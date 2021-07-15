import cx_Oracle
from functools import partial
import app
import unittest
import getpass
import os
import sys
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

def remove_excessive_spaces(string):
    return re.sub('( )+', ' ', string)

def remove_comments(string):
    return re.sub('(/\*[\s\S]*?\*/)', ' ', string)

def remove_line_breaks(string):
    return re.sub('\n|\r|\t', ' ', string)

def format_statements(string):
    return remove_excessive_spaces(remove_line_breaks(remove_comments(string)))

def parse_sql_from(file_path):
    open_file = partial(open, encoding='iso-8859-1')
    with open_file(file_path, 'r') as file:
        content = file.read()
    # Removes the last empty string and the COMMIT
    return [s.lstrip().rstrip() for s in format_statements(content).split(';')][:-1]

def execute_all(connection, statements_list):
    cursor = connection.cursor()
    for statement in statements_list:
        cursor.execute(statement)
    connection.commit()

TABLE_REMOVAL_TEMPLATE = 'DROP TABLE %s CASCADE CONSTRAINTS'
SEQUENCE_REMOVAL_TEMPLATE = 'DROP SEQUENCE %s'
def clear_db(connection):
    cursor = connection.cursor()
    cursor.execute(QUERY_ALL_TABLES)
    tables = cursor.fetchmany()
    for table in tables:
        cursor.execute(TABLE_REMOVAL_TEMPLATE % table[0])
    cursor.execute(QUERY_ALL_SEQUENCES)
    sequences = cursor.fetchmany()
    for sequence in sequences:
        cursor.execute(SEQUENCE_REMOVAL_TEMPLATE % sequence[0])
    connection.commit()

def create_and_populate_db(connection):
    schema_creation_statements = parse_sql_from('./Esquema_Projeto.sql')
    execute_all(connection, schema_creation_statements)
    insertion_statements = parse_sql_from('./Dados_Projeto.sql')
    execute_all(connection, insertion_statements)

class QueriesTests(unittest.TestCase):
    def setUp(self):
        dsn = cx_Oracle.makedsn(HOST, PORT, SID)
        connection_cfg = {
            'user': USERNAME,
            'password': PASSWORD,
            'dsn': dsn,
            'encoding': 'UTF-8'
        }
        self.connection = cx_Oracle.connect(**connection_cfg)
        clear_db(self.connection)
        create_and_populate_db(self.connection)

    def tearDown(self):
        clear_db(self.connection)
        self.connection.close()

    def test_login_and_ownership_query(self):
        statement = 'SELECT * FROM USUARIO U INNER JOIN ROTEIRO_VIAGEM '\
            + 'R ON U.NICKNAME = R.AUTOR WHERE R.NOME_ROTEIRO = \'Roteiro 1\' '\
            + 'AND U.NICKNAME = \'LeoF\' AND U.SENHA = \'123456789\''
        expected = (
            'LeoF',
            'leo@hotmail.com',
            'Leonardo',
            '10236958966',
            '123456789',
            'LeoF',
            'Roteiro 1',
            'Roteiro legal'
        )
        cursor = self.connection.cursor()
        cursor.execute(statement)
        result = cursor.fetchmany()
        self.assertEqual(len(result), 1)
        self.assertEqual(set(result), expected)

    def test_user_written_guides_query(self):
        statement = 'SELECT U.NICKNAME,U.NOME,R.NOME_ROTEIRO FROM USUARIO U '\
            + 'LEFT JOIN ROTEIRO_VIAGEM R ON U.NICKNAME = R.AUTOR WHERE '\
            + 'UPPER(U.NOME) LIKE \'L%\'';
        expected = {
            ('LeoF', 'Leonardo', 'Roteiro 1'),
            ('LeoF', 'Leonardo', 'Roteiro 2')
        }
        cursor = self.connection.cursor()
        cursor.execute(statement)
        result = cursor.fetchmany()
        self.assertEqual(len(result), len(expected))
        self.assertEqual(set(result), expected)

    def test_teams_from_a_country_query(self):
        statement = 'SELECT T.NOME_FANTASIA,T.CATEGORIA,T.NOME_ESPORTE,A.NOME '\
            + 'FROM CLUBE C INNER JOIN "TIME" T ON C.ID_CLUBE = T.ID_CLUBE '\
            + 'LEFT JOIN ATLETA_TIME A ON T.ID_TIME = A.ID_TIME WHERE '\
            + 'UPPER(C.PAIS) = \'BRASIL\'';
        expected = {
            ('São Paulo FC', 'Profissional', 'Futebol', 'Daniel Alves'),
            ('Basquetebol do São Paulo', 'Profissional', 'Basquetebol', 'Georginho de Paula'),
            ('São Paulo FC', 'Profissional', 'Futebol', 'Tiago Volpi')
        }
        cursor = self.connection.cursor()
        cursor.execute(statement)
        result = cursor.fetchmany()
        self.assertEqual(len(result), len(expected))
        self.assertEqual(set(result), expected)

    def test_users_that_wrote_about_championship_query(self):
        statement = 'SELECT DISTINCT U.NICKNAME, U.EMAIL FROM USUARIO U '\
            + 'INNER JOIN ROTEIRO_PARTIDA R ON U.NICKNAME = R.AUTOR_ROTEIRO '\
            + 'INNER JOIN PARTIDA P ON R.PARTIDA = P.CODIGO_PARTIDA '\
            + 'WHERE UPPER(P.NOME_CAMPEONATO) = \'MUNDIAL DE CLUBES\' AND '\
            + ' P.ANO_CAMPEONATO = 2021'
        expected = {
            ('LeoF', 'leo@hotmail.com'),
        }
        cursor = self.connection.cursor()
        cursor.execute(statement)
        result = cursor.fetchmany()
        self.assertEqual(len(result), len(expected))
        self.assertEqual(set(result), expected)

    def test_average_price_for_each_country_query(self):
        statement = 'SELECT PAIS,TIPO,AVG(PRECO) FROM (SELECT P.PAIS, P.PRECO'\
            + ' AS PRECO, \'PONTO\' AS TIPO FROM PONTO_TURISTICO P UNION SELECT'\
            + ' P2.PAIS,P2.PRECO AS PRECO, \'PARTIDA\' AS TIPO FROM PARTIDA P2)'\
            + ' GROUP BY PAIS,TIPO ORDER BY PAIS'
        expected = [
            ('Alemanha', 'PONTO', 70),
            ('EUA', 'PARTIDA', 72.5),
            ('EUA', 'PONTO', 30),
            ('Inglaterra', 'PARTIDA', 60),
            ('Inglaterra', 'PONTO', 50),
        ]
        cursor = self.connection.cursor()
        cursor.execute(statement)
        result = cursor.fetchmany()
        self.assertEqual(len(result), len(expected))
        self.assertEqual(result, expected)

    def test_all_matches_of_an_athtlete(self):
        statement = 'SELECT A.NOME, T.NOME_FANTASIA, P.PAIS, P.DATA'\
            + ' FROM ATLETA_TIME A INNER JOIN TIME T ON T.ID_TIME = A.ID_TIME'\
            + ' INNER JOIN PARTIDA_TIME PT ON T.ID_TIME = PT.ID_TIME'\
            + ' INNER JOIN PARTIDA P ON PT.PARTIDA = P.CODIGO_PARTIDA'\
            + 'WHERE UPPER(A.NOME) LIKE (\'DANIEL ALVES\')';
        expected = {
            ('Daniel Alves', 'São Paulo FC', 'Inglaterra', '2021-12-21'),
            ('Daniel Alves', 'São Paulo FC', 'Inglaterra', '2021-12-28'),
            ('Daniel Alves', 'São Paulo FC', 'EUA', '2021-12-25'),
        }
        cursor = self.connection.cursor()
        cursor.execute(statement)
        result = cursor.fetchmany()
        self.assertEqual(len(result), len(expected))
        self.assertEqual(set(result), expected)

    def test_all_matches_of_an_athtlete(self):
        statement = 'SELECT PAIS,TIPO,AVG(PRECO) FROM (SELECT P.PAIS, P.PRECO'\
            + ' AS PRECO, \'PONTO\' AS TIPO FROM PONTO_TURISTICO P UNION SELECT'\
            + ' P2.PAIS,P2.PRECO AS PRECO, \'PARTIDA\' AS TIPO FROM PARTIDA P2)'\
            + ' GROUP BY PAIS,TIPO ORDER BY PAIS'
        expected = [
            ('Alemanha', 'PONTO', 70),
            ('EUA', 'PARTIDA', 72.5),
            ('EUA', 'PONTO', 30),
            ('Inglaterra', 'PARTIDA', 60),
            ('Inglaterra', 'PONTO', 50),
        ]
        cursor = self.connection.cursor()
        cursor.execute(statement)
        result = cursor.fetchmany()
        self.assertEqual(len(result), len(expected))
        self.assertEqual(result, expected)

    def test_all_guides_that_contain_all_matches_of_a_team_in_a_championship_query(self):
        statement = 'SELECT R.AUTOR,R.NOME_ROTEIRO,R.DESCRICAO'\
            + ' FROM ROTEIRO_VIAGEM R WHERE NOT EXISTS ((SELECT P2.PARTIDA'\
            + ' FROM  PARTIDA_TIME P2 INNER JOIN PARTIDA P ON P2.PARTIDA ='\
            + ' P.CODIGO_PARTIDA WHERE P2.ID_TIME = 4 AND'\
            + ' UPPER(P.NOME_CAMPEONATO) = \'PLAYOFFS NBA\' AND'\
            + ' P.ANO_CAMPEONATO = \'2021\') MINUS (SELECT R2.PARTIDA FROM'\
            + ' ROTEIRO_PARTIDA R2 WHERE R2.AUTOR_ROTEIRO = R.AUTOR AND'\
            + ' R2.NOME_ROTEIRO = R.NOME_ROTEIRO))'
        expected = [
            ('LeoF', 'Roteiro 2', 'Roteiro chato'),
        ]
        cursor = self.connection.cursor()
        cursor.execute(statement)
        result = cursor.fetchmany()
        self.assertEqual(len(result), len(expected))
        self.assertEqual(result, expected)

    def test_all_athletes_on_a_match(self):
        statement = 'SELECT A.NOME, T.NOME_FANTASIA FROM PARTIDA P'\
            + ' INNER JOIN PARTIDA_TIME PT ON PT.PARTIDA = P.CODIGO_PARTIDA'\
            + ' INNER JOIN TIME T ON T.ID_TIME = PT.ID_TIME'\
            + ' INNER JOIN ATLETA_TIME A ON T.ID_TIME = A.ID_TIME'\
            + ' WHERE P.CODIGO_PARTIDA LIKE (\'1\')'
        expected = {
            ('Daniel Alves', 'São Paulo FC'),
            ('Roberto Firmino', 'Liverpool FC',),
            ('Tiago Volpi', 'São Paulo FC'),
        }
        cursor = self.connection.cursor()
        cursor.execute(statement)
        result = cursor.fetchmany()
        self.assertEqual(len(result), len(expected))
        self.assertEqual(set(result), expected)

unittest.main()
