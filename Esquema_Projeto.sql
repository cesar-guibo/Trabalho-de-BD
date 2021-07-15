
/* Limpando o DB   */

/*

SELECT 'drop table ' || table_name||' cascade constraints;' FROM user_tables; 

*/



/* tabela esporte */
CREATE TABLE ESPORTE (
	NOME VARCHAR(30),
	DESCRICAO VARCHAR(500),
	
	CONSTRAINT PK_ESPORTE PRIMARY KEY(NOME)
);

/* tabela campeonato */
CREATE TABLE CAMPEONATO(
	NOME VARCHAR(30),
	ANO NUMBER(4) DEFAULT 2021,
	ORGANIZADOR VARCHAR(30),
	
	CONSTRAINT PK_CAMPEONATO PRIMARY KEY(NOME,ANO),
	CONSTRAINT CK_ANO_VALIDO CHECK(ANO>2015)
);

/* tabela usu�rio*/
CREATE TABLE USUARIO(
	NICKNAME VARCHAR(15),
	EMAIL VARCHAR(50) NOT NULL,
	NOME VARCHAR(50) NOT NULL,
	CPF CHAR(11) NOT NULL,
	SENHA VARCHAR(20) NOT NULL,
	
	CONSTRAINT PK_USUARIO PRIMARY KEY(NICKNAME),
	CONSTRAINT UN_USUARIO_CPF UNIQUE(CPF),
    CONSTRAINT CK_USUARIO_CPF CHECK(REGEXP_LIKE(CPF, '[0-9]{11}'))
);

CREATE SEQUENCE SEQ_ID_CLUBE
MINVALUE 0
START WITH 0
INCREMENT BY 1;

/* tabela clube */
CREATE TABLE CLUBE(
	ID_CLUBE NUMBER(4),
	CADASTRO_EMPRESARIAL VARCHAR(11) NOT NULL,
	PAIS VARCHAR(20) NOT NULL,
	UF CHAR(2),
	NOME_DO_CLUBE VARCHAR(30) NOT NULL,
	COR1 VARCHAR(15) NOT NULL ,
	COR2 VARCHAR(15),
	COR3 VARCHAR(15),
	
	
	CONSTRAINT PK_CLUBE PRIMARY KEY(ID_CLUBE),
	CONSTRAINT UN_CLUBE UNIQUE(CADASTRO_EMPRESARIAL,PAIS,UF),
    CONSTRAINT CK_CLUBE_CNPJ CHECK(REGEXP_LIKE(CADASTRO_EMPRESARIAL, '[0-9]{11}'))
);

/* tabela roteiro de viagem */
/* achei q fica melhor trocar roteiro codigo roteiro para nome roteiro */
/* Acho melhor manter codigo */

CREATE TABLE ROTEIRO_VIAGEM(
	AUTOR VARCHAR(15),
	NOME_ROTEIRO VARCHAR(11),
	DESCRICAO VARCHAR (150),
	
	/*preco NUMBER(4,2), devemos por pre�o total do roteiro ? */
	
	CONSTRAINT PK_ROTEIRO_VIAGEM PRIMARY KEY(AUTOR,NOME_ROTEIRO),
	CONSTRAINT FK_ROTEIRO FOREIGN KEY (AUTOR) REFERENCES USUARIO(NICKNAME) ON DELETE CASCADE 
);

/* tabela hospedagem */
CREATE TABLE HOSPEDAGEM(
	NOME VARCHAR(20), 
	CODIGO_POSTAL VARCHAR(11),
	PRECO NUMBER(7,2) NOT NULL ,
	UF CHAR(2),
	CIDADE VARCHAR(30) NOT NULL,
	BAIRRO VARCHAR(30),
	LOGRADOURO VARCHAR(30) NOT NULL,
	NUMERO VARCHAR(5) NOT NULL,
	COMPLEMENTO VARCHAR(5),
	PONTO_DE_REFERENCIA VARCHAR(30),
	PAIS VARCHAR(20) NOT NULL,
	
	CONSTRAINT PK_HOSPEDAGEM PRIMARY KEY(NOME,CODIGO_POSTAL),
	
	/*conferindo se o pre�o � maior que zero */
	CONSTRAINT CK_PRECO_HOSPEDAGEM CHECK(PRECO >= 0.0)
	
);


/*tabela transporte */
/*fazer confer�ncia com regex para codigoPostal ser numero */
CREATE TABLE TRANSPORTE(
	NOME_DA_EMPRESA VARCHAR(20),
	CODIGO_POSTALORIGEM VARCHAR(11),
	CODIGO_POSTALDESTINO VARCHAR(11),
	PRECO NUMBER(6,2) NOT NULL,
	
	
	ORIGEM_UF CHAR(2),
	ORIGEM_CIDADE VARCHAR(30) NOT NULL,
	ORIGEM_BAIRRO VARCHAR(30),
	ORIGEM_LOGRADOURO VARCHAR(30) NOT NULL,
	ORIGEM_NUMERO VARCHAR(5) NOT NULL,
	ORIGEM_COMPLEMENTO VARCHAR(5),
	ORIGEMPONTO_DE_REFERENCIA VARCHAR(30),
	ORIGEM_PAIS VARCHAR(20) NOT NULL,
	
	DESTINO_UF CHAR(2),
	DESTINO_CIDADE VARCHAR(30) NOT NULL,
	DESTINO_BAIRRO VARCHAR(30),
	DESTINO_LOGRADOURO VARCHAR(30) NOT NULL,
	DESTINO_NUMERO VARCHAR(5) NOT NULL,
	DESTINO_COMPLEMENTO VARCHAR(5),
	DESTINOPONTO_DE_REFERENCIA VARCHAR(30),
	DESTINO_PAIS VARCHAR(20) NOT NULL,
	
	CONSTRAINT PK_TRANSPORTE PRIMARY KEY(NOME_DA_EMPRESA,CODIGO_POSTALORIGEM,CODIGO_POSTALDESTINO),
	
	/* confere se o codigo postal da origem � diferente do destino */
	CONSTRAINT CK_CPORIGEM_CPDESTINO CHECK( CODIGO_POSTALORIGEM != CODIGO_POSTALDESTINO ),
	
	/*confere se o pre�o � maior que zero */
	
	CONSTRAINT CK_PRECO_TRANSPORTE CHECK(PRECO >= 0)
);

/*tabela time*/
CREATE TABLE TIME(
	ID_TIME NUMBER(4),
	NOME_FANTASIA VARCHAR(30) NOT NULL,
	CATEGORIA VARCHAR(15) NOT NULL,
	ID_CLUBE NUMBER(4) NOT NULL,
	NOME_ESPORTE VARCHAR(30) NOT NULL,
	
	CONSTRAINT PK_TIME PRIMARY KEY(ID_TIME),
	CONSTRAINT FK_TIME_CLUBE FOREIGN KEY(ID_CLUBE) REFERENCES CLUBE(ID_CLUBE),
	CONSTRAINT UN_TIME UNIQUE(NOME_FANTASIA,CATEGORIA,ID_CLUBE,NOME_ESPORTE)
);

CREATE SEQUENCE SEQ_ID_TIME
MINVALUE 0
START WITH 0
INCREMENT BY 1;


/* tabela partida */

/* fazer check do tipo de codigo partida*/
CREATE TABLE PARTIDA(
	CODIGO_PARTIDA VARCHAR(5),
	JUIZ VARCHAR(20),
	DATA DATE NOT NULL,
	PRECO NUMBER(6,2) NOT NULL,
	
	UF CHAR(2),
	CIDADE VARCHAR(30) NOT NULL,
	BAIRRO VARCHAR(30),
	LOGRADOURO VARCHAR(30) NOT NULL,
	NUMERO VARCHAR(5) NOT NULL,
	COMPLEMENTO VARCHAR(5),
	PONTO_DE_REFERENCIA VARCHAR(30),
	PAIS VARCHAR(20) NOT NULL,
	
	
	NOME_CAMPEONATO VARCHAR(30),
	ANO_CAMPEONATO NUMBER(4) DEFAULT 2021,
	
	CONSTRAINT PK_PARTIDA PRIMARY KEY(CODIGO_PARTIDA),
	CONSTRAINT FK_PARTIDA_CAMPEONATO FOREIGN KEY(NOME_CAMPEONATO,ANO_CAMPEONATO) REFERENCES CAMPEONATO(NOME,ANO) ON DELETE SET NULL,
	
	CONSTRAINT CK_PRECO_PARTIDA CHECK(PRECO >= 0)
	
	
);


/* tabela da rela��o PartidaTime*/


CREATE TABLE PARTIDA_TIME(
	PARTIDA VARCHAR(5),
	ID_TIME NUMBER(4),
	
	CONSTRAINT PK_PARTIDA_TIME PRIMARY KEY (PARTIDA,ID_TIME),
	CONSTRAINT FK_PARTIDA_TIME_P FOREIGN KEY (PARTIDA) REFERENCES PARTIDA(CODIGO_PARTIDA) ON DELETE CASCADE,
	CONSTRAINT FK_PARTIDA_TIME_T FOREIGN KEY (ID_TIME) REFERENCES TIME(ID_TIME) ON DELETE CASCADE

);

/*tabela ponto turistico*/
CREATE TABLE PONTO_TURISTICO(
	NOME VARCHAR(20),
	CODIGO_POSTAL VARCHAR(11),
	TIPO VARCHAR(10) NOT NULL,
	PRECO NUMBER(4,2) NOT NULL,
	DESCRICAO VARCHAR(100) NOT NULL,
	
	/*armazena o caminho para a imagem no servidor*/
	FOTO VARCHAR(20),
	
	UF CHAR(2),
	CIDADE VARCHAR(30) NOT NULL,
	BAIRRO VARCHAR(30),
	LOGRADOURO VARCHAR(30) NOT NULL,
	NUMERO VARCHAR(5) NOT NULL,
	COMPLEMENTO VARCHAR(5),
	PONTO_DE_REFERENCIA VARCHAR(30),
	PAIS VARCHAR(20) NOT NULL,
	
	
	NOME_ESPORTERELACIONADO VARCHAR(30),
	ID_CLUBE NUMBER(4),
	
	CONSTRAINT PK_PONTO PRIMARY KEY(NOME,CODIGO_POSTAL),
	CONSTRAINT FK_PONTO_ESPORTE FOREIGN KEY(NOME_ESPORTERELACIONADO) REFERENCES ESPORTE(NOME),
	CONSTRAINT FK_PONTO_CLUBE FOREIGN KEY(ID_CLUBE) REFERENCES CLUBE(ID_CLUBE),
	
	CONSTRAINT CK_PRECO_PONTO CHECK(PRECO >= 0),
	
	/*para garantir que o tipo seja clube ou esporte e garantir que a chave certa � preenchida*/
	/* testar isso */
	CONSTRAINT CK_ESPECIALIZACAO CHECK((UPPER(TIPO) = 'ESPORTE' AND NOME_ESPORTERELACIONADO IS NOT NULL AND ID_CLUBE IS NULL) OR (UPPER(TIPO) = 'CLUBE' AND NOME_ESPORTERELACIONADO IS NULL AND ID_CLUBE IS NOT NULL))
	
);


/* tabela treinadores de um time */
/* aqui eu alterei a chave prim�ria pois �amos ter problemas de inconsist�ncia,
 * alterar no projeto l�gico
 */
CREATE TABLE TREINADORES_TIME(
	CPF VARCHAR(11),
	NOME VARCHAR(30),
	ID_TIME NUMBER(4) NOT NULL,
	
	CONSTRAINT PK_TREINADORES PRIMARY KEY(CPF),
	CONSTRAINT FK_TREINA_TIME FOREIGN KEY(ID_TIME) REFERENCES TIME(ID_TIME) ON DELETE CASCADE,
    CONSTRAINT CK_TREINADOR_CPF CHECK(REGEXP_LIKE(CPF, '[0-9]{11}'))

);


/* tabela atletas time */
/* mesma altera��o da anterior*/
/* conferir cpf no regex */

CREATE TABLE ATLETA_TIME(
	CPF VARCHAR(11),
	NOME VARCHAR(30),
	ID_TIME NUMBER(4) NOT NULL,
	NASCIMENTO DATE,
	/*em metros*/
	ALTURA NUMBER(3,2),
	/*em kgs*/
	PESO NUMBER(4,1),
	
	CONSTRAINT PK_ATLETAS PRIMARY KEY(CPF),
	CONSTRAINT FK_ATLETA_TIME FOREIGN KEY(ID_TIME) REFERENCES TIME(ID_TIME) ON DELETE CASCADE,
    CONSTRAINT CK_ATLETA_CPF CHECK(REGEXP_LIKE(CPF, '[0-9]{11}'))
);


/* tabela usuario acompanha esporte */
CREATE TABLE USUARIO_ACOMPANHA_ESPORTE(
	USUARIO VARCHAR(15),
	ESPORTE VARCHAR(30),
	
	CONSTRAINT PK_USUARIO_ACOMPANHA PRIMARY KEY(USUARIO,ESPORTE),
	CONSTRAINT FK_USUARIO_ACOMPANHA_U FOREIGN KEY(USUARIO) REFERENCES USUARIO(NICKNAME) ON DELETE CASCADE ,
	CONSTRAINT FK_USUARIO_ACOMPANHA_E FOREIGN KEY(ESPORTE) REFERENCES ESPORTE(NOME) ON DELETE CASCADE 
);

/* tabela usu�rio torce   */
CREATE TABLE USUARIO_TORCE(
	USUARIO VARCHAR(15),
	ID_TIME NUMBER(4),
	
	CONSTRAINT PK_USUARIO_TORCE PRIMARY KEY(USUARIO,ID_TIME),
	CONSTRAINT FK_USUARIO_TORCE_U FOREIGN KEY(USUARIO) REFERENCES USUARIO(NICKNAME) ON DELETE CASCADE ,
	CONSTRAINT FK_USUARIO_TORCE_C FOREIGN KEY(ID_TIME) REFERENCES TIME(ID_TIME) ON DELETE CASCADE
);


/*tabela roteiro ponto turistico*/
CREATE TABLE ROTEIROPONTO_TURISTICO(
	AUTOR_ROTEIRO VARCHAR(15),
	NOME_ROTEIRO VARCHAR(11),
	NOME_PONTO VARCHAR(20),
	CODIGO_POSTALPONTO VARCHAR(11),
	
	/*mudar no esquema*/
	QTD_INGRESSOS NUMBER(2),
	
	CONSTRAINT PK_ROTEIRO_PONTO_TURISTICO PRIMARY KEY(AUTOR_ROTEIRO,NOME_ROTEIRO,NOME_PONTO,CODIGO_POSTALPONTO),
	CONSTRAINT FK_ROTEIRO_PONTO_R FOREIGN KEY (AUTOR_ROTEIRO,NOME_ROTEIRO) REFERENCES ROTEIRO_VIAGEM(AUTOR,NOME_ROTEIRO) ON DELETE CASCADE,
	CONSTRAINT FK_ROTEIRO_PONTO_P FOREIGN KEY (NOME_PONTO,CODIGO_POSTALPONTO) REFERENCES PONTO_TURISTICO(NOME,CODIGO_POSTAL) ON DELETE CASCADE,
	
	CONSTRAINT CK_QTD_ROTEIRO CHECK( QTD_INGRESSOS >=1 )

	
);

CREATE TABLE ROTEIRO_TRANSPORTE(
	AUTOR_ROTEIRO VARCHAR(15),
	NOME_ROTEIRO VARCHAR(11),
	NOME_EMPRESA_TRANSPORTE VARCHAR(20),
	CODIGO_POSTALORIGEM VARCHAR(11),
	CODIGO_POSTALDESTINO VARCHAR(11),
	
	/*mudar no esquema*/
	QTD_INGRESSOS NUMBER(2),
	
	CONSTRAINT PK_ROTEIRO_TRANSPORTE PRIMARY KEY(AUTOR_ROTEIRO,NOME_ROTEIRO, NOME_EMPRESA_TRANSPORTE, CODIGO_POSTALORIGEM , CODIGO_POSTALDESTINO),
	CONSTRAINT FK_ROTEIRO_TRANSPORTE_R FOREIGN KEY (AUTOR_ROTEIRO,NOME_ROTEIRO) REFERENCES ROTEIRO_VIAGEM(AUTOR,NOME_ROTEIRO) ON DELETE CASCADE,
	CONSTRAINT FK_ROTEIRO_TRANSPORTE_T FOREIGN KEY (NOME_EMPRESA_TRANSPORTE,CODIGO_POSTALORIGEM,CODIGO_POSTALDESTINO) REFERENCES TRANSPORTE(NOME_DA_EMPRESA,CODIGO_POSTALORIGEM,CODIGO_POSTALDESTINO) ON DELETE CASCADE,
	CONSTRAINT CK_QTD_ROTEIRO_T CHECK( QTD_INGRESSOS >=1 )

);

CREATE TABLE ROTEIRO_HOSPEDAGEM(
	AUTOR_ROTEIRO VARCHAR(15),
	NOME_ROTEIRO VARCHAR(11),
	NOME_HOSPEDAGEM VARCHAR(20),
	CODIGO_POSTAL VARCHAR(11),
	
	/*mudar no esquema*/
	QTD_INGRESSOS NUMBER(2),
	
	CONSTRAINT PK_ROTEIRO_HOSPEDAGEM PRIMARY KEY(AUTOR_ROTEIRO,NOME_ROTEIRO, NOME_HOSPEDAGEM, CODIGO_POSTAL),
	CONSTRAINT FK_ROTEIRO_HOSPEDAGEM_R FOREIGN KEY (AUTOR_ROTEIRO,NOME_ROTEIRO) REFERENCES ROTEIRO_VIAGEM(AUTOR,NOME_ROTEIRO) ON DELETE CASCADE,
	CONSTRAINT FK_ROTEIRO_HOSPEDAGEM_H FOREIGN KEY (NOME_HOSPEDAGEM,CODIGO_POSTAL) REFERENCES HOSPEDAGEM(NOME,CODIGO_POSTAL) ON DELETE CASCADE,
	CONSTRAINT CK_QTD_ROTEIRO_H CHECK( QTD_INGRESSOS >=1 )

);

CREATE TABLE ROTEIRO_PARTIDA(
	AUTOR_ROTEIRO VARCHAR(15),
	NOME_ROTEIRO VARCHAR(11),
	PARTIDA VARCHAR(5),
	
	/*mudar no esquema*/
	QTD_INGRESSOS NUMBER(2),
	
	CONSTRAINT PK_ROTEIRO_PARTIDA PRIMARY KEY(AUTOR_ROTEIRO,NOME_ROTEIRO, PARTIDA),
	CONSTRAINT FK_ROTEIRO_PARTIDA_R FOREIGN KEY (AUTOR_ROTEIRO,NOME_ROTEIRO) REFERENCES ROTEIRO_VIAGEM(AUTOR,NOME_ROTEIRO) ON DELETE CASCADE,
	CONSTRAINT FK_ROTEIRO_PARTIDA_P FOREIGN KEY (PARTIDA) REFERENCES PARTIDA(CODIGO_PARTIDA) ON DELETE CASCADE,
	CONSTRAINT CK_QTD_ROTEIRO_P CHECK( QTD_INGRESSOS >=1 )
);
