--1. List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT 
salaries.emp_no,last_name,first_name,sex,salary
FROM 
employees
INNER JOIN 
salaries 
ON 
employees.emp_no = salaries.emp_no;


--2. List first name, last name, and hire date for employees who were hired in 1986.
SELECT 
first_name, last_name, hire_date
FROM
employees
WHERE
hire_date >= '1/1/1986' 
AND hire_date <= '12/31/1986';


--3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT 
dpt.dept_no, dpt.dept_name, mng.emp_no, emp.first_name, emp.last_name
FROM 
dept_manager AS mng
INNER JOIN
departments AS dpt
ON
mng.dept_no = dpt.dept_no
INNER JOIN
employees AS emp
ON
mng.emp_no = emp.emp_no;


--4. List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT 
e.emp_no, e.first_name, e.last_name, d.dept_name
FROM
departments AS d 
INNER JOIN 
dept_emp AS de
ON
de.dept_no = d.dept_no
INNER JOIN
employees AS e
ON
e.emp_no = de.emp_no;


--5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT 
first_name, last_name, sex
FROM
employees 
WHERE 
first_name = 'Hercules'
AND last_name LIKE 'B%'

--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT
e.emp_no,e.last_name, e.first_name, d.dept_name
FROM
dept_emp AS de
INNER JOIN
departments AS d
ON
d.dept_no = de.dept_no
INNER JOIN
employees AS e
ON
e.emp_no = de.emp_no
WHERE
dept_name = 'Sales'


--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT
e.emp_no,e.last_name, e.first_name, d.dept_name
FROM
dept_emp AS de
INNER JOIN
departments AS d
ON
d.dept_no = de.dept_no
INNER JOIN
employees AS e
ON
e.emp_no = de.emp_no
WHERE
dept_name = 'Sales' 
OR dept_name = 'Development'


--8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT
last_name, COUNT(last_name) AS last_name_frequency
FROM
employees
GROUP BY
last_name
ORDER BY
last_name DESC
