--실습(join8)
--countries, regions 테이블 이용, 지역별 소속 국가를 조회
--지역은 유럽만 한정, region_id, region_name, country_name
SELECT *
FROM countries;
SELECT *
FROM regions;

SELECT region_id, region_name, country_name
FROM regions NATURAL JOIN countries
WHERE region_name = 'Europe';

SELECT region_id, region_name, country_name
FROM regions JOIN countries USING (region_id)
WHERE region_name = 'Europe';

SELECT regions.region_id, region_name, country_name
FROM regions JOIN countries ON (regions.region_id = countries.region_id)
WHERE region_name = 'Europe';

SELECT regions.region_id, region_name, country_name
FROM regions, countries
WHERE regions.region_id = countries.region_id
AND region_name = 'Europe';

--실습(join9)
--countries, regions, locations 테이블 이용, 지역별 소속 국가, 국가에 소속된 도시를 조회
--지역은 유럽만 한정, region_id, region_name, country_name, city
SELECT *
FROM locations;

SELECT regions.region_id, region_name, country_name, city
FROM regions, countries, locations
WHERE regions.region_id = countries.region_id
AND countries.country_id = locations.country_id
AND region_name = 'Europe';

SELECT regions.region_id, region_name, country_name, city
FROM regions JOIN countries ON (regions.region_id = countries.region_id) 
    JOIN locations ON (countries.country_id = locations.country_id)
WHERE region_name = 'Europe';

--실습(join10)
--countries, regions, locations, departments 테이블 이용
--지역별 소속 국가, 국가에 소속된 도시, 도시에 있는 부서를 조회
--지역은 유럽만 한정, region_id, region_name, country_name, city, department_name
SELECT *
FROM departments;

SELECT regions.region_id, region_name, country_name, city, department_name
FROM regions, countries, locations, departments
WHERE regions.region_id = countries.region_id
AND countries.country_id = locations.country_id
AND locations.location_id = departments.location_id
AND region_name = 'Europe';

SELECT regions.region_id, region_name, country_name, city, department_name
FROM regions JOIN countries ON (regions.region_id = countries.region_id) 
    JOIN locations ON (countries.country_id = locations.country_id)
    JOIN departments ON (locations.location_id = departments.location_id)
WHERE region_name = 'Europe';

--실습(join11)
--countries, regions, locations, departments, employees 테이블 이용
--지역별 소속 국가, 국가에 소속된 도시, 도시에 있는 부서, 부서에 소속된 직원정보를 조회
--지역은 유럽만 한정, region_id, region_name, country_name, city, department_name, name
SELECT *
FROM employees;

SELECT regions.region_id, region_name, country_name, city, department_name, first_name||last_name name
FROM regions, countries, locations, departments, employees
WHERE regions.region_id = countries.region_id
AND countries.country_id = locations.country_id
AND locations.location_id = departments.location_id
AND departments.department_id = employees.department_id
AND region_name = 'Europe';

SELECT regions.region_id, region_name, country_name, city, department_name, CONCAT(first_name, last_name) name
FROM regions JOIN countries ON (regions.region_id = countries.region_id) 
    JOIN locations ON (countries.country_id = locations.country_id)
    JOIN departments ON (locations.location_id = departments.location_id)
    JOIN employees ON (departments.department_id = employees.department_id)
WHERE region_name = 'Europe';

--실습(join12)
--employees, jobs 테이블 이용
--직원의 담당업무 명칭 포함하는 쿼리, employee_id, name, job_id, job_title
SELECT *
FROM employees;
SELECT *
FROM jobs;

SELECT employee_id, first_name||last_name name, jobs.job_id, job_title
FROM employees, jobs
WHERE employees.job_id = jobs.job_id;

SELECT employee_id, CONCAT(first_name, last_name) name, jobs.job_id, job_title
FROM employees JOIN jobs ON (employees.job_id = jobs.job_id);

--실습(join13)
--employees, jobs 테이블 이용
--직원의 담당업무 명칭, 직원의 매니저 정보 포함
--mng_id, mgr_name, employee_id, name, job_id, job_title
SELECT b.employee_id mng_id, b.first_name||b.last_name mgr_name, 
        a.employee_id, a.first_name||a.last_name name, jobs.job_id, job_title
FROM employees a, employees b, jobs
WHERE a.manager_id = b.employee_id
AND a.job_id = jobs.job_id;

SELECT b.employee_id mng_id, b.first_name||b.last_name mgr_name, 
        a.employee_id, a.first_name||a.last_name name, jobs.job_id, job_title
FROM employees a JOIN employees b ON (a.manager_id = b.employee_id) 
    JOIN jobs ON (a.job_id = jobs.job_id);