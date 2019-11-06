--그룹함수
--multi row function : 여러개의 행을 입력으로 하나의 결과 행을 생성
--SUM, MAX, MIN, AVG, COUNT
--GROUP BY col | express
--SELECT 절에는 GROUP BY 절에 기술된 col, express만 표기 가능

--직원 중 가장 높은 급여 조회
--14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

--부서별로 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--실습(grp2)
--emp테이블을 이용하여
--부서기준 직원중 가장 높은 급여
--부서기준 직원중 가장 낮은 급여
--부서기준 직원의 급여 평균
--부서기준 직원의 급여 합
--부서의 직원 중 급여가 있는 직원의 수(null제외)
--부서의 직원 중 상급자가 있는 직원의 수(null제외)
--부서의 직원의 수
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
    ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
    COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY deptno DESC;

--실습(grp3)
--grp2의 부서번호 대신 부서명이 나오도록 작성
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

--실습(grp4)
--emp테이블에서 직원의 입사년월별로 몇명의 직원이 입사했는지 조회
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

--실습(grp5)
--emp테이블에서 직원의 입사년별로 몇명의 직원이 입사했는지 조회
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyy, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

--실습(grp6)
--회사에 존재하는 부서의 개수 조회
SELECT table_name
FROM user_tables;
SELECT COUNT(*) cnt
FROM dept;

--distinct : 중복 제거
SELECT distinct deptno
FROM emp;

--JOIN
--emp 테이블에는 dname 컬럼이 없다. -> 부서번호(deptno)밖에 없음
DESC emp;

--emp테이블에 부서이름을 저장할 수 있는 dname컬럼 추가
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

--ansi natural join : 테이블의 컬럼명이 같은 컬럼을 기준으로 JOIN
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

--from 절에 조인 대상 테이블 나열
--where절에 조인 조건 기술
--기존에 사용하던 조건 제약도 기술 가능
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.job = 'SALESMAN'; --job이 SALESMAN인 사람만 대상으로 조회

--JOIN with ON (개발자가 조인 컬럼을 on절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--SELF join : 같은 테이블끼리 조인
--emp 테이블의 mgr 정보를 참고하기 위해서 emp 테이블과 조인을 해야한다.
--a : 직원정보, b : 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

--oracle join으로
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno BETWEEN 7369 AND 7698;

--none equi join (등식 조인이 아닌 경우)
SELECT *
FROM salgrade;

--직원의 급여 등급은?
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

--실습(join0)
--emp dept 테이블 이용, empno, ename, deptno, dname 조회
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

--실습(join0_1)
--emp dept 테이블 이용, empno, ename, deptno, dname 조회(부서번호 10, 30만 조회)
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