import cx_Oracle
import getpass
import os
import sys
from functools import partial
import re

USERNAME = 'C11218705'
PASSWORD = USERNAME
HOST = 'grad.icmc.usp.br'
PORT = '15215'
SID = 'orcl'

EXIT_FAILURE = 1
EXIT_SUCCESS = 0

QUERY_ALL_TABLES = 'SELECT TABLE_NAME FROM USER_TABLES'
QUERY_ALL_SEQUENCES = 'SELECT SEQUENCE_NAME FROM USER_SEQUENCES'

def parse_sql_from(file_path):
    open_file = partial(open, encoding='iso-8859-1')
    with open_file(file_path, 'r') as file:
        content = file.read()
    filtered_content = re.sub('(  )+|(/\*[\s\S]*?\*)/', '', content)
    filtered_content = re.sub('\n|\t|\r', ' ', filtered_content)
    statements = filtered_content.split(';')
    return statements[:-2] # Removes the last empty string and COMMIT

TABLE_REMOVAL_TEMPLATE = 'DROP TABLE %s CASCADE CONSTRAINTS'
SEQUENCE_REMOVAL_TEMPLATE = 'DROP SEQUENCE %s'
def clear_db(connection):
    cursor = connection.cursor()
    cursor.execute(QUERY_ALL_TABLES)
    result = cursor.fetchmany()
    for table in result:
        cursor.execute(TABLE_REMOVAL_TEMPLATE % table[0])
    cursor.execute(QUERY_ALL_SEQUENCES)
    result = cursor.fetchmany()
    for sequence in result:
        cursor.execute(SEQUENCE_REMOVAL_TEMPLATE % sequence[0])
    connection.commit()

def execute_all(connection, cursor, statements_list):
    for statement in statements_list:
        cursor.execute(statement)
    connection.commit()
    return

if __name__ == '__main__':
    #sys.stdout.write('Username: ')
    #username = input()
    #password = getpass.getpass(prompt="Password: ")
    username = USERNAME
    password = PASSWORD

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
        clear_db(connection)
    except cx_Oracle.Error as error:
        print(error.args[0].message)
        exit(EXIT_FAILURE)

    statements = parse_sql_from('./Esquema_Projeto.sql')
    try:
        execute_all(connection, cursor, statements)
    except cx_Oracle.Error as error:
        print(error.args[0].message)
        exit(EXIT_FAILURE)

    try:
        cursor.execute(QUERY_ALL_TABLES)
        result = cursor.fetchmany()
    except cx_Oracle.Error as error:
        print(error.args[0].message)
        exit(EXIT_FAILURE)
    else:
        print(result)

    try:
        clear_db(connection)
    except cx_Oracle.Error as error:
        print(error.args[0].message)
        exit(EXIT_FAILURE)

    try:
        cursor.execute(QUERY_ALL_TABLES)
        result = cursor.fetchmany()
    except cx_Oracle.Error as error:
        print(error.args[0].message)
        exit(EXIT_FAILURE)
    else:
        print(result)

    exit(EXIT_SUCCESS)
