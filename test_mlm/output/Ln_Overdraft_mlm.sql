
    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THERE_ARE_NOT_ENOUGH_FUNDS_IN_THE_RESOURCE_ACCOUNT',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 6,
    i_state => 'A',
    i_message_mask => mlm_label_t('Недостаточно средств на ресурном счете! $1 $2 Доступная сумма $3 - $4 = $5 $6', 'Рэсурс ҳисобида маблаг` йэтарли эмас! $1 $2 Мавжуд миқдор $3 - $4 = $5 $6', 'Resurs hisobida mablag` yetarli emas! $1 $2 Mavjud miqdor $3 - $4 = $5 $6', 'There are not enough funds in the resource account! $1 $2 Available amount $3 - $4 = $5 $6'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Overdraft.pck:3'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'NO_LOAN_APPLICATION_WITH_THE_SPECIFIED_UNIQUE_NUMB',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 2,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не найдена кредитная заявка с указанным уникальным номером Claim Id = $1 ! $2', 'Ко`рсатилган ноёб рақамга эга крэдит аризаси топилмади Да`во идэнтификатори = $1 ! $2', 'Ko`rsatilgan noyob raqamga ega kredit arizasi topilmadi Da`vo identifikatori = $1 ! $2', 'No loan application with the specified unique number was found Claim Id = $1 ! $2'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Overdraft.pck:11'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THE_SPECIFIED_PLACE_OF_WORK_IN_THE_APPLICATION_DOE',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 2,
    i_state => 'A',
    i_message_mask => mlm_label_t('Указанное место работы в заявке не соответствует месту работы, указанному в модуле $1 . $2', 'Иловада ко`рсатилган иш жойи $1 модулида ко`рсатилган иш жойига мос кэлмайди $2', 'Ilovada ko`rsatilgan ish joyi $1 modulida ko`rsatilgan ish joyiga mos kelmaydi $2', 'The specified place of work in the application does not correspond to the place of work specified in module $1 $2'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Overdraft.pck:16'
);


    --MUHAMMADKODIR.A
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
    i_description => 'Ln_Overdraft.pck:19'
);


    --MUHAMMADKODIR.A
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
    i_description => 'Ln_Overdraft.pck:25'
);


    --MUHAMMADKODIR.A
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
    i_description => 'Ln_Overdraft.pck:28'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'CLIENT_UID_NOT_FOUND__1_IN_CLIENT_CURRENT_OR_THIS',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не найден Client_Uid - $1 в Client_Current или не вводили эту полю', 'Cлиэнт_Уид топилмади - Cлиэнт_Cуррэнтда $1 ёки бу майдон киритилмаган', 'Client_Uid topilmadi - Client_Currentda $1 yoki bu maydon kiritilmagan', 'Client_Uid not found - $1 in Client_Current or this field was not entered'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Overdraft.pck:33'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'THIS_OPERATION_MUST_BE_PERFORMED_BY_A_BRANCH_EMPLO',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Данная операция должна выполняться сотрудником филиала', 'Ушбу опэрацияни филиал ходими бажариши кэрак', 'Ushbu operatsiyani filial xodimi bajarishi kerak', 'This operation must be performed by a branch employee'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Overdraft.pck:37'
);


    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'ENTERING_APPLICATIONS_INTO_THE_CIVIL_DEFENSE_IS_PR',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Вводить заявки в ГО запрещено', 'Фуқаролик мудофаасига аризаларни киритиш тақиқланади', 'Fuqarolik mudofaasiga arizalarni kiritish taqiqlanadi', 'Entering applications into the Civil Defense is prohibited'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Overdraft.pck:42'
);

