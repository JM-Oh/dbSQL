--���̺��� ������ ��ȸ
/*
    SELECT �÷� : express (���ڿ� ���)
    FROM �����͸� ��ȸ�� ���̺�(VIEW)
    WHERE ���� (condition)
*/

DESC user_tables;
SELECT table_name, 'SELECT * FROM ' || table_name || ';' AS select_query
FROM user_tables
WHERE TABLE_NAME != 'EMP';
--��ü �Ǽ� - 1


-- ���� �� ����
-- �μ� ��ȣ�� 30������ ũ�ų� ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno >= 30;

-- �μ���ȣ�� 30������ ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno < 30;

-- �Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ
SELECT *
FROM emp
WHERE hiredate < TO_DATE('01/01/1982', 'MM/DD/YYYY'); --11��
--WHERE hiredate < TO_DATE('1982/01/01', 'YYYY/MM/DD'); --11��
--WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD'); --3��

-- BETWEEN X AND Y ����
-- �÷��� ���� X���� ũ�ų� ����, Y���� �۰ų� ���� ������
-- �޿�(sal)�� 1000���� ũ�ų� ����, Y���� �۰ų� ���� �����͸� ��ȸ
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

-- ���� BETWEEN AND�����ڸ� �Ʒ��� <=, >=���հ� ����.
SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000
  AND deptno = 30;

-- �ǽ� (where1)
-- emp ���̺��� �Ի����ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� enaeme, hiredate�� ��ȸ�ϴ� ���� �ۼ�
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM/DD');
-- �ǽ� (where2)
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

-- IN ������
-- COL IN (values...)
-- �μ���ȣ�� 10 Ȥ�� 20�� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno IN(10, 20);

-- IN �����ڴ� OR �����ڷ� ǥ���� �� �ִ�.
SELECT *
FROM emp
WHERE deptno = 10
OR deptno = 20;

-- �ǽ� (where3)
--users ���̺��� userid�� brown, cony, sally�� �����͸� ��ȸ
SELECT userid AS ���̵�, usernm �̸�, '����'
FROM users
WHERE userid IN('brown', 'cony', 'sally');

SELECT userid AS ���̵�, usernm �̸�, '����'
FROM users
WHERE userid = 'brown'
OR userid = 'cony'
OR userid = 'sally';

-- COL LIKE  'S%'
-- COL�� ���� �빮�� S�� �����ϴ� ��� ��
-- COL LIKE 'S____'
-- COL�� ���� �빮�� S�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

-- emp���̺��� ���� �̸��� S�� �����ϴ� ��� ���� ��ȸ
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- �ǽ�(where4)
-- member ���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name�� ��ȸ�ϴ� ���� �ۼ�
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

-- �ǽ�(where5)
-- member ���̺��� ȸ���� �̸��� ����[��]�� ���� ����� mem_id, mem_name�� ��ȸ�ϴ� ���� �ۼ�
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

-- NULL ��
-- COL IS NULL
-- emp ���̺��� MGR������ ���� ���(NULL) ��ȸ
SELECT *
FROM emp
WHERE mgr IS NULL;

-- �ҼӺμ��� 10���� �ƴ� ������
SELECT *
FROM emp
WHERE deptno != 10;
-- =, !=
-- IS NULL, IS NOT NULL

-- �ǽ�(where6)
-- emp ���̺��� ��(comm)�� �ִ� ȸ���� ������ ������ ���� ��ȸ�ǵ��� ���� �ۼ�
SELECT *
FROM emp
WHERE comm IS NOT NULL;

-- AND / OR
-- emp ���̺��� ������(mgr) ����� 7698�̰� �޿�(sal)�� 1000�̻��� ���
SELECT *
FROM emp
WHERE mgr = 7698
AND sal >= 1000;

-- emp ���̺��� ������(mgr) ����� 7698�̰ų� �޿�(sal)�� 1000�̻��� ���
SELECT *
FROM emp
WHERE mgr = 7698
OR sal >= 1000;

-- NOT
-- emp���̺��� ������(mgr)����� 7698�� �ƴϰ� 7839�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);
-- ���� ������ AND/OR �����ڷ� ��ȯ
SELECT *
FROM emp
WHERE mgr !=7698
AND mgr != 7839;

-- IN, NOT IN �������� NULL ó��
-- emp ���̺��� ������(mgr) ����� 7698, 7839 �Ǵ� null�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
AND mgr IS NOT NULL;

-- �ǽ�(where7)
-- emp ���̺��� job�� SALESMAN�̰� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');

-- �ǽ�(where8)
-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ��ȸ(NOT IN������ �̻��)
SELECT *
FROM emp
WHERE deptno != 10
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');

-- �ǽ�(where9)
-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ��ȸ(NOT IN������ ���)
SELECT *
FROM emp
WHERE deptno NOT IN (10)
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');

-- �ǽ�(where10)
-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ��ȸ
-- (IN������ ���, �μ��� 10, 20, 30�� �ִٰ� ����)
SELECT *
FROM emp
WHERE deptno IN (20, 30)
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');

-- �ǽ�(where11)
-- emp ���̺��� job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');

-- �ǽ�(where12)
-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE '78%';

-- �ǽ�(where13)
-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ��ȸ(LIKE������ �̻��)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno BETWEEN 7800 AND 7899;

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno >= 7800 
AND empno < 7900;

-- �ǽ�(where14)
-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϸ鼭 �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE '78%'
AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD');