                   v_Detailed_Info);

mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => 'A_LOAN_APPLICATION_HAS_NOT_BEEN_FOUND_WITH_THE_IND', i_Params => array_varchar2(iClaim_Id, iClaim_Uid));


mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => 'THE_SPECIFIED_PLACE_OF_WORK_IN_THE_APPLICATION_DOE', i_Params => array_varchar2(vClaim_Apx.Card_Type, sqlerrm));


Vmessage := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THE_SPECIFIED_CLIENT_1_IS_NOT_IN_A_STATE_OF_ASSET', i_Params => array_varchar2(Vcard.Client_Code));



Omessage := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THE_OPERATION_IS_NOT_PERFORMED_OR_PARTIALLY_PERFOR');


result := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => '1_2_COULD_NOT_TRANSFER_TO_THE_CURRENT_LOAN_TO_TRAN', i_Params => array_varchar2(Vsucc_Loans, Ut.Ccrlf, Verr_Loans));



o_Error_Msg := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'NO_CLIENT_UID_WAS_FOUND__1_IN_CLIENT_CURRENT_OR_DI', i_Params => array_varchar2(v_Client_Uid));

result := '12313123';
