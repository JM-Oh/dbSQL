SELECT *
FROM no_emp;

--1. leaf node 찾기
SELECT LPAD(' ', (LEVEL - 1) * 4, ' ') || org_cd org_cd, s_emp
FROM
    (SELECT org_cd, parent_org_cd, SUM(d_emp) s_emp
    FROM
        (SELECT org_cd, parent_org_cd,
               SUM(no_emp/org_cnt) OVER (PARTITION BY gr ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) d_emp
        FROM
            (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr,
                    COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
            FROM
                (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, CONNECT_BY_ISLEAF leaf
                FROM no_emp
                START WITH parent_org_cd IS NULL
                CONNECT BY PRIOR org_cd = parent_org_cd) a
            START WITH leaf = 1
            CONNECT BY PRIOR parent_org_cd = org_cd))
    GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;


--PL/SQL
--할당 연산 :=
--System.out.println(""); --> dbms_output.put_line("");
--set serveroutput on; -- 출력기능 활성화


--PL/SQL
--declare : 변수, 상수 선언
--begin : 로직 실행
--exception : 예외처리

set serveroutput on;
DECLARE
    --번수 선언
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    --SELECT 절의 결과를 변수에 잘 할당했는지 확인
    dbms_output.put_line('dname : ' || dname || '(' || deptno || ')');
END;
/

DECLARE
    --참조 번수 선언(테이블 컬럼타입이 변경되어도 pl/sql 구문을 수정할 필요가 없다.)
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    --SELECT 절의 결과를 변수에 잘 할당했는지 확인
    dbms_output.put_line('dname : ' || dname || '(' || deptno || ')');
END;
/

--10번 부서의 부서 이름과 lco정보를 화면 출력하는 프로시져
--프로시져 명 : printdept
CREATE OR REPLACE PROCEDURE printdept IS
    --변수선언
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = 20;
    
    dbms_output.put_line('dname, loc : ' || dname || ', ' || loc);
END;
/
exec printdept;

CREATE OR REPLACE PROCEDURE printdept_p(p_deptno IN dept.deptno%TYPE)
IS
    --변수선언
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    dbms_output.put_line('dname, loc : ' || dname || ', ' || loc);
END;
/
exec printdept_p(30);

--실습(PRO_1)
--printemp procedure 생성
--param : empno logic : empno에 해당하는 사원의 정보 조회 사원이름, 부서이름을 화면에 출력
CREATE OR REPLACE PROCEDURE printemp(p_empno IN emp.empno%TYPE)
IS
    ename emp.ename%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT ename, dname
    INTO ename, dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno
    AND empno = p_empno;
    
    dbms_output.put_line('ename : ' || ename || ', dname : ' || dname);
END;
/
exec printemp(7369);

--실습(PRO_2)
--registdept_test procedure 생성
--param : deptno, dname, loc
--logic : 입력받은 부서 정보를 dept_test테이블에 신규 입력
--exec registdept_test(99, 'ddit', 'daejeon');
--dept_test테이블에 정상적으로 입력되었는지 확인
SELECT *
FROM dept_test;

CREATE OR REPLACE PROCEDURE
registdept_test(p_deptno IN dept_test.deptno%TYPE, p_dname IN dept_test.dname%TYPE, p_loc IN dept_test.loc%TYPE)
IS
BEGIN
    INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc);
END;
/
exec registdept_test(99, 'ddit', 'daejeon');