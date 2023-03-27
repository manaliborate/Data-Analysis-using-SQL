Garage data System Questions.

select * from customer
SELECT * FROM vendors
SELECT * FROM employee
SELECT * FROM sparepart
SELECT * FROM purchase
SELECT * FROM ser_det
SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers

Q.1  List all the customers serviced.

SELECT DISTINCT c.CID,c.CNAME,s.TYP_VEH,s.VEH_NO,s.TYP_SER
FROM customer c INNER JOIN ser_det s
ON c.CID = s.CID;

SELECT DISTINCT c.CNAME
FROM customer c INNER JOIN ser_det s
ON c.CID = s.CID;


Q.2  Customers who are not serviced.

select CID FROM  customer
MINUS
SELECT CID FROM  ser_det

SELECT CNAME  FROM customer 
WHERE CID NOT IN (SELECT CID FROM ser_det)

Q.3  Employees who have not received the commission.


SELECT distinct e.ENAME,e.EID,s.COMM
FROM employee e,ser_det s
WHERE e.EID=s.EID
AND COMM=0

or

select ENAME from employee where EID in(select EID from ser_det where comm=0)

--(SELECT distinct e.ENAME,e.EID,s.COMM FROM employee e inner join ser_det s on e.EID=s.EID WHERE s.COMM =0)


Q.4  Name the employee who have maximum Commission.

select ENAME from employee where EID in(select EID from ser_det WHERE COMM=(SELECT MAX(COMM) FROM ser_det))



Q.5  Show employee name and minimum commission amount received by an employee.

select ENAME from employee where EID in(select EID from ser_det WHERE COMM = (SELECT MIN(COMM) FROM ser_det));

Q.6  Display the Middle record from any table.

SELECT * FROM vendors
WHERE ROWNUM<=(SELECT (COUNT(*)/2)FROM vendors)
MINUS
SELECT * FROM vendors
WHERE ROWNUM<>(SELECT (COUNT(*)/2)FROM vendors)

Q.7  Display last 4 records of any table.

SELECT * FROM customer
WHERE ROWNUM<=(SELECT (COUNT(*))FROM customer)
MINUS
SELECT * FROM customer
WHERE ROWNUM<=(SELECT (COUNT(*)/2)FROM customer)


Q.8  Count the number of records without count function from any table.

select sum(1) from Ser_det

--Q.9  Delete duplicate records from "Ser_det" table on cid.(note Please rollback after execution).

DELETE FROM Ser_det 
WHERE CID NOT IN (
  SELECT MAX(CID) 
  FROM Ser_det 
  GROUP BY cid
)

Q.10 Show the name of Customer who have paid maximum amount 

select cname from customer where cid in (select cid from Ser_det where total in (select max(total) from Ser_det ))

Q.11 Display Employees who are not currently working.
 
 select * from Employee 
 where EDOL is not null
 
Q.12 How many customers serviced their two wheelers.


  select distinct c.cname
  from customer c,Ser_det s
  where c.cid=s.cid
  and s.typ_veh='TWO WHEELER'
  
  or
  
  select cname from customer where cid in (select cid from Ser_det where typ_veh='TWO WHEELER')

 
Q.13 List the Purchased Items which are used for Customer Service with Unit of that Item.

select distinct s.spname,s.spunit
from sparepart s inner join purchase p
on s.spid=p.spid

or 

select spname,spunit from sparepart where spid in (select spid from purchase)


Q.14 Customers who have Colored their vehicles.

select c.cname
from customer c, Ser_det s
where c.cid=s.cid
and typ_ser='COLOR'
 or 
 
 select cname from customer where cid in (select cid from Ser_det where typ_ser='COLOR')

--Q.15 Find the annual income of each employee inclusive of Commission
select * from Ser_det
SELECT * FROM sparepart
SELECT * FROM purchase
SELECT * FROM employee

select esal,comm ,(esal+comm)*12 as anuual_salary from employee e
join ser_det s on e.eid=s.eid
Q.16 Vendor Names who provides the engine oil.

select V.VNAME
FROM purchase P INNER JOIN vendors V
ON P.VID=V.VID
INNER JOIN sparepart T
ON P.SPID=T.SPID
WHERE T.SPNAME IN ('TWO WHEELER ENGINE OIL','FOUR WHEELER ENGINE OIL')

OR

SELECT VNAME FROM vendors WHERE VID IN(SELECT VID FROM purchase WHERE SPID IN 
(SELECT SPID FROM sparepart WHERE SPNAME IN ('TWO WHEELER ENGINE OIL','FOUR WHEELER ENGINE OIL'))) 

Q.17 Total Cost to purchase the Color and name the color purchased.

select * from Ser_det
SELECT * FROM sparepart
SELECT * FROM purchase
SELECT * FROM venders
SELECT * FROM sparepart

select s.total,t.spname
from ser_det s inner join sparepart t
on s.spid=t.spid
where spname like '%COLOUR';

Q.18 Purchased Items which are not used in "Ser_det".

SELECT * FROM purchase
SELECT * FROM Ser_det
SELECT * FROM sparepart

select spid from purchase
where spid not in (select spid from Ser_det)

or

select t.spname
from purchase p inner join sparepart t
on p.spid=t.spid
minus
select t.spname
from Ser_det s inner join sparepart t
on s.spid=t.spid

Q.19 Spare Parts Not Purchased but existing in Sparepart

select spname from sparepart
where spid not in (select spid from purchase)

or

select  t.spname
from purchase p right join sparepart t
on p.spid=t.spid
minus
select  t.spname
from purchase p inner join sparepart t
on p.spid=t.spid




--Q.20 Calculate the Profit/Loss of the Firm. Consider one month salary of each employee for Calculation.

with a as
(select sum(esal) e from employee),
b as (select sum(total) f from ser_det)
select f-e from a,b;


Q.21 Specify the names of customers who have serviced their vehicles more than one time.

SELECT t2.CNAME,t1.CID, COUNT(*)
FROM Ser_det t1
JOIN CUSTOMER t2
ON t1.CID = t2.CID
GROUP BY t1.CID,t2.CNAME
HAVING COUNT(*)>1

OR

SELECT CID, COUNT(*)
FROM SER_DET
GROUP BY CID
HAVING COUNT(*)>1


Q.22 List the Items purchased from vendors locationwise.

SELECT V.VNAME,V.VADD,S.SPNAME
FROM PURCHASE P INNER JOIN VENDORS V
ON P.VID=V.VID INNER JOIN SPAREPART S
ON P.SPID=S.SPID


Q.23 Display count of two wheeler and four wheeler from ser_details

SELECT TYP_VEH,COUNT(*)
FROM SER_DET
GROUP BY TYP_VEH


Q24 Display name of customers who paid highest SPGST and for which item 


select C.CNAME,S.SPNAME,MAX(SPGST)
FROM CUSTOMER C,SPAREPART S,purchase P
GROUP BY C.CNAME,S.SPNAME


Q25  Display vendors name who have charged highest SPGST rate  for which item

select V.VNAME,S.SPNAME,MAX(SPGST)
FROM VENDORS V,SPAREPART S,purchase P
GROUP BY V.VNAME,S.SPNAME


Q26  list name of item and employee name who have received item 

SELECT * FROM SPAREPART
SELECT * FROM employee
SELECT * FROM PURCHASE

SELECT \ E.ENAME ,S.SPNAME
FROM EMPLOYEE E INNER JOIN PURCHASE P
ON E.EID=P.EID INNER JOIN SPAREPART S
ON P.SPID=S.SPID

Q27  Display the Name and Vehicle Number of Customer who serviced his vehicle, And Name 
 the Item used for Service, And specify the purchase date of that Item with his vendor 
 and Item Unit and Location, And employee Name who serviced the vehicle. for Vehicle NUMBER "MH-14PA335".'

SELECT C.CNAME,S.VEH_NO,SP.SPNAME,SP.SPUNIT,P.PDATE,V.VNAME,V.VADD,E.ENAME
FROM SER_DET S  INNER JOIN CUSTOMER C
ON S.CID=C.CID  INNER JOIN SPAREPART SP
ON S.SPID=SP.SPID  INNER JOIN PURCHASE P
ON SP.SPID=P.SPID INNER JOIN VENDORS V
ON P.VID=V.VID INNER JOIN EMPLOYEE E
ON S.EID=E.EID WHERE VEH_NO='MH14PA335'

 Q28 who belong this vehicle  MH-14PA335" Display the customer name 
SELECT C.CNAME,S.VEH_NO
FROM SER_DET S  INNER JOIN CUSTOMER C
ON S.CID=C.CID WHERE VEH_NO='MH14PA335'

Q29 Display the name of customer who belongs to New York and when he /she service their  vehicle on which date 
cust cadd set

 SELECT C.CNAME,C.CADD,S.SER_DATE
 FROM CUSTOMER C JOIN SER_DET S
 ON C.CID=S.CID
 WHERE C.CADD= 'NEW YORK'

Q 30 from whom we have purchased items having maximum cost?

 select vname,max(total)
 from vendors,purchase
 group by vname

Q31 Display the names of employees who are not working as Mechanic and that employee done services   .

 select distinct e.ename
 from employee e JOIN SER_DET s
 ON e.eid=s.eid
 where ejob not in ('MECHANIC')




Q32 Display the various jobs along with total number of employees in each job. The output should
contain only those jobs with more than two employees.

select ejob,count(*)
from employee
group by ejob
having count(*)>2



Q33 Display the details of employees who done service  and give them rank according to their no. of services .


SELECT E.ENAME,E.EID,E.EJOB,E.EADD, DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) DR
FROM EMPLOYEE E 
JOIN SER_DET S ON E.EID=S.EID
GROUP BY E.ENAME,E.EID,E.EJOB,E.EADD
HAVING COUNT(*) > 0;


Q 34 Display those employees who are working as Painter and fitter and who provide service and
total count of service done by fitter and painter  

 select distinct e.ename,e.ejob,count(*)
 from employee e JOIN SER_DET s
 ON e.eid=s.eid
 where ejob not in ('MECHANIC')
 group by e.ename,e.ejob
 
 


Q35 Display employee salary and as per highest  salary provide Grade to employee 

select ename, esal,
case 
when esal>2000 and esal<2500 THEN 'GRADE A'
when esal>1500 and esal<2000 THEN 'GRADE B'
when esal>1000 and esal<1500 THEN 'GRADE C'
ELSE 'GRADE D'
END AS GRADE
FROM EMPLOYEE
WHERE esal IS NOT NULL
ORDER BY esal DESC;

Q36  display the 4th record of emp table without using group by and rowid

SELECT * FROM EMPLOYEE
WHERE ROWNUM<=4
MINUS
SELECT * FROM EMPLOYEE
WHERE ROWNUM<4


Q37 Provide a commission 100 to employees who are not earning any commission.


UPDATE SER_DET---NOT TO RUN
SET COMM = 100
WHERE COMM IS NULL;


Q38 write a query that totals no. of services  for each day and place the results
in descending order


SELECT SER_DATE, COUNT(*) AS typ_ser
FROM SER_DET
GROUP BY SER_DATE
ORDER BY typ_ser DESC;


Q39 Display the service details of those customer who belong from same city 

SELECT C.CNAME,C.CADD,S.TYP_SER
FROM CUSTOMER C JOIN SER_DET S
ON C.CID=S.CID
WHERE CADD IN (SELECT CADD FROM CUSTOMER GROUP BY
CADD HAVING  COUNT(DISTINCT CID)>1);


--Q40 write a query join customers table to itself to find all pairs of
customers service by a single employee

SELECT C1.CNAME,E.ENAME,TYP_VEH
FROM CUSTOMER C1 JOIN CUSTOMER C2
ON C1.CID=C2.CID
  JOIN  ser_det S
on S.CID=C1.CID JOIN EMPLOYEE E
ON S.EID=E.EID


  
Q41 List each service number follow by name of the customer who
made  that service


select c.cname,s.sid
from customer c join ser_det s
on c.cid=s.cid

Q42 Write a query to get details of employee and provide rating on basis of  maximum services provide 
by employee  .Note (rating should be like A,B,C,D)
select * from ser_det

select e.eid,e.ename,e.eadd,e.ejob,s.typ_ser, count(*)AS NUM_SER,     
CASE 
WHEN COUNT(*)>1 THEN 'GRADE A'
WHEN COUNT(*)=1 THEN 'GRADE B'
ELSE 'GRADE C'
END AS GRADE
from 
employee e join ser_det s
on e.eid=s.eid
group by e.eid,e.ename,e.eadd,e.ejob,s.typ_ser
ORDER BY NUM_SER DESC;




  
--Q43 Write a query to get maximum service amount of each customer with their customer details ?


select c.cid,c.cname,c.cadd,c_contact,cj_date,c.sex,max(ser_amt)
from customer c join ser_det s
on c.cid=s.cid
group by c.cid,c.cname,c.cadd,c_contact,cj_date,c.sex
order by max(ser_amt) desc

Q44 Get the details of customers with his total no of services ?

select c.cid,c.cname,c.cadd,c.c_contact,c.c_creditdays,c.cj_date,c.sex,count(*)
from customer c  join ser_det s
on c.cid=s.cid
group by c.cid,c.cname,c.cadd,c.c_contact,c.c_creditdays,c.cj_date,c.sex
order by count(*) DESC



Q45 From which location sparpart purchased  with highest cost ?

select v.vadd,max(total)
from vendors v join purchase p
on v.vid=p.vid
group by v.vadd
order by max(total) desc


--Q46 Get the details of employee with their service details who has salary is null
--null is not present in ser_det
select e.ename,esal
from employee e join ser_det s
on e.eid=s.eid
where esal is not null


--Q47 find the sum of purchase location wise 

 select v.vadd, sum(total)
from vendors v join purchase p
on v.vid=p.vid
group by v.vadd
order by sum(total) desc

--Q48 write a query sum of purchase amount in word location wise ?
SELECT * FROM purchase

SELECT * FROM VENDORS

select v.vid,V.vadd,sum(total) as sum_of_purchase,to_char( to_date( ROUND(SUM(TOTAL)),'J'),'JSP')  from purchase p
inner join vendorS v
on p.vid=v.vid
group by v.vid,V.vadd




Q49 Has the customer who has spent the largest amount money has
been give highest rating

select c.cname,max(P.total),
case 
  when max(P.total)<100000 AND max(P.total)>150000 THEN 'GRADE A'
when max(P.total)<50000 AND max(P.total)>5000  THEN 'GRADE B'
WHEN max(P.total)<5000 AND max(P.total)>3000  THEN 'GRADE C'
ELSE 'GRADE D'
END AS GRADE
FROM SER_DET S INNER JOIN CUSTOMER C
ON S.CID=C.CID INNER JOIN PURCHASE P
ON S.SPID=P.SPID
GROUP BY c.cname
ORDER BY max(P.total) DESC

SELECT * FROM PURCHASE


Q50 select the total amount in service for each customer for which
the total is greater than the amount of the largest service amount in the table

SELECT * FROM SER_DET

SELECT C.CNAME, SUM(S.SER_AMT)
FROM CUSTOMER C JOIN SER_DET S
ON C.CID=S.CID
GROUP BY C.CNAME
having SUM(S.SER_AMT)>500


Q51  List the customer name and sparepart name used for their vehicle and  vehicle type

select c.cname,sp.spname,s.typ_veh
from ser_det s inner join customer c
on s.cid=c.cid inner join sparepart sp
on s.spid=sp.spid


Q52 Write a query to get spname ,ename,cname quantity ,rate ,service amount for record exist in service table 

select sp.spname,e.ename,c.cname,s.qty,s.sp_rate,s.ser_amt
from ser_det s inner join customer c
on s.cid=c.cid inner join sparepart sp
on s.spid=sp.spid inner join employee e
on s.eid=e.eid


Q53 specify the vehicles owners who’s tube damaged.
select * from ser_det
select c.cname
from ser_det s inner join customer c
on s.cid=c.cid
where s.typ_ser='TUBE DAMAGED'


Q.54 Specify the details who have taken full service.

select c.cid,c.cname,c.cadd,c.c_contact,c.c_creditdays,c.cj_date,c.sex,s.typ_ser
from ser_det s inner join customer c
on s.cid=c.cid
where s.typ_ser='FULL SERVICING'


--Q.55 Select the employees who have not worked yet and left the job.
WORKED OR NOT?


select e.ename
from ser_det s inner join employee e
on s.eid=e.eid
where EDOL IS NOT NULL


--Q.56  Select employee who have worked first ever.

select ename,min(edoj)
from employee
group by ename
ORDER BY min(edoj) ASC



Q.57 Display all records falling in odd date


select * from ser_det
WHERE MOD((TO_CHAR (SER_DATE,'DD')),2)<>0


Q.58 Display all records falling in even date

select * from ser_det
WHERE MOD((TO_CHAR (SER_DATE,'DD')),2)=0

Q.59 Display the vendors whose material is not yet used.


select * from ser_det;
select * from vendors;
select * from sparepart;
select * from purchase;


select vname from vendors
where vid not in(select v. vid from ser_det s
inner join purchase p
on p.spid=s.spid
inner join vendors v
on v.vid=p.vid)


--Q.60 Difference between purchase date and used date of spare part.
--=NOT DONE
 select * from sparepart;
select * from purchase;
select * from ser_det;

select ROUND((ser_date- PDATE),2) AS diff from purchase P ,ser_det S where P.Spid= S.Spid

SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers


1.	List all customers with a rating of 100.

select cname
from customers
where rating=100

--2.	Find all records in the Customer table with NULL values in the city column.

select * from customers
where city is null

3.	Find the largest order taken by each salesperson on each date.
SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers

select s.sname,o.odate,max(o.amt)
from salespeople s join orders o
on s.snum=o.snum
group by s.sname,o.odate
order by max(o.amt) desc

4.	Arrange the Orders table by descending customer number.


select * from orders
order by cnum desc


5.	Find which salespeople currently have orders in the Orders table.


select distinct s.sname
from salespeople s join orders o
on s.snum=o.snum



6.	List names of all customers matched with the salespeople serving them.

select c.cname
from customers c join salespeople s
on c.snum=s.snum


7.	Find the names and numbers of all salespeople who had more than one customer.


select s.sname,count(*)
from salespeople s join customers c
on s.snum=c.snum
group by s.sname
having count(*)>1



8.	Count the orders of each of the salespeople and output the results in descending order.


SELECT S.SNAME,COUNT(*)
FROM salespeople S JOIN orders O
ON S.SNUM=O.SNUM
GROUP BY S.SNAME
order by COUNT(*) desc


9.	List the Customer table if and only if one or more of the customers in the Customer 
tables are located in San Jose.

select c1.cname,count(*)
from customers c1 join customers c2
on c1.snum=c2.snum
where c1.city='SAN JOSE'
group by c1.cname


--10.	Match salespeople to customers according to what city they lived in.


select c.cname,sname,s.city
from salespeople s join customers c
on S.SNUM=c.SNUM
where s.city=c.city

11.	Find the largest order taken by each salesperson.


select s.sname,max(o.amt)
from salespeople s join orders o
on s.snum=o.snum
group by s.sname
order by max(o.amt) desc


12.	Find customers in San Jose who has a rating above 200.


select cname from customers
where rating >200 AND CITY='SAN JOSE'


13.	List the names and commissions of all salespeople in London.


SELECT SNAME,COMM
FROM salespeople
WHERE CITY='LONDON'


14.	List all the orders of salesperson Monika from the Orders table.

SELECT S.SNAME,COUNT(*) O_ORDER
FROM salespeople S JOIN orders O
ON S.SNUM=O.SNUM
WHERE S.SNAME='MONIKA'
GROUP BY S.SNAME

--15.	Find all customers with orders on October 3.
SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers


SELECT * FROM orders;

SELECT C.CNAME, O.ODATE 
FROM customers C 
JOIN orders O ON C.cNUM = O.cNUM 
WHERE o.ODATE BETWEEN TO_date('03-10-0096 00:00','dd-mm-yyyy hh24:mi') and to_date('03-10-0096 23:59','dd-mm-yyyy hh24:mi');


16.	Give the sums of the amounts from the orders table, grouped by date, 

select odate,sum(Amt)
from orders
group by odate
order by sum(Amt) desc

17.	Eliminating all those dates where the SUM was not at least 2000.00 above the MAX amount.



select odate,sum(Amt)
from orders
group by odate
HAVING sum(Amt)>2000
order by sum(Amt) desc

18.	Select all orders that had amounts that were greater than at least one of the orders from October 6.

    SELECT *
FROM orders
WHERE amt > (
    SELECT MIN(amt)
    FROM orders
    WHERE ODATE BETWEEN TO_date ('06-10-0096 00:00','dd-mm-yyyy hh24:mi') and to_date('06-10-0096 23:59','dd-mm-yyyy hh24:mi')

)


19.	Write a query that uses the EXISTS operator to extract all salespeople who have customers with a rating of 300.


SELECT *
FROM salespeople s
WHERE EXISTS (
    SELECT snum
    FROM customers c
    WHERE c.SNUM = s.SNUM
    AND c.rating = 300
)



20.	Find all pairs of customers having the same rating.



SELECT c1.CNUM AS customer1_id, c2.CNUM AS customer2_id, c1.rating
FROM customers c1
JOIN customers c2 ON c1.rating = c2.rating
WHERE c1.CNUM < c2.CNUM


21.	Find all customers with CNUM, 1000 above the SNUM of Serres.


select C.Cname,C.cnum
from customers c join salespeople s
on c.snum=s.snum
where S.snum> 1002

22.	Give the salespeople’s commissions as percentage instead of decimal numbers.

SELECT COMM * 100 AS percentage_comm
FROM salespeople


23.	Find the largest order taken by each salesperson on each date, eliminating those MAX orders, which are less than $3000.00 in value.

select s.sname,o.odate,max(o.amt)
from salespeople s join orders o
on s.snum=o.snum
group by s.sname,o.odate
HAVING max(o.amt)>3000
order by max(o.amt) desc


24.	List the largest orders on October 3, for each salesperson.

SELECT S.SNAME, O.ODATE,MAX(AMT)
FROM salespeople S 
JOIN orders O ON S.SNUM = O.SNUM 
WHERE o.ODATE BETWEEN TO_date('03-10-0096 00:00','dd-mm-yyyy hh24:mi') and to_date('03-10-0096 23:59','dd-mm-yyyy hh24:mi')
GROUP BY  S.SNAME, O.ODATE
ORDER  BY MAX(AMT) DESC


25.	Find all customers located in cities where Serres (SNUM 1002) has customers.

select c.cname,c.city,s.snum
from salespeople s join customers c
on s.snum=c.snum
where s.snum = 1002


26.	Select all customers with a rating above 200.00. 

select cname
from customers
where rating>100

27.	Count the number of salespeople currently listing orders in the Orders table.



SELECT S.SNAME, COUNT(*)
FROM salespeople S 
JOIN orders O ON S.SNUM = O.SNUM 
GROUP BY S.SNAME
ORDER BY  COUNT(*) DESC

28.	Write a query that produces all customers serviced by salespeople with a commission above 12%.
Output the customer’s name and the salesperson‘s rate of commission.




SELECT c.cname,s.COMM * 100 AS per_comm
FROM salespeople s join customers c
on c.snum=s.snum
where s.COMM * 100 >12



29.	Find salespeople who have multiple customers.

SELECT s.snum, COUNT(c.cnum) AS num_customers
FROM salespeople s
JOIN customers c ON s.snum = c.snum
GROUP BY s.snum
HAVING COUNT(c.cnum) > 1;


30.	Find salespeople with customers located in their city.


SELECT DISTINCT s.sname, s.city
FROM salespeople s
JOIN customers c1 ON s.snum = c1.snum
JOIN customers c2 ON c1.city = c2.city
WHERE c2.snum = s.snum;

31.	Find all salespeople whose name starts with ‘P’ and the fourth character is ‘I’.


SELECT SNAME FROM salespeople
WHERE SNAME LIKE '%P__L%';

32.	Write a query that uses a sub query to obtain all orders for the customer named ‘Cisneros’. Assume you do not know his customer number.


SELECT * FROM ORDERS WHERE CNUM=(SELECT CNUM FROM CUSTOMERS WHERE CNAME= 'CISNEROS');


33.	Find the largest orders for ‘Serres’ and ‘Rifkin’.

SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers 

SELECT S.SNAME,S.CITY ,MAX(O.AMT)
FROM orders O JOIN salespeople S
ON O.SNUM=S.SNUM
GROUP BY S.SNAME,S.CITY
HAVING S.SNAME IN ('RIFKIN','SERRES')

34.	Extract the Salespeople table in the following order: SNUM, SNAME, COMMISSION, CITY.

SELECT SNUM, SNAME, COMM, CITY
FROM Salespeople;

35.	Select all customers whose names fall in between ‘A’ and ‘G’ alphabetical range.

SELECT *
FROM Customers
WHERE cname >= 'A' AND cname <= 'G';

OR 

SELECT *
FROM Customers
WHERE cname BETWEEN 'A' AND  'G';


36.	Select all the possible combinations of customers that you can assign.

SELECT c1.cname , c2.cname
FROM Customers c1 cross JOIN Customers c2
WHERE  c1.cnum =c2.cnum or
c1.cnum <>c2.cnum;

or 

select c1.cname , c2.cname  from Customers c1,Customers c2


37.	Select all orders that are greater than the average for October 4.

SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers 

SELECT *
FROM orders
WHERE  amt > (
  SELECT AVG(amt)
  FROM orders
  WHERE ODATE BETWEEN TO_date('04-10-0096 00:00','dd-mm-yyyy hh24:mi') and to_date('04-10-0096 23:59','dd-mm-yyyy hh24:mi')
);


--38.	Write a select command using a correlated sub query that selects the names and numbers of all customers 
--with ratings equal to the maximum for their city.

 SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers 


select c.cname,c.city,c.cnum,c.rating from customers c where c.rating=(select max(rating) from customers where c.city=city)


39.	Write a query that totals the orders for each day and places the results in descending order.


select odate,count(*)
from orders
group by odate
order by count(*) desc

40.	Write a select command that produces the rating followed by the name of each customer in San Jose.

 SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers 

SELECT * FROM customers where city='SAN JOSE'



41.	Find all orders with amounts smaller than any amount for a customer in San Jose.

 
select * from orders where amt< any (select amt from orders where cnum in( select cnum from customers where city='SAN JOSE'));

42.	Find all orders with above average amounts for their customers.

SELECT *
FROM orders
WHERE amt > any (SELECT AVG(amt)FROM orders )

43.	Write a query that selects the highest rating in each city.

select city,max(rating)
from customers
group by city


44.	Write a query that calculates the amount of the salesperson’s commission on order by a customer with a rating above 100.00.

 SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers 

select distinct s.snum,s.comm,c.rating,sum(s.comm*o.amt)
from salespeople s inner join orders o
on s.snum=o.snum inner join customers c
on s.snum=c.snum
group  by s.snum,s.comm,c.rating
having c.rating >100

45.	Count the customers with rating above San Jose’s average.
 
select CNAME,count(*)
from CUSTOMERs
where RATING > (select avg(rating) from customers where city='SAN JOSE')
group by CNAME


--46.Write a query that produces all pairs of salespeople with themselves as well as duplicate rows with the order reversed.

SELECT s.sname,c.cname from salespeople s ,customers c
order by s.sname,c.cname desc

47.	Find all salespeople that are located in either Barcelona or London.


select sname
from salespeople
WHERE city = 'BARCELONA' OR city = 'LONDON'

48.	Find all salespeople with only one customer.
 SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers 

select sname, count(*)
from salespeople s join customers c
on s.snum=c.snum
group by sname
having count(*)=1

--49.	Write a query that joins the Customer table to itself to find all pairs of customers served by a single salesperson.
SELECT c1.cnum, c2.cnum, c1.snum
FROM Customers c1
JOIN Customers c2 ON c1.snum = c2.snum
WHERE c1.cnum <> c2.cnum

50.	Write a query that will give you all orders for more than $1000.00.


select * from orders
where amt>1000

51.	Write a query that lists each order number followed by the name of the customer who made that order.

 SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers 

select  distinct o.onum,c.cname
from customers c join orders o
on c.cnum=o.cnum


--52.	Write 2 queries that select all salespeople (by name and number) who have customers in their cities 
who they do not service, one using a join and one a correlated subquery. Which solution is more elegant?

--2nd query
select distinct s.sname
from salespeople s join customers c
on s.city=c.city
 

53.	Write a query that selects all customers whose ratings are equal than ANY (in the SQL sense) of Serres.

 SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers 

select c.cname
from salespeople s join customers c
on s.snum=c.snum
where sname='SERRES'


54.	Write2 queries that will produce all orders taken on October3 or October 4.



SELECT onum
FROM orders
WHERE odate BETWEEN TO_DATE('03-10-0096 00:00','dd-mm-yyyy hh24:mi') AND TO_DATE('03-10-0096 23:59','dd-mm-yyyy hh24:mi')
   OR odate BETWEEN TO_DATE('04-10-0096 00:00','dd-mm-yyyy hh24:mi') AND TO_DATE('04-10-0096 23:59','dd-mm-yyyy hh24:mi');

55.	Write a query that produces all pairs of orders by a given customer. Name that customer and eliminate duplicates.


SELECT DISTINCT O.ONUM,C.CNAME
FROM ORDERS O JOIN CUSTOMERS C
ON C.CNUM=O.CNUM
WHERE C.CNAME='GIOVANNI'


56.	Find only those customers whose ratings are higher than every customer in Rome.

 SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers 

SELECT CNAME,rating
FROM customers
WHERE RATING > (select max(rating) from customers where city='ROME');


--57.	Write a query on the customers table whose output will exclude all customers with a rating < = 100.00, unless they are located in Rome.
 SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers 
SELECT *
FROM customers
WHERE rating > 100.00 OR city = 'Rome';

select *
from customers
where rating > 100.00 or city='ROME';

58.	Find all rows from the Customer table for which the salesperson number is 1001.


select c.cnum,c.cname,c.city,c.rating
from customers c join salespeople s
on c.snum=s.snum
where s.snum=1001

59.	Find the total amount in Orders for each salesperson for which this total is greater than the amount of the largest order in the table.


 

select s.sname,sum(o.amt),max(amt)
from salespeople s join orders o
on s.snum=o.snum
having sum(o.amt)> (select max(amt) from orders )
group by s.sname


60.	Write a query that selects all orders that have Zeroes or NULL in the Amount field.

select onum,amt
from orders 
where amt is null


--61.	Produce all combinations of salespeople and customer names such that the former precedes the latter alphabetically, 
and the latter has a rating of less than 200.

 SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers 

select s.sname,c.cname from salespeople s,customers c
where c.rating <200
order by s.sname,c.cname

62.	List all salespeople’s names and the commission they have earned.

select sname,comm
from salespeople

63.	Write a query that produces the names and cities of all customers with the same rating as
Hoffman. Write the query using Hoffman’s CNUM rather than his rating, so that it would still be usable if his rating changed.
SELECT * FROM customers 

select cname,city,cnum
from customers
where rating=100


---64.	Find all salespeople for whom there are customers that follow them in alphabetical order.

SELECT  s.SNAME, c1.cname
FROM Customers c1 JOIN salespeople s ON c1.snum = s.snum
GROUP BY s.SNAME, c1.cname
ORDER BY s.SNAME,c1.cname 



65.	Write a query that produces the names and ratings of all customers of all who have above average orders.

select c.cname,c.rating,avg(amt)
from customers c join orders o
on c.cnum=o.cnum
where amt > (select avg(amt)from orders)
group by  c.cname,c.rating

66.	Find the sum of all purchases from the Orders table.


SELECT SUM(amt) AS TotalPurchases
FROM Orders


67.	Write a select command that produces the order number, amount, and date for all rows in the Order table.


select onum,amt,odate
from orders



68.	Count the number of not null rating fields in the Customer table including duplicates.


select count(rating)
from customers


69.	Write a query that gives the names of both the salesperson and the customer for each order after the order number.



select s.sname,c.cname,o.onum
from salespeople s inner join customers c
on s.snum=c.snum
inner join orders o
on o.cnum=c.cnum


70.	List the commissions of all salespeople servicing customers in London.

select comm
from salespeople
where city='LONDON'


71.	Write a query using ANY or ALL that will find all salespeople who have no customers located in their city.


SELECT  s.sname FROM salespeople s
WHERE s.city != ALL(SELECT city FROM customers c WHERE c.snum = s.snum)


--72.	Write a query using the EXISTS operator that selects all salespeople with customers
located in their cities who are not assigned to them.

SELECT s.sname
FROM salespeople s
WHERE EXISTS (
  SELECT 1
  FROM customers c
  WHERE c.cnum <> s.snum
  AND c.city = s.city
)


73.	Write a query that selects all customers serviced by Peel or Motika.

SELECT CNAME FROM customers WHERE snum in(select snum from salespeople where sname ='PEEL' or sname ='MONIKA');

74.	Count the number of salespeople registering orders for each day. 
(If a salesperson has more than one order on a given day, he or she should be counted only once.).

SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers

SELECT odate, COUNT(DISTINCT snum) as num_salespeople 
FROM orders 
GROUP BY odate;

select  s.sname,o.odate,count(distinct s.snum)
from salespeople s join orders o
on s.snum=o.snum
group by s.sname,o.odate




75.	Find all orders attributed to salespeople in London.


select * from orders where snum in (select snum from salespeople where city ='LONDON')

76.	Find all orders by customers not located in the same cities as their salespeople.

SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers

SELECT *
FROM orders
WHERE cnum = any(
  SELECT c.cnum
  FROM customers c
  WHERE c.city != ALL(SELECT city FROM salespeople s WHERE c.snum = s.snum)
)

77.	Find all salespeople who have customers with more than one current order.

select s.sname,c.cname,count(o.onum)
from salespeople s inner join customers c
on s.snum=c.snum inner join orders o
on o.cnum=c.cnum
group by  s.sname,c.cname
having count(o.onum)>1

78.	Write a query that extracts from the Customer table every customer assigned to a salesperson
who currently has at least one other customer (besides the customer being selected) with orders in the Orders table.

select s.sname,count(c.cname)
from salespeople s inner join customers c
on s.snum=c.snum inner join orders o
on o.cnum=c.cnum
group by  s.sname



79.	Write a query that selects all customers whose name begins with ‘C’.

select cname
from customers
where cname LIKE 'C%';

80.	Write a query on the Customers table that will find the highest rating in each city. 
Put the output in this form:  for the city (city) the highest rating is : (rating).


SELECT 'For the city '|| city|| '  rating is: '|| MAX(rating)as j_j
FROM Customers
GROUP BY city;

81.	Write a query that will produce the Snum values of all salespeople with 
orders currently in the Orders table without any repeats.

SELECT DISTINCT S.SNUM,O.ONUM
FROM salespeople S JOIN ORDERS O
ON S.SNUM=O.SNUM



82.	Write a query that lists customers in descending order of rating. 
Output the rating field first, followed by the customers’ names and numbers.

select rating,cname,cnum
from customers
order by rating desc

83.	Find the average commission for salespeople in London.

select  ROUND(AVG(comm), 2)
from salespeople
where city='LONDON'


84.	Find all orders credited to the same salesperson that services Hoffman.

SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers

select s.sname,o.onum
from salespeople s inner join customers c
on s.snum=c.snum inner join orders o
on o.cnum=c.cnum
where c.cname='HOFFFMAN'

85.	Find all salespeople whose commission is in between 0.10 and 0.12 both inclusive.

select sname
from salespeople
where comm between 0.10 and 0.12



86.	Write a query that will give you the names and cities of all salespeople in London with commission above 0.10

SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers
select sname,city
from salespeople
where city ='LONDON' and comm>0.10

--87.	What will be the output from the following query? 
SELECT * FROM ORDERS WHERE (AMT < 1000 OR NOT (ODATE = 10/03/1996 AND CNUM > 2003));


SELECT * FROM ORDERS WHERE (AMT < 1000 OR NOT (odate BETWEEN TO_DATE('03-10-0096 00:00','dd-mm-yyyy hh24:mi') AND TO_DATE('03-10-0096 23:59','dd-mm-yyyy hh24:mi') AND CNUM > 2003));


88.	Write a query that selects each customer’s smallest order.

select cname,min(amt)
from customers c join orders o
on c.cnum=o.cnum
group by cname
order by min(amt) desc

89.	Write a query that selects the first customer in alphabetical order whose name begins with ‘G’.

select cname
from customers
where cname like 'G%'

90.	Write a query that counts the number of different not NULL city values in the Customers table.

SELECT COUNT(DISTINCT city)
FROM Customers
WHERE city IS NOT NULL;


91.	Find the average amount from the Orders table.

SELECT ROUND(AVG(AMT),2)
FROM ORDERS

--92.	What would be the output from the following query?
SELECT*FROM ORDERS WHERE NOT  (Odate =10/03/1996 OR Snum>1006) AND amt. >=1500);

SELECT*FROM ORDERS WHERE NOT  ((odate BETWEEN TO_DATE('03-10-0096 00:00','dd-mm-yyyy hh24:mi') AND TO_DATE('03-10-0096 23:59','dd-mm-yyyy hh24:mi') OR Snum>1006) AND amt >=1500);

93.	Find all customers who are not located in San Jose & whose rating is above 200.

SELECT CNAME
FROM CUSTOMERS
WHERE CITY NOT IN('SAN JOSE') AND RATING >200


94.	Give a simpler way to write this query:
SELECT Snum, Sname, city, Comm FROM salespeople WHERE (Comm>0.12 and Comm <0.14);

SELECT * FROM salespeople
WHERE COMM=0.13

95.	Evaluate the following query:
SELECT * FROM orders WHERE NOT ((Odate = 10/03/1996 AND Snum>1002) OR amt>2000);


96.	Which salespeople attend to customers not in the city they have been assigned to?

select s.sname from salespeople s where s.city not in ( select c.city from customers c where s.snum=c.snum)       

97.	Which salespeople get commission greater than 0.11 and serving customers rated less than 250?


select s.sname
from salespeople s inner join customers c
on s.snum=c.snum 
where s.comm >0.11 and c.rating<250

98.	Which salespeople have been assigned to the same city but get different commission percentages?

select distinct s1.sname
from salespeople s1 join salespeople s2
on s1.city=s2.city
where s1.comm<>s2.comm   


99.	Which salesperson has earned the most by way of commission?


with a as
(select sname,comm,amt,comm*amt d,max(comm*amt) e from salespeople s
inner join orders o
on s.snum=o.snum
group by sname,comm,amt)

select * from a
where e=(select max(e) from a)


100.	Does the customer who has placed the maximum number of orders have the maximum rating?

SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers

with a as(
select c.cname,count(*), c.rating from customers c
inner join orders o
on c.cnum=o.cnum 
group by c.cname,c.rating 
order by count(*) desc )

select * from a
where rating=(select max(rating) from  customers )---gives max rating for low count




101.Has the customer who has spent the largest amount of money been given the highest rating?


with a as(
select c.cname,max(o.amt),rating from customers c
inner join orders o
on c.cnum=o.cnum 
group by c.cname,rating
order by max(o.amt)desc)

select * from a
where rating=(select max(rating) from  customers )---gives max rating for low count

102.	List all customers in descending order of customer rating.

select cname,
rating from customers 
order by rating desc


103.	On which days has Hoffman placed orders?


select c.cname,o.odate from customers c
inner join orders o
on c.cnum=o.cnum
where c.cname='HOFFFMAN'

104.	Do all salespeople have different commissions?

SELECT DECODE(M,1,'YES',2,'NO') FROM (SELECT COMM,COUNT(*) M FROM SALESPEOPLE GROUP BY COMM)


105.	Which salespeople have no orders between 10/03/1996 and 10/05/1996?

SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers

SELECT s.sname
FROM salespeople s join orders o
on s.snum=o.snum
WHERE o.odate  not BETWEEN TO_DATE('03-10-0096 00:00','dd-mm-yyyy hh24:mi') AND TO_DATE('03-10-0096 23:59','dd-mm-yyyy hh24:mi')
   and o.odate BETWEEN TO_DATE('05-10-0096 00:00','dd-mm-yyyy hh24:mi') AND TO_DATE('05-10-0096 23:59','dd-mm-yyyy hh24:mi');
   
106.	How many salespersons have succeeded in getting orders?

select distinct sname
from salespeople s join orders o
on s.snum=o.snum


107.	How many customers have placed orders?
select  count(distinct cname)
from customers c join orders o
on c.cnum=o.cnum

select  count(distinct cnum)
from orders

108.	On which date has each salesperson booked an order of maximum value?


SELECT s.sname, o.odate
FROM salespeople s
JOIN orders o ON s.snum = o.snum
WHERE o.amt = (
  SELECT MAX(amt)
  FROM orders 
  WHERE snum = s.snum
)


109.	Who is the most successful salesperson?
SELECT * FROM salespeople
SELECT * FROM orders
SELECT * FROM customers

with a as
(
SELECT sname,SUM(o.amt) as b
FROM salespeople s
JOIN orders o ON s.snum = o.snum
GROUP BY s.sname
ORDER BY b DESC
)

select * from a
where b=(select max(b) from a)


110.	Who is the worst customer with respect to the company?

with a as
(
SELECT cname,SUM(o.amt) as b
FROM customers s
JOIN orders o ON s.snum = o.snum
GROUP BY s.cname
ORDER BY b DESC
)

select * from a
where b=(select min(b) from a)

--111.	Are all customers not having placed orders greater than 200 totally been serviced by salesperson Peel or Serres?

select * from salespeople
select * from customers
select * from orders

select c.cname,o.amt,s.sname
from customers c inner join orders o
on c.cnum=o.cnum inner join salespeople s
on s.snum=o.snum
where s.sname='PEEL' or  s.sname='SERRES'
and o.amt<200




112.	Which customers have the same rating?

select c1.cname
from customers c1 join customers c2
on  c1.rating=c2.rating 
where c1.cnum >c2.cnum


113.	Find all orders greater than the average for October 4th.


SELECT *
FROM orders
  where amt > (
      SELECT AVG(amt)
      FROM orders
      WHERE odate BETWEEN TO_DATE('04-10-0096 00:00','dd-mm-yyyy hh24:mi') AND TO_DATE('04-10-0096 23:59','dd-mm-yyyy hh24:mi')
  );


114.	Which customers have above average orders?

SELECT c.cnum, c.cname, sum(o.amt) FROM customers c
JOIN orders o
ON c.cnum = o.cnum
GROUP BY c.cnum, c.cname 
HAVING sum(o.amt)> any(SELECT AVG(amt) FROM orders) 


115.	List all customers with ratings above San Jose’s average.


select cname,rating from customers where rating >any (select avg(rating) from customers where city='SAN JOSE' )



116.	Select the total amount in orders for each salesperson for which the total is greater than
the amount of the largest order in the table.



select s.sname,sum(o.amt)
from salespeople s join orders o
on s.snum=o.snum
group by s.sname
having sum(o.amt)> any (select max(amt) from orders)




117.	Give names and numbers of all salesperson that have more than one customer.

select s.snum, s.sname ,count(*)
from salespeople s join customers c
on s.snum=c.snum
group by s.snum, s.sname
having count(*)>1



118.	Select all salesperson by name and numbers who have customers in their city whom they don’s the service.


SELECT distinct s.sname,s.snum
from salespeople s inner join customers c
on s.city=c.city 
WHERE s.snum)


SELECT * FROM salespeople s
WHERE s.city in (select city from customers c WHERE c.snum!=s.snum)



119.	Which customers’ rating should be lowered?ou 


SELECT * FROM 
(select c.cname,c.cnum,sum(o.amt),
RANK() OVER (ORDER BY sum(o.amt))RM
from customers c join orders o
on c.cnum=o.cnum
group by c.cname,c.cnum) rose
WHERE rose.RM =1



--120.	Is there a case for assigning a salesperson to Berlin?

select * from salespeople
select * from customers
select * from orders

select snum,count(cnum) from customers where city = 'BERLIN' group by snum

121.	Is there any evidence linking the performance of a salesperson to commission that he or she is being paid?

SELECT s.snum,s.sname,sum(s.comm) FROM salespeople s
JOIN orders o on s.snum=o.snum
group by s.snum,s.sname
order by sum(s.comm) desc
--salesperson per can be judge on total per

--122.	Dose the total amount in orders by customer in Rome and London exceeds the
commission paid to salesperson in London and New York by more than 5 times?
select * from salespeople
select * from customers
select * from orders


with a as
(SELECT SUM(o.amt)f from orders o join customers c
on c.cnum=o.cnum
where c.city in ('ROME','LONDON') ),

b as (select 5*sum(s.comm*o.amt)e from salespeople s 
join orders o 
on s.snum=o.snum 
where s.city in ('LONDON','NEW YORK'))

select case 
when e > f then 'yes'
else 'no'
end pmt
 from a,b


123.	Which is the date, order number, amt and city for each salesperson 
(byname) for   the maximum order he has obtained?



with b as(
select distinct s.sname,o.odate,o.onum,s.city,max(o.amt) a
from salespeople s join orders o
on s.snum=o.snum
group by s.sname,o.odate,o.onum,s.city
order by max(o.amt) desc)

select *from b
where a=(select max(a) from b)


124.	Which salesperson(s) should be fired?

SELECT SNUM,COUNT(*) FROM ORDERS
GROUP BY SNUM
HAVING COUNT(*)<2


125.	What is the total income for the company?

SELECT (SUM(amt)-SUM(amt*COMM)) AS INCOME FROM ORDERS O
INNER JOIN SALESPEOPLE S
ON S.SNUM=O.SNUM
