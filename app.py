import cx_Oracle
import getpass
import os
import sys

USERNAME = 'C11218705'
PASSWORD = USERNAME
HOST = 'grad.icmc.usp.br'
PORT = '15215'
SID = 'orcl'

EXIT_FAILURE = 1
EXIT_SUCCESS = 0

QUERY_ALL_TABLES = 'SELECT table_name FROM user_tables'

INFORMATION_FOR_GUIDE_ALTERING_TEMPLATE = 'SELECT * FROM USUARIO U'\
    + ' INNER JOIN ROTEIRO_VIAGEM'\
    + ' R ON U.NICKNAME = R.AUTOR WHERE R.NOME_ROTEIRO = \'%s\' '\
    + ' AND U.NICKNAME = \'%s\' AND U.SENHA = \'%s\''
def information_for_guide_altering(connection, guide, username, password):
    cursor = connection.cursor()
    cursor.execute(INFORMATION_FOR_GUIDE_ALTERING_TEMPLATE % (guide, username, password))
    return cursor.fetchone()

def insert_new_guide(connection, guide):
    ...

def get_all_guides(connection, guide):
    ...

def create_account(connection, account):
    ...

def login(connection, loginInfo):
    ...

if __name__ == '__main__':
    #sys.stdout.write('Username: ')
    #username = input()
    #password = getpass.getpass(prompt="Password: ")
    username = 'C11218705'
    password = username

    dsn = cx_Oracle.makedsn(HOST, PORT, SID)
    connection_cfg = {
        'user': username,
        'password': password,
        'dsn': dsn,
        'encoding': 'UTF-8'
    }
    try:
        connection = cx_Oracle.connect(**connection_cfg)
    except cx_Oracle.Error as error:
        print(error.args[0].message)
        exit(EXIT_FAILURE)
    else:
        cursor = connection.cursor()

    try:
        cursor.execute(QUERY_ALL_TABLES)
        result = cursor.fetchone()
    except cx_Oracle.Error as error:
        print(error.args[0].message)
        exit(EXIT_FAILURE)
    else:
        print(result)

    exit(EXIT_SUCCESS)
