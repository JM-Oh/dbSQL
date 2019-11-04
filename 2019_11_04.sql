--복습
--job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원 정보 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--ROWNUM
SELECT ROWNUM, e.*
FROM emp e;

--ROWNUM 정렬 문제
--ORDER BY절은 SELECT절 이후에 동작
--ROWNUM 가상컬럼이 적용되고 나서 정렬되기 때문에 
--우리가 원하는대로 첫번째 데이터부터 순차적인 번호 부여가 되질 않는다.
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

--ORDER BY절을 포함한 인라인 뷰를 구성
SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;
    
--ROWNUM : 1번부터 읽어야한다.
--WHERE절에 ROWNUM 값을 중간만 읽는건 불가능
--안되는 케이스
--WHERE ROWNUM = 2
--WHERE ROWNUM >= 2

--가능한 케이스
--WHERE ROWNUM = 1
--WHERE ROWNUM <= 10

--페이징 처리를 위한 꼼수 ROWNUM에 별칭을 부여, 해당sql을 INLINE VIEW로 감싸고 별칭을 통해 페이징 처리
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT e.*
        FROM emp e
        ORDER BY ename) a)
WHERE rn BETWEEN 10 AND 14;

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
--REPLACE(원본문자열, 원본 문자열에서 변경하고자 하는 대상 문자열, 변경문자열)
SELECT REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace
FROM dual;
--TRIM : 문자열 앞뒤 공백 제거 혹은 특정 문자 제거
SELECT TRIM('   HELLO, WORLD         ') trim, TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;

--ROUND(대상숫자, 반올림 결과 자리수)
SELECT ROUND(105.54, 1) r1,--소수점 둘째자리에서 반올림
    ROUND(105.55, 1) r2,
    ROUND(105.55, 0) r3, --소수점 첫째자리에서 반올림
    ROUND(105.55, -1) r4 --정수 첫째자리에서 반올림
FROM dual;

SELECT empno, ename, sal, sal/1000, /*ROUND(sal/1000) quotient,*/ MOD(sal, 1000) reminder
FROM emp;

--TRUNC(대상숫자, 내림 결과 자리수)
SELECT TRUNC(105.54, 1) t1,--소수점 둘째자리에서 절삭
    TRUNC(105.55, 1) t2,
    TRUNC(105.55, 0) t3, --소수점 첫째자리에서 절삭
    TRUNC(105.55, -1) t4 --정수 첫째자리에서 절삭
FROM dual;

--SYSDATE : 오라클이 설치된 서버의 현재 날짜 + 시간정보를 리턴
--별도의 인자가 없는 함수

--TO_CHAR : DATE 타입을 문자열로 변환
--날짜를 문자열로 변환시에 포맷을 지정
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') now,
    TO_CHAR(SYSDATE + 30/24/60, 'YYYY/MM/DD HH24:MI:SS') result
FROM dual;

--실습(fn1)
--2019년 12월 31일을 date형으로 표현
--2019년 12월 31일을 date형으로 표현하고 5일 이전 날짜
--현재 날짜
--현재 날짜에서 3일 전 값
--위 4개 컬럼명(lastday, lastday_before5, now, now_before3)으로 표현
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') lastday,
    TO_DATE('2019/12/31', 'YYYY/MM/DD') - 5  lastday_before5,
    SYSDATE now,
    SYSDATE - 3 now_before3
FROM dual;

SELECT lastday, lastday - 5 lastday_before5, now, now - 3 now_before3
FROM
    (SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') lastday, SYSDATE now
    FROM dual);
    
--date format
--년도 : YYYY, YY, RRRR, RR : 두자리일때랑 네자리일때랑 다름
--RR : 50보다 클경우 앞자리는 19, 50보다 작을 경우 앞자리는 20
--YYYY, RRRR은 동일. 가급적이면 명시적으로 표현
--D : 요일을 숫자로 표기 (일요일 = 1, 월요일 = 2, ... , 토요일 = 7)
SELECT TO_CHAR(TO_DATE('35/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r1,
    TO_CHAR(TO_DATE('55/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r2,
    TO_CHAR(TO_DATE('35/03/01', 'YY/MM/DD'), 'YYYY/MM/DD') y1,
    TO_CHAR(SYSDATE, 'D') d, --오늘은 월요일 = 2
    TO_CHAR(SYSDATE, 'IW') iw, --주차 표기
    TO_CHAR(TO_DATE('2019/12/28', 'YYYY/MM/DD'), 'IW') this_year,
    TO_CHAR(TO_DATE('2019/12/29', 'YYYY/MM/DD'), 'IW') this_year,
    TO_CHAR(TO_DATE('2019/12/30', 'YYYY/MM/DD'), 'IW') this_year,
    TO_CHAR(TO_DATE('2019/12/31', 'YYYY/MM/DD'), 'IW') this_year,
    TO_CHAR(TO_DATE('2020/01/01', 'YYYY/MM/DD'), 'IW') this_year
FROM dual;

--실습(fn2)
--오늘 날짜를
--1. 년-월-일(DT_DASH)
--2. 년-월-일 시간(24):분:초(DT_DASH_WITH_TIME)
--3. 일-월-년(DT_DD_MM_YYYY)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') dt_dash,
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') dt_dash_with_time,
    TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;

--날짜의 반올림(ROUND), 절삭(TRUNC)
--ROUND(DATE, '포맷')
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') hiredate,
    TO_CHAR(ROUND(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') round_yyyy,
    TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') round_mm,
    TO_CHAR(ROUND(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') round_dd,
    TO_CHAR(ROUND(hiredate + 13/24, 'DD'), 'YYYY/MM/DD HH24:MI:SS') round_dd,
    TO_CHAR(ROUND(hiredate - 2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') round_mm
FROM emp
WHERE ename = 'SMITH';

--날짜의 반올림(ROUND), 절삭(TRUNC)
--TRUNC(DATE, '포맷')
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') hiredate,
    TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') TRUNC_yyyy,
    TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') TRUNC_mm,
    TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') TRUNC_dd,
    TO_CHAR(TRUNC(hiredate + 13/24, 'DD'), 'YYYY/MM/DD HH24:MI:SS') TRUNC_dd,
    TO_CHAR(TRUNC(hiredate - 2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') TRUNC_mm
FROM emp
WHERE ename = 'SMITH';

--날짜 연산 함수
--MONTHS_BETWEEN(DATE, DATE) : 두 날짜 사이의 개월 수
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
    MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
    MONTHS_BETWEEN(TO_DATE('2019/11/17', 'YYYY/MM/DD') , hiredate) months_between
FROM emp
WHERE ename = 'SMITH';

--ADD_MONTHS(DATE, 개월수) : DATE의 개월수 이후의 날짜
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
    ADD_MONTHS(hiredate, 467) add_months,
    ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename = 'SMITH';

--NEXT_DAY(DATE, 요일) : DATE 이후 첫번째 요일의 날짜
SELECT SYSDATE, NEXT_DAY(SYSDATE, 7) first_sat, --오늘날짜 이후 첫 토요일 일자
    NEXT_DAY(SYSDATE, '토요일') first_sat --오늘날짜 이후 첫 토요일 일자
FROM dual;

--LAST_DAY(DATE) 해당 날짜가 속한 월의 마지막 일자
SELECT SYSDATE, LAST_DAY(SYSDATE) LAST_DAY,
    LAST_DAY(ADD_MONTHS(SYSDATE, 1)) last_day_12
FROM dual;

--DATE + 정수 = DATE (DATE에서 정수만큼 이후의 DATE)
--D1 + 정수 = D2
--양변에서 D2 차감
--D1 + 정수 - D2 = D2 - D2
--D1 + 정수 - D2 = 0
--D1 + 정수 = D2
--양변에 D1 차감
--D1 + 정수 - D1 = D2 - D1
--정수 = D2 - D1
--날짜에서 날짜를 빼면 일자가 나온다.
SELECT TO_DATE('2019/11/04', 'YYYY/MM/DD') - TO_DATE('2019/11/01', 'YYYY/MM/DD') d1, 
    TO_DATE('2019/12/01', 'YYYY/MM/DD') - TO_DATE('2019/11/01', 'YYYY/MM/DD') d2, 
    --201908 : 2019년 8월의 일수 : 31
    ADD_MONTHS(TO_DATE('201908', 'YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') d3,
    LAST_DAY(TO_DATE('201908', 'YYYYMM')) + 1 - TO_DATE('201908', 'YYYYMM') d3
FROM dual;