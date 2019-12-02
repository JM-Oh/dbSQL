--익명 블록
SET serveroutput ON;

DECLARE
    --사원이름을 저장할 스칼라 변수(1개의 값)
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename
    FROM emp;
    --조회결과는 여러건인데 스칼라 변수에 값을 저장하려고 한다.
    -- -> 에러
    --발생예외, 발생예외를 특정 짓기 힘들때 -> OTHERS(java : Exception)
    EXCEPTION
        WHEN others THEN
            dbms_output.put_line('Exception others');
END;
/

--사용자 정의 예외
DECLARE
    --emp 테이블 조회시 결과가 없을 경우 발생시킬 사용자 정의 예외
    --예외명 EXCEPTION; --변수명 변수타입
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    BEGIN
        SELECT ename
        INTO v_ename
        FROM emp
        WHERE empno = 9999;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                dbms_output.put_line('데이터 미존재');
                --사용자가 생성한 사용자 정의 예외를 생성
                RAISE NO_EMP;
    END;
    
    EXCEPTION
        WHEN NO_EMP THEN
            dbms_output.put_line('no_emp exception');
END;
/

--사원번호를 입력하고 해당 사원의 이름을 리턴하는 함수(function)
CREATE OR REPLACE FUNCTION getEmpName(P_empno emp.empno%TYPE)
RETURN VARCHAR2
IS
    --선언부
    ret_ename emp.ename%TYPE;
BEGIN
    --로직
    SELECT ename
    INTO ret_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN ret_ename;
END;
/
SELECT getEmpName(7369)
FROM dual;

SELECT empno, ename, getEmpName(empno)
FROM emp;

--실습(function1)
--부서번호를 파라미터로 입력받고 해당 부서의 이름 리턴하는 함수 getdeptname 작성
CREATE OR REPLACE FUNCTION getdeptname(p_deptno dept.deptno%TYPE)
RETURN dept.dname%TYPE
IS
    ret_dname dept.dname%TYPE;
BEGIN
    SELECT dname
    INTO ret_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN ret_dname;
END;
/

SELECT getdeptname(40)
FROM dual;

SELECT empno, ename, deptno, getdeptname(deptno)
FROM emp;

--실습(function2)
--계층쿼리 시 LPAD부분을 indent라는 이름의 함수로 대체

SELECT deptcd, LPAD(' ', (LEVEL - 1) * 4, ' ') || deptnm deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT *
FROM dept_h;

CREATE OR REPLACE FUNCTION indent(p_level NUMBER, p_dname dept_h.deptnm%TYPE)
RETURN VARCHAR2
IS
    ret_deptnm VARCHAR2(50);
BEGIN
    SELECT LPAD(' ', (P_level - 1) * 4, ' ') || p_dname
    INTO ret_deptnm
    FROM dual;
    RETURN ret_deptnm;
END;
/

SELECT deptcd, deptnm, indent(LEVEL, deptnm)
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;


CREATE TABLE user_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE
);

--users 테이블의 pass 컬럼이 변경될 경우
--users_history에 변경전 pass를 이력으로 남기는 트리거
CREATE OR REPLACE TRIGGER make_history
    BEFORE UPDATE ON users --users 테이블을 업데이트 전에
    FOR EACH ROW
    
    BEGIN
        --:NEW.컬럼명 : 업데이트 쿼리시 작성한 값
        --:OLD.컬럼명 : 현재 테이블 값
        IF :NEW.pass != :OLD.pass THEN
            INSERT INTO user_history
            VALUES (:OLD.userid, :OLD.pass, SYSDATE);
        END IF;
    END;
/
SELECT *
FROM users;

UPDATE users SET pass = 'newpass';

SELECT *
FROM user_history;

