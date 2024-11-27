--h) Scripts SQL para Triggers (incluir comentário explicando para que serve a Trigger).

-- Trigger para registrar alterações nos dados dos pacientes na tabela `log_pacientes`.
-- Inclui as informações antigas e novas.

--1) É necessário criar a tabela para armazenar os logs dos dados do paciente

CREATE TABLE log_pacientes (
	id SERIAL PRIMARY KEY,
	date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	tabela TEXT NOT NULL,
	oldData TEXT DEFAULT '',
	newData TEXT DEFAULT ''
);

--2) Criar a Function Trigger que verifica qual operação está 
--sendo feita no BD ( inclusão, exclusão ou alteração) e procedendo 
--a inclusão do registro na tabela de logs de acordo com a operação que 
--está sendo realizada.

CREATE OR REPLACE FUNCTION ft_log_pacientes ()
	RETURNS trigger AS $regLog$
		DECLARE 
		dadosAntigos TEXT;
		dadosNovos 	 TEXT;
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			dadosNovos := ROW(NEW);
			INSERT  INTO log_pacientes(tabela, oldData, newData)
				VALUES (TG_TABLE_NAME, DEFAULT, dadosNovos);
		ELSEIF (TG_OP = 'DELETE') THEN
			dadosAntigos := ROW(OLD);
			INSERT INTO log_pacientes(tabela, oldData, newData)
				VALUES (TG_TABLE_NAME, dadosAntigos, DEFAULT);
		ELSEIF (TG_OP = 'UPDATE') THEN
			dadosNovos := ROW(NEW);
			dadosAntigos := ROW(OLD);
			INSERT INTO log_pacientes (tabela, oldData, newData)
				VALUES (TG_TABLE_NAME, dadosAntigos, dadosNovos);
		END IF;
		RETURN NEW;
	END
	$regLog$ LANGUAGE 'plpgsql';

--3) Criar a Trigger sobre a tabela pacientes para ser executada 
--depois (AFTER) de uma operação de inclusão, alteração ou exclusão.

CREATE TRIGGER logPacientes
AFTER INSERT OR UPDATE OR DELETE 
												ON pacientes
	FOR EACH ROW EXECUTE FUNCTION 
													ft_log_pacientes();

--4) Fazer operações de INSERT, UPDATE e DELETE na tabela pacientes (testar se a trigger está funcionando). 
--A cada operação, consulte a tabela de log_pacientes (SELECT * FROM log_pacientes;), 
--para ver o que foi registrado pela Trigger.

INSERT INTO pacientes (cpf, rg, dataNasc, telefone, telefone1, nomePlano, nomePaciente, cep, numero, cidade, uf, complemento, logradouro)
	VALUES('44859036402', '801651501', '1988-05-10', '99386668', '88479988', 'social','Mariana Rita Marcelino', '88233998', 397, 'Joinville', 'SC', 'Casa', 'Rua Mario Quintana Hill');

UPDATE pacientes SET telefone1='997339898' WHERE idPaciente=6;

DELETE FROM pacientes WHERE idPaciente=6;
