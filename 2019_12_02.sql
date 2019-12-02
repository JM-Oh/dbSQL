--�͸� ���
SET serveroutput ON;

DECLARE
    --����̸��� ������ ��Į�� ����(1���� ��)
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename
    FROM emp;
    --��ȸ����� �������ε� ��Į�� ������ ���� �����Ϸ��� �Ѵ�.
    -- -> ����
    --�߻�����, �߻����ܸ� Ư�� ���� ���鶧 -> OTHERS(java : Exception)
    EXCEPTION
        WHEN others THEN
            dbms_output.put_line('Exception others');
END;
/

--����� ���� ����
DECLARE
    --emp ���̺� ��ȸ�� ����� ���� ��� �߻���ų ����� ���� ����
    --���ܸ� EXCEPTION; --������ ����Ÿ��
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
                dbms_output.put_line('������ ������');
                --����ڰ� ������ ����� ���� ���ܸ� ����
                RAISE NO_EMP;
    END;
    
    EXCEPTION
        WHEN NO_EMP THEN
            dbms_output.put_line('no_emp exception');
END;
/

--�����ȣ�� �Է��ϰ� �ش� ����� �̸��� �����ϴ� �Լ�(function)
CREATE OR REPLACE FUNCTION getEmpName(P_empno emp.empno%TYPE)
RETURN VARCHAR2
IS
    --�����
    ret_ename emp.ename%TYPE;
BEGIN
    --����
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

--�ǽ�(function1)
--�μ���ȣ�� �Ķ���ͷ� �Է¹ް� �ش� �μ��� �̸� �����ϴ� �Լ� getdeptname �ۼ�
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

--�ǽ�(function2)
--�������� �� LPAD�κ��� indent��� �̸��� �Լ��� ��ü

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

--users ���̺��� pass �÷��� ����� ���
--users_history�� ������ pass�� �̷����� ����� Ʈ����
CREATE OR REPLACE TRIGGER make_history
    BEFORE UPDATE ON users --users ���̺��� ������Ʈ ����
    FOR EACH ROW
    
    BEGIN
        --:NEW.�÷��� : ������Ʈ ������ �ۼ��� ��
        --:OLD.�÷��� : ���� ���̺� ��
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

