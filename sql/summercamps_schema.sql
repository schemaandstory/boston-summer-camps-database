--
-- PostgreSQL database dump
--

\restrict hxyJnIkuWcuRIqoZGyjn2rPJ9J7duetU7bLN1Jk6XQhh3tcjUHAZn1Fe1eFZuI7

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-10-21 13:07:24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16775)
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    activity_id integer NOT NULL,
    activity_name character varying(200) NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 16780)
-- Name: activities_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 220
-- Name: activities_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_activity_id_seq OWNED BY public.activities.activity_id;


--
-- TOC entry 221 (class 1259 OID 16781)
-- Name: all_camps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.all_camps (
    camp_id integer NOT NULL,
    camp_name text NOT NULL,
    company_name text,
    city text,
    state text
);


--
-- TOC entry 222 (class 1259 OID 16788)
-- Name: all_camps_camp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.all_camps_camp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 222
-- Name: all_camps_camp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.all_camps_camp_id_seq OWNED BY public.all_camps.camp_id;


--
-- TOC entry 223 (class 1259 OID 16789)
-- Name: hours; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hours (
    hours_id integer NOT NULL,
    program_id integer NOT NULL,
    schedule_type text NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    CONSTRAINT chk_hours_time CHECK ((start_time < end_time)),
    CONSTRAINT chk_schedule_type CHECK ((schedule_type = ANY (ARRAY['full_day'::text, 'half_day_am'::text, 'half_day_pm'::text, 'extended_day'::text])))
);


--
-- TOC entry 224 (class 1259 OID 16801)
-- Name: hours_hours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hours_hours_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 224
-- Name: hours_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hours_hours_id_seq OWNED BY public.hours.hours_id;


--
-- TOC entry 225 (class 1259 OID 16802)
-- Name: program_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.program_activities (
    program_id integer NOT NULL,
    activity_id integer NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 16807)
-- Name: program_weeks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.program_weeks (
    program_week_id integer NOT NULL,
    program_id integer NOT NULL,
    week_id integer NOT NULL
);


--
-- TOC entry 227 (class 1259 OID 16813)
-- Name: program_weeks_program_week_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.program_weeks_program_week_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 227
-- Name: program_weeks_program_week_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.program_weeks_program_week_id_seq OWNED BY public.program_weeks.program_week_id;


--
-- TOC entry 228 (class 1259 OID 16814)
-- Name: programs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programs (
    program_id integer NOT NULL,
    camp_id integer NOT NULL,
    program_name text NOT NULL,
    program_type text,
    latitude numeric(10,7),
    longitude numeric(10,7),
    min_grade integer,
    max_grade integer,
    price_per_week numeric(10,2),
    url text,
    CONSTRAINT chk_latitude CHECK (((latitude >= ('-90'::integer)::numeric) AND (latitude <= (90)::numeric))),
    CONSTRAINT chk_longitude CHECK (((longitude >= ('-180'::integer)::numeric) AND (longitude <= (180)::numeric))),
    CONSTRAINT chk_price_per_week CHECK (((price_per_week IS NULL) OR (price_per_week >= (0)::numeric)))
);


--
-- TOC entry 229 (class 1259 OID 16825)
-- Name: programs_program_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.programs_program_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 229
-- Name: programs_program_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.programs_program_id_seq OWNED BY public.programs.program_id;


--
-- TOC entry 230 (class 1259 OID 16826)
-- Name: registration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.registration (
    reg_id integer NOT NULL,
    camp_id integer NOT NULL,
    priority_reg_open date,
    general_reg_open date,
    deadline date,
    fill_speed text,
    CONSTRAINT chk_registration_dates CHECK ((((priority_reg_open IS NULL) OR (general_reg_open IS NULL) OR (priority_reg_open <= general_reg_open)) AND ((priority_reg_open IS NULL) OR (deadline IS NULL) OR (priority_reg_open <= deadline)) AND ((general_reg_open IS NULL) OR (deadline IS NULL) OR (general_reg_open <= deadline))))
);


--
-- TOC entry 231 (class 1259 OID 16834)
-- Name: registration_reg_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.registration_reg_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 231
-- Name: registration_reg_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.registration_reg_id_seq OWNED BY public.registration.reg_id;


--
-- TOC entry 232 (class 1259 OID 16835)
-- Name: weeks_ref; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.weeks_ref (
    week_id integer NOT NULL,
    label text NOT NULL,
    week_start_date date NOT NULL,
    week_end_date date NOT NULL,
    CONSTRAINT chk_week_dates CHECK ((week_start_date <= week_end_date))
);


--
-- TOC entry 4889 (class 2604 OID 16845)
-- Name: activities activity_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN activity_id SET DEFAULT nextval('public.activities_activity_id_seq'::regclass);


--
-- TOC entry 4890 (class 2604 OID 16846)
-- Name: all_camps camp_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.all_camps ALTER COLUMN camp_id SET DEFAULT nextval('public.all_camps_camp_id_seq'::regclass);


--
-- TOC entry 4891 (class 2604 OID 16847)
-- Name: hours hours_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hours ALTER COLUMN hours_id SET DEFAULT nextval('public.hours_hours_id_seq'::regclass);


--
-- TOC entry 4892 (class 2604 OID 16848)
-- Name: program_weeks program_week_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_weeks ALTER COLUMN program_week_id SET DEFAULT nextval('public.program_weeks_program_week_id_seq'::regclass);


--
-- TOC entry 4893 (class 2604 OID 16849)
-- Name: programs program_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs ALTER COLUMN program_id SET DEFAULT nextval('public.programs_program_id_seq'::regclass);


--
-- TOC entry 4894 (class 2604 OID 16850)
-- Name: registration reg_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration ALTER COLUMN reg_id SET DEFAULT nextval('public.registration_reg_id_seq'::regclass);


--
-- TOC entry 4903 (class 2606 OID 16852)
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (activity_id);


--
-- TOC entry 4905 (class 2606 OID 16854)
-- Name: all_camps all_camps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.all_camps
    ADD CONSTRAINT all_camps_pkey PRIMARY KEY (camp_id);


--
-- TOC entry 4907 (class 2606 OID 16856)
-- Name: hours hours_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hours
    ADD CONSTRAINT hours_pkey PRIMARY KEY (hours_id);


--
-- TOC entry 4911 (class 2606 OID 16858)
-- Name: program_activities pk_program_activities; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_activities
    ADD CONSTRAINT pk_program_activities PRIMARY KEY (program_id, activity_id);


--
-- TOC entry 4913 (class 2606 OID 16860)
-- Name: program_weeks program_weeks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_weeks
    ADD CONSTRAINT program_weeks_pkey PRIMARY KEY (program_week_id);


--
-- TOC entry 4917 (class 2606 OID 16862)
-- Name: programs programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (program_id);


--
-- TOC entry 4919 (class 2606 OID 16864)
-- Name: registration registration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration
    ADD CONSTRAINT registration_pkey PRIMARY KEY (reg_id);


--
-- TOC entry 4909 (class 2606 OID 16866)
-- Name: hours uq_hours_program_schedule; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hours
    ADD CONSTRAINT uq_hours_program_schedule UNIQUE (program_id, schedule_type, start_time, end_time);


--
-- TOC entry 4915 (class 2606 OID 16907)
-- Name: program_weeks uq_program_weeks_program_week; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_weeks
    ADD CONSTRAINT uq_program_weeks_program_week UNIQUE (program_id, week_id);


--
-- TOC entry 4921 (class 2606 OID 16868)
-- Name: weeks_ref weeks_ref_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weeks_ref
    ADD CONSTRAINT weeks_ref_pkey PRIMARY KEY (week_id);


--
-- TOC entry 4922 (class 2606 OID 16869)
-- Name: hours fk_hours_program; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hours
    ADD CONSTRAINT fk_hours_program FOREIGN KEY (program_id) REFERENCES public.programs(program_id);


--
-- TOC entry 4923 (class 2606 OID 16874)
-- Name: program_activities fk_program_activities_activity; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_activities
    ADD CONSTRAINT fk_program_activities_activity FOREIGN KEY (activity_id) REFERENCES public.activities(activity_id);


--
-- TOC entry 4924 (class 2606 OID 16879)
-- Name: program_activities fk_program_activities_program; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_activities
    ADD CONSTRAINT fk_program_activities_program FOREIGN KEY (program_id) REFERENCES public.programs(program_id);


--
-- TOC entry 4925 (class 2606 OID 16884)
-- Name: program_weeks fk_program_weeks_program; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_weeks
    ADD CONSTRAINT fk_program_weeks_program FOREIGN KEY (program_id) REFERENCES public.programs(program_id);


--
-- TOC entry 4926 (class 2606 OID 16889)
-- Name: program_weeks fk_program_weeks_week; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_weeks
    ADD CONSTRAINT fk_program_weeks_week FOREIGN KEY (week_id) REFERENCES public.weeks_ref(week_id);


--
-- TOC entry 4927 (class 2606 OID 16894)
-- Name: programs fk_programs_camp; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT fk_programs_camp FOREIGN KEY (camp_id) REFERENCES public.all_camps(camp_id);


--
-- TOC entry 4928 (class 2606 OID 16899)
-- Name: registration fk_registration_camp; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration
    ADD CONSTRAINT fk_registration_camp FOREIGN KEY (camp_id) REFERENCES public.all_camps(camp_id);


-- Completed on 2026-10-21 13:07:24

--
-- PostgreSQL database dump complete
--

\unrestrict hxyJnIkuWcuRIqoZGyjn2rPJ9J7duetU7bLN1Jk6XQhh3tcjUHAZn1Fe1eFZuI7

