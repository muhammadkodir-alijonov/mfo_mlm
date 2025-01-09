
begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => 'LNKRS',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => 0,
    i_state => 'A',
    i_message_mask => mlm_label_t('LNCRS', 'ЛНКРС', 'LNKRS', 'LNKRS'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => 'Ln_Contract.pck:2'
);
commit;
end;
/
