--Nashville Housing data cleaning for data analysis
--Converting the SalesDate format  from date time to date 
SELECT SaleDate, CONVERT(Date,SaleDate)
FROM PortfolioProject.dbo.Nashvillehousingdata

--UPDATE Nashvillehousingdata
--SET SaleDate= CONVERT(Date,SaleDate)

ALTER TABLE Nashvillehousingdata
ADD SaleDateconverted Date;

UPDATE Nashvillehousingdata
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateconverted
FROM PortfolioProject.dbo.Nashvillehousingdata
 
ALTER TABLE Nashvillehousingdata
DROP COLUMN Saledate

----Cleaning  the Address column as a result of NULL values in the data 
--joining the table to itself inorder to populate address in the null spaces
 
 SELECT a.ParcelID,a.PropertyAddress, b.ParcelID, b.propertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM PortfolioProject.dbo.Nashvillehousingdata a
 JOIN PortfolioProject.dbo.Nashvillehousingdata b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]

UPDATE a
SET propertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.Nashvillehousingdata a
 JOIN PortfolioProject.dbo.Nashvillehousingdata b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ]<> b.[UniqueID ]
 WHERE A.PropertyAddress IS Null

--Checking if the Update  has been done effectively 

SELECT a.ParcelID,a.PropertyAddress, b.ParcelID, b.propertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM PortfolioProject.dbo.Nashvillehousingdata a
 JOIN PortfolioProject.dbo.Nashvillehousingdata b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE A.PropertyAddress IS Null

--Breaking the Address into  City , Address, State
--SELECT 
--SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
--SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))AS Address
--FROM PortfolioProject.dbo.Nashvillehousingdata

ALTER TABLE Nashvillehousingdata
ADD PropertysplitAddress Nvarchar(255);

UPDATE Nashvillehousingdata
SET PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Nashvillehousingdata
ADD City Nvarchar(255);

UPDATE Nashvillehousingdata
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

Select *
FROM PortfolioProject.dbo.Nashvillehousingdata

--The owner address needs to be splited into  state, city and Address to achive this 
--perse function was used

SELECT
PARSENAME(REPLACE(OwnerAddress, ',' ,'.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',' ,'.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',' ,'.') , 1)
FROM Portfolioproject.dbo.nashvillehousingdata

ALTER TABLE Nashvillehousingdata
ADD OwnersplitAddress NVARCHAR(255);

UPDATE Nashvillehousingdata
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Nashvillehousingdata
ADD OwnersplitCity NVARCHAR(255);

UPDATE Nashvillehousingdata
SET OwnersplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


ALTER TABLE Nashvillehousingdata
ADD Ownersplitstate NVARCHAR(255)

UPDATE Nashvillehousingdata
SET Ownersplitstate= PARSENAME(REPLACE(OwnerAddress,',','.'),1)
 
SELECT*
FROM Nashvillehousingdata

--in the soldasvacant column there are some inconsistencies in the data  
SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
From PortfolioProject.dbo.Nashvillehousingdata
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
		 WHEN SoldAsVacant = 'N' THEN 'NO'
		 ElSE SoldAsVacant
		 END
 FROM PortfolioProject.dbo.Nashvillehousingdata

 UPDATE Nashvillehousingdata
 SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
		 WHEN SoldAsVacant = 'N' THEN 'NO'
		 ElSE SoldAsVacant
		 END

SELECT  DISTINCT SoldAsVacant, COUNT(SoldASvacant)
FROM PortfolioProject.dbo.Nashvillehousingdata
GROUP BY  SoldAsVacant

--Removing Duplicates in the data 

 With RowNumCTE AS(
 SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
				 UniqueID
				 ) row_num
FROM PortfolioProject.dbo.Nashvillehousingdata
--Order by ParcelID
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

--Deleting unused column  from the data

Select*
FROM PortfolioProject.dbo.Nashvillehousingdata

ALTER TABLE Nashvillehousingdata
DROP COLUMN ownerAddress,Taxdistrict,PropertyAddress