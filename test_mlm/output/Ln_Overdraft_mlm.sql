
    --MUHAMMADKODIR.A
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'IT_IS_IMPOSSIBLE_TO_ISSUE_A_LOAN_BECAUSE_THE_AGREE',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('Нельзя выдать кредит т.к договор в состоянии $1', 'Крэдит бэриш мумкин эмас, чунки шартнома 1 долларга тэнг', 'Kredit berish mumkin emas, chunki shartnoma 1 dollarga teng', 'It is impossible to issue a loan because the agreement is worth $1'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Overdraft.pck:1'
);

