--테이블에서 데이터 조회
/*
    SELECT 컬럼 : express (문자열 상수)
    FROM 데이터를 조회할 테이블(VIEW)
    WHERE 조건 (condition)
*/

DESC user_tables;
SELECT table_name, 'SELECT * FROM ' || table_name || ';' AS select_query
FROM user_tables
WHERE TABLE_NAME != 'EMP';
--전체 건수 - 1


-- 숫자 비교 연산
-- 부서 번호가 30번보다 크거나 같은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno >= 30;

-- 부서번호가 30번보다 작은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno < 30;

-- 입사일자가 1982년 1월 1일 이후인 직원 조회
SELECT *
FROM emp
WHERE hiredate < TO_DATE('01/01/1982', 'MM/DD/YYYY'); --11명
--WHERE hiredate < TO_DATE('1982/01/01', 'YYYY/MM/DD'); --11명
--WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD'); --3명

-- BETWEEN X AND Y 연산
-- 컬럼의 값이 X보다 크거나 같고, Y보다 작거나 같은 데이터
-- 급여(sal)가 1000보다 크거나 같고, Y보다 작거나 같은 데이터를 조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

-- 위의 BETWEEN AND연산자를 아래의 <=, >=조합과 같다.
SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000
  AND deptno = 30;

-- 실습 (where1)
-- emp 테이블에서 입사일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의 enaeme, hiredate를 조회하는 쿼리 작성
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM/DD');
-- 실습 (where2)
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

-- IN 연산지
-- COL IN (values...)
-- 부서번호가 10 혹으 20인 직원 조회
SELECT *
FROM emp
WHERE deptno IN(10, 20);

-- IN 연산자는 OR 연산자로 표현할 수 있다.
SELECT *
FROM emp
WHERE deptno = 10
OR deptno = 20;

-- 실습 (where3)
--users 테이블에서 userid가 brown, cony, sally인 데이터를 조회
SELECT userid AS 아이디, usernm 이름, '별명'
FROM users
WHERE userid IN('brown', 'cony', 'sally');

SELECT userid AS 아이디, usernm 이름, '별명'
FROM users
WHERE userid = 'brown'
OR userid = 'cony'
OR userid = 'sally';

-- COL LIKE  'S%'
-- COL의 값이 대문자 S로 시작하는 모든 값
-- COL LIKE 'S____'
-- COL의 값이 대문자 S로 시작하고 이어서 4개의 문자열이 존재하는 값

-- emp테이블에서 직원 이름이 S로 시작하는 모든 직원 조회
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- 실습(where4)
-- member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리 작성
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

-- 실습(where5)
-- member 테이블에서 회원의 이름에 글자[이]가 들어가는 사람의 mem_id, mem_name을 조회하는 쿼리 작성
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

-- NULL 비교
-- COL IS NULL
-- emp 테이블에서 MGR정보가 없는 사람(NULL) 조회
SELECT *
FROM emp
WHERE mgr IS NULL;

-- 소속부서가 10번이 아닌 직원들
SELECT *
FROM emp
WHERE deptno != 10;
-- =, !=
-- IS NULL, IS NOT NULL

-- 실습(where6)
-- emp 테이블에서 상여(comm)가 있는 회원의 정보를 다음과 같이 조회되도록 쿼리 작성
SELECT *
FROM emp
WHERE comm IS NOT NULL;

-- AND / OR
-- emp 테이블에서 관리자(mgr) 사번이 7698이고 급여(sal)가 1000이상인 사람
SELECT *
FROM emp
WHERE mgr = 7698
AND sal >= 1000;

-- emp 테이블에서 관리자(mgr) 사번이 7698이거나 급여(sal)가 1000이상인 사람
SELECT *
FROM emp
WHERE mgr = 7698
OR sal >= 1000;

-- NOT
-- emp테이블에서 관리자(mgr)사번이 7698이 아니고 7839가 아닌 직원을 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);
-- 위의 쿼리를 AND/OR 연산자로 변환
SELECT *
FROM emp
WHERE mgr !=7698
AND mgr != 7839;

-- IN, NOT IN 연산자의 NULL 처리
-- emp 테이블에서 관리자(mgr) 사번이 7698, 7839 또는 null이 아닌 직원을 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
AND mgr IS NOT NULL;

-- 실습(where7)
-- emp 테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN'
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');

-- 실습(where8)
-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회(NOT IN연산자 미사용)
SELECT *
FROM emp
WHERE deptno != 10
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');

-- 실습(where9)
-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회(NOT IN연산자 사용)
SELECT *
FROM emp
WHERE deptno NOT IN (10)
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');

-- 실습(where10)
-- emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회
-- (IN연산자 사용, 부서는 10, 20, 30만 있다고 가정)
SELECT *
FROM emp
WHERE deptno IN (20, 30)
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');

-- 실습(where11)
-- emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');

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
OR empno BETWEEN 7800 AND 7899;

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno >= 7800 
AND empno < 7900;

-- 실습(where14)
-- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE '78%'
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');