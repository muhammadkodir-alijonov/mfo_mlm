import os
import logging
from core.config import INPUT_DIR, OUTPUT_DIR
from core.mlm_parser import process_pck_content
from core.script_parser import process_pck_file
from core.file_utils import read_file_with_encodings
from core.translator import translate_message
from template_generator import format_error_template
from template_generator import generate_message_name
import time


def main():
    start = time.time()
    """Main function to process .pck files and generate templates."""
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    files_in_directory = os.listdir(INPUT_DIR)
    logging.info(f"Files in the input directory: {files_in_directory}")

    pck_files = [f for f in files_in_directory if f.endswith('.pck')]
    if not pck_files:
        logging.info("No .pck files found in the input directory.")
        return

    for file_name in pck_files:
        input_path = os.path.join(INPUT_DIR, file_name)
        output_path = os.path.join(OUTPUT_DIR, f"{os.path.splitext(file_name)[0]}_mlm.sql")
        temp_file_path = os.path.join(OUTPUT_DIR, f"temp_{file_name}")

        logging.info(f"Processing file: {input_path}")

        content = read_file_with_encodings(input_path)
        if content is None:
            logging.error(f"Could not read file {file_name} with any supported encoding")
            continue

        errors = process_pck_file(content)
        if not errors:
            logging.warning(f"No errors found in file: {file_name}")
            continue

        try:
            # Create a dictionary to store message mappings
            message_mappings = {}

            # First pass: Generate MLM templates and collect message mappings
            with open(output_path, 'w', encoding='utf-8') as out_file:
                for error_msg, line_num in errors:
                    translations = translate_message(error_msg)
                    template = format_error_template(error_msg, translations, file_name, line_num)
                    message_name = generate_message_name(translations['ENG'])
                    message_mappings[error_msg] = message_name
                    out_file.write(template + "\n")

            # Second pass: Update the PCK file with MLM calls
            modified_content = process_pck_content(content, message_mappings)

            # Write to a temporary file first
            with open(temp_file_path, 'w', encoding='utf-8') as temp_file:
                temp_file.write(modified_content)

            # If successful, replace the original file
            os.replace(temp_file_path, input_path)

            logging.info(f"Successfully processed {file_name} and generated {output_path}")
            logging.info(f"Successfully updated original PCK file: {input_path}")

            end = time.time()
            print(end - start)

        except Exception as e:
            logging.error(f"Failed to process {file_name}: {str(e)}")
            # Clean up temporary file if it exists
            if os.path.exists(temp_file_path):
                os.remove(temp_file_path)


if __name__ == "__main__":
    main()