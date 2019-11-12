DESC emp;

INSERT INTO emp (ename, job)
VALUES ('brown', null);

SELECT *
FROM emp
WHERE empno = 9999;

rollback;

DESC emp;

SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP'
ORDER BY column_id;

INSERT INTO emp
VALUES (9999, 'brown', 'ranger', null, SYSDATE, 2500, null, 40);

--SELECT ���(������)�� INSERT
INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROM dept;
COMMIT;

SELECT *
FROM emp;

--UPDATE
--UPDATE ���̺� SET �÷�=��, �÷�=��...
--WHERE condition

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
commit;

SELECT *
FROM dept;

UPDATE dept SET dname = '���IT', loc = 'ym'
WHERE deptno = 99;

ROLLBACK;

SELECT *
FROM emp;

--DELETE ���̺��
--WHERE condition
--�����ȣ�� 9999�� ������ emp ���̺��� ����
DELETE emp
WHERE empno = 9999;

--�μ����̺��� �̿��ؼ� emp���̺� �Է��� 4���� �����͸� ����
--10, 20, 30, 40, 99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;

ROLLBACK;

DELETE emp
WHERE empno BETWEEN 10 AND 99;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

COMMIT;

SELECT * 
FROM emp;

--LV1 -> LV3
SET TRANSACTION
ISOLATION LEVEL SERIALIZABLE;

--DML������ ���� Ʈ����� ����
INSERT INTO dept
VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept;

--DDL : auto commit, rollback�� �ȵȴ�.
--CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,   --���� Ÿ��
    ranger_name VARCHAR2(50), --���� : VARCHAR2�� ����ȭ, CHAR
    reg_dt DATE DEFAULT SYSDATE --DEFAULT : SYSDATE
);
DESC ranger_new;

--ddl�� rollback�� ������� �ʴ´�.
rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000, 'brown');

SELECT *
FROM ranger_new;
commit;

--��¥ Ÿ�Կ��� Ư�� �ʵ� ��������
--ex : sysdate���� �⵵�� ��������
SELECT TO_CHAR(SYSDATE, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt, 'MM') mm, 
       EXTRACT(MONTH FROM reg_dt) mm,
       EXTRACT(YEAR FROM reg_dt) year,
       EXTRACT(DAY FROM reg_dt) day
FROM ranger_new;

--���� ����
--dept���̺� ����ؼ� dept_test ����
DESC dept_test;
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY, --deptno�÷��� �ĺ��ڷ� ����
    dname VARCHAR2(14),           --�ĺ��ڷ� ������ �Ǹ� ���� �ߺ��� �ɼ� ������, null�� ���� ����.
    loc VARCHAR2(13)
);

--primary key ���� ���� Ȯ��
--1. deptno�÷��� null�� �� �� ����.
--2. deptno�÷��� �ߺ��� ���� �� �� ����.
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test
VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test
VALUES (1, 'ddit2', 'daejeon');

ROLLBACK;

--����� ���� �������Ǹ��� �ο��� PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname) --�ĺ��ڰ� �����̹Ƿ�
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon'); --dname������ ���ƾ� �ߺ����� �ν��Ѵ�.
SELECT *
FROM dept_test;
ROLLBACK;

--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, null, 'daejeon');

--UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, 'ddit', 'daejeon');