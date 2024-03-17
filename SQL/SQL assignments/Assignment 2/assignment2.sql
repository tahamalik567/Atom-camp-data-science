-- List the names of all pet owners along with the names of their pets.
use assignment_sql_2;
select * from petowners;
select * from pets;
select petowners.Name, pets.Name as petname
from petowners 
inner join pets on petowners.OwnerID = pets.OwnerID;

-- List all pets and their owner names, including pets that don't have recorded owners. 
select pets.Name as pet_name ,petowners.Name
from pets
left join petowners 
on pets.OwnerID = petowners.OwnerID ;

-- Combine the information of pets and their owners, including those pets without 
-- owners and owners without pets. 

select * 
from pets
left join petowners
on pets.OwnerID = petowners.OwnerID
union 
select *
from petowners
right join pets
on petowners.OwnerID = pets.OwnerID;

-- 4. List all pet owners and the number of dogs they own.
select * from petowners;
select * from pets;

select petowners.OwnerID, petowners.Name as OwnerName, count(pets.OwnerID) as total_Dogs
from petowners
left join pets
on  petowners.OwnerID = pets.OwnerID
and petsprocedureshistory.Kind='Dog' 
group by petowners.OwnerID ,petowners.Name;

-- 5. Identify pets that have not had any procedures.
select * from procedureshistory;
select * from proceduresdetails;

select * 
from pets
left join procedureshistory
on pets.PetID = procedureshistory.petID
where procedureshistory.procedureType is null;

-- 6. Find the name of the oldest pet
 select max(Age) from pets;
 select Name as oldest_pet
 from pets 
 where Age = (select max(Age) from pets);
 
 -- 7. Find the details of procedures performed on 'Cuddles'.
select Pets.PetID,Pets.Name, procedureshistory.procedureType
from pets
inner join procedureshistory
on pets.PetID = procedureshistory.PetID
where pets.Name = 'Cuddles';

-- 8. List the pets who have undergone a procedure called 'VACCINATIONS'.
select Pets.PetID,Pets.Name, procedureshistory.procedureType
from pets
inner join procedureshistory
on pets.PetID = procedureshistory.PetID
where procedureshistory.procedureType = 'VACCINATIONS';

-- 9. Count the number of pets of each kind. 
select * from pets;
select distinct(kind) from pets;
select  kind,count(*) as count_of_kind
from pets
group by kind;

-- 10.Group pets by their kind and gender and count the number of pets in each group. 
select  kind, gender,count(*) as count_of_pets
from pets
group by kind,gender;

-- 11.Show the average age of pets for each kind, but only for kinds that have more than 5 
-- pets.
select kind,avg(age) 
from pets 
group by kind
having count(*)>5; 

-- 12.Find the types of procedures that have an average cost greater than $50.
select * from proceduresdetails;
select avg(price) from proceduresdetails;
select ProcedureType ,avg(price)
from proceduresdetails
group by ProcedureType
having avg(price) > 50 ;

-- 13.Classify pets as 'Young', 'Adult', or 'Senior' based on their age. Age less then 3 
-- Young, Age between 3and 8 Adult, else Senior  
select *,
case
	when Age <3 then 'Young'
    when Age between 3 and 8 then 'Adult'
    else 'Senior'
end as age_group
from pets;


-- 14.Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female). 
select *,
case
	when Gender = 'male' then 'Boy'
    when Gender = 'female' then 'Girl'
end as boy_girl
from pets;

-- 15.For each pet, display the pet's name, the number of procedures they've had, and a 
-- status label: 'Regular' for pets with 1 to 3 procedures, 'Frequent' for 4 to 7 
-- procedures, and 'Super User' for more than 7 procedures. 
select * from pets;
select PetID, ProcedureType,count(ProcedureType) from procedureshistory
group by PetID,ProcedureType;
select pets.Name,pets.petID , count(procedureshistory.ProcedureType),
case 
	when count(procedureshistory.ProcedureType) between 1 and 3 then 'Regular'
    when count(procedureshistory.ProcedureType) between 4 and 7 then 'Frequent'
    else 'Super User'
end as status_laybel
from pets
left join procedureshistory
on pets.PetID = procedureshistory.PetID
group by pets.Name,pets.PetID;

















