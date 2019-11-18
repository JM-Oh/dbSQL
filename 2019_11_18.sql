SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'PC03';

SELECT *
FROM PC03.V_EMP_DEPT;

--PC03 �������� ��ȸ������ ���� v_emp_dept view�� hr�������� ��ȸ�ϱ� ���ؼ���
--������.view�̸� �������� ����� �ؾ��Ѵ�.
--�Ź� �������� ����ϱ� �������Ƿ� �ó���� ���� �ٸ� ��Ī�� ����

CREATE SYNONYM v_emp_dept FOR PC03.v_emp_dept;

--PC03.v_emp_dept --> v_emp_dept
SELECT *
FROM v_emp_dept;

--�ó�� ����
DROP SYNONYM v_emp_dept;

--hr ���� ��й�ȣ : java
--hr ���� ��й�ȣ ���� : hr
ALTER USER hr IDENTIFIED BY hr;
--ALTER USER PC03 IDENTIFIED BY java; -- ���� ������ �ƴ϶� ����

--dictionary
--���ξ� : USER : ����� ���� ��ü
--        ALL : ����ڰ� ��밡���� ��ü
--        DBA : ������ ������ ��ü ��ü(�Ϲ� ����ڴ� ���Ұ�)
--        V$ : �ý��۰� ���õ� view (�Ϲ� ����ڴ� ���Ұ�)

SELECT *
FROM user_tables;

SELECT *
FROM all_tables;

SELECT *
FROM dba_tables
WHERE owner IN ('PC03', 'hr');

--����Ŭ���� ������ SQL�̶�?
--���ڰ� �ϳ��� Ʋ���� �ȵ�
--���� sql�� ���� ����� ����� ���� ���� DBMS������ ���� �ٸ� SQL�� �νĵȴ�.
SELECT /*bind test */* FROM emp;
SELECT /*bind test */* from emp;
Select /*bind test */*  FROM emp;

Select /*bind test */*  FROM emp WHERE empno = 7369;
Select /*bind test */*  FROM emp WHERE empno = 7499;
Select /*bind test */*  FROM emp WHERE empno = 7521;

Select /*bind test */*  FROM emp WHERE empno = :empno; --���ε庯��

SELECT *
FROM V$SQL
WHERE SQL_TEXT LIKE '%bind test%';