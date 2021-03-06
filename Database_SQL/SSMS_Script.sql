/*
USE [master]
GO
/****** Object:  Database [p1g6]    Script Date: 22/06/2021 03:39:01 ******/
CREATE DATABASE [p1g6]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'p1g6', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER\MSSQL\DATA\p1g6.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'p1g6_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER\MSSQL\DATA\p1g6_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [p1g6] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [p1g6].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [p1g6] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [p1g6] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [p1g6] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [p1g6] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [p1g6] SET ARITHABORT OFF 
GO
ALTER DATABASE [p1g6] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [p1g6] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [p1g6] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [p1g6] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [p1g6] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [p1g6] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [p1g6] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [p1g6] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [p1g6] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [p1g6] SET  ENABLE_BROKER 
GO
ALTER DATABASE [p1g6] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [p1g6] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [p1g6] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [p1g6] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [p1g6] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [p1g6] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [p1g6] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [p1g6] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [p1g6] SET  MULTI_USER 
GO
ALTER DATABASE [p1g6] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [p1g6] SET DB_CHAINING OFF 
GO
ALTER DATABASE [p1g6] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [p1g6] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [p1g6] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [p1g6] SET QUERY_STORE = OFF
GO
*/
USE [p1g6]
GO
/****** Object:  User [p1g6]    Script Date: 22/06/2021 03:39:02 ******/
CREATE USER [p1g6] FOR LOGIN [p1g6] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [p1g6]
GO
/****** Object:  Schema [proj]    Script Date: 22/06/2021 03:39:02 ******/
CREATE SCHEMA [proj]
GO
/****** Object:  UserDefinedFunction [proj].[getAverageGamePrice]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [proj].[getAverageGamePrice]()	RETURNS DECIMAL(19,2) AS
	BEGIN
		DECLARE @averageGamePrice DECIMAL(19,4);
		SELECT	@averageGamePrice = AVG(Price)
		FROM	proj.Store_Software INNER JOIN proj.Game ON proj.Store_Software.Software_ID=proj.Game.Software_ID;
		RETURN	@averageGamePrice;
	END
GO
/****** Object:  UserDefinedFunction [proj].[getAverageNumberFriends]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION	[proj].[getAverageNumberFriends]() RETURNS INT AS
	BEGIN
		DECLARE		@averageNumberFriends INT;
		SELECT		@averageNumberFriends = AVG(T.Number_Friends)
		FROM		(SELECT		AppUser_ID1, COUNT(AppUser_ID2) AS Number_Friends
						FROM	proj.FriendsList
						GROUP BY AppUser_ID1) AS T;
		RETURN @averageNumberFriends;
	END
GO
/****** Object:  UserDefinedFunction [proj].[getAverageToolPrice]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [proj].[getAverageToolPrice]() RETURNS DECIMAL(19,2) AS
	BEGIN
		DECLARE @averageToolPrice DECIMAL(19,4);
		SELECT	@averageToolPrice = AVG(Price)
		FROM	proj.Store_Software INNER JOIN proj.Tool ON proj.Store_Software.Software_ID=proj.Tool.Software_ID;
		RETURN	@averageToolPrice;
	END
GO
/****** Object:  UserDefinedFunction [proj].[getAverageUserAge]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION	[proj].[getAverageUserAge]() RETURNS INT AS
	BEGIN
		DECLARE		@averageUserAge INT;
		SELECT		@averageUserAge = AVG(DATEDIFF(year, Birthdate, GETDATE()))
		FROM		proj.AppUser;
		RETURN @averageUserAge;
	END
GO
/****** Object:  UserDefinedFunction [proj].[getTotalMoneySpent]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION	[proj].[getTotalMoneySpent]() RETURNS DECIMAL(19, 2) AS
	BEGIN
		DECLARE		@TotalMoneySpent DECIMAL(19, 4);
		SELECT		@TotalMoneySpent = SUM(Cost)
		FROM		proj.Purchases;
		RETURN @TotalMoneySpent;
	END
GO
/****** Object:  Table [proj].[Publisher]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Publisher](
	[NIPC] [char](9) NOT NULL,
	[Legal_Name] [nvarchar](255) NOT NULL,
	[Street] [nvarchar](255) NOT NULL,
	[Postcode] [nvarchar](64) NOT NULL,
	[City] [nvarchar](255) NOT NULL,
	[Country] [nvarchar](32) NOT NULL,
	[Found_Date] [date] NOT NULL,
	[IsAllowed] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NIPC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [proj].[Software]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Software](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Official_Name] [nvarchar](255) NOT NULL,
	[Release_Date] [date] NOT NULL,
	[Class] [char](1) NOT NULL,
	[Publisher_NIPC] [char](9) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [proj].[Game]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Game](
	[Software_ID] [int] NOT NULL,
	[Age_Rating] [nvarchar](9) NOT NULL,
	[Brief_Description] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Software_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [proj].[Game_Type]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Game_Type](
	[Game_ID] [int] NOT NULL,
	[Game_Type] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Game_ID] ASC,
	[Game_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [proj].[SoftOS]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[SoftOS](
	[Software_ID] [int] NOT NULL,
	[Supported_OS] [nvarchar](64) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Software_ID] ASC,
	[Supported_OS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [proj].[Store_Software]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Store_Software](
	[Store_ID] [int] NOT NULL,
	[Software_ID] [int] NOT NULL,
	[Price] [decimal](19, 4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Store_ID] ASC,
	[Software_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [proj].[Show_All_Store_Games]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;
-------------------------------VIEWS DA LOJA-------------------------------
CREATE VIEW [proj].[Show_All_Store_Games] AS
	SELECT		ID, Class AS Software_Type, Official_Name, Price, Release_Date, Legal_Name AS Publisher, Age_Rating, [Type], STRING_AGG(Supported_OS, ', ') AS Supported_OS, Brief_Description
	FROM		(((proj.Store_Software	INNER JOIN	proj.Game		ON	proj.Store_Software.Software_ID=proj.Game.Software_ID)
										INNER JOIN	proj.Software	ON	proj.Software.ID=proj.Game.Software_ID)
										INNER JOIN	proj.Publisher	ON	proj.Publisher.NIPC=proj.Software.Publisher_NIPC)
										LEFT JOIN	proj.SoftOS		ON	proj.SoftOS.Software_ID=proj.Software.ID
										LEFT JOIN	(SELECT			Game_ID, STRING_AGG(Game_Type, ', ') AS [Type] 
														FROM		proj.Game_Type	INNER JOIN proj.Game ON proj.Game_Type.Game_ID=proj.Game.Software_ID
														GROUP BY	Game_ID) AS T ON T.Game_ID=proj.Software.ID  

	WHERE		(proj.Publisher.IsAllowed='1') AND (proj.Software.Publisher_NIPC IS NOT NULL)
	GROUP BY	ID, Class, Official_Name, Price, Release_Date, Legal_Name, Age_Rating, [Type], Brief_Description
GO
/****** Object:  Table [proj].[Tool]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Tool](
	[Software_ID] [int] NOT NULL,
	[Current_Version] [nvarchar](64) NOT NULL,
	[Brief_Description] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Software_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [proj].[Show_All_Store_Tools]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE VIEW [proj].[Show_All_Store_Tools] AS
	SELECT		ID, Class AS Software_Type,Official_Name, Price, Release_Date, Legal_Name AS Publisher, Current_Version, STRING_AGG(Supported_OS, ', ') AS Supported_OS, Brief_Description
	FROM		(((proj.Store_Software	INNER JOIN	proj.Tool		ON	proj.Store_Software.Software_ID=proj.Tool.Software_ID)
										INNER JOIN	proj.Software	ON	proj.Software.ID=proj.Tool.Software_ID)
										INNER JOIN	proj.Publisher	ON	proj.Publisher.NIPC=proj.Software.Publisher_NIPC)
										LEFT JOIN	proj.SoftOS		ON	proj.SoftOS.Software_ID=proj.Software.ID	 	

	WHERE		(proj.Publisher.IsAllowed='1') AND (proj.Software.Publisher_NIPC IS NOT NULL)
	GROUP BY	ID, Class, Official_Name, Price, Release_Date, Legal_Name, Current_Version, Brief_Description
GO
/****** Object:  View [proj].[Show_Tools_Can_Add_Store]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE VIEW [proj].[Show_Tools_Can_Add_Store] AS
	SELECT	ID, Class AS Software_Type,Official_Name, Release_Date, Legal_Name AS Publisher, Current_Version, STRING_AGG(Supported_OS, ', ') AS Supported_OS, Brief_Description
	FROM	proj.Software LEFT JOIN proj.Store_Software ON proj.Software.ID=proj.Store_Software.Software_ID
							INNER JOIN proj.Publisher	ON proj.Publisher.NIPC=proj.Software.Publisher_NIPC
							INNER JOIN proj.Tool		ON proj.Software.ID=proj.Tool.Software_ID
							INNER JOIN proj.SoftOS		ON proj.Software.ID=proj.SoftOS.Software_ID
	WHERE	(proj.Store_Software.Software_ID IS NULL) AND (proj.Publisher.IsAllowed='1') AND (proj.Software.Publisher_NIPC IS NOT NULL)
	GROUP BY	ID, Class, Official_Name, Price, Release_Date, Legal_Name, Current_Version, Brief_Description;
GO
/****** Object:  View [proj].[Show_Games_Can_Add_Store]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE VIEW [proj].[Show_Games_Can_Add_Store] AS
	SELECT	ID, Class AS Software_Type, Official_Name, Release_Date, Legal_Name AS Publisher, Age_Rating, [Type], STRING_AGG(Supported_OS, ', ') AS Supported_OS, Brief_Description
	FROM	proj.Software LEFT JOIN proj.Store_Software ON proj.Software.ID=proj.Store_Software.Software_ID
							INNER JOIN proj.Publisher	ON proj.Publisher.NIPC=proj.Software.Publisher_NIPC
							INNER JOIN proj.Game		ON proj.Software.ID=proj.Game.Software_ID
							INNER JOIN proj.SoftOS		ON proj.Software.ID=proj.SoftOS.Software_ID
							LEFT JOIN  (SELECT			Game_ID, STRING_AGG(Game_Type, ', ') AS [Type] 
														FROM		proj.Game_Type	INNER JOIN proj.Game ON proj.Game_Type.Game_ID=proj.Game.Software_ID
														GROUP BY	Game_ID) AS T ON T.Game_ID=proj.Software.ID  
	WHERE	(proj.Store_Software.Software_ID IS NULL) AND (proj.Publisher.IsAllowed='1') AND (proj.Software.Publisher_NIPC IS NOT NULL)
	GROUP BY	ID, Class, Official_Name, Price, Release_Date, Legal_Name, Age_Rating, [Type], Brief_Description
GO
/****** Object:  View [proj].[Show_All_Allowed_Publishers]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE VIEW [proj].[Show_All_Allowed_Publishers] AS
	SELECT	NIPC, Legal_Name AS Publisher, Street, Postcode, City, Country, Found_Date AS Foundation_Date
	FROM	proj.Publisher
	WHERE	IsAllowed='1'
GO
/****** Object:  View [proj].[Show_All_NotAllowed_Publishers]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE VIEW [proj].[Show_All_NotAllowed_Publishers] AS
	SELECT	NIPC, Legal_Name AS Publisher, Street, Postcode, City, Country, Found_Date AS Foundation_Date
	FROM	proj.Publisher
	WHERE	IsAllowed='0'
GO
/****** Object:  Table [proj].[AppUser]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[AppUser](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](128) NOT NULL,
	[Fname] [nvarchar](64) NOT NULL,
	[Lname] [nvarchar](64) NOT NULL,
	[Birthdate] [date] NOT NULL,
	[Sex] [nvarchar](1) NOT NULL,
	[Street] [nvarchar](255) NOT NULL,
	[Postcode] [nvarchar](64) NOT NULL,
	[City] [nvarchar](255) NOT NULL,
	[Country] [nvarchar](32) NOT NULL,
	[Balance] [decimal](19, 4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [proj].[Show_All_Users]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;


-------------------------------VIEWS DE UTILIZADORES-------------------------------
CREATE VIEW [proj].[Show_All_Users] AS
	SELECT	ID, Email, Fname, Lname, Birthdate, Sex, Street, Postcode, City, Country, Balance 
	FROM	proj.AppUser
GO
/****** Object:  Table [proj].[Inventory]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Inventory](
	[AppUser_ID] [int] NOT NULL,
	[Item_UUID] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AppUser_ID] ASC,
	[Item_UUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [proj].[Item_Category]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Item_Category](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Category_Name] [nvarchar](64) NOT NULL,
	[CanBeSold] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [proj].[Item]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Item](
	[UUID] [uniqueidentifier] NOT NULL,
	[Item_Name] [nvarchar](64) NOT NULL,
	[Rarity] [int] NOT NULL,
	[Market_Value] [decimal](19, 4) NULL,
	[Category] [int] NULL,
	[Game_ID] [int] NULL,
	[ForSale] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [proj].[Show_All_Items]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;


-------------------------------VIEWS DE ITEMS-------------------------------
CREATE VIEW [proj].[Show_All_Items] AS
	SELECT		UUID, Item_Name, Rarity, Market_Value, Category_Name, Game_ID, CanBeSold, ForSale, proj.AppUser.ID, Email, Fname, Lname
	FROM		proj.Item LEFT JOIN	proj.Item_Category ON proj.Item.Category=proj.Item_Category.ID
							INNER JOIN proj.Inventory ON proj.Item.UUID=proj.Inventory.Item_UUID
							INNER JOIN proj.AppUser ON proj.Inventory.AppUser_ID=proj.AppUser.ID
GO
/****** Object:  Table [proj].[Purchase_Returns]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Purchase_Returns](
	[Purchase_ID] [int] NOT NULL,
	[AppUser_ID] [int] NOT NULL,
	[Return_Date] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Purchase_ID] ASC,
	[AppUser_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [proj].[Purchases]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Purchases](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Finalize_Date] [date] NOT NULL,
	[AppUser_ID] [int] NULL,
	[Software_ID] [int] NULL,
	[Store_ID] [int] NULL,
	[SKU] [uniqueidentifier] NOT NULL,
	[Cost] [decimal](19, 4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [proj].[getOwnedSoftwareByUserID]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;
--------------------DADOS SOBRE UTILIZADORES--------------------
CREATE FUNCTION [proj].[getOwnedSoftwareByUserID](@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT		proj.Software.ID, Official_Name, Class AS Type_of_Software, STRING_AGG(Supported_OS, ', ') AS Supported_OS, Release_Date, SKU
			FROM		proj.Purchases	LEFT JOIN proj.Purchase_Returns ON proj.Purchases.ID=proj.Purchase_Returns.Purchase_ID
										INNER JOIN proj.Software ON proj.Purchases.Software_ID=proj.Software.ID
										LEFT JOIN	proj.SoftOS	ON proj.SoftOS.Software_ID=proj.Software.ID
			WHERE		(proj.Purchase_Returns.Purchase_ID IS NULL) AND (proj.Purchases.AppUser_ID=@AppUser_ID)
			GROUP BY	proj.Software.ID, Official_Name, Class, Release_Date, SKU);
GO
/****** Object:  UserDefinedFunction [proj].[getPurchasesByUserID]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION	[proj].[getPurchasesByUserID](@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	Software_ID, SKU, Finalize_Date, Cost
			FROM	proj.Purchases
			WHERE	AppUser_ID=@AppUser_ID);
GO
/****** Object:  UserDefinedFunction [proj].[getPurchaseReturnsByUserID]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [proj].[getPurchaseReturnsByUserID](@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	Software_ID, SKU, Return_Date, Cost
			FROM	proj.Purchase_Returns INNER JOIN proj.Purchases ON proj.Purchase_Returns.Purchase_ID=proj.Purchases.ID
			WHERE	proj.Purchase_Returns.AppUser_ID=@AppUser_ID);
GO
/****** Object:  Table [proj].[FriendsList]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[FriendsList](
	[AppUser_ID1] [int] NOT NULL,
	[AppUser_ID2] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AppUser_ID1] ASC,
	[AppUser_ID2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [proj].[getFriendsListByUserID]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [proj].[getFriendsListByUserID](@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	ID, Email, Fname, Lname 
			FROM	proj.FriendsList INNER JOIN proj.AppUser ON proj.FriendsList.AppUser_ID2=proj.AppUser.ID
			WHERE	AppUser_ID1=@AppUser_ID);
GO
/****** Object:  UserDefinedFunction [proj].[getNotFriendsWithByUserID]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [proj].[getNotFriendsWithByUserID](@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	ID, Email, Fname, Lname  
			FROM	proj.AppUser
			WHERE	ID NOT IN (SELECT	AppUser_ID2 
								FROM	proj.FriendsList 
								WHERE	(AppUser_ID1=@AppUser_ID) AND (ID <> @AppUser_ID)));
GO
/****** Object:  Table [proj].[Wishlist]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Wishlist](
	[AppUser_ID] [int] NOT NULL,
	[Software_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AppUser_ID] ASC,
	[Software_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [proj].[getWishlistByUserID]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION	[proj].[getWishlistByUserID](@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT		proj.Software.ID, Official_Name, Class AS Type_of_Software, Price, Legal_Name AS Publisher, STRING_AGG(Supported_OS, ', ') AS Supported_OS, Release_Date
			FROM		proj.Wishlist	INNER JOIN proj.Software ON proj.Wishlist.Software_ID=proj.Software.ID
										INNER JOIN proj.Publisher ON proj.Software.Publisher_NIPC=proj.Publisher.NIPC
										INNER JOIN proj.Store_Software ON proj.Software.ID=proj.Store_Software.Software_ID
										LEFT JOIN proj.SoftOS ON proj.SoftOS.Software_ID=proj.Software.ID
			WHERE		proj.Wishlist.AppUser_ID=@AppUser_ID
			GROUP BY	proj.Software.ID, Official_Name, Price, Legal_Name, Class, Release_Date);
GO
/****** Object:  UserDefinedFunction [proj].[getInventoryByUserID]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [proj].[getInventoryByUserID](@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	Item_Name, Category_Name AS Category, Rarity, CanBeSold, Market_Value, CAST(Game_ID AS NVARCHAR) + ' - ' + Official_Name AS Origin_Game, Item_UUID, ForSale
			FROM	proj.Inventory	INNER JOIN proj.Item ON proj.Inventory.Item_UUID=proj.Item.UUID
									INNER JOIN proj.Item_Category ON proj.Item.Category=proj.Item_Category.ID
									INNER JOIN proj.Game ON proj.Item.Game_ID=proj.Game.Software_ID
									INNER JOIN proj.Software ON proj.Game.Software_ID=proj.Software.ID
			WHERE	AppUser_ID=@AppUser_ID);						
GO
/****** Object:  Table [proj].[Market_Items]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Market_Items](
	[Market_ID] [int] NOT NULL,
	[Item_UUID] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Market_ID] ASC,
	[Item_UUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [proj].[getMarketByUserID]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [proj].[getMarketByUserID](@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	Item_Name, Category_Name AS Category, Rarity, Market_Value, CAST(Game_ID AS NVARCHAR) + ' - ' + Official_Name AS Origin_Game, proj.Market_Items.Item_UUID
			FROM	proj.Market_Items	INNER JOIN proj.Item ON proj.Market_Items.Item_UUID=proj.Item.UUID
										INNER JOIN proj.Item_Category ON proj.Item.Category=proj.Item_Category.ID
										INNER JOIN proj.Game ON proj.Item.Game_ID=proj.Game.Software_ID
										INNER JOIN proj.Software ON proj.Game.Software_ID=proj.Software.ID
										INNER JOIN proj.Inventory ON proj.Item.UUID=proj.Inventory.Item_UUID
			WHERE	AppUser_ID <> @AppUser_ID);		
GO
/****** Object:  UserDefinedFunction [proj].[getItemsForSaleByUserID]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [proj].[getItemsForSaleByUserID](@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	Item_Name, Category_Name AS Category, Rarity, CanBeSold, Market_Value, CAST(Game_ID AS NVARCHAR) + ' - ' + Official_Name AS Origin_Game, Item_UUID
			FROM	proj.Inventory	INNER JOIN proj.Item ON proj.Inventory.Item_UUID=proj.Item.UUID
									INNER JOIN proj.Item_Category ON proj.Item.Category=proj.Item_Category.ID
									INNER JOIN proj.Game ON proj.Item.Game_ID=proj.Game.Software_ID
									INNER JOIN proj.Software ON proj.Game.Software_ID=proj.Software.ID
			WHERE	(AppUser_ID=@AppUser_ID) AND (ForSale='Y'));	
GO
/****** Object:  UserDefinedFunction [proj].[getGamesByPublisher]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;


--------------------DADOS SOBRE PUBLICADORAS--------------------
CREATE FUNCTION [proj].[getGamesByPublisher](@Publisher_NIPC CHAR(9)) RETURNS TABLE AS
	RETURN(SELECT		ID, Official_Name, Release_Date, Legal_Name AS Publisher, Age_Rating, [Type], STRING_AGG(Supported_OS, ', ') AS Supported_OS, Brief_Description
			FROM		proj.Game	INNER JOIN	proj.Software	ON	proj.Game.Software_ID=proj.Software.ID
									INNER JOIN	proj.Publisher	ON	proj.Publisher.NIPC=proj.Software.Publisher_NIPC
									LEFT JOIN	proj.SoftOS		ON	proj.SoftOS.Software_ID=proj.Software.ID
									LEFT JOIN	(SELECT			Game_ID, STRING_AGG(Game_Type, ', ') AS [Type] 
													FROM		proj.Game_Type	INNER JOIN proj.Game ON proj.Game_Type.Game_ID=proj.Game.Software_ID
													GROUP BY	Game_ID) AS T ON T.Game_ID=proj.Software.ID
			WHERE		Publisher_NIPC=@Publisher_NIPC
			GROUP BY	ID, Class, Official_Name, Release_Date, Legal_Name, Age_Rating, [Type], Brief_Description)
GO
/****** Object:  UserDefinedFunction [proj].[getToolsByPublisher]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [proj].[getToolsByPublisher](@Publisher_NIPC CHAR(9)) RETURNS TABLE AS
	RETURN(SELECT		ID, Official_Name, Release_Date, Legal_Name AS Publisher, Current_Version, [Type], STRING_AGG(Supported_OS, ', ') AS Supported_OS, Brief_Description
			FROM		proj.Tool	INNER JOIN	proj.Software	ON	proj.Tool.Software_ID=proj.Software.ID
									INNER JOIN	proj.Publisher	ON	proj.Publisher.NIPC=proj.Software.Publisher_NIPC
									LEFT JOIN	proj.SoftOS		ON	proj.SoftOS.Software_ID=proj.Software.ID
									LEFT JOIN	(SELECT			Game_ID, STRING_AGG(Game_Type, ', ') AS [Type] 
													FROM		proj.Game_Type	INNER JOIN proj.Game ON proj.Game_Type.Game_ID=proj.Game.Software_ID
													GROUP BY	Game_ID) AS T ON T.Game_ID=proj.Software.ID
			WHERE		Publisher_NIPC=@Publisher_NIPC
			GROUP BY	ID, Class, Official_Name, Release_Date, Legal_Name, Current_Version, [Type], Brief_Description)
GO
/****** Object:  UserDefinedFunction [proj].[getGameSales]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;


--------------------ESTATISTICAS DA LOJA--------------------
CREATE FUNCTION	[proj].[getGameSales]() RETURNS TABLE AS
	RETURN(SELECT		proj.Game.Software_ID, proj.Software.Official_Name, COUNT(proj.Purchases.Software_ID) AS Sold_Copies
			FROM		proj.Purchases	INNER JOIN proj.Game ON proj.Purchases.Software_ID=proj.Game.Software_ID
										INNER JOIN proj.Software ON proj.Game.Software_ID=proj.Software.ID
			GROUP BY	proj.Game.Software_ID, proj.Software.Official_Name);
GO
/****** Object:  UserDefinedFunction [proj].[getToolSales]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION	[proj].[getToolSales]() RETURNS TABLE AS
	RETURN(SELECT		proj.Tool.Software_ID, proj.Software.Official_Name, COUNT(proj.Purchases.Software_ID) AS Sold_Copies
			FROM		proj.Purchases	INNER JOIN proj.Tool ON proj.Purchases.Software_ID=proj.Tool.Software_ID
										INNER JOIN proj.Software ON proj.Tool.Software_ID=proj.Software.ID
			GROUP BY	proj.Tool.Software_ID, proj.Software.Official_Name);
GO
/****** Object:  UserDefinedFunction [proj].[getPublisherSales]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [proj].[getPublisherSales]() RETURNS TABLE AS
	RETURN(SELECT		NIPC, Legal_Name AS Publisher, COUNT(Software_ID) AS Total_Sales
			FROM		proj.Purchases	INNER JOIN proj.Software ON proj.Purchases.Software_ID=proj.Software.ID
										INNER JOIN proj.Publisher ON proj.Software.Publisher_NIPC=proj.Publisher.NIPC
			GROUP BY	NIPC, Legal_Name);
GO
/****** Object:  UserDefinedFunction [proj].[getMostSupportedOS]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [proj].[getMostSupportedOS]() RETURNS TABLE AS
	RETURN(SELECT Supported_OS AS OS_Name, COUNT(*) AS Numb
			FROM proj.Store_Software INNER JOIN proj.Software ON proj.Store_Software.Software_ID=proj.Software.ID
										INNER JOIN proj.SoftOS ON proj.Software.ID=proj.SoftOS.Software_ID
			GROUP BY Supported_OS 
			HAVING COUNT(*) = (SELECT MAX(Numb) FROM (SELECT		Supported_OS, COUNT(*) AS Numb
														FROM		proj.Store_Software INNER JOIN proj.Software ON proj.Store_Software.Software_ID=proj.Software.ID
																						INNER JOIN proj.SoftOS ON proj.Software.ID=proj.SoftOS.Software_ID
														GROUP BY	Supported_OS) AS X));
GO
/****** Object:  UserDefinedFunction [proj].[getSexRepresentation]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;


--------------------ESTATISTICAS DE UTILIZADORES--------------------
CREATE FUNCTION	[proj].[getSexRepresentation]() RETURNS TABLE AS
	RETURN(SELECT		Sex, CAST(COUNT(ID)*100/(SELECT COUNT(ID) FROM proj.AppUser) AS DECIMAL(4,2)) AS [Percentage]
			FROM		proj.AppUser
			GROUP BY	Sex);
GO
/****** Object:  UserDefinedFunction [proj].[getUsersByCountry]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION	[proj].[getUsersByCountry]() RETURNS TABLE AS
	RETURN(SELECT		Country, COUNT(*) AS Users
			FROM		proj.AppUser
			GROUP BY	Country);
GO
/****** Object:  UserDefinedFunction [proj].[getUserStoreStatistics]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION	[proj].[getUserStoreStatistics]() RETURNS TABLE AS
	RETURN (SELECT	AppUser_ID, SUM(Cost) AS Total_Spent, SUM(Cost)/COUNT(*) AS Avg_Purchase_Cost
			FROM		proj.Purchases
			GROUP BY	AppUser_ID);
GO
/****** Object:  UserDefinedFunction [proj].[getWishedSoftware]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION	[proj].[getWishedSoftware]() RETURNS TABLE AS
	RETURN(SELECT		Software_ID, Official_Name AS Software_Name, COUNT(*) AS Number_of_Wishers
			FROM		proj.Wishlist INNER JOIN proj.Software ON proj.Wishlist.Software_ID=proj.Software.ID
			GROUP BY	Software_ID, Official_Name);
GO
/****** Object:  Table [proj].[Authorization_List]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Authorization_List](
	[Store_ID] [int] NOT NULL,
	[Publisher_NIPC] [char](9) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Store_ID] ASC,
	[Publisher_NIPC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [proj].[Market]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Market](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Market_Name] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [proj].[Store]    Script Date: 22/06/2021 03:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [proj].[Store](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Registered_Name] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [proj].[AppUser] ON 

INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (1, N'mgeere0@cnbc.com', N'Marven', N'Geere', CAST(N'2003-05-15' AS Date), N'M', N'943 Messerschmidt Circle', N'62800-000', N'Aracati', N'Brazil', CAST(50.0000 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (2, N'dmotton1@accuweather.com', N'Dorree', N'Motton', CAST(N'1968-01-30' AS Date), N' ', N'1655 Truax Plaza', N'17110', N'Harrisburg', N'United States', CAST(112.2700 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (3, N'rgallon2@si.edu', N'Ray', N'Gallon', CAST(N'1986-08-29' AS Date), N'M', N'639 Clyde Gallagher Junction', N'4525-274', N'Espinheira', N'Portugal', CAST(246.7300 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (4, N'hdeye3@twitter.com', N'Haley', N'D''eye', CAST(N'1994-08-29' AS Date), N'M', N'307 Randy Pass', N'4755-318', N'Midoes', N'Portugal', CAST(228.5900 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (5, N'jpantin4@zimbio.com', N'Julina', N'Pantin', CAST(N'1972-08-27' AS Date), N'F', N'68 Anniversary Street', N'LN6', N'Stapleford', N'United Kingdom', CAST(154.7700 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (6, N'ddebischof5@mail.ru', N'Deana', N'De Bischof', CAST(N'1986-05-23' AS Date), N'F', N'51308 Morrow Road', N'89130-000', N'Indaial', N'Brazil', CAST(221.3500 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (7, N'rtreasure6@cloudflare.com', N'Rockwell', N'Treasure', CAST(N'1944-07-23' AS Date), N'M', N'751 Comanche Terrace', N'3158', N'Whakatane', N'New Zealand', CAST(58.6400 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (8, N'asextone7@i2i.jp', N'Ayn', N'Sextone', CAST(N'1990-07-09' AS Date), N'F', N'0934 Katie Hill', N'31015', N'Pamplona/Iruna', N'Spain', CAST(190.9600 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (9, N'uglowacha8@amazon.co.jp', N'Ulises', N'Glowacha', CAST(N'1954-06-29' AS Date), N'M', N'4 Schiller Terrace', N'623850', N'Irbit', N'Russia', CAST(90.7600 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (10, N'slosemann9@reddit.com', N'Saundra', N'Losemann', CAST(N'1990-03-30' AS Date), N'F', N'9 Dennis Alley', N'15150-000', N'Monte Aprazível', N'Brazil', CAST(197.7200 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (11, N'everryanb@yellowpages.com', N'Enos', N'Verryan', CAST(N'1999-09-04' AS Date), N'M', N'19865 Boyd Circle', N'37-565', N'Mirocin', N'Poland', CAST(232.8000 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (12, N'sachurchc@usa.gov', N'Stanwood', N'Achurch', CAST(N'1949-03-25' AS Date), N'M', N'9 Center Parkway', N'76105', N'Fort Worth', N'United States', CAST(152.5800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (13, N'rpengillyd@earthlink.net', N'Rachel', N'Pengilly', CAST(N'1986-01-04' AS Date), N' ', N'2 Holy Cross Terrace', N'H9S', N'Dorval', N'Canada', CAST(46.5200 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (14, N'bjakoubece@indiatimes.com', N'Beatriz', N'Jakoubec', CAST(N'1985-02-09' AS Date), N'F', N'482 Tomscot Point', N'960-0645', N'Daigo', N'Japan', CAST(39.6800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (15, N'vlawlorf@artisteer.com', N'Vincenz', N'Lawlor', CAST(N'1983-08-19' AS Date), N'M', N'339 Briar Crest Alley', N'05-319', N'Ceglow', N'Poland', CAST(105.1900 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (16, N'rbattillg@japanpost.jp', N'Rakel', N'Battill', CAST(N'1992-02-09' AS Date), N' ', N'6758 Kim Road', N'75455 CEDEX 09', N'Paris 09', N'France', CAST(192.3000 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (17, N'rjanaudh@dion.ne.jp', N'Reggi', N'Janaud', CAST(N'1957-05-05' AS Date), N'F', N'405 Bayside Place', N'17280-000', N'Pederneiras', N'Brazil', CAST(80.6400 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (18, N'spollyi@princeton.edu', N'Silvanus', N'Polly', CAST(N'1998-05-25' AS Date), N'M', N'58311 Stephen Drive', N'3740', N'Quimili', N'Argentina', CAST(96.3300 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (19, N'hdobelj@dropbox.com', N'Heindrick', N'Dobel', CAST(N'1991-06-04' AS Date), N'M', N'2081 Ohio Point', N'157305', N'Manturovo', N'Russia', CAST(215.0500 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (20, N'fhaestierk@stumbleupon.com', N'Fulvia', N'Haestier', CAST(N'1957-03-03' AS Date), N'F', N'7 Briar Crest Place', N'72035 CEDEX 1', N'Le Mans', N'France', CAST(237.8100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (21, N'cvialsl@posterous.com', N'Casie', N'Vials', CAST(N'1987-05-11' AS Date), N'F', N'605 Esker Alley', N'68370-000', N'Altamira', N'Brazil', CAST(41.8300 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (22, N'dtoffalom@a8.net', N'Deidre', N'Toffalo', CAST(N'1983-12-18' AS Date), N' ', N'11346 Clyde Gallagher Plaza', N'6709', N'Wageningen', N'Netherlands', CAST(9.7600 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (23, N'esturleyn@harvard.edu', N'Eliza', N'Sturley', CAST(N'1995-06-08' AS Date), N'F', N'87 Farmco Point', N'303773', N'Vyshneye Dolgoye', N'Russia', CAST(136.7100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (24, N'eboldryo@biglobe.ne.jp', N'Esme', N'Boldry', CAST(N'1966-08-19' AS Date), N'M', N'886 Starling Trail', N'33448', N'Delray Beach', N'United States', CAST(241.2000 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (25, N'sdalwisp@myspace.com', N'Stewart', N'D''Alwis', CAST(N'1991-02-06' AS Date), N' ', N'436 Aberg Hill', N'54932', N'Isidro Fabela', N'Mexico', CAST(23.1900 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (26, N'jjanikq@ted.com', N'Jarrad', N'Janik', CAST(N'1980-05-09' AS Date), N'M', N'685 Corscot Junction', N'5144', N'Waalwijk', N'Netherlands', CAST(50.6700 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (27, N'ppitbladdor@360.cn', N'Perren', N'Pitbladdo', CAST(N'2002-01-23' AS Date), N'M', N'33744 Sachtjen Junction', N'43-211', N'Piasek', N'Poland', CAST(10.5100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (28, N'tvaliants@g.co', N'Thornie', N'Valiant', CAST(N'1972-07-29' AS Date), N'M', N'33667 Sugar Crossing', N'06-225', N'Rzewnie', N'Poland', CAST(226.0100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (29, N'afiveasht@msn.com', N'Aleece', N'Fiveash', CAST(N'1975-04-04' AS Date), N'F', N'4638 Troy Circle', N'142139', N'Pushkino', N'Russia', CAST(7.0100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (30, N'dlemarchandu@nhs.uk', N'Dolores', N'Le Marchand', CAST(N'1979-05-20' AS Date), N'F', N'21511 Transport Crossing', N'79540-000', N'Cassilandia', N'Brazil', CAST(142.3100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (31, N'asheldonv@a8.net', N'Alfonse', N'Sheldon', CAST(N'1967-01-05' AS Date), N'M', N'447 Aberg Alley', N'352421', N'Rassvet', N'Russia', CAST(130.8600 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (32, N'gtorrejonw@people.com.cn', N'Georgiana', N'Torrejon', CAST(N'1973-10-31' AS Date), N' ', N'57275 Anniversary Trail', N'98-160', N'Sedziejowice', N'Poland', CAST(161.5300 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (33, N'breevex@opensource.org', N'Beltran', N'Reeve', CAST(N'1985-04-08' AS Date), N'M', N'5 Summerview Avenue', N'6555', N'Daireaux', N'Argentina', CAST(215.9600 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (34, N'lroncay@issuu.com', N'Letizia', N'Ronca', CAST(N'1951-06-07' AS Date), N'F', N'5 Derek Plaza', N'5823', N'Los Condores', N'Argentina', CAST(54.4000 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (35, N'agothliffz@foxnews.com', N'Alwyn', N'Gothliff', CAST(N'1974-03-08' AS Date), N'M', N'6014 Springview Junction', N'17380-000', N'Brotas', N'Brazil', CAST(132.8200 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (36, N'zbutterfield10@blogspot.com', N'Zollie', N'Butterfield', CAST(N'1950-05-16' AS Date), N'M', N'46 Dapin Hill', N'35129', N'Padova', N'Italy', CAST(241.7200 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (37, N'gledgister11@microsoft.com', N'Granny', N'Ledgister', CAST(N'1996-05-30' AS Date), N' ', N'38 Lyons Pass', N'23-231', N'Goscieradow', N'Poland', CAST(236.8100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (38, N'cbirwhistle12@weebly.com', N'Coleman', N'Birwhistle', CAST(N'1964-10-05' AS Date), N'M', N'094 Myrtle Court', N'161469', N'Nikolsk', N'Russia', CAST(90.7600 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (39, N'ahow13@mtv.com', N'Annalise', N'How', CAST(N'1984-11-22' AS Date), N'F', N'57 Birchwood Pass', N'184653', N'Polyarnyy', N'Russia', CAST(3.4800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (40, N'abeardsworth14@skyrock.com', N'Archy', N'Beardsworth', CAST(N'1961-05-10' AS Date), N'M', N'007 Gerald Junction', N'80-893', N'Prazmow', N'Poland', CAST(235.3800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (41, N'tcutsforth15@example.com', N'Townsend', N'Cutsforth', CAST(N'1995-01-13' AS Date), N'M', N'95965 Starling Park', N'10270', N'New York City', N'United States', CAST(48.9100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (42, N'jmyrkus16@sakura.ne.jp', N'Jo', N'Myrkus', CAST(N'1970-12-06' AS Date), N'F', N'80 Mallard Hill', N'40687', N'El Aguacate', N'Mexico', CAST(211.7500 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (43, N'pskewes17@ebay.co.uk', N'Paten', N'Skewes', CAST(N'1933-09-11' AS Date), N'M', N'5751 West Junction', N'186670', N'Chupa', N'Russia', CAST(176.8800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (44, N'kvinson18@gmpg.org', N'Krispin', N'Vinson', CAST(N'1989-06-04' AS Date), N'M', N'7 Westend Lane', N'97-216', N'Czerniewice', N'Poland', CAST(23.5800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (45, N'educarme19@auda.org.au', N'Esther', N'ducarme', CAST(N'1986-10-21' AS Date), N'F', N'13 Blaine Point', N'08650', N'Trenton', N'United States', CAST(191.6700 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (46, N'anorcliff1a@omniture.com', N'Alfred', N'Norcliff', CAST(N'1944-04-18' AS Date), N'M', N'9 Drewry Lane', N'37-600', N'Lubaczow', N'Poland', CAST(164.5800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (47, N'granns1b@nba.com', N'Giulio', N'Ranns', CAST(N'1955-05-19' AS Date), N'M', N'2 Schmedeman Center', N'15104 CEDEX', N'Saint-Flour', N'France', CAST(196.7400 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (48, N'dperring1c@stumbleupon.com', N'Donall', N'Perring', CAST(N'1977-06-27' AS Date), N'M', N'46 Shoshone Alley', N'879-4413', N'Tsukawaki', N'Japan', CAST(63.7900 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (49, N'bkemitt1d@blogtalkradio.com', N'Berkeley', N'Kemitt', CAST(N'1955-05-19' AS Date), N'M', N'99973 Ludington Park', N'4625-604', N'Lourido', N'Portugal', CAST(71.3000 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (50, N'broggero1e@apple.com', N'Buffy', N'Roggero', CAST(N'1964-05-25' AS Date), N'F', N'803 Hollow Ridge Hill', N'46025', N'Valencia', N'Spain', CAST(92.4600 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (51, N'jtuiller1f@about.me', N'Jessi', N'Tuiller', CAST(N'1989-04-26' AS Date), N'F', N'51 Eggendart Park', N'986-0704', N'Moriyama', N'Japan', CAST(114.3000 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (52, N'cgavrielli1g@theglobeandmail.com', N'Cristy', N'Gavrielli', CAST(N'1941-01-16' AS Date), N'F', N'11098 Mockingbird Trail', N'303167', N'Kosaya Gora', N'Russia', CAST(161.8700 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (53, N'halexandersson1h@rediff.com', N'Hank', N'Alexandersson', CAST(N'1948-02-18' AS Date), N'M', N'128 Milwaukee Hill', N'1625', N'Belen de Escobar', N'Argentina', CAST(120.8400 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (54, N'zthake1i@php.net', N'Zorina', N'Thake', CAST(N'1974-04-24' AS Date), N'F', N'75 Oriole Drive', N'58-111', N'Gorzyczki', N'Poland', CAST(176.2800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (55, N'clowry1j@mapy.cz', N'Chev', N'Lowry', CAST(N'1965-09-01' AS Date), N'M', N'6 Magdeline Court', N'30061', N'Marietta', N'United States', CAST(194.8600 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (56, N'sdowty1k@ovh.net', N'Sullivan', N'Dowty', CAST(N'1969-02-19' AS Date), N' ', N'66578 Luster Point', N'26-333', N'Paradyz', N'Poland', CAST(233.4900 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (57, N'cbryns1l@devhub.com', N'Carmine', N'Bryns', CAST(N'1975-08-15' AS Date), N' ', N'497 Morningstar Way', N'992-0478', N'Takehara', N'Japan', CAST(171.4500 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (58, N'emohamed1m@mashable.com', N'Ethelbert', N'Mohamed', CAST(N'1971-06-04' AS Date), N'M', N'42 Algoma Pass', N'425050', N'Suslonger', N'Russia', CAST(100.0800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (59, N'gsirett1n@mapy.cz', N'Gawain', N'Sirett', CAST(N'1957-09-23' AS Date), N'M', N'3 Elka Way', N'2725-094', N'Mem Martins', N'Portugal', CAST(107.3100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (60, N'kkezor1o@youku.com', N'Karena', N'Kezor', CAST(N'1956-05-05' AS Date), N'F', N'34594 Express Drive', N'21-310', N'Wohyn', N'Poland', CAST(161.9300 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (61, N'sboddie1p@ow.ly', N'Seumas', N'Boddie', CAST(N'1995-10-29' AS Date), N'M', N'20 Sunnyside Park', N'80305', N'Boulder', N'United States', CAST(133.5100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (62, N'amaccrea1q@quantcast.com', N'Alie', N'Maccrea', CAST(N'1955-08-18' AS Date), N'F', N'27231 Westerfield Alley', N'83040 CEDEX 9', N'Toulon', N'France', CAST(209.4300 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (63, N'kgennings1r@quantcast.com', N'Krystalle', N'Gennings', CAST(N'1967-11-03' AS Date), N' ', N'91362 Grasskamp Terrace', N'904-2244', N'Okinawa', N'Japan', CAST(41.2500 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (64, N'jhaseldine1s@istockphoto.com', N'Jehanna', N'Haseldine', CAST(N'1946-03-19' AS Date), N'F', N'4953 Hagan Street', N'2950-438', N'Venda do Alcaide', N'Portugal', CAST(116.3300 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (65, N'petoile1t@bravesites.com', N'Piggy', N'Etoile', CAST(N'1954-09-23' AS Date), N'M', N'8779 Jenna Parkway', N'241521', N'Suponevo', N'Russia', CAST(92.5900 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (66, N'sworts1u@ucoz.ru', N'Sutherlan', N'Worts', CAST(N'1974-09-17' AS Date), N'M', N'2 Saint Paul Crossing', N'377-0816', N'Nakanojomachi', N'Japan', CAST(173.4300 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (67, N'lpusill1v@unc.edu', N'Laverne', N'Pusill', CAST(N'1955-07-20' AS Date), N'F', N'6 Nova Crossing', N'86-031', N'Osielsko', N'Poland', CAST(79.3900 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (68, N'nligerton1w@tumblr.com', N'Nan', N'Ligerton', CAST(N'1946-10-09' AS Date), N'F', N'73 Lakewood Gardens Point', N'184366', N'Baykalovo', N'Russia', CAST(123.4800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (69, N'gconradsen1x@prnewswire.com', N'Gusty', N'Conradsen', CAST(N'1985-08-19' AS Date), N' ', N'94960 Mccormick Pass', N'9521', N'Viljoenskroon', N'South Africa', CAST(242.7100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (70, N'gbirdis1y@amazon.co.jp', N'Gaelan', N'Birdis', CAST(N'1996-10-25' AS Date), N'M', N'1353 Morrow Parkway', N'21747', N'Hagerstown', N'United States', CAST(15.3700 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (71, N'bstebbings1z@apple.com', N'Buddie', N'Stebbings', CAST(N'1981-05-27' AS Date), N'M', N'204 Blackbird Street', N'91982 CEDEX 9', N'Évry', N'France', CAST(121.5100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (72, N'sfireman20@moonfruit.com', N'Shane', N'Fireman', CAST(N'1964-02-20' AS Date), N' ', N'221 Manitowish Court', N'4570-414', N'Rates', N'Portugal', CAST(213.9200 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (73, N'lmargaritelli21@shinystat.com', N'Lyn', N'Margaritelli', CAST(N'1975-06-14' AS Date), N'M', N'2 Bay Circle', N'641500', N'Lebyazhye', N'Russia', CAST(139.0200 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (74, N'cvanmerwe22@gizmodo.com', N'Chiquita', N'Van Merwe', CAST(N'1967-08-02' AS Date), N' ', N'6080 Hooker Hill', N'238703', N'Lesnoye', N'Russia', CAST(207.5200 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (75, N'rtoms23@nyu.edu', N'Ruby', N'Toms', CAST(N'1995-12-03' AS Date), N'M', N'6 Center Parkway', N'35574 CEDEX', N'Chantepie', N'France', CAST(63.5100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (76, N'djelley24@salon.com', N'Dianemarie', N'Jelley', CAST(N'1997-05-03' AS Date), N'F', N'59 Cambridge Place', N'175276', N'Ostashkov', N'Russia', CAST(13.1500 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (77, N'moveril25@phoca.cz', N'Micki', N'Overil', CAST(N'1943-09-17' AS Date), N' ', N'72 Merrick Center', N'54927', N'El Carmen', N'Mexico', CAST(40.9000 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (78, N'ajeanneau26@noaa.gov', N'Aguste', N'Jeanneau', CAST(N'1956-12-21' AS Date), N'M', N'6 Northwestern Hill', N'9213', N'Leleque', N'Argentina', CAST(191.2500 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (79, N'rmallall27@csmonitor.com', N'Reilly', N'Mallall', CAST(N'1984-01-17' AS Date), N'M', N'179 Namekagon Road', N'34-471', N'Lasek', N'Poland', CAST(182.4600 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (80, N'aatty28@flickr.com', N'Angie', N'Atty', CAST(N'1925-03-14' AS Date), N'M', N'0458 Quincy Trail', N'9400', N'Rio Gallegos', N'Argentina', CAST(1.7900 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (81, N'cpashbee29@nature.com', N'Christiano', N'Pashbee', CAST(N'1987-04-17' AS Date), N'M', N'8448 Dovetail Park', N'67236', N'Wichita', N'United States', CAST(195.8400 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (82, N'tauchterlonie2a@addtoany.com', N'Tildy', N'Auchterlonie', CAST(N'1946-07-25' AS Date), N' ', N'450 Hintze Park', N'839-1407', N'Miharu', N'Japan', CAST(220.9600 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (83, N'jburnyeat2b@topsy.com', N'Janeen', N'Burnyeat', CAST(N'1988-02-02' AS Date), N'F', N'23582 American Trail', N'363104', N'Grazhdanskoye', N'Russia', CAST(165.6800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (84, N'eaudiss2c@edublogs.org', N'Enid', N'Audiss', CAST(N'1976-03-03' AS Date), N'F', N'014 Fallview Road', N'32-432', N'Osieczany', N'Poland', CAST(143.1900 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (85, N'blafoy2d@hibu.com', N'Bogart', N'Lafoy', CAST(N'1944-04-03' AS Date), N'M', N'9 Eastlawn Crossing', N'60477 CEDEX', N'Compiegne', N'France', CAST(15.2900 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (86, N'ebalmer2e@dot.gov', N'Elvis', N'Balmer', CAST(N'1997-10-01' AS Date), N'M', N'1417 Commercial Junction', N'649193', N'Choya', N'Russia', CAST(34.3200 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (87, N'iswain2f@vimeo.com', N'Ida', N'Swain', CAST(N'1963-04-16' AS Date), N' ', N'5408 Lien Hill', N'78732', N'Austin', N'United States', CAST(199.8100 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (88, N'hjorat2g@chron.com', N'Hollie', N'Jorat', CAST(N'1961-08-22' AS Date), N'F', N'11270 Vera Plaza', N'79260-000', N'Bela Vista', N'Brazil', CAST(21.2800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (89, N'jlongworth2h@fastcompany.com', N'Jessamine', N'Longworth', CAST(N'1991-03-10' AS Date), N'F', N'040 Independence Avenue', N'3040-555', N'Albergaria', N'Portugal', CAST(129.1800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (90, N'ablasetti2i@ed.gov', N'Amitie', N'Blasetti', CAST(N'1996-12-10' AS Date), N' ', N'155 Kedzie Park', N'43-178', N'Ornontowice', N'Poland', CAST(209.6300 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (91, N'lscholfield2j@is.gd', N'Lonni', N'Scholfield', CAST(N'1970-07-19' AS Date), N'F', N'6516 Dovetail Crossing', N'62-620', N'Babiak', N'Poland', CAST(64.7000 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (92, N'pblackaller2k@cbsnews.com', N'Papageno', N'Blackaller', CAST(N'1959-12-13' AS Date), N'M', N'07863 Menomonie Drive', N'357815', N'Podgornaya', N'Russia', CAST(187.0700 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (93, N'tbenwell2l@sourceforge.net', N'Terrell', N'Benwell', CAST(N'1944-04-30' AS Date), N'M', N'0386 Talisman Alley', N'2670', N'Chacabuco', N'Argentina', CAST(23.9600 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (94, N'toswick2m@reddit.com', N'Trescha', N'Oswick', CAST(N'1991-03-05' AS Date), N'F', N'4174 Village Place', N'93828', N'20 de Noviembre', N'Mexico', CAST(76.1200 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (95, N'kprescote2n@livejournal.com', N'Kinna', N'Prescote', CAST(N'1933-11-05' AS Date), N'F', N'2 Hazelcrest Center', N'3070-725', N'Praia de Mira', N'Portugal', CAST(107.5900 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (96, N'glevane2o@diigo.com', N'Guendolen', N'Levane', CAST(N'2003-03-19' AS Date), N' ', N'1417 Meadow Valley Junction', N'91384 CEDEX', N'Chilly-Mazarin', N'France', CAST(46.8000 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (97, N'mmacrierie2p@phoca.cz', N'Micheal', N'MacRierie', CAST(N'1987-10-27' AS Date), N' ', N'12 La Follette Hill', N'2840-466', N'Seixal', N'Portugal', CAST(109.3400 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (98, N'rdevlin2q@1688.com', N'Roselle', N'Devlin', CAST(N'1971-04-10' AS Date), N'F', N'4 Old Gate Court', N'77260', N'Houston', N'United States', CAST(69.5800 AS Decimal(19, 4)))
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (99, N'smcavey0@unblog.fr', N'Sumner', N'McAvey', CAST(N'1995-04-10' AS Date), N'M', N'128 Warrior Place', N'98000', N'Fontvieille', N'Monaco', CAST(86.8000 AS Decimal(19, 4)))
GO
INSERT [proj].[AppUser] ([ID], [Email], [Fname], [Lname], [Birthdate], [Sex], [Street], [Postcode], [City], [Country], [Balance]) VALUES (100, N'lconyers1@tamu.edu', N'Lacee', N'Conyers', CAST(N'1981-02-21' AS Date), N'F', N'554 Fallview Drive', N'15103', N'Ait Ali', N'Algeria', CAST(47.8400 AS Decimal(19, 4)))
SET IDENTITY_INSERT [proj].[AppUser] OFF
GO
INSERT [proj].[Authorization_List] ([Store_ID], [Publisher_NIPC]) VALUES (1, N'262496356')
INSERT [proj].[Authorization_List] ([Store_ID], [Publisher_NIPC]) VALUES (1, N'446823285')
INSERT [proj].[Authorization_List] ([Store_ID], [Publisher_NIPC]) VALUES (1, N'516221301')
INSERT [proj].[Authorization_List] ([Store_ID], [Publisher_NIPC]) VALUES (1, N'531561295')
INSERT [proj].[Authorization_List] ([Store_ID], [Publisher_NIPC]) VALUES (1, N'532383894')
INSERT [proj].[Authorization_List] ([Store_ID], [Publisher_NIPC]) VALUES (1, N'649088570')
INSERT [proj].[Authorization_List] ([Store_ID], [Publisher_NIPC]) VALUES (1, N'668142917')
INSERT [proj].[Authorization_List] ([Store_ID], [Publisher_NIPC]) VALUES (1, N'718590525')
INSERT [proj].[Authorization_List] ([Store_ID], [Publisher_NIPC]) VALUES (1, N'915573914')
GO
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (1, 2)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (1, 7)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (1, 29)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (1, 43)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (1, 60)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (1, 86)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (2, 1)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (2, 14)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (2, 40)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (3, 14)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (3, 31)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (5, 42)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (5, 56)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (5, 79)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (7, 1)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (7, 9)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (7, 38)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (7, 73)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (9, 7)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (9, 40)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (9, 73)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (14, 2)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (14, 3)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (14, 37)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (15, 56)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (15, 69)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (18, 91)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (20, 37)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (24, 26)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (26, 24)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (26, 39)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (26, 67)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (26, 72)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (26, 88)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (29, 1)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (29, 91)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (31, 3)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (37, 14)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (37, 20)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (37, 85)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (37, 97)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (38, 7)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (39, 26)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (40, 2)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (40, 9)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (42, 5)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (42, 56)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (43, 1)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (46, 56)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (56, 5)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (56, 15)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (56, 42)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (56, 46)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (56, 70)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (60, 1)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (60, 63)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (63, 60)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (63, 79)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (67, 26)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (67, 91)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (69, 15)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (69, 79)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (69, 99)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (70, 56)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (70, 88)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (72, 26)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (72, 85)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (73, 7)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (73, 9)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (79, 5)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (79, 63)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (79, 69)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (85, 37)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (85, 72)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (86, 1)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (88, 26)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (88, 70)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (91, 18)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (91, 29)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (91, 67)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (97, 37)
INSERT [proj].[FriendsList] ([AppUser_ID1], [AppUser_ID2]) VALUES (99, 69)
GO
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (3, N'T', N'')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (5, N'A', N'aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (6, N'T', N'id consequat in consequat ut ''a sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (9, N'A', N'magna at nunc commodo placerat praesent blandit nam ''a integer pede justo lacinia eget tincidunt eget tempus')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (12, N'M', N'elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (13, N'Non-Rated', N'sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (15, N'M', N'nibh ligula nec sem duis aliquam convallis nunc proin at turpis')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (19, N'E', N'blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (20, N'Non-Rated', N'nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (23, N'E', N'ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (25, N'E', N'a eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum ''a nunc purus phasellus in felis donec semper sapien')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (26, N'A', N'')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (30, N'M', N'')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (32, N'T', N'accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (33, N'T', N'elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (37, N'T', N'suspendisse potenti ''am porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet ''am orci pede')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (38, N'T', N'mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (39, N'E', N'ante ''a justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (40, N'E', N'eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae ''a dapibus dolor vel est donec odio')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (41, N'A', N'leo odio porttitor id consequat in consequat ut ''a sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (42, N'M', N'elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (48, N'E', N'purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt ''a mollis molestie')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (49, N'T', N'quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (53, N'E', N'cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (54, N'E', N'proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (55, N'A', N'facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (56, N'T', N'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (59, N'T', N'id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (61, N'T', N'amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (63, N'Non-Rated', N'amet sem fusce consequat ''a nisl nunc nisl duis bibendum felis sed')
INSERT [proj].[Game] ([Software_ID], [Age_Rating], [Brief_Description]) VALUES (66, N'T', N'magna at nunc commodo placerat praesent blandit nam ''a integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor')
GO
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (3, N'Horror')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (3, N'RPG')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (3, N'Sports')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (3, N'Strategy')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (5, N'Puzzle')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (5, N'Sandbox')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (5, N'Shooter')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (5, N'Story')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (6, N'Uncategorized')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (9, N'Multiplayer')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (9, N'RPG')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (9, N'Shooter')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (9, N'Strategy')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (12, N'Crime')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (12, N'MOBA')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (12, N'Puzzle')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (12, N'Sandbox')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (13, N'Horror')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (13, N'Sports')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (13, N'Strategy')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (13, N'Survival')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (15, N'Multiplayer')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (15, N'Puzzle')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (15, N'Shooter')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (15, N'Story')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (19, N'Uncategorized')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (20, N'Multiplayer')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (20, N'RPG')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (20, N'Strategy')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (23, N'Crime')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (23, N'Puzzle')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (23, N'Sandbox')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (25, N'Horror')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (25, N'Sports')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (25, N'Survival')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (26, N'Multiplayer')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (26, N'Shooter')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (26, N'Story')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (30, N'Uncategorized')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (32, N'Horror')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (32, N'RPG')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (32, N'Strategy')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (33, N'Puzzle')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (33, N'Sandbox')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (33, N'Story')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (37, N'Sports')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (37, N'Survival')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (38, N'Multiplayer')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (38, N'RPG')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (38, N'Shooter')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (39, N'Crime')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (39, N'MOBA')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (39, N'Sandbox')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (40, N'Horror')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (40, N'Sports')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (40, N'Strategy')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (41, N'Puzzle')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (41, N'Shooter')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (41, N'Story')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (42, N'Uncategorized')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (48, N'Multiplayer')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (48, N'RPG')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (48, N'Strategy')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (49, N'Crime')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (49, N'Puzzle')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (49, N'Sandbox')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (53, N'Horror')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (53, N'Sports')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (53, N'Survival')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (54, N'Multiplayer')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (54, N'Shooter')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (54, N'Story')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (55, N'Uncategorized')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (56, N'Horror')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (56, N'RPG')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (56, N'Strategy')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (59, N'Puzzle')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (59, N'Sandbox')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (59, N'Story')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (61, N'Uncategorized')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (63, N'Multiplayer')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (63, N'RPG')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (63, N'Shooter')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (66, N'Crime')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (66, N'MOBA')
INSERT [proj].[Game_Type] ([Game_ID], [Game_Type]) VALUES (66, N'Sandbox')
GO
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (1, N'0b556d21-2087-4df3-9dfa-0271b6061483')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (1, N'3a77e02e-2f44-404f-822d-2cb4d9f48769')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (1, N'02242a45-6591-406f-b99f-92957a4c7b89')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (1, N'bce9d00b-8dda-4743-beef-97f69cdc193a')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (1, N'9d7c2a6f-1e4a-4420-84e8-c08be026e040')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (3, N'03705926-ed97-4c4d-bbcc-d903908303cd')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (11, N'2a5e2ceb-ce5d-47c3-ac9f-7154cf3f61c4')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (16, N'3f3aea80-5c19-41a3-a7cf-304bcfcd37e6')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (17, N'e414a86c-b989-4e63-a46e-a1faec8e8b68')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (22, N'a7344104-cb70-4781-8f67-0cab9d4468f5')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (23, N'f1048dd5-5ae2-40e7-aabf-c921e65d91e5')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (26, N'1aa060b9-8708-45f1-b22c-6fd35657a28f')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (29, N'a05cdf3e-ddb0-4e10-b9d3-eb070713b257')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (37, N'6f57bcf9-eb12-49b4-a595-e28e2c1fba8f')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (38, N'e661c8fe-6d8d-4179-8669-7c5294109472')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (38, N'ed816297-0beb-44cc-a6ea-e7d4b74630a7')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (42, N'bc8912fa-699e-410a-9410-b968d2393c10')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (42, N'a16fda0d-83f9-4653-b126-f527c55ddd0c')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (48, N'6dd21fba-fbe6-4b2b-8a3a-0ba567d8eabb')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (51, N'776ea454-13e8-449b-966c-de1d60fbee24')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (55, N'9b40d143-5d43-4812-a02c-9f63135cc0be')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (58, N'f1009f39-c37d-44b7-934a-660c1cad947d')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (63, N'7ce7ca81-4610-419b-85f6-d9c5cdef3252')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (64, N'aecee278-fe6a-467d-82c8-0e24b5a34a92')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (64, N'4dc52a42-7968-4c9e-bc49-b1d70a520a0b')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (67, N'04555b03-17db-462d-9ba3-9ea85c047017')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (72, N'94865bc6-4b16-40ef-99a0-52e89e29518d')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (72, N'abf1f7ae-4233-413b-90a8-a5a7404a635b')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (73, N'9811688d-3d26-4d22-ade2-98724c929f76')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (74, N'264650e6-0327-4b24-8610-17210fa5faf0')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (80, N'fc40e52e-ce88-46b0-86e6-637ae495d649')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (82, N'f7c6e3d1-321a-4d0f-97f5-42e3edad7c1d')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (87, N'95b5c732-a6e1-430e-87bc-3fbe78878c4e')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (87, N'ef7a851c-6aea-41e8-9090-bc87b8b9fbde')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (89, N'7499483e-4822-48ca-8607-5b295b877c57')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (94, N'cdaf8cb7-5f7f-4adc-888b-5f32ed9f805c')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (94, N'4b663e30-6188-4620-a5f7-9d7be4f0d87b')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (95, N'd7e7f93a-3fcb-4f4e-829b-f54041435a80')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (96, N'878d939b-bddd-4d7b-8489-ab5be7809fb0')
INSERT [proj].[Inventory] ([AppUser_ID], [Item_UUID]) VALUES (97, N'10241d27-4315-40cf-a09e-581b991c9107')
GO
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'0b556d21-2087-4df3-9dfa-0271b6061483', N'Card-5156grih', 5, CAST(13.1000 AS Decimal(19, 4)), 3, 6, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'6dd21fba-fbe6-4b2b-8a3a-0ba567d8eabb', N'Medal-8596gkor', 3, NULL, 1, 66, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'a7344104-cb70-4781-8f67-0cab9d4468f5', N'Card-0954nusb', 5, CAST(10.3500 AS Decimal(19, 4)), 3, 61, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'aecee278-fe6a-467d-82c8-0e24b5a34a92', N'Card-1641jort', 5, CAST(2.8900 AS Decimal(19, 4)), 3, 33, N'Y')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'264650e6-0327-4b24-8610-17210fa5faf0', N'Medal-1117itji', 3, NULL, 1, 49, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'3a77e02e-2f44-404f-822d-2cb4d9f48769', N'Cosmetic-9883ytld', 1, CAST(15.7900 AS Decimal(19, 4)), 2, 53, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'3f3aea80-5c19-41a3-a7cf-304bcfcd37e6', N'Wallpaper-2175gvqv', 3, CAST(5.8000 AS Decimal(19, 4)), 4, 55, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'95b5c732-a6e1-430e-87bc-3fbe78878c4e', N'Wallpaper-0021uqii', 4, CAST(0.9200 AS Decimal(19, 4)), 4, 23, N'Y')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'f7c6e3d1-321a-4d0f-97f5-42e3edad7c1d', N'Cosmetic-4261kwai', 3, CAST(19.1300 AS Decimal(19, 4)), 2, 9, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'94865bc6-4b16-40ef-99a0-52e89e29518d', N'Cosmetic-7226lhlc', 1, CAST(0.4000 AS Decimal(19, 4)), 2, 32, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'10241d27-4315-40cf-a09e-581b991c9107', N'Medal-1986ruey', 5, NULL, 1, 63, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'7499483e-4822-48ca-8607-5b295b877c57', N'Medal-8823sgue', 1, NULL, 1, 33, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'cdaf8cb7-5f7f-4adc-888b-5f32ed9f805c', N'Card-6993awmu', 3, CAST(9.6800 AS Decimal(19, 4)), 3, 5, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'fc40e52e-ce88-46b0-86e6-637ae495d649', N'Cosmetic-5964zovh', 1, CAST(18.4600 AS Decimal(19, 4)), 2, 40, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'f1009f39-c37d-44b7-934a-660c1cad947d', N'Cosmetic-9402tfdo', 1, CAST(18.2300 AS Decimal(19, 4)), 2, 55, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'1aa060b9-8708-45f1-b22c-6fd35657a28f', N'Medal-5783lmxt', 4, NULL, 1, 3, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'2a5e2ceb-ce5d-47c3-ac9f-7154cf3f61c4', N'Medal-7303oixc', 5, NULL, 1, 3, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'e661c8fe-6d8d-4179-8669-7c5294109472', N'Medal-0013auwz', 1, NULL, 1, 3, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'02242a45-6591-406f-b99f-92957a4c7b89', N'Medal-1545oyun', 3, NULL, 1, 5, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'bce9d00b-8dda-4743-beef-97f69cdc193a', N'Wallpaper-6033ycif', 3, CAST(11.1600 AS Decimal(19, 4)), 4, 6, N'Y')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'9811688d-3d26-4d22-ade2-98724c929f76', N'Cosmetic-5380narm', 2, CAST(13.7500 AS Decimal(19, 4)), 2, 5, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'4b663e30-6188-4620-a5f7-9d7be4f0d87b', N'Wallpaper-5212yrlc', 4, CAST(13.6300 AS Decimal(19, 4)), 4, 6, N'Y')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'04555b03-17db-462d-9ba3-9ea85c047017', N'Card-1547nhrr', 3, CAST(1.2400 AS Decimal(19, 4)), 3, 20, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'9b40d143-5d43-4812-a02c-9f63135cc0be', N'Card-2802yxtq', 1, CAST(14.9800 AS Decimal(19, 4)), 3, 42, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'e414a86c-b989-4e63-a46e-a1faec8e8b68', N'Wallpaper-3148vcqb', 5, CAST(5.8000 AS Decimal(19, 4)), 4, 49, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'abf1f7ae-4233-413b-90a8-a5a7404a635b', N'Cosmetic-6673wypk', 2, CAST(3.5500 AS Decimal(19, 4)), 2, 37, N'Y')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'878d939b-bddd-4d7b-8489-ab5be7809fb0', N'Card-7823lorl', 3, CAST(5.0700 AS Decimal(19, 4)), 3, 19, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'4dc52a42-7968-4c9e-bc49-b1d70a520a0b', N'Wallpaper-2855hvfz', 4, CAST(10.7600 AS Decimal(19, 4)), 4, 12, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'bc8912fa-699e-410a-9410-b968d2393c10', N'Wallpaper-5816tbpx', 1, CAST(12.0100 AS Decimal(19, 4)), 4, 3, N'Y')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'ef7a851c-6aea-41e8-9090-bc87b8b9fbde', N'Wallpaper-5239jimf', 3, CAST(3.7300 AS Decimal(19, 4)), 4, 32, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'9d7c2a6f-1e4a-4420-84e8-c08be026e040', N'Card-5484wolq', 2, CAST(6.7700 AS Decimal(19, 4)), 3, 39, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'f1048dd5-5ae2-40e7-aabf-c921e65d91e5', N'Wallpaper-9737wzpp', 3, CAST(14.3800 AS Decimal(19, 4)), 4, 23, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'03705926-ed97-4c4d-bbcc-d903908303cd', N'Cosmetic-1927izmn', 3, CAST(10.1500 AS Decimal(19, 4)), 2, 32, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'7ce7ca81-4610-419b-85f6-d9c5cdef3252', N'Card-6486vuml', 3, CAST(6.7300 AS Decimal(19, 4)), 3, 25, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'776ea454-13e8-449b-966c-de1d60fbee24', N'Medal-1709auzj', 1, NULL, 1, 9, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'6f57bcf9-eb12-49b4-a595-e28e2c1fba8f', N'Cosmetic-0034xzna', 2, CAST(15.2200 AS Decimal(19, 4)), 2, 41, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'ed816297-0beb-44cc-a6ea-e7d4b74630a7', N'Cosmetic-7395rvds', 4, CAST(3.3500 AS Decimal(19, 4)), 2, 48, N'Y')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'a05cdf3e-ddb0-4e10-b9d3-eb070713b257', N'Card-6524bnct', 3, CAST(3.9200 AS Decimal(19, 4)), 3, 66, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'a16fda0d-83f9-4653-b126-f527c55ddd0c', N'Medal-8336wujj', 1, NULL, 1, 48, N'N')
INSERT [proj].[Item] ([UUID], [Item_Name], [Rarity], [Market_Value], [Category], [Game_ID], [ForSale]) VALUES (N'd7e7f93a-3fcb-4f4e-829b-f54041435a80', N'Wallpaper-3188hxbr', 1, CAST(9.0100 AS Decimal(19, 4)), 4, 48, N'N')
GO
SET IDENTITY_INSERT [proj].[Item_Category] ON 

INSERT [proj].[Item_Category] ([ID], [Category_Name], [CanBeSold]) VALUES (1, N'Medal', 0)
INSERT [proj].[Item_Category] ([ID], [Category_Name], [CanBeSold]) VALUES (2, N'Cosmetic', 1)
INSERT [proj].[Item_Category] ([ID], [Category_Name], [CanBeSold]) VALUES (3, N'Card', 1)
INSERT [proj].[Item_Category] ([ID], [Category_Name], [CanBeSold]) VALUES (4, N'Wallpaper', 1)
SET IDENTITY_INSERT [proj].[Item_Category] OFF
GO
SET IDENTITY_INSERT [proj].[Market] ON 

INSERT [proj].[Market] ([ID], [Market_Name]) VALUES (1, N'Mercado da Comunidade')
SET IDENTITY_INSERT [proj].[Market] OFF
GO
INSERT [proj].[Market_Items] ([Market_ID], [Item_UUID]) VALUES (1, N'aecee278-fe6a-467d-82c8-0e24b5a34a92')
INSERT [proj].[Market_Items] ([Market_ID], [Item_UUID]) VALUES (1, N'95b5c732-a6e1-430e-87bc-3fbe78878c4e')
INSERT [proj].[Market_Items] ([Market_ID], [Item_UUID]) VALUES (1, N'bce9d00b-8dda-4743-beef-97f69cdc193a')
INSERT [proj].[Market_Items] ([Market_ID], [Item_UUID]) VALUES (1, N'4b663e30-6188-4620-a5f7-9d7be4f0d87b')
INSERT [proj].[Market_Items] ([Market_ID], [Item_UUID]) VALUES (1, N'abf1f7ae-4233-413b-90a8-a5a7404a635b')
INSERT [proj].[Market_Items] ([Market_ID], [Item_UUID]) VALUES (1, N'bc8912fa-699e-410a-9410-b968d2393c10')
INSERT [proj].[Market_Items] ([Market_ID], [Item_UUID]) VALUES (1, N'ed816297-0beb-44cc-a6ea-e7d4b74630a7')
GO
INSERT [proj].[Publisher] ([NIPC], [Legal_Name], [Street], [Postcode], [City], [Country], [Found_Date], [IsAllowed]) VALUES (N'262496356', N'Kirlin, Altenwerth and Heidenreich', N'7814 Browning Parkway', N'9010', N'Brisbane', N'Australia', CAST(N'2002-09-04' AS Date), 1)
INSERT [proj].[Publisher] ([NIPC], [Legal_Name], [Street], [Postcode], [City], [Country], [Found_Date], [IsAllowed]) VALUES (N'392464610', N'Cummings Group', N'331 Westerfield Park', N'622970', N'Visim', N'Russia', CAST(N'2017-09-14' AS Date), 0)
INSERT [proj].[Publisher] ([NIPC], [Legal_Name], [Street], [Postcode], [City], [Country], [Found_Date], [IsAllowed]) VALUES (N'446823285', N'Thiel, Beier and Rowe', N'8 Ohio Junction', N'08922', N'New Brunswick', N'United States', CAST(N'2011-08-21' AS Date), 1)
INSERT [proj].[Publisher] ([NIPC], [Legal_Name], [Street], [Postcode], [City], [Country], [Found_Date], [IsAllowed]) VALUES (N'516221301', N'Doyle-Cassin', N'6 Barby Center', N'964-0944', N'Saku', N'Japan', CAST(N'1983-03-07' AS Date), 1)
INSERT [proj].[Publisher] ([NIPC], [Legal_Name], [Street], [Postcode], [City], [Country], [Found_Date], [IsAllowed]) VALUES (N'531561295', N'Stanton, Padberg and Haley', N'40845 Sunnyside Crossing', N'CH48', N'Wirral', N'United Kingdom', CAST(N'2016-10-04' AS Date), 1)
INSERT [proj].[Publisher] ([NIPC], [Legal_Name], [Street], [Postcode], [City], [Country], [Found_Date], [IsAllowed]) VALUES (N'532383894', N'Flatley LLC', N'637 Elka Junction', N'DL8', N'Carlton', N'United Kingdom', CAST(N'2009-11-10' AS Date), 1)
INSERT [proj].[Publisher] ([NIPC], [Legal_Name], [Street], [Postcode], [City], [Country], [Found_Date], [IsAllowed]) VALUES (N'649088570', N'Stoltenberg-Vandervort', N'5496 Bluejay Parkway', N'473-0938', N'Anjo', N'Japan', CAST(N'2013-08-15' AS Date), 1)
INSERT [proj].[Publisher] ([NIPC], [Legal_Name], [Street], [Postcode], [City], [Country], [Found_Date], [IsAllowed]) VALUES (N'668142917', N'Leuschke-Mraz', N'44 Fair Oaks Center', N'14109', N'Berlin', N'Germany', CAST(N'2010-05-15' AS Date), 1)
INSERT [proj].[Publisher] ([NIPC], [Legal_Name], [Street], [Postcode], [City], [Country], [Found_Date], [IsAllowed]) VALUES (N'718590525', N'Wolf-Becker', N'8 Crownhardt Lane', N'78764', N'Austin', N'United States', CAST(N'1987-03-07' AS Date), 1)
INSERT [proj].[Publisher] ([NIPC], [Legal_Name], [Street], [Postcode], [City], [Country], [Found_Date], [IsAllowed]) VALUES (N'915573914', N'Purdy, Batz and Kulas', N'5158 Vidon Drive', N'L33', N'Liverpool', N'United Kingdom', CAST(N'1970-07-16' AS Date), 1)
GO
INSERT [proj].[Purchase_Returns] ([Purchase_ID], [AppUser_ID], [Return_Date]) VALUES (4, 1, CAST(N'2020-10-09' AS Date))
INSERT [proj].[Purchase_Returns] ([Purchase_ID], [AppUser_ID], [Return_Date]) VALUES (16, 12, CAST(N'2020-11-06' AS Date))
INSERT [proj].[Purchase_Returns] ([Purchase_ID], [AppUser_ID], [Return_Date]) VALUES (28, 24, CAST(N'2021-04-22' AS Date))
INSERT [proj].[Purchase_Returns] ([Purchase_ID], [AppUser_ID], [Return_Date]) VALUES (36, 32, CAST(N'2020-11-28' AS Date))
INSERT [proj].[Purchase_Returns] ([Purchase_ID], [AppUser_ID], [Return_Date]) VALUES (45, 41, CAST(N'2020-11-20' AS Date))
INSERT [proj].[Purchase_Returns] ([Purchase_ID], [AppUser_ID], [Return_Date]) VALUES (57, 54, CAST(N'2020-07-06' AS Date))
INSERT [proj].[Purchase_Returns] ([Purchase_ID], [AppUser_ID], [Return_Date]) VALUES (62, 59, CAST(N'2020-11-14' AS Date))
INSERT [proj].[Purchase_Returns] ([Purchase_ID], [AppUser_ID], [Return_Date]) VALUES (71, 4, CAST(N'2021-03-24' AS Date))
INSERT [proj].[Purchase_Returns] ([Purchase_ID], [AppUser_ID], [Return_Date]) VALUES (88, 22, CAST(N'2020-09-05' AS Date))
INSERT [proj].[Purchase_Returns] ([Purchase_ID], [AppUser_ID], [Return_Date]) VALUES (99, 35, CAST(N'2020-08-30' AS Date))
GO
SET IDENTITY_INSERT [proj].[Purchases] ON 

INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (1, CAST(N'2021-02-13' AS Date), 1, 1, 1, N'a8cc8915-57f2-4714-9433-a217797edcb2', CAST(131.1700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (2, CAST(N'2021-02-13' AS Date), 1, 1, 1, N'd22ddf6e-e2b7-4963-b175-1c196fa531d4', CAST(131.1700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (3, CAST(N'2020-08-11' AS Date), 1, 8, 1, N'e9635645-56d4-4204-a984-fa2c9cad94bd', CAST(73.4800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (4, CAST(N'2020-10-08' AS Date), 1, 7, 1, N'62201fa3-41bf-4651-a732-d60805dc0f68', CAST(77.0000 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (5, CAST(N'2020-08-12' AS Date), 2, 12, 1, N'4df9c849-a0d2-46d9-a796-1a88430cee6d', CAST(3.3800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (6, CAST(N'2020-08-30' AS Date), 2, 42, 1, N'34d1042b-e23a-4e27-bed4-86c0aac6cbce', CAST(34.5700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (7, CAST(N'2020-09-04' AS Date), 3, 66, 1, N'f2f4dcb6-ef9c-4913-8d75-f0b7ae664a7a', CAST(0.0000 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (8, CAST(N'2020-09-05' AS Date), 4, 27, 1, N'e4841fe9-f74d-48a4-b3b8-ddbcae12df4f', CAST(14.9600 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (9, CAST(N'2021-01-24' AS Date), 5, 57, 1, N'3b5e74ad-b98e-4b76-8b83-32191422cb05', CAST(49.4700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (10, CAST(N'2020-11-25' AS Date), 6, 25, 1, N'190277a7-3be0-4f7d-b81d-b726600d971e', CAST(61.4000 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (11, CAST(N'2020-06-25' AS Date), 7, 8, 1, N'8fe71435-9f99-4e89-9623-22421c9ebfc0', CAST(73.4800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (12, CAST(N'2020-11-21' AS Date), 8, 31, 1, N'038e3310-64ce-4602-9f89-8d3b3ecad742', CAST(11.8300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (13, CAST(N'2020-10-22' AS Date), 9, 44, 1, N'a61e45bf-3d95-4450-902d-b8647850e750', CAST(38.5200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (14, CAST(N'2021-03-04' AS Date), 10, 22, 1, N'2ac0096b-daef-411f-8085-4275415bd286', CAST(115.9200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (15, CAST(N'2021-03-08' AS Date), 11, 48, 1, N'0cc00f8e-f131-4bd8-acf8-9851445d523e', CAST(50.1300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (16, CAST(N'2020-11-03' AS Date), 12, 8, 1, N'6afbd787-b0db-49b9-8f98-756412e7913e', CAST(73.4800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (17, CAST(N'2020-07-08' AS Date), 13, 65, 1, N'de00422b-747f-4594-840a-35d6a4108a9f', CAST(54.2900 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (18, CAST(N'2021-03-20' AS Date), 14, 21, 1, N'310ffe25-972f-4366-b058-4e634a7dacfe', CAST(50.4300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (19, CAST(N'2021-04-17' AS Date), 15, 10, 1, N'4342e0a7-8890-4489-8d42-743b514af8e8', CAST(51.0100 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (20, CAST(N'2020-06-15' AS Date), 16, 1, 1, N'04d71733-36f8-4b52-b0c7-5df8788f23b9', CAST(131.1700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (21, CAST(N'2020-07-31' AS Date), 17, 45, 1, N'15349cd0-3459-4d93-a666-dd7f23d8c5de', CAST(75.3700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (22, CAST(N'2020-10-15' AS Date), 18, 31, 1, N'44912e0b-a11f-4738-af03-8e02b66e7540', CAST(11.8300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (23, CAST(N'2020-12-26' AS Date), 19, 49, 1, N'9fc8836e-e5fc-484f-867e-23a84fc06810', CAST(10.5100 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (24, CAST(N'2021-01-29' AS Date), 20, 20, 1, N'acce870a-6d11-4d1e-a788-53e39375f0ab', CAST(33.2600 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (25, CAST(N'2021-05-13' AS Date), 21, 17, 1, N'e59ae37c-e2d6-4094-8c48-3d53b56946a1', CAST(25.0700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (26, CAST(N'2021-03-06' AS Date), 22, 56, 1, N'f589e1c0-d4e2-42f8-91d3-886d2134d7ea', CAST(55.4000 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (27, CAST(N'2020-10-31' AS Date), 23, 51, 1, N'd2814476-8798-4b4b-ab7b-3d55c586f2af', CAST(122.3400 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (28, CAST(N'2021-04-21' AS Date), 24, 38, 1, N'f8f2acd4-44a9-46b6-9533-6cccb65fe05b', CAST(17.4800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (29, CAST(N'2020-12-25' AS Date), 25, 12, 1, N'55f8d8fd-c56c-4755-a153-6331fe8ee926', CAST(3.3800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (30, CAST(N'2021-01-30' AS Date), 26, 2, 1, N'ae793df6-7da1-4dc0-8a9c-30d1f988cad4', CAST(114.1300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (31, CAST(N'2021-02-22' AS Date), 27, 13, 1, N'f204d24e-ffbf-45ba-b306-8ad5de3a18e9', CAST(26.0800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (32, CAST(N'2021-03-26' AS Date), 28, 39, 1, N'29041582-3ea5-45f3-8ddb-81f4d91fcfa9', CAST(47.1200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (33, CAST(N'2021-03-26' AS Date), 29, 63, 1, N'70cbdae7-3e8a-4259-bdbc-90ed2aa7e930', CAST(64.8800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (34, CAST(N'2020-12-29' AS Date), 30, 6, 1, N'a80435d8-c39b-4ee3-a1e1-41aed3a56c72', CAST(45.7400 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (35, CAST(N'2021-01-24' AS Date), 31, 16, 1, N'e6fe0907-19a6-48e5-98a8-ad05e0f351ae', CAST(55.8700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (36, CAST(N'2020-11-28' AS Date), 32, 31, 1, N'7f98989b-4039-4225-8897-3e9a4469e131', CAST(11.8300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (37, CAST(N'2020-11-02' AS Date), 33, 14, 1, N'b56c4df4-7016-42d7-be90-df74b369d428', CAST(75.2300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (38, CAST(N'2020-06-06' AS Date), 34, 27, 1, N'6dfaa80d-b61e-4a15-a813-04151cd52abc', CAST(14.9600 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (39, CAST(N'2021-04-20' AS Date), 35, 22, 1, N'ecb4492e-b18b-49e9-a954-59a6a071a639', CAST(115.9200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (40, CAST(N'2020-01-24' AS Date), 36, 12, 1, N'c1343684-774d-444f-8e89-bf5e51c9923d', CAST(3.3800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (41, CAST(N'2021-03-04' AS Date), 37, 49, 1, N'588304ad-256f-42c7-bd35-a71c617e27f2', CAST(10.5100 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (42, CAST(N'2021-03-07' AS Date), 38, 36, 1, N'53d04c75-edd9-4545-8133-05ddc668eb75', CAST(113.5700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (43, CAST(N'2020-01-14' AS Date), 39, 33, 1, N'3af4840c-6c32-4f1d-8887-f8d91961cbd8', CAST(55.9500 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (44, CAST(N'2020-02-29' AS Date), 40, 2, 1, N'9eba1140-5ea4-453f-b690-c6ca6ef0b5fa', CAST(114.1300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (45, CAST(N'2020-11-19' AS Date), 41, 30, 1, N'1ef45fb1-b453-4c8f-a02f-45c62545dccc', CAST(57.9200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (46, CAST(N'2020-01-03' AS Date), 42, 31, 1, N'3ffdb37e-b143-4ac3-b7a2-bae34b382224', CAST(11.8300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (47, CAST(N'2021-03-28' AS Date), 43, 60, 1, N'ba986fa3-ed49-4d7c-965d-dba918f9625f', CAST(143.6300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (48, CAST(N'2021-03-27' AS Date), 45, 56, 1, N'ed5c7bc3-304b-4f34-95ef-ad773bd035d3', CAST(55.4000 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (49, CAST(N'2020-02-23' AS Date), 46, 17, 1, N'3febc841-aa2a-425e-a7ad-416d83af2d33', CAST(25.0700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (50, CAST(N'2020-07-12' AS Date), 47, 6, 1, N'b02a0c9d-bd04-465f-afe9-85b1b83ca0ba', CAST(45.7400 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (51, CAST(N'2020-09-11' AS Date), 48, 30, 1, N'a595cc84-9585-4538-bb24-b4c07759e5eb', CAST(57.9200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (52, CAST(N'2021-02-11' AS Date), 49, 34, 1, N'58840b8e-1274-44c2-9c40-26bd9aaa30d6', CAST(90.3100 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (53, CAST(N'2021-05-16' AS Date), 50, 52, 1, N'10a04b26-babc-4d3c-8640-525b72e0c27c', CAST(107.8300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (54, CAST(N'2020-03-25' AS Date), 51, 43, 1, N'de353e96-e793-4f8b-bf5f-47ba5d43252d', CAST(44.5200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (55, CAST(N'2021-02-23' AS Date), 52, 66, 1, N'd1efda3b-27b3-4337-8640-160641dbcd8a', CAST(0.0000 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (56, CAST(N'2020-02-23' AS Date), 53, 35, 1, N'facaaa3c-496f-4395-a27d-4f6b5c24b1c8', CAST(104.8600 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (57, CAST(N'2020-07-05' AS Date), 54, 4, 1, N'1359626f-8f95-47b3-a048-ce79b4621c1b', CAST(64.1400 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (58, CAST(N'2020-06-29' AS Date), 55, 20, 1, N'0464d254-d810-4e0a-9905-f8c2beb3eeff', CAST(33.2600 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (59, CAST(N'2020-05-22' AS Date), 56, 58, 1, N'db2433c5-35b4-4214-a99c-1ac3d28ac601', CAST(84.3700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (60, CAST(N'2021-04-17' AS Date), 57, 56, 1, N'3ee57f11-e847-4a3e-89e9-f5e35d37a32a', CAST(55.4000 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (61, CAST(N'2020-10-20' AS Date), 58, 35, 1, N'b44913b9-3cec-4680-aeac-697a4086e04a', CAST(104.8600 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (62, CAST(N'2020-11-12' AS Date), 59, 22, 1, N'12f9bf3d-fb51-4e46-8452-3307de369a94', CAST(115.9200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (63, CAST(N'2020-10-09' AS Date), 60, 57, 1, N'1a763dbe-4b53-4f8a-bc23-5345f61286e5', CAST(49.4700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (64, CAST(N'2021-05-13' AS Date), 61, 5, 1, N'487038f9-51aa-4786-a999-b085ba2ed2e9', CAST(12.3600 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (65, CAST(N'2021-04-11' AS Date), 62, 55, 1, N'd40f79ee-d1c1-4b3f-9ea3-67b208067c9e', CAST(33.6300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (66, CAST(N'2020-08-22' AS Date), 63, 19, 1, N'bfb4da9c-b37f-49db-8b44-7f4fabfb8b1f', CAST(29.9200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (67, CAST(N'2020-08-18' AS Date), 64, 12, 1, N'dce89f0d-bd11-4aa8-aeb8-546b7902f3ff', CAST(3.3800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (68, CAST(N'2020-11-07' AS Date), 65, 58, 1, N'5e8c8bcd-c398-48ae-925c-1997ff33adf6', CAST(84.3700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (69, CAST(N'2020-09-28' AS Date), 66, 46, 1, N'1d8b4c92-660b-47a7-b539-59fda0237436', CAST(17.4000 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (70, CAST(N'2021-03-18' AS Date), 3, 31, 1, N'124f26d2-c38d-4657-aae4-8463df61dfa8', CAST(11.8300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (71, CAST(N'2021-03-23' AS Date), 4, 36, 1, N'3bbcdac7-f906-4463-ba52-f489dfef12b8', CAST(113.5700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (72, CAST(N'2020-04-30' AS Date), 5, 15, 1, N'cfe383c2-7206-423b-807e-8b494a2d9f06', CAST(60.0600 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (73, CAST(N'2020-04-10' AS Date), 6, 23, 1, N'529d7a29-11d7-4e70-a683-f603ca7a6ec3', CAST(13.9800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (74, CAST(N'2020-09-17' AS Date), 7, 35, 1, N'4a10bb59-30cd-4dee-855b-ffb00e53e8ba', CAST(104.8600 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (75, CAST(N'2020-02-27' AS Date), 8, 63, 1, N'9ecfd8b5-07aa-4449-b4cf-ed8288ba11dd', CAST(64.8800 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (76, CAST(N'2020-01-02' AS Date), 9, 39, 1, N'e82061b7-180e-401b-b455-3ef4e5d90a2b', CAST(47.1200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (77, CAST(N'2021-04-25' AS Date), 10, 62, 1, N'4906707d-8dc6-4c97-9d1e-8813f763749a', CAST(94.0400 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (78, CAST(N'2020-03-15' AS Date), 11, 60, 1, N'2fa21508-9f39-4158-a964-7fb198464f4e', CAST(143.6300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (79, CAST(N'2020-06-02' AS Date), 12, 21, 1, N'a9127925-2629-479b-b294-c4cdf33706ea', CAST(50.4300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (80, CAST(N'2021-02-13' AS Date), 13, 29, 1, N'aa0c064e-6c2f-4ac2-911f-3450e8c4dd99', CAST(11.4200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (81, CAST(N'2020-09-27' AS Date), 15, 34, 1, N'76dc9da1-537b-4b09-aa96-c1ea4217022d', CAST(90.3100 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (82, CAST(N'2021-05-11' AS Date), 16, 20, 1, N'00ac1710-ab60-4d39-b076-1807162decde', CAST(33.2600 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (83, CAST(N'2021-12-24' AS Date), 17, 45, 1, N'f7014979-04d0-4eba-8ae5-f11ef4c9d241', CAST(75.3700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (84, CAST(N'2021-11-21' AS Date), 18, 40, 1, N'f5563a52-78df-4f41-98f5-2d5226a7f70a', CAST(57.5500 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (85, CAST(N'2020-09-11' AS Date), 19, 19, 1, N'27145733-0746-4d8d-8970-6df441e0153a', CAST(29.9200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (86, CAST(N'2020-10-25' AS Date), 20, 26, 1, N'41593d43-8e11-401d-9a62-314f898a883b', CAST(67.4700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (87, CAST(N'2020-09-13' AS Date), 21, 18, 1, N'748c5baa-627a-4773-8375-cbb00589a651', CAST(57.5500 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (88, CAST(N'2020-09-03' AS Date), 22, 51, 1, N'3b8a7ce4-e9d4-499c-8024-d2bf12ba9fc1', CAST(122.3400 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (89, CAST(N'2020-03-31' AS Date), 23, 54, 1, N'3011d225-f1af-4f8a-ba28-6c851efb1a9a', CAST(26.3900 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (90, CAST(N'2021-01-06' AS Date), 24, 34, 1, N'6426cc2e-f19a-49bf-b320-51755c38f181', CAST(90.3100 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (91, CAST(N'2021-02-08' AS Date), 25, 55, 1, N'a6e1a226-c426-4bf4-ba9e-7bd8f37fe018', CAST(33.6300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (92, CAST(N'2020-10-29' AS Date), 26, 28, 1, N'63d46ef6-038f-4833-94dd-63b24ed6d48d', CAST(100.4000 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (93, CAST(N'2020-12-01' AS Date), 28, 36, 1, N'332b4eaa-95e4-45eb-8c2d-325007e7b272', CAST(113.5700 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (94, CAST(N'2020-11-30' AS Date), 29, 55, 1, N'54c38815-6cf3-4aa5-838b-3f0e76b2e05a', CAST(33.6300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (95, CAST(N'2020-08-25' AS Date), 30, 30, 1, N'3af2c431-1c20-461c-ad80-5d6d99da5f89', CAST(57.9200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (96, CAST(N'2020-08-18' AS Date), 32, 34, 1, N'c0ea799f-3703-4516-a260-6560cc9d6108', CAST(90.3100 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (97, CAST(N'2020-12-02' AS Date), 33, 39, 1, N'5bc96d66-b118-4c40-aecd-2e97b240a567', CAST(47.1200 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (98, CAST(N'2020-06-26' AS Date), 34, 48, 1, N'4e20a2a7-30b0-4b0e-a307-5d73468de182', CAST(50.1300 AS Decimal(19, 4)))
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (99, CAST(N'2020-08-30' AS Date), 35, 31, 1, N'ed080249-e69a-48a7-9d5a-a5a483a017a1', CAST(11.8300 AS Decimal(19, 4)))
GO
INSERT [proj].[Purchases] ([ID], [Finalize_Date], [AppUser_ID], [Software_ID], [Store_ID], [SKU], [Cost]) VALUES (100, CAST(N'2021-01-01' AS Date), 36, 32, 1, N'699c46f5-0b69-43f2-9230-e01e7193960a', CAST(0.0000 AS Decimal(19, 4)))
SET IDENTITY_INSERT [proj].[Purchases] OFF
GO
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (1, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (1, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (1, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (2, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (2, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (2, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (3, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (3, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (3, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (3, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (4, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (5, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (5, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (5, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (6, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (6, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (6, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (7, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (8, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (8, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (8, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (9, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (10, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (10, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (11, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (11, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (12, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (12, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (12, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (13, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (13, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (14, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (14, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (14, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (15, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (15, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (16, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (16, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (16, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (16, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (17, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (17, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (18, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (18, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (19, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (19, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (19, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (20, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (20, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (20, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (21, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (21, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (21, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (22, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (22, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (23, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (23, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (24, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (24, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (25, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (25, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (25, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (26, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (26, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (26, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (27, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (27, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (27, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (28, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (28, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (28, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (29, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (29, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (29, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (30, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (30, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (30, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (31, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (31, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (31, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (32, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (32, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (33, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (33, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (33, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (34, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (34, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (35, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (35, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (35, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (36, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (37, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (37, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (37, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (38, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (38, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (39, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (39, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (40, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (40, N'Linux')
GO
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (40, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (41, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (41, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (41, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (41, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (42, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (43, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (43, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (43, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (44, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (45, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (45, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (45, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (46, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (46, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (47, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (47, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (47, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (48, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (49, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (49, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (49, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (49, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (50, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (50, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (50, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (51, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (51, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (51, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (52, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (52, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (52, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (53, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (53, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (53, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (54, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (55, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (56, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (56, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (56, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (57, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (57, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (58, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (58, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (59, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (59, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (60, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (60, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (61, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (61, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (61, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (62, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (63, N'Android')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (63, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (63, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (63, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (64, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (64, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (64, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (65, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (65, N'MS-Windows')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (66, N'Linux')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (66, N'Mac OS')
INSERT [proj].[SoftOS] ([Software_ID], [Supported_OS]) VALUES (66, N'MS-Windows')
GO
SET IDENTITY_INSERT [proj].[Software] ON 

INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (1, N'Lotstring', CAST(N'2014-08-05' AS Date), N'T', N'262496356')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (2, N'Asoka', CAST(N'2015-03-06' AS Date), N'T', N'262496356')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (3, N'Fixflex', CAST(N'2020-03-01' AS Date), N'G', N'262496356')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (4, N'Gembucket', CAST(N'2019-05-13' AS Date), N'T', N'262496356')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (5, N'Transcof', CAST(N'2006-01-12' AS Date), N'G', N'262496356')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (6, N'Hatity', CAST(N'2004-05-16' AS Date), N'G', N'262496356')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (7, N'Tampflex', CAST(N'2008-03-04' AS Date), N'T', N'262496356')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (8, N'Duobam', CAST(N'2013-04-14' AS Date), N'T', N'668142917')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (9, N'Domainer', CAST(N'2019-06-28' AS Date), N'G', N'668142917')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (10, N'Subin', CAST(N'2013-04-06' AS Date), N'T', N'668142917')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (11, N'Aerified', CAST(N'2017-10-25' AS Date), N'T', N'668142917')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (12, N'Alpha', CAST(N'2019-10-12' AS Date), N'G', N'649088570')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (13, N'Keylex', CAST(N'2014-03-08' AS Date), N'G', N'649088570')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (14, N'Treeflex', CAST(N'2018-04-27' AS Date), N'T', N'649088570')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (15, N'Span', CAST(N'2017-03-03' AS Date), N'G', N'649088570')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (16, N'Veribet', CAST(N'1984-10-29' AS Date), N'T', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (17, N'Bytecard', CAST(N'2010-05-26' AS Date), N'T', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (18, N'Konklux', CAST(N'2000-05-13' AS Date), N'T', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (19, N'Job', CAST(N'2001-10-13' AS Date), N'G', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (20, N'Latlux', CAST(N'1989-06-03' AS Date), N'G', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (21, N'Home Ing', CAST(N'1994-01-23' AS Date), N'T', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (22, N'Andalax', CAST(N'2007-01-14' AS Date), N'T', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (23, N'Sub-Ex', CAST(N'1999-06-17' AS Date), N'G', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (24, N'Sub-Filler', CAST(N'2017-03-15' AS Date), N'T', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (25, N'Flexidy', CAST(N'2020-08-28' AS Date), N'G', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (26, N'Mat Lam Tam', CAST(N'1995-12-06' AS Date), N'G', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (27, N'Cookley', CAST(N'2019-11-04' AS Date), N'T', N'516221301')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (28, N'Y-Solowarm', CAST(N'2019-03-04' AS Date), N'T', N'392464610')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (29, N'Box-Close', CAST(N'2017-12-03' AS Date), N'T', N'392464610')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (30, N'Pannier', CAST(N'2017-12-18' AS Date), N'G', N'392464610')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (31, N'Solarbreeze', CAST(N'2018-08-28' AS Date), N'T', N'392464610')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (32, N'Photo Shower', CAST(N'2013-03-21' AS Date), N'G', N'532383894')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (33, N'Zathin', CAST(N'2020-06-17' AS Date), N'G', N'532383894')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (34, N'Wrapsafe', CAST(N'2015-10-26' AS Date), N'T', N'532383894')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (35, N'Mistolen', CAST(N'2013-04-18' AS Date), N'T', N'532383894')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (36, N'Zontrax', CAST(N'2018-01-30' AS Date), N'T', N'532383894')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (37, N'Opela', CAST(N'2018-06-05' AS Date), N'G', N'532383894')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (38, N'Screen Safe', CAST(N'2010-02-21' AS Date), N'G', N'532383894')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (39, N'Tin', CAST(N'1986-12-25' AS Date), N'G', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (40, N'Phone Caller', CAST(N'1975-06-29' AS Date), N'G', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (41, N'Sonair', CAST(N'1972-02-02' AS Date), N'G', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (42, N'Flowlub', CAST(N'1996-05-22' AS Date), N'G', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (43, N'Lotlux', CAST(N'1991-03-09' AS Date), N'T', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (44, N'Bamity', CAST(N'1975-10-11' AS Date), N'T', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (45, N'Biodex', CAST(N'2004-11-27' AS Date), N'T', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (46, N'Key Log', CAST(N'2014-08-23' AS Date), N'T', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (47, N'Cardguard', CAST(N'1982-10-09' AS Date), N'T', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (48, N'Ping On', CAST(N'1982-04-03' AS Date), N'G', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (49, N'Bitchip', CAST(N'1992-06-10' AS Date), N'G', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (50, N'Overhold', CAST(N'1992-06-16' AS Date), N'T', N'915573914')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (51, N'Mouse Tap', CAST(N'2001-08-18' AS Date), N'T', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (52, N'Vagram', CAST(N'2020-06-05' AS Date), N'T', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (53, N'Wordder', CAST(N'2015-04-08' AS Date), N'G', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (54, N'Stopify', CAST(N'2012-12-01' AS Date), N'G', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (55, N'Alphazap', CAST(N'2018-03-09' AS Date), N'G', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (56, N'Samsun', CAST(N'1999-05-30' AS Date), N'G', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (57, N'EarInner', CAST(N'1992-08-20' AS Date), N'T', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (58, N'Sonsing', CAST(N'1998-07-13' AS Date), N'T', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (59, N'Zoolab', CAST(N'2005-07-06' AS Date), N'G', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (60, N'Tempsoft', CAST(N'2011-10-08' AS Date), N'T', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (61, N'Stronghold', CAST(N'2005-01-05' AS Date), N'G', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (62, N'Rank', CAST(N'1989-03-14' AS Date), N'T', N'718590525')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (63, N'Toast Go', CAST(N'2017-08-09' AS Date), N'G', N'446823285')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (64, N'Jobber', CAST(N'2019-03-25' AS Date), N'T', N'446823285')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (65, N'Rock Art', CAST(N'2013-09-16' AS Date), N'T', N'446823285')
INSERT [proj].[Software] ([ID], [Official_Name], [Release_Date], [Class], [Publisher_NIPC]) VALUES (66, N'Base Pad', CAST(N'2016-08-07' AS Date), N'G', N'446823285')
SET IDENTITY_INSERT [proj].[Software] OFF
GO
SET IDENTITY_INSERT [proj].[Store] ON 

INSERT [proj].[Store] ([ID], [Registered_Name]) VALUES (1, N'Loja Universal')
SET IDENTITY_INSERT [proj].[Store] OFF
GO
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 1, CAST(131.1700 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 2, CAST(114.1300 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 3, CAST(7.5100 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 4, CAST(64.1400 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 5, CAST(12.3600 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 6, CAST(45.7400 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 7, CAST(77.0000 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 8, CAST(73.4800 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 9, CAST(31.1800 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 10, CAST(51.0100 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 11, CAST(61.9000 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 12, CAST(3.3800 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 13, CAST(26.0800 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 14, CAST(75.2300 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 15, CAST(60.0600 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 16, CAST(55.8700 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 17, CAST(25.0700 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 18, CAST(57.5500 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 19, CAST(29.9200 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 20, CAST(33.2600 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 21, CAST(50.4300 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 22, CAST(115.9200 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 23, CAST(13.9800 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 24, CAST(86.9400 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 25, CAST(61.4000 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 26, CAST(67.4700 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 27, CAST(14.9600 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 32, CAST(0.0000 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 33, CAST(55.9500 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 34, CAST(90.3100 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 35, CAST(104.8600 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 37, CAST(43.0800 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 38, CAST(17.4800 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 39, CAST(47.1200 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 40, CAST(19.6700 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 41, CAST(3.7700 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 42, CAST(34.5700 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 45, CAST(75.3700 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 46, CAST(17.4000 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 47, CAST(78.5600 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 48, CAST(50.1300 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 49, CAST(10.5100 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 50, CAST(29.0000 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 51, CAST(122.3400 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 52, CAST(107.8300 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 56, CAST(55.4000 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 57, CAST(49.4700 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 58, CAST(84.3700 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 59, CAST(6.0400 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 60, CAST(143.6300 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 61, CAST(44.0100 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 62, CAST(94.0400 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 63, CAST(64.8800 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 64, CAST(70.5100 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 65, CAST(54.2900 AS Decimal(19, 4)))
INSERT [proj].[Store_Software] ([Store_ID], [Software_ID], [Price]) VALUES (1, 66, CAST(0.0000 AS Decimal(19, 4)))
GO
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (1, N'1.8.9', N'molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (2, N'0.9.5', N'')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (4, N'5.1.0', N'tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (7, N'9.9.5', N'rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (8, N'0.5.4', N'erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus ''a ut erat id mauris vulputate elementum ''am')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (10, N'9.4.4', N'quis orci ''am molestie nibh in lectus pellentesque at ''a suspendisse potenti cras in purus eu magna vulputate')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (11, N'1.3.3', N'donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet ''am orci pede venenatis non sodales sed tincidunt eu felis fusce')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (14, N'BETA', N'')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (16, N'0.3.4', N'in felis donec semper sapien a libero nam dui proin')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (17, N'0.7.9', N'auctor sed tristique in tempus sit amet sem fusce consequat ''a nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (18, N'BETA', N'eros viverra eget congue eget semper rutrum ''a nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (21, N'0.5.6', N'sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (22, N'BETA', N'leo odio porttitor id consequat in consequat ut ''a sed accumsan felis ut at dolor')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (24, N'0.1.0', N'platea dictumst etiam faucibus cursus urna ut tellus ''a ut erat')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (27, N'9.7.5', N'non mattis pulvinar ''a pede ullamcorper augue a suscipit ''a elit ac ''a sed vel enim sit amet')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (28, N'BETA', N'libero quis orci ''am molestie nibh in lectus pellentesque at ''a suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (29, N'0.4.2', N'ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (31, N'0.5.1', N'vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet ''am orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (34, N'6.2.5', N'morbi non lectus aliquam sit amet diam in magna bibendum')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (35, N'8.8.3', N'semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut ''a sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (36, N'0.1.9', N'non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel ''a eget eros elementum pellentesque quisque')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (43, N'9.5.4', N'quis libero ''am sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (44, N'0.8.7', N'ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet ''am orci pede venenatis')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (45, N'9.8.2', N'sit amet nunc viverra dapibus ''a suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet ''a quisque arcu libero rutrum ac')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (46, N'BETA', N'')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (47, N'0.7.0', N'quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (50, N'0.2.7', N'orci ''am molestie nibh in lectus pellentesque at ''a suspendisse potenti cras in purus eu magna')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (51, N'0.3.0', N'etiam faucibus cursus urna ut tellus ''a ut erat id mauris vulputate elementum ''am varius ''a facilisi cras non velit nec nisi vulputate')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (52, N'7.8.3', N'justo nec condimentum neque sapien placerat ante ''a justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (57, N'5.2.3', N'aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (58, N'5.1.3', N'in felis eu sapien cursus vestibulum proin eu mi ''a')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (60, N'8.1.2', N'nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id ''a ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (62, N'0.5.2', N'rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (64, N'3.1.7', N'tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat')
INSERT [proj].[Tool] ([Software_ID], [Current_Version], [Brief_Description]) VALUES (65, N'4.6.9', N'iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula')
GO
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (1, 2)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (1, 15)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (1, 32)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (1, 45)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (2, 57)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (2, 64)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (4, 37)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (8, 9)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (9, 49)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (12, 3)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (12, 23)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (13, 24)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (14, 4)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (18, 27)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (19, 37)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (20, 64)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (21, 64)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (30, 32)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (32, 18)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (37, 33)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (40, 65)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (44, 33)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (47, 58)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (50, 11)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (54, 61)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (59, 13)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (60, 66)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (61, 46)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (64, 3)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (74, 58)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (78, 23)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (80, 26)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (81, 56)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (90, 9)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (91, 3)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (99, 49)
INSERT [proj].[Wishlist] ([AppUser_ID], [Software_ID]) VALUES (100, 46)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__AppUser__A9D10534F4BBFA85]    Script Date: 22/06/2021 03:39:06 ******/
ALTER TABLE [proj].[AppUser] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IXUserQuery]    Script Date: 22/06/2021 03:39:06 ******/
CREATE NONCLUSTERED INDEX [IXUserQuery] ON [proj].[AppUser]
(
	[Email] ASC,
	[Fname] ASC,
	[Lname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IXItemName]    Script Date: 22/06/2021 03:39:06 ******/
CREATE NONCLUSTERED INDEX [IXItemName] ON [proj].[Item]
(
	[Item_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Item_Cat__B35EB419241402D0]    Script Date: 22/06/2021 03:39:06 ******/
ALTER TABLE [proj].[Item_Category] ADD UNIQUE NONCLUSTERED 
(
	[Category_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Publishe__685F8ADBBCF4C943]    Script Date: 22/06/2021 03:39:06 ******/
ALTER TABLE [proj].[Publisher] ADD UNIQUE NONCLUSTERED 
(
	[Legal_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IXIsAllowed]    Script Date: 22/06/2021 03:39:06 ******/
CREATE NONCLUSTERED INDEX [IXIsAllowed] ON [proj].[Publisher]
(
	[IsAllowed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IXPubName]    Script Date: 22/06/2021 03:39:06 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IXPubName] ON [proj].[Publisher]
(
	[Legal_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Purchase__CA1ECF0D1558981D]    Script Date: 22/06/2021 03:39:06 ******/
ALTER TABLE [proj].[Purchases] ADD UNIQUE NONCLUSTERED 
(
	[SKU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IXSKU]    Script Date: 22/06/2021 03:39:06 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IXSKU] ON [proj].[Purchases]
(
	[SKU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Software__80CFE8BD4084D67A]    Script Date: 22/06/2021 03:39:06 ******/
ALTER TABLE [proj].[Software] ADD UNIQUE NONCLUSTERED 
(
	[Official_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IXSoftName]    Script Date: 22/06/2021 03:39:06 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IXSoftName] ON [proj].[Software]
(
	[Official_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [proj].[AppUser] ADD  DEFAULT (' ') FOR [Sex]
GO
ALTER TABLE [proj].[AppUser] ADD  DEFAULT ((0)) FOR [Balance]
GO
ALTER TABLE [proj].[Authorization_List] ADD  DEFAULT ((1)) FOR [Store_ID]
GO
ALTER TABLE [proj].[Game] ADD  DEFAULT ('Non-Rated') FOR [Age_Rating]
GO
ALTER TABLE [proj].[Game] ADD  DEFAULT (' ') FOR [Brief_Description]
GO
ALTER TABLE [proj].[Game_Type] ADD  DEFAULT ('Uncategorized') FOR [Game_Type]
GO
ALTER TABLE [proj].[Item] ADD  DEFAULT (newid()) FOR [UUID]
GO
ALTER TABLE [proj].[Item] ADD  DEFAULT ((0.01)) FOR [Market_Value]
GO
ALTER TABLE [proj].[Item] ADD  DEFAULT ('N') FOR [ForSale]
GO
ALTER TABLE [proj].[Item_Category] ADD  DEFAULT ('0') FOR [CanBeSold]
GO
ALTER TABLE [proj].[Market_Items] ADD  DEFAULT ((1)) FOR [Market_ID]
GO
ALTER TABLE [proj].[Publisher] ADD  DEFAULT (getdate()) FOR [Found_Date]
GO
ALTER TABLE [proj].[Publisher] ADD  DEFAULT ('1') FOR [IsAllowed]
GO
ALTER TABLE [proj].[Purchase_Returns] ADD  DEFAULT (getdate()) FOR [Return_Date]
GO
ALTER TABLE [proj].[Purchases] ADD  DEFAULT (getdate()) FOR [Finalize_Date]
GO
ALTER TABLE [proj].[Purchases] ADD  DEFAULT ((1)) FOR [Store_ID]
GO
ALTER TABLE [proj].[Purchases] ADD  DEFAULT (newid()) FOR [SKU]
GO
ALTER TABLE [proj].[Purchases] ADD  DEFAULT ((0)) FOR [Cost]
GO
ALTER TABLE [proj].[Software] ADD  DEFAULT (getdate()) FOR [Release_Date]
GO
ALTER TABLE [proj].[Store_Software] ADD  DEFAULT ((1)) FOR [Store_ID]
GO
ALTER TABLE [proj].[Store_Software] ADD  DEFAULT ((1)) FOR [Price]
GO
ALTER TABLE [proj].[Tool] ADD  DEFAULT ('BETA') FOR [Current_Version]
GO
ALTER TABLE [proj].[Tool] ADD  DEFAULT (' ') FOR [Brief_Description]
GO
ALTER TABLE [proj].[Authorization_List]  WITH CHECK ADD  CONSTRAINT [FK_AuthorizationList_Publisher] FOREIGN KEY([Publisher_NIPC])
REFERENCES [proj].[Publisher] ([NIPC])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Authorization_List] CHECK CONSTRAINT [FK_AuthorizationList_Publisher]
GO
ALTER TABLE [proj].[Authorization_List]  WITH CHECK ADD  CONSTRAINT [FK_AuthorizationList_Store] FOREIGN KEY([Store_ID])
REFERENCES [proj].[Store] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Authorization_List] CHECK CONSTRAINT [FK_AuthorizationList_Store]
GO
ALTER TABLE [proj].[FriendsList]  WITH CHECK ADD  CONSTRAINT [FK_FriendsList_AppUser1] FOREIGN KEY([AppUser_ID1])
REFERENCES [proj].[AppUser] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[FriendsList] CHECK CONSTRAINT [FK_FriendsList_AppUser1]
GO
ALTER TABLE [proj].[Game]  WITH CHECK ADD  CONSTRAINT [FK_Game_Software] FOREIGN KEY([Software_ID])
REFERENCES [proj].[Software] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Game] CHECK CONSTRAINT [FK_Game_Software]
GO
ALTER TABLE [proj].[Game_Type]  WITH CHECK ADD  CONSTRAINT [FK_GameType_Game] FOREIGN KEY([Game_ID])
REFERENCES [proj].[Game] ([Software_ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Game_Type] CHECK CONSTRAINT [FK_GameType_Game]
GO
ALTER TABLE [proj].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_AppUser] FOREIGN KEY([AppUser_ID])
REFERENCES [proj].[AppUser] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Inventory] CHECK CONSTRAINT [FK_Inventory_AppUser]
GO
ALTER TABLE [proj].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_Item] FOREIGN KEY([Item_UUID])
REFERENCES [proj].[Item] ([UUID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Inventory] CHECK CONSTRAINT [FK_Inventory_Item]
GO
ALTER TABLE [proj].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_Category] FOREIGN KEY([Category])
REFERENCES [proj].[Item_Category] ([ID])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [proj].[Item] CHECK CONSTRAINT [FK_Item_Category]
GO
ALTER TABLE [proj].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_Game] FOREIGN KEY([Game_ID])
REFERENCES [proj].[Game] ([Software_ID])
ON DELETE SET NULL
GO
ALTER TABLE [proj].[Item] CHECK CONSTRAINT [FK_Item_Game]
GO
ALTER TABLE [proj].[Market_Items]  WITH CHECK ADD  CONSTRAINT [FK_MarketItems_Item] FOREIGN KEY([Item_UUID])
REFERENCES [proj].[Item] ([UUID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Market_Items] CHECK CONSTRAINT [FK_MarketItems_Item]
GO
ALTER TABLE [proj].[Market_Items]  WITH CHECK ADD  CONSTRAINT [FK_MarketItems_Market] FOREIGN KEY([Market_ID])
REFERENCES [proj].[Market] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Market_Items] CHECK CONSTRAINT [FK_MarketItems_Market]
GO
ALTER TABLE [proj].[Purchase_Returns]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseReturns_AppUser] FOREIGN KEY([AppUser_ID])
REFERENCES [proj].[AppUser] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Purchase_Returns] CHECK CONSTRAINT [FK_PurchaseReturns_AppUser]
GO
ALTER TABLE [proj].[Purchase_Returns]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseReturns_Purchases] FOREIGN KEY([Purchase_ID])
REFERENCES [proj].[Purchases] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Purchase_Returns] CHECK CONSTRAINT [FK_PurchaseReturns_Purchases]
GO
ALTER TABLE [proj].[Purchases]  WITH CHECK ADD  CONSTRAINT [FK_Purchases_AppUser] FOREIGN KEY([AppUser_ID])
REFERENCES [proj].[AppUser] ([ID])
ON DELETE SET NULL
GO
ALTER TABLE [proj].[Purchases] CHECK CONSTRAINT [FK_Purchases_AppUser]
GO
ALTER TABLE [proj].[Purchases]  WITH CHECK ADD  CONSTRAINT [FK_Purchases_Software] FOREIGN KEY([Software_ID])
REFERENCES [proj].[Software] ([ID])
ON DELETE SET NULL
GO
ALTER TABLE [proj].[Purchases] CHECK CONSTRAINT [FK_Purchases_Software]
GO
ALTER TABLE [proj].[Purchases]  WITH CHECK ADD  CONSTRAINT [FK_Purchases_StoreID] FOREIGN KEY([Store_ID])
REFERENCES [proj].[Store] ([ID])
ON DELETE SET NULL
GO
ALTER TABLE [proj].[Purchases] CHECK CONSTRAINT [FK_Purchases_StoreID]
GO
ALTER TABLE [proj].[SoftOS]  WITH CHECK ADD  CONSTRAINT [FK_SoftOS_Software] FOREIGN KEY([Software_ID])
REFERENCES [proj].[Software] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[SoftOS] CHECK CONSTRAINT [FK_SoftOS_Software]
GO
ALTER TABLE [proj].[Software]  WITH CHECK ADD  CONSTRAINT [FK_Software_Publisher] FOREIGN KEY([Publisher_NIPC])
REFERENCES [proj].[Publisher] ([NIPC])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [proj].[Software] CHECK CONSTRAINT [FK_Software_Publisher]
GO
ALTER TABLE [proj].[Store_Software]  WITH CHECK ADD  CONSTRAINT [FK_StoreSoftware_Software] FOREIGN KEY([Software_ID])
REFERENCES [proj].[Software] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Store_Software] CHECK CONSTRAINT [FK_StoreSoftware_Software]
GO
ALTER TABLE [proj].[Store_Software]  WITH CHECK ADD  CONSTRAINT [FK_StoreSoftware_Store] FOREIGN KEY([Store_ID])
REFERENCES [proj].[Store] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Store_Software] CHECK CONSTRAINT [FK_StoreSoftware_Store]
GO
ALTER TABLE [proj].[Tool]  WITH CHECK ADD  CONSTRAINT [FK_Tool_Software] FOREIGN KEY([Software_ID])
REFERENCES [proj].[Software] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Tool] CHECK CONSTRAINT [FK_Tool_Software]
GO
ALTER TABLE [proj].[Wishlist]  WITH CHECK ADD  CONSTRAINT [FK_Wishlist_AppUser] FOREIGN KEY([AppUser_ID])
REFERENCES [proj].[AppUser] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Wishlist] CHECK CONSTRAINT [FK_Wishlist_AppUser]
GO
ALTER TABLE [proj].[Wishlist]  WITH CHECK ADD  CONSTRAINT [FK_Wishlist_Software] FOREIGN KEY([Software_ID])
REFERENCES [proj].[Software] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [proj].[Wishlist] CHECK CONSTRAINT [FK_Wishlist_Software]
GO
ALTER TABLE [proj].[AppUser]  WITH CHECK ADD CHECK  (([Balance]>=(0)))
GO
ALTER TABLE [proj].[AppUser]  WITH CHECK ADD CHECK  (([Sex]='M' OR [Sex]='F' OR [Sex]=' '))
GO
ALTER TABLE [proj].[FriendsList]  WITH CHECK ADD CHECK  (([AppUser_ID1]<>[AppUser_ID2]))
GO
ALTER TABLE [proj].[Game]  WITH CHECK ADD CHECK  (([Age_Rating]='Non-Rated' OR [Age_Rating]='A' OR [Age_Rating]='M' OR [Age_Rating]='T' OR [Age_Rating]='E'))
GO
ALTER TABLE [proj].[Item]  WITH CHECK ADD CHECK  (([ForSale]='N' OR [ForSale]='Y'))
GO
ALTER TABLE [proj].[Item]  WITH CHECK ADD CHECK  (([Market_Value]>=(0.01)))
GO
ALTER TABLE [proj].[Item]  WITH CHECK ADD CHECK  (([Rarity]>=(0) AND [Rarity]<=(5)))
GO
ALTER TABLE [proj].[Publisher]  WITH CHECK ADD CHECK  ((len([NIPC])=(9) AND isnumeric([NIPC])='1'))
GO
ALTER TABLE [proj].[Purchases]  WITH CHECK ADD CHECK  (([Cost]>=(0)))
GO
ALTER TABLE [proj].[Software]  WITH CHECK ADD CHECK  (([Class]='G' OR [Class]='T'))
GO
ALTER TABLE [proj].[Store_Software]  WITH CHECK ADD CHECK  (([Price]>=(0)))
GO
/****** Object:  StoredProcedure [proj].[addAuthorizationList]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[addAuthorizationList](@Publisher_NIPC CHAR(9))
AS
	BEGIN TRANSACTION
		UPDATE proj.Publisher SET IsAllowed='1' WHERE NIPC=@Publisher_NIPC;
		INSERT INTO proj.Authorization_List VALUES ('1', @Publisher_NIPC);
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[addBalance]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[addBalance](@AppUser_ID INT, @Value DECIMAL(19, 4))
AS
	DECLARE @User_Balance AS DECIMAL(19, 4);
	SET @User_Balance = (SELECT Balance FROM proj.AppUser WHERE ID=@AppUser_ID);

	DECLARE @New_Balance AS DECIMAL(19, 4);
	SET @New_Balance = @User_Balance + @Value;

	UPDATE proj.AppUser SET Balance=@New_Balance WHERE ID=@AppUser_ID;
GO
/****** Object:  StoredProcedure [proj].[addFriend]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[addFriend](@AppUser_ID1 INT, @AppUser_ID2 INT) 
AS
	BEGIN TRANSACTION
		INSERT INTO proj.FriendsList(AppUser_ID1, AppUser_ID2) VALUES (@Appuser_ID1, @AppUser_ID2);
		INSERT INTO proj.FriendsList(AppUser_ID1, AppUser_ID2) VALUES (@Appuser_ID2, @AppUser_ID1);
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[addStore_Software]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;


--------------------------------ADICIONAR-----------------------------
CREATE PROC [proj].[addStore_Software](@Software_ID INT, @Price DECIMAL(19, 4))
AS	
	INSERT INTO proj.Store_Software(Software_ID, Price) VALUES (@Software_ID, @Price);
GO
/****** Object:  StoredProcedure [proj].[addWishlist]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[addWishlist](@AppUser_ID INT, @Software_ID INT)
AS
	INSERT INTO proj.Wishlist(AppUser_ID, Software_ID) VALUES (@Appuser_ID, @Software_ID);
GO
/****** Object:  StoredProcedure [proj].[buyMarketItem]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[buyMarketItem](@Buyer_ID INT, @Item_UUID NVARCHAR(50))
AS
	DECLARE @Cost AS DECIMAL(19, 4);
	SET @Cost = (SELECT Market_Value FROM proj.Market_Items INNER JOIN proj.Item ON proj.Market_Items.Item_UUID=proj.Item.UUID WHERE proj.Market_Items.Item_UUID=@Item_UUID);

	DECLARE @Buyer_Balance AS DECIMAL(19, 4);
	SET @Buyer_Balance = (SELECT Balance FROM proj.AppUser WHERE ID=@Buyer_ID);

	DECLARE @Seller_ID AS INT;
	SET @Seller_ID = (SELECT AppUser_ID FROM proj.Inventory WHERE Item_UUID=@Item_UUID);

	DECLARE @Seller_Balance AS DECIMAL(19, 4);
	SET @Seller_Balance = (SELECT Balance FROM proj.AppUser WHERE ID=@Seller_ID);

	IF(@Buyer_Balance >= @Cost)
		BEGIN
			DECLARE @Buyer_New_Balance AS DECIMAL(19, 4);
			SET @Buyer_New_Balance = @Buyer_Balance - @Cost;

			DECLARE @Seller_New_Balance AS DECIMAL(19, 4);
			SET @Seller_New_Balance = @Seller_Balance + @Cost;
				
			BEGIN TRANSACTION
				DELETE FROM proj.Inventory WHERE Item_UUID=@Item_UUID;
				INSERT INTO proj.Inventory(AppUser_ID, Item_UUID) VALUES (@Buyer_ID, @Item_UUID);
				UPDATE proj.AppUser SET Balance=@Buyer_New_Balance WHERE ID=@Buyer_ID;
				UPDATE proj.AppUser SET Balance=@Seller_New_Balance WHERE ID=@Seller_ID;
				DELETE FROM proj.Market_Items WHERE Item_UUID=@Item_UUID;
				UPDATE proj.Item SET ForSale = 'N' WHERE UUID=@Item_UUID;
			COMMIT TRANSACTION
		END
	ELSE
		RAISERROR('A compra nao foi concluida', 16, 1);
GO
/****** Object:  StoredProcedure [proj].[buySoftware]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;


--------------------------------VARIOS-------------------------------
CREATE PROC [proj].[buySoftware](@AppUser_ID INT, @Software_ID INT)
AS
		DECLARE @Cost AS DECIMAL(19, 4);
		SET @Cost = (SELECT Price FROM proj.Store_Software WHERE Software_ID=@Software_ID);

		DECLARE @User_Balance AS DECIMAL(19, 4);
		SET @User_Balance = (SELECT Balance FROM proj.AppUser WHERE ID=@AppUser_ID);

		IF(@User_Balance >= @Cost)
			BEGIN 
				DECLARE @New_Balance AS DECIMAL(19, 4);
				SET @New_Balance = @User_Balance - @Cost;
				BEGIN TRANSACTION
					INSERT INTO proj.Purchases(AppUser_ID, Software_ID, Cost) VALUES (@AppUser_ID, @Software_ID, @Cost);
					UPDATE proj.AppUser SET Balance=@New_Balance WHERE ID=@AppUser_ID;
					DELETE FROM proj.Wishlist WHERE (AppUser_ID=@Appuser_ID) AND (Software_ID=@Software_ID);
				COMMIT TRANSACTION
			END
		ELSE
			RAISERROR('A compra nao foi concluida', 16, 1);
GO
/****** Object:  StoredProcedure [proj].[createAppUser]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;


--------------------------------CRIAR-------------------------------
CREATE PROC [proj].[createAppUser](@Email NVARCHAR(128), @Fname NVARCHAR(64), @Lname NVARCHAR(64), @Birthdate DATE, @Sex NVARCHAR(1), @Street NVARCHAR(255), @Postcode NVARCHAR(64), @City NVARCHAR(255), @Country NVARCHAR(32))
AS
	DECLARE @Balance Decimal(19, 4);
	SET @Balance = 0;
	INSERT INTO proj.AppUser(Email, Fname, Lname, Birthdate, Sex, Street, Postcode, City, Country, Balance) VALUES(@Email, @Fname, @Lname, @Birthdate, @Sex, @Street, @Postcode, @City, @Country, @Balance);
GO
/****** Object:  StoredProcedure [proj].[createGame]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[createGame](@Official_Name NVARCHAR(255), @Release_Date DATE, @Publisher_NIPC CHAR(9), @Age_Rating NVARCHAR(9), @Brief_Description NVARCHAR(255), @Game_Type NVARCHAR(1024), @SupportedOS NVARCHAR(1024))
AS		
	BEGIN TRANSACTION
		INSERT INTO proj.Software VALUES (@Official_Name, @Release_Date, 'G', @Publisher_NIPC);

		DECLARE @Soft_ID AS INT;
		SET @Soft_ID = SCOPE_IDENTITY();
		INSERT INTO proj.Game VALUES (@Soft_ID, @Age_Rating, @Brief_Description);
		
		DECLARE @Separador AS NVARCHAR(1);
		SET @Separador = ',';

		DECLARE @SP1 INT;
		DECLARE @SP2 INT;
		DECLARE @TypeValue NVARCHAR(255);
		DECLARE @OSValue NVARCHAR(255);

		--Adicionar a tabela proj.Game_Type os tuplos (Game_ID, Game_Type) correspondentes ao novo Jogo criado
		WHILE PATINDEX('%' + @Separador + '%', @Game_Type ) <> 0
			BEGIN
				SELECT  @SP1 = PATINDEX('%' + @Separador + '%', @Game_Type);
				SELECT  @TypeValue = LEFT(@Game_Type , @SP1 - 1);
				SELECT  @Game_Type = STUFF(@Game_Type, 1, @SP1, '');
				INSERT INTO proj.Game_Type VALUES (@Soft_ID, @TypeValue);
			END

		--Adicionar a tabela proj.SoftOS os tuplos (Software_ID, Supported_OS) correspondentes ao novo Jogo criado
		WHILE PATINDEX('%' + @Separador + '%', @SupportedOS ) <> 0
			BEGIN
				SELECT  @SP2 = PATINDEX('%' + @Separador + '%', @SupportedOS);
				SELECT  @OSValue = LEFT(@SupportedOS , @SP2 - 1);
				SELECT  @SupportedOS = STUFF(@SupportedOS, 1, @SP2, '');
				INSERT INTO proj.SoftOS VALUES (@Soft_ID, @OSValue);
			END
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[createItem]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[createItem](@Item_Name NVARCHAR(64), @Rarity INT, @Market_Value	DECIMAL(19, 4), @Category INT, @Game_ID INT, @AppUser_ID INT)
AS
	IF(@Category IN('2', '3', '4')) --Se pertencer a uma categoria que pode ser vendida
		BEGIN
			BEGIN TRANSACTION
				INSERT INTO proj.Item(Item_Name, Rarity, Market_Value, Category, Game_ID) VALUES (@Item_Name, @Rarity, @Market_Value, @Category, @Game_ID);
				
				DECLARE @Item_UUID1 NVARCHAR(64);
				SET @Item_UUID1 = (SELECT UUID 
									FROM proj.Item LEFT JOIN proj.Inventory ON proj.Item.UUID=proj.Inventory.Item_UUID
									WHERE proj.Inventory.Item_UUID IS NULL);
				INSERT INTO proj.Inventory VALUES (@Appuser_ID, @Item_UUID1);
			COMMIT TRANSACTION
		END	
	ELSE
		BEGIN
			BEGIN TRANSACTION
				INSERT INTO proj.Item(Item_Name, Rarity, Market_Value, Category, Game_ID) VALUES (@Item_Name, @Rarity, NULL, @Category, @Game_ID);
				
				DECLARE @Item_UUID2 NVARCHAR(64);
				SET @Item_UUID2 = (SELECT UUID 
									FROM proj.Item LEFT JOIN proj.Inventory ON proj.Item.UUID=proj.Inventory.Item_UUID
									WHERE proj.Inventory.Item_UUID IS NULL);
				INSERT INTO proj.Inventory VALUES (@Appuser_ID, @Item_UUID2);
			COMMIT TRANSACTION
		END	
GO
/****** Object:  StoredProcedure [proj].[createPublisher]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[createPublisher](@NIPC CHAR(9), @Legal_Name NVARCHAR(255), @Street NVARCHAR(255), @Postcode NVARCHAR(64), @City NVARCHAR(255), @Country NVARCHAR(32), @Found_Date DATE, @IsAllowed BIT)
AS
	INSERT INTO proj.Publisher VALUES (@NIPC, @Legal_Name, @Street, @Postcode, @City, @Country, @Found_Date, @IsAllowed);
GO
/****** Object:  StoredProcedure [proj].[createTool]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[createTool](@Official_Name NVARCHAR(255), @Release_Date DATE, @Publisher_NIPC CHAR(9), @Current_Version	NVARCHAR(64), @Brief_Description NVARCHAR(255), @SupportedOS NVARCHAR(1024))
AS
	BEGIN TRANSACTION
		INSERT INTO proj.Software VALUES (@Official_Name, @Release_Date, 'T', @Publisher_NIPC);

		DECLARE @Soft_ID AS INT;
		SET @Soft_ID = SCOPE_IDENTITY();
		INSERT INTO proj.Tool VALUES (@Soft_ID, @Current_Version, @Brief_Description);

		DECLARE @Separador AS NVARCHAR(1);
		SET @Separador = ',';

		DECLARE @SP1 INT;
		DECLARE @OSValue NVARCHAR(255);

		--Adicionar a tabela proj.SoftOS os tuplos (Software_ID, Supported_OS) correspondentes a nova Aplicação criada
		WHILE PATINDEX('%' + @Separador + '%', @SupportedOS ) <> 0
			BEGIN
				SELECT  @SP1 = PATINDEX('%' + @Separador + '%', @SupportedOS);
				SELECT  @OSValue = LEFT(@SupportedOS , @SP1 - 1);
				SELECT  @SupportedOS = STUFF(@SupportedOS, 1, @SP1, '');
				INSERT INTO proj.SoftOS VALUES (@Soft_ID, @OSValue);
			END
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[deleteAppUser]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[deleteAppUser](@AppUser_ID INT) 
AS	
	BEGIN TRANSACTION
		DELETE FROM proj.AppUser WHERE ID = @AppUser_ID;
		DELETE FROM proj.Item WHERE UUID IN(SELECT	Item_UUID 
											FROM	proj.Inventory
											WHERE	AppUser_ID=@AppUser_ID);
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[deleteGame]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[deleteGame](@Software_ID INT)
AS	
	DELETE FROM proj.Game WHERE Software_ID = @Software_ID;
GO
/****** Object:  StoredProcedure [proj].[deleteItem]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[deleteItem](@UUID NVARCHAR(50), @AppUser_ID INT)
AS	
	DECLARE @Market_Value DECIMAL(19, 4);
	SET @Market_Value = (SELECT Market_Value FROM proj.Item WHERE UUID=@UUID);

	IF (@Market_Value IS NOT NULL)
		BEGIN
			DECLARE @OldBalance DECIMAL(19, 4);
			SELECT @OldBalance = Balance FROM proj.AppUser WHERE ID=@AppUser_ID;

			DECLARE @NewBalance DECIMAL(19, 4);
			SET @NewBalance = @OldBalance+@Market_Value;

			BEGIN TRANSACTION
				DELETE FROM proj.Item WHERE UUID = @UUID;
				UPDATE proj.AppUser SET Balance=@NewBalance WHERE ID=@AppUser_ID;
			COMMIT TRANSACTION
		END
	ELSE
		DELETE FROM proj.Item WHERE UUID = @UUID;
GO
/****** Object:  StoredProcedure [proj].[deletePublisher]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;


--------------------------------APAGAR-------------------------------
CREATE PROC [proj].[deletePublisher](@Publisher_NIPC CHAR(9)) 
AS
	BEGIN TRANSACTION
		DELETE FROM proj.Wishlist WHERE Software_ID IN (SELECT		ID
														FROM	proj.Software
														WHERE	Publisher_NIPC=@Publisher_NIPC);
		DELETE FROM proj.Publisher WHERE NIPC=@Publisher_NIPC;
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[deleteTool]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[deleteTool](@Software_ID INT) 
AS	
	DELETE FROM proj.Tool WHERE Software_ID = @Software_ID;
GO
/****** Object:  StoredProcedure [proj].[editAppUser]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[editAppUser](@AppUser_ID INT, @Email NVARCHAR(128), @Fname NVARCHAR(64), @Lname NVARCHAR(64), @Birthdate DATE, @Sex NVARCHAR(1), @Street NVARCHAR(255), @Postcode NVARCHAR(64), @City NVARCHAR(255), @Country NVARCHAR(32))
AS
	UPDATE proj.AppUser SET Email=@Email, Fname=@Fname, Lname=@Lname, Birthdate=@Birthdate, Sex=@Sex, Street=@Street, Postcode=@Postcode, City=@City, Country=@Country WHERE ID=@AppUser_ID;
GO
/****** Object:  StoredProcedure [proj].[editGame]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[editGame](@Software_ID INT, @Official_Name NVARCHAR(255), @Release_Date DATE, @Age_Rating NVARCHAR(9), @Brief_Description NVARCHAR(255), @Game_Type NVARCHAR(1024), @SupportedOS NVARCHAR(1024))
AS
	BEGIN TRANSACTION
		UPDATE proj.Game SET Age_Rating=@Age_Rating, Brief_Description=@Brief_Description WHERE Software_ID=@Software_ID;
		UPDATE proj.Software SET Official_Name=@Official_Name, Release_Date=@Release_Date WHERE ID=@Software_ID;
		DELETE FROM proj.Game_Type WHERE Game_ID=@Software_ID;
		DELETE FROM proj.SoftOS WHERE Software_ID=@Software_ID;
		
		DECLARE @Separador AS NVARCHAR(1);
		SET @Separador = ',';
		DECLARE @SP1 INT;
		DECLARE @SP2 INT;
		DECLARE @TypeValue NVARCHAR(255);
		DECLARE @OSValue NVARCHAR(255);

		--Adicionar a tabela proj.Game_Type os tuplos (Game_ID, Game_Type) correspondentes ao novo Jogo
		WHILE PATINDEX('%' + @Separador + '%', @Game_Type ) <> 0
			BEGIN
				SELECT  @SP1 = PATINDEX('%' + @Separador + '%', @Game_Type);
				SELECT  @TypeValue = LEFT(@Game_Type , @SP1 - 1);
				SELECT  @Game_Type = STUFF(@Game_Type, 1, @SP1, '');
				INSERT INTO proj.Game_Type VALUES (@Software_ID, @TypeValue);
			END
		
		--Adicionar a tabela proj.SoftOS os tuplos (Software_ID, Supported_OS) correspondentes ao Jogo 
		WHILE PATINDEX('%' + @Separador + '%', @SupportedOS ) <> 0
			BEGIN
				SELECT  @SP2 = PATINDEX('%' + @Separador + '%', @SupportedOS);
				SELECT  @OSValue = LEFT(@SupportedOS , @SP2 - 1);
				SELECT  @SupportedOS = STUFF(@SupportedOS, 1, @SP2, '');
				INSERT INTO proj.SoftOS VALUES (@Software_ID, @OSValue);
			END
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[editItem]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[editItem](@UUID NVARCHAR(50), @Item_Name NVARCHAR(64), @Rarity INT, @Market_Value DECIMAL(19, 4), @Category INT, @Game_ID INT, @AppUser_ID INT)
AS
	IF(@Category IN('2', '3', '4')) --Se pertencer a uma categoria que pode ser vendida
		UPDATE proj.Item SET Item_Name=@Item_Name, Rarity=@Rarity, Market_Value=@Market_Value, Category=@Category, Game_ID=@Game_ID WHERE UUID=@UUID;
	ELSE
		UPDATE proj.Item SET Item_Name=@Item_Name, Rarity=@Rarity, Market_Value=NULL, Category=@Category, Game_ID=@Game_ID WHERE UUID=@UUID;
GO
/****** Object:  StoredProcedure [proj].[editPublisher]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[editPublisher](@CurrentNIPC CHAR(9), @NewNIPC CHAR(9), @Legal_Name	NVARCHAR(255), @Street NVARCHAR(255), @Postcode NVARCHAR(64), @City	NVARCHAR(255), @Country	NVARCHAR(32), @IsAllowed BIT)
AS
	UPDATE proj.Publisher SET NIPC=@NewNIPC, Legal_Name=@Legal_Name, Street=@Street, Postcode=@Postcode, City=@City, Country=@Country, IsAllowed=@IsAllowed WHERE NIPC=@CurrentNIPC;
GO
/****** Object:  StoredProcedure [proj].[editSoftwarePrice]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;


--------------------------------EDITAR-------------------------------
CREATE PROC [proj].[editSoftwarePrice](@Software_ID INT, @New_Price DECIMAL(19, 4))
AS
	UPDATE proj.Store_Software SET Price=@New_Price WHERE Software_ID=@Software_ID;
GO
/****** Object:  StoredProcedure [proj].[editTool]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[editTool](@Software_ID INT, @Official_Name NVARCHAR(255), @Release_Date DATE, @Current_Version NVARCHAR(9), @Brief_Description NVARCHAR(255), @SupportedOS NVARCHAR(1024))
AS
	BEGIN TRANSACTION
		UPDATE proj.Tool SET Current_Version=@Current_Version, Brief_Description=@Brief_Description WHERE Software_ID=@Software_ID;
		UPDATE proj.Software SET Official_Name=@Official_Name, Release_Date=@Release_Date WHERE ID=@Software_ID;
		DELETE FROM proj.SoftOS WHERE Software_ID=@Software_ID;
		
		DECLARE @Separador AS NVARCHAR(1);
		SET @Separador = ',';
		DECLARE @SP1 INT;
		DECLARE @OSValue NVARCHAR(255);

		--Adicionar a tabela proj.SoftOS os tuplos (Software_ID, Supported_OS) correspondentes a Aplicacao
		WHILE PATINDEX('%' + @Separador + '%', @SupportedOS ) <> 0
			BEGIN
				SELECT  @SP1 = PATINDEX('%' + @Separador + '%', @SupportedOS);
				SELECT  @OSValue = LEFT(@SupportedOS , @SP1 - 1);
				SELECT  @SupportedOS = STUFF(@SupportedOS, 1, @SP1, '');
				INSERT INTO proj.SoftOS VALUES (@Software_ID, @OSValue);
			END
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[removeAuthorizationList]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[removeAuthorizationList](@Publisher_NIPC CHAR(9))
AS
	BEGIN TRANSACTION
		DELETE FROM proj.Wishlist WHERE Software_ID IN (SELECT	Software_ID 
														FROM	proj.Wishlist	INNER JOIN proj.Software ON proj.Wishlist.Software_ID=proj.Software.ID
																				INNER JOIN proj.Publisher ON proj.Software.Publisher_NIPC=proj.Publisher.NIPC
														WHERE	proj.Software.Publisher_NIPC=@Publisher_NIPC);

		DELETE FROM proj.Store_Software WHERE Software_ID IN (SELECT	Software_ID 
																FROM	proj.Store_Software INNER JOIN proj.Software ON proj.Store_Software.Software_ID=proj.Software.ID
																							INNER JOIN proj.Publisher ON proj.Software.Publisher_NIPC = proj.Publisher.NIPC
																WHERE	proj.Publisher.NIPC = @Publisher_NIPC);

		DELETE FROM proj.Authorization_List WHERE Publisher_NIPC=@Publisher_NIPC;
		UPDATE proj.Publisher SET IsAllowed='0' WHERE NIPC=@Publisher_NIPC;
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[removeFriend]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[removeFriend](@AppUser_ID1 INT, @AppUser_ID2 INT)
AS	
	BEGIN TRANSACTION
		DELETE FROM proj.FriendsList WHERE (AppUser_ID1 = @AppUser_ID1) AND (AppUser_ID2 = @AppUser_ID2);
		DELETE FROM proj.FriendsList WHERE (AppUser_ID1 = @AppUser_ID2) AND (AppUser_ID2 = @AppUser_ID1);
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[removeItemFromMarket]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[removeItemFromMarket](@Item_UUID NVARCHAR(50))
AS
	BEGIN TRANSACTION
		DELETE FROM proj.Market_Items WHERE Item_UUID=@Item_UUID;
		UPDATE proj.Item SET ForSale = 'N' WHERE UUID=@Item_UUID;
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[removeStoreSoftware]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;


-----------------------------REMOVER-------------------------------
CREATE PROC [proj].[removeStoreSoftware](@Software_ID INT)
AS
	BEGIN TRANSACTION
		DELETE FROM proj.Wishlist WHERE Software_ID=@Software_ID;
		DELETE FROM proj.Store_Software WHERE Software_ID=@Software_ID;
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[removeWishlist]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[removeWishlist](@AppUser_ID INT, @Software_ID INT)
AS
	DELETE FROM proj.Wishlist WHERE (AppUser_ID=@Appuser_ID) AND (Software_ID=@Software_ID);
GO
/****** Object:  StoredProcedure [proj].[returnSoftware]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[returnSoftware](@AppUser_ID INT, @Software_SKU NVARCHAR(50))
AS
	DECLARE @Purchase_ID AS INT;
	SET @Purchase_ID = (SELECT ID FROM proj.Purchases WHERE SKU=@Software_SKU);

	DECLARE @Cost AS DECIMAL(19, 4);
	SET @Cost = (SELECT Cost FROM proj.Purchases WHERE SKU=@Software_SKU);

	DECLARE @User_Balance AS DECIMAL(19, 4);
	SET @User_Balance = (SELECT Balance FROM proj.AppUser WHERE ID=@AppUser_ID);

	DECLARE @New_Balance AS DECIMAL(19, 4);
	SET @New_Balance = @User_Balance + @Cost;

	BEGIN TRANSACTION
		INSERT INTO proj.Purchase_Returns(Purchase_ID, AppUser_ID) VALUES (@Purchase_ID, @AppUser_ID);
		UPDATE proj.AppUser SET Balance=@New_Balance WHERE ID=@AppUser_ID;
	COMMIT TRANSACTION
GO
/****** Object:  StoredProcedure [proj].[searchAppUser]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

-------------------------------QUERIES-------------------------------
CREATE PROC [proj].[searchAppUser](@StringFind NVARCHAR(128))
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%'; --retirar trailing spaces
	SELECT	* 
	FROM	proj.AppUser
	WHERE	(ID LIKE @StringFind) OR (Email LIKE @StringFind)  OR (Fname LIKE @StringFind) OR (Lname LIKE @StringFind);
GO
/****** Object:  StoredProcedure [proj].[searchGame]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[searchGame](@Publisher_NIPC INT, @StringFind NVARCHAR(255))
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%';  --retirar trailing spaces
	SELECT	* 
	FROM	proj.getGamesByPublisher(@Publisher_NIPC)
	WHERE	(ID LIKE @StringFind) OR (Official_Name LIKE @StringFind);
GO
/****** Object:  StoredProcedure [proj].[searchItem]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[searchItem](@StringFind NVARCHAR(255))
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%';  --retirar trailing spaces
	SELECT	* 
	FROM	proj.Show_All_Items
	WHERE	(UUID LIKE @StringFind) OR (Item_Name LIKE @StringFind);
GO
/****** Object:  StoredProcedure [proj].[searchNonFriend]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[searchNonFriend](@AppUser_ID INT, @StringFind NVARCHAR(128))
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%';  --retirar trailing spaces
	SELECT	* 
	FROM	proj.getNotFriendsWithByUserID(@AppUser_ID) 
	WHERE	(ID LIKE @StringFind) OR (Email LIKE @StringFind)  OR (Fname LIKE @StringFind) OR (Lname LIKE @StringFind);
GO
/****** Object:  StoredProcedure [proj].[searchPublisher]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[searchPublisher](@StringFind NVARCHAR(255))
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%';  --retirar trailing spaces
	SELECT	* 
	FROM	proj.Publisher 
	WHERE	(NIPC LIKE @StringFind)  OR (Legal_Name LIKE @StringFind);
GO
/****** Object:  StoredProcedure [proj].[searchRandomUserID]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[searchRandomUserID](@User_ID INT OUTPUT)
AS
	SELECT @User_ID = (SELECT TOP 1 ID 
						FROM		proj.AppUser
						ORDER BY	NEWID());
GO
/****** Object:  StoredProcedure [proj].[searchTool]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[searchTool](@Publisher_NIPC INT, @StringFind NVARCHAR(255))
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%';  --retirar trailing spaces
	SELECT	* 
	FROM	proj.getToolsByPublisher(@Publisher_NIPC)
	WHERE	(ID LIKE @StringFind) OR (Official_Name LIKE @StringFind);
GO
/****** Object:  StoredProcedure [proj].[sellMarketItem]    Script Date: 22/06/2021 03:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE PROC [proj].[sellMarketItem](@Item_UUID NVARCHAR(50))
AS
		DECLARE @CanBeSold AS BIT;
		SET @CanBeSold = (SELECT CanBeSold FROM proj.Item INNER JOIN proj.Item_Category ON proj.Item.Category=proj.Item_Category.ID WHERE proj.Item.UUID=@Item_UUID);

		IF(@CanBeSold = '1')
			BEGIN
				BEGIN TRANSACTION
					INSERT INTO proj.Market_Items VALUES ('1', @Item_UUID);
					UPDATE proj.Item SET ForSale = 'Y' WHERE UUID=@Item_UUID;
				COMMIT TRANSACTION
			END
		ELSE
			RAISERROR('Artigo não pode ser colocado a venda', 16, 1);
GO
USE [master]
GO
ALTER DATABASE [p1g6] SET  READ_WRITE 
GO
