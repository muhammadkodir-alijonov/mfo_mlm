
begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THE_UNIQUE_CREDIT_APPLICATION_NUMBER_WAS_NOT_TRANS',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не передан уникальный номер кредитной заявки!', 'Ноёб крэдит ариза рақами узатилмади!', 'Noyob kredit ariza raqami uzatilmadi!', 'The unique credit application number was not transmitted!'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Contract.pck:1'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'NO_LOAN_APPLICATION_WITH_THE_SPECIFIED_UNIQUE_NUMB',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не найдена кредитная заявка с указанным уникальным номером Claim Id = $1 !', 'Ко''рсатилган ягона рақамга эга крэдит аризаси топилмади Да''во Ид = $1 !', 'Ko''rsatilgan yagona raqamga ega kredit arizasi topilmadi Da''vo Id = $1 !', 'No loan application with the specified unique number was found Claim Id = $1 !'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Contract.pck:4'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THE_LOAN_CANNOT_BE_CLOSED_BECAUSE_BALANCES_IN_THE',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 2,
    i_state => 'A',
    i_message_mask => mlm_label_t('Кредит не может быть закрыт, так как на счете $1 - $2 обнаружены остатки на сумму FM999G999G999G999G999G999G990D00999999 !', 'Крэдитни ёпиш мумкин эмас, чунки $1 - $2 ҳисобида ФМ999Г999Г999Г999Г999Г999Г990Д00999999 миқдоридаги қолдиқлар топилган!', 'Kreditni yopish mumkin emas, chunki $1 - $2 hisobida FM999G999G999G999G999G999G990D00999999 miqdoridagi qoldiqlar topilgan!', 'The loan cannot be closed because balances in the amount of FM999G999G999G999G999G999G990D00999999 were found on the account $1 - $2!'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Contract.pck:8'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'NOT_A_SINGLE_PLASTIC_CARD_OF_THE_CLIENT_OR_GUARANT',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не закреплена ни одна пластиковая карта клиента или поручителя', 'Мижоз ёки кафилнинг битта ҳам пластик картаси бириктирилмаган', 'Mijoz yoki kafilning bitta ham plastik kartasi biriktirilmagan', 'Not a single plastic card of the client or guarantor is attached'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Contract.pck:16'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THE_OPERATION_TO_APPROVE_THE_CURRENT_CONTRACT_MUST',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Операция по утверждению текущего договора должна выполняться в филиале $1', 'Жорий шартномани тасдиқлаш учун опэрация $1 филиалида амалга оширилиши кэрак', 'Joriy shartnomani tasdiqlash uchun operatsiya $1 filialida amalga oshirilishi kerak', 'The operation to approve the current contract must be performed in branch $1'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Contract.pck:18'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THE_SPECIFIED_PLACE_OF_WORK_IN_THE_APPLICATION_DOE',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 2,
    i_state => 'A',
    i_message_mask => mlm_label_t('Указанное место работы в заявке не соответствует месту работы, указанному в модуле $1 . $2', 'Иловада ко''рсатилган иш жойи $1 модулида ко''рсатилган иш жойига мос кэлмайди $2', 'Ilovada ko''rsatilgan ish joyi $1 modulida ko''rsatilgan ish joyiga mos kelmaydi $2', 'The specified place of work in the application does not correspond to the place of work specified in module $1 $2'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Contract.pck:20'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THE_SPECIFIED_CLIENT_1_IS_INACTIVE_OR_NOT_A_CLIENT',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Указанный клиент $1 находится в состоянии НЕ АКТИВКЕН или НЕ ЯВЛЯЕТСЯ клиентом вашего филиала. см. Клиенты и счета!', 'Бэлгиланган $1 мижоз НОФАОЛ ёки филиалингиз мижози ЭМАС Мижозлар ва Ҳисобларга қаранг!', 'Belgilangan $1 mijoz NOFAOL yoki filialingiz mijozi EMAS Mijozlar va Hisoblarga qarang!', 'The specified client $1 is INACTIVE or NOT a client of your branch see Clients and Accounts!'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Contract.pck:23'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THE_CONTRACT_SPECIFIES_AN_INVALID_CLIENT__THE_ORDE',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('В договоре указан недопустимый клиент - заявка заведена на $1 !', 'Шартномада яроқсиз мижоз ко''рсатилган - буюртма $1 га киритилган!', 'Shartnomada yaroqsiz mijoz ko''rsatilgan - buyurtma $1 ga kiritilgan!', 'The contract specifies an invalid client - the order was entered for $1!'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Contract.pck:28'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => '1_TRANSFERRED_TO_CURRENT_LOAN_STATE_2_FAILED_TO_TR',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 3,
    i_state => 'A',
    i_message_mask => mlm_label_t('В состояние Текущая ссуда переведено $1 $2 Не удалось перевести $3', 'Жорий қарз ҳолатига $1 ўтказилди $2 $3 ўтказиб бўлмади', 'Joriy qarz holatiga $1 oʻtkazildi $2 $3 oʻtkazib boʻlmadi', '$1 transferred to Current Loan state $2 Failed to transfer $3'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Contract.pck:34'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THE_OPERATION_WAS_NOT_COMPLETED_OR_PARTIALLY_COMPL',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Операция не выполнена или выполнена частично', 'Опэрация тугалланмаган ёки қисман тугалланмаган', 'Operatsiya tugallanmagan yoki qisman tugallanmagan', 'The operation was not completed or partially completed'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Contract.pck:38'
);
commit;
end;
/
