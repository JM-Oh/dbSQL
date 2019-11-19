SELECT sido, sigungu, sal
FROM tax
ORDER BY sal DESC;

--sido, sigungu, ��������, sido, sigungu, �������곳�Ծ�
--����� �߱� 5,67 ��⵵ ������ 18623591

SELECT a.sido, a.sigungu, ��������, b.sido, b.sigungu, sal
FROM
    (SELECT ROWNUM rank, a.*
    FROM
        (SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 2) ��������
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
            ORDER BY �������� DESC) a) a,
    (SELECT ROWNUM rank, a.*
    FROM
        (SELECT sido, sigungu, sal
        FROM tax
        ORDER BY sal DESC) a) b
WHERE a.rank(+) = b.rank;