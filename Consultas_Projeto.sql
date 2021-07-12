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


/*
 * ideia para pesquisa com divisão: consultar todos os roteiros que possuem todas as partidas do phoenix suns na nba(playoffs) de 2021
 */

