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
    """Extract and format error message with parameters - improved version"""
    try:
        # Clean up the statement first
        stmt = stmt.replace('\n', ' ').replace('\r', ' ')
        stmt = re.sub(r'\s+', ' ', stmt)

        # Remove common prefixes and suffixes
        stmt = re.sub(r'^(return|vMessage|result|Omessage|o_Error_Msg)\s*:=\s*', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'return\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'raise\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)

        # Special handling for Raise_Application_Error with to_char
        if 'Raise_Application_Error' in stmt and 'to_char' in stmt:
            # Extract the message parts and parameters
            parts = re.split(r'\|\s*\|', stmt)
            message_parts = []
            param_counter = 1

            for part in parts:
                part = part.strip()
                # Handle to_char function specially
                if 'to_char' in part:
                    message_parts.append(format_parameter(param_counter))
                    param_counter += 1
                    continue

                # Extract quoted text or parameter references
                quote_match = re.search(r"'([^']+)'", part)
                if quote_match:
                    cleaned_text = clean_quotes(quote_match.group(1))
                    if cleaned_text:
                        message_parts.append(cleaned_text)
                elif not part.startswith("'") and not part.endswith("'"):
                    if not any(keyword in part.lower() for keyword in
                               ['raise_application_error', '-20000']):
                        message_parts.append(format_parameter(param_counter))
                        param_counter += 1

            result = ' '.join(message_parts)
            return result if result else None

        # Handle regular concatenated messages
        parts = re.split(r'\|\s*\|', stmt)
        message_parts = []
        param_counter = 1

        for part in parts:
            part = part.strip()
            # Handle Ut.Ccrlf specially
            if 'Ut.Ccrlf' in part:
                message_parts.append('\n')
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
                               ['raise_application_error', 'result', 'raise', 'vmessage', 'Omessage','o_error_msg']):
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
                # Check if it ends with a semicolon and is a valid error statement
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


def modify_error_statement(content: str, message_name: str) -> Tuple[str, int, int]:
    """Modify error statement with improved pattern matching"""
    # Enhanced patterns to handle multi-line statements
    raise_patterns = [
        r"Raise_Application_Error\s*\([^;]+?;",  # Non-greedy match
        r"Em.Raise_Error_If\s*\([^;]+?;",  # Non-greedy match
        r"Em.Raise_Error\s*\([^;]+?;",  # Non-greedy match
        r"Em.Raise_Exception\s*\([^;]+?;",  # Non-greedy match
        r"Ut.Raise_Err\s*\([^;]+?;"  # Non-greedy match
    ]

    message_patterns = [
        r"[Vv]message\s*:=\s*[^;]+?;",
        r"result\s*:=\s*[^;]+?;",
        r"[Oo]_[Ee]rror_[Ms]sg\s*:=\s*[^;]+?;",
        r"[Oo]message\s*:=\s*[^;]+?;"
    ]

    # First check for raise patterns
    for pattern in raise_patterns:
        match = re.search(pattern, content, re.IGNORECASE | re.MULTILINE | re.DOTALL)
        if match:
            stmt = match.group(0)
            params = parse_error_params(stmt)
            replacement = generate_mlm_raise_error(message_name, params)
            return content[:match.start()] + replacement + content[match.end():], match.start(), match.end()

    # Then check for message patterns
    for pattern in message_patterns:
        match = re.search(pattern, content, re.IGNORECASE | re.MULTILINE | re.DOTALL)
        if match:
            stmt = match.group(0)
            params = parse_error_params(stmt)
            replacement = generate_mlm_replacement(message_name, stmt, params)
            return content[:match.start()] + replacement + content[match.end():], match.start(), match.end()

    return content, -1, -1


def parse_error_params(stmt: str) -> List[str]:
    """Extract parameters from concatenated error message with improved handling"""
    params = []

    # Handle to_char function calls
    to_char_matches = re.finditer(r'to_char\([^)]+\)', stmt)
    for match in to_char_matches:
        # Clean up the to_char parameter
        param = match.group(0).strip()
        if param and not param.isspace():
            params.append(param)

    # Remove string literals and process remaining parts
    stmt = re.sub(r"'[^']*'", "", stmt)
    stmt = re.sub(r'to_char\([^)]+\)', '', stmt)  # Remove processed to_char calls

    # Split by concatenation operator
    parts = re.split(r'\|\s*\|', stmt)

    for part in parts:
        part = part.strip()
        # Skip if empty or contains specific keywords
        if not part or any(keyword in part.lower() for keyword in [
            'raise_application_error',
            'o_error_msg',
            'result',
            'raise',
            'vmessage',
            'omessage',
            '-20000',
            'lncontc',
            'lnprdup',
            'lnblank',
            'lnproduct',
            'lno',
            'ln'
        ]):
            continue

        # Clean up the parameter
        clean_part = part.split(':=')[-1].strip().rstrip('!')
        if clean_part and not clean_part.isspace():
            params.append(clean_part)

    # Remove duplicates while preserving order
    seen = set()
    return [x for x in params if not (x in seen or seen.add(x))]


def generate_mlm_replacement(message_name: str, original_stmt: str, params: List[str] = None) -> str:
    """Generate MLM message call with proper parameter handling"""
    # Extract variable name from the statement
    var_match = re.match(r'(\w+)\s*:=', original_stmt, re.IGNORECASE)
    variable_name = var_match.group(1) if var_match else "Omessage"

    # If no parameters are provided, generate a simple message
    if not params:
        return f"{variable_name} := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => '{message_name}');"

    # Clean up parameters and remove any assignment operators
    cleaned_params = []
    for param in params:
        param = param.strip()
        # Remove assignment operator if present
        if ':=' in param:
            param = param.split(':=')[-1].strip()
        # Remove any trailing delimiters or whitespace
        param = re.sub(r'[,\s;]+$', '', param)
        # Only add non-empty parameters
        if param and not param.isspace():
            cleaned_params.append(param)

    # If cleaned_params is empty after filtering, exclude i_Params entirely
    if not cleaned_params:
        return f"{variable_name} := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => '{message_name}');"

    # Join parameters with clean formatting
    param_array = f"array_varchar2({', '.join(cleaned_params)})"

    return f"{variable_name} := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => '{message_name}', i_Params => {param_array});"

def generate_mlm_raise_error(message_name: str, params: List[str] = None) -> str:
    """Generate MLM Raise_Error call with proper parameter handling"""
    if not params:
        return f"mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => '{message_name}');"

    # Clean up parameters and remove any assignment operators
    cleaned_params = []
    for param in params:
        param = param.strip().rstrip(';')
        if ':=' in param:
            param = param.split(':=')[-1].strip()
        if param and not param.isspace():
            cleaned_params.append(param)

    # Format the parameters into the required structure
    param_array = f"array_varchar2({', '.join(cleaned_params)})"
    result = f"mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => '{message_name}', i_Params => {param_array});"

    # Stack to track parentheses
    stack = []
    final_result = []

    # Iterate through the characters of the result to check parentheses balance
    for char in result:
        if char == '(':
            stack.append(char)
            final_result.append(char)
        elif char == ')':
            if stack:
                stack.pop()
                final_result.append(char)
            else:
                # Skip unmatched closing parenthesis
                continue
        else:
            final_result.append(char)

    # If the stack is not empty, remove unmatched opening parentheses
    if stack:
        final_result = ''.join(final_result).rstrip('(').rstrip(')')
    else:
        final_result = ''.join(final_result)

    return final_result