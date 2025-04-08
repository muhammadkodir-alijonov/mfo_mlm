# import os
# import logging
# from config import INPUT_DIR, OUTPUT_DIR
# from file_utils import read_file_with_encodings
# from translator import translate_message
# from template_generator import generate_message_name
# from script_parser import process_pck_file
# from mlm_parser import process_pck_content
# import time
#
#
# def main():
#     """Main function to convert PCK files to MLM format."""
#     start = time.time()
#     os.makedirs(OUTPUT_DIR, exist_ok=True)
#
#     files_in_directory = os.listdir(INPUT_DIR)
#     logging.info(f"Files in the input directory: {files_in_directory}")
#
#     pck_files = [f for f in files_in_directory if f.endswith('.pck')]
#     if not pck_files:
#         logging.info("No .pck files found in the input directory.")
#         return
#
#     for file_name in pck_files:
#         input_path = os.path.join(INPUT_DIR, file_name)
#         temp_file_path = os.path.join(OUTPUT_DIR, f"temp_{file_name}")
#
#         logging.info(f"Processing file for MLM conversion: {input_path}")
#
#         content = read_file_with_encodings(input_path)
#         if content is None:
#             logging.error(f"Could not read file {file_name} with any supported encoding")
#             continue
#
#         errors = process_pck_file(content)
#         if not errors:
#             logging.warning(f"No errors found in file: {file_name}")
#             continue
#
#         try:
#             # Create message mappings
#             message_mappings = {}
#             for error_msg, _ in errors:
#                 translations = translate_message(error_msg)
#                 message_name = generate_message_name(translations['ENG'])
#                 message_mappings[error_msg] = message_name
#
#             # Convert to MLM format
#             modified_content = process_pck_content(content, message_mappings)
#
#             # Write to temporary file first
#             with open(temp_file_path, 'w', encoding='utf-8') as temp_file:
#                 temp_file.write(modified_content)
#
#             # Replace original file
#             os.replace(temp_file_path, input_path)
#
#             logging.info(f"Successfully converted {file_name} to MLM format")
#
#             end = time.time()
#             print(f"MLM conversion completed in {end - start:.2f} seconds")
#
#         except Exception as e:
#             logging.error(f"Failed to convert {file_name} to MLM format: {str(e)}")
#             if os.path.exists(temp_file_path):
#                 os.remove(temp_file_path)
#
#
# if __name__ == "__main__":
#     main()

import os
import logging
from core.config import INPUT_DIR, OUTPUT_DIR
from core.file_utils import read_file_with_encodings
from core.translator import translate_message
from core.template_generator import generate_message_name
from core.script_parser import process_pck_file
from core.mlm_parser import process_pck_content
import time


def process_single_file(input_path: str, output_dir: str) -> str:
    """Process single file and return output path"""
    start = time.time()
    file_name = os.path.basename(input_path)
    output_path = os.path.join(output_dir, file_name)

    logging.info(f"Processing file for MLM conversion: {input_path}")

    content = read_file_with_encodings(input_path)
    if content is None:
        logging.error(f"Could not read file {file_name}")
        return None

    errors = process_pck_file(content)
    if not errors:
        logging.warning(f"No errors found in file: {file_name}")
        return None

    try:
        message_mappings = {}
        for error_msg, _ in errors:
            translations = translate_message(error_msg)
            message_name = generate_message_name(translations['ENG'])
            message_mappings[error_msg] = message_name

        modified_content = process_pck_content(content, message_mappings)

        with open(output_path, 'w', encoding='utf-8') as output_file:
            output_file.write(modified_content)

        logging.info(f"Successfully converted file: {output_path}")
        return output_path

    except Exception as e:
        logging.error(f"Conversion failed: {str(e)}")
        return None
    finally:
        end = time.time()
        print(f"Processing time: {end - start:.2f}s")


def main():
    """CLI uchun asosiy funksiya"""
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    for file_name in os.listdir(INPUT_DIR):
        if file_name.endswith('.pck'):
            input_path = os.path.join(INPUT_DIR, file_name)
            process_single_file(input_path, INPUT_DIR)  # Original faylni overwrite qilish


if __name__ == "__main__":
    main()