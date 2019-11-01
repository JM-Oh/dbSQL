--����
--WHERE
--������
-- �� : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' (% : �ټ��� ���ڿ��� ��Ī, _ : ��Ȯ�� �ѱ��� ��Ī)
-- IS NULL
-- AND, OR, NOT

--emp ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ� ���� ���� ��ȸ
--BETWEEN
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01', 'YYYY/MM/DD') AND TO_DATE('1986/12/31', 'YYYY/MM/DD');
-- <= >=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD') 
AND hiredate <= TO_DATE('1986/12/31', 'YYYY/MM/DD');

--emp���̺��� ������(mgr)�� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- �ǽ�(where12)
-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE '78%';

-- �ǽ�(where13)
-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ��ȸ(LIKE������ �̻��)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno BETWEEN 7800 AND 7899
OR empno BETWEEN 780 AND 789
OR empno = 78;

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR (empno >= 7800 
AND empno < 7900)
OR (empno >= 780 
AND empno < 790)
OR empno = 78;

-- �ǽ�(where14)
-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϸ鼭 �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR (empno LIKE '78%'
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD'));

-- order by �÷��� | ��Ī | �÷��ε��� (ASC | DESC)
-- order by ������ WHERE ������ ���
-- WHERE���� ���� ��� FROM������ ���
-- ename �������� �������� ����
SELECT *
FROM emp
ORDER BY ename ASC;

--ASC : dafault
--ASC�� �Ⱥٿ��� �� ������ ������
SELECT *
FROM emp
ORDER BY ename;

-- ename �������� �������� ����
SELECT *
FROM emp
ORDER BY ename DESC;

--job�� �������� ������������ ����, job�� ���� ��� ���(empno)���� �������� ����
SELECT *
FROM emp
ORDER BY job DESC, empno;

--��Ī���� �����ϱ�
--�����ȣ(empno), �����(ename), ����(sal * 12) as year_sal
SELECT empno, ename, sal, sal*12 AS year_sal
FROM emp
ORDER BY year_sal;

--SELECT�� �÷� ���� �ε����� ����
SELECT empno, ename, sal, sal*12 AS year_sal
FROM emp
ORDER BY 4;--SELECT���� 4��°�� year_sal�̹Ƿ�

--�ǽ�(orderby1)
--dept���̺��� ��� ������ �μ��̸����� �������� ���ķ� ��ȸ
desc dept;
SELECT *
FROM dept
ORDER BY dname;
--dept���̺��� ��� ������ �μ���ġ���� �������� ���ķ� ��ȸ
SELECT *
FROM dept
ORDER BY loc DESC;

--�ǽ�(orderby2)
--emp���̺��� ��(comm)������ �ִ� ����鸸 ��ȸ�ϰ�,
--�󿩸� ���� �޴� ����� ���� ��ȸ�ǵ��� �ϰ�, �󿩰� ���� ��� ������� �������� ����
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno;

--�ǽ�(orderby3)
--emp���̺��� �����ڰ� �ִ� ����鸸 ��ȸ�ϰ�,
--����(job)������ �������� �����ϰ�, ������ ���� ��� ����� ū ����� ���� ��ȸ�ǵ��� �ۼ�
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

--�ǽ�(orderby4)
--emp���̺��� 10�� �μ�(deptno) Ȥ�� 30�� �μ��� ���ϴ� ��� �� �޿��� 1500�� �Ѵ� ����鸸 ��ȸ�ϰ�
--�̸����� �������� ����
SELECT *
FROM emp
WHERE deptno IN (10, 30)
AND sal > 1500
ORDER BY ename DESC;

--�����÷� ROWNUM : SELECT������ ���� ��ȸ�� ������� �ο��� ���� ���� �÷�
SELECT ROWNUM, empno, ename 
FROM emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 1; --1���Ĵ� ���� ���� �ʾ����Ƿ� WHERE ROWNUM = 2 ���� �� �� �� ����.

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 10; --����(<=)�� �̸�(<)���δ� �� �� �ִ�.

--emp ���̺��� ���(empno), �̸�(ename)�� �޿� �������� �������� �����ϰ� ���ĵ� ��������� ROWNUM
SELECT empno, ename, sal, ROWNUM
FROM emp
ORDER BY sal;

SELECT ROWNUM, a.* --���̺��� ��Ī�� a��� �ְ� a.*���� ��ü �÷��� �����´�.
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a; -- ��ȣ ���� ��ü�� �ϳ��� ���̺�� �ȴ�. inline view

--�ǽ�(row_1)
--���� ���̺��� ROWNUM ���� 1~10�� ���� ��ȸ�ϴ� ������ �ۼ�
SELECT ROWNUM AS RN, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a
WHERE ROWNUM <= 10;

--�ǽ�(row_2)
--���� ���̺��� ROWNUM ���� 11~20�� ���� ��ȸ�ϴ� ������ �ۼ�
SELECT *
FROM
(SELECT ROWNUM AS RN, a.*
FROM
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal) a
    ORDER BY ROWNUM DESC)
WHERE ROWNUM <= 4
ORDER BY RN; --�ʹ� ������ ���� ����̾���..

SELECT *
FROM
    (SELECT ROWNUM AS RN, a.*
    FROM
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal) a)
WHERE RN BETWEEN 11 AND 20;

--FUNCTION
--DUAL ���̺� ��ȸ -- �⺻������ ������ �ִ� ���̺� DUMMY�÷� �ϳ��� X�� ���� ����
SELECT 'HELLO WORLD' AS msg
FROM DUAL;

SELECT 'HELLO WORLD'
FROM emp;

--���ڿ� ��ҹ��� ���� �Լ�
--LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('hello, world') 
FROM dual;

--FUNCTION�� WHERE�������� ��밡��
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';

--������ SQL ĥ������
--1. �º��� �������� ���ƶ�
--�º�(TABLE�� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
--Function Based Index -> FBI

--CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ�
SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD')
FROM dual;
--SUBSTR : ���ڿ��� �κй��ڿ� (1�� �ε������� ����)
SELECT SUBSTR('HELLO, WORLD', 0, 5) substr, SUBSTR('HELLO, WORLD', 1, 5) substr1
FROM dual;
--LENGTH : ���ڿ��� ����
SELECT LENGTH('HELLO, WORLD')
FROM dual;
--INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
SELECT INSTR('HELLO, WORLD', 'O') instr,
       INSTR('HELLO, WORLD', 'O', 6) instr1--INSTR(���ڿ�, ã�� ���ڿ�, Ư���ε��� ������ ��ġ ǥ��)
FROM dual;
--LPAD : ���ڿ� ���ʿ� Ư�� ���ڿ��� ���� / RPAD : �����ʿ� ����
--LPAD(���ڿ�, ��ü ���ڿ�����, ��ü ���ڿ� ���̿� ���ڿ��� ��ġ�� ���� ��� �߰��� ����)
SELECT LPAD('HELLO, WORLD', 15, '*'), RPAD('HELLO, WORLD', 15, '*')
FROM dual;