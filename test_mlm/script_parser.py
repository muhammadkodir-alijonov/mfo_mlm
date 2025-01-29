import logging
import re
from typing import List, Optional, Tuple


def clean_quotes(text: str) -> str:
    """Remove unnecessary quotes and normalize spacing"""
    return (
            text.replace('"', '')
            .replace("''", '')
            .replace("' ", '')
            .replace(" '", '')
            .replace("(", '')
            .replace(")", '')
            .replace("'", '')
            .replace("  ", ' ')
            .replace("{", '')
            .replace("}", '')
            .replace('"', '')
            .replace(':', '')
            .strip())


def format_parameter(param_num: int) -> str:
    """Format parameter placeholder consistently"""
    return f"${param_num}"


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
                "Vmessage :=",
                "result :=",
                "v_Msg :=",
                "o_Error_Msg :=",
                "Ut.Raise_Err",
                "Omessage :=",
                "oMessage :=",
                "Em.Raise_Error_If",
                "Em.Raise_Error",
                "Em.Raise_Exception"
            ]):
                in_error_block = True
                start_line = line_num if not start_line else start_line

            if in_error_block:
                current_stmt += " " + stripped

            # Process when we reach the end of statement
            if ";" in stripped and in_error_block:
                if current_stmt.endswith(";"):
                    message = extract_error_message(current_stmt)
                    if message:
                        errors.append((message, start_line))
                current_stmt = ""
                start_line = 0
                in_error_block = False

    except Exception as e:
        logging.error(f"Error processing file: {str(e)}")

    return errors


def extract_error_message(stmt: str) -> Optional[str]:
    """Extract and format error message with parameters"""
    try:
        stmt = stmt.replace('\n', ' ').replace('\r', ' ')
        stmt = re.sub(r'\s+', ' ', stmt)

        # Skip simple numeric assignments first (e.g. result := '1')
        if re.search(r":=\s*'\d+'\s*;", stmt, re.IGNORECASE):
            return None

        if 'Em.Raise_Error' in stmt:
            match = re.search(r"Em\.Raise_Error\([^,]+, (.+)\);", stmt)
            if match:
                stmt = match.group(1)
        if 'Em.Raise_Error_If' in stmt:
            match = re.search(r"Em\.Raise_Error_If\([^,]+, [^,]+, (.+)\);", stmt)
            if match:
                stmt = match.group(1)

        stmt = re.sub(r'^(return|vMessage|result|Omessage|o_Error_Msg|v_Msg)\s*:=\s*', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'return\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'raise\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)

        parts = re.split(r'\|\s*\|', stmt)
        message_parts = []
        param_counter = 1

        for part in parts:
            part = part.strip()
            if 'to_char' in part:
                message_parts.append(format_parameter(param_counter))
                param_counter += 1
                continue
            elif 'replace' in part:
                message_parts.append(format_parameter(param_counter))
                param_counter += 1
                continue

            quote_match = re.search(r"'([^']+)'", part)
            if quote_match:
                cleaned_text = clean_quotes(quote_match.group(1))
                if cleaned_text:
                    message_parts.append(cleaned_text)
            elif not part.startswith("'") and not part.endswith("'"):
                clean_part = clean_quotes(part)
                if clean_part and not clean_part.isspace():
                    if not any(keyword in clean_part.lower() for keyword in
                               ['raise_application_error', 'result', 'raise', 'vmessage', 'omessage', 'o_error_msg',
                                'v_Msg', '-20000']):
                        message_parts.append(format_parameter(param_counter))
                        param_counter += 1

        result = ' '.join(part for part in message_parts if part)
        result = re.sub(r'\s+', ' ', result).strip()

        # Final check for numeric-only messages
        if result and re.fullmatch(r'\d+', result):
            return None

        return result if result else None

    except Exception as e:
        logging.error(f"Error extracting message: {str(e)}")
        return None