/* Caso algum usuário esteja navegando deslogado no sistema e deseje editar um determinado roteiro, será solicitado seus dados de login, e
 *  caso o usuario logue corretamente, tem que se verificar se este usuário é dono do roteiro que pretende editar */
/*
 * assim podemos criar uma consulta que faça as duas tarefas. 
 */


SELECT * FROM USUARIO u INNER JOIN ROTEIROVIAGEM r ON u.nickname = r.autor WHERE r.nome_roteiro = 'Roteiro 1' AND u.nickname = 'LeoF' AND u.senha = '123456789'


/**
 * 	Para recuperar os roteiros escritos por um usuários
 * 
 * 
 */


SELECT u.nickname,r.nome_roteiro,r.descricao FROM USUARIO u INNER JOIN ROTEIROVIAGEM r ON u.nickname = r.autor

SELECT r.autor,r.nome_roteiro,r.descricao FROM roteiroviagem r WHERE r.autor = 'LeoF' 


/* no contexto de viagem internacional, um turista pode se interessar pelos clubes de um país, assim deve ser selecionado para um dado país
 * os nomes fantasias dos times de cada clube, sua categoria, o nome do esporte e caso tenham atletas cadastrados, resgatar o nome destes atletas
 */


SELECT t.NOMEFANTASIA, t.CATEGORIA,t.NOMEESPORTE ,a.NOME FROM CLUBE c INNER JOIN "TIME" t ON c.IDCLUBE = t.IDCLUBE LEFT JOIN ATLETATIME a ON t.IDTIME = a.IDTIME WHERE upper(c.pais) = 'BRASIL'


/**
 * os grandes eventos esportivos são o grande impulsionador para o turismo esportivo, assim é importante a capacidade dos turistas que pretendem ir a um grande evento
 * se acaharem na plataforma. Pensando neste contexto é importante a consulta de achar todos os usuarios que escreveram roteiros que envolvem partidas de algum super evento para que o usuario possa segui-los.
 */

SELECT DISTINCT u.NICKNAME FROM USUARIO u INNER JOIN ROTEIROVIAGEM r ON u.NICKNAME = r.AUTOR INNER JOIN ROTEIROPARTIDA r2 ON r2.AUTORROTEIRO = r.AUTOR AND r2.NOMEROTEIRO = r.NOME_ROTEIRO INNER JOIN PARTIDA p ON r2.PARTIDA = p.CODIGOPARTIDA WHERE upper(p.NOMECAMPEONATO) = 'MUNDIAL DE CLUBES' AND p.ANOCAMPEONATO = 2021

/* mais eficiente - pulando roteiroviagem*/
SELECT DISTINCT u.nickname FROM USUARIO u INNER JOIN ROTEIROPARTIDA r ON u.NICKNAME = r.AUTORROTEIRO INNER JOIN PARTIDA p ON r.PARTIDA = p.CODIGOPARTIDA WHERE upper(p.NOMECAMPEONATO) = 'MUNDIAL DE CLUBES' AND p.ANOCAMPEONATO = 2021


/*para cada país exibir o preço medio de suas atrações turisticas(ponto ou partida)
 * 
 */

SELECT p.PAIS, AVG(p.PRECO) AS PRECO FROM PONTOTURISTICO p GROUP BY p.pais

SELECT p2.PAIS,AVG(p2.PRECO) AS PRECO FROM PARTIDA p2 GROUP BY p2.pais

SELECT pais,avg(PRECO) FROM (SELECT p.PAIS, AVG(p.PRECO) AS PRECO FROM PONTOTURISTICO p GROUP BY p.pais UNION SELECT p2.PAIS,AVG(p2.PRECO) AS PRECO FROM PARTIDA p2 GROUP BY p2.pais) GROUP BY pais

SELECT pais,PRECO FROM (SELECT p.PAIS, AVG(p.PRECO) AS PRECO FROM PONTOTURISTICO p GROUP BY p.pais UNION SELECT p2.PAIS,AVG(p2.PRECO) AS PRECO FROM PARTIDA p2 GROUP BY p2.pais)

SELECT pais,avg(PRECO) FROM (SELECT p.PAIS, p.PRECO AS PRECO FROM PONTOTURISTICO p UNION SELECT p2.PAIS,p2.PRECO AS PRECO FROM PARTIDA p2) GROUP BY pais

SELECT pais,PRECO FROM (SELECT p.PAIS, p.PRECO AS PRECO FROM PONTOTURISTICO p UNION SELECT p2.PAIS,p2.PRECO AS PRECO FROM PARTIDA p2)

/*
 * ideia para pesquisa com divisão: consultar todos os roteiros que possuem todas as partidas do phoenix suns na nba(playoffs) de 2021
 */

