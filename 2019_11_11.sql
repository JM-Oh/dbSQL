--SMiTH, WARD사원이 속한 부서의 모든 사원 정보 조회
SELECT *
FROM emp
WHERE deptno IN (
    SELECT deptno
    FROM emp
    WHERE ename IN (:name1, :name2));
    
--ANY : set 중에 만족하는게 하나라도 있으면 참으로(크기 비교)
--SMITH 또는 WARD의 급여보다 적은 급여를 받는 직원 정보 조회
SELECT *
FROM emp
WHERE sal < ANY (
            SELECT sal --800, 1250
            FROM emp
            WHERE ename IN ('SMITH', 'WARD'));

--SMITH와 WARD보다 급여가 높은 직원 조회
--SMITH보다도 급여가 높고 WARD보다도 급여가 높은 직원
SELECT *
FROM emp
WHERE sal > ALL (
            SELECT sal --800, 1250
            FROM emp
            WHERE ename IN ('SMITH', 'WARD'));

--NOT IN

--관리자인 직원 정보
SELECT DISTINCT mgr
FROM emp;

SELECT *
FROM emp
WHERE empno IN (
            SELECT mgr
            FROM emp);
            
--관리자가 아닌 직원 정보
--단 NOT IN 연산자 사용시 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
--NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용.
SELECT *
FROM emp
WHERE empno NOT IN ( --null값이 있어서 값이 나오지 않으므로
            SELECT mgr
            FROM emp
            WHERE mgr IS NOT NULL); --null값을 제외해준다.
            
--pair wise
--사번 7499, 7782인 직원의 관리자, 부서번호 조회
SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);
--7698 30, 7839 10

--직원중에 관리자와 부서번호가 (7698, 30), (7839 10)인 직원
--mgr, deptno컬럼을 동시에 만족시키는 직원 정보 조회
SELECT *
FROM emp
WHERE (mgr, deptno) IN (
                    SELECT mgr, deptno
                    FROM emp
                    WHERE empno IN (7499, 7782));
                    
SELECT *
FROM emp
WHERE mgr IN (
          SELECT mgr
          FROM emp
          WHERE empno IN (7499, 7782))
AND deptno IN (
           SELECT deptno
           FROM emp
           WHERE empno IN (7499, 7782)); --따로 만족시키므로 결과가 달라진다.(7698 30, 7698 10, 7839 30, 7839 10)
           
--SCALAR SUBQUERY : SELECT절에 등장하는 서브쿼리(단 값이 하나의 행, 하나의 컬럼)
--직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;

--sub4 데이터 생성
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

--실습(sub4)
--dept테이블에는 신규등록된 99번 부서에 속하는 직원이 없음. 직원이 속하지 않는 부서를 조회
SELECT *
FROM dept;

SELECT *
FROM dept
WHERE deptno NOT IN ( 
             SELECT deptno
             FROM emp);
             
--실습(sub5)
--cycle, product 테이블에서 cid=1인 고객이 애음하지 않는 제품 조회
SELECT *
FROM cycle;
SELECT *
FROM product;

SELECT *
FROM product
WHERE pid NOT IN(
          SELECT pid
          FROM cycle
          WHERE cid = 1);
          
--실습(sub6)
--cycle에서 cid=2인 고객이 애음하는 제품 중 cid=1인 고객도 애음하는 제품의 애음정보 조회
SELECT *
FROM cycle
WHERE pid IN (
          SELECT pid
          FROM cycle
          WHERE cid = 2)
AND cid = 1;

--실습(sub7)
--cycle에서 cid=2인 고객이 애음하는 제품 중 cid=1인 고객도 애음하는 제품의 애음정보 조회하고 고객명과 제품명까지 포함하는 쿼리
--scalar subquery 사용
SELECT cid,
       (SELECT cnm FROM customer WHERE cid = cycle.cid) cnm, 
       pid,
       (SELECT pnm FROM product WHERE pid = cycle.pid) pnm,
       day,
       cnt
FROM cycle
WHERE pid IN (
          SELECT pid
          FROM cycle
          WHERE cid = 2)
AND cid = 1;

--inline view 사용
SELECT a.cid, customer.cnm, a.pid, product.pnm, day, cnt
FROM 
    (SELECT *
    FROM cycle
    WHERE pid IN (
              SELECT pid
              FROM cycle
              WHERE cid = 2)
    AND cid = 1) a,
    customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;

--subquery 사용
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, day, cnt
FROM cycle, customer, product
WHERE cycle.pid IN (
          SELECT pid
          FROM cycle
          WHERE cid = 2)
AND cycle.pid = product.pid
AND cycle.cid = customer.cid
AND cycle.cid = 1;

--EXISTS MAIN쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
--만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에 성능면에서 유리

--mgr가 존재하는 직원 조회
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
--mgr가 존재하지 않는 직원 조회
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X'
                  FROM emp
                  WHERE empno = a.mgr);
                  
--실습(sub8)
--mgr가 존재하는 직원 조회(아래 쿼리를 subquery사용하지 않고)
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--부서에 소속된 직원이 있는 부서 정보 조회(EXISTS)
SELECT *
FROM dept
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE deptno = dept.deptno);

SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                 FROM emp);
                 
--집합연산
--UNION : 합집합. 중복을 제거.
--        DBMS에서는 중복을 제거하기 위해 데이터를 정렬(대량의 데이터에 대해 정렬 시 부하)
--UNION ALL : UNION과 같은 개념
--            중복을 제거하지 않고, 위아래 집합을 결합 -> 중복가능
--            위아래 집합에 중복되는 데이터가 없다는 것을 확신하면 UNION연산자보다 성능면에서 유리
--사번이 7566 또는 7698인 사원 조회(사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION
--사번이 7369 또는 7499인 사원 조회(사번, 이름)
SELECT empno, ename
FROM emp
--WHERE empno IN (7369, 7499);
WHERE empno IN (7566, 7698);

--UNION ALL(중복 허용, 위아래 집합을 합치기만 한다.)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--INTERSECT(교집합 : 위아래 집합간 공통 데이터)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);

--MINUS(차집합 : 위 집합에서 아래 집합을 제거)
--순서가 존재
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369);

SELECT 1 n, 'x' m
FROM dual
UNION
SELECT 2, 'y'
FROM dual;

SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'PC03'
AND TABLE_NAME IN ('PROD', 'LPROD')
AND CONSTRAINT_TYPE IN ('P', 'R');