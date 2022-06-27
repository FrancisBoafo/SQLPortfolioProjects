-- Cleaning Data in SQL Quuries

select *
from PortfolioProject..NashvilleHousing

-- Standardize Date Format

select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
Set SaleDate = CONVERT(Date,SaleDate)

ALter table NashvilleHousing 
add SaleDateConverted Date;

update NashvilleHousing
SET SaleDateConverted = Convert(date,saledate)

--Populate Property Address Data

select *
from PortfolioProject..NashvilleHousing
where PropertyAddress is null 
order by ParcelID

select  a.ParcelID, a.PropertyAddress, b. ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOin PortfolioProject..NashvilleHousing b
		on a.ParcelID = b.ParcelID
		AnD a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a 
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOin PortfolioProject..NashvilleHousing b
		on a.ParcelID = b.ParcelID
		AnD a.[UniqueID ] <> b.[UniqueID ]

-- Breaking out Address into Individual Column (Address, City, State)

Select PropertyAddress
from PortfolioProject..NashvilleHousing


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing


ALter table NashvilleHousing 
add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

ALter table NashvilleHousing 
add PropertySplitCity Nvarchar(255);

update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select * 
from PortfolioProject..NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', ',') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',', ',') , 2)
, PARSENAME(REPLACE(OwnerAddress, ',', ',') , 1)
from PortfolioProject.dbo.NashvilleHousing

ALter table NashvilleHousing 
add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 3)

ALter table NashvilleHousing 
add OwnerSplitCity Nvarchar(255);

update NashvilleHousing
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', ',') , 2)

ALter table NashvilleHousing 
add OwnerSplitState Nvarchar(255);

update NashvilleHousing
SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', ',') , 1)



-- Change Y and N to Yes and No on "Solid as Vacant" field

Select Distinct(soldAsvacant), COUNT(SoldAsVacant) 
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by SoldAsVacant

Select SoldAsVacant 
, Case when soldasvacant = 'Y' THEN 'Yes' 
		when SoldASVacant = 'N' THEN 'No'
		ELSE SoldAsVacant 
		END 
from PortfolioProject..NashvilleHousing

update NashvilleHousing
SET SoldAsVacant = Case when soldasvacant = 'Y' THEN 'Yes' 
		when SoldASVacant = 'N' THEN 'No'
		ELSE SoldAsVacant 
		END 

-- Remove Duplicates 

With RowNumCTE As(
Select *,
		ROW_NUMBER() OvER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 Order by 
						UniqueID
						) row_num
					 
from PortfolioProject..NashvilleHousing
--Order by ParcelID
)

Select *
from RowNumCTE
where row_num > 1
Order By PropertyAddress


-- Delete Unused Columns

Alter Table PortfolioProject.dbo.Nashville 
Drop Column OwnerAddress, TaxDistrict, ProperAddress

Alter Table PortfolioProject.dbo.Nashville 
Drop Column SaleDate

