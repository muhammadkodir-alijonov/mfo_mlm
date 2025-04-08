Raise_Application_Error(-20000,
                                  'Недостаточно средств на ресурном счете!' || Chr(10) || Chr(13) ||
                                  'Доступная сумма: ' ||
                                  to_char(v_Respurce_Sum / 100, Ln_Const.Masksum) || ' - ' ||
                                  to_char(v_Used_Sum / 100, Ln_Const.Masksum) || ' = ' ||
                                  to_char(v_Resource_Saldo / 100, Ln_Const.Masksum) ||
                                  v_Detailed_Info);


Ut.Raise_Err( 'Указанное место работы в заявке не соответствует месту работы, указанному в модуле "'||vClaim_Apx.Card_Type||'". ' || sqlerrm);


Vmessage := 'Указанный клиент ( ' || Vcard.Client_Code ||
                ' ) находится в состоянии НЕ АКТИВКЕН ' ||
                  'или НЕ ЯВЛЯЕТСЯ клиентом вашего филиала. (см. "Клиенты и счета")!';


v_Msg := 'ID: ' || v_Loan_Uid || ', karta: ' ||
                 replace(v_Card_Number, Substr(v_Card_Number, 1, 12), '****') ||
                 'Muddati o''tgan qarizdorlik vujudga kelganda, mazkur karta raqamidan avtomat yechib olinadi!';

Raise_Application_Error(-20000, 'Dw_Process не найдено. process_id = ' || Nvl(to_char(vProcess_Id), 'null'));