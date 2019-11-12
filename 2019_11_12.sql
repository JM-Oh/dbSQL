DESC emp;

INSERT INTO emp (ename, job)
VALUES ('brown', null);

SELECT *
FROM emp
WHERE empno = 9999;

rollback;

DESC emp;

SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP'
ORDER BY column_id;

INSERT INTO emp
VALUES (9999, 'brown', 'ranger', null, SYSDATE, 2500, null, 40);

--SELECT 결과(여러건)를 INSERT
INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROM dept;
COMMIT;

SELECT *
FROM emp;

--UPDATE
--UPDATE 테이블 SET 컬럼=값, 컬럼=값...
--WHERE condition

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
commit;

SELECT *
FROM dept;

UPDATE dept SET dname = '대덕IT', loc = 'ym'
WHERE deptno = 99;

ROLLBACK;

SELECT *
FROM emp;

--DELETE 테이블명
--WHERE condition
--사원번호가 9999인 직원을 emp 테이블에서 삭제
DELETE emp
WHERE empno = 9999;

--부서테이블을 이용해서 emp테이블에 입력한 4건의 데이터를 삭제
--10, 20, 30, 40, 99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;

ROLLBACK;

DELETE emp
WHERE empno BETWEEN 10 AND 99;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

COMMIT;

SELECT * 
FROM emp;

--LV1 -> LV3
SET TRANSACTION
ISOLATION LEVEL SERIALIZABLE;

--DML문장을 통해 트랜잭션 시작
INSERT INTO dept
VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept;

--DDL : auto commit, rollback이 안된다.
--CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,   --숫자 타입
    ranger_name VARCHAR2(50), --문자 : VARCHAR2가 보편화, CHAR
    reg_dt DATE DEFAULT SYSDATE --DEFAULT : SYSDATE
);
DESC ranger_new;

--ddl은 rollback이 적용되지 않는다.
rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000, 'brown');

SELECT *
FROM ranger_new;
commit;

--날짜 타입에서 특정 필드 가져오기
--ex : sysdate에서 년도만 가져오기
SELECT TO_CHAR(SYSDATE, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt, 'MM') mm, 
       EXTRACT(MONTH FROM reg_dt) mm,
       EXTRACT(YEAR FROM reg_dt) year,
       EXTRACT(DAY FROM reg_dt) day
FROM ranger_new;

--제약 조건
--dept테이블 모방해서 dept_test 생성
DESC dept_test;
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY, --deptno컬럼을 식별자로 지정
    dname VARCHAR2(14),           --식별자로 지정이 되면 값이 중복이 될수 없으며, null일 수도 없다.
    loc VARCHAR2(13)
);

--primary key 제약 조건 확인
--1. deptno컬럼에 null이 들어갈 수 없다.
--2. deptno컬럼에 중복된 값이 들어갈 수 없다.
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test
VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test
VALUES (1, 'ddit2', 'daejeon');

ROLLBACK;

--사용자 지정 제약조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname) --식별자가 복합이므로
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon'); --dname까지도 같아야 중복으로 인식한다.
SELECT *
FROM dept_test;
ROLLBACK;

--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, null, 'daejeon');

--UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, 'ddit', 'daejeon');