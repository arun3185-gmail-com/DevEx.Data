﻿
USE [AdventureWorks]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*** SCHEMA ***/

CREATE SCHEMA [SalesLT] AUTHORIZATION [dbo];
GO



/*** TYPE ***/

CREATE TYPE [dbo].[Name] FROM NVARCHAR (50) NULL;
GO

CREATE TYPE [dbo].[NameStyle] FROM BIT NOT NULL;
GO

CREATE TYPE [dbo].[Phone] FROM NVARCHAR (25) NULL;
GO

CREATE TYPE [dbo].[Flag] FROM BIT NOT NULL;
GO

CREATE TYPE [dbo].[AccountNumber] FROM NVARCHAR (15) NULL;
GO

CREATE TYPE [dbo].[OrderNumber] FROM NVARCHAR (25) NULL;
GO



/*** TABLE ***/

CREATE TABLE [dbo].[BuildVersion]
(
    [SystemInformationID] TINYINT       IDENTITY (1, 1) NOT NULL,
    [Database Version]    NVARCHAR (25) NOT NULL,
    [VersionDate]         DATETIME      NOT NULL,
    [ModifiedDate]        DATETIME      NOT NULL
);
GO

CREATE TABLE [dbo].[ErrorLog]
(
    [ErrorLogID]     INT             IDENTITY (1, 1) NOT NULL,
    [ErrorTime]      DATETIME        NOT NULL,
    [UserName]       [sysname]       NOT NULL,
    [ErrorNumber]    INT             NOT NULL,
    [ErrorSeverity]  INT             NULL,
    [ErrorState]     INT             NULL,
    [ErrorProcedure] NVARCHAR (126)  NULL,
    [ErrorLine]      INT             NULL,
    [ErrorMessage]   NVARCHAR (4000) NOT NULL
);
GO


CREATE TABLE [SalesLT].[Customer]
(
    [CustomerID]   INT               IDENTITY (1, 1) NOT NULL,
    [NameStyle]    [dbo].[NameStyle] NOT NULL,
    [Title]        NVARCHAR (8)      NULL,
    [FirstName]    [dbo].[Name]      NOT NULL,
    [MiddleName]   [dbo].[Name]      NULL,
    [LastName]     [dbo].[Name]      NOT NULL,
    [Suffix]       NVARCHAR (10)     NULL,
    [CompanyName]  NVARCHAR (128)    NULL,
    [SalesPerson]  NVARCHAR (256)    NULL,
    [EmailAddress] NVARCHAR (50)     NULL,
    [Phone]        [dbo].[Phone]     NULL,
    [PasswordHash] VARCHAR (128)     NOT NULL,
    [PasswordSalt] VARCHAR (10)      NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER  NOT NULL,
    [ModifiedDate] DATETIME          NOT NULL
);
GO

CREATE NONCLUSTERED INDEX [IX_Customer_EmailAddress] ON [SalesLT].[Customer]([EmailAddress] ASC);
GO

ALTER TABLE [SalesLT].[Customer] ADD CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED ([CustomerID] ASC);
GO
ALTER TABLE [SalesLT].[Customer] ADD CONSTRAINT [AK_Customer_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC);
GO
ALTER TABLE [SalesLT].[Customer] ADD CONSTRAINT [DF_Customer_NameStyle] DEFAULT ((0)) FOR [NameStyle];
GO
ALTER TABLE [SalesLT].[Customer] ADD CONSTRAINT [DF_Customer_rowguid] DEFAULT (newid()) FOR [rowguid];
GO
ALTER TABLE [SalesLT].[Customer] ADD CONSTRAINT [DF_Customer_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];
GO


CREATE TABLE [SalesLT].[Address]
(
    [AddressID]     INT              IDENTITY (1, 1) NOT NULL,
    [AddressLine1]  NVARCHAR (60)    NOT NULL,
    [AddressLine2]  NVARCHAR (60)    NULL,
    [City]          NVARCHAR (30)    NOT NULL,
    [StateProvince] [dbo].[Name]     NOT NULL,
    [CountryRegion] [dbo].[Name]     NOT NULL,
    [PostalCode]    NVARCHAR (15)    NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]  DATETIME         NOT NULL
);
GO

CREATE NONCLUSTERED INDEX [IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion] ON [SalesLT].[Address]([AddressLine1] ASC, [AddressLine2] ASC, [City] ASC, [StateProvince] ASC, [PostalCode] ASC, [CountryRegion] ASC);
GO
CREATE NONCLUSTERED INDEX [IX_Address_StateProvince] ON [SalesLT].[Address]([StateProvince] ASC);
GO

ALTER TABLE [SalesLT].[Address] ADD CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED ([AddressID] ASC);
GO
ALTER TABLE [SalesLT].[Address] ADD CONSTRAINT [AK_Address_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC);
GO
ALTER TABLE [SalesLT].[Address] ADD CONSTRAINT [DF_Address_rowguid] DEFAULT (newid()) FOR [rowguid];
GO
ALTER TABLE [SalesLT].[Address] ADD CONSTRAINT [DF_Address_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];
GO


CREATE TABLE [SalesLT].[CustomerAddress]
(
    [CustomerID]   INT              NOT NULL,
    [AddressID]    INT              NOT NULL,
    [AddressType]  [dbo].[Name]     NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate] DATETIME         NOT NULL
);
GO


CREATE TABLE [SalesLT].[ProductCategory]
(
    [ProductCategoryID]       INT              IDENTITY (1, 1) NOT NULL,
    [ParentProductCategoryID] INT              NULL,
    [Name]                    [dbo].[Name]     NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]            DATETIME         NOT NULL
);
GO


CREATE TABLE [SalesLT].[ProductModel]
(
    [ProductModelID]     INT              IDENTITY (1, 1) NOT NULL,
    [Name]               [dbo].[Name]     NOT NULL,
    [CatalogDescription] XML              NULL,
    [rowguid]            UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]       DATETIME         NOT NULL
);
GO


CREATE TABLE [SalesLT].[ProductDescription]
(
    [ProductDescriptionID] INT              IDENTITY (1, 1) NOT NULL,
    [Description]          NVARCHAR (400)   NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]         DATETIME         NOT NULL
);
GO


CREATE TABLE [SalesLT].[Product]
(
    [ProductID]              INT              IDENTITY (1, 1) NOT NULL,
    [Name]                   [dbo].[Name]     NOT NULL,
    [ProductNumber]          NVARCHAR (25)    NOT NULL,
    [Color]                  NVARCHAR (15)    NULL,
    [StandardCost]           MONEY            NOT NULL,
    [ListPrice]              MONEY            NOT NULL,
    [Size]                   NVARCHAR (5)     NULL,
    [Weight]                 DECIMAL (8, 2)   NULL,
    [ProductCategoryID]      INT              NULL,
    [ProductModelID]         INT              NULL,
    [SellStartDate]          DATETIME         NOT NULL,
    [SellEndDate]            DATETIME         NULL,
    [DiscontinuedDate]       DATETIME         NULL,
    [ThumbNailPhoto]         VARBINARY (MAX)  NULL,
    [ThumbnailPhotoFileName] NVARCHAR (50)    NULL,
    [rowguid]                UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]           DATETIME         NOT NULL
);
GO


CREATE TABLE [SalesLT].[ProductModelProductDescription]
(
    [ProductModelID]       INT              NOT NULL,
    [ProductDescriptionID] INT              NOT NULL,
    [Culture]              NCHAR (6)        NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]         DATETIME         NOT NULL
);
GO


CREATE TABLE [SalesLT].[SalesOrderHeader]
(
    [SalesOrderID]           INT                   NOT NULL,
    [RevisionNumber]         TINYINT               NOT NULL,
    [OrderDate]              DATETIME              NOT NULL,
    [DueDate]                DATETIME              NOT NULL,
    [ShipDate]               DATETIME              NULL,
    [Status]                 TINYINT               NOT NULL,
    [OnlineOrderFlag]        [dbo].[Flag]          NOT NULL,
    [SalesOrderNumber]       AS                    (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID],(0)),N'*** ERROR ***')),
    [PurchaseOrderNumber]    [dbo].[OrderNumber]   NULL,
    [AccountNumber]          [dbo].[AccountNumber] NULL,
    [CustomerID]             INT                   NOT NULL,
    [ShipToAddressID]        INT                   NULL,
    [BillToAddressID]        INT                   NULL,
    [ShipMethod]             NVARCHAR (50)         NOT NULL,
    [CreditCardApprovalCode] VARCHAR (15)          NULL,
    [SubTotal]               MONEY                 NOT NULL,
    [TaxAmt]                 MONEY                 NOT NULL,
    [Freight]                MONEY                 NOT NULL,
    [TotalDue]               AS                    (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
    [Comment]                NVARCHAR (MAX)        NULL,
    [rowguid]                UNIQUEIDENTIFIER      NOT NULL,
    [ModifiedDate]           DATETIME              NOT NULL
);
GO

CREATE NONCLUSTERED INDEX [IX_SalesOrderHeader_CustomerID] ON [SalesLT].[SalesOrderHeader]([CustomerID] ASC);
GO

ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [PK_SalesOrderHeader_SalesOrderID] PRIMARY KEY CLUSTERED ([SalesOrderID] ASC);
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [AK_SalesOrderHeader_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC);
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [AK_SalesOrderHeader_SalesOrderNumber] UNIQUE NONCLUSTERED ([SalesOrderNumber] ASC);
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [FK_SalesOrderHeader_Address_BillTo_AddressID] FOREIGN KEY ([BillToAddressID]) REFERENCES [SalesLT].[Address] ([AddressID]);
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [FK_SalesOrderHeader_Address_ShipTo_AddressID] FOREIGN KEY ([ShipToAddressID]) REFERENCES [SalesLT].[Address] ([AddressID]);
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID] FOREIGN KEY ([CustomerID]) REFERENCES [SalesLT].[Customer] ([CustomerID]);
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [DF_SalesOrderHeader_OrderID] DEFAULT (NEXT VALUE FOR [SalesLT].[SalesOrderNumber]) FOR [SalesOrderID];
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [DF_SalesOrderHeader_RevisionNumber] DEFAULT ((0)) FOR [RevisionNumber];
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [DF_SalesOrderHeader_OrderDate] DEFAULT (getdate()) FOR [OrderDate];
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [DF_SalesOrderHeader_Status] DEFAULT ((1)) FOR [Status];
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [DF_SalesOrderHeader_OnlineOrderFlag] DEFAULT ((1)) FOR [OnlineOrderFlag];
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [DF_SalesOrderHeader_SubTotal] DEFAULT ((0.00)) FOR [SubTotal];
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [DF_SalesOrderHeader_TaxAmt] DEFAULT ((0.00)) FOR [TaxAmt];
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [DF_SalesOrderHeader_Freight] DEFAULT ((0.00)) FOR [Freight];
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [DF_SalesOrderHeader_rowguid] DEFAULT (newid()) FOR [rowguid];
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [DF_SalesOrderHeader_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_DueDate] CHECK ([DueDate]>=[OrderDate]);
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_Freight] CHECK ([Freight]>=(0.00));
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_ShipDate] CHECK ([ShipDate]>=[OrderDate] OR [ShipDate] IS NULL);
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_Status] CHECK ([Status]>=(0) AND [Status]<=(8));
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_SubTotal] CHECK ([SubTotal]>=(0.00));
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_TaxAmt] CHECK ([TaxAmt]>=(0.00));
GO


CREATE TABLE [SalesLT].[SalesOrderDetail]
(
    [SalesOrderID]       INT              NOT NULL,
    [SalesOrderDetailID] INT              IDENTITY (1, 1) NOT NULL,
    [OrderQty]           SMALLINT         NOT NULL,
    [ProductID]          INT              NOT NULL,
    [UnitPrice]          MONEY            NOT NULL,
    [UnitPriceDiscount]  MONEY            NOT NULL,
    [LineTotal]          AS               (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))),
    [rowguid]            UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]       DATETIME         NOT NULL
);
GO

CREATE NONCLUSTERED INDEX [IX_SalesOrderDetail_ProductID] ON [SalesLT].[SalesOrderDetail]([ProductID] ASC);
GO

ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID] PRIMARY KEY CLUSTERED ([SalesOrderID] ASC, [SalesOrderDetailID] ASC);
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [AK_SalesOrderDetail_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC);
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [FK_SalesOrderDetail_Product_ProductID] FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID]);
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID] FOREIGN KEY ([SalesOrderID]) REFERENCES [SalesLT].[SalesOrderHeader] ([SalesOrderID]) ON DELETE CASCADE;
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [DF_SalesOrderDetail_UnitPriceDiscount] DEFAULT ((0.0)) FOR [UnitPriceDiscount];
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [DF_SalesOrderDetail_rowguid] DEFAULT (newid()) FOR [rowguid];
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [DF_SalesOrderDetail_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [CK_SalesOrderDetail_OrderQty] CHECK ([OrderQty]>(0));
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [CK_SalesOrderDetail_UnitPrice] CHECK ([UnitPrice]>=(0.00));
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount] CHECK ([UnitPriceDiscount]>=(0.00));
GO



/*** SEQUENCE ***/

CREATE SEQUENCE [SalesLT].[SalesOrderNumber]
    AS INT
    START WITH 1
    INCREMENT BY 1;
GO



/*** VIEW ***/

CREATE VIEW [SalesLT].[vGetAllCategories]
WITH SCHEMABINDING
AS
	-- Returns the CustomerID, first name, and last name for the specified customer.
	WITH CategoryCTE([ParentProductCategoryID], [ProductCategoryID], [Name]) AS
	(
		SELECT [ParentProductCategoryID], [ProductCategoryID], [Name]
		FROM SalesLT.ProductCategory
		WHERE ParentProductCategoryID IS NULL

	UNION ALL

		SELECT C.[ParentProductCategoryID], C.[ProductCategoryID], C.[Name]
		FROM SalesLT.ProductCategory AS C
		INNER JOIN CategoryCTE AS BC ON BC.ProductCategoryID = C.ParentProductCategoryID
	)

	SELECT PC.[Name] AS [ParentProductCategoryName], CCTE.[Name] as [ProductCategoryName], CCTE.[ProductCategoryID]
	  FROM CategoryCTE AS CCTE
	  JOIN SalesLT.ProductCategory AS PC ON PC.[ProductCategoryID] = CCTE.[ParentProductCategoryID]
GO


CREATE VIEW [SalesLT].[vProductAndDescription]
WITH SCHEMABINDING
AS
	-- View (indexed or standard) to display products and product descriptions by language.
	SELECT
		p.[ProductID]
	   ,p.[Name]
	   ,pm.[Name] AS [ProductModel]
	   ,pmx.[Culture]
	   ,pd.[Description]
	  FROM [SalesLT].[Product] p
	  INNER JOIN [SalesLT].[ProductModel] pm ON p.[ProductModelID] = pm.[ProductModelID]
	  INNER JOIN [SalesLT].[ProductModelProductDescription] pmx ON pm.[ProductModelID] = pmx.[ProductModelID]
	  INNER JOIN [SalesLT].[ProductDescription] pd ON pmx.[ProductDescriptionID] = pd.[ProductDescriptionID];
GO


CREATE VIEW [SalesLT].[vProductModelCatalogDescription]
AS
	SELECT
		[ProductModelID]
	   ,[Name]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   declare namespace html="http://www.w3.org/1999/xhtml";
		   (/p1:ProductDescription/p1:Summary/html:p)[1]', 'nvarchar(max)') AS [Summary]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   (/p1:ProductDescription/p1:Manufacturer/p1:Name)[1]', 'nvarchar(max)') AS [Manufacturer]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   (/p1:ProductDescription/p1:Manufacturer/p1:Copyright)[1]', 'nvarchar(30)') AS [Copyright]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   (/p1:ProductDescription/p1:Manufacturer/p1:ProductURL)[1]', 'nvarchar(256)') AS [ProductURL]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain";
		   (/p1:ProductDescription/p1:Features/wm:Warranty/wm:WarrantyPeriod)[1]', 'nvarchar(256)') AS [WarrantyPeriod]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain";
		   (/p1:ProductDescription/p1:Features/wm:Warranty/wm:Description)[1]', 'nvarchar(256)') AS [WarrantyDescription]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain";
		   (/p1:ProductDescription/p1:Features/wm:Maintenance/wm:NoOfYears)[1]', 'nvarchar(256)') AS [NoOfYears]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain";
		   (/p1:ProductDescription/p1:Features/wm:Maintenance/wm:Description)[1]', 'nvarchar(256)') AS [MaintenanceDescription]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures";
		   (/p1:ProductDescription/p1:Features/wf:wheel)[1]', 'nvarchar(256)') AS [Wheel]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures";
		   (/p1:ProductDescription/p1:Features/wf:saddle)[1]', 'nvarchar(256)') AS [Saddle]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures";
		   (/p1:ProductDescription/p1:Features/wf:pedal)[1]', 'nvarchar(256)') AS [Pedal]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures";
		   (/p1:ProductDescription/p1:Features/wf:BikeFrame)[1]', 'nvarchar(max)') AS [BikeFrame]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures";
		   (/p1:ProductDescription/p1:Features/wf:crankset)[1]', 'nvarchar(256)') AS [Crankset]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   (/p1:ProductDescription/p1:Picture/p1:Angle)[1]', 'nvarchar(256)') AS [PictureAngle]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   (/p1:ProductDescription/p1:Picture/p1:Size)[1]', 'nvarchar(256)') AS [PictureSize]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   (/p1:ProductDescription/p1:Picture/p1:ProductPhotoID)[1]', 'nvarchar(256)') AS [ProductPhotoID]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   (/p1:ProductDescription/p1:Specifications/Material)[1]', 'nvarchar(256)') AS [Material]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   (/p1:ProductDescription/p1:Specifications/Color)[1]', 'nvarchar(256)') AS [Color]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   (/p1:ProductDescription/p1:Specifications/ProductLine)[1]', 'nvarchar(256)') AS [ProductLine]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   (/p1:ProductDescription/p1:Specifications/Style)[1]', 'nvarchar(256)') AS [Style]
	   ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
		   (/p1:ProductDescription/p1:Specifications/RiderExperience)[1]', 'nvarchar(1024)') AS [RiderExperience]
	   ,[rowguid]
	   ,[ModifiedDate]
	  FROM [SalesLT].[ProductModel]
	 WHERE [CatalogDescription] IS NOT NULL;
GO



/*** PROCEDURE ***/

-- uspLogError logs error information in the ErrorLog table about the
-- error that caused execution to jump to the CATCH block of a
-- TRY...CATCH construct. This should be executed from within the scope
-- of a CATCH block otherwise it will return without inserting error
-- information.
CREATE PROCEDURE [dbo].[uspLogError]
    @ErrorLogID int = 0 OUTPUT -- contains the ErrorLogID of the row inserted
AS                             -- by uspLogError in the ErrorLog table
BEGIN
    SET NOCOUNT ON;

    -- Output parameter value of 0 indicates that error
    -- information was not logged
    SET @ErrorLogID = 0;

    BEGIN TRY
        -- Return if there is no error information to log
        IF ERROR_NUMBER() IS NULL
            RETURN;

        -- Return if inside an uncommittable transaction.
        -- Data insertion/modification is not allowed when
        -- a transaction is in an uncommittable state.
        IF XACT_STATE() = -1
        BEGIN
            PRINT 'Cannot log error since the current transaction is in an uncommittable state. '
                + 'Rollback the transaction before executing uspLogError in order to successfully log error information.';
            RETURN;
        END

        INSERT [dbo].[ErrorLog]
            (
            [UserName],
            [ErrorNumber],
            [ErrorSeverity],
            [ErrorState],
            [ErrorProcedure],
            [ErrorLine],
            [ErrorMessage]
            )
        VALUES
            (
            CONVERT(sysname, CURRENT_USER),
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_MESSAGE()
            );

        -- Pass back the ErrorLogID of the row inserted
        SET @ErrorLogID = @@IDENTITY;
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred in stored procedure uspLogError: ';
        EXECUTE [dbo].[uspPrintError];
        RETURN -1;
    END CATCH
END;
GO


-- uspPrintError prints error information about the error that caused
-- execution to jump to the CATCH block of a TRY...CATCH construct.
-- Should be executed from within the scope of a CATCH block otherwise
-- it will return without printing any error information.
CREATE PROCEDURE [dbo].[uspPrintError]
AS
BEGIN
    SET NOCOUNT ON;

    -- Print error information.
    PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) +
          ', Severity ' + CONVERT(varchar(5), ERROR_SEVERITY()) +
          ', State ' + CONVERT(varchar(5), ERROR_STATE()) +
          ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') +
          ', Line ' + CONVERT(varchar(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END;
GO



/*** FUNCTION ***/

CREATE FUNCTION [dbo].[ufnGetSalesOrderStatusText](@Status tinyint)
RETURNS nvarchar(15)
AS
-- Returns the sales order status text representation for the status value.
BEGIN
    DECLARE @ret nvarchar(15);

    SET @ret =
        CASE @Status
            WHEN 1 THEN 'In process'
            WHEN 2 THEN 'Approved'
            WHEN 3 THEN 'Backordered'
            WHEN 4 THEN 'Rejected'
            WHEN 5 THEN 'Shipped'
            WHEN 6 THEN 'Cancelled'
            ELSE '** Invalid **'
        END;

    RETURN @ret
END;
GO


CREATE FUNCTION [dbo].[ufnGetCustomerInformation](@CustomerID int)
RETURNS TABLE
AS
-- Returns the CustomerID, first name, and last name for the specified customer.
RETURN (
    SELECT
        CustomerID,
        FirstName,
        LastName
    FROM [SalesLT].[Customer]
    WHERE [CustomerID] = @CustomerID
);
GO


CREATE FUNCTION [dbo].[ufnGetAllCategories]()
RETURNS @retCategoryInformation TABLE
(
    -- Columns returned by the function
    [ParentProductCategoryName] nvarchar(50) NULL,
    [ProductCategoryName] nvarchar(50) NOT NULL,
    [ProductCategoryID] int NOT NULL
)
AS
-- Returns the CustomerID, first name, and last name for the specified customer.
BEGIN

    WITH CategoryCTE([ParentProductCategoryID], [ProductCategoryID], [Name]) AS
    (
        SELECT [ParentProductCategoryID], [ProductCategoryID], [Name]
        FROM SalesLT.ProductCategory
        WHERE ParentProductCategoryID IS NULL

    UNION ALL

        SELECT C.[ParentProductCategoryID], C.[ProductCategoryID], C.[Name]
        FROM SalesLT.ProductCategory AS C
        INNER JOIN CategoryCTE AS BC ON BC.ProductCategoryID = C.ParentProductCategoryID
    )

    INSERT INTO @retCategoryInformation
    SELECT PC.[Name] AS [ParentProductCategoryName], CCTE.[Name] as [ProductCategoryName], CCTE.[ProductCategoryID]
      FROM CategoryCTE AS CCTE
      JOIN SalesLT.ProductCategory AS PC ON PC.[ProductCategoryID] = CCTE.[ParentProductCategoryID];
    RETURN;

END;
GO


/******************************************************************************/
/*

SELECT [CustomerID],[NameStyle],[Title],[FirstName],[MiddleName],[LastName],[Suffix],[CompanyName],[SalesPerson],[EmailAddress],[Phone],[PasswordHash],[PasswordSalt],[ModifiedDate]
  FROM [SalesLT].[Customer]

SELECT [AddressID],[AddressLine1],[AddressLine2],[City],[StateProvince],[CountryRegion],[PostalCode],[ModifiedDate]
  FROM [SalesLT].[Address]

SELECT [CustomerID],[AddressID],[AddressType],[ModifiedDate]
  FROM [SalesLT].[CustomerAddress]

SELECT [ProductCategoryID],[ParentProductCategoryID],[Name],[ModifiedDate]
  FROM [SalesLT].[ProductCategory]

SELECT [ProductModelID],[Name],[CatalogDescription],[ModifiedDate]
  FROM [SalesLT].[ProductModel]

SELECT [ProductDescriptionID],[Description],[ModifiedDate]
  FROM [SalesLT].[ProductDescription]


SELECT [ProductID],[Name],[ProductNumber],[Color],[StandardCost],[ListPrice],[Size],[Weight],[ProductCategoryID],[ProductModelID],[SellStartDate],[SellEndDate],[DiscontinuedDate],[ThumbNailPhoto],[ThumbnailPhotoFileName],[ModifiedDate]
  FROM [SalesLT].[Product]

SELECT [ProductModelID],[ProductDescriptionID],[Culture],[ModifiedDate]
  FROM [SalesLT].[ProductModelProductDescription]

SELECT [SalesOrderID],[RevisionNumber],[OrderDate],[DueDate],[ShipDate],[Status],[OnlineOrderFlag],[SalesOrderNumber],[PurchaseOrderNumber],[AccountNumber],[CustomerID],[ShipToAddressID],[BillToAddressID],[ShipMethod],[CreditCardApprovalCode],[SubTotal],[TaxAmt],[Freight],[TotalDue],[Comment],[ModifiedDate]
  FROM [SalesLT].[SalesOrderHeader]

SELECT [SalesOrderID],[SalesOrderDetailID],[OrderQty],[ProductID],[UnitPrice],[UnitPriceDiscount],[LineTotal],[ModifiedDate]
  FROM [SalesLT].[SalesOrderDetail]

*/
/******************************************************************************/
