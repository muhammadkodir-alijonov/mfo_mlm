Em.Raise_Error_If(Not v_Is_Create_Claim and Ln_Util.Is_Header_Bank, 'LNCLAIM', 'Изменять заявки в ГО запрещено');

Em.Raise_Error_If(Iraise = 'Y', 'LN', 'Не найдена заявка!');


Em.Raise_Error('LNCRS',
                     'Общая сумма финансирования по источникам кредитования не соответствует сумме договора');


Em.Raise_Error_If(Not v_Is_Create_Claim and Ln_Util.Is_Header_Bank, 'LNCLAIM', 'Изменять заявки в ГО запрещено');