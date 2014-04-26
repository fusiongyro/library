CREATE TABLE damm_matrix (i smallint, j smallint, v smallint, PRIMARY KEY (i, j));

INSERT INTO damm_matrix
SELECT
  i-1,
  j-1,
  ('{{0, 3, 1, 7, 5, 9, 8, 6, 4, 2},
  {7, 0, 9, 2, 1, 5, 4, 8, 6, 3},
  {4, 2, 0, 6, 8, 7, 1, 3, 5, 9},
  {1, 7, 5, 0, 9, 8, 3, 4, 2, 6},
  {6, 1, 2, 3, 0, 4, 5, 9, 7, 8},
  {3, 6, 7, 4, 2, 0, 9, 5, 8, 1},
  {5, 8, 6, 9, 7, 2, 0, 1, 3, 4},
  {8, 9, 4, 5, 3, 6, 2, 0, 1, 7},
  {9, 4, 3, 8, 6, 1, 7, 2, 0, 5},
  {2, 5, 8, 1, 4, 3, 6, 7, 9, 0}}'::smallint[][])[i][j] as v
FROM
  generate_series(1, 10) as i(i),
  generate_series(1, 10) as j(j);

CREATE OR REPLACE FUNCTION damm_code(bigint) RETURNS smallint AS $$
WITH RECURSIVE prev AS
  (SELECT string_to_array($1::varchar, null)::smallint[] AS digits, 0::smallint AS interim, 1 as i
   UNION ALL
   SELECT prev.digits, v AS interim, prev.i+1 FROM prev JOIN damm_matrix dm ON (dm.j,dm.i) = (prev.digits[prev.i], prev.interim))
SELECT interim AS code FROM prev ORDER BY i DESC LIMIT 1
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION valid_damm(numeric) RETURNS boolean AS $$
SELECT damm_code($1 / 10) = ($1 % 10)
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION generate_damm(bigint) RETURNS bigint AS $$
SELECT $1 * 10 + damm_code($1)
$$ LANGUAGE SQL;

CREATE DOMAIN damm_code AS bigint CONSTRAINT CHECK(valid_damm(VALUE));

CREATE OR REPLACE FUNCTION nextdamm(VARCHAR) RETURNS bigint AS $$
SELECT generate_damm(nextval($1))
$$ LANGUAGE SQL;
