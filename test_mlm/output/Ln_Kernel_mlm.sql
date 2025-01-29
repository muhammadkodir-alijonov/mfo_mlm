
    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'A_LOAN_APPLICATION_HAS_NOT_BEEN_FOUND_WITH_THE_IND',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 2,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не найдена кредитная заявка с указанным уникальным номером Claim Id = $1 ! $2', 'Ушбу ноёб рақамли да`во идэнтификатори билан крэдит аризаси топилмади = $1! $2', 'Ushbu noyob raqamli da`vo identifikatori bilan kredit arizasi topilmadi = $1! $2', 'A loan application has not been found with the indicated unique number Claim id = $1! $2'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Kernel.pck:3'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THE_SPECIFIED_PLACE_OF_WORK_IN_THE_APPLICATION_DOE',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 2,
    i_state => 'A',
    i_message_mask => mlm_label_t('Указанное место работы в заявке не соответствует месту работы, указанному в модуле $1 . $2', 'Аризада ко`рсатилган иш жойи - $1 модулда ко`рсатилган иш жойига мос кэлмайди $2', 'Arizada ko`rsatilgan ish joyi - $1 modulda ko`rsatilgan ish joyiga mos kelmaydi $2', 'The specified place of work in the application does not correspond to the place of work specified in the $1 module $2'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Kernel.pck:8'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THE_SPECIFIED_CLIENT_1_IS_NOT_IN_A_STATE_OF_ASSET',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Указанный клиент $1 находится в состоянии НЕ АКТИВКЕН или НЕ ЯВЛЯЕТСЯ клиентом вашего филиала. см. Клиенты и счета!', 'Бэлгиланган мижоз $1 актив ҳолатида эмас ёки сизнинг филиалингиз мижоз эмас Мижозлар ва ҳисоб-китобларга қаранг!', 'Belgilangan mijoz $1 aktiv holatida emas yoki sizning filialingiz mijoz emas Mijozlar va hisob-kitoblarga qarang!', 'The specified Client $1 is not in a state of asset or is not a client of your branch See clients and accounts!'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Kernel.pck:11'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THE_OPERATION_IS_NOT_PERFORMED_OR_PARTIALLY_PERFOR',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Операция не выполнена или выполнена частично', 'Опэрация амалга оширилмайди ёки қисман бажарилмайди', 'Operatsiya amalga oshirilmaydi yoki qisman bajarilmaydi', 'The operation is not performed or partially performed'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Kernel.pck:17'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => '1_2_COULD_NOT_TRANSFER_TO_THE_CURRENT_LOAN_TO_TRAN',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 3,
    i_state => 'A',
    i_message_mask => mlm_label_t('В состояние Текущая ссуда переведено $1 $2 Не удалось перевести $3', '$1 $2 АҚШ долларини о`тказиш учун жорий крэдитга о`тказа олмади', '$1 $2 AQSh dollarini o`tkazish uchun joriy kreditga o`tkaza olmadi', '$1 $2 could not transfer to the current loan to transfer $3'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Kernel.pck:20'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'NO_CLIENT_UID_WAS_FOUND__1_IN_CLIENT_CURRENT_OR_DI',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не найден Client_Uid - $1 в Client_Current или не вводили эту полю', 'Ҳэч қандай мижоз_уид топилмади - мижоз_cаллэнт-да $1 ёки ушбу майдонни киритмади', 'Hech qanday mijoz_uid topilmadi - mijoz_callent-da $1 yoki ushbu maydonni kiritmadi', 'No Client_uid was found - $1 in Client_current or did not introduce this field'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Kernel.pck:25'
);

