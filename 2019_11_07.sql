--emp테이블에는 부서번호(deptno)만 존재
--emp테이블에서 부서명을 조회하기 위해서는
--dept테이블과 조인을 통해 부서명 조회

--조인 문법
--ANSI : 테이블 JOIN 테이블2 ON (테이블.COL = 테이블2.COL)
--      emp JOIN dept ON (emp.deptno = dept.deptno)
--ORACLE : FROM 테이블, 테이블2 WHERE 테이블.co1 = 테이블2.col
--      FROM emp, dept WHERE emp.deptno = dept.deptno

--사원번호, 사원명, 부서번호, 부서명
SELECT empno, ename, deptno, dname
FROM emp NATURAL JOIN dept;

SELECT empno, ename, deptno, dname
FROM emp JOIN dept USING (deptno);

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--실습(join0_2)
--emp dept 테이블 이용, empno, ename, sal, deptno, dname 조회(급여가 2500 초과)
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

--실습(join0_3)
--emp dept 테이블 이용, empno, ename, sal, deptno, dname 조회(급여가 2500 초과, 사번이 7600보다 큰 직원)
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

--실습(join0_4)
--emp dept 테이블 이용, empno, ename, sal, deptno, dname 조회
--(급여가 2500 초과, 사번이 7600보다 크고 부서명이 RESEARCH인 부서에 속한 직원)
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

--실습(join1)
--prod테이블과 lprod테이블을 조인하여 lprod_gu, lprod_nm, prod_id, prod_name 조회
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

--실습(join2)
--prod테이블과 buyer테이블을 조인하여 buyer_id, buyer_name, prod_id, prod_name 조회
SELECT *
FROM buyer;

SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer JOIN prod ON (buyer.buyer_id = prod.prod_buyer)
ORDER BY prod.prod_id;

SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer, prod 
WHERE buyer.buyer_id = prod.prod_buyer
ORDER BY prod.prod_id;

--실습(join3)
--member, cart, prod 테이블 조인, 회원별 장바구니에 담은 제품 정보를 조회
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

--실습(join4)
--customer, cycle 테이블 조인, 고객별 애음제품(pid), 애음 요일(day), 개수(cnt) 조회
--(고객명cnm이 brownm sally만 조회)
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

--실습(join5)
--customer, cycle, product 테이블 조인, 고객별 애음제품(pid), 제품명(pnm), 애음 요일(day), 개수(cnt) 조회
--(고객명cnm이 brownm sally만 조회)
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

--실습(join6)
--customer, cycle, product 테이블 조인, 애음 요일에 관계없이
--고객번호(cid), 고객명(cnm), 고객별 애음제품(pid), 제품명(pnm), 개수(cnt) 조회

--고객, 제품별 애음건수(요일과 관계 없이)
SELECT cid, pid, SUM(cnt) cnt
FROM cycle
GROUP BY cid, pid;

/*WITH cycle_groupby as (
SELECT cid, pid, SUM(cnt) cnt
FROM cycle
GROUP BY cid, pid)*/

--고객과 제품 테이블과 조인
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

--실습(join7)
--cycle, product테이블 이용, pid, 제품명(pnm) 제품별 개수의 합(cnt)
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
