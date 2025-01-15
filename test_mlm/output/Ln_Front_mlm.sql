
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
    i_description => 'Ln_Front.pck:4'
);
commit;
end;
/
