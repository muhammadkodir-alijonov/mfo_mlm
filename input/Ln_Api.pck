result := 'В состояние "Текущая ссуда" переведено : ' | | Vsucc_Loans | | Ut.Ccrlf | |
'Не удалось перевести : ' | | Verr_Loans;
return result;


 Vmessage := 'Указанный клиент ( ' || Vcard.Client_Code ||
                ' ) находится в состоянии НЕ АКТИВКЕН ' ||
                  'или НЕ ЯВЛЯЕТСЯ клиентом вашего филиала. (см. "Клиенты и счета")!';
      raise Ex;


Raise_Application_Error(-20000,
                              'Не обнаружена заявка с указанным ID = ' || Iclaim_Id || '!');


Raise_Application_Error(-20000,
                              case Idoc_Type_Code when ' ' then 'Договор не найден!' when 'LNCLAIM' then
                              'Заявка не найдена!' else 'Документ не найден!' end);


Vmessage := 'Указанный клиент ( ' || Vcard.Client_Code ||
                ' ) находится в состоянии НЕ АКТИВКЕН ' ||
                  'или НЕ ЯВЛЯЕТСЯ клиентом вашего филиала. (см. "Клиенты и счета")!';