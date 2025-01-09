import re

def count_dynamic_parameters(error_message: str) -> int:
    count = 0
    for match in re.finditer(r"\$\d+", error_message):
        count += 1
    return count
def generate_message_name(text: str) -> str:
    """i_message_name qiymatini generatsiya qilish."""
    # 1. Bo'shliqlarni _ bilan almashtirish va barcha harflarni katta qilish
    formatted_text = text.upper().replace(" ", "_")

    # 2. Belgilarni SQL formatiga moslashtirish
    formatted_text = formatted_text.replace("O'", "O`").replace("G'", "G`")

    # 3. Faqat harf, raqam va _ belgilarni qoldirish
    formatted_text = re.sub(r"[^A-Z0-9_]", "", formatted_text)

    # 4. Uzunlikni 50 belgi bilan cheklash
    truncated_text = formatted_text[:50]

    # 5. Oxirgi _ belgisini olib tashlash
    if truncated_text.endswith('_'):
        count = 0
        for i in range(len(truncated_text)-1,-1,-1):
            if truncated_text[i].isalnum():
                break
            count += 1
        truncated_text = truncated_text[:-count]

    if truncated_text.startswith('_'):
        count = 0
        for i in truncated_text:
            if i.isalnum():
                break
            count += 1
        truncated_text = truncated_text[count:]

    return truncated_text

def format_error_template(error_message: str, translations: dict, file_name: str, line_number: int) -> str:
    """Format the error message into an MLM template."""
    param_count = count_dynamic_parameters(error_message)
    rus = translations.get('RUS', error_message)
    uzc = translations.get('UZC', error_message)
    uzl = translations.get('UZL', error_message)
    eng = translations.get('ENG', error_message)
    message_name = generate_message_name(eng)

    return f"""
begin
mlm.save_template(
    i_module_code => 'LN',
    i_message_name => '{message_name}',
    i_message_type => 'T',
    i_error_code => 1,
    i_param_count => {param_count},
    i_state => 'A',
    i_message_mask => mlm_label_t('{rus}', '{uzc}', '{uzl}', '{eng}'),
    i_user_action => mlm_text_t(),
    i_admin_action => mlm_text_t(),
    i_description => '{file_name}:{line_number}'
);
commit;
end;
/"""