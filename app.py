import cx_Oracle
import getpass
import os
import sys
from abc import ABC
from functools import partial
import re

USERNAME = 'C11218705'
PASSWORD = USERNAME
HOST = 'grad.icmc.usp.br'
PORT = '15215'
SID = 'orcl'

EXIT_FAILURE = 1
EXIT_SUCCESS = 0

USER_CONSTRAINTS = ['PK_USUARIO', 'UN_USUARIO_CPF', 'CK_USUARIO_CPF']
USER_ERROR_MESSAGES = [
    'Nome de usuário indisponível.',
    'CPF já cadastrado.',
    'CPF inválido.'
]
MAX_LEN_ERROR_CODE = 12899
CAMPOS_USUARIO = [
    'NICKNAME',
    'NOME',
    'EMAIL',
    'CPF',
    'SENHA',
]

MAX_LEN_ERROR_MESSAGE = [
    'nickname excedeu o limite de caracteres (15 caracteres).',
    'nome excedeu o limite de caracteres (50 caracteres).',
    'email excedeu o limite de caracteres (50 caracteres).',
    'cpf excedeu o limite de caracteres (11 caracteres).',
    'senha excedeu o limite de caracteres (20 caracteres).',
]


class UserInterfaceState(ABC):
    def __init__(
        self,
        connection,
        user_is_logged_in=False,
        username='',
        password=''
    ):
        self.connection = connection
        self.user_is_logged_in = user_is_logged_in
        self.username =  username
        self.password = password

    def next_state(self, param):
        pass

    def isExit(self):
        return False

class Guide:
    def __init__(self, id_, author, name, description):
        self.id = id_
        self.author = author
        self.name = name
        self.description = description

    def __str__(self):
        description = f'Descrição: {self.description}'
        author = f'Autor: {self.author}' if self.author != '' else ''
        return f'({self.id}) {self.name}\n{description}\n{author}'

class Exit(UserInterfaceState):
    def isExit(self):
        return True

    def __str__(self):
        return 'Programa finalizado.'

class GuidesUserSpecificVisualization(UserInterfaceState):
    def __init__(
        self,
        connection,
        user_is_logged_in,
        username,
        password
    ):
        super(GuidesUserSpecificVisualization, self).__init__(
            connection,
            user_is_logged_in=user_is_logged_in,
            username=username,
            password=password
        )
        statement = 'SELECT NOME_ROTEIRO, DESCRICAO FROM'\
            + ' ROTEIRO_VIAGEM R WHERE R.AUTOR = \'%s\''
        cursor = self.connection.cursor()
        cursor.execute(statement % (self.username))
        self.guides = cursor.fetchmany()
        self.guides = [Guide(i, '', *guide) for i, guide in enumerate(self.guides)]

    def next_state(self, _):
        return Menu(self.connection, self.user_is_logged_in, self.username, self.password)

    def __str__(self):
        if len(self.guides) > 0:
            return '\n\n'.join([str(guide) for guide in self.guides])\
                + '\n\nAperte enter para voltar para o menu.'
        else:
            return 'Nenhum roteiro foi encontrado.'\
                + '\n\nAperte enter para voltar para o menu.'


class GuidesVisualization(UserInterfaceState):
    def __init__(
        self,
        connection,
        user_is_logged_in=False,
        username='',
        password=''
    ):
        super(GuidesVisualization, self).__init__(
            connection,
            user_is_logged_in,
            username,
            password
        )
        statement = 'SELECT * FROM ROTEIRO_VIAGEM'
        cursor = self.connection.cursor()
        cursor.execute(statement)
        self.guides = cursor.fetchmany()
        self.guides = [Guide(i, *guide) for i, guide in enumerate(self.guides)]

    def next_state(self, _):
        return Menu(self.connection, self.user_is_logged_in, self.username, self.password)

    def __str__(self):
        if len(self.guides) > 0:
            return '\n\n'.join([str(guide) for guide in self.guides])\
                + '\n\nAperte enter para voltar para o menu.'
        else:
            return 'Nenhum roteiro foi encontrado.'\
                + '\n\nAperte enter para voltar para o menu.'

class CreateAccount(UserInterfaceState):
    def __init__(
        self,
        connection,
        user_is_logged_in=False,
        username='',
        password=''
    ):
        super(CreateAccount, self).__init__(
            connection,
            user_is_logged_in,
            username,
            password
        )
        self.email = ''
        self.cpf = ''
        self.name = ''

    def next_state(self, received_input):
        if self.cpf != '':
            statement = 'INSERT INTO USUARIO (NICKNAME, NOME, EMAIL, CPF, SENHA)'\
                + ' VALUES (\'%s\', \'%s\', \'%s\', \'%s\', \'%s\')'
            cursor = self.connection.cursor()
            try:
                cursor.execute(statement % (
                    self.username,
                    self.name,
                    self.email,
                    self.cpf,
                    received_input
                ))
                self.connection.commit()
            except cx_Oracle.Error as error:
                i = 0
                type_of_error_found = False
                error_message = error.args[0].message
                if  error.args[0].code == MAX_LEN_ERROR_CODE:
                    while i < len(CAMPOS_USUARIO) and not type_of_error_found:
                        if re.search(CAMPOS_USUARIO[i], error.args[0].message):
                            error_message = MAX_LEN_ERROR_MESSAGE[i]
                            type_of_error_found = True
                        i += 1
                else:
                    while i < len(USER_CONSTRAINTS) and not type_of_error_found:
                        if re.search(USER_CONSTRAINTS[i], error.args[0].message):
                            error_message = USER_ERROR_MESSAGES[i]
                            type_of_error_found = True
                        i += 1
                print(error_message)
                return Menu(self.connection)
            else:
                return Menu(
                    self.connection,
                    user_is_logged_in=True,
                    username=self.username,
                    password=received_input
                )
        else:
            if self.username == '':
                self.username = received_input
            elif self.name == '':
                self.name = received_input
            elif self.email == '':
                self.email = received_input
            else:
                self.cpf = received_input
            return self

    def __str__(self):
        if self.username == '':
            return 'Digite o seu nickname:'
        if self.name == '':
            return 'Digite o seu nome:'
        if self.email == '':
            return 'Digite o seu email:'
        if self.cpf == '':
            return 'Digite o seu cpf:'
        return 'Digite a sua senha:'

class Login(UserInterfaceState):
    def next_state(self, received_input):
        if self.username != '':
            statement = 'SELECT NICKNAME FROM USUARIO U'\
                + ' WHERE U.NICKNAME = \'%s\' AND U.SENHA = \'%s\''
            cursor = self.connection.cursor()
            cursor.execute(statement % (self.username, received_input))
            login_match = cursor.fetchone() is not None
            if login_match:
                return Menu(
                    self.connection,
                    user_is_logged_in=True,
                    username=self.username,
                    password=received_input
                )
            else:
                print("Usuário ou senha inválido.")
                return Menu(self.connection)
        else:
            self.username = received_input
            return self

    def __str__(self):
        if self.username == '':
            return 'Digite o seu nickname:'
        else:
            return 'Digite a sua senha:'

NOT_LOGGED_IN_OPTIONS = [0, 1, 2, 4]
LOGGED_IN_OPTIONS = [2, 3, 4]
OPTIONS = [
    '(%d) fazer login.',
    '(%d) criar uma conta.',
    '(%d) visualizar todos os roteiros.',
    '(%d) visualizar seus roteiros.',
    '(%d) sair.',
]
LOGGED_IN_CONSTRUCTORS = [
    GuidesVisualization,
    GuidesUserSpecificVisualization,
    Exit
]
NOT_LOGGED_IN_CONSTRUCTORS = [
    Login,
    CreateAccount,
    GuidesVisualization,
    Exit
]

class Menu(UserInterfaceState):
    def next_state(self, received_input):
        used_map = LOGGED_IN_CONSTRUCTORS if self.user_is_logged_in\
            else NOT_LOGGED_IN_CONSTRUCTORS
        if not received_input.isdigit():
            return self
        as_int = int(received_input)
        if as_int > len(used_map) or as_int < 0:
            return self
        return used_map[as_int - 1](
            self.connection,
            self.user_is_logged_in,
            self.username,
            self.password
        )

    def __str__(self):
        username_display = "" if not self.user_is_logged_in else " " + self.username
        greeting = f'Olá,{username_display} o que você gostaria de fazer?'
        menu = [greeting]
        if self.user_is_logged_in:
            menu += [OPTIONS[i] for i in LOGGED_IN_OPTIONS]
        else:
            menu += [OPTIONS[i] for i in NOT_LOGGED_IN_OPTIONS]
        return ('\n    '.join(menu) % tuple(range(1, len(menu))))

if __name__ == '__main__':
    dsn = cx_Oracle.makedsn(HOST, PORT, SID)
    connection_cfg = {
        'user': USERNAME,
        'password': PASSWORD,
        'dsn': dsn,
        'encoding': 'UTF-8'
    }
    try:
        connection = cx_Oracle.connect(**connection_cfg)
    except cx_Oracle.Error as error:
        print(error.args[0].message)
        exit(EXIT_FAILURE)

    interface = Menu(connection)
    while not interface.isExit():
        print(interface)
        command = input()
        interface = interface.next_state(command)

    connection.close()

    exit(EXIT_SUCCESS)
