INSERT INTO ESPORTE (NOME, DESCRICAO) VALUES ('Futebol', 'O futebol � o esporte coletivo mais praticado do mundo. � disputado por duas equipes, de 11 jogadores que t�m como objetivo colocar a bola entre as traves advers�rias o maior n�mero de vezes sem usar m�os e bra�os.');
INSERT INTO ESPORTE (NOME, DESCRICAO) VALUES ('Basquetebol', 'O jogo � disputado por duas equipes de cinco jogadores que tem por objetivo passar a bola por dentro do cesto disposto nas extremidades do campo. Os cestos ficam a uma altura de tr�s metros e cinco cent�metros. Os jogadores batem a bola contra o ch�o caminhando dentro do campo, podendo repass�-la a um jogador da equipe. '); 


INSERT INTO CAMPEONATO (NOME, ANO, ORGANIZADOR) VALUES ('Copa do Mundo', '2022', 'Fifa');
INSERT INTO CAMPEONATO (NOME, ANO, ORGANIZADOR) VALUES ('Mundial de Clubes', '2021', 'Fifa');


INSERT INTO USUARIO (NICKNAME, EMAIL, NOME, CPF, SENHA) VALUES ('LeoF', 'leo@hotmail.com', 'Leonardo', '10236958966', '123456789');
INSERT INTO USUARIO (NICKNAME, EMAIL, NOME, CPF, SENHA) VALUES ('Cleiton', 'cleiton@hotmail.com', 'Cleiton', '10236958967', '123456789');

INSERT INTO CLUBE (idClube, cadastroEmpresarial, pais, uf, nomeDoClube, cor1, cor2,	cor3) VALUES (seq_id_clube.NEXTVAL, '00000000000', 'Brasil', 'SP', 'S�o Paulo', 'Vermelho', 'Preto', 'Branco' );
INSERT INTO CLUBE (idClube, cadastroEmpresarial, pais, nomeDoClube, cor1, cor2, cor3) VALUES (seq_id_clube.nextval, '00000000001', 'Inglaterra', 'Liverpool', 'Vermelho', 'Branco', 'Verde');
INSERT INTO CLUBE (idClube, cadastroEmpresarial, pais, nomeDoClube, cor1, cor2) VALUES (seq_id_clube.nextval, '00000000002', 'Alemanha', 'Bayern', 'Vermelho', 'Branco');

INSERT INTO ROTEIROVIAGEM (AUTOR, NOME_ROTEIRO, DESCRICAO) VALUES ('LeoF', 'Roteiro 1', 'Roteiro legal');
INSERT INTO ROTEIROVIAGEM (AUTOR, NOME_ROTEIRO, DESCRICAO) VALUES ('LeoF', 'Roteiro 2', 'Roteiro chato');

INSERT INTO HOSPEDAGEM (NOME, CODIGOPOSTAL, PRECO, UF, CIDADE, LOGRADOURO, NUMERO, PAIS) VALUES ('Gate Hotel', '97301', '500.00', 'OR', 'Salem', 'Gateway Road', '1472', 'Estados Unidos');
INSERT INTO HOSPEDAGEM (NOME, CODIGOPOSTAL, PRECO, CIDADE, LOGRADOURO, NUMERO, PAIS) VALUES ('Faulkner Resort', 'DL11 3XR', '1000.00', 'Langthwaite', 'Roker Terrace', '75', 'Inglaterra');

INSERT INTO TRANSPORTE (NOMEDAEMPRESA, CODIGOPOSTALORIGEM, CODIGOPOSTALDESTINO, PRECO, ORIGEMUF, ORIGEMCIDADE, ORIGEMLOGRADOURO, ORIGEMNUMERO, ORIGEMPAIS, DESTINOCIDADE, DESTINOLOGRADOURO, DESTINONUMERO, DESTINOPAIS) VALUES ('American Airlines', '97301', 'DL11 3XR', '99.99', 'OR', 'Salem', 'Gateway Road', '1472', 'Estados Unidos', 'Langthwaite', 'Roker Terrace', '75', 'Inglaterra');
INSERT INTO TRANSPORTE (NOMEDAEMPRESA, CODIGOPOSTALORIGEM, CODIGOPOSTALDESTINO, PRECO, ORIGEMUF, ORIGEMCIDADE, ORIGEMLOGRADOURO, ORIGEMNUMERO, ORIGEMPAIS, DESTINOCIDADE, DESTINOLOGRADOURO, DESTINONUMERO, DESTINOPAIS) VALUES ('American Airlines', '2113', 'DL11 3XR', '99.99', 'NS', 'Macquarie Centre', 'Cecil Street', '135', 'Australia', 'Langthwaite', 'Roker Terrace', '75', 'Inglaterra');

INSERT INTO TIME (IDTIME, NOMEFANTASIA, CATEGORIA, IDCLUBE, NOMEESPORTE) VALUES (seq_id_time.nextval, 'S�o Paulo FC', 'Profissional', '1', 'Futebol');
INSERT INTO TIME (IDTIME, NOMEFANTASIA, CATEGORIA, IDCLUBE, NOMEESPORTE) VALUES (seq_id_time.nextval, 'Liverpool FC', 'Profissional', '2', 'Futebol');
INSERT INTO TIME (IDTIME, NOMEFANTASIA, CATEGORIA, IDCLUBE, NOMEESPORTE) VALUES (seq_id_time.nextval, 'Basquetebol do S�o Paulo ', 'Profissional', '1', 'Basquetebol');

INSERT INTO PARTIDA (CODIGOPARTIDA, JUIZ, DATA, PRECO, CIDADE, LOGRADOURO, NUMERO, PAIS, NOMECAMPEONATO, ANOCAMPEONATO) VALUES ('1', 'Marcelo Luiz', TO_DATE('2021-12-21', 'YYYY-MM-DD'), '60.00', 'Londres', 'Royal RTE', '200', 'Inglaterra', 'Mundial de Clubes','2021');
INSERT INTO PARTIDA (CODIGOPARTIDA, JUIZ, DATA, PRECO, CIDADE, LOGRADOURO, NUMERO, PAIS, NOMECAMPEONATO, ANOCAMPEONATO) VALUES ('2', 'Will Smith', TO_DATE('2021-12-28', 'YYYY-MM-DD'), '60.00', 'Londres', 'Royal RTE', '200', 'Inglaterra', 'Mundial de Clubes','2021');


INSERT INTO PARTIDATIME (PARTIDA, IDTIME) VALUES ('1', '1');
INSERT INTO PARTIDATIME (PARTIDA, IDTIME) VALUES ('1', '2');
INSERT INTO PARTIDATIME (PARTIDA, IDTIME) VALUES ('2', '1');
INSERT INTO PARTIDATIME (PARTIDA, IDTIME) VALUES ('2', '2');

INSERT INTO PONTOTURISTICO (NOME, CODIGOPOSTAL, TIPO, PRECO, DESCRICAO, CIDADE, LOGRADOURO, NUMERO, PAIS, NOMEESPORTERELACIONADO) VALUES ('Estadio de Wembley', 'HA9 0WS', 'ESPORTE', '50', 'Um dos estadios mais famosos do mundo',  'Londres', 'South Way', '200', 'Inglaterra', 'Futebol');
INSERT INTO PONTOTURISTICO (NOME, CODIGOPOSTAL, TIPO, PRECO, DESCRICAO, CIDADE, LOGRADOURO, NUMERO, PAIS, IDCLUBE) VALUES ('Allianz Arena', '80939', 'CLUBE', '70', 'Um dos estadios mais bonitos do mundo',  'Munique', 'Werner-Heisenberg-Allee', '25', 'Alemanha', '3');
INSERT INTO PONTOTURISTICO (NOME, CODIGOPOSTAL, TIPO, PRECO, DESCRICAO, CIDADE, LOGRADOURO, NUMERO, PAIS, NOMEESPORTERELACIONADO,bairro) VALUES ('Rucker Park', '10039', 'ESPORTE', '30', 'Quadra de rua lend�ria para o basquete nos EUA, onde jogaram nomes como Kobe e Durant',  'Nova Iorque', 'Harlem River Drive', '2', 'EUA', 'Basquetebol','Harlem');

INSERT INTO TREINADORESTIME (CPF, NOME, IDTIME) VALUES ('36589765632', 'Hernan Crespo', '1');
INSERT INTO TREINADORESTIME (CPF, NOME, IDTIME) VALUES ('45585565625', 'Jurgen Klopp', '2');

INSERT INTO ATLETATIME (CPF, NOME, IDTIME, NASCIMENTO, ALTURA, PESO) VALUES ('58796585635', 'Daniel Alves', '1', TO_DATE('1983-05-06', 'YYYY-MM-DD'), '1.72', '70.0');
INSERT INTO ATLETATIME (CPF, NOME, IDTIME, NASCIMENTO, ALTURA, PESO) VALUES ('43786587775', 'Roberto Firmino', '2', TO_DATE('1991-10-02', 'YYYY-MM-DD'), '1.81', '76.0');
INSERT INTO ATLETATIME (CPF, NOME, IDTIME, NASCIMENTO, ALTURA, PESO) VALUES ('58796585637', 'Georginho de Paula', '3', TO_DATE('1996-05-24', 'YYYY-MM-DD'), '1.97', '96.0');
INSERT INTO ATLETATIME (CPF, NOME, IDTIME, NASCIMENTO, ALTURA, PESO) VALUES ('58796585633', 'Tiago Volpi', '1', TO_DATE('1990-12-19', 'YYYY-MM-DD'), '1.88', '85.0');

INSERT INTO USUARIOACOMPANHAESPORTE (USUARIO, ESPORTE) VALUES ('LeoF', 'Futebol');
INSERT INTO USUARIOACOMPANHAESPORTE (USUARIO, ESPORTE) VALUES ('LeoF', 'Basquetebol');
INSERT INTO USUARIOACOMPANHAESPORTE (USUARIO, ESPORTE) VALUES ('Cleiton', 'Futebol');

INSERT INTO USUARIOTORCE (USUARIO, IDTIME) VALUES ('LeoF', '1');
INSERT INTO USUARIOTORCE (USUARIO, IDTIME) VALUES ('Cleiton', '2');

INSERT INTO ROTEIROPONTOTURISTICO (AUTORROTEIRO, NOMEROTEIRO, NOMEPONTO, CODIGOPOSTALPONTO, QTDINGRESSOS) VALUES ('LeoF', 'Roteiro 1', 'Allianz Arena', '80939', '1');
INSERT INTO ROTEIROPONTOTURISTICO (AUTORROTEIRO, NOMEROTEIRO, NOMEPONTO, CODIGOPOSTALPONTO, QTDINGRESSOS) VALUES ('LeoF', 'Roteiro 1', 'Estadio de Wembley', 'HA9 0WS', '2');



INSERT INTO ROTEIROTRANSPORTE (AUTORROTEIRO, NOMEROTEIRO, NOMEEMPRESATRANSPORTE, CODIGOPOSTALORIGEM, CODIGOPOSTALDESTINO, QTDINGRESSOS) VALUES ('LeoF', 'Roteiro 1', 'American Airlines', '97301', 'DL11 3XR', '1');
INSERT INTO ROTEIROTRANSPORTE (AUTORROTEIRO, NOMEROTEIRO, NOMEEMPRESATRANSPORTE, CODIGOPOSTALORIGEM, CODIGOPOSTALDESTINO, QTDINGRESSOS) VALUES ('LeoF', 'Roteiro 2', 'American Airlines', '97301', 'DL11 3XR', '1');

INSERT INTO ROTEIROPARTIDA (AUTORROTEIRO, NOMEROTEIRO, PARTIDA, QTDINGRESSOS) VALUES ('LeoF', 'Roteiro 1', '1', '1');
INSERT INTO ROTEIROPARTIDA (AUTORROTEIRO, NOMEROTEIRO, PARTIDA, QTDINGRESSOS) VALUES ('LeoF', 'Roteiro 1', '2', '3');


COMMIT;