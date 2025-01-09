mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => 'THE_UNIQUE_CREDIT_APPLICATION_NUMBER_WAS_NOT_TRANS')

mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => 'NO_LOAN_APPLICATION_WITH_THE_SPECIFIED_UNIQUE_NUMB', i_Params => array_varchar(iClaim_Id))

Raise_Application_Error(-20000,
                                  'Кредит не может быть закрыт, так как на счете "' || Vln_Accounts(j).Acc_Type ||
                                  ' - ' || Vln_Accounts(j).Acc_Type_Name ||
                                  '" обнаружены остатки на сумму ' ||
                                  to_char(Abs(Vln_Accounts(j).Balance),
                                          'FM999G999G999G999G999G999G990D00999999',
                                          'NLS_NUMERIC_CHARACTERS=''. ''') || '!');

mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => 'THE_LOAN_CANNOT_BE_CLOSED_BECAUSE_BALANCES_IN_THE')

mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => 'NOT_A_SINGLE_PLASTIC_CARD_OF_THE_CLIENT_OR_GUARANT', i_Params => array_varchar(iLoan.Card.Filial_Code ;))

mlm.Raise_Error(i_Module_Code => 'LN', i_Message_Name => 'THE_OPERATION_TO_APPROVE_THE_CURRENT_CONTRACT_MUST', i_Params => array_varchar(vClaim_Apx.Card_Type, sqlerrm;))


Vmessage := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THE_SPECIFIED_PLACE_OF_WORK_IN_THE_APPLICATION_DOE', i_Params => array_varchar(Vcard.Client_Code))


Vmessage := 'В договоре указан недопустимый клиент - заявка заведена на "' ||
                vClaim.Client_Name || '"!';

vMessage := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THE_SPECIFIED_CLIENT_1_IS_INACTIVE_OR_NOT_A_CLIENT')


result := 'В состояние "Текущая ссуда" переведено : ' || Vsucc_Loans || Ut.Ccrlf ||
            'Не удалось перевести : ' || Verr_Loans;


Omessage := mlm.Get_Message(i_Module_Code => 'LN', i_Message_Name => 'THE_CONTRACT_SPECIFIES_AN_INVALID_CLIENT__THE_ORDE')

