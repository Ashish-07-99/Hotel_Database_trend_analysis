--Data Cleaning Project for a Housing Company


Select * from Housing

----Standardize Date Format

Select saledatenew,convert(date,saledate) from Housing


--update Housing set saledate =convert(date,saledate) not Working 
--alternate method

Alter table Housing 
add saledatenew date

update housing
set saledatenew=convert(date,saledate) 


--Populate property Address whereever its NULL

Select a.parcelid,a.Propertyaddress,b.parcelid,b.propertyaddress
from Housing a
join housing b on a.parcelid =b.parcelid
and a.uniqueid <> b.uniqueid
where a.Propertyaddress is null

update a 
set propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
from Housing a
join housing b on a.parcelid =b.parcelid
and a.uniqueid <> b.uniqueid
where a.Propertyaddress is null

---Breaking Addresss Into indiviual columns (Address,City,State)


select propertyaddress,prop_address,prop_city from housing

select 
substring(propertyaddress,1,charindex(',',propertyaddress)-1) as address,
substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as City
from housing

Alter table Housing 
add Prop_Address varchar(255)

update housing
set Prop_Address=substring(propertyaddress,1,charindex(',',propertyaddress)-1)

Alter table Housing 
add Prop_city varchar(255)

update housing
set Prop_city=substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))


--2.We need to split Owner address

select owneraddress,owner_address,owner_city,owner_state from housing

select 
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from housing

Alter table Housing 
add Owner_Address varchar(255)

update housing
set Owner_Address=parsename(replace(owneraddress,',','.'),3)

Alter table Housing 
add owner_city varchar(255)

update housing
set Owner_city=parsename(replace(owneraddress,',','.'),2)

Alter table Housing 
add Owner_state varchar(255)

update housing
set Owner_state=parsename(replace(owneraddress,',','.'),1)


---Change Y and N to Yes and No in Sold as vacant column


select distinct(soldasvacant) from housing

select soldasvacant, 
case
when soldasvacant='Y' then 'Yes'
When soldasvacant='N' then 'No'
end 
from housing
--where soldasvacant in ('Y','N')


update housing 
set soldasvacant=case
when soldasvacant='Y' then 'Yes' 
When soldasvacant='N' then 'No' 
end 
from housing

select soldasvacant,count(soldasvacant) 
from housing
group by soldasvacant
order by 2

--Remove Duplicates

select *, 
row_number() Over (partition by parcelid,propertyaddress,saledate,saleprice,legalreference order by parcelid) as row_num
from housing
order by uniqueid


with removedup as
(select *, 
row_number() Over (partition by parcelid,propertyaddress,saledate,saleprice,legalreference order by parcelid) as row_num
from housing)

select *from removedup
where row_num>1


with removedup as
(select *, 
row_number() Over (partition by parcelid,propertyaddress,saledate,saleprice,legalreference order by parcelid) as row_num
from housing)
delete from removedup
where row_num>1

----DELETE SOME UNUSED COLUMNS

SELECT * FROM HOUSING

ALTER TABLE HOUSING
DROP COLUMN SALEDATE,PROPERTYADDRESS,OWNERADDRESS,TAXDISTRICT