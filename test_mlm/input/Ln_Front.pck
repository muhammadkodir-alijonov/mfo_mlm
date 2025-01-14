Vmessage := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THE_SPECIFIED_CLIENT_1_IS_INACTIVE_OR_NOT_A_CLIENT', i_Params => array_varchar2(Vcard.Client_Code));



def extract_error_message(stmt: str) -> Optional[str]:
    """Extract and format error message with parameters - improved version"""
    try:
        # Clean up the statement first
        stmt = stmt.replace('\n', ' ').replace('\r', ' ')
        stmt = re.sub(r'\s+', ' ', stmt)

        # Remove common prefixes and suffixes
        stmt = re.sub(r'^(vMessage|result|Omessage)\s*:=\s*', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'return\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'raise\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)

result := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => '1_TRANSFERRED_TO_CURRENT_LOAN_STATUS_FAILED_TO_TRA', i_Params => array_varchar2(Vsucc_Loans, Ut.Ccrlf, Verr_Loans));


def extract_error_message(stmt: str) -> Optional[str]:
    """Extract and format error message with parameters - improved version"""
    try:
        # Clean up the statement first
        stmt = stmt.replace('\n', ' ').replace('\r', ' ')
        stmt = re.sub(r'\s+', ' ', stmt)

        # Remove common prefixes and suffixes
        stmt = re.sub(r'^(vMessage|result|Omessage)\s*:=\s*', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'return\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'raise\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)
        
o_Error_Msg := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'CLIENT_UID_NOT_FOUND__1_IN_CLIENT_CURRENT_OR_THIS', i_Params => array_varchar2(v_Client_Uid));


def extract_error_message(stmt: str) -> Optional[str]:
    """Extract and format error message with parameters - improved version"""
    try:
        # Clean up the statement first
        stmt = stmt.replace('\n', ' ').replace('\r', ' ')
        stmt = re.sub(r'\s+', ' ', stmt)

        # Remove common prefixes and suffixes
        stmt = re.sub(r'^(vMessage|result|Omessage)\s*:=\s*', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'return\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'raise\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)


Omessage := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THE_OPERATION_WAS_NOT_COMPLETED_OR_PARTIALLY_COMPL');

def extract_error_message(stmt: str) -> Optional[str]:
    """Extract and format error message with parameters - improved version"""
    try:
        # Clean up the statement first
        stmt = stmt.replace('\n', ' ').replace('\r', ' ')
        stmt = re.sub(r'\s+', ' ', stmt)

        # Remove common prefixes and suffixes
        stmt = re.sub(r'^(vMessage|result|Omessage)\s*:=\s*', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'return\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'raise\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)


Em.Raise_Error('LN',
                     'Данная операция должна выполняться сотрудником филиала');



def extract_error_message(stmt: str) -> Optional[str]:
    """Extract and format error message with parameters - improved version"""
    try:
        # Clean up the statement first
        stmt = stmt.replace('\n', ' ').replace('\r', ' ')
        stmt = re.sub(r'\s+', ' ', stmt)

        # Remove common prefixes and suffixes
        stmt = re.sub(r'^(vMessage|result|Omessage)\s*:=\s*', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'return\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'raise\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)


Em.Raise_Error_If(v_Msg is not null, 'LNBLANK', v_Msg);


def extract_error_message(stmt: str) -> Optional[str]:
    """Extract and format error message with parameters - improved version"""
    try:
        # Clean up the statement first
        stmt = stmt.replace('\n', ' ').replace('\r', ' ')
        stmt = re.sub(r'\s+', ' ', stmt)

        # Remove common prefixes and suffixes
        stmt = re.sub(r'^(vMessage|result|Omessage)\s*:=\s*', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'return\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'raise\s+\w+\s*;$', '', stmt, flags=re.IGNORECASE)


Em.Raise_Error('LN','Транзакция автопогашения незавершена');