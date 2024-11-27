-- DLL do banco de dados Clinica Integrativa

CREATE DATABASE clinica_integrativa; 

-- Criação de Domínios para dados mais comuns

CREATE DOMAIN cidadeDomain AS VARCHAR(50);
CREATE DOMAIN complementoDomain AS VARCHAR(50);
CREATE DOMAIN cepDomain AS VARCHAR(8) CHECK (LENGTH(VALUE) = 8); --Validação para que seja apenas 8 dígitos
CREATE DOMAIN telDomain AS VARCHAR(15);
CREATE DOMAIN cpfDomain AS VARCHAR(11);
CREATE DOMAIN rgDomain as VARCHAR(15);
CREATE DOMAIN ufDomain as VARCHAR(2);
CREATE DOMAIN logradouroDomain as VARCHAR(50);

-- Tabelas primárias


CREATE TABLE clinicas (
  idFilial SERIAL PRIMARY KEY,
  nomeFantasia VARCHAR(50) NOT NULL,
  cnpj VARCHAR(14) NOT NULL,
  cep cepDomain NOT NULL,
  numero INTEGER NOT NULL,
  telefone telDomain NOT NULL,
  cidade cidadeDomain NOT NULL,
  uf ufDomain NOT NULL,
  complemento complementoDomain NOT NULL,
  logradouro logradouroDomain NOT NULL
);

--As clínicas terão pequena diferença nos nomes, CNPJ pode alterar também, temos o telefone e o numero do endereço.

CREATE TABLE pacientes (
  idPaciente SERIAL PRIMARY KEY,
  cpf cpfDomain NOT NULL UNIQUE,-- A adição de unique para que não haja repetição de cpf por engano.
  rg rgDomain NOT NULL,
  dataNasc DATE NOT NULL,
  telefone telDomain NOT NULL,
  telefone1 telDomain, --Não obrigatório
  nomePlano VARCHAR(10) NOT NULL,
  nomePaciente VARCHAR(50) NOT NULL,
  cep cepDomain NOT NULL,
  numero INTEGER NOT NULL,
  cidade cidadeDomain NOT NULL,
  uf ufDomain NOT NULL,
  complemento complementoDomain NOT NULL,
  logradouro logradouroDomain NOT NULL
);
--Pacientes podem ter até dois telefones

CREATE TABLE profissionais (
  idProfissional SERIAL PRIMARY KEY,
  cpf cpfDomain NOT NULL UNIQUE,
  nome VARCHAR(50) NOT NULL,
  conselho VARCHAR(20),
  rg rgDomain NOT NULL,
  salarioClt DECIMAL(15,2),
  salarioAtendimento DECIMAL(15,2),
  salarioDiaria DECIMAL(15,2),
  especialidade VARCHAR(50) NOT NULL,
  funcao VARCHAR(30) NOT NULL,
  profissionaisTipo INTEGER NOT NULL CHECK (profissionaisTipo IN (0, 1)), --Forçará ser apenas 0 ou 1.
  dataNasc DATE NOT NULL,
  telefone telDomain NOT NULL,
  diasTrabSemanal VARCHAR(50) NOT NULL
);
-- Os profissionais da saúde conselho (numero e nome), mas caso a função seja administrativa não terá. Os profissionais da saúde também possuem atuação (as especialidades que executa na clínica) e especialidade(s) da área.
-- profissionaisTipo = 0 são da parte administrativa/secretaria e profissionaisTipo = 1 são da área da saúde. O número do conselho está em varchar devido ter uma letra ao final.
-- função diz respeito a formação base ou atuação base. Ex.: fisioterapeuta, secretário, faxineira, etc.

-- Tabelas secundárias

CREATE TABLE trat_planos_trat (
  idContrato SERIAL PRIMARY KEY,
  nome VARCHAR(30) NOT NULL,
  valor DECIMAL(7,2) NOT NULL,
  numSessoes INTEGER NOT NULL,
  nomeTerapia VARCHAR (60) NOT NULL,
  planosTratTipo VARCHAR(15) NOT NULL,
  idPaciente INTEGER NOT NULL,
  FOREIGN KEY(idPaciente) REFERENCES pacientes (idPaciente)
);
--idContrato = id de contratação do pacote.


CREATE TABLE prontuarios (
  idProntuario SERIAL PRIMARY KEY,
  dataAtendimento DATE NOT NULL,
  horaAtendimento TIME NOT NULL,
  evolucao VARCHAR(200) NOT NULL,
  idPaciente INTEGER NOT NULL,
  FOREIGN KEY(idPaciente) REFERENCES pacientes (idPaciente)
);

--Tabelas terciárias

CREATE TABLE dispoe (
  idFilial INTEGER NOT NULL,
  idContrato INTEGER NOT NULL,
  PRIMARY KEY (idFilial, idContrato),
  FOREIGN KEY(idFilial) REFERENCES clinicas (idFilial),
  FOREIGN KEY (idContrato) REFERENCES trat_planos_trat (idContrato)
);

CREATE TABLE atendimento (
  idContrato INTEGER NOT NULL,
  idProfissional INTEGER NOT NULL,
  PRIMARY KEY (idContrato, idProfissional),
  FOREIGN KEY (idContrato) REFERENCES trat_planos_trat (idContrato),
  FOREIGN KEY(idProfissional) REFERENCES profissionais (idProfissional) 
);

CREATE TABLE atualizacao (
  idProfissional INTEGER NOT NULL,
  idProntuario INTEGER NOT NULL,
  data DATE NOT NULL,
  hora TIME NOT NULL,
  PRIMARY KEY (idProfissional, idProntuario),
  FOREIGN KEY(idProfissional) REFERENCES profissionais (idProfissional),
  FOREIGN KEY(idProntuario) REFERENCES prontuarios (idProntuario)
);



