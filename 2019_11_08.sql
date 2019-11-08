--조인 복습
--조인 왜??
--RDBMS의 특성상 데이터의 중복을 최대한 배제한 설계를 한다.
--emp 테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는
--부서번호만 갖고 있고, 부서번호를 통해 dept테이블과 조인을 통해
--해당 부서의 정보를 가져올 수 있다.

--직원 번호, 직원 이름, 직원의 소속 부서번호, 부서이름
--emp, dept
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--부서번호, 부서명, 해당부서의 인원수
--OCUNT(col) : col값이 존재하면 1, null이면 0
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

--OUTER JOIN : 조인에 실패해도 기준이 되는 테이블의 데이터는 조회결과가 나오도록 하는 형태
--LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이 되도록하는 형태
--RIGHT OUTER JOIN : JOIN KEYWORD 오른쪽에 위치한 테이블이 조회 기준이 되도록하는 형태
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복제거

--직원 정보와, 해당 직원의 관리자 정보 outer join
--직원 번호, 직원이름 관리자 번호, 관리자 이름
SELECT a.empno, a.ename, a.mgr, b.ename mgr_name
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename mgr_name
FROM emp a JOIN emp b ON (a.mgr = b.empno);

--ORACLE OUTER JOIN (left, right만 존재, full outer는 지원하지 않음)
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
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno AND b.deptno = 10);--조인조건에 관리자 소속 부서 번호가 10

SELECT a.empno, a.ename, a.mgr, b.ename mgr_name, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno)
WHERE b.deptno = 10;--조인이 완료된 후 관리자 소속부서가 10번만 조회

--oracle outer 문법에서는 outer 테이블이 되는 모든 컬럼에 (+)를 붙여줘야 outer join이 정상적으로 동작한다.
SELECT a.empno, a.ename, a.mgr, b.ename mgr_name, b.deptno
FROM emp a,emp b 
WHERE a.mgr = b.empno(+)
AND b.deptno(+) = 10;

--ANSI RIGHT OUTER 
SELECT a.empno, a.ename, a.mgr, b.ename mgr_name
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);

--실습(outerjoin1)
--buyprod테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목밖에 없다.
--모든 품목이 나올 수 있도록 작성
--prod테이블과 조인(buy_date, buy_prod, prod_id, prod_name, buy_qty)
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

--실습(outerjoin2)
--실습(outerjoin1)에서 buy_date컬럼의 값이 null이 나오지 않도록
SELECT TO_DATE('20050125', 'YYYYMMDD') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod, buyprod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buyprod.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

--실습(outerjoin3)
--실습(outerjoin2)에서 buy_gty컬럼의 값이 null일 경우 0이 나오도록
SELECT TO_DATE('20050125', 'YYYYMMDD') buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty, 0) buy_qty
FROM prod, buyprod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buyprod.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD');

--실습(outerjoin4)
--cycle, product 테이블을 이용하여 고객이 애음하는 제품명칭을 표현하고, 애음하지 않는 제품도 조회되도록
--고객은 cid=1인 고객만, null처리(pid, pnm, cid, day, cnt)
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

--실습(outerjoin4)
--cycle, product, customer 테이블 이용, 고객이 애음하는 제품명칭을 표현하고, 애음하지 않는 제품도 조회되도록
--고객은 cid=1인 고객만, null처리(pid, pnm, cid, cnm day, cnt)
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

--실습(crossjoin1)
--customer, product테이블 이용하여 고객이 애음 가능한 모든 제품의 정보 결함
SELECT *
FROM customer, product;
SELECT *
FROM customer CROSS JOIN product;

--subquery : main쿼리에 속하는 부분 쿼리
--사용되는 위치 : 
-- SELECT - scalar subquery (하나의 행, 하나의 컬럼만 조회되는 쿼리이어야 한다.)
-- FROM - inline view
-- WHERE - subquery

--scalar subquery
SELECT empno, ename, (SELECT SYSDATE FROM dual) now
FROM emp;

--subquery
--SMITH가 속한 부서의 직원 구하기
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;

--위의 두 쿼리를 합쳐 하나의 쿼리로 작성(subquery)
SELECT *
FROM emp
WHERE deptno = 
    (SELECT deptno
    FROM emp
    WHERE ename = 'SMITH');
    
--실습(sub1)
--평균급여보다 높은 급여를 받는 직원의 수
SELECT COUNT(*)
FROM emp
WHERE sal >
    (SELECT AVG(sal)
    FROM emp);
    
--실습(sub2)
--평균급여보다 높은 급여를 받는 직원의 정보
SELECT *
FROM emp
WHERE sal >
    (SELECT AVG(sal)
    FROM emp);
    
--실습(sub3)
--SMiTH, WARD사원이 속한 부서의 모든 사원 정보 조회
SELECT *
FROM emp
WHERE deptno IN (
    (SELECT deptno
    FROM emp
    WHERE ename IN ('SMITH', 'WARD')));