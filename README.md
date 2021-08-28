# SQL Project: Employee Database A Mystery in Two Parts

![sql](https://user-images.githubusercontent.com/79428102/126284887-efd2278c-5320-4a63-9535-c9f44d248562.png)

## Background

It is a beautiful spring day, and it is two weeks since you have been hired as a new data engineer at Pewlett Hackard. Your first major task is a research project on employees of the corporation from the 1980s and 1990s. All that remain of the database of employees from that period are six CSV files.

You will design the tables to hold data in the CSVs, import the CSVs into a SQL database, and answer questions about the data. In other words, you will perform:

1. Data Engineering

3. Data Analysis

## Task

#### Data Modeling

Inspect the CSVs and sketch out an ERD of the tables.
![QuickDBD-export](https://user-images.githubusercontent.com/79428102/128482835-c4533666-19c1-40d5-8e88-184164bf1a7e.png)

```
employees
-
emp_no INTEGER PK
emp_title_id VARCHAR FK >- titles.title_id
birth_date DATE
first_name VARCHAR
last_name VARCHAR
sex VARCHAR
hire_date DATE

salaries
-
emp_no INTEGER PK FK - employees.emp_no
salary INTEGER

dept_manager
-
dept_no VARCHAR PK FK >- departments.dept_no
emp_no INTEGER PK FK >- employees.emp_no

dept_emp
-
emp_no INTEGER PK FK >- employees.emp_no
dept_no VARCHAR PK FK >- departments.dept_no

departments
-
dept_no VARCHAR PK
dept_name VARCHAR 

titles
-
title_id VARCHAR PK
title VARCHAR
```

#### Data Engineering

* Use the information you have to create a table schema for each of the six CSV files. Remember to specify data types, primary keys, foreign keys, and other constraints.

  * For the primary keys check to see if the column is unique, otherwise create a [composite key](https://en.wikipedia.org/wiki/Compound_key). Which takes to primary keys in order to uniquely identify a row.
  * Be sure to create tables in the correct order to handle foreign keys.

* Import each CSV file into the corresponding SQL table. 
* **Note** be sure to import the data in the same order that the tables were created and account for the headers when importing to avoid errors.

```
CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INTEGER   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");


```

#### Data Analysis

Once you have a complete database, do the following:

1. List the following details of each employee: employee number, last name, first name, sex, and salary.

```
SELECT 
salaries.emp_no,last_name,first_name,sex,salary

FROM employees
INNER JOIN salaries ON employees.emp_no = salaries.emp_no;
```

2. List first name, last name, and hire date for employees who were hired in 1986.
```
SELECT 
first_name, last_name, hire_date
FROM
employees
WHERE
hire_date >= '1/1/1986' and hire_date <= '12/31/1986';
```
3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
```
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
```
4. List the department of each employee with the following information: employee number, last name, first name, and department name.
```
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
```
5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
```
SELECT 
first_name, last_name, sex
FROM
employees 
WHERE 
first_name = 'Hercules'
and
last_name LIKE 'B%'
```
6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
```
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
```

7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
```
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
```
8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
```
SELECT
last_name, COUNT(last_name) AS last_name_frequency
FROM
employees
GROUP BY
last_name
ORDER BY
last_name DESC
```
## Bonus (Optional)

As you examine the data, you are overcome with a creeping suspicion that the dataset is fake. You surmise that your boss handed you spurious data in order to test the data engineering skills of a new employee. To confirm your hunch, you decide to take the following steps to generate a visualization of the data, with which you will confront your boss:

1. Import the SQL database into Pandas. (Yes, you could read the CSVs directly in Pandas, but you are, after all, trying to prove your technical mettle.) This step may require some research. Feel free to use the code below to get started. Be sure to make any necessary modifications for your username, password, host, port, and database name:
```
# connect to pgAdmin

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sqlalchemy import create_engine
engine = create_engine("postgresql://postgres:{pass}@localhost:5432/Employee_Database") 
connection = engine.connect()
```

2. Create a histogram to visualize the most common salary ranges for employees.
```
# Histogram
#Create a histogram to visualize the most common salary ranges for employees.
#Dataset
salary = pd.read_sql("SELECT * from salaries", connection)
salary['salary'].describe()

#Histogram
plt.style.use('ggplot')
x_axis = list(salary['salary'])

fig1, ax1 = plt.subplots(figsize = (6,6));
ax1.hist(x_axis,bins = 15);
ax1.set(title = 'salary histogram',
      xlabel = 'salary',
      ylabel = 'number of employee')
```
3. Create a bar chart of average salary by title.
```
# Bar Chart
# Create a bar chart of average salary by title.
#Dataset
salaries = pd.read_sql("SELECT * FROM salaries", connection)
employees = pd.read_sql("SELECT emp_no, emp_title_id FROM employees", connection)
titles = pd.read_sql("SELECT * FROM titles", connection)

emp_titles = employees.merge(titles, left_on = 'emp_title_id', right_on = 'title_id' )
emp_titles_salaries = emp_titles.merge(salaries, left_on ='emp_no' ,right_on = 'emp_no')

avg_salary = round(emp_titles_salaries.groupby('title')['salary'].agg('mean'),2).to_frame().reset_index().sort_values(by=['salary'])

x_axis = avg_salary['title']
y_axis = avg_salary['salary']

#Bar Chart

fig2, ax2 = plt.subplots(figsize = (10,8))
ax2.bar(x_axis, y_axis,  width = 0.65)
ax2.set(title = 'Average Salary by title',
       xlabel = 'title',
       ylabel = 'Average Salary' )
ax2.set_xticklabels(x_axis, rotation = 45)
```

### Copyright

© 2021 Trilogy Education Services, LLC, a 2U, Inc. brand. Confidential and Proprietary. All Rights Reserved.
