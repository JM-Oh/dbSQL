--CURSOR�� ��������� �������� �ʰ�
--LOOP���� inline ���·� cursor ���

--�͸���
SET serveroutput ON;
DECLARE
    --cursor ���� --> LOOP���� inline ����
BEGIN
    --for(String str : list)
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/

--�ǽ�(PRO_3)
--���� ��� : 5
--dt���̺��� ��¥ ������ ���� ��� ���ϴ� ���ν���
CREATE OR REPLACE PROCEDURE avgdt IS
    CURSOR dt_cursor IS
        SELECT * FROM dt ORDER BY dt DESC;    
    prev_dt DATE;
    ind NUMBER := 0;
    diff NUMBER := 0;
BEGIN
    --dt ���̺� ��� ������ ��ȸ   
    FOR rec IN dt_cursor LOOP
        --���� ���� ������(dt) - ���� ������(dt)
        IF ind = 0 THEN --LOOP�� ù����
            prev_dt := rec.dt;
        ELSE
            diff := diff + prev_dt - rec.dt;
            prev_dt := rec.dt;
        END IF;
        ind := ind + 1;
    END LOOP;    
    dbms_output.put_line(diff / (ind - 1));
END;
/
exec avgdt;


SELECT *
FROM daily;
SELECT *
FROM cycle;
--1�� ���� 100�� ��ǰ�� �����ϳ� �Ѱ��� �Դ´�.
--1	        100	        2       1
--�ǽ�(PRO_4)
--create_daily_sales ���ν��� ����
--���ڴ� ����� ex) exec create_daily_sales('201911');
--cycle���̺��� day(����)�� �̿�, ���ڷ� ���� ����� ���ڷ� ����Ͽ� daily ���̺� �ű� ����
CREATE OR REPLACE PROCEDURE create_daily_sales(p_ym VARCHAR2)
IS
    --�޷��� �������� ������ RECORD TYPE
    TYPE cal_row IS RECORD(
        dt VARCHAR2(8),
        d VARCHAR2(1)
    );
    --�޷� ������ ������ table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
    
    --�����ֱ� cursor
    CURSOR cycle_cursor IS
        SELECT *
        FROM cycle;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_ym, 'YYYYMM') + (LEVEL - 1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_ym, 'YYYYMM') + (LEVEL - 1), 'D') d
           BULK COLLECT INTO cal
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(p_ym, 'YYYYMM')), 'DD');
    
    --�����Ϸ��� �ϴ� ����� ���� �����͸� �����Ѵ�.
    DELETE daily WHERE dt LIKE (p_ym || '%');
    
    --�����ֱ� loop
    FOR rec IN cycle_cursor LOOP
        FOR i IN 1..cal.count LOOP
            --�����ֱ��� ���ϰ� ������ ������ ������ ��
            IF rec.day = cal(i).d THEN
                INSERT INTO daily VALUES(rec.cid, rec.pid, cal(i).dt, rec.cnt);
            END IF;
        END LOOP;
    END LOOP;
    COMMIT;
END;
/
exec create_daily_sales('201911');

SELECT *
FROM daily;


SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM
    cycle,
    (SELECT TO_CHAR(TO_DATE(:p_ym, 'YYYYMM') + (LEVEL - 1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(:p_ym, 'YYYYMM') + (LEVEL - 1), 'D') d
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:p_ym, 'YYYYMM')), 'DD')) cal
WHERE cycle.day = cal.d;