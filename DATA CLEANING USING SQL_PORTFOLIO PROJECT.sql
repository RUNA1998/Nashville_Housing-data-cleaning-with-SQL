----cleaning data in sql queries

select * 
from Portfolio_project..Nashville_Housing

----standarize data format
select saledateconverted,convert(date,saledate)
from Portfolio_project..Nashville_Housing

update Portfolio_project..Nashville_Housing
set saledate=convert(date,saledate)

alter table Portfolio_project..Nashville_Housing
add saledateconverted date;

update Portfolio_project..Nashville_Housing
set saledateconverted =convert (date,saledate);

---populate property address data

select *
from Portfolio_project..Nashville_Housing
--where PropertyAddress is null;
order by ParcelID;

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.propertyaddress,b.PropertyAddress)
from Portfolio_project..Nashville_Housing a
join Portfolio_project..Nashville_Housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

update a
set  PropertyAddress=isnull(a.propertyaddress,b.PropertyAddress)
from Portfolio_project..Nashville_Housing a
join Portfolio_project..Nashville_Housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


---breaking out address into individual columns (address,city,state)

select PropertyAddress
from Portfolio_project..Nashville_Housing
--where PropertyAddress is null;
--order by ParcelID;

select 
SUBSTRING (propertyaddress,1,charindex(',',propertyaddress)-1) as address
,SUBSTRING (propertyaddress,charindex(',',propertyaddress)+1 ,len(propertyaddress)) as address
from Portfolio_project..Nashville_Housing;

alter table Portfolio_project..Nashville_Housing
add propertysplitaddress nvarchar(255);

update Portfolio_project..Nashville_Housing
set propertysplitaddress =SUBSTRING (propertyaddress,1,charindex(',',propertyaddress)-1);

alter table Portfolio_project..Nashville_Housing
add  propertysplitcity nvarchar(255);

update Portfolio_project..Nashville_Housing
set  propertysplitaddress=SUBSTRING (propertyaddress,charindex(',',propertyaddress)+1 ,len(propertyaddress))


select *
from Portfolio_project..Nashville_Housing

select OwnerAddress
from Portfolio_project..Nashville_Housing

select 
PARSENAME(replace(owneraddress,',','.'),3)
,PARSENAME(replace(owneraddress,',','.'),2)
,PARSENAME(replace(owneraddress,',','.'),1)
from Portfolio_project..Nashville_Housing;

alter table Portfolio_project..Nashville_Housing
add ownersplitaddress nvarchar(255);

update Portfolio_project..Nashville_Housing
set ownersplitaddress =PARSENAME(replace(owneraddress,',','.'),3)

alter table Portfolio_project..Nashville_Housing
add  ownersplitcity nvarchar(255);

update Portfolio_project..Nashville_Housing
set  ownersplitcity=PARSENAME(replace(owneraddress,',','.'),2)

alter table Portfolio_project..Nashville_Housing
add  ownersplitstate nvarchar(255);

update Portfolio_project..Nashville_Housing
set ownersplitstate =PARSENAME(replace(owneraddress,',','.'),1)

select * 
from Portfolio_project..Nashville_Housing


---change y and N to yes and no in "sold as vacant" field


select distinct(SoldAsVacant) ,count (SoldAsVacant)
from Portfolio_project..Nashville_Housing
group by SoldAsVacant
order by SoldAsVacant;

select SoldAsVacant
,case when SoldAsVacant = 'y' then  'yes'
      when SoldAsVacant= 'n' then 'no'
	  else SoldAsVacant
	  end
from Portfolio_project..Nashville_Housing


update Portfolio_project..Nashville_Housing
set SoldAsVacant=case when SoldAsVacant = 'y' then  'yes'
      when SoldAsVacant= 'n' then 'no'
	  else SoldAsVacant
	  end;



 ----remove duplicates
 with rownumCTE AS (
select *,
ROW_NUMBER()over(
partition by parcelid,
             propertyaddress,
			 saleprice,
			 saledate,
			 legalreference
			 order by 
			 uniqueid
			 )row_num
from Portfolio_project..Nashville_Housing
--order by ParcelID
)
DELETE
FROM rownumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


----DELETE UNUSED COLUMNS

SELECT *
FROM Portfolio_project..Nashville_Housing

ALTER TABLE Portfolio_project..Nashville_Housing
DROP COLUMN OWNERADDRESS,TAXDISTRICT,PROPERTYADDRESS;

ALTER TABLE Portfolio_project..Nashville_Housing
DROP COLUMN SALEDATE;

---------------------------------