from functools import partial
import re

corrections_dict = {}

def to_uppercase_format(string):
    word = string.group(0)
    translation = ''
    for i, ch in enumerate(word):
        if ch.isupper() and i != 0:
            translation = f'{translation}_{ch}'
        else:
            translation = f'{translation}{ch.upper()}'
    corrections_dict[word.upper()] = translation
    return word.upper()

ALL_FILES = [
    './Esquema_Projeto.sql',
    './Dados_Projeto.sql',
    './Consultas_Projeto.sql',
    './Drop_Projeto.sql'
]

COMMENTS_REGEX = '(/\*[\s\S]*?\*/)'
STRINGS_REGEX = '[\'"][\s\S]*?[\'"]'

if __name__ == '__main__':
    op = partial(open, encoding='iso-8859-1')
    REGEX = '[A-Z]?[a-z0-9][a-zA-Z0-9]*'

    for i, file_path in enumerate(ALL_FILES):
        with op(file_path, 'r') as in_file, op(f'./out{i}.sql', 'w') as out_file:
            content = in_file.read()
            corrected = re.sub(REGEX, to_uppercase_format, content)
            comments = re.compile(COMMENTS_REGEX)
            for m in comments.finditer(content):
                left = corrected[:m.start()]
                right = corrected[m.start() + len(m.group()):]
                corrected = left + m.group() + right
            strings = re.compile(STRINGS_REGEX)
            for m in strings.finditer(content):
                left = corrected[:m.start()]
                right = corrected[m.start() + len(m.group()):]
                corrected = left + m.group() + right
            for wrong_word, correct_word in corrections_dict.items():
                corrected = corrected.replace(wrong_word, correct_word)
            out_file.write(corrected)
