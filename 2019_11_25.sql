--실습(ana0)
--부서별 랭킹
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT ROWNUM rn
FROM emp;

SELECT a.deptno, b.rn
FROM
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) a,
    (SELECT ROWNUM rn
    FROM emp) b
WHERE a.cnt >= b.rn
ORDER BY a.deptno, b.rn;

SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC;

SELECT ename, sal, deptno, ROWNUM rn
FROM
    (SELECT ename, sal, deptno
    FROM emp
    ORDER BY deptno, sal DESC);
    
SELECT deptno, rn, ROWNUM rk
FROM
    (SELECT a.deptno, b.rn
    FROM
        (SELECT deptno, COUNT(*) cnt
        FROM emp
        GROUP BY deptno) a,
        (SELECT ROWNUM rn
        FROM emp) b
    WHERE a.cnt >= b.rn
    ORDER BY a.deptno, b.rn);
    
SELECT ename, sal, a.deptno, b.rn
FROM
    (SELECT ename, sal, deptno, ROWNUM rn
    FROM
        (SELECT ename, sal, deptno
        FROM emp
        ORDER BY deptno, sal DESC)) a,
    (SELECT deptno, rn, ROWNUM rk
    FROM
        (SELECT a.deptno, b.rn
        FROM
            (SELECT deptno, COUNT(*) cnt
            FROM emp
            GROUP BY deptno) a,
            (SELECT ROWNUM rn
            FROM emp) b
        WHERE a.cnt >= b.rn
        ORDER BY a.deptno, b.rn)) b
WHERE a.rn = b.rk;

SELECT ename, sal, deptno,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;