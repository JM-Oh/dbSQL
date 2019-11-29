--CURSOR를 명시적으로 선언하지 않고
--LOOP에서 inline 형태로 cursor 사용

--익명블록
SET serveroutput ON;
DECLARE
    --cursor 선언 --> LOOP에서 inline 선언
BEGIN
    --for(String str : list)
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/

--실습(PRO_3)
--간격 평균 : 5
--dt테이블에서 날짜 사이의 간격 평균 구하는 프로시저
CREATE OR REPLACE PROCEDURE avgdt IS
    CURSOR dt_cursor IS
        SELECT * FROM dt ORDER BY dt DESC;    
    prev_dt DATE;
    ind NUMBER := 0;
    diff NUMBER := 0;
BEGIN
    --dt 테이블 모든 데이터 조회   
    FOR rec IN dt_cursor LOOP
        --먼저 읽은 데이터(dt) - 다음 데이터(dt)
        IF ind = 0 THEN --LOOP의 첫시작
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
--1번 고객은 100번 제품을 월요일날 한개를 먹는다.
--1	        100	        2       1
--실습(PRO_4)
--create_daily_sales 프로시져 생성
--인자는 년월값 ex) exec create_daily_sales('201911');
--cycle테이블의 day(요일)를 이용, 인자로 들어온 년월의 일자로 계산하여 daily 테이블에 신규 생성
CREATE OR REPLACE PROCEDURE create_daily_sales(p_ym VARCHAR2)
IS
    --달력의 행정보를 저장할 RECORD TYPE
    TYPE cal_row IS RECORD(
        dt VARCHAR2(8),
        d VARCHAR2(1)
    );
    --달력 정보를 저장할 table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
    
    --애음주기 cursor
    CURSOR cycle_cursor IS
        SELECT *
        FROM cycle;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_ym, 'YYYYMM') + (LEVEL - 1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_ym, 'YYYYMM') + (LEVEL - 1), 'D') d
           BULK COLLECT INTO cal
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(p_ym, 'YYYYMM')), 'DD');
    
    --생성하려고 하는 년월의 실적 데이터를 삭제한다.
    DELETE daily WHERE dt LIKE (p_ym || '%');
    
    --애음주기 loop
    FOR rec IN cycle_cursor LOOP
        FOR i IN 1..cal.count LOOP
            --애음주기의 요일과 일자의 요일이 같은지 비교
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