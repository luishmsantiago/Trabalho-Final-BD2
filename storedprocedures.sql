-- e) Scripts SQL para Stored Procedures (incluir comentário explicando para que serve a
--SP e os parâmetros caso utilizar).
--Mínimo = pelo menos 2 SP.

-- Stored Procedure para inserir um novo paciente na tabela `pacientes`.
-- Parâmetros: a_cpf (cpf do paciente), a_rg (rg do paciente), 
--a_dataNasc (data de nascimento do paciente), a_telefone (telefone do paciente), 
-- a_telefone1 (segundo telefone do paciente), a_nomePlano (plano que o paciente está cadastrado), 
-- a_nomePaciente, a_cep (cep do paciente), a_numero (numero residencial do paciente), 
-- a_cidade (cidade em que o paciente mora), a_uf (unidade federativa em que o paciente mora), 
-- a_complemento (complemento do endereço do paciente), a_logradouro (logradouro do endereço do paciente)

CREATE OR REPLACE FUNCTION 
  sp_inserirPaciente (a_cpf VARCHAR(11), a_rg VARCHAR(15), a_dataNasc DATE, a_telefone VARCHAR(15), 
                      a_telefone1 VARCHAR(15), a_nomePlano VARCHAR(10), a_nomePaciente VARCHAR(50), 
                      a_cep VARCHAR(8), a_numero INTEGER, a_cidade VARCHAR(50), a_uf VARCHAR(2), 
                      a_complemento VARCHAR(50), a_logradouro VARCHAR(50))
  RETURNS void as $$
  BEGIN              
      INSERT INTO pacientes (cpf, rg, dataNasc, telefone, telefone1, nomePlano, nomePaciente, 
                            cep, numero, cidade, uf, complemento, logradouro)
      VALUES (a_cpf, a_rg, a_dataNasc, a_telefone, a_telefone1, a_nomePlano, a_nomePaciente, 
              a_cep, a_numero, a_cidade, a_uf, a_complemento, a_logradouro);
  END
  $$ LANGUAGE 'plpgsql';
-- ID paciente não adicionado pois ele é SERIAL.

-- Stored Procedure para atualizar os salários dos funcionários.
-- Parâmetros: a_idProfissional (id do profissional), 
-- a_novoSalarioCLT (valor a ser recebido para modificar o salário CLT), 
-- a_novoSalarioDiaria (valor a ser recebido para modificar o salário diária), 
-- a_novoSalarioAtendimento (valor a ser recebido para modificar o salário atendimento)

CREATE OR REPLACE FUNCTION 
  sp_atualizarSalario (a_idProfissional INT, a_novoSalarioCLT DECIMAL(15,2), 
                    a_novoSalarioDiaria DECIMAL(15,2), a_novoSalarioAtendimento DECIMAL(15,2))
  RETURNS void as $$
  BEGIN
      UPDATE profissionais
      SET 
        salarioClt = CASE
          WHEN a_novoSalarioCLT > 0 THEN a_novoSalarioCLT 
          ELSE salarioClt
        END,      
        salarioDiaria = CASE
          WHEN a_novoSalarioDiaria > 0 THEN a_novoSalarioDiaria
          ELSE salarioDiaria
        END,  
        salarioAtendimento = CASE
          WHEN a_novoSalarioAtendimento > 0 THEN a_novoSalarioAtendimento 
          ELSE salarioAtendimento
        END
      WHERE idProfissional = a_idProfissional;
  END
  $$ LANGUAGE 'plpgsql';

