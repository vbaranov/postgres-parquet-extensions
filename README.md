This is Docker Compose setup for generating container with Postgres DB and built-in extensions `pg_parquet` and `parquet_fdw`.

### Getting started

```
# Build & Run Docker container
docker compose up --build

# Enter inside the container
docker exec -it postgres-parquet-extensions bin/bash
```

Run Postgres client inside the container:
```
psql postgresql://blockscout:@localhost:5432/blockscout
```

Run next commands inside Postgres client in order to add required extensions:
```
CREATE EXTENSION parquet_fdw;
CREATE EXTENSION pg_parquet;
```

### Testing extensions

```
CREATE TABLE test(title varchar(50), num integer);
INSERT INTO test(title, num) VALUES('foo', 123);
INSERT INTO test(title, num) VALUES('bar', 456);

COPY test TO '/tmp/test.parquet' (format 'parquet', compression 'gzip');

create server parquet_srv foreign data wrapper parquet_fdw;
create user mapping for blockscout server parquet_srv options (user 'blockscout');

CREATE FOREIGN TABLE test_from_parquet (
    title varchar(255),
    num   integer
)
server parquet_srv
options (
    filename '/tmp/test.parquet'
);

SELECT * FROM test_from_parquet;

# blockscout=# SELECT * FROM test_from_parquet;
# title | num 
#-------+-----
# foo   | 123
# bar   | 456
#(2 rows)
```