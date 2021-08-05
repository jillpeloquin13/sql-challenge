----Create the schema
--DROP TABLE dept_manager;

CREATE TABLE employees (
	emp_no int PRIMARY KEY NOT NULL, 
	emp_title varchar,
	birth_date date,
	first_name varchar,
	last_name varchar,
	sex varchar,
	hire_date date
);

CREATE TABLE salaries (
	emp_no int PRIMARY KEY NOT NULL,
	salary int,
	CONSTRAINT fk_emp_no
      FOREIGN KEY(emp_no) 
	  REFERENCES employees(emp_no)
)


CREATE TABLE titles (
	title_id VARCHAR PRIMARY KEY NOT NULL,
	title VARCHAR
	--CONSTRAINT fk_title_id
      --FOREIGN KEY(title_id) 
	  --REFERENCES employees(emp_title)
)

CREATE TABLE dept_emp (
	emp_no INT NOT NULL, 
	dept_no VARCHAR
)

CREATE TABLE departments (
	dept_no VARCHAR PRIMARY KEY NOT NULL, 
	dept_name VARCHAR
)

CREATE TABLE dept_manager (
	dept_no VARCHAR NOT NULL, 
	emp_no INT
)

------IMPORT THE DATA-------

--employees table
copy public.employees (emp_no, emp_title, birth_date, first_name, last_name, sex, hire_date) 
FROM 'C:/Users/jillp/DOCUME~1/Class/EMER-V~1/EMER-V~1/02-HOM~1/SQL-CH~1/RESOUR~1/EMPLOY~1.CSV' 
DELIMITER ','
CSV HEADER

--departments
copy public.departments (dept_no, dept_name) 
FROM 'C:/Users/jillp/DOCUME~1/Class/EMER-V~1/EMER-V~1/02-HOM~1/SQL-CH~1/RESOUR~1/DEPART~1.CSV' 
DELIMITER ',' 
CSV HEADER 

--dept emp
copy public.dept_emp
FROM 'C:/Users/jillp/DOCUME~1/Class/EMER-V~1/EMER-V~1/02-HOM~1/SQL-CH~1/RESOUR~1/dept_emp.CSV' 
DELIMITER ',' 
CSV HEADER 

--titles
copy public.titles
FROM 'C:/Users/jillp/DOCUME~1/Class/EMER-V~1/EMER-V~1/02-HOM~1/SQL-CH~1/RESOUR~1/titles.CSV' 
DELIMITER ',' 
CSV HEADER 

--salaries
copy public.salaries
FROM 'C:/Users/jillp/DOCUME~1/Class/EMER-V~1/EMER-V~1/02-HOM~1/SQL-CH~1/RESOUR~1/salaries.CSV' 
DELIMITER ',' 
CSV HEADER 

--dept manager
copy public.dept_manager
FROM 'C:/Users/jillp/DOCUME~1/Class/EMER-V~1/EMER-V~1/02-HOM~1/SQL-CH~1/RESOUR~1/dept_manager.CSV' 
DELIMITER ',' 
CSV HEADER 

-----Analysis---------
---List the following details of each employee: employee number, last name, first name, sex, and salary.
Select
	e.emp_no AS "Employee Number",
	e.last_name AS "Last Name",
	e.first_name AS "First Name", 
	e.sex AS "Sex", 
	s.salary AS "Salary (USD)"
FROM employees e
INNER JOIN salaries s on 
e.emp_no=s.emp_no;

--List first name, last name, and hire date for employees who were hired in 1986.
Select 
	last_name AS "Last Name",
	first_name AS "First Name", 
	hire_date AS "Hire Date"
FROM employees 
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31'
ORDER by hire_date

---List the manager of each department with the following information: 
---department number, department name, the manager's employee number, last name, first name.
Select
	d.dept_no AS "Department Number",
	d.dept_name AS "Department Name",
	e.emp_no AS "Employee Number",
	e.last_name AS "Last Name",
	e.first_name AS "First Name"
FROM employees e
INNER JOIN dept_manager dm ON
e.emp_no=dm.emp_no
INNER JOIN departments d ON
dm.dept_no=d.dept_no


--List the department of each employee with the following information: 
--employee number, last name, first name, and department name.
Select
	e.emp_no AS "Employee Number",
	e.last_name AS "Last Name",
	e.first_name AS "First Name",
	d.dept_name AS "Department Name"
FROM employees e
INNER JOIN dept_emp de ON
e.emp_no=de.emp_no
INNER JOIN departments d ON
de.dept_no=d.dept_no;


--List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
Select 
	first_name AS "First Name", 
	last_name AS "Last Name",
	sex AS "Sex"
FROM employees 
WHERE first_name = 'Hercules' AND last_name like 'B%'
ORDER by last_name

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
Select
	e.emp_no AS "Employee Number",
	e.last_name AS "Last Name",
	e.first_name AS "First Name",
	d.dept_name AS "Department Name"
FROM employees e
INNER JOIN dept_emp de ON
e.emp_no=de.emp_no
INNER JOIN departments d ON
de.dept_no=d.dept_no
WHERE d.dept_name = 'Sales'
Order by e.last_name;

--List all employees in the Sales and Development departments, including their 
--employee number, last name, first name, and department name.
Select
	e.emp_no AS "Employee Number",
	e.last_name AS "Last Name",
	e.first_name AS "First Name",
	d.dept_name AS "Department Name"
FROM employees e
INNER JOIN dept_emp de ON
e.emp_no=de.emp_no
INNER JOIN departments d ON
de.dept_no=d.dept_no
WHERE d.dept_name IN ('Sales', 'Development')
Order by d.dept_name, e.last_name;

---In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
Select 
	last_name AS "Last Name",
	count(last_name) AS "Total Count of Last Name"
FROM employees
Group by last_name
Order by count(last_name) desc

----Support for Bonus Section-----
--Average salary by title query; create a view to query in the notebook
Create View Salaries_bands AS 
Select
	e.emp_no AS "Employee Number",
	s.salary AS "salary", 
	t.title AS "Title"
FROM employees e
INNER JOIN salaries s ON
s.emp_no=e.emp_no
INNER JOIN titles t ON 
e.emp_title=t.title_id

------Scratch the query to use in the notebooke
Select 
	"Title", avg("salary")
From Salaries_bands
group by "Title"


----Employee id look up
Select * from employees where emp_no = 499942
