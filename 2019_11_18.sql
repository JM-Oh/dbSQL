SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'PC03';

SELECT *
FROM PC03.V_EMP_DEPT;

--PC03 계정에서 조회권한을 받은 v_emp_dept view를 hr계정에서 조회하기 위해서는
--계정명.view이름 형식으로 기술을 해야한다.
--매번 계정명을 기술하기 귀찮으므로 시노님을 통해 다른 별칭을 생성

CREATE SYNONYM v_emp_dept FOR PC03.v_emp_dept;

--PC03.v_emp_dept --> v_emp_dept
SELECT *
FROM v_emp_dept;

--시노님 삭제
DROP SYNONYM v_emp_dept;

--hr 계정 비밀번호 : java
--hr 계정 비밀번호 변경 : hr
ALTER USER hr IDENTIFIED BY hr;
--ALTER USER PC03 IDENTIFIED BY java; -- 본인 계정이 아니라 에러

--dictionary
--접두어 : USER : 사용자 소유 객체
--        ALL : 사용자가 사용가능한 객체
--        DBA : 관리자 관점의 전체 객체(일반 사용자는 사용불가)
--        V$ : 시스템과 관련된 view (일반 사용자는 사용불가)

SELECT *
FROM user_tables;

SELECT *
FROM all_tables;

SELECT *
FROM dba_tables
WHERE owner IN ('PC03', 'hr');

--오라클에서 동일한 SQL이란?
--문자가 하나라도 틀리면 안됨
--다음 sql은 같은 결과를 만들어 낼지 몰라도 DBMS에서는 서로 다른 SQL로 인식된다.
SELECT /*bind test */* FROM emp;
SELECT /*bind test */* from emp;
Select /*bind test */*  FROM emp;

Select /*bind test */*  FROM emp WHERE empno = 7369;
Select /*bind test */*  FROM emp WHERE empno = 7499;
Select /*bind test */*  FROM emp WHERE empno = 7521;

Select /*bind test */*  FROM emp WHERE empno = :empno; --바인드변수

SELECT *
FROM V$SQL
WHERE SQL_TEXT LIKE '%bind test%';