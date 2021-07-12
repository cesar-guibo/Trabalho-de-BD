
/* Limpando o DB   */

/*

SELECT 'drop table ' || table_name||' cascade constraints;' FROM user_tables; 
SELECT 'drop sequence ' || sequence_name FROM user_sequences;
*/


/* tabela esporte */
CREATE TABLE ESPORTE (
	nome varchar(30),
	descricao varchar(500),
	
	CONSTRAINT PK_ESPORTE PRIMARY KEY(nome)
);

/* tabela campeonato */
CREATE TABLE CAMPEONATO(
	nome varchar(30),
	ano number(4) DEFAULT 2021,
	organizador varchar(30),
	
	CONSTRAINT PK_CAMPEONATO PRIMARY KEY(nome,ano),
	CONSTRAINT CK_ANO_VALIDO CHECK(ano>2015)
);

/* tabela usuário*/
CREATE TABLE USUARIO(
	nickname varchar(15),
	email varchar(50) NOT NULL,
	nome varchar(50) NOT NULL,
	cpf char(11) NOT NULL,
	senha varchar(20) NOT NULL,
	
	CONSTRAINT PK_USUARIO PRIMARY KEY(nickname),
	CONSTRAINT UN_USUARIO_CPF UNIQUE(cpf),
    CONSTRAINT CK_USUARIO_CPF CHECK(REGEXP_LIKE(CPF, '[0-9]{11}'))
);

CREATE SEQUENCE seq_id_clube
MINVALUE 0
START WITH 0
INCREMENT BY 1
CACHE 20;

/* tabela clube */
CREATE TABLE CLUBE(
	idClube NUMBER(4),
	cadastroEmpresarial varchar(11) NOT NULL,
	pais varchar(20) NOT NULL,
	uf char(2),
	nomeDoClube varchar(30) NOT NULL,
	cor1 varchar(15) NOT NULL ,
	cor2 varchar(15),
	cor3 varchar(15),
	
	
	CONSTRAINT PK_CLUBE PRIMARY KEY(idClube),
	CONSTRAINT UN_CLUBE UNIQUE(cadastroEmpresarial,pais,uf),
    CONSTRAINT CK_CLUBE_CNPJ CHECK(REGEXP_LIKE(cadastroEmpresarial, '[0-9]{11}'))
);

/* tabela roteiro de viagem */
/* achei q fica melhor trocar roteiro codigo roteiro para nome roteiro */
/* Acho melhor manter codigo */

CREATE TABLE RoteiroViagem(
	autor varchar(15),
	nome_roteiro varchar(11),
	descricao varchar (150),
	
	/*preco NUMBER(4,2), devemos por preço total do roteiro ? */
	
	CONSTRAINT PK_ROTEIRO_VIAGEM PRIMARY KEY(autor,nome_roteiro),
	CONSTRAINT FK_ROTEIRO FOREIGN KEY (autor) REFERENCES USUARIO(nickname) ON DELETE CASCADE 
);

/* tabela hospedagem */
CREATE TABLE Hospedagem(
	nome varchar(20), 
	codigoPostal varchar(11),
	preco NUMBER(7,2) NOT NULL ,
	uf char(2),
	cidade varchar(30) NOT NULL,
	bairro varchar(30),
	logradouro varchar(30) NOT NULL,
	numero varchar(5) NOT NULL,
	complemento varchar(5),
	pontoDeReferencia varchar(30),
	pais varchar(20) NOT NULL,
	
	CONSTRAINT PK_HOSPEDAGEM PRIMARY KEY(nome,codigoPostal),
	
	/*conferindo se o preço é maior que zero */
	CONSTRAINT CK_PRECO_HOSPEDAGEM CHECK(preco >= 0.0)
	
);


/*tabela transporte */
/*fazer conferência com regex para codigoPostal ser numero */
CREATE TABLE Transporte(
	nomeDaEmpresa varchar(20),
	codigoPostalOrigem varchar(11),
	codigoPostalDestino varchar(11),
	preco NUMBER(6,2) NOT NULL,
	
	
	origemUf char(2),
	origemCidade varchar(30) NOT NULL,
	origemBairro varchar(30),
	origemLogradouro varchar(30) NOT NULL,
	origemNumero varchar(5) NOT NULL,
	origemComplemento varchar(5),
	origemPontoDeReferencia varchar(30),
	origemPais varchar(20) NOT NULL,
	
	destinoUf char(2),
	destinoCidade varchar(30) NOT NULL,
	destinoBairro varchar(30),
	destinoLogradouro varchar(30) NOT NULL,
	destinoNumero varchar(5) NOT NULL,
	destinoComplemento varchar(5),
	destinoPontoDeReferencia varchar(30),
	destinoPais varchar(20) NOT NULL,
	
	CONSTRAINT PK_TRANSPORTE PRIMARY KEY(nomeDaEmpresa,codigoPostalOrigem,codigoPostalDestino),
	
	/* confere se o codigo postal da origem é diferente do destino */
	CONSTRAINT CK_CPOrigem_CPDestino CHECK( codigoPostalOrigem != codigoPostalDestino ),
	
	/*confere se o preço é maior que zero */
	
	CONSTRAINT CK_PRECO_TRANSPORTE CHECK(preco >= 0)
);

/*tabela time*/
CREATE TABLE TIME(
	idTime NUMBER(4),
	nomeFantasia varchar(30) NOT NULL,
	categoria varchar(15) NOT NULL,
	idClube number(4) NOT NULL,
	nomeEsporte varchar(30) NOT NULL,
	
	CONSTRAINT PK_TIME PRIMARY KEY(idTime),
	CONSTRAINT UN_TIME UNIQUE(nomeFantasia,categoria,idClube,nomeEsporte)
);

CREATE SEQUENCE seq_id_time
MINVALUE 0
START WITH 0
INCREMENT BY 1
CACHE 20;


/* tabela partida */

/* fazer check do tipo de codigo partida*/
CREATE TABLE Partida(
	codigoPartida varchar(5),
	juiz varchar(20),
	DATA DATE NOT NULL,
	preco number(6,2) NOT NULL,
	
	uf char(2),
	cidade varchar(30) NOT NULL,
	bairro varchar(30),
	logradouro varchar(30) NOT NULL,
	numero varchar(5) NOT NULL,
	complemento varchar(5),
	pontoDeReferencia varchar(30),
	pais varchar(20) NOT NULL,
	
	
	nomeCampeonato varchar(30),
	anoCampeonato number(4) DEFAULT 2021,
	
	CONSTRAINT PK_PARTIDA PRIMARY KEY(codigoPartida),
	CONSTRAINT FK_PARTIDA_CAMPEONATO FOREIGN KEY(nomeCampeonato,anoCampeonato) REFERENCES Campeonato(nome,ano) ON DELETE SET NULL,
	
	CONSTRAINT CK_PRECO_PARTIDA CHECK(preco >= 0)
	
	
);


/* tabela da relação PartidaTime*/


CREATE TABLE PartidaTime(
	partida varchar(5),
	idTime number(4),
	
	CONSTRAINT PK_PARTIDA_TIME PRIMARY KEY (partida,idTime),
	CONSTRAINT FK_PARTIDA_TIME_P FOREIGN KEY (partida) REFERENCES Partida(codigoPartida) ON DELETE CASCADE,
	CONSTRAINT FK_PARTIDA_TIME_T FOREIGN KEY (idTime) REFERENCES Time(idTime) ON DELETE CASCADE

);

/*tabela ponto turistico*/
CREATE TABLE PontoTuristico(
	nome varchar(20),
	codigoPostal varchar(11),
	tipo varchar(10) NOT NULL,
	preco number(4,2) NOT NULL,
	descricao varchar(100) NOT NULL,
	
	/*armazena o caminho para a imagem no servidor*/
	foto varchar(20),
	
	uf char(2),
	cidade varchar(30) NOT NULL,
	bairro varchar(30),
	logradouro varchar(30) NOT NULL,
	numero varchar(5) NOT NULL,
	complemento varchar(5),
	pontoDeReferencia varchar(30),
	pais varchar(20) NOT NULL,
	
	
	nomeEsporteRelacionado varchar(30),
	idClube NUMBER(4),
	
	CONSTRAINT PK_PONTO PRIMARY KEY(nome,codigoPostal),
	CONSTRAINT FK_PONTO_ESPORTE FOREIGN KEY(nomeEsporteRelacionado) REFERENCES Esporte(nome),
	CONSTRAINT FK_PONTO_CLUBE FOREIGN KEY(idClube) REFERENCES Clube(idClube),
	
	CONSTRAINT CK_PRECO_PONTO CHECK(preco >= 0),
	
	/*para garantir que o tipo seja clube ou esporte e garantir que a chave certa é preenchida*/
	/* testar isso */
	CONSTRAINT CK_ESPECIALIZACAO CHECK((upper(tipo) = 'ESPORTE' AND nomeEsporteRelacionado IS NOT NULL AND idClube IS NULL) OR (upper(tipo) = 'CLUBE' AND nomeEsporteRelacionado IS NULL AND idClube IS NOT NULL))
	
);


/* tabela treinadores de um time */
/* aqui eu alterei a chave primária pois íamos ter problemas de inconsistência,
 * alterar no projeto lógico
 */
CREATE TABLE TreinadoresTime(
	cpf varchar(11),
	nome varchar(30),
	idTime number(4) NOT NULL,
	
	CONSTRAINT PK_TREINADORES PRIMARY KEY(cpf),
	CONSTRAINT FK_TREINA_TIME FOREIGN KEY(idTime) REFERENCES Time(idTime) ON DELETE CASCADE,
    CONSTRAINT CK_TREINADOR_CPF CHECK(REGEXP_LIKE(CPF, '[0-9]{11}'))

);


/* tabela atletas time */
/* mesma alteração da anterior*/
/* conferir cpf no regex */

CREATE TABLE AtletaTime(
	cpf varchar(11),
	nome varchar(30),
	idTime number(4) NOT NULL,
	nascimento DATE,
	/*em metros*/
	altura number(3,2),
	/*em kgs*/
	peso number(4,1),
	
	CONSTRAINT PK_ATLETAS PRIMARY KEY(cpf),
	CONSTRAINT FK_ATLETA_TIME FOREIGN KEY(idTime) REFERENCES Time(idTime) ON DELETE CASCADE,
    CONSTRAINT CK_ATLETA_CPF CHECK(REGEXP_LIKE(CPF, '[0-9]{11}'))
);


/* tabela usuario acompanha esporte */
CREATE TABLE UsuarioAcompanhaEsporte(
	usuario varchar(15),
	esporte varchar(30),
	
	CONSTRAINT PK_USUARIO_ACOMPANHA PRIMARY KEY(usuario,esporte),
	CONSTRAINT FK_USUARIO_ACOMPANHA_U FOREIGN KEY(usuario) REFERENCES Usuario(nickname) ON DELETE CASCADE ,
	CONSTRAINT FK_USUARIO_ACOMPANHA_E FOREIGN KEY(esporte) REFERENCES Esporte(nome) ON DELETE CASCADE 
);

/* tabela usuário torce   */
CREATE TABLE UsuarioTorce(
	usuario varchar(15),
	idTime number(4),
	
	CONSTRAINT PK_USUARIO_TORCE PRIMARY KEY(usuario,idTime),
	CONSTRAINT FK_USUARIO_TORCE_U FOREIGN KEY(usuario) REFERENCES Usuario(nickname) ON DELETE CASCADE ,
	CONSTRAINT FK_USUARIO_TORCE_C FOREIGN KEY(idTime) REFERENCES Time(idTime) ON DELETE CASCADE
);


/*tabela roteiro ponto turistico*/
CREATE TABLE RoteiroPontoTuristico(
	autorRoteiro varchar(15),
	nomeRoteiro varchar(11),
	nomePonto varchar(20),
	codigoPostalPonto varchar(11),
	
	/*mudar no esquema*/
	qtdIngressos number(2),
	
	CONSTRAINT PK_ROTEIRO_PONTO_TURISTICO PRIMARY KEY(autorRoteiro,nomeRoteiro,nomePonto,codigoPostalPonto),
	CONSTRAINT FK_ROTEIRO_PONTO_R FOREIGN KEY (autorRoteiro,nomeRoteiro) REFERENCES RoteiroViagem(autor,nome_roteiro) ON DELETE CASCADE,
	CONSTRAINT FK_ROTEIRO_PONTO_P FOREIGN KEY (nomePonto,codigoPostalPonto) REFERENCES PontoTuristico(nome,codigoPostal) ON DELETE CASCADE,
	
	CONSTRAINT CK_QTD_ROTEIRO CHECK( qtdIngressos >=1 )

	
);

CREATE TABLE RoteiroTransporte(
	autorRoteiro varchar(15),
	nomeRoteiro varchar(11),
	nomeEmpresaTransporte varchar(20),
	codigoPostalOrigem varchar(11),
	codigoPostalDestino varchar(11),
	
	/*mudar no esquema*/
	qtdIngressos number(2),
	
	CONSTRAINT PK_ROTEIRO_TRANSPORTE PRIMARY KEY(autorRoteiro,nomeRoteiro, nomeEmpresaTransporte, codigoPostalOrigem , codigoPostalDestino),
	CONSTRAINT FK_ROTEIRO_TRANSPORTE_R FOREIGN KEY (autorRoteiro,nomeRoteiro) REFERENCES RoteiroViagem(autor,nome_roteiro) ON DELETE CASCADE,
	CONSTRAINT FK_ROTEIRO_TRANSPORTE_T FOREIGN KEY (nomeEmpresaTransporte,codigoPostalOrigem,codigoPostalDestino) REFERENCES Transporte(nomeDaEmpresa,codigoPostalOrigem,codigoPostalDestino) ON DELETE CASCADE,
	CONSTRAINT CK_QTD_ROTEIRO_T CHECK( qtdIngressos >=1 )

);

CREATE TABLE RoteiroPartida(
	autorRoteiro varchar(15),
	nomeRoteiro varchar(11),
	partida varchar(5),
	
	/*mudar no esquema*/
	qtdIngressos number(2),
	
	CONSTRAINT PK_ROTEIRO_PARTIDA PRIMARY KEY(autorRoteiro,nomeRoteiro, partida),
	CONSTRAINT FK_ROTEIRO_PARTIDA_R FOREIGN KEY (autorRoteiro,nomeRoteiro) REFERENCES RoteiroViagem(autor,nome_roteiro) ON DELETE CASCADE,
	CONSTRAINT FK_ROTEIRO_PARTIDA_P FOREIGN KEY (partida) REFERENCES Partida(codigoPartida) ON DELETE CASCADE,
	CONSTRAINT CK_QTD_ROTEIRO_P CHECK( qtdIngressos >=1 )
);
