SELECT sido, sigungu, sal
FROM tax
ORDER BY sal DESC;

--sido, sigungu, 버거지수, sido, sigungu, 연말정산납입액
--서울시 중구 5,67 경기도 수원시 18623591

SELECT a.sido, a.sigungu, 버거지수, b.sido, b.sigungu, sal
FROM
    (SELECT ROWNUM rank, a.*
    FROM
        (SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 2) 버거지수
        FROM
            (SELECT sido, sigungu, COUNT(*) cnt
            FROM fastfood
            WHERE gb IN ('버거킹', '맥도날드', 'KFC')
            GROUP BY sido, sigungu) a,
            (SELECT sido, sigungu, COUNT(*) cnt
            FROM fastfood
            WHERE gb = '롯데리아'
            GROUP BY sido, sigungu) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu
            ORDER BY 버거지수 DESC) a) a,
    (SELECT ROWNUM rank, a.*
    FROM
        (SELECT sido, sigungu, sal
        FROM tax
        ORDER BY sal DESC) a) b
WHERE a.rank(+) = b.rank;