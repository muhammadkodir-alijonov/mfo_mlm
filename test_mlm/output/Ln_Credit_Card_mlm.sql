
begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'LINENBLANK_1',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 1,
    i_state => 'A',
    i_message_mask => mlm_label_t('LNBLANK $1', 'ЛинэнБланк $1', 'LinenBlank $1', 'LinenBlank $1'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Credit_Card.pck:2'
);
commit;
end;
/
