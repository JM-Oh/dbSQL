--복습
--WHERE
--연산자
-- 비교 : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' (% : 다수의 문자열과 매칭, _ : 정확히 한글자 매칭)
-- IS NULL
-- AND, OR, NOT

--emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는 직원 정보 조회
--BETWEEN
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01', 'YYYY/MM/DD') AND TO_DATE('1986/12/31', 'YYYY/MM/DD');
-- <= >=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD') 
AND hiredate <= TO_DATE('1986/12/31', 'YYYY/MM/DD');

--emp테이블에서 관리자(mgr)이 있는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- 실습(where12)
-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE '78%';

-- 실습(where13)
-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회(LIKE연산자 미사용)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno BETWEEN 7800 AND 7899
OR empno BETWEEN 780 AND 789
OR empno = 78;

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR (empno >= 7800 
AND empno < 7900)
OR (empno >= 780 
AND empno < 790)
OR empno = 78;

-- 실습(where14)
-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR (empno LIKE '78%'
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD'));

-- order by 컬럼명 | 별칭 | 컬럼인덱스 (ASC | DESC)
-- order by 구문은 WHERE 다음에 기술
-- WHERE절이 없을 경우 FROM다음에 기술
-- ename 기준으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename ASC;

--ASC : dafault
--ASC를 안붙여도 위 쿼리와 동일함
SELECT *
FROM emp
ORDER BY ename;

-- ename 기준으로 내림차순 정렬
SELECT *
FROM emp
ORDER BY ename DESC;

--job을 기준으로 내림차순으로 정렬, job이 같을 경우 사번(empno)으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY job DESC, empno;

--별칭으로 정렬하기
--사원번호(empno), 사원명(ename), 연봉(sal * 12) as year_sal
SELECT empno, ename, sal, sal*12 AS year_sal
FROM emp
ORDER BY year_sal;

--SELECT절 컬럼 순서 인덱스로 정렬
SELECT empno, ename, sal, sal*12 AS year_sal
FROM emp
ORDER BY 4;--SELECT절의 4번째가 year_sal이므로

--실습(orderby1)
--dept테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회
desc dept;
SELECT *
FROM dept
ORDER BY dname;
--dept테이블의 모든 정보를 부서위치으로 내림차순 정렬로 조회
SELECT *
FROM dept
ORDER BY loc DESC;

--실습(orderby2)
--emp테이블에서 상여(comm)정보가 있는 사람들만 조회하고,
--상여를 많이 받는 사람이 먼저 조회되도록 하고, 상여가 같을 경우 사번으로 오름차순 정렬
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno;

--실습(orderby3)
--emp테이블에서 관리자가 있는 사람들만 조회하고,
--직군(job)순으로 오름차순 정렬하고, 직업이 같을 경우 사번이 큰 사원이 먼저 조회되도록 작성
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

--실습(orderby4)
--emp테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람 중 급여가 1500이 넘는 사람들만 조회하고
--이름으로 내림차순 정렬
SELECT *
FROM emp
WHERE deptno IN (10, 30)
AND sal > 1500
ORDER BY ename DESC;

--가상컬럼 ROWNUM : SELECT쿼리에 의해 조회된 순서대로 부여된 가상 숫자 컬럼
SELECT ROWNUM, empno, ename 
FROM emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 1; --1이후는 아직 읽지 않았으므로 WHERE ROWNUM = 2 같은 건 쓸 수 없다.

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 10; --이하(<=)나 미만(<)으로는 쓸 수 있다.

--emp 테이블에서 사번(empno), 이름(ename)을 급여 기준으로 오름차순 정렬하고 정렬된 결과순으로 ROWNUM
SELECT empno, ename, sal, ROWNUM
FROM emp
ORDER BY sal;

SELECT ROWNUM, a.* --테이블의 별칭을 a라고 주고 a.*으로 전체 컬럼을 가져온다.
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a; -- 괄호 안쪽 자체가 하나의 테이블로 된다. inline view

--실습(row_1)
--위의 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성
SELECT ROWNUM AS RN, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a
WHERE ROWNUM <= 10;

--실습(row_2)
--위의 테이블에서 ROWNUM 값이 11~20인 값만 조회하는 쿼리를 작성
SELECT *
FROM
(SELECT ROWNUM AS RN, a.*
FROM
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal) a
    ORDER BY ROWNUM DESC)
WHERE ROWNUM <= 4
ORDER BY RN; --너무 쓰레기 같은 방법이었다..

SELECT *
FROM
    (SELECT ROWNUM AS RN, a.*
    FROM
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal) a)
WHERE RN BETWEEN 11 AND 20;

--FUNCTION
--DUAL 테이블 조회 -- 기본적으로 가지고 있는 테이블 DUMMY컬럼 하나에 X인 값이 존재
SELECT 'HELLO WORLD' AS msg
FROM DUAL;

SELECT 'HELLO WORLD'
FROM emp;

--문자열 대소문자 관련 함수
--LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('hello, world') 
FROM dual;

--FUNCTION은 WHERE절에서도 사용가능
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';

--개발자 SQL 칠거지악
--1. 좌변을 가공하지 말아라
--좌변(TABLE의 컬럼)을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
--Function Based Index -> FBI

--CONCAT : 문자열 결합 - 두개의 문자열을 결합하는 함수
SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD')
FROM dual;
--SUBSTR : 문자열의 부분문자열 (1번 인덱스부터 시작)
SELECT SUBSTR('HELLO, WORLD', 0, 5) substr, SUBSTR('HELLO, WORLD', 1, 5) substr1
FROM dual;
--LENGTH : 문자열의 길이
SELECT LENGTH('HELLO, WORLD')
FROM dual;
--INSTR : 문자열의 특정 문자열이 등장하는 첫번째 인덱스
SELECT INSTR('HELLO, WORLD', 'O') instr,
       INSTR('HELLO, WORLD', 'O', 6) instr1--INSTR(문자열, 찾을 문자열, 특정인덱스 이후의 위치 표시)
FROM dual;
--LPAD : 문자열 왼쪽에 특정 문자열을 삽입 / RPAD : 오른쪽에 삽입
--LPAD(문자열, 전체 문자열길이, 전체 문자열 길이에 문자열이 미치지 못할 경우 추가할 문자)
SELECT LPAD('HELLO, WORLD', 15, '*'), RPAD('HELLO, WORLD', 15, '*')
FROM dual;