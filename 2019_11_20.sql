--GROUPING (cube, rollup���� ���� �÷�)
--�ش� �÷��� �Ұ� ��꿡 ���� ��� : 1
--������ ���� ��� : 0

--job�÷�
--case1, GROUPING(job) = 1 AND GROUPING(deptno) = 1
--       job --> '�Ѱ�'
--case else
--       job --> job
SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE job
       END job, deptno,
       GROUPING(job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

SELECT job, deptno,
       GROUPING(job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--�ǽ�(GROUP_AD2)�Ѱ�� �Ұ踦 �ֱ�
SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE job
       END job, 
       CASE WHEN GROUPING(job) = 0 AND
                 GROUPING(deptno) = 1 THEN job ||' �Ұ�'
            ELSE TO_CHAR(deptno)
       END deptno,
       SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--�ǽ�(GROUP_AD3)
SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

--�ǽ�(GROUP_AD4)
SELECT dname, job, SUM(sal) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job)
ORDER BY dname, job DESC;

SELECT dname, job, sal
FROM 
    (SELECT deptno, job, SUM(sal) sal
    FROM emp
    GROUP BY ROLLUP (deptno, job)) a,
    dept
WHERE a.deptno = dept.deptno(+);

--�ǽ�(GROUP_AD5)
SELECT NVL(a.dname, '����') dname, a.job, a.sal
FROM 
    (SELECT dname, job, sal
    FROM 
        (SELECT deptno, job, SUM(sal) sal
        FROM emp
        GROUP BY ROLLUP (deptno, job)) a,
        dept
    WHERE a.deptno = dept.deptno(+)) a;

SELECT 
    CASE
        WHEN GROUPING(dname) = 1
        AND GROUPING(job) = 1
        THEN '����'
        ELSE dname
    END dname, job, SUM(sal) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job)
ORDER BY dname, job DESC;
    
    
--CUBE (col, col2,...)
--CUBE ���� ������ �÷��� ������ ��� ���տ� ���� ���� �׷����� ����
--CUBE�� ������ �÷��� ���� ���⼺�� ����.(rollup���� ����)
--GROUP BY CUBE(job, deptno)
--OO : GROUP BY job, deptno
--OX : GROUP BY job
--XO : GROUP BY deptno
--XX : GROUP BY -- ��� �����Ϳ� ���ؼ�

--GROUP BY CUBE(job, deptno, mgr) --8����

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE (job, deptno);

--subquery�� ���� ������Ʈ
DROP TABLE emp_test;

--emp���̺��� �����͸� �����ؼ� ��� �÷��� �̿��Ͽ� emp_test���̺�� ����
CREATE TABLE emp_test AS
SELECT *
FROM emp;

--emp_test���̺��� dept���̺��� �����ǰ� �ִ� dname�÷�(VARCHAR2(14))�� �߰�
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

--emp_test���̺��� dname�÷��� dept���̺��� �÷� ������ ������Ʈ�ϴ� ���� �ۼ�
UPDATE emp_test SET dname = (SELECT dname
                            FROM dept
                            WHERE dept.deptno = emp_test.deptno);
COMMIT;

--�ǽ�(sub_a1)
--dept���̺��� �̿��Ͽ� dept_test����
--dept_test���̺� empcnt(number)�÷� �߰�
--subquery�� �̿��Ͽ� dept_test���̺��� empcnt�÷��� �ش� �μ��� ���� update
DROP TABLE dept_test;
CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);

UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                              FROM emp
                              WHERE emp.deptno = dept_test.deptno);

SELECT *
FROM dept_test;
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

--�ǽ�(sub_a2)
--dept_test���̺��� emp���̺��� �������� ������ ���� �μ� ����
INSERT INTO dept_test VALUES (98, 'it', 'daejeon', 0);
DELETE dept_test WHERE (SELECT COUNT(*)
                       FROM emp 
                       WHERE emp.deptno = dept_test.deptno) = 0; 

DELETE dept_test WHERE deptno NOT IN (SELECT deptno FROM emp);                    

DELETE dept_test WHERE NOT EXISTS (SELECT 'X'
                                   FROM emp 
                                   WHERE emp.deptno = dept_test.deptno);                       
                       
ROLLBACK;
SELECT *
FROM dept_test;

--�ǽ�(sub_a2)
--emp_test���̺��� subquery�� �̿��Ͽ� ������ ���� �μ��� ��� �޿����� ���� ������ �޿��� +200 ������Ʈ
UPDATE emp_test SET sal = sal + 200
WHERE sal < (SELECT AVG(sal)
            FROM emp_test a 
            WHERE emp_test.deptno = a.deptno);

SELECT AVG(sal) avg
FROM emp_test
WHERE deptno = 30;

SELECT *
FROM emp_test;

--emp, emp_test empno�÷����� ���� ������ ��ȸ
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
WHERE emp.empno = emp_test.empno;
--2. emp.empno, emp.ename, emp.sal, emp_test.sal, deptno, sal_avg
--emp���̺� ������ �μ� �޿����
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal, emp.deptno, sal_avg
FROM emp, emp_test,
    (SELECT deptno, ROUND(AVG(sal), 2) sal_avg
    FROM emp
    GROUP BY deptno) a
WHERE emp.empno = emp_test.empno
AND emp.deptno = a.deptno;