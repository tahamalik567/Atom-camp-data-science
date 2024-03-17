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
 




