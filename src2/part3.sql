SELECT rolname FROM pg_roles;

CREATE ROLE administrator WITH SUPERUSER LOGIN;
SELECT rolname FROM pg_roles;


CREATE ROLE visitor WITH LOGIN;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO visitor;
SELECT rolname FROM pg_roles;
