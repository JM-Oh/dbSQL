--실습(h_2)
--정보시스템부 하위의 부서계층을 조회하는 쿼리 작성
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL - 1) * 3, ' ') || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptnm = '정보시스템부'
CONNECT BY PRIOR deptcd = p_deptcd;

--상향식 계층쿼리
--특정 노드로부터 자신의 부모노드를 탐색(트리 전체 탐색이 아니다.)
--디자인팀(dept0_00_0)을 시작으로 상위부서를 조회
SELECT *
FROM dept_h;

SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;
--실습(h_4)
--h_sum테이블 이용 s_id(노드 아이디), ps_id(부모 노드 아이디), value(노드 값)
SELECT LPAD(' ', (LEVEL - 1) * 4, ' ') || s_id s_id, value
FROM h_sum
START WITH s_id = 0
CONNECT BY PRIOR s_id = ps_id;

--실습(h_5)
--no_emp테이블 org_cd(부서코드), parent_org_cd(부모부서코드), no_emp(부서 인원수)
SELECT LPAD(' ', (LEVEL - 1) * 4, ' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

--pruning branch(가지치기)
--계층쿼리에서 WHERE절은 START WITH, CONNECT BY 절이 전부 적용된 이후에 실행된다.

--dept_h테이블을 최상위 노드부터 하향식으로 조회
SELECT deptcd, LPAD(' ', (LEVEL - 1) * 4, ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--계층쿼리가 완성된 이후 WHERE절이 적용된다.
SELECT deptcd, LPAD(' ', (LEVEL - 1) * 4, ' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, LPAD(' ', (LEVEL - 1) * 4, ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
           AND deptnm != '정보기획부';
           
--CONNECT_BY_ROOT(col) : col의 최상의 노드 컬럼값
--SYS_CONNECT_BY_PATH(col, 구분자) : col의 계층구조 순서를 구분자로 이은 경로
--  LTRIM을 통해 최상위 노드 왼쪽의 구분자를 없애주는 형태가 일반적
--CONNECT_BY_ISLEAF : 해당 row가 leaf node인지 판별(1 : O, 0 : X)
SELECT LPAD(' ', (LEVEL - 1) * 4, ' ') || org_cd org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path_org_cd,
       CONNECT_BY_ISLEAF is_leaf
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

?create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

--실습(h6)
--게시글을 저장하는 board_test 테이블을 이용하여 계층쿼리 작성
SELECT seq, LPAD(' ', (LEVEL - 1) * 4, ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

--실습(h7)
--게시글을 저장하는 board_test 테이블을 이용하여 계층쿼리 작성
--가장 최신글이 위로 오도록 작성
SELECT seq, LPAD(' ', (LEVEL - 1) * 4, ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC;

--ORDER SIBLINGS BY : 계층쿼리를 파괴하지 않으면서 정렬하는 방법
--실습(h8)
SELECT seq, LPAD(' ', (LEVEL - 1) * 4, ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

--실습(h9)
SELECT *
FROM
    (SELECT seq, LPAD(' ', (LEVEL - 1) * 4, ' ') || title title, CONNECT_BY_ROOT(seq) r_seq
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq)
ORDER BY r_seq DESC, seq;

SELECT *
FROM board_test;
--글 그룹번호 컬럼 추가
ALTER TABLE board_test ADD (gn NUMBER);

SELECT seq, LPAD(' ', (LEVEL - 1) * 4, ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY gn DESC, seq;

--emp테이블에서 ename, sal, 자신의 한 단계 아래 sal
SELECT a.ename, a.sal, b.sal
FROM
    (SELECT ename, sal, ROWNUM + 1 rn
    FROM
        (SELECT ename, sal
        FROM emp
        ORDER BY sal DESC)) a,
    (SELECT ename, sal, ROWNUM rn
    FROM
        (SELECT ename, sal
        FROM emp
        ORDER BY sal DESC)) b
WHERE a.rn = b.rn(+);

