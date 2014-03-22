--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: mrshoe; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    entryid integer,
    commenter text,
    comment text,
    tstamp timestamp without time zone
);


ALTER TABLE public.comments OWNER TO mrshoe;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: mrshoe
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO mrshoe;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mrshoe
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: entries; Type: TABLE; Schema: public; Owner: mrshoe; Tablespace: 
--

CREATE TABLE entries (
    id integer NOT NULL,
    title text,
    body text,
    published timestamp without time zone,
    slug text
);


ALTER TABLE public.entries OWNER TO mrshoe;

--
-- Name: entries_id_seq; Type: SEQUENCE; Schema: public; Owner: mrshoe
--

CREATE SEQUENCE entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.entries_id_seq OWNER TO mrshoe;

--
-- Name: entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mrshoe
--

ALTER SEQUENCE entries_id_seq OWNED BY entries.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mrshoe
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mrshoe
--

ALTER TABLE ONLY entries ALTER COLUMN id SET DEFAULT nextval('entries_id_seq'::regclass);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: mrshoe; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: entries_pkey; Type: CONSTRAINT; Schema: public; Owner: mrshoe; Tablespace: 
--

ALTER TABLE ONLY entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: comments_entryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mrshoe
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_entryid_fkey FOREIGN KEY (entryid) REFERENCES entries(id);


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

