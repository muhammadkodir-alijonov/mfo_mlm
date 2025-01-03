import logging
import re
from typing import List, Optional, Tuple


def clean_quotes(text: str) -> str:
    """Remove unnecessary quotes and normalize spacing"""
    return (text.replace('"', '')
            .replace("''", '')
            .replace("' ", '')
            .replace(" '", '')
            .replace("(", '')
            .replace(")", '')
            .replace("'", '')
            .replace("{", '')
            .replace("}", '')
            .replace('"', '')
            .replace(':', '')
            .strip())


def format_parameter(param_num: int) -> str:
    """Format parameter placeholder consistently"""
    return f"${param_num}"


def extract_error_message(stmt: str) -> Optional[str]:
    """Extract and format error message with parameters"""
    try:
        # Clean up the statement first
        stmt = stmt.replace('\n', ' ').replace('\r', ' ')
        stmt = re.sub(r'\s+', ' ', stmt)

        # Remove common prefixes and suffixes
        stmt = re.sub(r'^(vMessage|result)\s*:=\s*', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'return\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'raise\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)

        # Handle CASE WHEN structure
        if 'case' in stmt.lower() and 'when' in stmt.lower():
            pattern = r"when\s+'([^']+)'\s+then\s+'([^']+)'"
            matches = re.finditer(pattern, stmt, re.IGNORECASE)
            cases = {}
            for match in matches:
                cases[match.group(1)] = match.group(2)

            else_pattern = r"else\s+'([^']+)'"
            else_match = re.search(else_pattern, stmt, re.IGNORECASE)
            if else_match:
                cases['else'] = else_match.group(1)
            return str(cases)

        # Split by concatenation operator
        parts = re.split(r'\|\s*\|', stmt)
        message_parts = []
        param_counter = 1

        for part in parts:
            part = part.strip()
            quote_match = re.search(r"'([^']+)'", part)
            if quote_match:
                cleaned_text = clean_quotes(quote_match.group(1))
                if cleaned_text:
                    message_parts.append(cleaned_text)
            # Handle parameters
            elif not any(keyword in part.lower() for keyword in
                         ['raise_application_error', 'result', 'raise','vmessage']):
                clean_part = clean_quotes(part)
                if clean_part and not clean_part.isspace():
                    message_parts.append(format_parameter(param_counter))
                    param_counter += 1

        # Join all parts and clean up spaces
        result = ' '.join(part for part in message_parts if part)
        result = re.sub(r'\s+', ' ', result).strip()
        return result if result else None

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
        in_error_block = False

        for line_num, line in enumerate(lines, 1):
            stripped = line.strip()
            if not stripped:
                continue

            # Start collecting when we see an error pattern
            if any(pattern in stripped for pattern in [
                "Raise_Application_Error",
                "vMessage :=",
                "result :=",
                "Ut.Raise_Err"
            ]):
                in_error_block = True
                start_line = line_num if not start_line else start_line

            if in_error_block:
                current_stmt += " " + stripped

            # Process when we reach the end of statement
            if ";" in stripped and in_error_block:
                message = extract_error_message(current_stmt)
                if message:
                    errors.append((message, start_line))
                current_stmt = ""
                start_line = 0
                in_error_block = False

    except Exception as e:
        logging.error(f"Error processing file: {str(e)}")

    return errors