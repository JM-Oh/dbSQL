--�׷��Լ�
--multi row function : �������� ���� �Է����� �ϳ��� ��� ���� ����
--SUM, MAX, MIN, AVG, COUNT
--GROUP BY col | express
--SELECT ������ GROUP BY ���� ����� col, express�� ǥ�� ����

--���� �� ���� ���� �޿� ��ȸ
--14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

--�μ����� ���� ���� �޿� ��ȸ
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--�ǽ�(grp2)
--emp���̺��� �̿��Ͽ�
--�μ����� ������ ���� ���� �޿�
--�μ����� ������ ���� ���� �޿�
--�μ����� ������ �޿� ���
--�μ����� ������ �޿� ��
--�μ��� ���� �� �޿��� �ִ� ������ ��(null����)
--�μ��� ���� �� ����ڰ� �ִ� ������ ��(null����)
--�μ��� ������ ��
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
    ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
    COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY deptno DESC;

--�ǽ�(grp3)
--grp2�� �μ���ȣ ��� �μ����� �������� �ۼ�
SELECT 
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
    END dname,
    MAX(sal) max_sal, MIN(sal) min_sal,
    ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
    COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
         END
ORDER BY MAX(sal) DESC;

SELECT 
    DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') dname,
    MAX(sal) max_sal, MIN(sal) min_sal,
    ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
    COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES')
ORDER BY MAX(sal) DESC;

--�ǽ�(grp4)
--emp���̺��� ������ �Ի������� ����� ������ �Ի��ߴ��� ��ȸ
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

--�ǽ�(grp5)
--emp���̺��� ������ �Ի�⺰�� ����� ������ �Ի��ߴ��� ��ȸ
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyy, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

--�ǽ�(grp6)
--ȸ�翡 �����ϴ� �μ��� ���� ��ȸ
SELECT table_name
FROM user_tables;
SELECT COUNT(*) cnt
FROM dept;

--distinct : �ߺ� ����
SELECT distinct deptno
FROM emp;

--JOIN
--emp ���̺��� dname �÷��� ����. -> �μ���ȣ(deptno)�ۿ� ����
DESC emp;

--emp���̺� �μ��̸��� ������ �� �ִ� dname�÷� �߰�
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

UPDATE emp SET dname = 'ACCOUNTING' WHERE deptno = 10;
UPDATE emp SET dname = 'RESEARCH' WHERE deptno = 20;
UPDATE emp SET dname = 'SALES' WHERE deptno = 30;
COMMIT;

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP COLUMN dname;

SELECT *
FROM emp;

--ansi natural join : ���̺��� �÷����� ���� �÷��� �������� JOIN
SELECT deptno, ename, dname
FROM emp NATURAL JOIN dept;

--ORACLE join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e , dept d
WHERE e.deptno = d.deptno;

--ANSI JOIN WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

--from ���� ���� ��� ���̺� ����
--where���� ���� ���� ���
--������ ����ϴ� ���� ���൵ ��� ����
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.job = 'SALESMAN'; --job�� SALESMAN�� ����� ������� ��ȸ

--JOIN with ON (�����ڰ� ���� �÷��� on���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--SELF join : ���� ���̺��� ����
--emp ���̺��� mgr ������ �����ϱ� ���ؼ� emp ���̺�� ������ �ؾ��Ѵ�.
--a : ��������, b : ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

--oracle join����
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno BETWEEN 7369 AND 7698;

--none equi join (��� ������ �ƴ� ���)
SELECT *
FROM salgrade;

--������ �޿� �����?
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON(emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--none equi join
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
--WHERE a.mgr != b.empno
--AND a.empno = 7369;
WHERE a.empno = 7369;

--�ǽ�(join0)
--emp dept ���̺� �̿�, empno, ename, deptno, dname ��ȸ
SELECT empno, ename, deptno, dname
FROM emp NATURAL JOIN dept
ORDER BY deptno;

SELECT empno, ename, deptno, dname
FROM emp JOIN dept USING (deptno)
ORDER BY deptno;

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY emp.deptno;

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
ORDER BY emp.deptno;

--�ǽ�(join0_1)
--emp dept ���̺� �̿�, empno, ename, deptno, dname ��ȸ(�μ���ȣ 10, 30�� ��ȸ)
SELECT empno, ename, deptno, dname
FROM emp NATURAL JOIN dept
WHERE deptno IN (10, 30);

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno IN (10, 30);

SELECT empno, ename, deptno, dname
FROM emp JOIN dept USING (deptno)
WHERE deptno IN (10, 30);

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.deptno IN (10, 30);