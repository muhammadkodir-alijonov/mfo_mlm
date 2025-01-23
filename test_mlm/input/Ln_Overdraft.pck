mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => 'THERE_ARE_NOT_ENOUGH_FUNDS_IN_THE_RESOURCE_ACCOUNT', i_Params => array_varchar2(Chr(10), Chr(13), to_char(v_Respurce_Sum / 100, Ln_Const.Masksum), to_char(v_Used_Sum / 100, Ln_Const.Masksum), to_char(v_Resource_Saldo / 100, Ln_Const.Masksum), v_Detailed_Info));

mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => 'THERE_ARE_NOT_ENOUGH_FUNDS_IN_THE_RESOURCE_ACCOUNT', i_Params => array_varchar2(iClaim_Id, iClaim_Uid));


mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => 'THERE_ARE_NOT_ENOUGH_FUNDS_IN_THE_RESOURCE_ACCOUNT', i_Params => array_varchar2(vClaim_Apx.Card_Type));


Vmessage := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THERE_ARE_NOT_ENOUGH_FUNDS_IN_THE_RESOURCE_ACCOUNT', i_Params => array_varchar2(Vcard.Client_Code));



Omessage := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THERE_ARE_NOT_ENOUGH_FUNDS_IN_THE_RESOURCE_ACCOUNT');


result := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THERE_ARE_NOT_ENOUGH_FUNDS_IN_THE_RESOURCE_ACCOUNT', i_Params => array_varchar2(Vsucc_Loans, Verr_Loans));



o_Error_Msg := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THERE_ARE_NOT_ENOUGH_FUNDS_IN_THE_RESOURCE_ACCOUNT', i_Params => array_varchar2(v_Client_Uid));

Omessage := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THERE_ARE_NOT_ENOUGH_FUNDS_IN_THE_RESOURCE_ACCOUNT');



Omessage := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THERE_ARE_NOT_ENOUGH_FUNDS_IN_THE_RESOURCE_ACCOUNT');
