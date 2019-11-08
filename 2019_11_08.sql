--���� ����
--���� ��??
--RDBMS�� Ư���� �������� �ߺ��� �ִ��� ������ ���踦 �Ѵ�.
--emp ���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ�������
--�μ���ȣ�� ���� �ְ�, �μ���ȣ�� ���� dept���̺�� ������ ����
--�ش� �μ��� ������ ������ �� �ִ�.

--���� ��ȣ, ���� �̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
--emp, dept
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--�μ���ȣ, �μ���, �ش�μ��� �ο���
--OCUNT(col) : col���� �����ϸ� 1, null�̸� 0
SELECT a.deptno, dname, cnt
FROM 
    (SELECT deptno, COUNT(empno) cnt
    FROM emp
    GROUP BY deptno) a,
    dept
WHERE a.deptno = dept.deptno;

SELECT a.deptno, dname, cnt
FROM 
    (SELECT deptno, COUNT(empno) cnt
    FROM emp
    GROUP BY deptno) a
    JOIN dept ON (a.deptno = dept.deptno);

SELECT emp.deptno, dname, COUNT(empno) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY emp.deptno, dname;

SELECT emp.deptno, dname, COUNT(empno) cnt
FROM emp JOIN dept ON emp.deptno = dept.deptno
GROUP BY emp.deptno, dname;

--TOTAL ROW : 14
SELECT COUNT(*), COUNT(empno), COUNT(mgr), COUNT(comm)
FROM emp;

--OUTER JOIN : ���ο� �����ص� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ����� �������� �ϴ� ����
--LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ����ϴ� ����
--RIGHT OUTER JOIN : JOIN KEYWORD �����ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ����ϴ� ����
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - �ߺ�����

--���� ������, �ش� ������ ������ ���� outer join
--���� ��ȣ, �����̸� ������ ��ȣ, ������ �̸�
SELECT a.empno, a.ename, a.mgr, b.ename mgr_name
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename mgr_name
FROM emp a JOIN emp b ON (a.mgr = b.empno);

--ORACLE OUTER JOIN (left, right�� ����, full outer�� �������� ����)
SELECT a.empno, a.ename, a.mgr, b.ename mgr_name
FROM emp a, emp b 
WHERE a.mgr = b.empno(+);

SELECT a.empno, a.ename, a.mgr, b.ename mgr_name
FROM emp a, emp b 
WHERE a.mgr = b.empno;

--ANSI OUTER JOIN
SELECT a.empno, a.ename, a.mgr, b.ename mgr_name
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename mgr_name, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno AND b.deptno = 10);--�������ǿ� ������ �Ҽ� �μ� ��ȣ�� 10

SELECT a.empno, a.ename, a.mgr, b.ename mgr_name, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno)
WHERE b.deptno = 10;--������ �Ϸ�� �� ������ �ҼӺμ��� 10���� ��ȸ

--oracle outer ���������� outer ���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ���� outer join�� ���������� �����Ѵ�.
SELECT a.empno, a.ename, a.mgr, b.ename mgr_name, b.deptno
FROM emp a,emp b 
WHERE a.mgr = b.empno(+)
AND b.deptno(+) = 10;

--ANSI RIGHT OUTER 
SELECT a.empno, a.ename, a.mgr, b.ename mgr_name
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);

--�ǽ�(outerjoin1)
--buyprod���̺� �������ڰ� 2005�� 1�� 25���� �����ʹ� 3ǰ��ۿ� ����.
--��� ǰ���� ���� �� �ֵ��� �ۼ�
--prod���̺�� ����(buy_date, buy_prod, prod_id, prod_name, buy_qty)
SELECT *
FROM buyprod;
SELECT *
FROM prod;

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod LEFT OUTER JOIN buyprod
ON (buyprod.buy_prod = prod.prod_id AND buyprod.buy_date = TO_DATE('20050125', 'YYYYMMDD'));

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod, buyprod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buyprod.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

--�ǽ�(outerjoin2)
--�ǽ�(outerjoin1)���� buy_date�÷��� ���� null�� ������ �ʵ���
SELECT TO_DATE('20050125', 'YYYYMMDD') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod, buyprod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buyprod.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

--�ǽ�(outerjoin3)
--�ǽ�(outerjoin2)���� buy_gty�÷��� ���� null�� ��� 0�� ��������
SELECT TO_DATE('20050125', 'YYYYMMDD') buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty, 0) buy_qty
FROM prod, buyprod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buyprod.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

--�ǽ�(outerjoin4)
--cycle, product ���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ��Ī�� ǥ���ϰ�, �������� �ʴ� ��ǰ�� ��ȸ�ǵ���
--���� cid=1�� ����, nulló��(pid, pnm, cid, day, cnt)
SELECT *
FROM cycle;
SELECT *
FROM product;

SELECT product.pid, pnm, 1 cid, NVL(day, 0) day, NVL(cnt, 0) cnt
FROM product, cycle 
WHERE product.pid = cycle.pid(+)
AND cid(+) = 1;

SELECT product.pid, pnm, 1 cid, NVL(day, 0) day, NVL(cnt, 0) cnt
FROM product LEFT OUTER JOIN cycle ON(product.pid = cycle.pid AND cid = 1);

--�ǽ�(outerjoin4)
--cycle, product, customer ���̺� �̿�, ���� �����ϴ� ��ǰ��Ī�� ǥ���ϰ�, �������� �ʴ� ��ǰ�� ��ȸ�ǵ���
--���� cid=1�� ����, nulló��(pid, pnm, cid, cnm day, cnt)
SELECT *
FROM customer;

SELECT pid, pnm, a.cid, cnm, day, cnt
FROM
    (SELECT product.pid, pnm, 1 cid, NVL(day, 0) day, NVL(cnt, 0) cnt
    FROM product, cycle 
    WHERE product.pid = cycle.pid(+)
    AND cid(+) = 1) a,
    customer
WHERE a.cid = customer.cid
ORDER BY pid DESC, day DESC;

SELECT pid, pnm, a.cid, cnm, day, cnt
FROM
    (SELECT product.pid, pnm, 1 cid, NVL(day, 0) day, NVL(cnt, 0) cnt
    FROM product, cycle 
    WHERE product.pid = cycle.pid(+)
    AND cid(+) = 1) a
    JOIN customer ON (a.cid = customer.cid)
ORDER BY pid DESC, day DESC;

--�ǽ�(crossjoin1)
--customer, product���̺� �̿��Ͽ� ���� ���� ������ ��� ��ǰ�� ���� ����
SELECT *
FROM customer, product;
SELECT *
FROM customer CROSS JOIN product;

--subquery : main������ ���ϴ� �κ� ����
--���Ǵ� ��ġ : 
-- SELECT - scalar subquery (�ϳ��� ��, �ϳ��� �÷��� ��ȸ�Ǵ� �����̾�� �Ѵ�.)
-- FROM - inline view
-- WHERE - subquery

--scalar subquery
SELECT empno, ename, (SELECT SYSDATE FROM dual) now
FROM emp;

--subquery
--SMITH�� ���� �μ��� ���� ���ϱ�
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;

--���� �� ������ ���� �ϳ��� ������ �ۼ�(subquery)
SELECT *
FROM emp
WHERE deptno = 
    (SELECT deptno
    FROM emp
    WHERE ename = 'SMITH');
    
--�ǽ�(sub1)
--��ձ޿����� ���� �޿��� �޴� ������ ��
SELECT COUNT(*)
FROM emp
WHERE sal >
    (SELECT AVG(sal)
    FROM emp);
    
--�ǽ�(sub2)
--��ձ޿����� ���� �޿��� �޴� ������ ����
SELECT *
FROM emp
WHERE sal >
    (SELECT AVG(sal)
    FROM emp);
    
--�ǽ�(sub3)
--SMiTH, WARD����� ���� �μ��� ��� ��� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno IN (
    (SELECT deptno
    FROM emp
    WHERE ename IN ('SMITH', 'WARD')));