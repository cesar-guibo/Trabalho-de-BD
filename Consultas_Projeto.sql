/* Caso algum usu�rio esteja navegando deslogado no sistema e deseje editar um determinado roteiro, ser� solicitado seus dados de login, e
 *  caso o usuario logue corretamente, tem que se verificar se este usu�rio � dono do roteiro que pretende editar */
/*
 * assim podemos criar uma consulta que fa�a as duas tarefas. 
 */


SELECT * FROM USUARIO u INNER JOIN ROTEIROVIAGEM r ON u.nickname = r.autor WHERE r.nome_roteiro = 'Roteiro 1' AND u.nickname = 'LeoF' AND u.senha = '123456789'


/**
 * 	Para recuperar os roteiros escritos por um usu�rios
 * 
 * 
 */


SELECT u.nickname,r.nome_roteiro,r.descricao FROM USUARIO u INNER JOIN ROTEIROVIAGEM r ON u.nickname = r.autor

SELECT r.autor,r.nome_roteiro,r.descricao FROM roteiroviagem r WHERE r.autor = 'LeoF' 


/*
 * ideia para pesquisa com divis�o: consultar todos os roteiros que possuem todas as partidas do phoenix suns na nba(playoffs) de 2021
 */

