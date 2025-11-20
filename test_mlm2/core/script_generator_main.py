import os
import logging
from core.config import INPUT_DIR, OUTPUT_DIR
from core.file_utils import read_file_with_encodings
from core.translator import translate_message
from core.template_generator import format_error_template
from core.script_parser import process_pck_file
import time


def process_single_file(input_path: str, output_dir: str, module_code: str) -> str:
    """Process single file and return output path"""
    start = time.time()
    file_name = os.path.basename(input_path)
    base_name = os.path.splitext(file_name)[0]
    output_filename = f"{base_name}_mlm.sql"
    output_path = os.path.join(output_dir, output_filename)

    logging.info(f"Processing file for SQL template generation: {input_path}")

    content = read_file_with_encodings(input_path)
    if content is None:
        logging.error(f"Could not read file {file_name}")
        return None

    errors = process_pck_file(content)
    if not errors:
        logging.warning(f"No errors found in file: {file_name}")
        return None

    try:
        with open(output_path, 'w', encoding='utf-8') as out_file:
            for error_msg, line_num in errors:
                translations = translate_message(error_msg)
                template = format_error_template(error_msg, translations, file_name, line_num,module_code)
                out_file.write(template + "\n\n")

        logging.info(f"Successfully generated SQL template: {output_path}")
        return output_path

    except Exception as e:
        logging.error(f"Failed to generate SQL template: {str(e)}")
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
            process_single_file(input_path, OUTPUT_DIR)


if __name__ == "__main__":
    main()