--SMiTH, WARD����� ���� �μ��� ��� ��� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno IN (
    SELECT deptno
    FROM emp
    WHERE ename IN (:name1, :name2));
    
--ANY : set �߿� �����ϴ°� �ϳ��� ������ ������(ũ�� ��)
--SMITH �Ǵ� WARD�� �޿����� ���� �޿��� �޴� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE sal < ANY (
            SELECT sal --800, 1250
            FROM emp
            WHERE ename IN ('SMITH', 'WARD'));

--SMITH�� WARD���� �޿��� ���� ���� ��ȸ
--SMITH���ٵ� �޿��� ���� WARD���ٵ� �޿��� ���� ����
SELECT *
FROM emp
WHERE sal > ALL (
            SELECT sal --800, 1250
            FROM emp
            WHERE ename IN ('SMITH', 'WARD'));

--NOT IN

--�������� ���� ����
SELECT DISTINCT mgr
FROM emp;

SELECT *
FROM emp
WHERE empno IN (
            SELECT mgr
            FROM emp);
            
--�����ڰ� �ƴ� ���� ����
--�� NOT IN ������ ���� SET�� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
--NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���.
SELECT *
FROM emp
WHERE empno NOT IN ( --null���� �־ ���� ������ �����Ƿ�
            SELECT mgr
            FROM emp
            WHERE mgr IS NOT NULL); --null���� �������ش�.
            
--pair wise
--��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);
--7698 30, 7839 10

--�����߿� �����ڿ� �μ���ȣ�� (7698, 30), (7839 10)�� ����
--mgr, deptno�÷��� ���ÿ� ������Ű�� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE (mgr, deptno) IN (
                    SELECT mgr, deptno
                    FROM emp
                    WHERE empno IN (7499, 7782));
                    
SELECT *
FROM emp
WHERE mgr IN (
          SELECT mgr
          FROM emp
          WHERE empno IN (7499, 7782))
AND deptno IN (
           SELECT deptno
           FROM emp
           WHERE empno IN (7499, 7782)); --���� ������Ű�Ƿ� ����� �޶�����.(7698 30, 7698 10, 7839 30, 7839 10)
           
--SCALAR SUBQUERY : SELECT���� �����ϴ� ��������(�� ���� �ϳ��� ��, �ϳ��� �÷�)
--������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;

--sub4 ������ ����
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

--�ǽ�(sub4)
--dept���̺��� �űԵ�ϵ� 99�� �μ��� ���ϴ� ������ ����. ������ ������ �ʴ� �μ��� ��ȸ
SELECT *
FROM dept;

SELECT *
FROM dept
WHERE deptno NOT IN ( 
             SELECT deptno
             FROM emp);
             
--�ǽ�(sub5)
--cycle, product ���̺��� cid=1�� ���� �������� �ʴ� ��ǰ ��ȸ
SELECT *
FROM cycle;
SELECT *
FROM product;

SELECT *
FROM product
WHERE pid NOT IN(
          SELECT pid
          FROM cycle
          WHERE cid = 1);
          
--�ǽ�(sub6)
--cycle���� cid=2�� ���� �����ϴ� ��ǰ �� cid=1�� ���� �����ϴ� ��ǰ�� �������� ��ȸ
SELECT *
FROM cycle
WHERE pid IN (
          SELECT pid
          FROM cycle
          WHERE cid = 2)
AND cid = 1;

--�ǽ�(sub7)
--cycle���� cid=2�� ���� �����ϴ� ��ǰ �� cid=1�� ���� �����ϴ� ��ǰ�� �������� ��ȸ�ϰ� ����� ��ǰ����� �����ϴ� ����
--scalar subquery ���
SELECT cid,
       (SELECT cnm FROM customer WHERE cid = cycle.cid) cnm, 
       pid,
       (SELECT pnm FROM product WHERE pid = cycle.pid) pnm,
       day,
       cnt
FROM cycle
WHERE pid IN (
          SELECT pid
          FROM cycle
          WHERE cid = 2)
AND cid = 1;

--inline view ���
SELECT a.cid, customer.cnm, a.pid, product.pnm, day, cnt
FROM 
    (SELECT *
    FROM cycle
    WHERE pid IN (
              SELECT pid
              FROM cycle
              WHERE cid = 2)
    AND cid = 1) a,
    customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;

--subquery ���
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, day, cnt
FROM cycle, customer, product
WHERE cycle.pid IN (
          SELECT pid
          FROM cycle
          WHERE cid = 2)
AND cycle.pid = product.pid
AND cycle.cid = customer.cid
AND cycle.cid = 1;

--EXISTS MAIN������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
--�����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������ ���ɸ鿡�� ����

--mgr�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
--mgr�� �������� �ʴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X'
                  FROM emp
                  WHERE empno = a.mgr);
                  
--�ǽ�(sub8)
--mgr�� �����ϴ� ���� ��ȸ(�Ʒ� ������ subquery������� �ʰ�)
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--�μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ(EXISTS)
SELECT *
FROM dept
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE deptno = dept.deptno);

SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                 FROM emp);
                 
--���տ���
--UNION : ������. �ߺ��� ����.
--        DBMS������ �ߺ��� �����ϱ� ���� �����͸� ����(�뷮�� �����Ϳ� ���� ���� �� ����)
--UNION ALL : UNION�� ���� ����
--            �ߺ��� �������� �ʰ�, ���Ʒ� ������ ���� -> �ߺ�����
--            ���Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ� UNION�����ں��� ���ɸ鿡�� ����
--����� 7566 �Ǵ� 7698�� ��� ��ȸ(���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION
--����� 7369 �Ǵ� 7499�� ��� ��ȸ(���, �̸�)
SELECT empno, ename
FROM emp
--WHERE empno IN (7369, 7499);
WHERE empno IN (7566, 7698);

--UNION ALL(�ߺ� ���, ���Ʒ� ������ ��ġ�⸸ �Ѵ�.)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--INTERSECT(������ : ���Ʒ� ���հ� ���� ������)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);

--MINUS(������ : �� ���տ��� �Ʒ� ������ ����)
--������ ����
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369);

SELECT 1 n, 'x' m
FROM dual
UNION
SELECT 2, 'y'
FROM dual;

SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'PC03'
AND TABLE_NAME IN ('PROD', 'LPROD')
AND CONSTRAINT_TYPE IN ('P', 'R');