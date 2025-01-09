import logging
from typing import Dict, Optional
from googletrans import Translator

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def escape_sql_quotes(text: str) -> str:
    """SQLga mos keladigan format uchun maxsus belgilarni almashtirish."""
    replacements = {
        "$ ": "$",
        ".": "",
        "'": "''",  # SQL injection xavfsizligi uchun
        '"': '""'  # SQL injection xavfsizligi uchun
    }
    for old, new in replacements.items():
        text = text.replace(old, new)
    return text


def safe_translate(translator: Translator, text: str, src: str, dest: str) -> Optional[str]:
    """Xavfsiz tarjima funksiyasi"""
    try:
        result = translator.translate(text, src=src, dest=dest)
        return result.text if result else None
    except Exception as e:
        logger.error(f"Translation error for {dest}: {str(e)}")
        return None


def translate_message(message: str) -> Dict[str, str]:
    """Berilgan xabarni bir nechta tilda tarjima qilish."""
    translator = Translator()
    translations = {'RUS': message}

    # Tarjima parametrlarini saqlash
    translation_params = {
        'ENG': ('ru', 'en'),
        'UZL': ('ru', 'uz')
    }

    # Har bir til uchun tarjima
    for lang, (src, dest) in translation_params.items():
        translated_text = safe_translate(translator, message, src, dest)
        if translated_text:
            translations[lang] = escape_sql_quotes(translated_text)
        else:
            logger.warning(f"Fallback to original for {lang}")
            translations[lang] = escape_sql_quotes(message)

    # Kirill versiyasini yaratish
    try:
        translations['UZC'] = latin_to_cyrillic_convert(translations['UZL'])
    except Exception as e:
        logger.error(f"Error converting to Cyrillic: {str(e)}")
        translations['UZC'] = translations['UZL']

    # Variable placeholders ($1, $2, $3) ni tekshirish
    for lang, text in translations.items():
        if not check_variable_consistency(message, text):
            logger.warning(f"Variable mismatch in {lang} translation")

    return translations


def check_variable_consistency(source: str, translation: str) -> bool:
    """Manba va tarjimadagi o'zgaruvchilar sonini tekshirish"""
    source_vars = set(var for var in source.split() if var.startswith('$'))
    trans_vars = set(var for var in translation.split() if var.startswith('$'))
    return source_vars == trans_vars


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
    "Oʻ": 'Ў', "oʻ": 'ў',
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
    'J': 'Ж', 'j': 'ж'
}


def latin_to_cyrillic_convert(text: str) -> str:
    """Latin matnini kirill alfavitiga o'tkazish."""
    result = ""
    i = 0
    while i < len(text):
        # 2 harfli kombinatsiyalarni tekshirish
        if i + 1 < len(text) and text[i:i + 2] in latin_to_cyrillic:
            result += latin_to_cyrillic[text[i:i + 2]]
            i += 2
        # Bitta harfni tekshirish
        elif text[i] in latin_to_cyrillic:
            result += latin_to_cyrillic[text[i]]
            i += 1
        else:
            result += text[i]
            i += 1
    return result