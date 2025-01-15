
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
    i_description => 'Ln_Front.pck:1'
);
commit;
end;
/
