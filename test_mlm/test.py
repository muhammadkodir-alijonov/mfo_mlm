import re
from typing import Dict, List, Tuple, Optional
import logging


def clean_error_message(message: str) -> str:
    """Clean and normalize error message"""
    message = re.sub(r'\s+', ' ', message)
    message = message.strip()
    return message


def generate_message_name(message: str) -> str:
    """Generate a standardized message name for MLM"""
    # Convert to uppercase and replace spaces with underscores
    name = message.upper().replace(' ', '_')

    # Replace special characters
    name = name.replace("O'", "O`").replace("G'", "G`")

    # Remove all non-alphanumeric characters except underscore
    name = re.sub(r'[^A-Z0-9_]', '', name)

    # Truncate to 50 characters
    name = name[:50]

    # Remove trailing underscore
    if name.endswith('_'):
        name = name[:-1]

    return name


def extract_params(error_stmt: str) -> List[str]:
    """Extract parameter names from concatenation operations"""
    params = []
    # Find all concatenated variables
    concat_pattern = r'\|\|\s*([A-Za-z][A-Za-z0-9_\.]*)'
    matches = re.finditer(concat_pattern, error_stmt)
    for match in matches:
        params.append(match.group(1))
    return params


def transform_error_statement(original_code: str) -> str:
    """Transform an error statement to MLM format"""
    # Extract the error message
    message_match = re.search(r"'([^']+)'", original_code)
    if not message_match:
        return original_code

    message = message_match.group(1)
    params = extract_params(original_code)
    message_name = generate_message_name(message)

    # Generate the new MLM code
    new_code = f"/* {original_code.strip()} */\n"
    new_code += "mlm.Raise_Error(\n"
    new_code += "    i_Module_Code    => 'LN',\n"
    new_code += f"    i_Message_Name   => '{message_name}'"

    if params:
        new_code += ",\n    i_Params         => array_varchar2(" + ", ".join(params) + ")"

    new_code += "\n);"

    return new_code


def transform_case_statement(case_stmt: str) -> str:
    """Transform a CASE statement to MLM format with multiple message names"""
    new_code = f"/* {case_stmt.strip()} */\n"
    new_code += "mlm.Raise_Error(\n"
    new_code += "    i_Module_Code    => 'LN',\n"
    new_code += "    i_Message_Name   => case "

    # Extract the condition variable
    condition_match = re.search(r'case\s+(\w+)', case_stmt)
    if condition_match:
        condition_var = condition_match.group(1)
        new_code += condition_var + "\n"

        # Extract when clauses
        when_clauses = re.finditer(r"when\s+'([^']+)'\s+then\s+'([^']+)'", case_stmt)
        for clause in when_clauses:
            condition = clause.group(1)
            message = clause.group(2)
            message_name = generate_message_name(message)
            new_code += f"                          when '{condition}' then '{message_name}'\n"

        # Extract else clause if exists
        else_match = re.search(r"else\s+'([^']+)'", case_stmt)
        if else_match:
            message = else_match.group(1)
            message_name = generate_message_name(message)
            new_code += f"                          else '{message_name}'\n"

        new_code += "                        end\n);"

    return new_code


def transform_content(content: str) -> str:
    """Transform an entire file's error handling code"""
    lines = content.split('\n')
    result = []
    i = 0
    while i < len(lines):
        line = lines[i].strip()

        # Check for different error patterns
        if any(pattern in line for pattern in [
            "Raise_Application_Error",
            "Vmessage :=",
            "result :=",
            "raise Ex",
            "Omessage :=",
            "oMessage :="
        ]):
            # Collect multi-line statement
            stmt = line
            while i + 1 < len(lines) and ';' not in stmt:
                i += 1
                stmt += ' ' + lines[i].strip()

            # Transform based on type
            if 'case' in stmt.lower() and 'when' in stmt.lower():
                result.append(transform_case_statement(stmt))
            else:
                result.append(transform_error_statement(stmt))
        else:
            result.append(lines[i])
        i += 1

    return '\n'.join(result)


def transform_pck_file(file_path: str, output_path: str):
    """Transform a PCK file from old error handling to MLM format"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        transformed_content = transform_content(content)

        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(transformed_content)

        print(f"Successfully transformed {file_path} to {output_path}")
    except Exception as e:
        logging.error(f"Error transforming file {file_path}: {str(e)}")


# Example usage:
if __name__ == "__main__":
    path = 'C:/Users/muxammadqodir.a/Desktop/test_mlm/input'
    transform_pck_file(path, 'ln_api_transformed.pck')