/* 1. Caso algum usuário esteja navegando deslogado no sistema e deseje editar um determinado roteiro, será solicitado seus dados de login, e
 *  caso o usuario logue corretamente, tem que se verificar se este usuário é dono do roteiro que pretende editar */
/*
 * assim podemos criar uma consulta que faça as duas tarefas. 
 */


SELECT * FROM USUARIO u INNER JOIN ROTEIROVIAGEM r ON u.nickname = r.autor WHERE r.nome_roteiro = 'Roteiro 1' AND u.nickname = 'LeoF' AND u.senha = '123456789';


/**
 * 	2. Para recuperar os roteiros escritos por um usuários
 * Recuperar todos os nicknames e nomes de usuário e caso tenham escrito roteiros, recuperar os nomes dos roteiros
 * 
 * 
 */

SELECT u.NICKNAME,u.NOME,r.NOME_ROTEIRO FROM USUARIO u LEFT JOIN ROTEIROVIAGEM r ON u.NICKNAME = r.AUTOR WHERE upper(u.nome) LIKE 'L%';


/* 3. no contexto de viagem internacional, um turista pode se interessar pelos clubes de um país, assim deve ser selecionado para um dado país
 * os nomes fantasias dos times de cada clube, sua categoria, o nome do esporte e caso tenham atletas cadastrados, resgatar o nome destes atletas
 */


SELECT t.NOMEFANTASIA, t.CATEGORIA,t.NOMEESPORTE ,a.NOME 
FROM CLUBE c
INNER JOIN "TIME" t ON c.IDCLUBE = t.IDCLUBE
LEFT JOIN ATLETATIME a ON t.IDTIME = a.IDTIME
WHERE upper(c.pais) = 'BRASIL';


/**
 * 4. os grandes eventos esportivos são o grande impulsionador para o turismo esportivo, assim é importante a possibilidade dos turistas que pretendem ir a um grande evento
 * se acaharem na plataforma. Pensando neste contexto é importante a consulta de achar todos os usuarios que escreveram roteiros que envolvem partidas de algum super evento para que o usuario possa segui-los.
 */

SELECT DISTINCT u.nickname, u.EMAIL FROM USUARIO u
INNER JOIN ROTEIROPARTIDA r ON u.NICKNAME = r.AUTORROTEIRO
INNER JOIN PARTIDA p ON r.PARTIDA = p.CODIGOPARTIDA
WHERE upper(p.NOMECAMPEONATO) = 'MUNDIAL DE CLUBES' AND p.ANOCAMPEONATO = 2021


/*5. para cada país exibir o preço medio de suas atrações turisticas, separadas por ponto turistico e partida
 */

SELECT p.PAIS, p.PRECO AS PRECO,'PONTO' AS tipo  FROM PONTOTURISTICO p;

SELECT p2.PAIS,p2.PRECO AS PRECO,'PARTIDA' AS tipo FROM PARTIDA p2;

SELECT pais,tipo,avg(PRECO) FROM 
(SELECT p.PAIS, p.PRECO AS PRECO, 'PONTO' AS tipo FROM PONTOTURISTICO p 
UNION SELECT p2.PAIS,p2.PRECO AS PRECO, 'PARTIDA' AS tipo FROM PARTIDA p2) 
GROUP BY pais,tipo ORDER BY pais;


/*
 * 6. Pesquisa todas as partidas em que um atleta atuará, uma vez que é comum um torcedor ser fã de um jogador e querer assistir uma partida 
 * por conta dele, independente do time.
 */
 
 SELECT A.NOME FROM ATLETATIME A WHERE UPPER(A.NOME) LIKE ('DANIEL ALVES');
 
 SELECT A.NOME, T.NOMEFANTASIA FROM ATLETATIME A INNER JOIN TIME T ON T.IDTIME = A.IDTIME WHERE UPPER(A.NOME) LIKE ('DANIEL ALVES');

 SELECT A.NOME, T.NOMEFANTASIA, PT.PARTIDA FROM ATLETATIME A INNER JOIN TIME T ON T.IDTIME = A.IDTIME INNER JOIN PARTIDATIME PT ON T.IDTIME = PT.IDTIME WHERE UPPER(A.NOME) LIKE ('DANIEL ALVES');

SELECT A.NOME, T.NOMEFANTASIA, P.PAIS, P.DATA
FROM ATLETATIME A 
INNER JOIN TIME T ON T.IDTIME = A.IDTIME 
INNER JOIN PARTIDATIME PT ON T.IDTIME = PT.IDTIME 
INNER JOIN PARTIDA P ON PT.PARTIDA = P.CODIGOPARTIDA
WHERE UPPER(A.NOME) LIKE ('DANIEL ALVES');

/*
 * 7. ideia para pesquisa com divisão: consultar todos os roteiros que possuem todas as partidas do phoenix suns na nba(playoffs) de 2021
 */

/*consulta para saber todas as partidas jogadas pelo time phoenix sun, id = 4
SELECT * FROM PARTIDA p WHERE upper(p.NOMECAMPEONATO) = 'PLAYOFFS NBA' AND p.ANOCAMPEONATO = '2021';*/

SELECT * FROM  PARTIDATIME p2 INNER JOIN PARTIDA p ON p2.PARTIDA = p.CODIGOPARTIDA WHERE p2.IDTIME = 4 and upper(p.NOMECAMPEONATO) = 'PLAYOFFS NBA' AND p.ANOCAMPEONATO = '2021';

SELECT * FROM ROTEIROPARTIDA r WHERE r.AUTORROTEIRO = 'LeoF' AND r.NOMEROTEIRO = 'Roteiro 1';


SELECT r.AUTOR ,r.NOME_ROTEIRO ,r.DESCRICAO FROM ROTEIROVIAGEM r WHERE
NOT EXISTS (

			(SELECT p2.PARTIDA FROM  PARTIDATIME p2 
			INNER JOIN PARTIDA p ON p2.PARTIDA = p.CODIGOPARTIDA
			WHERE p2.IDTIME = 4 and upper(p.NOMECAMPEONATO) = 'PLAYOFFS NBA' AND p.ANOCAMPEONATO = '2021')
			
			MINUS
			
			(SELECT r2.PARTIDA FROM ROTEIROPARTIDA r2
			WHERE r2.AUTORROTEIRO = r.AUTOR AND r2.NOMEROTEIRO = r.NOME_ROTEIRO)
				
)

/*
 * 8. Lista todos os atletas envolvidos em uma determinada partida.
 * O usuario pode buscar mais informacoes sobre uma partida que o interessa e,
 * com essa consulta, pode saber todos os atletas que participarão.
 */
 
SELECT A.NOME, T.NOMEFANTASIA
FROM PARTIDA P
INNER JOIN PARTIDATIME PT ON PT.PARTIDA = P.CODIGOPARTIDA
INNER JOIN TIME T ON T.IDTIME = PT.IDTIME 
INNER JOIN ATLETATIME A ON T.IDTIME = A.IDTIME
WHERE P.CODIGOPARTIDA LIKE ('1');


