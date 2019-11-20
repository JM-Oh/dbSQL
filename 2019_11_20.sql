--GROUPING (cube, rollup절에 사용된 컬럼)
--해당 컬럼이 소계 계산에 사용된 경우 : 1
--사용되지 않은 경우 : 0

--job컬럼
--case1, GROUPING(job) = 1 AND GROUPING(deptno) = 1
--       job --> '총계'
--case else
--       job --> job
SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '총계'
            ELSE job
       END job, deptno,
       GROUPING(job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

SELECT job, deptno,
       GROUPING(job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--실습(GROUP_AD2)총계와 소계를 넣기
SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '총계'
            ELSE job
       END job, 
       CASE WHEN GROUPING(job) = 0 AND
                 GROUPING(deptno) = 1 THEN job ||' 소계'
            ELSE TO_CHAR(deptno)
       END deptno,
       SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--실습(GROUP_AD3)
SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

--실습(GROUP_AD4)
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

--실습(GROUP_AD5)
SELECT NVL(a.dname, '총합') dname, a.job, a.sal
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
        THEN '총합'
        ELSE dname
    END dname, job, SUM(sal) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job)
ORDER BY dname, job DESC;
    
    
--CUBE (col, col2,...)
--CUBE 절에 나열된 컬럼의 가능한 모든 조합에 대해 서브 그룹으로 생성
--CUBE에 나열된 컬럼에 대해 방향성은 없다.(rollup과의 차이)
--GROUP BY CUBE(job, deptno)
--OO : GROUP BY job, deptno
--OX : GROUP BY job
--XO : GROUP BY deptno
--XX : GROUP BY -- 모든 데이터에 대해서

--GROUP BY CUBE(job, deptno, mgr) --8가지

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE (job, deptno);

--subquery를 통한 업데이트
DROP TABLE emp_test;

--emp테이블의 데이터를 포함해서 모든 컬럼을 이용하여 emp_test테이블로 생성
CREATE TABLE emp_test AS
SELECT *
FROM emp;

--emp_test테이블의 dept테이블에서 관리되고 있는 dname컬럼(VARCHAR2(14))을 추가
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

--emp_test테이블의 dname컬럼을 dept테이블의 컬럼 값으로 업데이트하는 쿼리 작성
UPDATE emp_test SET dname = (SELECT dname
                            FROM dept
                            WHERE dept.deptno = emp_test.deptno);
COMMIT;

--실습(sub_a1)
--dept테이블을 이용하여 dept_test생성
--dept_test테이블에 empcnt(number)컬럼 추가
--subquery를 이용하여 dept_test테이블의 empcnt컬럼에 해당 부서원 수를 update
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

--실습(sub_a2)
--dept_test테이블에서 emp테이블의 직원들이 속하지 않은 부서 삭제
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

--실습(sub_a2)
--emp_test테이블에서 subquery를 이용하여 본인이 속한 부서의 평균 급여보다 작은 직원의 급여를 +200 업데이트
UPDATE emp_test SET sal = sal + 200
WHERE sal < (SELECT AVG(sal)
            FROM emp_test a 
            WHERE emp_test.deptno = a.deptno);

SELECT AVG(sal) avg
FROM emp_test
WHERE deptno = 30;

SELECT *
FROM emp_test;

--emp, emp_test empno컬럼으로 같은 값끼리 조회
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
WHERE emp.empno = emp_test.empno;
--2. emp.empno, emp.ename, emp.sal, emp_test.sal, deptno, sal_avg
--emp테이블 기준의 부서 급여평균
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal, emp.deptno, sal_avg
FROM emp, emp_test,
    (SELECT deptno, ROUND(AVG(sal), 2) sal_avg
    FROM emp
    GROUP BY deptno) a
WHERE emp.empno = emp_test.empno
AND emp.deptno = a.deptno;