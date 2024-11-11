--coding challenge : Crime Management System

--create database
create database CMSystem

--create tables
create table Crime (
 CrimeId int primary key,
 Incident_type varchar(255),
 Incident_date date,
 Location varchar(255),
 Description text,
 Status varchar(20)
)

create table Victim (
 VictimId int primary key,
 CrimeId int,
 Name varchar(50),
 ContactInfo varchar(255),
 Injuries varchar(200),
 Age int,
 foreign key (CrimeId) references Crime(CrimeId)
)

create table Suspect (
 SuspectId int primary key,
 CrimeId int,
 Name varchar(255),
 Description varchar(200),
 CriminalHistory text,
 foreign key (CrimeId) references Crime(CrimeId)
)
alter table Suspect
add Age int;

-- Insert values
insert into Crime values
(1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
(2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'),
(3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed')
insert into Crime values
(4, 'Assault', '2023-10-05', '321 Maple St, Cityville', 'Reported assault incident', 'Open')
INSERT INTO Crime VALUES 
(5, 'Burglary', '2023-10-15','321 Maple St, Cityville','Burglary at a residential house', 'Open')

insert into Victim  values
 (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries',35),
 (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased',28),
 (3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None',42)

insert into Suspect values
(1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'),
(2, 2, 'Unknown', 'Investigation ongoing', NULL),
(3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests')
UPDATE Suspect set Age = 40 where SuspectID = 1;
UPDATE Suspect set Age = 30 where SuspectID = 2;
UPDATE Suspect set Age = 25 where SuspectID = 3;
insert into Suspect values
(4, 1, 'Robber 1', 'Involved in another robbery', 'Previous robbery convictions', 40)



-- 1. Select all open incidents.
select * from Crime where Status='Open'

--2.Find the total number of incidents
select count(*) as Total_Incidents from Crime

-- 3.List all unique incident types
select distinct Incident_type
from Crime

--4.Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'
select * from Crime 
where Incident_date between '2023-09-01' and '2023-09-10'

-- 5.List persons involved in incidents in descending order of age
select v.Name,v.age from Victim v
join Crime c
on v.CrimeId=c.CrimeId
order by v.age desc

--6.Find the average age of persons involved in incidents
select avg(Age) as average_age
from (select Age from Suspect union select Age from Victim) as People

--7.List incident types and their counts, only for open cases
select Incident_type,count(Incident_type) as Incidentcount from Crime
where Status='Open' 
group by Incident_type

--8.Find persons with names containing 'Doe'
select name from Victim where Name like '%Doe%' 
union all
select name from Suspect where name like '%Doe%'

--9.Retrieve the names of persons involved in open cases and closed cases
select v.name,c.Status as Case_Invloved from Victim v
join Crime c on v.CrimeId=c.CrimeId
where c.Status in ('Open','Closed')
union
select s.Name, c.Status as Case_Invloved
from Suspect s
join Crime c on s.CrimeId = c.CrimeId
where c.Status in ('Open', 'Closed')

--10.List incident types where there are persons aged 30 or 35 involved
select c.incident_type
from crime c
left join victim v on c.crimeid = v.crimeid and v.age in (30, 35)
left join suspect s on c.crimeid = s.crimeid and s.age in (30, 35)

--11.Find persons involved in incidents of the same type as 'Robbery'
select v.name, c.incident_Type
from victim v
join crime c on v.crimeid = c.crimeid
where c.incident_Type = 'Robbery'
union
select s.name, c.incident_Type
from suspect s
join crime c on s.crimeid = c.crimeid
where c.incident_Type = 'Robbery'

--12.List incident types with more than one open case
select Incident_Type,count(*) as Incident_count from Crime
where Status='Open'
group by Incident_Type
having count(*)>1

--13.List all incidents with suspects whose names also appear as victims in other incidents
select Incident_Date,Incident_Type,Location,c.Description,Status from Crime c
join Suspect s on s.CrimeID=c.CrimeID
where s.name in(select name from Victim)

-- 14. Retrieve all incidents along with victim and suspect details
select c.CrimeId, c.Incident_type, v.Name as VictimName, s.Name as SuspectName from Crime c
left join Victim v on c.CrimeId = v.CrimeId
left join Suspect s on c.CrimeId = s.CrimeId

--15. Find incidents where the suspect is older than any victim
select c.CrimeId, s.Name as SuspectName, s.Age as SuspectAge, v.Name as VictimName, v.Age as VictimAge
FROM Crime c
join Suspect s on c.CrimeId = s.CrimeId
join Victim v on c.CrimeId = v.CrimeId
WHERE s.Age > v.Age

--16.Find suspects involved in multiple incidents
select s.Name, count(*) as Incident_count from Suspect s
group by s.Name having COUNT(*) > 1

--17.List incidents with no suspects involved
SELECT c.CrimeId, c.Incident_type, c.Incident_date, c.Location, c.Description, c.Status
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeId = s.CrimeId
WHERE s.SuspectId IS NULL

--18.List all cases where at least one incident is of type 'Homicide' and all other incidents are of type'Robbery'
SELECT * 
FROM Crime 
WHERE Incident_type IN ('Robbery', 'Homicide')

--19.Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or 'No Suspect' if there are none.
select c.CrimeId, c.Incident_Type,
isnull(s.Name, 'No Suspect') AS SuspectName
FROM Crime c
left join Suspect s ON c.CrimeId = s.CrimeId

--20.List all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault'
select distinct s.Name from Suspect s
JOIN Crime c ON s.CrimeId = c.CrimeId 
where c.Incident_type in ('Robbery', 'Assault')