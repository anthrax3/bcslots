--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: balance_change_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE balance_change_types (
    id integer NOT NULL,
    change_type character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: balance_change_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE balance_change_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: balance_change_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE balance_change_types_id_seq OWNED BY balance_change_types.id;


--
-- Name: balance_changes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE balance_changes (
    id integer NOT NULL,
    balance numeric(16,8) NOT NULL,
    change numeric(16,8) NOT NULL,
    balance_change_type_id integer NOT NULL,
    next_id integer,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: balance_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE balance_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: balance_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE balance_changes_id_seq OWNED BY balance_changes.id;


--
-- Name: bets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bets (
    id integer NOT NULL,
    credits integer,
    multiplier numeric(16,8),
    weight integer,
    payout integer,
    balance_change_id integer,
    reel_combination_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bets_id_seq OWNED BY bets.id;


--
-- Name: conditional_reel_combinations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE conditional_reel_combinations (
    id integer NOT NULL,
    condition character varying(255) NOT NULL,
    payout integer NOT NULL,
    weight integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: conditional_reel_combinations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE conditional_reel_combinations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conditional_reel_combinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE conditional_reel_combinations_id_seq OWNED BY conditional_reel_combinations.id;


--
-- Name: reel_combinations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reel_combinations (
    id integer NOT NULL,
    first_id integer NOT NULL,
    second_id integer NOT NULL,
    third_id integer NOT NULL,
    conditional_reel_combination_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: reel_combinations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reel_combinations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reel_combinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reel_combinations_id_seq OWNED BY reel_combinations.id;


--
-- Name: reels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reels (
    id integer NOT NULL,
    reel character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: reels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reels_id_seq OWNED BY reels.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    public_id character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    active boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY balance_change_types ALTER COLUMN id SET DEFAULT nextval('balance_change_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY balance_changes ALTER COLUMN id SET DEFAULT nextval('balance_changes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bets ALTER COLUMN id SET DEFAULT nextval('bets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY conditional_reel_combinations ALTER COLUMN id SET DEFAULT nextval('conditional_reel_combinations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reel_combinations ALTER COLUMN id SET DEFAULT nextval('reel_combinations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reels ALTER COLUMN id SET DEFAULT nextval('reels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: balance_change_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY balance_change_types
    ADD CONSTRAINT balance_change_types_pkey PRIMARY KEY (id);


--
-- Name: balance_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY balance_changes
    ADD CONSTRAINT balance_changes_pkey PRIMARY KEY (id);


--
-- Name: bets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bets
    ADD CONSTRAINT bets_pkey PRIMARY KEY (id);


--
-- Name: conditional_reel_combinations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY conditional_reel_combinations
    ADD CONSTRAINT conditional_reel_combinations_pkey PRIMARY KEY (id);


--
-- Name: reel_combinations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reel_combinations
    ADD CONSTRAINT reel_combinations_pkey PRIMARY KEY (id);


--
-- Name: reels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reels
    ADD CONSTRAINT reels_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_balance_change_types_on_change_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_balance_change_types_on_change_type ON balance_change_types USING btree (change_type);


--
-- Name: index_balance_changes_on_user_id_and_next_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_balance_changes_on_user_id_and_next_id ON balance_changes USING btree (user_id, next_id);


--
-- Name: index_balance_changes_on_user_id_and_next_id_with_one_null; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_balance_changes_on_user_id_and_next_id_with_one_null ON balance_changes USING btree (user_id, (COALESCE(next_id, (-1))));


--
-- Name: index_bets_on_balance_change_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bets_on_balance_change_id ON bets USING btree (balance_change_id);


--
-- Name: index_conditional_reel_combinations_on_condition; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_conditional_reel_combinations_on_condition ON conditional_reel_combinations USING btree (condition);


--
-- Name: index_reel_combinations_on_first_id_and_second_id_and_third_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_reel_combinations_on_first_id_and_second_id_and_third_id ON reel_combinations USING btree (first_id, second_id, third_id);


--
-- Name: index_reels_on_reel; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_reels_on_reel ON reels USING btree (reel);


--
-- Name: index_users_on_active_and_public_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_active_and_public_id ON users USING btree (active, public_id);


--
-- Name: index_users_on_public_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_public_id ON users USING btree (public_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: balance_changes_balance_change_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY balance_changes
    ADD CONSTRAINT balance_changes_balance_change_type_id_fk FOREIGN KEY (balance_change_type_id) REFERENCES balance_change_types(id);


--
-- Name: balance_changes_next_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY balance_changes
    ADD CONSTRAINT balance_changes_next_id_fk FOREIGN KEY (next_id) REFERENCES balance_changes(id);


--
-- Name: balance_changes_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY balance_changes
    ADD CONSTRAINT balance_changes_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: bets_balance_change_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bets
    ADD CONSTRAINT bets_balance_change_id_fk FOREIGN KEY (balance_change_id) REFERENCES balance_changes(id);


--
-- Name: bets_reel_combination_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bets
    ADD CONSTRAINT bets_reel_combination_id_fk FOREIGN KEY (reel_combination_id) REFERENCES reel_combinations(id);


--
-- Name: reel_combinations_conditional_reel_combination_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reel_combinations
    ADD CONSTRAINT reel_combinations_conditional_reel_combination_id_fk FOREIGN KEY (conditional_reel_combination_id) REFERENCES conditional_reel_combinations(id);


--
-- Name: reel_combinations_first_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reel_combinations
    ADD CONSTRAINT reel_combinations_first_id_fk FOREIGN KEY (first_id) REFERENCES reels(id);


--
-- Name: reel_combinations_second_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reel_combinations
    ADD CONSTRAINT reel_combinations_second_id_fk FOREIGN KEY (second_id) REFERENCES reels(id);


--
-- Name: reel_combinations_third_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reel_combinations
    ADD CONSTRAINT reel_combinations_third_id_fk FOREIGN KEY (third_id) REFERENCES reels(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');