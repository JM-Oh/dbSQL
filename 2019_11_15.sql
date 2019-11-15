--실행계획을 통한 인덱스 사용여부 확인
--emp 테이블에 empno 컬럼을 기준으로 인덱스가 없을 때
ALTER TABLE emp DROP CONSTRAINT pk_emp;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

--인덱스가 없기 때문에 empno = 7369인 데이터를 찾기 위해 
--emp테이블 전체를 찾아봐야한다. -> TABLE FULL SCAN

SELECT *
FROM TABLE(dbms_xplan.display);
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7782)
   
--emp 테이블에 empno 컬럼을 기준으로 PRIMARY KEY 생성
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);
Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
   
--empno 컬럼으로 인덱스가 존재하는 상황에서 다른 컬럼 값으로 데이터를 조회하는 경우
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |   261 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   261 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER')
   
--인덱스 구성 컬럼만 SELECT절에 기술한 경우
--테이블 접근이 필요없다.
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);
Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |    13 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |    13 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
   
--컬럼에 중복이 가능한 non-unique 인덱스 생성후
--unique index와의 실행계획 비교
--PRIMARY KEY 제약조건 삭제
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--emp 테이블에 job 컬럼으로 두번재 인덱스 생성
--job컬럼은 다른 row의 job 컬럼과 중복이 가능한 컬럼이다.
CREATE INDEX IDX_emp_02 ON emp (job);
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--emp테이블에 job, ename 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX idx_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--emp 테이블에 ename, job컬럼으로 non-unique 인덱스 생성
CREATE INDEX idx_emp_04 ON emp (ename, job);
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C%'; -- 주의 %C%

SELECT *
FROM TABLE(dbms_xplan.display);

--HINT를 사용한 실행계획 제어
EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_03) */ * --주석. 정상적(문법이 맞고 오타가 없음)인 경우에만 적용
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C%'; -- 주의 %C%

SELECT *
FROM TABLE(dbms_xplan.display);

--실습(idx1)
--CREATE TABLE dept_test AS SELECT * FROM dept WHERE 1 = 1 구문으로
--dept_test테이블 생성 후
--deptno 컬럼을 기준으로 unique인덱스 생성
CREATE TABLE dept_test AS SELECT * FROM dept WHERE 1 = 1;
ALTER TABLE dept_test ADD CONSTRAINT pk_dept_test PRIMARY KEY (deptno);
--dname 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX idx_dept_test_01 ON dept_test (dname);
--deptno, dname 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX idx_dept_test_02 ON dept_test (deptno, dname);

--실습(idx2)
--위의 쿼리에서 인덱스 삭제
ALTER TABLE dept_test DROP CONSTRAINT pk_dept_test;
DROP INDEX idx_dept_test_01;
DROP INDEX idx_dept_test_02;

--실습(idx3)
EXPLAIN PLAN FOR
SELECT b.*
FROM emp a, emp b
WHERE a.mgr = b.empno;

SELECT *
FROM TABLE(dbms_xplan.display);

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
CREATE INDEX idx_emp_01 ON emp (deptno);