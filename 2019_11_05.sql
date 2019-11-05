--��� �Ķ���Ͱ� �־����� �� �ش� ����� �ϼ��� ���ϴ� ����
--201911 -> 30 / 201912 -> 12

--�Ѵ� ���� �� �������� ���� �ϼ�
--������ ��¥ ���� �� 'DD'�� ����
SELECT :yyyymm param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') dt
FROM dual;

explain plan for
SELECT *
FROM emp
WHERE empno = '7369'; --'7369' ���ڿ��� ���ڷ� ������ ����ȯ

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM emp
WHERE empno = 7300 + '69';

SELECT empno, ename, sal, TO_CHAR(sal, '$0009,999.99') sal_fmt
FROM emp;

--function null
--nvl(coll, coll�� null�� ��� ��ü�� ��)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm, sal + nvl(comm, 0)
FROM emp;

--NVL2(coll, coll�� null�� �ƴ� ��� ǥ���Ǵ� ��, coll�� null�� ��� ��ü�� ��)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 -> null
--else -> expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3...)
--�Լ� ���� �� null�� �ƴ� ù��° ����
SELECT empno, ename, sal, comm, COALESCE(comm, sal)
FROM emp;

--�ǽ�(fn4)
SELECT empno, ename, mgr,
    NVL(mgr, 9999) mgr_n, 
    NVL2(mgr, mgr, 9999) mgr_n, 
    COALESCE(mgr, 9999) mgr_n
FROM emp;
--�ǽ�(fn5)
SELECT userid, usernm, reg_dt,
    NVL(reg_dt, SYSDATE) n_reg_dt, 
    NVL2(reg_dt, reg_dt, SYSDATE) n_reg_dt,
    COALESCE(reg_dt, SYSDATE) n_reg_dt
FROM users;

--case when
SELECT empno, ename, job, sal,
    case
        when job = 'SALESMAN' then sal * 1.05
        when job = 'MANAGER' then sal * 1.10
        when job = 'PRESIDENT' then sal * 1.20
        else sal
    end case_sal
FROM emp;

--decode(col, search1, return1, search2, return2,... default)
SELECT empno, ename, job, sal,
    DECODE(job, 'SALESMAN', sal * 1.05, 'MANAGER', sal * 1.1, 'PRESIDENT', sal * 1.2, sal) decode_sal
FROM emp;

--�ǽ�(con1)
--emp���̺��� �̿� deptno�� ���� �μ������� �����ؼ�
--10->'ACCOUNTING'
--20->'RESEARCH'
--30->'SALES'
--40->'OPERATIONS'
--��Ÿ �ٸ� ��->'DDIT'
SELECT empno, ename, deptno,
    case
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
    end dname,
    DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname
FROM emp;

--�ǽ�(con2)
--emp���̺��� �̿� hiredate�� ���� ���� �ǰ����� ��������� ��ȸ(���⼭�� �Ի�⵵ ����)
SELECT empno, ename, hiredate,
    CASE
       WHEN MOD(TO_CHAR(hiredate, 'YY'), 2) = MOD(TO_CHAR(SYSDATE, 'YY'), 2) THEN '�ǰ����� �����'
       ELSE '�ǰ����� ������'
    END contacttodoctor,
    DECODE(MOD(TO_CHAR(hiredate, 'YY'), 2), MOD(TO_CHAR(SYSDATE, 'YY'), 2), '�ǰ����� �����',
            '�ǰ����� ������') contacttodoctor
FROM emp;

--�ǽ�(con3)
--users���̺��� �̿� reg_dt�� ���� ���� �ǰ����� ��������� ��ȸ(���⼭�� reg_dt ����)
SELECT userid, usernm, alias, reg_dt,
    CASE
       WHEN MOD(TO_CHAR(SYSDATE, 'YY') - TO_CHAR(reg_dt, 'YY'), 2) = 0 THEN '�ǰ����� �����'
       ELSE '�ǰ����� ������'
    END contacttodoctor,
    DECODE(MOD(TO_CHAR(reg_dt, 'YY') - TO_CHAR(SYSDATE, 'YY'), 2), 0, '�ǰ����� �����',
            '�ǰ����� ������') contacttodoctor
FROM users;

--�׷��Լ� (AVG, MAX, MIN, SUM, COUNT)
--�׷��Լ��� NULL���� ����󿡼� �����Ѵ�.
--SUM(comm), COUNT(mgr)
--���� �� ���� ���� �޿��� �޴� ���
--���� �� ���� ���� �޿��� �޴� ���
--������ �޿� ���(�Ҽ��� ��°�ڸ������� ������)
--������ ��
SELECT MAX(sal) max_sal, MIN(sal) min_sal,
    ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
    COUNT(*) emp_cnt,
    COUNT(sal) sal_cnt,
    COUNT(mgr) mgr_cnt, --null���� �������� �ʴ´�.
    SUM(comm) comm_sum
FROM emp;

--�μ��� ���� ���� �޿��� �޴� ����� �޿�
--GROUP BY���� ������� ���� �÷��� SELECT���� ����� ��� ����
--�׷�ȭ�� ���� ���� ���ڿ�, ����� �� �� �ִ�.
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
    ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
    COUNT(*) emp_cnt,
    COUNT(sal) sal_cnt,
    COUNT(mgr) mgr_cnt, --null���� �������� �ʴ´�.
    SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--�μ��� �ִ� �޿�
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--�ǽ�(grp1)
--emp���̺��� �̿��Ͽ�
--������ ���� ���� �޿�
--������ ���� ���� �޿�
--������ �޿� ���
--������ �޿� ��
--���� �� �޿��� �ִ� ������ ��(null����)
--���� �� ����ڰ� �ִ� ������ ��(null����)
--��ü ������ ��
SELECT MAX(sal) max_sal, MIN(sal) min_sal,
    ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
    COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp;

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