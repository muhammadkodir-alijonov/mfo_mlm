import deepl

auth_key = "your_deepL_auth_key"  # DeepL API kalitingiz
translator = deepl.Translator(auth_key)

# Tarjima qilish
result = translator.translate_text("Hello, how are you?", target_lang="RU")
print(result.text)  # Rus tilida tarjima
