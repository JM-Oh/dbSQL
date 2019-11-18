--도시발전 지수 = (버거컹+맥도날드+KFC) / 롯데리아

SELECT sido, sigungu
FROM fastfood
GROUP BY sido, sigungu;

SELECT gb, COUNT(*)
FROM fastfood
GROUP BY gb;

SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('버거킹', '맥도날드', 'KFC')
GROUP BY sido, sigungu;

SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb = '롯데리아'
GROUP BY sido, sigungu;

SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 2) 도시발전지수
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
ORDER BY 도시발전지수 DESC;