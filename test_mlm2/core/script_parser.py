import logging
import re
from typing import List, Optional, Tuple


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
                "Verror_Log :=",
                "Oerror_Log :=",
                "result :=",
                "v_Msg :=",
                "o_Error_Msg :=",
                "o_Ora_Msg :=",
                "Ut.Raise_Err",
                "Omessage :=",
                "oMessage :=",
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

def clean_quotes(text: str) -> str:
    return (
        text
        .replace("''", '')
        .replace("' ", ' ')
        .replace(" '", ' ')
        .replace("(", '')
        .replace(")", '')
        .replace("'", '')
        .replace("  ", ' ')
        .replace("{", '')
        .replace("}", '')
        .replace(':', '')
        .strip()
    )

def extract_error_message(stmt: str) -> Optional[str]:
    """Extract and format error message with parameters, preserving $ in text"""
    try:
        stmt = stmt.replace('\n', ' ').replace('\r', ' ')
        stmt = re.sub(r'\s+', ' ', stmt)

        # Skip simple numeric assignments
        if re.search(r":=\s*'\d+'\s*;", stmt, re.IGNORECASE):
            return None

        # Handle Em.Raise_Error and similar functions
        if 'Em.Raise_Error' in stmt:
            match = re.search(r"Em\.Raise_Error\([^,]+, (.+)\);", stmt)
            if match:
                stmt = match.group(1)

        # Remove variable assignments and keep the message part
        stmt = re.sub(
            r'^(Raise_Application_Error|return|vMessage|result|Omessage|o_Error_Msg|v_Msg|Oerror_Log|Verror_Log|o_Ora_Msg)\s*:=\s*',
            '',
            stmt,
            flags=re.IGNORECASE
        )
        stmt = re.sub(r'return\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'raise\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)

        parts = re.split(r'\|\s*\|', stmt)
        message_parts = []
        param_counter = 1

        for part in parts:
            part = part.strip()
            if any(p in part for p in ('to_char', 'replace')):
                # Handle as parameter
                message_parts.append(format_parameter(param_counter))
                param_counter += 1
                continue

            # Extract quoted text and preserve $ placeholders
            quoted = re.findall(r"'((?:[^']|'[^'])*')", part)
            if quoted:
                cleaned = ' '.join([clean_quotes(q) for q in quoted])
                if cleaned:
                    message_parts.append(cleaned)
            else:
                # Handle non-quoted parts only if they are not literals
                clean_part = clean_quotes(part)
                if clean_part and not clean_part.isspace():
                    # Check if it's a numeric or known keyword
                        # Preserve existing $ placeholders
                    if re.match(r'^\$\d+', clean_part):
                        message_parts.append(clean_part)
                    else:
                        message_parts.append(format_parameter(param_counter))
                        param_counter += 1

        result = ' '.join(message_parts)
        result = re.sub(r'\s+', ' ', result).strip()

        # Skip numeric-only messages
        if re.fullmatch(r'\d+', result):
            return None

        return result if result else None

    except Exception as e:
        logging.error(f"Error extracting message: {str(e)}")
        return None
