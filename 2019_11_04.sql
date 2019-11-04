--����
--job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������ ���� ���� ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--ROWNUM
SELECT ROWNUM, e.*
FROM emp e;

--ROWNUM ���� ����
--ORDER BY���� SELECT�� ���Ŀ� ����
--ROWNUM �����÷��� ����ǰ� ���� ���ĵǱ� ������ 
--�츮�� ���ϴ´�� ù��° �����ͺ��� �������� ��ȣ �ο��� ���� �ʴ´�.
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

--ORDER BY���� ������ �ζ��� �並 ����
SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;
    
--ROWNUM : 1������ �о���Ѵ�.
--WHERE���� ROWNUM ���� �߰��� �д°� �Ұ���
--�ȵǴ� ���̽�
--WHERE ROWNUM = 2
--WHERE ROWNUM >= 2

--������ ���̽�
--WHERE ROWNUM = 1
--WHERE ROWNUM <= 10

--����¡ ó���� ���� �ļ� ROWNUM�� ��Ī�� �ο�, �ش�sql�� INLINE VIEW�� ���ΰ� ��Ī�� ���� ����¡ ó��
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT e.*
        FROM emp e
        ORDER BY ename) a)
WHERE rn BETWEEN 10 AND 14;

--CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ�
SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD')
FROM dual;
--SUBSTR : ���ڿ��� �κй��ڿ� (1�� �ε������� ����)
SELECT SUBSTR('HELLO, WORLD', 0, 5) substr, SUBSTR('HELLO, WORLD', 1, 5) substr1
FROM dual;
--LENGTH : ���ڿ��� ����
SELECT LENGTH('HELLO, WORLD')
FROM dual;
--INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
SELECT INSTR('HELLO, WORLD', 'O') instr,
       INSTR('HELLO, WORLD', 'O', 6) instr1--INSTR(���ڿ�, ã�� ���ڿ�, Ư���ε��� ������ ��ġ ǥ��)
FROM dual;
--LPAD : ���ڿ� ���ʿ� Ư�� ���ڿ��� ���� / RPAD : �����ʿ� ����
--LPAD(���ڿ�, ��ü ���ڿ�����, ��ü ���ڿ� ���̿� ���ڿ��� ��ġ�� ���� ��� �߰��� ����)
SELECT LPAD('HELLO, WORLD', 15, '*'), RPAD('HELLO, WORLD', 15, '*')
FROM dual;
--REPLACE(�������ڿ�, ���� ���ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���湮�ڿ�)
SELECT REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace
FROM dual;
--TRIM : ���ڿ� �յ� ���� ���� Ȥ�� Ư�� ���� ����
SELECT TRIM('   HELLO, WORLD         ') trim, TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;

--ROUND(������, �ݿø� ��� �ڸ���)
SELECT ROUND(105.54, 1) r1,--�Ҽ��� ��°�ڸ����� �ݿø�
    ROUND(105.55, 1) r2,
    ROUND(105.55, 0) r3, --�Ҽ��� ù°�ڸ����� �ݿø�
    ROUND(105.55, -1) r4 --���� ù°�ڸ����� �ݿø�
FROM dual;

SELECT empno, ename, sal, sal/1000, /*ROUND(sal/1000) quotient,*/ MOD(sal, 1000) reminder
FROM emp;

--TRUNC(������, ���� ��� �ڸ���)
SELECT TRUNC(105.54, 1) t1,--�Ҽ��� ��°�ڸ����� ����
    TRUNC(105.55, 1) t2,
    TRUNC(105.55, 0) t3, --�Ҽ��� ù°�ڸ����� ����
    TRUNC(105.55, -1) t4 --���� ù°�ڸ����� ����
FROM dual;

--SYSDATE : ����Ŭ�� ��ġ�� ������ ���� ��¥ + �ð������� ����
--������ ���ڰ� ���� �Լ�

--TO_CHAR : DATE Ÿ���� ���ڿ��� ��ȯ
--��¥�� ���ڿ��� ��ȯ�ÿ� ������ ����
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') now,
    TO_CHAR(SYSDATE + 30/24/60, 'YYYY/MM/DD HH24:MI:SS') result
FROM dual;

--�ǽ�(fn1)
--2019�� 12�� 31���� date������ ǥ��
--2019�� 12�� 31���� date������ ǥ���ϰ� 5�� ���� ��¥
--���� ��¥
--���� ��¥���� 3�� �� ��
--�� 4�� �÷���(lastday, lastday_before5, now, now_before3)���� ǥ��
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
--�⵵ : YYYY, YY, RRRR, RR : ���ڸ��϶��� ���ڸ��϶��� �ٸ�
--RR : 50���� Ŭ��� ���ڸ��� 19, 50���� ���� ��� ���ڸ��� 20
--YYYY, RRRR�� ����. �������̸� ��������� ǥ��
--D : ������ ���ڷ� ǥ�� (�Ͽ��� = 1, ������ = 2, ... , ����� = 7)
SELECT TO_CHAR(TO_DATE('35/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r1,
    TO_CHAR(TO_DATE('55/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r2,
    TO_CHAR(TO_DATE('35/03/01', 'YY/MM/DD'), 'YYYY/MM/DD') y1,
    TO_CHAR(SYSDATE, 'D') d, --������ ������ = 2
    TO_CHAR(SYSDATE, 'IW') iw, --���� ǥ��
    TO_CHAR(TO_DATE('2019/12/28', 'YYYY/MM/DD'), 'IW') this_year,
    TO_CHAR(TO_DATE('2019/12/29', 'YYYY/MM/DD'), 'IW') this_year,
    TO_CHAR(TO_DATE('2019/12/30', 'YYYY/MM/DD'), 'IW') this_year,
    TO_CHAR(TO_DATE('2019/12/31', 'YYYY/MM/DD'), 'IW') this_year,
    TO_CHAR(TO_DATE('2020/01/01', 'YYYY/MM/DD'), 'IW') this_year
FROM dual;

--�ǽ�(fn2)
--���� ��¥��
--1. ��-��-��(DT_DASH)
--2. ��-��-�� �ð�(24):��:��(DT_DASH_WITH_TIME)
--3. ��-��-��(DT_DD_MM_YYYY)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') dt_dash,
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') dt_dash_with_time,
    TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;

--��¥�� �ݿø�(ROUND), ����(TRUNC)
--ROUND(DATE, '����')
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') hiredate,
    TO_CHAR(ROUND(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') round_yyyy,
    TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') round_mm,
    TO_CHAR(ROUND(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') round_dd,
    TO_CHAR(ROUND(hiredate + 13/24, 'DD'), 'YYYY/MM/DD HH24:MI:SS') round_dd,
    TO_CHAR(ROUND(hiredate - 2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') round_mm
FROM emp
WHERE ename = 'SMITH';

--��¥�� �ݿø�(ROUND), ����(TRUNC)
--TRUNC(DATE, '����')
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') hiredate,
    TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') TRUNC_yyyy,
    TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') TRUNC_mm,
    TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') TRUNC_dd,
    TO_CHAR(TRUNC(hiredate + 13/24, 'DD'), 'YYYY/MM/DD HH24:MI:SS') TRUNC_dd,
    TO_CHAR(TRUNC(hiredate - 2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') TRUNC_mm
FROM emp
WHERE ename = 'SMITH';

--��¥ ���� �Լ�
--MONTHS_BETWEEN(DATE, DATE) : �� ��¥ ������ ���� ��
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
    MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
    MONTHS_BETWEEN(TO_DATE('2019/11/17', 'YYYY/MM/DD') , hiredate) months_between
FROM emp
WHERE ename = 'SMITH';

--ADD_MONTHS(DATE, ������) : DATE�� ������ ������ ��¥
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
    ADD_MONTHS(hiredate, 467) add_months,
    ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename = 'SMITH';

--NEXT_DAY(DATE, ����) : DATE ���� ù��° ������ ��¥
SELECT SYSDATE, NEXT_DAY(SYSDATE, 7) first_sat, --���ó�¥ ���� ù ����� ����
    NEXT_DAY(SYSDATE, '�����') first_sat --���ó�¥ ���� ù ����� ����
FROM dual;

--LAST_DAY(DATE) �ش� ��¥�� ���� ���� ������ ����
SELECT SYSDATE, LAST_DAY(SYSDATE) LAST_DAY,
    LAST_DAY(ADD_MONTHS(SYSDATE, 1)) last_day_12
FROM dual;

--DATE + ���� = DATE (DATE���� ������ŭ ������ DATE)
--D1 + ���� = D2
--�纯���� D2 ����
--D1 + ���� - D2 = D2 - D2
--D1 + ���� - D2 = 0
--D1 + ���� = D2
--�纯�� D1 ����
--D1 + ���� - D1 = D2 - D1
--���� = D2 - D1
--��¥���� ��¥�� ���� ���ڰ� ���´�.
SELECT TO_DATE('2019/11/04', 'YYYY/MM/DD') - TO_DATE('2019/11/01', 'YYYY/MM/DD') d1, 
    TO_DATE('2019/12/01', 'YYYY/MM/DD') - TO_DATE('2019/11/01', 'YYYY/MM/DD') d2, 
    --201908 : 2019�� 8���� �ϼ� : 31
    ADD_MONTHS(TO_DATE('201908', 'YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') d3,
    LAST_DAY(TO_DATE('201908', 'YYYYMM')) + 1 - TO_DATE('201908', 'YYYYMM') d3
FROM dual;