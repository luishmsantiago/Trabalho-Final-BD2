--g) Scripts SQL para Views (incluir comentário explicando para que serve a View).

-- View para listar pacientes do plano vip, em ordem alfabética.
CREATE VIEW pacientesVip 
  AS SELECT  p.nomePaciente, tpt.nome AS planoNome
  FROM pacientes p
  LEFT JOIN trat_planos_trat tpt
    ON p.idPaciente = tpt.idPaciente
  WHERE tpt.nome = 'vip'
  ORDER BY p.nomePaciente ASC;

-- View para listar nome do paciente, data, hora de atendiemtento e profissional que o atendeu. 
--Está organizado do mais recente para o mais antigo.


CREATE VIEW pacienteAtend
  AS SELECT p.nomePaciente, pr.dataAtendimento, pr.horaAtendimento, pro.nome
  FROM pacientes p
  LEFT JOIN prontuarios pr
    ON p.idPaciente = pr.idPaciente
  LEFT JOIN atualizacao a
    ON pr.idProntuario = a.idProntuario
  LEFT JOIN profissionais pro
    ON a.idProfissional = pro.idProfissional
  ORDER BY pr.dataAtendimento DESC;