--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE department (
    deptname character varying(50),
    createtime timestamp with time zone,
    id integer NOT NULL
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: popedom; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE popedom (
    userno character varying(50),
    variable character varying(100),
    popedom integer,
    id integer NOT NULL
);


ALTER TABLE public.popedom OWNER TO postgres;

--
-- Name: popedomgroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE popedomgroup (
    groupname character varying(100),
    variable character varying(100),
    popedom integer,
    createdate timestamp with time zone,
    id integer NOT NULL
);


ALTER TABLE public.popedomgroup OWNER TO postgres;

--
-- Name: tbdata; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbdata (
    filetitle character varying(100),
    fileurl character varying(200),
    description text,
    filesizes numeric(19,0),
    uptime timestamp with time zone,
    userno character varying(50),
    popedom integer,
    type_id integer,
    sharetime timestamp with time zone,
    id integer NOT NULL
);


ALTER TABLE public.tbdata OWNER TO postgres;

--
-- Name: tbdataoperatelog; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbdataoperatelog (
    opt_username character varying(50),
    opt_userdept character varying(50),
    opt_time timestamp with time zone,
    data_title character varying(100),
    data_url character varying(100),
    data_ownername character varying(30),
    data_ownerdept character varying(50),
    id integer NOT NULL
);


ALTER TABLE public.tbdataoperatelog OWNER TO postgres;

--
-- Name: tbdatarecycle; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbdatarecycle (
    filetitle character varying(100),
    fileurl character varying(200),
    description text,
    filesizes numeric(19,0),
    uptime timestamp with time zone,
    userno character varying(50),
    popedom integer,
    type_id integer,
    id integer NOT NULL
);


ALTER TABLE public.tbdatarecycle OWNER TO postgres;

--
-- Name: tbdatatype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbdatatype (
    userno character varying(50),
    name character varying(50),
    createdate timestamp with time zone,
    id integer NOT NULL
);


ALTER TABLE public.tbdatatype OWNER TO postgres;

--
-- Name: tbdeldata; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbdeldata (
    filetitle character varying(100),
    fileurl character varying(200),
    description text,
    filesizes numeric(19,0),
    uptime timestamp with time zone,
    userno character varying(50),
    popedom integer,
    type_id integer,
    deletetime timestamp with time zone,
    id integer NOT NULL
);


ALTER TABLE public.tbdeldata OWNER TO postgres;

--
-- Name: tbexcel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbexcel (
    filetitle character varying(100),
    fileurl character varying(200),
    description text,
    uptime timestamp with time zone,
    userno character varying(50),
    isdelete character varying(1),
    id integer NOT NULL
);


ALTER TABLE public.tbexcel OWNER TO postgres;

--
-- Name: tbloginlog; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbloginlog (
    loginurl character varying(100),
    loginname character varying(50),
    loginuserid character varying(50),
    logintime timestamp with time zone,
    ip character varying(50),
    browser character varying(50),
    os character varying(50),
    id integer NOT NULL
);


ALTER TABLE public.tbloginlog OWNER TO postgres;

--
-- Name: tbnews; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbnews (
    news_title character varying(100),
    content text,
    type_id integer,
    createtime timestamp with time zone,
    userno character varying(50),
    isdelete integer,
    id integer NOT NULL
);


ALTER TABLE public.tbnews OWNER TO postgres;

--
-- Name: tbnewstype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbnewstype (
    typename character varying(50),
    createtime timestamp with time zone,
    ispublic character varying(1),
    id integer NOT NULL
);


ALTER TABLE public.tbnewstype OWNER TO postgres;

--
-- Name: tbsystem; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbsystem (
    variable character varying(150),
    sencondvalue character varying(200),
    orderbysencond timestamp with time zone,
    parentvalue character varying(200),
    orderbyparent timestamp with time zone,
    id integer NOT NULL
);


ALTER TABLE public.tbsystem OWNER TO postgres;

--
-- Name: tbuser; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbuser (
    userno character varying(50),
    userid character varying(20),
    password character varying(20),
    usergrade character varying(50),
    popedomgroup character varying(50),
    username character varying(30),
    dept_id integer,
    createdate timestamp with time zone,
    isdelete integer,
    online timestamp with time zone,
    sex character varying(1),
    email character varying(200),
    phone character varying(100),
    faxnum character varying(100),
    mobilephone character varying(100),
    msn character varying(50),
    qq character varying(50),
    postalcode character varying(20),
    address text,
    id integer NOT NULL
);


ALTER TABLE public.tbuser OWNER TO postgres;

--
-- Name: department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE department_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.department_id_seq OWNER TO postgres;

--
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE department_id_seq OWNED BY department.id;


--
-- Name: popedom_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE popedom_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.popedom_id_seq OWNER TO postgres;

--
-- Name: popedom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE popedom_id_seq OWNED BY popedom.id;


--
-- Name: popedomgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE popedomgroup_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.popedomgroup_id_seq OWNER TO postgres;

--
-- Name: popedomgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE popedomgroup_id_seq OWNED BY popedomgroup.id;


--
-- Name: tbDataOperateLog_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "tbDataOperateLog_id_seq"
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public."tbDataOperateLog_id_seq" OWNER TO postgres;

--
-- Name: tbDataOperateLog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "tbDataOperateLog_id_seq" OWNED BY tbdataoperatelog.id;


--
-- Name: tbDeldata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "tbDeldata_id_seq"
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public."tbDeldata_id_seq" OWNER TO postgres;

--
-- Name: tbDeldata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "tbDeldata_id_seq" OWNED BY tbdeldata.id;


--
-- Name: tbUser_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "tbUser_id_seq"
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public."tbUser_id_seq" OWNER TO postgres;

--
-- Name: tbUser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "tbUser_id_seq" OWNED BY tbuser.id;


--
-- Name: tbdataRecycle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "tbdataRecycle_id_seq"
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public."tbdataRecycle_id_seq" OWNER TO postgres;

--
-- Name: tbdataRecycle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "tbdataRecycle_id_seq" OWNED BY tbdatarecycle.id;


--
-- Name: tbdata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbdata_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbdata_id_seq OWNER TO postgres;

--
-- Name: tbdata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tbdata_id_seq OWNED BY tbdata.id;


--
-- Name: tbdatatype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbdatatype_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbdatatype_id_seq OWNER TO postgres;

--
-- Name: tbdatatype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tbdatatype_id_seq OWNED BY tbdatatype.id;


--
-- Name: tbexcel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbexcel_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbexcel_id_seq OWNER TO postgres;

--
-- Name: tbexcel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tbexcel_id_seq OWNED BY tbexcel.id;


--
-- Name: tbloginLog_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "tbloginLog_id_seq"
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public."tbloginLog_id_seq" OWNER TO postgres;

--
-- Name: tbloginLog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "tbloginLog_id_seq" OWNED BY tbloginlog.id;


--
-- Name: tbnews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbnews_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbnews_id_seq OWNER TO postgres;

--
-- Name: tbnews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tbnews_id_seq OWNED BY tbnews.id;


--
-- Name: tbnewstype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbnewstype_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbnewstype_id_seq OWNER TO postgres;

--
-- Name: tbnewstype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tbnewstype_id_seq OWNED BY tbnewstype.id;


--
-- Name: tbsystem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbsystem_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbsystem_id_seq OWNER TO postgres;

--
-- Name: tbsystem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tbsystem_id_seq OWNED BY tbsystem.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE department ALTER COLUMN id SET DEFAULT nextval('department_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE popedom ALTER COLUMN id SET DEFAULT nextval('popedom_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE popedomgroup ALTER COLUMN id SET DEFAULT nextval('popedomgroup_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tbdata ALTER COLUMN id SET DEFAULT nextval('tbdata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tbdataoperatelog ALTER COLUMN id SET DEFAULT nextval('"tbDataOperateLog_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tbdatarecycle ALTER COLUMN id SET DEFAULT nextval('"tbdataRecycle_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tbdatatype ALTER COLUMN id SET DEFAULT nextval('tbdatatype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tbdeldata ALTER COLUMN id SET DEFAULT nextval('"tbDeldata_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tbexcel ALTER COLUMN id SET DEFAULT nextval('tbexcel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tbloginlog ALTER COLUMN id SET DEFAULT nextval('"tbloginLog_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tbnews ALTER COLUMN id SET DEFAULT nextval('tbnews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tbnewstype ALTER COLUMN id SET DEFAULT nextval('tbnewstype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tbsystem ALTER COLUMN id SET DEFAULT nextval('tbsystem_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tbuser ALTER COLUMN id SET DEFAULT nextval('"tbUser_id_seq"'::regclass);


--
-- Name: department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- Name: tbloginLog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbloginlog
    ADD CONSTRAINT "tbloginLog_pkey" PRIMARY KEY (id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

