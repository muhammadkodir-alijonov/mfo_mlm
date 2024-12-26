import logging
from typing import Dict
from googletrans import Translator

logging.basicConfig(level=logging.INFO)

def escape_sql_quotes(text: str) -> str:
    """SQLga mos keladigan format uchun maxsus belgilarni almashtirish."""
    replacements = {
        "O'": "O`",
        "o'": "o`",
        "$ ": "$",
        "'": "",
        "`": ""
    }
    for old, new in replacements.items():
        text = text.replace(old, new)
    return text

def translate_message(message: str) -> Dict[str, str]:
    """Berilgan xabarni bir nechta tilda tarjima qilish."""
    translator = Translator()
    translations = {'RUS': message}
    
    try:
        # Inglizcha tarjima
        eng_trans = translator.translate(message, src='ru', dest='en')
        translations['ENG'] = escape_sql_quotes(eng_trans.text)

        # O'zbek (lotin) tarjimasi
        uzl_trans = translator.translate(message, src='ru', dest='uz')
        uzl_text = escape_sql_quotes(uzl_trans.text)
        translations['UZL'] = uzl_text

        # O'zbek (kiril) tarjimasi
        uzc_text = latin_to_cyrillic_convert(uzl_text)
        translations['UZC'] = escape_sql_quotes(uzc_text)

    except Exception as e:
        logging.error(f"Translation error: {str(e)}")
        # Fallback to original message if translation fails
        translations.update({
            'ENG': escape_sql_quotes(message),
            'UZL': escape_sql_quotes(message),
            'UZC': escape_sql_quotes(message)
        })
    
    return translations

latin_to_cyrillic = {
    'A': 'А', 'a': 'а',
    'B': 'Б', 'b': 'б',
    'V': 'В', 'v': 'в',
    'G‘': 'Ғ', 'g‘': 'ғ',
    'G': 'Г', 'g': 'г',
    'D': 'Д', 'd': 'д',
    'E': 'Э', 'e': 'э',
    'Yo': 'Ё', 'yo': 'ё',
    'Zh': 'Ж', 'zh': 'ж',
    'Z': 'З', 'z': 'з',
    'I': 'И', 'i': 'и',
    'Y': 'Й', 'y': 'й',
    'K': 'К', 'k': 'к',
    'L': 'Л', 'l': 'л',
    'M': 'М', 'm': 'м',
    'N': 'Н', 'n': 'н',
    "O`": 'Ў', "o`": 'ў',
    'O': 'О', 'o': 'о',
    'P': 'П', 'p': 'п',
    'R': 'Р', 'r': 'р',
    'S': 'С', 's': 'с',
    'T': 'Т', 't': 'т',
    'U': 'У', 'u': 'у',
    'F': 'Ф', 'f': 'ф',
    'X': 'Х', 'x': 'х',
    'Ts': 'Ц', 'ts': 'ц',
    'Ch': 'Ч', 'ch': 'ч',
    'Shch': 'Щ', 'shch': 'щ',
    'Sh': 'Ш', 'sh': 'ш',
    'Yu': 'Ю', 'yu': 'ю',
    'Ya': 'Я', 'ya': 'я',
    'Q': 'Қ', 'q': 'қ',
    'H': 'Ҳ', 'h': 'ҳ',
    'J': 'Ж', 'j': 'ж',
    '$ ': '$',
}

def latin_to_cyrillic_convert(text: str) -> str:
    """Convert Latin text to Cyrillic."""
    result = ""
    i = 0
    while i < len(text):
        # Try 3-character combinations first
        if i + 2 < len(text) and text[i:i+3] in latin_to_cyrillic:
            result += latin_to_cyrillic[text[i:i+3]]
            i += 3
        # Then try 2-character combinations
        elif i + 1 < len(text) and text[i:i+2] in latin_to_cyrillic:
            result += latin_to_cyrillic[text[i:i+2]]
            i += 2
        # Finally try single characters
        elif text[i] in latin_to_cyrillic:
            result += latin_to_cyrillic[text[i]]
            i += 1
        else:
            result += text[i]
            i += 1
    return result