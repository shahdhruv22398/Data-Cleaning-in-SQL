select * 
from PortfolioProject.dbo.NashvilleHousing

-- Standardize date format

select SaleDateConverted
from PortfolioProject.dbo.NashvilleHousing;

alter table NashvilleHousing
add SaleDateConverted DATE;

update NashvilleHousing
set SaleDateConverted = convert(date, SaleDate);

-- Populate property address data

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID and
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

update a
set propertyaddress = isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID and
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

-- Breaking out addresses into different individual columns (Address, city, state)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing;

select 
propertyaddress,
substring(propertyaddress, 1, charindex(',', propertyaddress)-1) as address,
substring(propertyaddress, charindex(',', propertyaddress)+1, len(propertyaddress))
from PortfolioProject.dbo.NashvilleHousing;

alter table NashvilleHousing
add PropertySplitAddress NVARCHAR(255);

update NashvilleHousing
set PropertySplitAddress = substring(propertyaddress, 1, charindex(',', propertyaddress)-1) 
from PortfolioProject.dbo.NashvilleHousing;

alter table NashvilleHousing
add PropertySplitCity NVARCHAR(255);

update NashvilleHousing
set PropertySplitCity = substring(propertyaddress, charindex(',', propertyaddress)+1, len(propertyaddress))
from PortfolioProject.dbo.NashvilleHousing;

select PropertyAddress, PropertySplitAddress, PropertySplitCity
from PortfolioProject.dbo.NashvilleHousing;


select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing;

select parsename(replace(OwnerAddress, ',', '.'),1)
from PortfolioProject.dbo.NashvilleHousing;


select
OwnerAddress,
parsename(replace(OwnerAddress, ',', '.'),3),
parsename(replace(OwnerAddress, ',', '.'),2),
parsename(replace(OwnerAddress, ',', '.'),1)
from PortfolioProject.dbo.NashvilleHousing;

alter table NashvilleHousing
add OwnerSplitAddress NVARCHAR(255);

update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'),3)
from PortfolioProject.dbo.NashvilleHousing;

select OwnerSplitAddress
from PortfolioProject.dbo.NashvilleHousing;

alter table NashvilleHousing
add OwnerSplitCity NVARCHAR(255);

update NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'),2)
from PortfolioProject.dbo.NashvilleHousing;


alter table NashvilleHousing
add OwnerSplitState NVARCHAR(255);

update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'),1)
from PortfolioProject.dbo.NashvilleHousing;


-- Change Y and N to Yes and No in "Sold as vacant" field

select distinct(soldasvacant), count(soldasvacant)
from NashvilleHousing
group by soldasvacant
order by 2;

select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else SoldAsVacant end
from NashvilleHousing;

update NashvilleHousing
set soldasvacant = 
case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else SoldAsVacant end
from NashvilleHousing;


-- Remove Duplicates

with row_num_cte as(
select *,
	ROW_NUMBER() OVER(
	partition by parcelid,
	propertyaddress,
	saleprice,
	saledate,
	legalreference
	order by 
	uniqueid) row_num
from PortfolioProject.dbo.NashvilleHousing
-- order by row_num;
)
DELETE  
from row_num_cte
where row_num > 1
-- order by PropertyAddress;

with row_num_cte as(
select *,
	ROW_NUMBER() OVER(
	partition by parcelid,
	propertyaddress,
	saleprice,
	saledate,
	legalreference
	order by 
	uniqueid) row_num
from PortfolioProject.dbo.NashvilleHousing
-- order by row_num;
)
select *  
from row_num_cte
where row_num > 1
-- order by PropertyAddress;

select *
from PortfolioProject.dbo.NashvilleHousing;

-- Delete unused columns

select *
from PortfolioProject.dbo.NashvilleHousing;

alter table PortfolioProject.dbo.NashvilleHousing
drop column 
owneraddress, taxdistrict, propertyaddress;

alter table PortfolioProject.dbo.NashvilleHousing
drop column 
saledate;