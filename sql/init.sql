CREATE USER vault_admin WITH SUPERUSER CREATEROLE PASSWORD 'notsosecure';
CREATE DATABASE mother;

\c mother

CREATE SCHEMA it;
CREATE SCHEMA hr;
CREATE SCHEMA security;
CREATE SCHEMA finance;
CREATE SCHEMA engineering;

ALTER ROLE postgres SET search_path TO public,it,hr,security,finance,engineering;
ALTER ROLE vault_admin SET search_path TO public,it,hr,security,finance,engineering;

GRANT ALL PRIVILEGES ON ALL TABLES 
IN SCHEMA public,it,hr,security,finance,engineering 
TO vault_admin 
WITH GRANT OPTION;

\c mother vault_admin

CREATE TABLE hr.people (
  email       varchar(40),
  id          varchar(255),
  id_type     varchar(40),
  first_name  varchar(40),
  last_name   varchar(40)
);

INSERT INTO hr.people VALUES
  ('alice@ourcorp.com', '123-45-6789', 'ssn', 'Alice', 'Enshanes'),
  ('bob@ourcorp.com', '234-56-7890', 'ssn', 'Bob', 'Paulson'),
  ('chun@ourcorp.com', '350322197001015332', 'cric', 'Chun', 'Li'),
  ('deepak@ourcorp.com', '0123 4567 8901', 'uidai', 'Deepak', 'Singh'),
  ('eve@ourcorp.com', 'AB 12 34 56 Z', 'nino', 'Eve', 'Darknight'),
  ('frank@ourcorp.com', '678-90-1234', 'ssn', 'Frank', 'Franklin')
;


CREATE TABLE engineering.catalog (
  id            SERIAL PRIMARY KEY,
  name          VARCHAR (60),
  description   VARCHAR (255),
  currency      VARCHAR (40),
  price         NUMERIC (12,2)
);

INSERT INTO engineering.catalog (name, description, currency, price) 
   VALUES
  ('Thromdibulator', 'Complex machine, do not disassemble', 'usd', '100.00'),
  ('Visi-Sonor', 'Musical instrument with visualizations', 'usd', '20000.00'),
  ('Deep Thought', 'Super Computer', 'gbp', '4242424242.42'),
  ('Mithril Vest', 'Very Good Armor (TM)', 'gbp', '12345678.90'),
  ('Blaine the Mono', 'Psychopathic train, enjoys proper riddles', 'usd', '9600000.96'),
  ('Millennium Falcon', 'Fastest Hunk-of-Junk in the Galaxy', 'cred', '421000.00'),
  ('Sonic Screwdriver', 'Multi-tool', 'gbp', '999999999.99')
;
