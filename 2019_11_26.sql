SELECT ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

--�ǽ�(ana1)
--����� ��ü �޿������� rank, dense_rank, row_number�� �̿��Ͽ� ���ϼ���
--�޿��� ������ ��� ����� ���� ����� ���� ������ �ǵ��� �ۼ�
SELECT empno, ename, sal, deptno,
       RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_row_number
FROM emp;

--�ǽ�(no_ana2)
--������ ��� ���� Ȱ��
--��� ����� ���� �����ȣ, ����̸�, �ش����� ���� �μ��� ��� ���� ��ȸ�ϴ� ����
SELECT empno, ename, emp.deptno, cnt
FROM emp,
     (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) a
WHERE emp.deptno = a.deptno
ORDER BY deptno;

--�м��Լ��� ���� �μ��� ������ (COUNT)
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

--�μ��� ����� �޿� �հ�
--SUM �м��Լ�
SELECT empno, ename, deptno, sal, SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

--�ǽ�(ana2)
--�м��Լ��� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �޿�, �μ���ȣ, �ҼӺμ��� �޿���� ��ȸ
SELECT empno, ename, sal, deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;

--�ǽ�(ana3)
--�м��Լ��� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �޿�, �μ���ȣ, �ҼӺμ��� ���� ���� �޿� ��ȸ
SELECT empno, ename, sal, deptno, MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

--�ǽ�(ana4)
--�м��Լ��� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �޿�, �μ���ȣ, �ҼӺμ��� ���� ���� �޿� ��ȸ
SELECT empno, ename, sal, deptno, MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

--�μ��� �����ȣ�� ���� ���� ���
--�μ��� �����ȣ�� ���� ���� ���
SELECT empno, ename, deptno,
       FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
       LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

--LAG(������)
--������
--LEAD(������)
--�޿��� ���� ������ ���������� �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�
--�޿��� ���� ������ ���������� �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�
SELECT empno, ename, sal,
       LAG(sal) OVER (ORDER BY sal) lag_sal,
       LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

--�ǽ�(ana5)
--�м��Լ� �̿�, ��� ����� ���� �����ȣ, ����̸�, �Ի�����, �޿�, �Ѵܰ� ���� ����� �޿� ��ȸ
--�޿��� ���� ��� �Ի����� ���� ����� ���� ����
SELECT empno, ename, hiredate, sal,
       LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

--�ǽ�(ana6)
--�м��Լ� �̿�, ��� ����� ���� �����ȣ, ����̸�, �Ի�����, ����, �޿�
--������ �޿������� �Ѵܰ� ���� ����� �޿� ��ȸ
--�޿��� ���� ��� �Ի����� ���� ����� ���� ����
SELECT empno, ename, hiredate, job, sal,
       LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

--�ǽ�(no_ana3)
--��� ����� ���� �����ȣ, ����̸�, �޿��� �޿��� ���� ������ ��ȸ
--�ڽź��� �޿��� ���� ����� �޿� ���� ���ο� �÷��� �м��Լ� ����
SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno;

SELECT a.*, ROWNUM rn
FROM
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal, empno) a;

SELECT a.*, ROWNUM rn
FROM
    (SELECT sal
    FROM emp
    ORDER BY sal) a;

SELECT a.empno, a.ename, a.sal, SUM(b.sal)
FROM
    (SELECT a.*, ROWNUM rn
    FROM
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal, empno) a) a,
    (SELECT a.*, ROWNUM rn
    FROM
        (SELECT sal
        FROM emp
        ORDER BY sal) a) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, empno;

--WINDOWING
--UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� ��� ��
--CURRENT ROW : ���� ��
--UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� ��� ��
--N(����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
--N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��
SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;

--�ǽ�(ana7)
--��� ����� ���� �����ȣ, ����̸�, �μ���ȣ, �޿�, 
--�ҼӺμ����� ������� ���� �޿��� �޴� ������� �޿� �� ��ȸ
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS UNBOUNDED PRECEDING) c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2,
       SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum2
FROM emp;