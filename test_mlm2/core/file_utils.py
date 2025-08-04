import logging
from typing import List, Optional
from core.config import ENCODINGS

def read_file_with_encodings(file_path: str, encodings: List[str] = ENCODINGS) -> Optional[str]:
    """
    Attempt to read a file with multiple encodings.
    Returns the file content if successful, None if all encodings fail.
    """
    last_error = None
    
    for encoding in encodings:
        try:
            with open(file_path, 'r', encoding=encoding) as file:
                content = file.read()
                logging.info(f"Successfully read file with encoding: {encoding}")
                return content
        except UnicodeDecodeError as e:
            last_error = e
            logging.warning(f"Failed to read {file_path} with encoding {encoding}")
            continue
        except Exception as e:
            logging.error(f"Unexpected error reading file: {str(e)}")
            raise

    logging.error(f"Failed to read file with any encoding. Last error: {str(last_error)}")
    return None