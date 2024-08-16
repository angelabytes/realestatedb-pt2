-- Tickets
-- 1. Find the average listing price of all properties.
-- Calculate the average listing price using a subquery.

select avg(listingprice) as avg_price
from properties 
where (Select avg(listingprice) from properties);


-- 2. Retrieve the address of the property with the lowest listing price.
-- Use a subquery to determine the lowest listing price and get the property address.

select address, listingprice as property_price
from properties 
where listingprice = (select min(listingprice) from properties);

-- 3. List the addresses of all properties where the listing price is above the average listing price.
-- Use a subquery to find the average listing price and filter properties.
select address, listingprice as price
from properties
where listingprice > (select avg(listingprice) from properties);

-- 4. Find the names of agents who have listed at least one property with a listing price above $500,000.
-- Use a subquery to filter agents based on listing prices.

select firstname, lastname
from agents
where agentid in (select agentid from properties where listingprice > 500000);

-- 5. Retrieve the address and number of bedrooms for the properties with the highest number of bedrooms.
-- Use a subquery to find the property with the most bedrooms.

select address, max(bedrooms) as max_bedrooms
from propertydetails
left join properties on propertydetails.PropertyID = properties.PropertyID
where bedrooms = (select max(bedrooms)from propertydetails)
group by address;

-- 6. Find the average number of bedrooms across all properties.
-- Use a subquery to calculate the average number of bedrooms.

select avg(bedrooms) as avg_bedrooms
from propertydetails
right join properties using (propertyid)
where (select avg(bedrooms) from propertydetails);

-- 7. Retrieve the details of the property with the oldest construction date.
-- Use a subquery to find the property with the earliest YearBuilt.

select *
from properties 
inner join propertydetails using(propertyid)
where yearbuilt = (select min(yearbuilt) from propertydetails);

-- 8. List all properties where the number of bathrooms is greater than the average number of bathrooms.
-- Use a subquery to compare the number of bathrooms with the average.

select * from 
properties
inner join propertydetails using(propertyid)
where bathrooms > (select avg(bathrooms) from propertydetails);

-- 9. Find the total number of properties that have a 'Pool' as an amenity.
-- Use a subquery to count the number of properties with the 'Pool' amenity.

select * from 
properties p
inner join propertyamenityassignments using(propertyid)
inner join propertyamenities using(propertyid);

-- 10. List the names of all amenities that are assigned to more than 3 properties.
-- Use a subquery to filter amenities based on the number of properties they are assigned to.
select amenityname
from propertyamenities pa
where (
select count(*) 
from propertyamenityassignments paa
where paa.amenityid = pa.amenityid) > 3;

-- 11. Retrieve all properties that have more bedrooms than the average number of bedrooms and a listing price above the average listing price.
-- subquery to filter properties based on bedrooms and listing price.
select *
from properties p
where(
	(select bedrooms 
    from propertydetails pd 
    where p.PropertyID = pd.PropertyID) > 
    (select avg(bedrooms) from  propertydetails)
    and p.listingprice > (select avg(listingprice) from properties)
);


-- 12. Find the names of clients who have purchased properties with more than 3 bedrooms and a sale price above $500,000.
-- a subquery to filter clients based on the number of bedrooms and sale price.

select * from clients
inner join transactions using(clientid)
inner join propertydetails using(propertyid)
where propertydetails.bedrooms > 3 and transactions.saleprice > 500000;
