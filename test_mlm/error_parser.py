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
                         ['raise_application_error', 'result', 'raise','vmessage','Omessage','oMessage']):
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
                "Vmessage :=",
                "result :=",
                "Ut.Raise_Err",
                "Omessage :=",
                "oMessage :="
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

def parse_error_params(stmt: str) -> List[str]:
    """Extract parameters from concatenated error message"""
    params = []
    parts = re.split(r'\|\s*\|', stmt)

    for part in parts:
        part = part.strip()
        # Skip string literals
        if not re.search(r"'[^']+'", part):
            # Clean and check if it's a parameter
            clean_part = part.strip().replace('(', '').replace(')', '')
            if clean_part and not any(keyword in clean_part.lower() for keyword in
                                      ['raise_application_error', 'result', 'raise', 'vmessage', 'omessage']):
                params.append(clean_part)

    return params


def generate_mlm_replacement(message_name: str, original_stmt: str, params: List[str] = None) -> str:
    """
    Generate MLM message call replacement while preserving the original variable name.

    Args:
        message_name: The generated message name for MLM
        original_stmt: The original error statement to extract variable name from
        params: List of parameters if any
    """
    # Extract the variable name from the original statement
    var_match = re.match(r'(\w+)\s*:=', original_stmt)
    if not var_match:
        # Default to Omessage if no match found
        variable_name = "Omessage"
    else:
        variable_name = var_match.group(1)

    if not params:
        return f"{variable_name} := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => '{message_name}')"

    param_array = f"array_varchar({', '.join(params)})"
    return f"{variable_name} := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => '{message_name}', i_Params => {param_array})"

def process_pck_content(content: str, message_mappings: dict) -> str:
    """
    Process PCK file content and replace error messages with MLM calls.
    message_mappings: dict mapping original error messages to their message_names
    """
    modified_content = content
    offset = 0

    for original_msg, message_name in message_mappings.items():
        # Find and replace each error message
        temp_content = modified_content[offset:]
        new_content, start, end = modify_error_statement(temp_content, message_name)

        if start != -1:
            modified_content = modified_content[:offset] + new_content
            offset += end

    return modified_content


def update_pck_file(file_path: str, message_mappings: dict) -> bool:
    """
    Update PCK file with MLM message calls.
    Returns True if successful, False otherwise.
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()

        modified_content = process_pck_content(content, message_mappings)

        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(modified_content)

        return True
    except Exception as e:
        print(f"Error updating PCK file: {str(e)}")
        return False


def generate_mlm_raise_error(message_name: str, params: List[str] = None) -> str:
    """Generate MLM Raise_Error call replacement"""
    if not params:
        return f"mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => '{message_name}')"

    param_array = f"array_varchar({', '.join(params)})"
    return f"mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => '{message_name}', i_Params => {param_array})"


def modify_error_statement(content: str, message_name: str) -> Tuple[str, int, int]:
    """
    Modify error statement in the content.
    Returns: (modified_content, start_position, end_position)
    """
    # Define patterns for both raise errors and message assignments
    raise_patterns = [
        r"Raise_Application_Error\s*\([^;]+;",
        r"Ut\.Raise_Err\s*\([^;]+;"
    ]

    message_patterns = [
        r"Vmessage\s*:=\s*[^;]+;",
        r"result\s*:=\s*[^;]+;",
        r"Omessage\s*:=\s*[^;]+;"
    ]

    # First check for raise patterns
    for pattern in raise_patterns:
        match = re.search(pattern, content, re.IGNORECASE | re.MULTILINE)
        if match:
            stmt = match.group(0)
            params = parse_error_params(stmt)
            replacement = generate_mlm_raise_error(message_name, params)
            return content[:match.start()] + replacement + content[match.end():], match.start(), match.end()

    # Then check for message patterns
    for pattern in message_patterns:
        match = re.search(pattern, content, re.IGNORECASE | re.MULTILINE)
        if match:
            stmt = match.group(0)
            params = parse_error_params(stmt)
            replacement = generate_mlm_replacement(message_name, stmt, params)
            return content[:match.start()] + replacement + content[match.end():], match.start(), match.end()

    return content, -1, -1