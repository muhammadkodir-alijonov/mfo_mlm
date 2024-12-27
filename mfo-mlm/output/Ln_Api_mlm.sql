
begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => '_SHARTNOMA_TOPILMADI_LNCAIM_ILOVA_TOPILMADI__BOSHQ',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('{' ': 'Договор не найден!', 'LNCLAIM': 'Заявка не найдена!', 'else': 'Документ не найден!'}', '{: Шартнома топилмади!, "ЛНCАИМ": Илова топилмади! "," Бошқа ":" Ҳужжат топилмади! "}', '{: Shartnoma topilmadi!, "LNCAIM": Ilova topilmadi! "," Boshqa ":" Hujjat topilmadi! "}', '{: The contract was not found!, Lnclaim: The application is not found!, Else: The document was not found!}'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:1011'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'BELGILANGAN_KREDIT_SORASH_ID__1_TOPILMADI',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не обнаружен договор с указанным Loan_ID = $1', 'Бэлгиланган крэдит сораш_ид = $1 топилмади', 'Belgilangan kredit sorash_id = $1 topilmadi', 'The contract with the specified loan_id = $1 has not been found'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:1145'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'BELGILANGAN_IDENTIFIKATORLI_DASTUR__1_ANIQLANMADI',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не обнаружена заявка с указанным ID = $1', 'Бэлгиланган идэнтификаторли дастур = $1 аниқланмади', 'Belgilangan identifikatorli dastur = $1 aniqlanmadi', 'The application with the specified id = $1 was not detected'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:1214'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'AVVAL_SHARTNOMALAR_MENYUSI_ROYXATIGA_OTING_KEYIN_K',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Сначала зайдите в меню Список договоров затем выберите необходимый договор.', 'Аввал шартномалар мэнюси ройхати-га отинг, кэйин кэракли шартномани танланг.', 'Avval shartnomalar menyusi royxati-ga oting, keyin kerakli shartnomani tanlang.', 'First go to the menu list of contracts then select the necessary contract.'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:1231'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'ESKI_KREDITLAR_QAYTA_ISHLANMAYDI',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Старые кредиты не обрабатываются!', 'Эски крэдитлар қайта ишланмайди!', 'Eski kreditlar qayta ishlanmaydi!', 'Old loans are not processed!'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:1239'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'NOMALUM_HUJJAT_TURI_1_UZATILDI',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Передан неизвестный тип документа $1', 'Номалум ҳужжат тури $1 узатилди', 'Nomalum hujjat turi $1 uzatildi', 'The unknown type of document $1 was transferred'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:1254'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'SHARTNOMA_YOQ',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не найден договор!', 'Шартнома ёқ!', 'Shartnoma yoq!', 'No contract!'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:1274'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'HECH_QANDAY_DASTUR_TOPILMADI',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не найдена заявка!', 'Ҳэч қандай дастур топилмади!', 'Hech qanday dastur topilmadi!', 'No application was found!'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:1295'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'N',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('N', 'Н', 'N', 'N'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:3342'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'FILIAL_MIJOZ_2_KOD_BILAN_1',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 2,
    i_state => 'A',
    i_message_mask => mlm_label_t('Клиент филиала $1 с кодом $2', 'Филиал мижоз $2 код билан $1', 'Filial mijoz $2 kod bilan $1', 'Branch Client $1 with $2 code'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:3388'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'FILIAL_MIJOZ_2_KOD_BILAN_1',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 2,
    i_state => 'A',
    i_message_mask => mlm_label_t('Клиент филиала $1 с кодом $2', 'Филиал мижоз $2 код билан $1', 'Filial mijoz $2 kod bilan $1', 'Branch Client $1 with $2 code'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:3437'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'USHBU_SHARTNOMAGA_MUVOFIQ_QUYI_TIZIM_KREDITLARI_BO',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('По этому договору запрещено выполнять какие-либо действия в подсистеме Кредиты', 'Ушбу шартномага мувофиқ қуйи тизим крэдитлари бойича ҳар қандай ҳаракатларни амалга ошириш тақиқланади', 'Ushbu shartnomaga muvofiq quyi tizim kreditlari boyicha har qanday harakatlarni amalga oshirish taqiqlanadi', 'Under this agreement it is forbidden to perform any actions in the subsystem loans'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4448'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'AKKUNT',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('ACCOUNT%', 'Аккунт%', 'Akkunt%', 'Akkunt%'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4453'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'OVERDRAFT_AAAAILLE_MANOAL_OPERTSENS',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('OVERDRAFT_AVAILABLE_MANUAL_OPERATIONS', 'Овэрдрафт_ааааиллэ_маноал_опэрцэнс', 'Overdraft_aaaaille_manoal_opertsens', 'Overdraft_Aavailable_Manoal_Opertens'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4470'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'KREDITLAR_TANLANMAGAN',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не выбраны кредиты', 'Крэдитлар танланмаган', 'Kreditlar tanlanmagan', 'Loans are not selected'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4481'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'VA',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Y', 'Ва', 'Va', 'AND'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4489'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => '1_PARAMETRLARI_SONI_2_QIYMATGA_MOS_KELMAYDI',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 2,
    i_state => 'A',
    i_message_mask => mlm_label_t('Количество параметров $1 не соответсвует количеству значений $2', '$1 парамэтрлари сони $2 қийматга мос кэлмайди', '$1 parametrlari soni $2 qiymatga mos kelmaydi', 'The number of $1 parameters does not correspond to the number of $2 values'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4494'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'GET_OPERATSIYA_PARAMS_PROTSEDURASIDAGI_XATO',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Ошибка в процедуре Get_Operation_Params', 'Гэт_опэрация_парамс процэдурасидаги хато', 'Get_operatsiya_params protsedurasidagi xato', 'Error in the Get_OPERATION_PARAMS procedure'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4633'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'PROTSESSORDA_XATO_GRAF_BUTTON_INF',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Ошибка в процедуре Graph_Operation_Button_Inf', 'Процэссорда хато граф_буттон_инф', 'Protsessorda xato graf_button_inf', 'Error in the procedure Graph_OPREATION_BUTTON_inf'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4665'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'USHBU_SHARTNOMAGA_MUVOFIQ_QUYI_TIZIM_KREDITLARI_BO',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('По этому договору запрещено выполнять какие-либо действия в подсистеме Кредиты', 'Ушбу шартномага мувофиқ қуйи тизим крэдитлари бойича ҳар қандай ҳаракатларни амалга ошириш тақиқланади', 'Ushbu shartnomaga muvofiq quyi tizim kreditlari boyicha har qanday harakatlarni amalga oshirish taqiqlanadi', 'Under this agreement it is forbidden to perform any actions in the subsystem loans'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4715'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'VA',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Y', 'Ва', 'Va', 'AND'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4720'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'USHBU_SHARTNOMAGA_MUVOFIQ_QUYI_TIZIM_KREDITLARI_BO',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('По этому договору запрещено выполнять какие-либо действия в подсистеме Кредиты', 'Ушбу шартномага мувофиқ қуйи тизим крэдитлари бойича ҳар қандай ҳаракатларни амалга ошириш тақиқланади', 'Ushbu shartnomaga muvofiq quyi tizim kreditlari boyicha har qanday harakatlarni amalga oshirish taqiqlanadi', 'Under this agreement it is forbidden to perform any actions in the subsystem loans'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4816'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'OVLAMOQ',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('OSN', 'Овламоқ', 'Ovlamoq', 'Op'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4871'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'VA',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Y', 'Ва', 'Va', 'AND'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4898'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => '09005',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('09005', '09005', '09005', '09005'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:4903'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'USHBU_SHARTNOMAGA_MUVOFIQ_QUYI_TIZIM_KREDITLARI_BO',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('По этому договору запрещено выполнять какие-либо действия в подсистеме Кредиты', 'Ушбу шартномага мувофиқ қуйи тизим крэдитлари бойича ҳар қандай ҳаракатларни амалга ошириш тақиқланади', 'Ushbu shartnomaga muvofiq quyi tizim kreditlari boyicha har qanday harakatlarni amalga oshirish taqiqlanadi', 'Under this agreement it is forbidden to perform any actions in the subsystem loans'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:5834'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'MD__1_UCHUN_BOSHQARUV_PARAMETRLARI_TOPILMADI',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Не найдены параметры контролей для md= $1', 'МД = $1 учун бошқарув парамэтрлари топилмади', 'MD = $1 uchun boshqaruv parametrlari topilmadi', 'No control parameters for MD = $1 were found'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:6079'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => '09003',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('09003', '09003', '09003', '09003'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:6295'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'FILIALGA_KIRISH_IMKONIYATI_YOQ',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('Нет доступа филиала', 'Филиалга кириш имконияти ёқ', 'Filialga kirish imkoniyati yoq', 'There is no access to the branch'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:6962'
);
commit;
end;
/

begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'N',
    i_message_type => 'E',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('N', 'Н', 'N', 'N'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Api.~pck:7179'
);
commit;
end;
/
