-- DML do banco de dados Clinica Integrativa

-- Inclusão de 5 registros para cada tabela;

INSERT INTO clinicas (nomeFantasia, cnpj, cep, numero, telefone, cidade, uf, complemento, logradouro)
	VALUES ('Clinica Integrativa Balneario', '82161803697100', '88330081', 123, '33672030', 'Balneario Camboriu', 'SC', 'Casa', 'Rua Uganda'),
		   	 ('Clinica Integrativa Camboriu', '82161103697100', '88345022', 456, '30652210', 'Camboriu', 'SC', 'Casa', 'Rua Areias'),
		  	 ('Clinica Integrativa Itajai', '82161855697100', '88319445', 789, '33413020', 'Itajai', 'SC', 'Casa', 'Rua Araquari'),
		   	 ('Clinica Integrativa Joinville', '82134803697100', '89230747', 121, '34311150', 'Joinville', 'SC', 'Escritório', 'Rua das Armas'),
		   	 ('Clinica Integrativa Curitiba', '82166503697100', '82974086', 321, '33503170', 'Curitiba', 'PR', 'Escritório', 'Av. Rebolsas');


INSERT INTO pacientes (cpf, rg, dataNasc, telefone, telefone1, nomePlano, nomePaciente, cep, numero, cidade, uf, complemento, logradouro)
	VALUES ('97055631179', '548702055', '1985-04-12', '83749261', '99283716', 'vip','Ana Clara Rodrigues', '88924560', 332, 'Balneario Camboriu', 'SC', 'Casa 2', 'Quarta Avenida'),
	       ('51923874623', '886106896', '1993-07-29', '88839416', '96172934', 'gold','João Pedro Silva', '88933439', 121, 'Camboriu', 'SC', 'apto 703', 'Avenida Santo Amaro'),
	       ('63597180204', '774304866', '2001-11-08', '88462719', '97582936', 'social','Maria Eduarda Almeida', '88213809', 122, 'Caboriú', 'SC', 'apto 1001', 'Rua Santa Clara'),
	       ('72486310985', '970072986', '1978-03-25', '99283746', '96473829', 'vip','Lucas Oliveira Santos', '88391080', 989, 'Joinville', 'SC', 'Casa de fundos', 'Rua Joaquim Lacerda'),
	       ('18759034602', '901652701', '1966-10-17', '99384765', '88475612', 'social','Beatriz Costa Pereira', '88233070', 1287, 'Sao Jose do Pinhais', 'PR', 'Casa', 'Rua Julio Pereira Sobrinho');


INSERT INTO profissionais (cpf, nome, conselho, rg, salarioClt, salarioAtendimento, salarioDiaria, especialidade, funcao, profissionaisTipo, dataNasc, telefone, diasTrabSemanal)
	VALUES ('97055721179', 'João Pereira da Silva', 'CREFITO10-123456F', '1255567', 4000.00, NULL, NULL, 'Fisioterapeuta Ortopedica', 'Fisioterapeuta', 1, '1990-02-01', 999887766, 'Segunda a sexta'),
	       ('51923124623', 'Maria Claudia dos Santos', 'CRP12-654321P', '9876543', 3000.00, NULL, NULL, 'Psicologia Clinica', 'Psicóloga', 1,'1991-04-06', 999886677, 'Segunda e quarta'),
	       ('63597340204', 'José Carlos Oliveira', 'CREF3-789012EF', '9871234', NULL, NULL, 150.00, 'Instrutor de Pilates', 'Educador Fisico', 1,'1988-09-15', 999567803, 'Segunda a sexta'),
	       ('72486560985', 'Ana Carolina Pereira', 'CREFITO10-345678F', '1287654', NULL, 180.00, NULL, 'Osteopatia', 'Fisioterapeuta', 1, '1987-08-11', 991857761, 'Quinta e sábado'),
	       ('18759784602', 'Carlos Fernando Rodrigues', NULL, '6543219', 2200.00, NULL, NULL, 'Organizacao de agenda e relatorios de rendimentos', 'Secretario', 0,'1990-02-01', 999887766, 'Segunda a sexta'),
	       ('18999904602', 'Maria Fernanda Cordeiro', NULL, '6577187', NULL, NULL, 220.00, 'Limpeza e fazer comida', 'Faxineira', 0,'1980-10-20', 992867526, 'Sabado');
--Somente profissionais da saúde tem conselho
--Profissional 1 é da saúde e 0 é administrativo

INSERT INTO trat_planos_trat (nome, valor, numSessoes, nomeTerapia, planosTratTipo, idPaciente)
	VALUES ('vip', 2000, 10, 'Fisioterapia, Pilates e Psicologia', 'pacote', 1),
		   	 ('gold', 1500, 8, 'Fisioterapia e Pilates', 'pacote', 2),
	   	   ('social', 1000, 10, 'Fisioterapia', 'pacote', 3),
	   	   ('vip', 2000, 10, 'Fisioterapia, Pilates e Psicologia', 'pacote', 4),
	   	   ('social', 1000, 10, 'Fisioterapia', 'pacote', 5),
		   	 ('particular', 180, 1, 'Osteopatia', 'particular', 2);
--CPF presente é do paciente que está complanto o plano ou particular. 


INSERT INTO prontuarios (dataAtendimento, horaAtendimento, evolucao, idPaciente)
	VALUES ('2024-11-20', '08:31:42', 'A paciente apresentou melhora significativa das dores.', 1),
				 ('2024-10-12', '10:42:30', 'O paciente relatou aumento da dor nos membros inferiores após última intervenção.', 2),
				 ('2024-11-26', '14:11:10', 'Paciente disse que a dor não retornou. Paciente está de alta.', 3),
				 ('2024-10-27', '09:02:41', 'Paciente disse que a dor está 80% melhor. Será necessário realizar um novo plano de tratamento.', 4),
				 ('2024-12-03', '08:01:25', 'Houve redução de irradiação para membro inferior direito.', 5),
				 ('2024-11-03', '11:37:55', 'Houve redução da dor nos ombros. Foi feita mobilização articular e alongamento muscular na região da cervical e membros superiores.', 2);


INSERT INTO dispoe (idFilial, idContrato)
VALUES (1, 1),
	   	 (2, 2),
	   	 (3, 3),
	   	 (4, 5),
	   	 (5, 4),
	   	 (1, 6);


INSERT INTO atendimento (idProfissional, idContrato)
VALUES (1, 1), 
			 (2, 1),
			 (3, 1),
			 (1, 2),
			 (3, 2),
			 (1, 3),
			 (1, 4),
			 (2, 4),
			 (3, 4),
			 (1, 5),
			 (4, 6);


INSERT INTO atualizacao (idProfissional, idProntuario, data, hora)
VALUES (2, 1, '2024-06-24', '08:44:17'),
			 (1, 2, '2024-06-25', '10:49:10'),
			 (1, 3, '2024-04-30', '14:14:33'),
			 (3, 4, '2024-06-01', '09:01:55'),
			 (1, 5, '2024-06-04', '10:36:03'),
			 (4, 6, '2024-06-04', '10:37:12');

-- data remete a data que foi feita a última atualização, já que o profissional pode atualizar o prontuário após o atendimento.
-------------------------------------------------------------------------------------------------------------------------------------------------

--DUMP
--"C:\Program Files\PostgreSQL\16\bin\pg_dump.exe" -U postgres -d clinica_integrativa > C:\Users\lhg93\clinica_integrativa.sql

--Insert new DB
--C:\ CREATEDB -U postgres clinica_integrativa <- para criar o BD novo
--C:\ PSQL -U postgres clinica_integrativa < C:\Users\lhg93\clinica_integrativa.sql
