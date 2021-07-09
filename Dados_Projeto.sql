INSERT INTO ESPORTE (NOME, DESCRICAO) VALUES ('FUTEBOL', 'O futebol � o esporte coletivo mais praticado do mundo. � disputado por duas equipes, de 11 jogadores que t�m como objetivo colocar a bola entre as traves advers�rias o maior n�mero de vezes sem usar m�os e bra�os.');
INSERT INTO ESPORTE (NOME, DESCRICAO) VALUES ('BASQUETEBOL', 'O jogo � disputado por duas equipes de cinco jogadores que tem por objetivo passar a bola por dentro do cesto disposto nas extremidades do campo. Os cestos ficam a uma altura de tr�s metros e cinco cent�metros. Os jogadores batem a bola contra o ch�o caminhando dentro do campo, podendo repass�-la a um jogador da equipe. ');                                              



INSERT INTO CAMPEONATO (NOME, ANO, ORGANIZADOR) VALUES ('Copa do Mundo', '2022', 'Fifa');
INSERT INTO CAMPEONATO (NOME, ANO, ORGANIZADOR) VALUES ('Campeonato Brasileiro', '2021', 'CBF');


INSERT INTO USUARIO (NICKNAME, EMAIL, NOME, CPF, SENHA) VALUES ('LeoF', 'leo@hotmail.com', 'Leonardo', '10236958966', '123456789');
INSERT INTO USUARIO (NICKNAME, EMAIL, NOME, CPF, SENHA) VALUES ('Cleiton', 'cleiton@hotmail.com', 'Cleiton', '10236958967', '123456789');

INSERT INTO CLUBE (idClube, cadastroEmpresarial, pais, uf, nomeDoClube, cor1, cor2,	cor3) VALUES ('1', '00000000000', 'Brasil', 'SP', 'S�o Paulo FC', 'Vermelho', 'Preto', 'Branco' );
INSERT INTO CLUBE (idClube, cadastroEmpresarial, pais, uf, nomeDoClube, cor1, cor2) VALUES ('2', '00000000001', 'Brasil', 'SP', 'SE Palmeiras', 'Verde', 'Branco');

INSERT INTO ROTEIROVIAGEM (AUTOR, NOME_ROTEIRO, DESCRICAO) VALUES ('LeoF', 'Roteiro 1', 'Roteiro legal');
INSERT INTO ROTEIROVIAGEM (AUTOR, NOME_ROTEIRO, DESCRICAO) VALUES ('LeoF', 'Roteiro 2', 'Roteiro chato');

INSERT INTO HOSPEDAGEM (NOME, CODIGOPOSTAL, PRECO, UF, CIDADE, BAIRRO, LOGRADOURO, NUMERO, PAIS) VALUES ('Atibainha', '00000000000', '500.00', 'SP', 'Atibaia', 'Bairro 1', 'Rua 1', '0', 'Brasil');
INSERT INTO HOSPEDAGEM (NOME, CODIGOPOSTAL, PRECO, UF, CIDADE, BAIRRO, LOGRADOURO, NUMERO, PAIS) VALUES ('Bourbon', '00000000002', '1000.00', 'SP', 'Atibaia', 'Bairro 5', 'Rua 8', '500', 'Brasil');


COMMIT;