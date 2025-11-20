
    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LOAN',
    i_message_name => 'NOT_ENOUGH_FUNDS_IN_THE_RESOURCE_ACCOUNT_1_2_AVAIL',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 6,
    i_state => 'A',
    i_message_mask => mlm_label_t('Недостаточно средств на ресурном счете! $1 $2 Доступная сумма $3 - $4 = $5 $6', 'Рэсурс ҳисобида маблаг `йэтарли эмас! $1 $2 Мавжуд $3 - $4 = $5 $6', 'Resurs hisobida mablag `yetarli emas! $1 $2 Mavjud $3 - $4 = $5 $6', 'Not enough funds in the resource account! $1 $2 Available amount $3 - $4 = $5 $6'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Bo_Kernel.pck:1'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LOAN',
    i_message_name => 'THE_SPECIFIED_PLACE_OF_WORK_IN_THE_APPLICATION_DOE',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 2,
    i_state => 'A',
    i_message_mask => mlm_label_t('Указанное место работы в заявке не соответствует месту работы, указанному в модуле " $1 ". $2', 'Аризада ко`рсатилган иш жойи `"$1`" модулида ко`рсатилган иш жойига мос кэлмайди $2', 'Arizada ko`rsatilgan ish joyi `"$1`" modulida ko`rsatilgan ish joyiga mos kelmaydi $2', 'The specified place of work in the application does not correspond to the place of work specified in the `"$1`" module $2'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Bo_Kernel.pck:10'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LOAN',
    i_message_name => 'THE_SPECIFIED_CLIENT_1_IS_NOT_IN_A_STATE_OF_ASSET',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Указанный клиент $1 находится в состоянии НЕ АКТИВКЕН или НЕ ЯВЛЯЕТСЯ клиентом вашего филиала. см. "Клиенты и счета"!', 'Бэлгиланган мижоз $1 актив ҳолатида эмас ёки сизнинг филиалингиз мижоз эмас Қаранг `"Мижозлар ва ҳисоблар`"!', 'Belgilangan mijoz $1 aktiv holatida emas yoki sizning filialingiz mijoz emas Qarang `"Mijozlar va hisoblar`"!', 'The specified Client $1 is not in a state of asset or is not a client of your branch See `"Clients and Accounts`"!'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Bo_Kernel.pck:13'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LOAN',
    i_message_name => 'ID_1_CARD_2_WISDOM_ABOUT_TGANA_GARIZDORLIK_VUZHUDG',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 2,
    i_state => 'A',
    i_message_mask => mlm_label_t('ID $1 , karta $2 Muddati o tgan qarizdorlik vujudga kelganda, mazkur karta raqamidan avtomat yechib olinadi!', 'ИД $1, картанинг 2 долларлик донолик, Тҳона Гаризда Кэлганда, Мазкур Мап Рабамидаон автоматироти автоуловлар!', 'ID $1, kartaning 2 dollarlik donolik, Thona Garizda Kelganda, Mazkur Map Rabamidaon avtomatiroti avtoulovlar!', 'ID $1, card $2 wisdom about Tgana Garizdorlik Vuzhudga Kelganda, Mazkur Map Ragamidan Automat Ekhib Olynada!'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Bo_Kernel.pck:18'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LOAN',
    i_message_name => 'DW_PROCESS_WAS_NOT_FOUND_PROCESS_ID__1',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Dw_Process не найдено. process_id = $1', 'ДW_ПРОCСС топилмади Жараён_ИД = $1', 'DW_PROCSS topilmadi Jarayon_ID = $1', 'DW_PROCESS was not found Process_id = $1'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Bo_Kernel.pck:22'
);

