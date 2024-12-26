# quote_cleaner.py
import logging
import re
from typing import List, Optional, Tuple


def clean_quotes(text: str) -> str:
    """Remove unnecessary quotes and normalize spacing"""
    return (text.replace('"', '')
               .replace("''", '')
               .replace("' ", '')
               .replace(" '", '')
               .replace("(",'')
               .replace(")",'')
               .replace("'",'')
               .strip())

# parameter_formatter.py
def format_parameter(param_num: int) -> str:
    """Format parameter placeholder consistently"""
    return f"${param_num}"



def extract_error_message(raise_stmt: str) -> Optional[str]:
    """Extract and format error message with parameters"""
    try:
        concat_parts = raise_stmt.split('||')
        
        if len(concat_parts) <= 1:
            match = re.search(r"'(.*?)'", raise_stmt)
            return clean_quotes(match.group(1)) if match else None
            
        message_parts = []
        param_counter = 1
        
        for i, part in enumerate(concat_parts):
            part = part.strip()
            if i == 0:
                match = re.search(r"'(.*?)$", part)
                if match:
                    message_parts.append(clean_quotes(match.group(1)))
            elif i == len(concat_parts) - 1:
                match = re.search(r"^(.*?)'", part)
                if match:
                    message_parts.append(clean_quotes(match.group(1)))
            else:
                if not (part.startswith("'") or part.endswith("'")):
                    message_parts.append(format_parameter(param_counter))
                    param_counter += 1
                else:
                    match = re.search(r"'(.*?)'", part)
                    if match:
                        message_parts.append(clean_quotes(match.group(1)))
        
        return ' '.join(part for part in message_parts if part)
        
    except Exception as e:
        logging.error(f"Error extracting message: {str(e)}")
        return None


def process_pck_file(content: str) -> List[Tuple[str, int]]:
    """Process PCK file and extract error messages with line numbers"""
    errors = []
    try:
        lines = content.split('\n')
        current_stmt = ""
        start_line = 0
        
        for line_num, line in enumerate(lines, 1):
            stripped = line.strip()
            if not stripped:
                continue
                
            current_stmt += " " + stripped
            
            if start_line == 0:
                start_line = line_num
                
            if ";" in line:
                if "Raise_Application_Error" in current_stmt:
                    message = extract_error_message(current_stmt)
                    if message:
                        errors.append((message, start_line))
                
                current_stmt = ""
                start_line = 0
                
    except Exception as e:
        logging.error(f"Error processing file: {str(e)}")
        
    return errors
