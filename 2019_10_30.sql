-- SELECT : ��ȸ�� �÷� ���
--          - ��ü �÷� ��ȸ : *
--          - �Ϻ� �÷� : �ش� �÷��� ���� (, ����)
-- FROM : ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� �������.
-- �� keyword�� �ٿ��� �ۼ�


-- ��� �÷��� ��ȸ
SELECT * FROM prod;

-- Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name
FROM prod;


--�ǽ� (select1)
-- 1) 1prod ���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT *
FROM lprod;

-- 2) buyer ���̺��� buyer_id, buyer_name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT buyer_id, buyer_name
FROM buyer;

-- 3) cart ���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT *
FROM cart;

-- 4) member ���̺��� mem_id, mem_pass, mem_name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT mem_id, mem_pass, mem_name
FROM member;


-- ������ / ��¥����
-- date type + ���� : ���ڸ� ���Ѵ�.
-- null�� ������ ������ ����� �׻� null�̴�.
SELECT userid, usernm, reg_dt,
        reg_dt + 5 reg_dt_after5,
        reg_dt - 5 as reg_dt_before5
FROM users;

--�ǽ� (select2)
SELECT prod_id as id, prod_name as name
FROM prod;

SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

SELECT buyer_id ���̾���̵�, buyer_name �̸�
FROM buyer;

-- ���ڿ� ����
-- Java + --> sql ||
-- CONCAT(str, str) �Լ�
-- user���̺��� userid, usernm
SELECT userid, usernm, userid || usernm,
        CONCAT(userid, usernm)
FROM users;

-- ���ڿ� ��� (�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : '|| userid, CONCAT('����� ���̵� : ', userid)
FROM users;

-- �ǽ�(sel_conl)
SELECT table_name, 'SELECT * FROM ' || table_name || ';' as query
FROM user_tables;

-- desc table
-- ���̺� ���ǵ� �÷��� �˰� ������
-- 1. desc
-- 2. SELECT * FROM ...;
desc emp;

SELECT *
FROM emp;

--WHERE��, ���� ������
SELECT *
FROM users
WHERE userid = 'brown';

--usernm�� ������ �����͸� ��ȸ�ϴ� ������ �ۼ�
SELECT *
FROM users
WHERE usernm = '����';

