--�ǽ�(join8)
--countries, regions ���̺� �̿�, ������ �Ҽ� ������ ��ȸ
--������ ������ ����, region_id, region_name, country_name
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

--�ǽ�(join9)
--countries, regions, locations ���̺� �̿�, ������ �Ҽ� ����, ������ �Ҽӵ� ���ø� ��ȸ
--������ ������ ����, region_id, region_name, country_name, city
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

--�ǽ�(join10)
--countries, regions, locations, departments ���̺� �̿�
--������ �Ҽ� ����, ������ �Ҽӵ� ����, ���ÿ� �ִ� �μ��� ��ȸ
--������ ������ ����, region_id, region_name, country_name, city, department_name
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

--�ǽ�(join11)
--countries, regions, locations, departments, employees ���̺� �̿�
--������ �Ҽ� ����, ������ �Ҽӵ� ����, ���ÿ� �ִ� �μ�, �μ��� �Ҽӵ� ���������� ��ȸ
--������ ������ ����, region_id, region_name, country_name, city, department_name, name
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

--�ǽ�(join12)
--employees, jobs ���̺� �̿�
--������ ������ ��Ī �����ϴ� ����, employee_id, name, job_id, job_title
SELECT *
FROM employees;
SELECT *
FROM jobs;

SELECT employee_id, first_name||last_name name, jobs.job_id, job_title
FROM employees, jobs
WHERE employees.job_id = jobs.job_id;

SELECT employee_id, CONCAT(first_name, last_name) name, jobs.job_id, job_title
FROM employees JOIN jobs ON (employees.job_id = jobs.job_id);

--�ǽ�(join13)
--employees, jobs ���̺� �̿�
--������ ������ ��Ī, ������ �Ŵ��� ���� ����
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