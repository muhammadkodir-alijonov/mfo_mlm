
import os
import shutil
import uuid
import asyncio
from fastapi import FastAPI, File, UploadFile, WebSocket, BackgroundTasks, HTTPException
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import logging
from typing import Dict, List, Optional
import time

# Import your existing processing functions
from core.mlm_converter_main import process_single_file as convert_to_mlm
from core.script_generator_main import process_single_file as make_script_for_mlm

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Create directories if they don't exist
os.makedirs("uploads", exist_ok=True)
os.makedirs("outputs", exist_ok=True)
os.makedirs("static", exist_ok=True)
os.makedirs("templates", exist_ok=True)

app = FastAPI(title="PCK File Processor")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static files directory
app.mount("/static", StaticFiles(directory="static"), name="static")

# Setup templates
templates = Jinja2Templates(directory="static/index.html")

# Store active connections and processing status
active_connections: Dict[str, WebSocket] = {}
processing_status: Dict[str, Dict] = {}


class ProcessRequest(BaseModel):
    file_id: str
    action: str  # "convert" or "script"


@app.get("/", response_class=HTMLResponse)
async def get_index():
    return FileResponse("static/index.html")


@app.post("/upload/")
async def upload_file(file: UploadFile = File(...)):
    # Validate file extension
    if not file.filename.endswith('.pck'):
        raise HTTPException(status_code=400, detail="Only .pck files are allowed")

    # Generate unique ID for this upload
    file_id = str(uuid.uuid4())
    file_location = f"uploads/{file_id}_{file.filename}"

    # Save the file
    with open(file_location, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    logger.info(f"File uploaded: {file.filename} as {file_location}")

    return {"file_id": file_id, "filename": file.filename, "location": file_location}


@app.post("/process/")
async def process_file(request: ProcessRequest, background_tasks: BackgroundTasks):
    file_id = request.file_id
    action = request.action

    # Find the uploaded file
    uploaded_files = [f for f in os.listdir("uploads") if f.startswith(f"{file_id}_")]
    if not uploaded_files:
        raise HTTPException(status_code=404, detail="Uploaded file not found")

    file_path = f"uploads/{uploaded_files[0]}"
    original_filename = uploaded_files[0].replace(f"{file_id}_", "")

    # Initialize processing status
    processing_status[file_id] = {
        "status": "processing",
        "progress": 0,
        "message": f"Starting {action} operation...",
        "output_file": None
    }

    # Process the file based on the selected action
    if action == "convert":
        # Start processing in background
        background_tasks.add_task(
            process_convert_task,
            file_id,
            file_path,
            original_filename
        )
    elif action == "script":
        # Start processing in background
        background_tasks.add_task(
            process_script_task,
            file_id,
            file_path,
            original_filename
        )
    else:
        raise HTTPException(status_code=400, detail="Invalid action")

    return {"file_id": file_id, "status": "processing"}


async def process_convert_task(file_id: str, file_path: str, original_filename: str):
    try:
        # Update status
        processing_status[file_id]["message"] = "Converting file to MLM..."

        # Simulate progress updates
        for i in range(1, 10):
            processing_status[file_id]["progress"] = i * 10
            await asyncio.sleep(0.5)  # Simulate processing time

            # Send progress update to WebSocket if connected
            if file_id in active_connections:
                await active_connections[file_id].send_json(processing_status[file_id])

        # Actual processing
        output_dir = "outputs"
        output_path = convert_to_mlm(file_path, output_dir)

        if output_path:
            base_name = os.path.splitext(original_filename)[0]
            output_filename = f"{base_name}_converted.pck"
            final_path = f"outputs/{file_id}_{output_filename}"

            # Rename the output file to include the file_id
            shutil.move(output_path, final_path)

            processing_status[file_id].update({
                "status": "completed",
                "progress": 100,
                "message": "Conversion completed successfully!",
                "output_file": final_path
            })
        else:
            processing_status[file_id].update({
                "status": "error",
                "progress": 100,
                "message": "Conversion failed. No errors found or processing error occurred."
            })

    except Exception as e:
        logger.error(f"Error in convert task: {str(e)}")
        processing_status[file_id].update({
            "status": "error",
            "progress": 100,
            "message": f"Error: {str(e)}"
        })

    # Send final status update
    if file_id in active_connections:
        await active_connections[file_id].send_json(processing_status[file_id])


async def process_script_task(file_id: str, file_path: str, original_filename: str):
    try:
        # Update status
        processing_status[file_id]["message"] = "Generating MLM script..."

        # Simulate progress updates
        for i in range(1, 10):
            processing_status[file_id]["progress"] = i * 10
            await asyncio.sleep(0.5)  # Simulate processing time

            # Send progress update to WebSocket if connected
            if file_id in active_connections:
                await active_connections[file_id].send_json(processing_status[file_id])

        # Actual processing
        output_dir = "outputs"
        output_path = make_script_for_mlm(file_path, output_dir)

        if output_path:
            base_name = os.path.splitext(original_filename)[0]
            output_filename = f"{base_name}_mlm.sql"
            final_path = f"outputs/{file_id}_{output_filename}"

            # Rename the output file to include the file_id
            shutil.move(output_path, final_path)

            processing_status[file_id].update({
                "status": "completed",
                "progress": 100,
                "message": "Script generation completed successfully!",
                "output_file": final_path
            })
        else:
            processing_status[file_id].update({
                "status": "error",
                "progress": 100,
                "message": "Script generation failed. No errors found or processing error occurred."
            })

    except Exception as e:
        logger.error(f"Error in script task: {str(e)}")
        processing_status[file_id].update({
            "status": "error",
            "progress": 100,
            "message": f"Error: {str(e)}"
        })

    # Send final status update
    if file_id in active_connections:
        await active_connections[file_id].send_json(processing_status[file_id])


@app.get("/status/{file_id}")
async def get_status(file_id: str):
    if file_id not in processing_status:
        raise HTTPException(status_code=404, detail="File ID not found")
    return processing_status[file_id]


@app.get("/download/{file_id}")
async def download_file(file_id: str, background_tasks: BackgroundTasks):
    if file_id not in processing_status:
        raise HTTPException(status_code=404, detail="File ID not found")

    status = processing_status[file_id]
    if status["status"] != "completed" or not status["output_file"]:
        raise HTTPException(status_code=400, detail="File processing not completed or no output file available")

    output_file = status["output_file"]
    if not os.path.exists(output_file):
        raise HTTPException(status_code=404, detail="Output file not found")

    # Schedule cleanup after download
    background_tasks.add_task(cleanup_files, file_id)

    return FileResponse(
        path=output_file,
        filename=os.path.basename(output_file).replace(f"{file_id}_", ""),
        media_type="application/octet-stream"
    )


async def cleanup_files(file_id: str):
    """Clean up uploaded and output files after download"""
    try:
        # Wait a bit to ensure download has started
        await asyncio.sleep(5)

        # Clean up uploaded file
        uploaded_files = [f for f in os.listdir("uploads") if f.startswith(f"{file_id}_")]
        for file in uploaded_files:
            file_path = f"uploads/{file}"
            if os.path.exists(file_path):
                os.remove(file_path)
                logger.info(f"Removed uploaded file: {file_path}")

        # Clean up output file
        output_files = [f for f in os.listdir("outputs") if f.startswith(f"{file_id}_")]
        for file in output_files:
            file_path = f"outputs/{file}"
            if os.path.exists(file_path):
                os.remove(file_path)
                logger.info(f"Removed output file: {file_path}")

        # Clean up status
        if file_id in processing_status:
            del processing_status[file_id]

    except Exception as e:
        logger.error(f"Error during cleanup: {str(e)}")


@app.websocket("/ws/{file_id}")
async def websocket_endpoint(websocket: WebSocket, file_id: str):
    await websocket.accept()
    active_connections[file_id] = websocket

    try:
        # Send initial status if available
        if file_id in processing_status:
            await websocket.send_json(processing_status[file_id])

        # Keep connection open and handle disconnection
        while True:
            await websocket.receive_text()
    except Exception as e:
        logger.error(f"WebSocket error: {str(e)}")
    finally:
        if file_id in active_connections:
            del active_connections[file_id]