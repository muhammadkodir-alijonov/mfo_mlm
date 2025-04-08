import re
from typing import List
from core.script_parser import extract_error_message


def process_pck_content(content: str, message_mappings: dict) -> str:
    """
    Process PCK file content and replace error messages with MLM calls.
    message_mappings: dict mapping original error messages to their message_names
    """
    modified_content = content
    # Expanded error patterns
    error_patterns = [
        r'Raise_Application_Error\s*\(-20000,[^;]+;',
        r'Ut\.Raise_Err\s*\([^;]+;',
        r'Em.Raise_Error\s*\([^;]+;',
        r'\w+message\s*:=\s*[^;]+;',
        r'result\s*:=\s*[^;]+;',
        r'v_Msg\s*:=\s*[^;]+;',
        r'Verror_Log\s*:=\s*[^;]+;',
        r'Oerror_Log\s*:=\s*[^;]+;',
        r'o_Err_Msg\s*:=\s*[^;]+;',
        r'o_Error_Msg\s*:=\s*[^;]+;',
        r'o_Ora_Msg\s*:=\s*[^;]+;'
    ]

    # Find all error statements in the content
    matches = list(re.finditer('|'.join(error_patterns), modified_content, flags=re.IGNORECASE | re.DOTALL))

    # Process matches in reverse order to avoid offset issues
    for match in reversed(matches):
        stmt = match.group(0)
        # Extract the original message from the statement
        original_msg = extract_error_message(stmt)
        if original_msg in message_mappings:
            message_name = message_mappings[original_msg]
            # Determine replacement type
            if any(pattern in stmt for pattern in ['Raise_Application_Error', 'Ut.Raise_Err', 'Em.Raise_Error']):
                params = parse_error_params(stmt)
                replacement = generate_mlm_raise_error(message_name, params)
            else:
                params = parse_error_params(stmt)
                replacement = generate_mlm_replacement(message_name, stmt, params)
            # Replace the statement
            modified_content = (
                    modified_content[:match.start()] +
                    replacement +
                    modified_content[match.end():]
            )

    return modified_content

#
# def parse_error_params(stmt: str) -> List[str]:
#     """Comprehensive parameter extraction with advanced parsing"""
#     # Expanded exclusion list and more flexible extraction
#     exclusion_keywords = [
#         'raise_application_error', 'o_Err_Msg', 'o_Error_Msg','result', 'raise',
#         'vmessage', 'omessage', '-20000'
#     ]
#
#     # Handle function calls and complex expressions
#     function_matches = re.finditer(
#         r'\b(to_char|to_number|nvl|trim|chr)\([^)]+\)',
#         stmt,
#         re.IGNORECASE
#     )
#
#     params = [
#         match.group(0).strip()
#         for match in function_matches
#         if not any(keyword in match.group(0).lower() for keyword in exclusion_keywords)
#     ]
#
#     # Remove string literals and processed function calls
#     clean_stmt = re.sub(r"'[^']*'", "", stmt)
#     clean_stmt = re.sub(r'\b(to_char|to_number|nvl|trim|chr)\([^)]+\)', '', clean_stmt)
#
#     # More aggressive parameter extraction
#     additional_params = [
#         part.split(':=')[-1].strip().rstrip('!,.')
#         # Corrected split regex to handle '||'
#         for part in re.split(r'\s*\|\|\s*|\s*\+\s*|\s*&\s*', clean_stmt)
#         if part.strip() and not any(keyword in part.lower() for keyword in exclusion_keywords)
#     ]
#     params.extend(additional_params)
#
#     # Remove duplicates while preserving order
#     seen = set()
#     return [x for x in params if not (x in seen or seen.add(x))]
def parse_error_params(stmt: str) -> List[str]:
    """Extract parameters from the message part of error statements"""
    params = []
    message_part = ""

    # Extract message part based on statement type
    # Case 1: Raise_Application_Error pattern
    raise_app_match = re.search(
        r'Raise_Application_Error\s*\([^,]+,\s*(.*?)\s*\);',
        stmt,
        re.IGNORECASE | re.DOTALL
    )
    if raise_app_match:
        message_part = raise_app_match.group(1)
    else:
        # Case 2: Ut.Raise_Err pattern
        ut_raise_match = re.search(
            r'Ut\.Raise_Err\s*\(\s*(.*?)\s*\);',
            stmt,
            re.IGNORECASE | re.DOTALL
        )
        if ut_raise_match:
            message_part = ut_raise_match.group(1)
        else:
            # Case 3: Em.Raise_Error pattern
            em_raise_match = re.search(
                r'Em\.Raise_Error\s*\(\s*\'[^\']+\'\s*,\s*(.*?)\s*\);',
                stmt,
                re.IGNORECASE | re.DOTALL
            )
            if em_raise_match:
                message_part = em_raise_match.group(1)
            else:
                # Case 4: Assignment patterns (result := ...)
                assign_match = re.search(
                    r':=\s*(.*?)\s*;',
                    stmt,
                    re.IGNORECASE | re.DOTALL
                )
                if assign_match:
                    message_part = assign_match.group(1)

    if not message_part:
        return []

    # Split message part by concatenation operators (||, +)
    components = re.split(r'\s*\|\|\s*|\s*\+\s*', message_part)

    for comp in components:
        comp = comp.strip()
        if not comp:
            continue
        # Skip string literals and numeric values
        if re.match(r'^(\'.*\'|\d+)$', comp):
            continue
        # Handle variables and function calls (e.g., Ut.Ccrlf, vClaim_Apx.Card_Type)
        params.append(comp)

    # Remove duplicates while preserving order
    seen = set()
    return [p for p in params if not (p in seen or seen.add(p))]

def generate_mlm_replacement(message_name: str, original_stmt: str, params: List[str] = None) -> str:
    """Generate MLM message call with proper parameter handling"""
    # Extract variable name from the statement
    var_match = re.match(r'(\w+)\s*:=', original_stmt, re.IGNORECASE)
    variable_name = var_match.group(1) if var_match else "Omessage"

    # If no parameters are provided, generate a simple message
    if not params:
        return f"{variable_name} := mlm.Get_Message(i_Module_Code => 'LOAN', i_Message_Name => '{message_name}');"

    # Clean up parameters and remove any assignment operators
    cleaned_params = []

    for param in params:
        # Normalize the parameter
        param = param.strip()

        # Remove assignment operators
        if ':=' in param:
            param = param.split(':=')[-1].strip()

        # Remove trailing delimiters and whitespace
        param = re.sub(r'[,;]+$', '', param).strip()

        # Handle complex function calls with potential trailing comma
        if param.endswith(','):
            param = param.rstrip(',').strip()

        # Special handling for replace() function with empty last argument
        if param.startswith('replace(') and param.endswith(',)'):
            param = param.replace(',)', ')')

        # Validate parameter
        if (param and
                not param.isspace() and
                param != '()' and
                param != 'null'):

            # Additional cleanup for specific function calls
            if param.startswith('replace('):
                # Ensure replace() function is properly formatted
                param = re.sub(r',\s*\)', ')', param)

            cleaned_params.append(param)

    # If cleaned_params is empty after filtering, exclude i_Params entirely
    if not cleaned_params:
        return f"{variable_name} := mlm.Get_Message(i_Module_Code => 'LOAN', i_Message_Name => '{message_name}');"

    # Join parameters with clean formatting
    param_array = f"array_varchar2({', '.join(cleaned_params)})"
    result = f"{variable_name} := mlm.Get_Message(i_Module_Code => 'LOAN', i_Message_Name => '{message_name}', i_Params => {param_array});"

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


def generate_mlm_raise_error(message_name: str, params: List[str] = None) -> str:
    """Generate MLM Raise_Error call with proper parameter handling"""
    if not params:
        return f"mlm.Raise_Error(i_Module_Code => 'LOAN', i_Message_Name => '{message_name}');"

    # Clean up parameters and remove any assignment operators
    cleaned_params = []

    for param in params:
        # Normalize the parameter
        param = param.strip()

        # Remove assignment operators
        if ':=' in param:
            param = param.split(':=')[-1].strip()

        # Remove trailing delimiters and whitespace
        param = re.sub(r'[,;]+$', '', param).strip()

        # Handle complex function calls with potential trailing comma
        if param.endswith(','):
            param = param.rstrip(',').strip()

        # Special handling for replace() function with empty last argument
        if param.startswith('replace(') and param.endswith(',)'):
            param = param.replace(',)', ')')

        # Validate parameter
        if (param and
                not param.isspace() and
                param != '()' and
                param != 'null'):

            # Additional cleanup for specific function calls
            if param.startswith('replace('):
                # Ensure replace() function is properly formatted
                param = re.sub(r',\s*\)', ')', param)

            cleaned_params.append(param)

    # Format the parameters into the required structure without trailing comma
    param_array = f"array_varchar2({', '.join(cleaned_params)})"  # Removed potential trailing comma

    # Generate the full MLM call
    result = f"mlm.Raise_Error(i_Module_Code => 'LOAN', i_Message_Name => '{message_name}', i_Params => {param_array});"

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