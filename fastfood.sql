--���ù��� ���� = (������+�Ƶ�����+KFC) / �Ե�����

SELECT sido, sigungu
FROM fastfood
GROUP BY sido, sigungu;

SELECT gb, COUNT(*)
FROM fastfood
GROUP BY gb;

SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('����ŷ', '�Ƶ�����', 'KFC')
GROUP BY sido, sigungu;

SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb = '�Ե�����'
GROUP BY sido, sigungu;

SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 2) ���ù�������
FROM
    (SELECT sido, sigungu, COUNT(*) cnt
    FROM fastfood
    WHERE gb IN ('����ŷ', '�Ƶ�����', 'KFC')
    GROUP BY sido, sigungu) a,
    (SELECT sido, sigungu, COUNT(*) cnt
    FROM fastfood
    WHERE gb = '�Ե�����'
    GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY ���ù������� DESC;