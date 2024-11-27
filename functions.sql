
--f) Scripts SQL para Functions (incluir comentário explicando para que serve a Function
--e os parâmetros de entrada e valor de saída).

-- Function para calcular Número de contratos de planos feitos. Será ordenado em ordem decrescente.
-- Parâmetro: nomePlano receberá na tabela o nome dos planos, totalContratos receberá a soma dos números de planos feitos
-- Retorna: Uma tabela com o nome e número de atendimentos de cada plano
-- OBS: A função está sem parâmetros de entrada, pois foi projetada para 
-- executar uma operação fixa e independente.
CREATE OR REPLACE FUNCTION 
  f_totalContratos()
	RETURNS TABLE (nomePlano VARCHAR(30), totalContratos BIGINT) AS $$
  BEGIN
      RETURN QUERY
      SELECT
          tpt.nome AS nomePlano,
          COUNT(*) AS totalContratos
      FROM trat_planos_trat tpt
      GROUP BY tpt.nome
      ORDER BY totalContratos DESC;
  END;
  $$ LANGUAGE 'plpgsql';


-- Function para calcular a idade de um paciente com base no ID dele.
-- Parâmetros: dataNascimento (Data de nascimento do paciente) e idPaciente (identificação do paciente)
-- Retorna: Idade do paciente em anos

CREATE OR REPLACE FUNCTION 
  f_calcularIdade(a_idPaciente INT)
  RETURNS TABLE(nomePaciente VARCHAR(50), idadeAtual NUMERIC) AS $$
  BEGIN
      RETURN QUERY
      SELECT 
        p.nomePaciente, 
        EXTRACT(YEAR FROM AGE (CURRENT_DATE, p.dataNasc)) AS idadeAtual 
      FROM pacientes p
      WHERE p.idPaciente = a_idPaciente;
  END;
  $$ LANGUAGE 'plpgsql';
