/* 1. Caso algum usuário esteja navegando deslogado no sistema e deseje editar um determinado roteiro, será solicitado seus dados de login, e
 *  caso o usuario logue corretamente, tem que se verificar se este usuário é dono do roteiro que pretende editar */
/*
 * assim podemos criar uma consulta que faça as duas tarefas. 
 */


SELECT * FROM USUARIO U INNER JOIN ROTEIRO_VIAGEM R ON U.NICKNAME = R.AUTOR WHERE R.NOME_ROTEIRO = 'Roteiro 1' AND U.NICKNAME = 'LeoF' AND U.SENHA = '123456789';


/**
 * 	2. Para recuperar os roteiros escritos por um usuários
 * Recuperar todos os nicknames e nomes de usuário e caso tenham escrito roteiros, recuperar os nomes dos roteiros
 * 
 * 
 */

SELECT U.NICKNAME,U.NOME,R.NOME_ROTEIRO FROM USUARIO U LEFT JOIN ROTEIRO_VIAGEM R ON U.NICKNAME = R.AUTOR WHERE UPPER(U.NOME) LIKE 'L%';


/* 3. no contexto de viagem internacional, um turista pode se interessar pelos times de um país, assim deve ser selecionado para um dado país
 * os nomes fantasias dos times de cada clube, sua categoria, o nome do esporte e caso tenham atletas cadastrados, resgatar o nome destes atletas
 */


SELECT T.NOME_FANTASIA, T.CATEGORIA,T.NOME_ESPORTE ,A.NOME 
FROM CLUBE C
INNER JOIN "TIME" T ON C.ID_CLUBE = T.ID_CLUBE
LEFT JOIN ATLETA_TIME A ON T.ID_TIME = A.ID_TIME
WHERE UPPER(C.PAIS) = 'BRASIL';


/**
 * 4. os grandes eventos esportivos são o grande impulsionador para o turismo esportivo, assim é importante a possibilidade dos turistas que pretendem ir a um grande evento
 * se acaharem na plataforma. Pensando neste contexto é importante a consulta de achar todos os usuarios que escreveram roteiros que envolvem partidas de algum super evento para que o usuario possa segui-los.
 */

SELECT DISTINCT U.NICKNAME, U.EMAIL FROM USUARIO U
INNER JOIN ROTEIRO_PARTIDA R ON U.NICKNAME = R.AUTOR_ROTEIRO
INNER JOIN PARTIDA P ON R.PARTIDA = P.CODIGO_PARTIDA
WHERE UPPER(P.NOME_CAMPEONATO) = 'MUNDIAL DE CLUBES' AND P.ANO_CAMPEONATO = 2021


/*5. para cada país exibir o preço medio de suas atrações turisticas, separadas por ponto turistico e partida
 */

SELECT P.PAIS, P.PRECO AS PRECO,'PONTO' AS TIPO  FROM PONTO_TURISTICO P;

SELECT P2.PAIS,P2.PRECO AS PRECO,'PARTIDA' AS TIPO FROM PARTIDA P2;

SELECT PAIS,TIPO,AVG(PRECO) FROM 
(SELECT P.PAIS, P.PRECO AS PRECO, 'PONTO' AS TIPO FROM PONTO_TURISTICO P 
UNION SELECT P2.PAIS,P2.PRECO AS PRECO, 'PARTIDA' AS TIPO FROM PARTIDA P2) 
GROUP BY PAIS,TIPO ORDER BY PAIS;


/*
 * 6. Pesquisa todas as partidas em que um atleta atuará, uma vez que é comum um torcedor ser fã de um jogador e querer assistir uma partida 
 * por conta dele, independente do time.
 */
 
 SELECT A.NOME FROM ATLETA_TIME A WHERE UPPER(A.NOME) LIKE ('DANIEL ALVES');
 
 SELECT A.NOME, T.NOME_FANTASIA FROM ATLETA_TIME A INNER JOIN TIME T ON T.ID_TIME = A.ID_TIME WHERE UPPER(A.NOME) LIKE ('DANIEL ALVES');

 SELECT A.NOME, T.NOME_FANTASIA, PT.PARTIDA FROM ATLETA_TIME A INNER JOIN TIME T ON T.ID_TIME = A.ID_TIME INNER JOIN PARTIDA_TIME PT ON T.ID_TIME = PT.ID_TIME WHERE UPPER(A.NOME) LIKE ('DANIEL ALVES');

SELECT A.NOME, T.NOME_FANTASIA, P.PAIS, P.DATA
FROM ATLETA_TIME A 
INNER JOIN TIME T ON T.ID_TIME = A.ID_TIME 
INNER JOIN PARTIDA_TIME PT ON T.ID_TIME = PT.ID_TIME 
INNER JOIN PARTIDA P ON PT.PARTIDA = P.CODIGO_PARTIDA
WHERE UPPER(A.NOME) LIKE ('DANIEL ALVES');

/*
 * 7. ideia para pesquisa com divisão: consultar todos os roteiros que possuem todas as partidas do phoenix suns na nba(playoffs) de 2021
 */

/*consulta para saber todas as partidas jogadas pelo time phoenix sun, id = 4
SELECT * FROM PARTIDA p WHERE upper(p.NOME_CAMPEONATO) = 'PLAYOFFS NBA' AND p.ANO_CAMPEONATO = '2021';*/

SELECT * FROM  PARTIDA_TIME P2 INNER JOIN PARTIDA P ON P2.PARTIDA = P.CODIGO_PARTIDA WHERE P2.ID_TIME = 4 AND UPPER(P.NOME_CAMPEONATO) = 'PLAYOFFS NBA' AND P.ANO_CAMPEONATO = '2021';

SELECT * FROM ROTEIRO_PARTIDA R WHERE R.AUTOR_ROTEIRO = 'LeoF' AND R.NOME_ROTEIRO = 'Roteiro 1';


SELECT R.AUTOR ,R.NOME_ROTEIRO ,R.DESCRICAO FROM ROTEIRO_VIAGEM R WHERE
NOT EXISTS (
			(SELECT P2.PARTIDA FROM  PARTIDA_TIME P2 
			INNER JOIN PARTIDA P ON P2.PARTIDA = P.CODIGO_PARTIDA
			WHERE P2.ID_TIME = 4 AND UPPER(P.NOME_CAMPEONATO) = 'PLAYOFFS NBA' AND P.ANO_CAMPEONATO = '2021')
			
			MINUS
			
			(SELECT R2.PARTIDA FROM ROTEIRO_PARTIDA R2
			WHERE R2.AUTOR_ROTEIRO = R.AUTOR AND R2.NOME_ROTEIRO = R.NOME_ROTEIRO)
)

/*
 * 8. Lista todos os atletas envolvidos em uma determinada partida.
 * O usuario pode buscar mais informacoes sobre uma partida que o interessa e,
 * com essa consulta, pode saber todos os atletas que participarão.
 */
 
SELECT A.NOME, T.NOME_FANTASIA
FROM PARTIDA P
INNER JOIN PARTIDA_TIME PT ON PT.PARTIDA = P.CODIGO_PARTIDA
INNER JOIN TIME T ON T.ID_TIME = PT.ID_TIME 
INNER JOIN ATLETA_TIME A ON T.ID_TIME = A.ID_TIME
WHERE P.CODIGO_PARTIDA LIKE ('1');



/**
 * Selecionar todos os times cuja torcida gastou mais do que determinado valor X
 * 
 */


