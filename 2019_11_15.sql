--�����ȹ�� ���� �ε��� ��뿩�� Ȯ��
--emp ���̺� empno �÷��� �������� �ε����� ���� ��
ALTER TABLE emp DROP CONSTRAINT pk_emp;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

--�ε����� ���� ������ empno = 7369�� �����͸� ã�� ���� 
--emp���̺� ��ü�� ã�ƺ����Ѵ�. -> TABLE FULL SCAN

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
   
--emp ���̺� empno �÷��� �������� PRIMARY KEY ����
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
   
--empno �÷����� �ε����� �����ϴ� ��Ȳ���� �ٸ� �÷� ������ �����͸� ��ȸ�ϴ� ���
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
   
--�ε��� ���� �÷��� SELECT���� ����� ���
--���̺� ������ �ʿ����.
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
   
--�÷��� �ߺ��� ������ non-unique �ε��� ������
--unique index���� �����ȹ ��
--PRIMARY KEY �������� ����
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--emp ���̺� job �÷����� �ι��� �ε��� ����
--job�÷��� �ٸ� row�� job �÷��� �ߺ��� ������ �÷��̴�.
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

--emp���̺� job, ename �÷��� �������� non-unique �ε��� ����
CREATE INDEX idx_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--emp ���̺� ename, job�÷����� non-unique �ε��� ����
CREATE INDEX idx_emp_04 ON emp (ename, job);
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C%'; -- ���� %C%

SELECT *
FROM TABLE(dbms_xplan.display);

--HINT�� ����� �����ȹ ����
EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_03) */ * --�ּ�. ������(������ �°� ��Ÿ�� ����)�� ��쿡�� ����
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C%'; -- ���� %C%

SELECT *
FROM TABLE(dbms_xplan.display);

--�ǽ�(idx1)
--CREATE TABLE dept_test AS SELECT * FROM dept WHERE 1 = 1 ��������
--dept_test���̺� ���� ��
--deptno �÷��� �������� unique�ε��� ����
CREATE TABLE dept_test AS SELECT * FROM dept WHERE 1 = 1;
ALTER TABLE dept_test ADD CONSTRAINT pk_dept_test PRIMARY KEY (deptno);
--dname �÷��� �������� non-unique �ε��� ����
CREATE INDEX idx_dept_test_01 ON dept_test (dname);
--deptno, dname �÷��� �������� non-unique �ε��� ����
CREATE INDEX idx_dept_test_02 ON dept_test (deptno, dname);

--�ǽ�(idx2)
--���� �������� �ε��� ����
ALTER TABLE dept_test DROP CONSTRAINT pk_dept_test;
DROP INDEX idx_dept_test_01;
DROP INDEX idx_dept_test_02;

--�ǽ�(idx3)
EXPLAIN PLAN FOR
SELECT b.*
FROM emp a, emp b
WHERE a.mgr = b.empno;

SELECT *
FROM TABLE(dbms_xplan.display);

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
CREATE INDEX idx_emp_01 ON emp (deptno);