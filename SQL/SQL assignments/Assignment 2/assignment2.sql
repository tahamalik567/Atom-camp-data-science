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




