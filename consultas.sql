-- d) 5 consultas, algumas usando diferentes tipos de JOIN.

-- Selecionar pacientes (nomes), cpf, plano de tratamento, valor pago no plano em ordem decrescente.

SELECT 
    p.nomePaciente,
    p.cpf,
    tpt.nome AS plano_de_tratamento,
    tpt.valor
FROM 
    pacientes p
JOIN 
    trat_planos_trat tpt ON p.idPaciente = tpt.idPaciente
ORDER BY  valor DESC;


-- Selecionar profissional 'João Pereira', atendimentos (nome dos pacientes) e as datas com horas das atualizações nos prontuários.

SELECT 
    p.nome AS nome_profissional,
    pa.nomePaciente AS nomePaciente,
    atz.data,
    atz.hora
FROM 
    profissionais p
INNER JOIN 
    atualizacao atz ON p.idProfissional = atz.idProfissional
INNER JOIN 
    prontuarios pro ON atz.idProntuario = pro.idProntuario
INNER JOIN 
    pacientes pa ON pro.idPaciente = pa.idPaciente
WHERE 
    p.nome LIKE '%João Pereira%';

-- Mostrar todos os planos contratados (com seus dados) da filial 1 da clínica.

SELECT 
    c.idFilial,
    c.nomeFantasia AS nome_da_clinica,
    tpt.*
FROM 
    clinicas c
LEFT JOIN 
    dispoe d ON c.idFilial = d.idFilial
LEFT JOIN 
    trat_planos_trat tpt ON d.idContrato = tpt.idContrato
WHERE 
    c.idFilial = 1;

-- Mostrar as evoluções e profissionais que atenderam a paciente com cpf "51923874623".

SELECT 
    pro.nome AS nome_profissional,
    p.evolucao AS evolucao,
    pa.nomePaciente AS nomePaciente,
    pa.cpf AS cpf
FROM 
    pacientes pa
INNER JOIN 
    prontuarios p ON pa.idPaciente = p.idPaciente
INNER JOIN 
    atualizacao at ON p.idProntuario = at.idProntuario
INNER JOIN 
    profissionais pro ON at.idProfissional = pro.idProfissional
WHERE 
    pa.cpf = '51923874623';

-- Mostrar profissionais, evoluções e pacientes atendidos no dia 2024-11-03.

SELECT 
    pro.nome AS nome_profissional,
    p.evolucao AS evolucao,
    pa.nomePaciente AS nomePaciente,
    p.dataAtendimento AS dataAtendimento
FROM 
    profissionais pro
RIGHT JOIN 
    atualizacao at ON pro.idProfissional = at.idProfissional
RIGHT JOIN 
    prontuarios p ON at.idProntuario = p.idProntuario
RIGHT JOIN 
    pacientes pa ON p.idPaciente = pa.idPaciente
WHERE 
    p.dataAtendimento = '2024-11-03';

