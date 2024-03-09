
--Standardize Date Format 
SELECT SaleDate , CAST(SaleDate AS DATE) AS converted_date
FROM [ProtfolioProject].[dbo].[Nashville Housing ]

SELECT SaleDate , CONVERt(DATE,SaleDate) AS converted_date
FROM [ProtfolioProject].[dbo].[Nashville Housing ]

--Adding New Column Called SaleDateConv
ALTER TABLE [ProtfolioProject].[dbo].[Nashville Housing ]
ADD SaleDateConv Date;

UPDATE [ProtfolioProject].[dbo].[Nashville Housing ]
SET SaleDateConv = CONVERt(DATE,SaleDate);

--Populate Property Address data
Select a.[UniqueID ] ,a.ParcelID, a.PropertyAddress,b.[UniqueID ], b.ParcelID, b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress) as PropertyAddressCon
From [ProtfolioProject].[dbo].[Nashville Housing ] a
JOIN [ProtfolioProject].[dbo].[Nashville Housing ] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is not null
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
From [ProtfolioProject].[dbo].[Nashville Housing ] a
JOIN [ProtfolioProject].[dbo].[Nashville Housing ] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null
--PropertyAddress Split(twocolumns)
select PropertyAddress , 
SUBSTRING(PropertyAddress,1 , CHARINDEX(',', PropertyAddress)-1) ,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress) ) 
From [ProtfolioProject].[dbo].[Nashville Housing ]

ALTER TABLE [ProtfolioProject].[dbo].[Nashville Housing ]
ADD PropertySplitAddress Nvarchar(255);

UPDATE [ProtfolioProject].[dbo].[Nashville Housing ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1 , CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE [ProtfolioProject].[dbo].[Nashville Housing ]
ADD  PropertySplitCity Nvarchar(255) ;

UPDATE [ProtfolioProject].[dbo].[Nashville Housing ]
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress) ) ;


--OwnerAddress Split(threecolumns)
select OwnerAddress ,
 PARSENAME( REPLACE(OwnerAddress , ',', '.'), 3) ,
 PARSENAME( REPLACE(OwnerAddress , ',', '.'), 2),
 PARSENAME( REPLACE(OwnerAddress , ',', '.'), 1)
from [ProtfolioProject].[dbo].[Nashville Housing ]

ALTER TABLE [ProtfolioProject].[dbo].[Nashville Housing ]
ADD OwnerAddressSplitAddress Nvarchar(255) ;

UPDATE [ProtfolioProject].[dbo].[Nashville Housing ]
SET OwnerAddressSplitAddress = PARSENAME( REPLACE(OwnerAddress , ',', '.'), 3);

ALTER TABLE [ProtfolioProject].[dbo].[Nashville Housing ]
ADD  OwnerAddressSplitCity Nvarchar(255) ;

UPDATE [ProtfolioProject].[dbo].[Nashville Housing ]
SET OwnerAddressSplitCity = PARSENAME( REPLACE(OwnerAddress , ',', '.'), 2);

ALTER TABLE [ProtfolioProject].[dbo].[Nashville Housing ]
ADD  OwnerAddressSplitState Nvarchar(255) ;

UPDATE [ProtfolioProject].[dbo].[Nashville Housing ]
SET OwnerAddressSplitState = PARSENAME( REPLACE(OwnerAddress , ',', '.'), 1) ;

select *  from [ProtfolioProject].[dbo].[Nashville Housing ]


---- Change Y and N to Yes and No in Sold as Vacant
select 
CASE
  WHEN Soldasvacant ='Y' THEN 'Yes'
  WHEN Soldasvacant ='N' THEN 'No'
  ELSE Soldasvacant
END
 from [ProtfolioProject].[dbo].[Nashville Housing ]

 UPDATE [ProtfolioProject].[dbo].[Nashville Housing ]
SET Soldasvacant = CASE
  WHEN Soldasvacant ='Y' THEN 'Yes'
  WHEN Soldasvacant ='N' THEN 'No'
  ELSE Soldasvacant
END
 from [ProtfolioProject].[dbo].[Nashville Housing ]

  --Removing Duplicates 
WITH DupData AS (
  Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
from [ProtfolioProject].[dbo].[Nashville Housing ]
)
Delete 
from DupData
Where row_num > 1

--Deleting Unused Columns
Select * from [ProtfolioProject].[dbo].[Nashville Housing ]
ALTER TABLE [ProtfolioProject].[dbo].[Nashville Housing ]
DROP COLUMN PropertyAddress ,OwnerAddress ;


