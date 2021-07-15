from functools import partial

if __name__ == '__main__':
    op = partial(open, encoding='iso-8859-1')
    with op('./Dados_Projeto.sql', 'r') as in_file, op('./out.sql', 'w') as out_file:
        for ch in iter(lambda: in_file.read(1), ''):
            if ch == '(' or ch == ',':
                next_ch = in_file.read(1)
                if (next_ch != ''):
                    if next_ch == ' ':
                        out_file.write(f'{ch}\n\t')
                    else:
                        out_file.write(f'{ch}\n\t{next_ch}')
            elif ch == ')':
                location = out_file.tell()
                out_file.write(f'\n{ch}')
            elif ch == ';':
                out_file.write(f'{ch}\n')
            else:
                out_file.write(ch)
