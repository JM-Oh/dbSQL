SELECT ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

--실습(ana1)
--사원의 전체 급여순위를 rank, dense_rank, row_number를 이용하여 구하세요
--급여가 동일할 경우 사번이 빠른 사람이 높은 순위가 되도록 작성
SELECT empno, ename, sal, deptno,
       RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_row_number
FROM emp;

--실습(no_ana2)
--기존의 배운 내용 활용
--모든 사원에 대해 사원번호, 사원이름, 해당사원이 속한 부서의 사원 수를 조회하는 쿼리
SELECT empno, ename, emp.deptno, cnt
FROM emp,
     (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) a
WHERE emp.deptno = a.deptno
ORDER BY deptno;

--분석함수를 통한 부서별 직원수 (COUNT)
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

--부서별 사원의 급여 합계
--SUM 분석함수
SELECT empno, ename, deptno, sal, SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

--실습(ana2)
--분석함수를 이용하여 모든 사원에 대해 사원번호, 사원이름, 급여, 부서번호, 소속부서의 급여평균 조회
SELECT empno, ename, sal, deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;

--실습(ana3)
--분석함수를 이용하여 모든 사원에 대해 사원번호, 사원이름, 급여, 부서번호, 소속부서의 가장 높은 급여 조회
SELECT empno, ename, sal, deptno, MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

--실습(ana4)
--분석함수를 이용하여 모든 사원에 대해 사원번호, 사원이름, 급여, 부서번호, 소속부서의 가장 낮은 급여 조회
SELECT empno, ename, sal, deptno, MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

--부서별 사원번호가 가장 빠른 사람
--부서별 사원번호가 가장 느린 사람
SELECT empno, ename, deptno,
       FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
       LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

--LAG(이전행)
--현재행
--LEAD(다음행)
--급여가 낮은 순으로 정렬했을때 자기보다 한단계 급여가 낮은 사람의 급여
--급여가 낮은 순으로 정렬했을때 자기보다 한단계 급여가 높은 사람의 급여
SELECT empno, ename, sal,
       LAG(sal) OVER (ORDER BY sal) lag_sal,
       LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

--실습(ana5)
--분석함수 이용, 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여, 한단계 낮은 사람의 급여 조회
--급여가 같을 경우 입사일이 빠른 사람이 높은 순위
SELECT empno, ename, hiredate, sal,
       LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

--실습(ana6)
--분석함수 이용, 모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군, 급여
--직군별 급여순위가 한단계 높은 사람의 급여 조회
--급여가 같을 경우 입사일이 빠른 사람이 높은 순위
SELECT empno, ename, hiredate, job, sal,
       LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

--실습(no_ana3)
--모든 사원에 대해 사원번호, 사원이름, 급여를 급여가 낮은 순으로 조회
--자신보다 급여가 낮은 사람의 급여 합을 새로운 컬럼에 분석함수 없이
SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno;

SELECT a.*, ROWNUM rn
FROM
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal, empno) a;

SELECT a.*, ROWNUM rn
FROM
    (SELECT sal
    FROM emp
    ORDER BY sal) a;

SELECT a.empno, a.ename, a.sal, SUM(b.sal)
FROM
    (SELECT a.*, ROWNUM rn
    FROM
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal, empno) a) a,
    (SELECT a.*, ROWNUM rn
    FROM
        (SELECT sal
        FROM emp
        ORDER BY sal) a) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, empno;

--WINDOWING
--UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든 행
--CURRENT ROW : 현재 행
--UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든 행
--N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
--N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행
SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;

--실습(ana7)
--모든 사원에 대해 사원번호, 사원이름, 부서번호, 급여, 
--소속부서에서 사원포함 낮은 급여를 받는 사람들의 급여 합 조회
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS UNBOUNDED PRECEDING) c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2,
       SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum2
FROM emp;