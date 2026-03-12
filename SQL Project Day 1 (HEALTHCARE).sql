create database hospital_management
use hospital_management

-- provide the 2nd patient row

select * 
from patients
limit 1 offset 1

-- how many patients are recintly registered in last 30 days

select *
from patients
where registration_date >= (select max(registration_date) - interval 30 day from patients)
order by registration_date desc


-- insight >> only one patient registered
-- very low recent acquisition rate
-- reduce marketing, bad reveiew, if this pattern continues there will be no new patients in future
-- no effiecent utlisation of resources

select * from doctors

-- how many doctors are available in hospital

select count(doctor_id) as Total_No_of_Doctors
from doctors

-- workforce of the hospital is 10

-- what are distinct specilation in the hospital

select distinct(specialization) 
from doctors

-- sort the doctor based on experience and provide first and last name together

select concat(first_name, " ", last_name) as Doctor_name, specialization, years_experience
from doctors
order by years_experience desc

-- there are lot of doctors who are highly experience

-- find the doctor name ending with 'is' based on first name

select first_name
from doctors
where first_name like '%is'


select * from appointments

-- what is the total number of rows

select count(*) from appointments

-- what is appointment status distribution

select  status, count(status)
from appointments
group by status

-- provide me the status type whose count more than 50

select status, count(*)
from appointments
group by status
having count(*) > 50

-- find all the appointments in the last 7 days

	select *
	from appointments
	where appointment_date >= (select max(appointment_date) - interval 7 day from appointments)
	order by appointment_date desc
    
-- 	only one appointments is completed in last 7 days
-- patients are comming after the follow up


-- find date wise count of status

select appointment_date, status, count(status)
from appointments
group by appointment_date, status
order by appointment_date desc


select * from treatments

-- how to total rows of treatment

select count(treatment_id)
from treatments

-- can you find most common treatment_type

select treatment_type, count(*) as treatment_count
from treatments
group by treatment_type
order by treatment_count desc

-- find min cost, max cost , avg cost of the treatment

select min(cost) as Min_cost, max(cost) as max_cost, round(avg(cost),1) as Avg_cost
from treatments
	
select cast(10.389 as decimal (10, 4))
    
select * from Billing

-- find the total rows 

select count(*) from billing

-- payment status distribution

select payment_status, count(payment_status) as bill_count
from billing
group by payment_status


-- pateint and doctors >> segmentation 

select * from patients

-- how many patients are registered from each address

select address,count(address) as Patient_count
from patients
group by address
order by Patient_count desc

-- these are region are residential are, localized demand, strongs referral	network
-- targerted outreach (promotional activities)

-- what is age distribution of patients

select patient_id, first_name, last_name, gender,
timestampdiff (year, date_of_birth, curdate()) as age
from patients

-- age group segmentation 
-- 18-35 (young)
-- 36-55 (middle_age)
-- 56 + (old)

-- age_group, patient_count

select
case
	when timestampdiff (year, date_of_birth, curdate())  < 18 then 'child'
	when timestampdiff (year, date_of_birth, curdate())  between 18 and 35 then 'Adults'
	when timestampdiff (year, date_of_birth, curdate())  between 36 and 55 then 'Old_adults'
	else 'senior_citizens'
end as age_group,
count(*) as patient_count
from patients
group by age_group
order by patient_count desc

-- which email domains are most commonly used by patients

select substring_index(email, "@", -1) as email_domain,
count(*) as patient_count
from patients
group by email_domain


-- which month has higher patients registration

select year(registration_date) as year , month(registration_date) as month, count(*) as patient_count
from patients
group by year, month


-- which medical specialization are most in demand based on appointment volume

select * from doctors

select * from appointments

select d.specialization, count(a.appointment_id) as total_appointments
from doctors as d join appointments as a
on d.doctor_id = a.doctor_id
group by d.specialization


-- are critical specialization supported by senior experience doctor or junior doctor
-- > 15 year - senior doctor

select specialization, count(*) as total_doctor,
sum(case when years_experience >= 15 then 1 else 0 end) as senior_doctor,
sum(case when years_experience < 15 then 1 else 0 end) as junior_doctor	
from doctors
group by specialization


-- make a table/maste data >> appointments with patients details and doctor specialization

select * from doctors
select * from patients
select * from appointments


select a.appointment_id, concat(p.first_name," ", p.last_name) as patient_name, concat(d.first_name," ", d.last_name) as doctor_name,
d.specialization, a.appointment_date, a.appointment_time
from appointments as a join patients as p
on a.patient_id = p.patient_id
join doctors as d
on a.doctor_id = d.doctor_id 
order by a.appointment_id


-- which doctors are overloaded and which have availablity capacity based on appointment volume

select concat(d.first_name," ", d.last_name) as doctor_name, d.specialization, count(appointment_id) as total_appointments
from appointments as a left join doctors as d
on a.doctor_id = d.doctor_id
group by d.doctor_id, doctor_name, d.specialization
order by total_appointments


-- build a big master data where we can see the entire journey of a pateint >> from appointment, treatment, billing

select * from billing
select * from treatments
select * from appointments

select p.patient_id, concat(p.first_name, " ", p.last_name) as patient_name, a.appointment_id, a.appointment_date,
a.status as appointment_status, t.treatment_id, t.treatment_type, t.cost as treatment_cost, b.bill_id, b.amount as bill_amount,
b.payment_status
from patients as p join appointments as a 
on p.patient_id = a.patient_id 
left join treatments as t
on a.appointment_id = t.appointment_id
left join billing as b
on t.treatment_id = b.treatment_id
order by p.patient_id, a.appointment_date

-- finances
-- what is total revenue generated by company

select sum(amount) as Total_revenue
from billing
where payment_status = "Paid"

-- which patients contribute the most revenue

select concat(first_name, " ", last_name) as patient_name, sum(b.amount) as total_spent
from patients as p join billing as b
on p.patient_id = b.patient_id
group by p.patient_id, patient_name
order by total_spent desc


-- RFM segmentation
-- Recency, Frequency, Monetary

-- create the RFM matrix per patient using last_visit, total_visit, paid_spend
-- label as 'champoins', 'loyal high value', 'risk'

WITH rfm AS (
  SELECT
    p.patient_id,
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    MAX(a.appointment_date) AS last_visit,
    COUNT(DISTINCT a.appointment_id) AS frequency,
    COALESCE(SUM(CASE WHEN b.payment_status='Paid' THEN b.amount END),0) AS monetary
  FROM patients p
  LEFT JOIN appointments a ON a.patient_id = p.patient_id
  LEFT JOIN billing b ON b.patient_id = p.patient_id
  GROUP BY p.patient_id, patient_name
),
scored AS (
  SELECT
    *,
    DATEDIFF(CURDATE(), last_visit) AS recency_days,
    NTILE(4) OVER (ORDER BY DATEDIFF(CURDATE(), last_visit) ASC) AS r_score, -- lower recency better
    NTILE(4) OVER (ORDER BY frequency DESC) AS f_score,
    NTILE(4) OVER (ORDER BY monetary DESC) AS m_score
  FROM rfm
)
SELECT
  patient_id, patient_name,
  recency_days, frequency, monetary,
  r_score, f_score, m_score,
  CONCAT(r_score,f_score,m_score) AS rfm_code,
  CASE
    WHEN r_score >=3 AND f_score >=3 AND m_score >=3 THEN 'Champions'
    WHEN f_score >=3 AND m_score >=3 THEN 'Loyal High Value'
    WHEN r_score <=2 AND f_score <=2 THEN 'At Risk / Inactive'
    WHEN f_score >=3 THEN 'Frequent Visitors'
    WHEN m_score >=3 THEN 'High Spenders'
    ELSE 'Regular'
  END AS segment
FROM scored
ORDER BY monetary DESC, frequency DESC;


-- -- outlier detection
-- are there treatments with unusually high cost that require review

select treatment_id, treatment_type, cost
from treatments 
where cost > (select avg(cost) + 2 *stddev(cost) from treatments)

-- Rank doctors by total appointment

select concat(d.first_name, " ", d.last_name) as doctor_name,
d.specialization,
count(a.appointment_id) as total_appointments
from appointments as a join doctors as d 
on a.doctor_id = d.doctor_id
group by d.doctor_id, doctor_name, d.specialization
order by total_appointments desc


-- Rank patients by total spending (VIP patients)

select p.patient_id, concat(p.first_name, " ", p.last_name) as patient_name,
sum(b.amount) as total_spent,
rank() over (order by sum(b.amount) desc) as spending_rank
from patients as p join billing as b
on p.patient_id = b.patient_id
where b.payment_status = "Paid"
group by p.patient_id, patient_name

-- select treatment by frequency

select treatment_type, count(*) as treatment_count,
rank() over (order by count(*) desc) as frequency_rank
from  treatments
group by treatment_type


--  count the no. of patient from patient table

select count(*) 
from patients

-- count the rows in appointment table

select count(*)
from appointments

-- are there appointment status that indicates patient disengagement list

select status, count(*) as appointment_count
from appointments
group by status

-- no show + cancelled > completed + scheduled >> high patient disengagement risk

-- which patient are repeatedly missing the appointment and may need intervention,
-- 40 % > no show and total appointments > 3


with patient_status_summary as (
select p.patient_id, concat(p.first_name, " ", p.last_name) as patient_name, count(a.appointment_id) as total_appointments,
sum(case when a.status = "No show" then 1 else 0 end) as No_show_Count,
Round(sum(case when a.status = "No show" then 1 else 0 end) * 100
/ count(a.appointment_id),2) as No_show_rate

from patients as p join appointments as a 
on p.patient_id = a.patient_id
group by p.patient_id, patient_name)

select * from patient_status_summary
where total_appointments >= 3
and no_show_rate >= 40
order by no_show_rate desc , no_show_count desc


-- are there treatment with unusaully high cost that require review (> 1.5 standard deviation)

select *
from treatments
 
select treatment_id treatment_type , cost
from treatments
where cost > (select avg(cost) + 1.5 * std(cost) from treatments)

-- rank doctors by total appointments

select * from appointments

select concat(d.first_name, " ", d.last_name) as doctor_name, d.specialization, count(a.appointment_id) as total_appointments 
from doctors as d join appointments as a 
on d.doctor_id = a.doctor_id
group by d.doctor_id, doctor_name, d.specialization
order by total_appointments desc limit 5

-- rank patients by total spending

select p.patient_id, concat(p.first_name, " ", p.last_name) as patient_name, sum(b.amount) as total_spent,
rank()over(order by sum(b.amount)desc) as spending_rank
from patients as p join billing as b
on p.patient_id = b.patient_id
where b.payment_status = "Paid"
group by p.patient_id, patient_name


-- Monthly appointment trend

select year(appointment_date) as year, month(appointment_date) as month, count(*) as appointment_count
from appointments
group by year, month
order by year, month

-- appointments by day of week

select dayname(appointment_date) as day_of_week, count(*) as appointment_count
from appointments
group by day_of_week


-- monthly revenue trend

select year(bill_date) as year ,month(bill_date) as Months, sum(amount) as total_revenue
from billing 
where amount = "Paid" 
group by year,months
order by year, months

-- appointment seqeunce by patients

select patient_id, appointment_id, appointment_date, 
row_number() over (partition by patient_id order by appointment_date) as visit_number
from  appointments

-- what is the gap between patient visit

select patient_id, appointment_id, 
datediff(appointment_date, lag(appointment_date)over (partition by patient_id order by appointment_date)) as no_of_days_gap
from  appointments


