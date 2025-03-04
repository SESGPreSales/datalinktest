set Path=C:\Program Files\PostgreSQL\15\bin;%path%
set PGPASSWORD=Samsung01
psql -p 5432 -d postgres -c "DROP DATABASE IF EXISTS \"datalink\";" -U postgres 
psql -p 5432 -d postgres -c "DROP ROLE IF EXISTS  \"datalink\";" -U postgres 
psql -p 5432 -d postgres -c "CREATE ROLE \"datalink\" LOGIN PASSWORD 'datalink2019!' NOSUPERUSER NOINHERIT CREATEDB NOCREATEROLE;" -U postgres 
psql -p 5432 -d postgres -c "CREATE DATABASE \"datalink\" WITH ENCODING = 'UNICODE';" -U postgres 
psql -p 5432 -d postgres -c "SET CLIENT_ENCODING TO 'UNICODE';" -U postgres 
psql -p 5432 -d postgres -c "ALTER DATABASE \"datalink\" OWNER TO \"datalink\";" -U postgres 
psql -p 5432 -d postgres -c "GRANT CREATE ON SCHEMA public TO datalink;"
psql -p 5432 -d datalink -c "CREATE EXTENSION IF NOT EXISTS pgcrypto;"  -U postgres 
set PGPASSWORD=datalink2019!