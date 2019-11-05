--년월 파라미터가 주어졌을 때 해당 년월의 일수를 구하는 문제
--201911 -> 30 / 201912 -> 12

--한달 더한 후 원래값을 빼면 일수
--마지막 날짜 구한 후 'DD'만 추충
SELECT :yyyymm param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') dt
FROM dual;

explain plan for
SELECT *
FROM emp
WHERE empno = '7369'; --'7369' 문자열이 숫자로 묵시적 형변환

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM emp
WHERE empno = 7300 + '69';

SELECT empno, ename, sal, TO_CHAR(sal, '$0009,999.99') sal_fmt
FROM emp;

--function null
--nvl(coll, coll이 null일 경우 대체할 값)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm, sal + nvl(comm, 0)
FROM emp;

--NVL2(coll, coll이 null이 아닐 경우 표현되는 값, coll이 null일 경우 대체할 값)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 -> null
--else -> expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3...)
--함수 인자 중 null이 아닌 첫번째 인자
SELECT empno, ename, sal, comm, COALESCE(comm, sal)
FROM emp;

--실습(fn4)
SELECT empno, ename, mgr,
    NVL(mgr, 9999) mgr_n, 
    NVL2(mgr, mgr, 9999) mgr_n, 
    COALESCE(mgr, 9999) mgr_n
FROM emp;
--실습(fn5)
SELECT userid, usernm, reg_dt,
    NVL(reg_dt, SYSDATE) n_reg_dt, 
    NVL2(reg_dt, reg_dt, SYSDATE) n_reg_dt,
    COALESCE(reg_dt, SYSDATE) n_reg_dt
FROM users;

--case when
SELECT empno, ename, job, sal,
    case
        when job = 'SALESMAN' then sal * 1.05
        when job = 'MANAGER' then sal * 1.10
        when job = 'PRESIDENT' then sal * 1.20
        else sal
    end case_sal
FROM emp;

--decode(col, search1, return1, search2, return2,... default)
SELECT empno, ename, job, sal,
    DECODE(job, 'SALESMAN', sal * 1.05, 'MANAGER', sal * 1.1, 'PRESIDENT', sal * 1.2, sal) decode_sal
FROM emp;

--실습(con1)
--emp테이블을 이용 deptno에 따라 부서명으로 변경해서
--10->'ACCOUNTING'
--20->'RESEARCH'
--30->'SALES'
--40->'OPERATIONS'
--기타 다른 값->'DDIT'
SELECT empno, ename, deptno,
    case
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
    end dname,
    DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname
FROM emp;

--실습(con2)
--emp테이블을 이용 hiredate에 따라 올해 건강검진 대상자인지 조회(여기서는 입사년도 기준)
SELECT empno, ename, hiredate,
    CASE
       WHEN MOD(TO_CHAR(hiredate, 'YY'), 2) = MOD(TO_CHAR(SYSDATE, 'YY'), 2) THEN '건강검진 대상자'
       ELSE '건강검진 비대상자'
    END contacttodoctor,
    DECODE(MOD(TO_CHAR(hiredate, 'YY'), 2), MOD(TO_CHAR(SYSDATE, 'YY'), 2), '건강검진 대상자',
            '건강검진 비대상자') contacttodoctor
FROM emp;

--실습(con3)
--users테이블을 이용 reg_dt에 따라 올해 건강검진 대상자인지 조회(여기서는 reg_dt 기준)
SELECT userid, usernm, alias, reg_dt,
    CASE
       WHEN MOD(TO_CHAR(SYSDATE, 'YY') - TO_CHAR(reg_dt, 'YY'), 2) = 0 THEN '건강검진 대상자'
       ELSE '건강검진 비대상자'
    END contacttodoctor,
    DECODE(MOD(TO_CHAR(reg_dt, 'YY') - TO_CHAR(SYSDATE, 'YY'), 2), 0, '건강검진 대상자',
            '건강검진 비대상자') contacttodoctor
FROM users;

--그룹함수 (AVG, MAX, MIN, SUM, COUNT)
--그룹함수의 NULL값을 계산대상에서 제외한다.
--SUM(comm), COUNT(mgr)
--직원 중 가장 높은 급여를 받는 사람
--직원 중 가장 낮은 급여를 받는 사람
--직원의 급여 평균(소수점 둘째자리까지만 나오게)
--직원의 수
SELECT MAX(sal) max_sal, MIN(sal) min_sal,
    ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
    COUNT(*) emp_cnt,
    COUNT(sal) sal_cnt,
    COUNT(mgr) mgr_cnt, --null값은 포함하지 않는다.
    SUM(comm) comm_sum
FROM emp;

--부서별 가장 높은 급여를 받는 사람의 급여
--GROUP BY절에 기술되지 않은 컬럼이 SELECT절에 기술될 경우 에러
--그룹화와 관련 없는 문자열, 상수는 올 수 있다.
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
    ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
    COUNT(*) emp_cnt,
    COUNT(sal) sal_cnt,
    COUNT(mgr) mgr_cnt, --null값은 포함하지 않는다.
    SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--부서별 최대 급여
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--실습(grp1)
--emp테이블을 이용하여
--직원중 가장 높은 급여
--직원중 가장 낮은 급여
--직원의 급여 평균
--직원의 급여 합
--직원 중 급여가 있는 직원의 수(null제외)
--직원 중 상급자가 있는 직원의 수(null제외)
--전체 직원의 수
SELECT MAX(sal) max_sal, MIN(sal) min_sal,
    ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
    COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp;

--실습(grp2)
--emp테이블을 이용하여
--부서기준 직원중 가장 높은 급여
--부서기준 직원중 가장 낮은 급여
--부서기준 직원의 급여 평균
--부서기준 직원의 급여 합
--부서의 직원 중 급여가 있는 직원의 수(null제외)
--부서의 직원 중 상급자가 있는 직원의 수(null제외)
--부서의 직원의 수
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
    ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
    COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY deptno DESC;