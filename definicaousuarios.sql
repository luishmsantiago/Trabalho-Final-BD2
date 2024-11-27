--i) Definição de Usuários e permissões (incluir os comandos para implementação
--dessas regras).
--Mínimo = pelo menos 2 usuários (1 administrador e 1 usuário com permissões
--limitadas).

-- Criação do usuário administrador que será usado pelos profissionais da saúde.
CREATE USER admin PASSWORD 'adm123456';

-- Criação do usuário secretária
CREATE USER secretaria PASSWORD '123456';

-- Permissões para o administrador (acesso total a todas as tabelas)
GRANT SELECT, INSERT, UPDATE, DELETE ON clinicas, pacientes, 
profissionais, trat_planos_trat, prontuarios, dispoe, atendimento, 
atualizacao, log_pacientes TO admin;

-- Permissões para o usuário secretária
GRANT SELECT ON pacientes, profissionais, clinicas, dispoe, 
                atendimento TO secretaria;
GRANT SELECT, INSERT, UPDATE, DELETE ON pacientes TO secretaria;

-- Não dará permissão para o usuário 'secretaria' na tabela 'prontuarios'.
-- GRANT SELECT ON clinica_integrativa.prontuarios TO 'secretaria'; -- NÃO EXECUTAR, A SECRETÁRIA NÃO DEVE TER ACESSO.