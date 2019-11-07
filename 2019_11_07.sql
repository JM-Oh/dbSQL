--emp���̺��� �μ���ȣ(deptno)�� ����
--emp���̺��� �μ����� ��ȸ�ϱ� ���ؼ���
--dept���̺�� ������ ���� �μ��� ��ȸ

--���� ����
--ANSI : ���̺� JOIN ���̺�2 ON (���̺�.COL = ���̺�2.COL)
--      emp JOIN dept ON (emp.deptno = dept.deptno)
--ORACLE : FROM ���̺�, ���̺�2 WHERE ���̺�.co1 = ���̺�2.col
--      FROM emp, dept WHERE emp.deptno = dept.deptno

--�����ȣ, �����, �μ���ȣ, �μ���
SELECT empno, ename, deptno, dname
FROM emp NATURAL JOIN dept;

SELECT empno, ename, deptno, dname
FROM emp JOIN dept USING (deptno);

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--�ǽ�(join0_2)
--emp dept ���̺� �̿�, empno, ename, sal, deptno, dname ��ȸ(�޿��� 2500 �ʰ�)
SELECT empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE sal > 2500
ORDER BY deptno;

SELECT empno, ename, sal, deptno, dname
FROM emp JOIN dept USING (deptno)
WHERE sal > 2500
ORDER BY deptno;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.sal > 2500
ORDER BY emp.deptno;

SELECT emp.empno, emp.ename,emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.sal > 2500
ORDER BY emp.deptno;

--�ǽ�(join0_3)
--emp dept ���̺� �̿�, empno, ename, sal, deptno, dname ��ȸ(�޿��� 2500 �ʰ�, ����� 7600���� ū ����)
SELECT empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE sal > 2500
AND empno > 7600;

SELECT empno, ename, sal, deptno, dname
FROM emp JOIN dept USING (deptno)
WHERE sal > 2500
AND empno > 7600;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.sal > 2500
AND emp.empno > 7600;

SELECT emp.empno, emp.ename,emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.sal > 2500
AND emp.empno > 7600;

--�ǽ�(join0_4)
--emp dept ���̺� �̿�, empno, ename, sal, deptno, dname ��ȸ
--(�޿��� 2500 �ʰ�, ����� 7600���� ũ�� �μ����� RESEARCH�� �μ��� ���� ����)
SELECT empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE sal > 2500
AND empno > 7600
AND dname = 'RESEARCH'
ORDER BY empno DESC;

SELECT empno, ename, sal, deptno, dname
FROM emp JOIN dept USING (deptno)
WHERE sal > 2500
AND empno > 7600
AND dname = 'RESEARCH'
ORDER BY empno DESC;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.sal > 2500
AND emp.empno > 7600
AND dept.dname = 'RESEARCH'
ORDER BY emp.empno DESC;

SELECT emp.empno, emp.ename,emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.sal > 2500
AND emp.empno > 7600
AND dept.dname = 'RESEARCH'
ORDER BY emp.empno DESC;

--�ǽ�(join1)
--prod���̺�� lprod���̺��� �����Ͽ� lprod_gu, lprod_nm, prod_id, prod_name ��ȸ
SELECT *
FROM lprod;
SELECT *
FROM prod;

SELECT lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu
ORDER BY prod.prod_id;

SELECT lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM prod JOIN lprod ON(prod.prod_lgu = lprod.lprod_gu)
ORDER BY prod.prod_id;

--�ǽ�(join2)
--prod���̺�� buyer���̺��� �����Ͽ� buyer_id, buyer_name, prod_id, prod_name ��ȸ
SELECT *
FROM buyer;

SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer JOIN prod ON (buyer.buyer_id = prod.prod_buyer)
ORDER BY prod.prod_id;

SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer, prod 
WHERE buyer.buyer_id = prod.prod_buyer
ORDER BY prod.prod_id;

--�ǽ�(join3)
--member, cart, prod ���̺� ����, ȸ���� ��ٱ��Ͽ� ���� ��ǰ ������ ��ȸ
--mem_id, mem_name, prod_id, prod_name, cart_qty
SELECT *
FROM cart;
SELECT *
FROM member;

SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, prod, cart
WHERE member.mem_id = cart.cart_member
AND cart.cart_prod = prod.prod_id;

SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM cart JOIN member ON (member.mem_id = cart.cart_member) JOIN prod ON(cart.cart_prod = prod.prod_id);

--�ǽ�(join4)
--customer, cycle ���̺� ����, ���� ������ǰ(pid), ���� ����(day), ����(cnt) ��ȸ
--(����cnm�� brownm sally�� ��ȸ)
SELECT *
FROM customer;
SELECT *
FROM cycle;

SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM cycle JOIN customer ON (cycle.cid = customer.cid)
WHERE customer.cnm IN ('brown', 'sally');

SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM cycle, customer
WHERE cycle.cid = customer.cid
AND customer.cnm IN ('brown', 'sally');

SELECT cid, cnm, pid, day, cnt
FROM cycle NATURAL JOIN customer
WHERE cnm IN ('brown', 'sally');

SELECT cid, cnm, pid, day, cnt
FROM cycle JOIN customer USING (cid)
WHERE cnm IN ('brown', 'sally');

--�ǽ�(join5)
--customer, cycle, product ���̺� ����, ���� ������ǰ(pid), ��ǰ��(pnm), ���� ����(day), ����(cnt) ��ȸ
--(����cnm�� brownm sally�� ��ȸ)
SELECT *
FROM product;

SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle JOIN customer ON (cycle.cid = customer.cid) JOIN product ON (cycle.pid = product.pid)
WHERE customer.cnm IN ('brown', 'sally');

SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = customer.cid
AND cycle.pid = product.pid
AND customer.cnm IN ('brown', 'sally');

SELECT cid, cnm, pid, pnm, day, cnt
FROM cycle NATURAL JOIN customer NATURAL JOIN product 
WHERE cnm IN ('brown', 'sally');

SELECT cid, cnm, pid, pnm, day, cnt
FROM cycle JOIN customer USING (cid) JOIN product USING (pid)
WHERE cnm IN ('brown', 'sally');

--�ǽ�(join6)
--customer, cycle, product ���̺� ����, ���� ���Ͽ� �������
--����ȣ(cid), ����(cnm), ���� ������ǰ(pid), ��ǰ��(pnm), ����(cnt) ��ȸ

--��, ��ǰ�� �����Ǽ�(���ϰ� ���� ����)
SELECT cid, pid, SUM(cnt) cnt
FROM cycle
GROUP BY cid, pid;

/*WITH cycle_groupby as (
SELECT cid, pid, SUM(cnt) cnt
FROM cycle
GROUP BY cid, pid)*/

--���� ��ǰ ���̺�� ����
SELECT a.cid, customer.cnm, a.pid, product.pnm, a.cnt
FROM
    (SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid) a,
    customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;

SELECT cid, cnm, pid, pnm, SUM(cnt) cnt
FROM cycle NATURAL JOIN customer NATURAL JOIN product 
WHERE cnm IN ('brown', 'sally')
GROUP BY cid, cnm, pid, pnm;

--�ǽ�(join7)
--cycle, product���̺� �̿�, pid, ��ǰ��(pnm) ��ǰ�� ������ ��(cnt)
SELECT *
FROM cycle;
SELECT *
FROM product;

SELECT a.pid, pnm, cnt
FROM
    (SELECT pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY pid) a,
    product
WHERE a.pid = product.pid;

SELECT cycle.pid, pnm, SUM(cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, pnm;

SELECT cycle.pid, pnm, SUM(cnt) cnt
FROM cycle JOIN product ON (cycle.pid = product.pid)
GROUP BY cycle.pid, pnm;
