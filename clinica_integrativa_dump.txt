--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: cepdomain; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.cepdomain AS character varying(8)
	CONSTRAINT cepdomain_check CHECK ((length((VALUE)::text) = 8));


ALTER DOMAIN public.cepdomain OWNER TO postgres;

--
-- Name: cidadedomain; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.cidadedomain AS character varying(50);


ALTER DOMAIN public.cidadedomain OWNER TO postgres;

--
-- Name: complementodomain; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.complementodomain AS character varying(50);


ALTER DOMAIN public.complementodomain OWNER TO postgres;

--
-- Name: cpfdomain; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.cpfdomain AS character varying(11);


ALTER DOMAIN public.cpfdomain OWNER TO postgres;

--
-- Name: logradourodomain; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.logradourodomain AS character varying(50);


ALTER DOMAIN public.logradourodomain OWNER TO postgres;

--
-- Name: rgdomain; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.rgdomain AS character varying(15);


ALTER DOMAIN public.rgdomain OWNER TO postgres;

--
-- Name: teldomain; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.teldomain AS character varying(15);


ALTER DOMAIN public.teldomain OWNER TO postgres;

--
-- Name: ufdomain; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.ufdomain AS character varying(2);


ALTER DOMAIN public.ufdomain OWNER TO postgres;

--
-- Name: f_calcularidade(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_calcularidade(a_idpaciente integer) RETURNS TABLE(nomepaciente character varying, idadeatual numeric)
    LANGUAGE plpgsql
    AS $$
  BEGIN
      RETURN QUERY
      SELECT 
        p.nomePaciente, 
        EXTRACT(YEAR FROM AGE (CURRENT_DATE, p.dataNasc)) AS idadeAtual 
      FROM pacientes p
      WHERE p.idPaciente = a_idPaciente;
  END;
  $$;


ALTER FUNCTION public.f_calcularidade(a_idpaciente integer) OWNER TO postgres;

--
-- Name: f_totalcontratos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_totalcontratos() RETURNS TABLE(nomeplano character varying, totalcontratos bigint)
    LANGUAGE plpgsql
    AS $$
  BEGIN
      RETURN QUERY
      SELECT
          tpt.nome AS nomePlano,
          COUNT(*) AS totalContratos
      FROM trat_planos_trat tpt
      GROUP BY tpt.nome
      ORDER BY totalContratos DESC;
  END;
  $$;


ALTER FUNCTION public.f_totalcontratos() OWNER TO postgres;

--
-- Name: ft_log_pacientes(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ft_log_pacientes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
	$$;


ALTER FUNCTION public.ft_log_pacientes() OWNER TO postgres;

--
-- Name: sp_atualizarsalario(integer, numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_atualizarsalario(a_idprofissional integer, a_novosalarioclt numeric, a_novosalariodiaria numeric, a_novosalarioatendimento numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
  $$;


ALTER FUNCTION public.sp_atualizarsalario(a_idprofissional integer, a_novosalarioclt numeric, a_novosalariodiaria numeric, a_novosalarioatendimento numeric) OWNER TO postgres;

--
-- Name: sp_inserirpaciente(character varying, character varying, date, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_inserirpaciente(a_cpf character varying, a_rg character varying, a_datanasc date, a_telefone character varying, a_telefone1 character varying, a_nomeplano character varying, a_nomepaciente character varying, a_cep character varying, a_numero integer, a_cidade character varying, a_uf character varying, a_complemento character varying, a_logradouro character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
  BEGIN              
      INSERT INTO pacientes (cpf, rg, dataNasc, telefone, telefone1, nomePlano, nomePaciente, 
                            cep, numero, cidade, uf, complemento, logradouro)
      VALUES (a_cpf, a_rg, a_dataNasc, a_telefone, a_telefone1, a_nomePlano, a_nomePaciente, 
              a_cep, a_numero, a_cidade, a_uf, a_complemento, a_logradouro);
  END
  $$;


ALTER FUNCTION public.sp_inserirpaciente(a_cpf character varying, a_rg character varying, a_datanasc date, a_telefone character varying, a_telefone1 character varying, a_nomeplano character varying, a_nomepaciente character varying, a_cep character varying, a_numero integer, a_cidade character varying, a_uf character varying, a_complemento character varying, a_logradouro character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: atendimento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.atendimento (
    idcontrato integer NOT NULL,
    idprofissional integer NOT NULL
);


ALTER TABLE public.atendimento OWNER TO postgres;

--
-- Name: atualizacao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.atualizacao (
    idprofissional integer NOT NULL,
    idprontuario integer NOT NULL,
    data date NOT NULL,
    hora time without time zone NOT NULL
);


ALTER TABLE public.atualizacao OWNER TO postgres;

--
-- Name: clinicas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clinicas (
    idfilial integer NOT NULL,
    nomefantasia character varying(50) NOT NULL,
    cnpj character varying(14) NOT NULL,
    cep public.cepdomain NOT NULL,
    numero integer NOT NULL,
    telefone public.teldomain NOT NULL,
    cidade public.cidadedomain NOT NULL,
    uf public.ufdomain NOT NULL,
    complemento public.complementodomain NOT NULL,
    logradouro public.logradourodomain NOT NULL
);


ALTER TABLE public.clinicas OWNER TO postgres;

--
-- Name: clinicas_idfilial_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clinicas_idfilial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clinicas_idfilial_seq OWNER TO postgres;

--
-- Name: clinicas_idfilial_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clinicas_idfilial_seq OWNED BY public.clinicas.idfilial;


--
-- Name: dispoe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dispoe (
    idfilial integer NOT NULL,
    idcontrato integer NOT NULL
);


ALTER TABLE public.dispoe OWNER TO postgres;

--
-- Name: log_pacientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_pacientes (
    id integer NOT NULL,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tabela text NOT NULL,
    olddata text DEFAULT ''::text,
    newdata text DEFAULT ''::text
);


ALTER TABLE public.log_pacientes OWNER TO postgres;

--
-- Name: log_pacientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_pacientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.log_pacientes_id_seq OWNER TO postgres;

--
-- Name: log_pacientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_pacientes_id_seq OWNED BY public.log_pacientes.id;


--
-- Name: pacientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pacientes (
    idpaciente integer NOT NULL,
    cpf public.cpfdomain NOT NULL,
    rg public.rgdomain NOT NULL,
    datanasc date NOT NULL,
    telefone public.teldomain NOT NULL,
    telefone1 public.teldomain,
    nomeplano character varying(10) NOT NULL,
    nomepaciente character varying(50) NOT NULL,
    cep public.cepdomain NOT NULL,
    numero integer NOT NULL,
    cidade public.cidadedomain NOT NULL,
    uf public.ufdomain NOT NULL,
    complemento public.complementodomain NOT NULL,
    logradouro public.logradourodomain NOT NULL
);


ALTER TABLE public.pacientes OWNER TO postgres;

--
-- Name: profissionais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profissionais (
    idprofissional integer NOT NULL,
    cpf public.cpfdomain NOT NULL,
    nome character varying(50) NOT NULL,
    conselho character varying(20),
    rg public.rgdomain NOT NULL,
    salarioclt numeric(15,2),
    salarioatendimento numeric(15,2),
    salariodiaria numeric(15,2),
    especialidade character varying(50) NOT NULL,
    funcao character varying(30) NOT NULL,
    profissionaistipo integer NOT NULL,
    datanasc date NOT NULL,
    telefone public.teldomain NOT NULL,
    diastrabsemanal character varying(50) NOT NULL,
    CONSTRAINT profissionais_profissionaistipo_check CHECK ((profissionaistipo = ANY (ARRAY[0, 1])))
);


ALTER TABLE public.profissionais OWNER TO postgres;

--
-- Name: prontuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prontuarios (
    idprontuario integer NOT NULL,
    dataatendimento date NOT NULL,
    horaatendimento time without time zone NOT NULL,
    evolucao character varying(200) NOT NULL,
    idpaciente integer NOT NULL
);


ALTER TABLE public.prontuarios OWNER TO postgres;

--
-- Name: pacienteatend; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.pacienteatend AS
 SELECT p.nomepaciente,
    pr.dataatendimento,
    pr.horaatendimento,
    pro.nome
   FROM (((public.pacientes p
     LEFT JOIN public.prontuarios pr ON ((p.idpaciente = pr.idpaciente)))
     LEFT JOIN public.atualizacao a ON ((pr.idprontuario = a.idprontuario)))
     LEFT JOIN public.profissionais pro ON ((a.idprofissional = pro.idprofissional)))
  ORDER BY pr.dataatendimento DESC;


ALTER VIEW public.pacienteatend OWNER TO postgres;

--
-- Name: pacientes_idpaciente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pacientes_idpaciente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pacientes_idpaciente_seq OWNER TO postgres;

--
-- Name: pacientes_idpaciente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pacientes_idpaciente_seq OWNED BY public.pacientes.idpaciente;


--
-- Name: trat_planos_trat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trat_planos_trat (
    idcontrato integer NOT NULL,
    nome character varying(30) NOT NULL,
    valor numeric(7,2) NOT NULL,
    numsessoes integer NOT NULL,
    nometerapia character varying(60) NOT NULL,
    planostrattipo character varying(15) NOT NULL,
    idpaciente integer NOT NULL
);


ALTER TABLE public.trat_planos_trat OWNER TO postgres;

--
-- Name: pacientesvip; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.pacientesvip AS
 SELECT p.nomepaciente,
    tpt.nome AS planonome
   FROM (public.pacientes p
     LEFT JOIN public.trat_planos_trat tpt ON ((p.idpaciente = tpt.idpaciente)))
  WHERE ((tpt.nome)::text = 'vip'::text)
  ORDER BY p.nomepaciente;


ALTER VIEW public.pacientesvip OWNER TO postgres;

--
-- Name: profissionais_idprofissional_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.profissionais_idprofissional_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.profissionais_idprofissional_seq OWNER TO postgres;

--
-- Name: profissionais_idprofissional_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.profissionais_idprofissional_seq OWNED BY public.profissionais.idprofissional;


--
-- Name: prontuarios_idprontuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prontuarios_idprontuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.prontuarios_idprontuario_seq OWNER TO postgres;

--
-- Name: prontuarios_idprontuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prontuarios_idprontuario_seq OWNED BY public.prontuarios.idprontuario;


--
-- Name: trat_planos_trat_idcontrato_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trat_planos_trat_idcontrato_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.trat_planos_trat_idcontrato_seq OWNER TO postgres;

--
-- Name: trat_planos_trat_idcontrato_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trat_planos_trat_idcontrato_seq OWNED BY public.trat_planos_trat.idcontrato;


--
-- Name: clinicas idfilial; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clinicas ALTER COLUMN idfilial SET DEFAULT nextval('public.clinicas_idfilial_seq'::regclass);


--
-- Name: log_pacientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_pacientes ALTER COLUMN id SET DEFAULT nextval('public.log_pacientes_id_seq'::regclass);


--
-- Name: pacientes idpaciente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes ALTER COLUMN idpaciente SET DEFAULT nextval('public.pacientes_idpaciente_seq'::regclass);


--
-- Name: profissionais idprofissional; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profissionais ALTER COLUMN idprofissional SET DEFAULT nextval('public.profissionais_idprofissional_seq'::regclass);


--
-- Name: prontuarios idprontuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prontuarios ALTER COLUMN idprontuario SET DEFAULT nextval('public.prontuarios_idprontuario_seq'::regclass);


--
-- Name: trat_planos_trat idcontrato; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trat_planos_trat ALTER COLUMN idcontrato SET DEFAULT nextval('public.trat_planos_trat_idcontrato_seq'::regclass);


--
-- Data for Name: atendimento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.atendimento (idcontrato, idprofissional) FROM stdin;
1	1
1	2
1	3
2	1
2	3
3	1
4	1
4	2
4	3
5	1
6	4
\.


--
-- Data for Name: atualizacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.atualizacao (idprofissional, idprontuario, data, hora) FROM stdin;
2	1	2024-06-24	08:44:17
1	2	2024-06-25	10:49:10
1	3	2024-04-30	14:14:33
3	4	2024-06-01	09:01:55
1	5	2024-06-04	10:36:03
4	6	2024-06-04	10:37:12
\.


--
-- Data for Name: clinicas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clinicas (idfilial, nomefantasia, cnpj, cep, numero, telefone, cidade, uf, complemento, logradouro) FROM stdin;
1	Clinica Integrativa Balneario	82161803697100	88330081	123	33672030	Balneario Camboriu	SC	Casa	Rua Uganda
2	Clinica Integrativa Camboriu	82161103697100	88345022	456	30652210	Camboriu	SC	Casa	Rua Areias
3	Clinica Integrativa Itajai	82161855697100	88319445	789	33413020	Itajai	SC	Casa	Rua Araquari
4	Clinica Integrativa Joinville	82134803697100	89230747	121	34311150	Joinville	SC	Escritório	Rua das Armas
5	Clinica Integrativa Curitiba	82166503697100	82974086	321	33503170	Curitiba	PR	Escritório	Av. Rebolsas
\.


--
-- Data for Name: dispoe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dispoe (idfilial, idcontrato) FROM stdin;
1	1
2	2
3	3
4	5
5	4
1	6
\.


--
-- Data for Name: log_pacientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_pacientes (id, date, tabela, olddata, newdata) FROM stdin;
1	2024-11-27 14:36:22.007439	pacientes		("(6,44859036402,801651501,1988-05-10,99386668,88479988,social,""Mariana Rita Marcelino"",88233998,397,Joinville,SC,Casa,""Rua Mario Quintana Hill"")")
2	2024-11-27 14:36:40.100238	pacientes	("(6,44859036402,801651501,1988-05-10,99386668,88479988,social,""Mariana Rita Marcelino"",88233998,397,Joinville,SC,Casa,""Rua Mario Quintana Hill"")")	("(6,44859036402,801651501,1988-05-10,99386668,997339898,social,""Mariana Rita Marcelino"",88233998,397,Joinville,SC,Casa,""Rua Mario Quintana Hill"")")
3	2024-11-27 14:36:49.472732	pacientes	("(6,44859036402,801651501,1988-05-10,99386668,997339898,social,""Mariana Rita Marcelino"",88233998,397,Joinville,SC,Casa,""Rua Mario Quintana Hill"")")	
4	2024-11-27 14:47:32.781545	pacientes		("(7,12345678901,123456789,1990-01-01,48999999999,48988888888,VIP,""João Silva"",88000000,123,Florianópolis,SC,""Apartamento 201"",""Rua das Flores"")")
\.


--
-- Data for Name: pacientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pacientes (idpaciente, cpf, rg, datanasc, telefone, telefone1, nomeplano, nomepaciente, cep, numero, cidade, uf, complemento, logradouro) FROM stdin;
1	97055631179	548702055	1985-04-12	83749261	99283716	vip	Ana Clara Rodrigues	88924560	332	Balneario Camboriu	SC	Casa 2	Quarta Avenida
2	51923874623	886106896	1993-07-29	88839416	96172934	gold	João Pedro Silva	88933439	121	Camboriu	SC	apto 703	Avenida Santo Amaro
3	63597180204	774304866	2001-11-08	88462719	97582936	social	Maria Eduarda Almeida	88213809	122	Caboriú	SC	apto 1001	Rua Santa Clara
4	72486310985	970072986	1978-03-25	99283746	96473829	vip	Lucas Oliveira Santos	88391080	989	Joinville	SC	Casa de fundos	Rua Joaquim Lacerda
5	18759034602	901652701	1966-10-17	99384765	88475612	social	Beatriz Costa Pereira	88233070	1287	Sao Jose do Pinhais	PR	Casa	Rua Julio Pereira Sobrinho
7	12345678901	123456789	1990-01-01	48999999999	48988888888	VIP	João Silva	88000000	123	Florianópolis	SC	Apartamento 201	Rua das Flores
\.


--
-- Data for Name: profissionais; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profissionais (idprofissional, cpf, nome, conselho, rg, salarioclt, salarioatendimento, salariodiaria, especialidade, funcao, profissionaistipo, datanasc, telefone, diastrabsemanal) FROM stdin;
2	51923124623	Maria Claudia dos Santos	CRP12-654321P	9876543	3000.00	\N	\N	Psicologia Clinica	Psicóloga	1	1991-04-06	999886677	Segunda e quarta
3	63597340204	José Carlos Oliveira	CREF3-789012EF	9871234	\N	\N	150.00	Instrutor de Pilates	Educador Fisico	1	1988-09-15	999567803	Segunda a sexta
4	72486560985	Ana Carolina Pereira	CREFITO10-345678F	1287654	\N	180.00	\N	Osteopatia	Fisioterapeuta	1	1987-08-11	991857761	Quinta e sábado
5	18759784602	Carlos Fernando Rodrigues	\N	6543219	2200.00	\N	\N	Organizacao de agenda e relatorios de rendimentos	Secretario	0	1990-02-01	999887766	Segunda a sexta
6	18999904602	Maria Fernanda Cordeiro	\N	6577187	\N	\N	220.00	Limpeza e fazer comida	Faxineira	0	1980-10-20	992867526	Sabado
1	97055721179	João Pereira da Silva	CREFITO10-123456F	1255567	4000.00	\N	200.00	Fisioterapeuta Ortopedica	Fisioterapeuta	1	1990-02-01	999887766	Segunda a sexta
\.


--
-- Data for Name: prontuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prontuarios (idprontuario, dataatendimento, horaatendimento, evolucao, idpaciente) FROM stdin;
1	2024-11-20	08:31:42	A paciente apresentou melhora significativa das dores.	1
2	2024-10-12	10:42:30	O paciente relatou aumento da dor nos membros inferiores após última intervenção.	2
3	2024-11-26	14:11:10	Paciente disse que a dor não retornou. Paciente está de alta.	3
4	2024-10-27	09:02:41	Paciente disse que a dor está 80% melhor. Será necessário realizar um novo plano de tratamento.	4
5	2024-12-03	08:01:25	Houve redução de irradiação para membro inferior direito.	5
6	2024-11-03	11:37:55	Houve redução da dor nos ombros. Foi feita mobilização articular e alongamento muscular na região da cervical e membros superiores.	2
\.


--
-- Data for Name: trat_planos_trat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trat_planos_trat (idcontrato, nome, valor, numsessoes, nometerapia, planostrattipo, idpaciente) FROM stdin;
1	vip	2000.00	10	Fisioterapia, Pilates e Psicologia	pacote	1
2	gold	1500.00	8	Fisioterapia e Pilates	pacote	2
3	social	1000.00	10	Fisioterapia	pacote	3
4	vip	2000.00	10	Fisioterapia, Pilates e Psicologia	pacote	4
5	social	1000.00	10	Fisioterapia	pacote	5
6	particular	180.00	1	Osteopatia	particular	2
\.


--
-- Name: clinicas_idfilial_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clinicas_idfilial_seq', 5, true);


--
-- Name: log_pacientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_pacientes_id_seq', 4, true);


--
-- Name: pacientes_idpaciente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pacientes_idpaciente_seq', 7, true);


--
-- Name: profissionais_idprofissional_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profissionais_idprofissional_seq', 6, true);


--
-- Name: prontuarios_idprontuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prontuarios_idprontuario_seq', 6, true);


--
-- Name: trat_planos_trat_idcontrato_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trat_planos_trat_idcontrato_seq', 6, true);


--
-- Name: atendimento atendimento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atendimento
    ADD CONSTRAINT atendimento_pkey PRIMARY KEY (idcontrato, idprofissional);


--
-- Name: atualizacao atualizacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atualizacao
    ADD CONSTRAINT atualizacao_pkey PRIMARY KEY (idprofissional, idprontuario);


--
-- Name: clinicas clinicas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clinicas
    ADD CONSTRAINT clinicas_pkey PRIMARY KEY (idfilial);


--
-- Name: dispoe dispoe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dispoe
    ADD CONSTRAINT dispoe_pkey PRIMARY KEY (idfilial, idcontrato);


--
-- Name: log_pacientes log_pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_pacientes
    ADD CONSTRAINT log_pacientes_pkey PRIMARY KEY (id);


--
-- Name: pacientes pacientes_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes
    ADD CONSTRAINT pacientes_cpf_key UNIQUE (cpf);


--
-- Name: pacientes pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes
    ADD CONSTRAINT pacientes_pkey PRIMARY KEY (idpaciente);


--
-- Name: profissionais profissionais_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profissionais
    ADD CONSTRAINT profissionais_cpf_key UNIQUE (cpf);


--
-- Name: profissionais profissionais_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profissionais
    ADD CONSTRAINT profissionais_pkey PRIMARY KEY (idprofissional);


--
-- Name: prontuarios prontuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prontuarios
    ADD CONSTRAINT prontuarios_pkey PRIMARY KEY (idprontuario);


--
-- Name: trat_planos_trat trat_planos_trat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trat_planos_trat
    ADD CONSTRAINT trat_planos_trat_pkey PRIMARY KEY (idcontrato);


--
-- Name: pacientes logpacientes; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER logpacientes AFTER INSERT OR DELETE OR UPDATE ON public.pacientes FOR EACH ROW EXECUTE FUNCTION public.ft_log_pacientes();


--
-- Name: atendimento atendimento_idcontrato_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atendimento
    ADD CONSTRAINT atendimento_idcontrato_fkey FOREIGN KEY (idcontrato) REFERENCES public.trat_planos_trat(idcontrato);


--
-- Name: atendimento atendimento_idprofissional_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atendimento
    ADD CONSTRAINT atendimento_idprofissional_fkey FOREIGN KEY (idprofissional) REFERENCES public.profissionais(idprofissional);


--
-- Name: atualizacao atualizacao_idprofissional_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atualizacao
    ADD CONSTRAINT atualizacao_idprofissional_fkey FOREIGN KEY (idprofissional) REFERENCES public.profissionais(idprofissional);


--
-- Name: atualizacao atualizacao_idprontuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atualizacao
    ADD CONSTRAINT atualizacao_idprontuario_fkey FOREIGN KEY (idprontuario) REFERENCES public.prontuarios(idprontuario);


--
-- Name: dispoe dispoe_idcontrato_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dispoe
    ADD CONSTRAINT dispoe_idcontrato_fkey FOREIGN KEY (idcontrato) REFERENCES public.trat_planos_trat(idcontrato);


--
-- Name: dispoe dispoe_idfilial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dispoe
    ADD CONSTRAINT dispoe_idfilial_fkey FOREIGN KEY (idfilial) REFERENCES public.clinicas(idfilial);


--
-- Name: prontuarios prontuarios_idpaciente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prontuarios
    ADD CONSTRAINT prontuarios_idpaciente_fkey FOREIGN KEY (idpaciente) REFERENCES public.pacientes(idpaciente);


--
-- Name: trat_planos_trat trat_planos_trat_idpaciente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trat_planos_trat
    ADD CONSTRAINT trat_planos_trat_idpaciente_fkey FOREIGN KEY (idpaciente) REFERENCES public.pacientes(idpaciente);


--
-- Name: TABLE atendimento; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.atendimento TO admin;
GRANT SELECT ON TABLE public.atendimento TO secretaria;


--
-- Name: TABLE atualizacao; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.atualizacao TO admin;


--
-- Name: TABLE clinicas; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.clinicas TO admin;
GRANT SELECT ON TABLE public.clinicas TO secretaria;


--
-- Name: TABLE dispoe; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.dispoe TO admin;
GRANT SELECT ON TABLE public.dispoe TO secretaria;


--
-- Name: TABLE log_pacientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.log_pacientes TO admin;


--
-- Name: TABLE pacientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.pacientes TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.pacientes TO secretaria;


--
-- Name: TABLE profissionais; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.profissionais TO admin;
GRANT SELECT ON TABLE public.profissionais TO secretaria;


--
-- Name: TABLE prontuarios; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.prontuarios TO admin;


--
-- Name: TABLE trat_planos_trat; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.trat_planos_trat TO admin;


--
-- PostgreSQL database dump complete
--

