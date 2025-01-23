import re
from typing import List, Tuple


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
            .replace("  ", ' ')
            .replace("}", '')
            .replace('"', '')
            .replace(':', '')
            .strip())


def format_parameter(param_num: int) -> str:
    """Format parameter placeholder consistently"""
    return f"${param_num}"


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
    """Advanced error statement modification with comprehensive handling"""
    # Expanded error patterns
    error_patterns = [
        r'Raise_Application_Error\s*\(-20000,[^;]+;',
        r'Ut\.Raise_Err\s*\([^;]+;',
        r'Em\.Raise_Error(?:_If)?\s*\([^;]+;',
        r'\w+message\s*:=\s*[^;]+;',
        r'result\s*:=\s*[^;]+;',
        r'o_Error_Msg\s*:=\s*[^;]+;'
    ]

    modified_content = content
    matches = list(re.finditer('|'.join(error_patterns), content, re.MULTILINE | re.DOTALL | re.IGNORECASE))

    for match in sorted(matches, key=lambda x: x.start(), reverse=True):
        stmt = match.group(0)

        # Extract parameters and generate MLM replacement
        params = parse_error_params(stmt)

        if 'Raise_Application_Error' in stmt or 'Ut.Raise_Err' in stmt:
            replacement = generate_mlm_raise_error(message_name, params)
        else:
            replacement = generate_mlm_replacement(message_name, stmt, params)

        modified_content = (
                modified_content[:match.start()] +
                replacement +
                modified_content[match.end():]
        )

    return modified_content, 0, len(modified_content)


def parse_error_params(stmt: str) -> List[str]:
    """Comprehensive parameter extraction with advanced parsing"""
    # Expanded exclusion list and more flexible extraction
    exclusion_keywords = [
        'raise_application_error', 'o_error_msg', 'result', 'raise',
        'vmessage', 'omessage', '-20000', 'sqlerrm', 'ut.ccrlf'
    ]

    # Handle function calls and complex expressions
    function_matches = re.finditer(
        r'\b(to_char|to_number|nvl|trim|chr)\([^)]+\)',
        stmt,
        re.IGNORECASE
    )

    params = [
        match.group(0).strip()
        for match in function_matches
        if not any(keyword in match.group(0).lower() for keyword in exclusion_keywords)
    ]

    # Remove string literals and processed function calls
    clean_stmt = re.sub(r"'[^']*'", "", stmt)
    clean_stmt = re.sub(r'\b(to_char|to_number|nvl|trim|chr)\([^)]+\)', '', clean_stmt)

    # More aggressive parameter extraction
    additional_params = [
        part.split(':=')[-1].strip().rstrip('!,.')
        for part in re.split(r'\s*\|\s*|\s*\+\s*|\s*&\s*', clean_stmt)
        if part.strip() and not any(keyword in part.lower() for keyword in exclusion_keywords)
    ]

    params.extend(additional_params)

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

    # Format the parameters into the required structure without trailing comma
    param_array = f"array_varchar2({', '.join(cleaned_params)})"  # Removed potential trailing comma

    # Generate the full MLM call
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

    # Clean up any trailing commas before closing parentheses
    result = ''.join(final_result)
    result = re.sub(r',\s*\)', ')', result)  # Remove any trailing comma before closing parenthesis

    return result