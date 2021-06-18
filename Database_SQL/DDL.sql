IF NOT EXISTS( SELECT	* 
				FROM	sys.databases 
				WHERE	name = 'p1g6')
	BEGIN
		CREATE DATABASE p1g6;
	END
GO
;

USE p1g6;
GO
;

IF NOT EXISTS (SELECT	*
                FROM    sys.schemas
                WHERE   name = N'proj')
	BEGIN
		EXEC('CREATE SCHEMA [proj]');
	END
GO
;

CREATE TABLE proj.Store(
	ID				INT				NOT NULL	IDENTITY(1,1),
	Registered_Name	NVARCHAR(255)	NOT NULL,
	PRIMARY KEY(ID)
);
GO
;

CREATE TABLE proj.Market(
	ID				INT				NOT NULL	IDENTITY(1,1),
	Market_Name		NVARCHAR(255)	NOT NULL,
	PRIMARY KEY(ID)
);
GO
;

CREATE TABLE proj.AppUser(
	ID				INT				NOT NULL	IDENTITY(1,1),
	Email			NVARCHAR(128)	NOT NULL	UNIQUE,
	Fname			NVARCHAR(64)	NOT NULL,
	Lname			NVARCHAR(64)	NOT NULL,
	Birthdate		DATE			NOT NULL,
	Sex				NVARCHAR(1)		NOT NULL	DEFAULT ' ',	
	Street			NVARCHAR(255)	NOT NULL,
	Postcode		NVARCHAR(64)	NOT NULL,
	City			NVARCHAR(255)	NOT NULL,
	Country			NVARCHAR(32)	NOT NULL,
	Balance			DECIMAL(19, 4)	NOT NULL	DEFAULT 0,
	PRIMARY KEY(ID),
	CHECK(Balance >= 0),
	CHECK(Sex IN(' ', 'F', 'M'))
);
GO
;

CREATE TABLE proj.Publisher(
	NIPC			CHAR(9)			NOT NULL,
	Legal_Name		NVARCHAR(255)	NOT NULL	UNIQUE,
	Street			NVARCHAR(255)	NOT NULL,
	Postcode		NVARCHAR(64)	NOT NULL,
	City			NVARCHAR(255)	NOT NULL,
	Country			NVARCHAR(32)	NOT NULL,
	Found_Date		DATE			NOT NULL	DEFAULT	CURRENT_TIMESTAMP,
	IsAllowed		BIT				NOT NULL	DEFAULT '1',  -- 0->Not allowed on store, 1-->Allowed on store
	PRIMARY KEY(NIPC),
	CHECK(LEN(NIPC)=9 AND ISNUMERIC(NIPC)='1')
);
GO
;


CREATE TABLE proj.Software(
	ID				INT				NOT NULL	IDENTITY(1,1),
	Official_Name	NVARCHAR(255)	NOT NULL	UNIQUE,
	Release_Date	DATE			NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	Class			CHAR(1)			NOT NULL,
	Publisher_NIPC	CHAR(9),
	PRIMARY KEY(ID),
	CHECK(Class IN('T', 'G')) -- T-->Tool, G-->Game
);
GO
;

CREATE TABLE proj.Tool(
	Software_ID			INT					NOT NULL,
	Current_Version		NVARCHAR(64)		NOT NULL	DEFAULT 'BETA',
	Brief_Description	NVARCHAR(255)					DEFAULT ' ',
	PRIMARY KEY(Software_ID)
);
GO
;

CREATE TABLE proj.Game(
	Software_ID			INT				NOT NULL,
	Age_Rating			NVARCHAR(9)		NOT NULL	DEFAULT 'Non-Rated',
	Brief_Description	NVARCHAR(255)				DEFAULT ' ',
	PRIMARY KEY(Software_ID),
	CHECK(Age_Rating IN('E', 'T', 'M', 'A', 'Non-Rated'))
);
GO
;

CREATE TABLE proj.Purchases(
	ID				INT					NOT NULL	IDENTITY(1,1),
	Finalize_Date	DATE				NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	AppUser_ID		INT,
	Software_ID		INT,	
	Store_ID		INT								DEFAULT 1,   
	SKU				UNIQUEIDENTIFIER	NOT NULL	UNIQUE	DEFAULT NEWID(),
	Cost			Decimal(19, 4)		NOT NULL	DEFAULT 0,
	PRIMARY KEY(ID),
	CHECK(Cost >= 0)
);
GO
;

CREATE TABLE proj.Item_Category(
	ID				INT				NOT NULL	IDENTITY(1,1),
	Category_Name	NVARCHAR(64)	NOT NULL	UNIQUE,
	CanBeSold		BIT				NOT NULL	DEFAULT '0',
	PRIMARY KEY(ID)
);
GO
;

CREATE TABLE proj.Item(
	UUID			UNIQUEIDENTIFIER	NOT NULL	DEFAULT NEWID(),
	Item_Name		NVARCHAR(64)		NOT NULL,
	Rarity			INT					NOT NULL,
	Market_Value	DECIMAL(19, 4)					DEFAULT 0.01,
	Category		INT,
	Game_ID			INT,
	ForSale			CHAR(1)				NOT NULL	DEFAULT 'N',
	PRIMARY KEY(UUID),
	CHECK(Rarity >=0 AND Rarity <=5),
	CHECK(Market_Value >= 0.01),
	CHECK(ForSale IN('Y', 'N'))
);
GO
;

CREATE TABLE proj.Game_Type(
	Game_ID		INT				NOT NULL,
	Game_Type	NVARCHAR(255)	NOT NULL	 DEFAULT 'Uncategorized',
	PRIMARY KEY(Game_ID, Game_Type)
);
GO
;

CREATE TABLE proj.SoftOS(
	Software_ID		INT					NOT NULL,
	Supported_OS	NVARCHAR(64)		NOT NULL,
	PRIMARY KEY(Software_ID, Supported_OS)
);
GO
;

CREATE TABLE proj.Authorization_List(
	Store_ID		INT					NOT NULL	DEFAULT 1,
	Publisher_NIPC	CHAR(9)				NOT NULL,
	PRIMARY KEY(Store_ID, Publisher_NIPC)
);
GO
;

CREATE TABLE proj.Store_Software(
	Store_ID		INT					NOT NULL	DEFAULT 1,
	Software_ID		INT					NOT NULL,
	Price			DECIMAL(19, 4)		NOT NULL	DEFAULT 1,
	PRIMARY KEY(Store_ID, Software_ID),
	CHECK(Price >= 0)
);
GO
;

CREATE TABLE proj.Market_Items(
	Market_ID		INT					NOT NULL	DEFAULT 1,
	Item_UUID		UNIQUEIDENTIFIER	NOT NULL,
	PRIMARY KEY(Market_ID, Item_UUID)
);
GO
;

CREATE TABLE proj.Inventory(
	AppUser_ID		INT					NOT NULL,
	Item_UUID		UNIQUEIDENTIFIER	NOT NULL,
	PRIMARY KEY(AppUser_ID, Item_UUID)
);
GO
;

CREATE TABLE proj.FriendsList(
	AppUser_ID1		INT		NOT NULL,
	AppUser_ID2		INT		NOT NULL,
	PRIMARY KEY(AppUser_ID1, AppUser_ID2),
	CHECK(AppUser_ID1 <> AppUser_ID2)
);
GO
;

CREATE TABLE proj.Wishlist(
	AppUser_ID		INT		NOT NULL,
	Software_ID		INT		NOT NULL,
	PRIMARY KEY(AppUser_ID, Software_ID)
);
GO
;

CREATE TABLE proj.Purchase_Returns(
	Purchase_ID		INT		NOT NULL,
	AppUser_ID		INT		NOT NULL,
	Return_Date		DATE	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(Purchase_ID, AppUser_ID)
);
GO
;


----------------------Software ----------------------
ALTER TABLE proj.Software WITH CHECK ADD CONSTRAINT FK_Software_Publisher FOREIGN KEY (Publisher_NIPC)
	REFERENCES proj.Publisher(NIPC) ON DELETE SET NULL ON UPDATE CASCADE;
GO
;

----------------------Tool FK----------------------
ALTER TABLE proj.Tool WITH CHECK ADD CONSTRAINT FK_Tool_Software FOREIGN KEY (Software_ID)
	REFERENCES proj.Software(ID) ON DELETE CASCADE;
GO
;

----------------------Game FK----------------------
ALTER TABLE proj.Game WITH CHECK ADD CONSTRAINT FK_Game_Software FOREIGN KEY (Software_ID)
	REFERENCES proj.Software(ID) ON DELETE CASCADE;
GO
;

----------------------Purchases FK----------------------
ALTER TABLE proj.Purchases WITH CHECK ADD CONSTRAINT FK_Purchases_Software FOREIGN KEY (Software_ID)
	REFERENCES proj.Software(ID) ON DELETE SET NULL;

ALTER TABLE proj.Purchases WITH CHECK ADD CONSTRAINT FK_Purchases_AppUser FOREIGN KEY (AppUser_ID)
	REFERENCES proj.AppUser(ID) ON DELETE SET NULL;

ALTER TABLE proj.Purchases WITH CHECK ADD CONSTRAINT FK_Purchases_StoreID FOREIGN KEY (Store_ID)
	REFERENCES proj.Store(ID) ON DELETE SET NULL;
GO
;

----------------------Item FK----------------------
ALTER TABLE proj.Item WITH CHECK ADD CONSTRAINT FK_Item_Category FOREIGN KEY (Category)
	REFERENCES proj.Item_Category(ID) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE proj.Item WITH CHECK ADD CONSTRAINT FK_Item_Game FOREIGN KEY (Game_ID)
	REFERENCES proj.Game(Software_ID) ON DELETE SET NULL;
GO
;

----------------------Game_Type FK----------------------
ALTER TABLE proj.Game_Type WITH CHECK ADD CONSTRAINT FK_GameType_Game FOREIGN KEY (Game_ID)
	REFERENCES proj.Game(Software_ID) ON DELETE CASCADE;
GO
;

----------------------SoftOS FK----------------------
ALTER TABLE proj.SoftOS WITH CHECK ADD CONSTRAINT FK_SoftOS_Software FOREIGN KEY (Software_ID)
	REFERENCES proj.Software(ID) ON DELETE CASCADE;
GO
;

----------------------Authorization_List FK----------------------
ALTER TABLE proj.Authorization_List WITH CHECK ADD CONSTRAINT FK_AuthorizationList_Store FOREIGN KEY (Store_ID)
	REFERENCES proj.Store(ID) ON DELETE CASCADE;

ALTER TABLE proj.Authorization_List WITH CHECK ADD CONSTRAINT FK_AuthorizationList_Publisher FOREIGN KEY (Publisher_NIPC)
	REFERENCES proj.Publisher(NIPC) ON DELETE CASCADE ON UPDATE CASCADE;
GO
;

----------------------Store_Software FK----------------------
ALTER TABLE proj.Store_Software WITH CHECK ADD CONSTRAINT FK_StoreSoftware_Store FOREIGN KEY (Store_ID)
	REFERENCES proj.Store(ID) ON DELETE CASCADE;

ALTER TABLE proj.Store_Software WITH CHECK ADD CONSTRAINT FK_StoreSoftware_Software FOREIGN KEY (Software_ID)
	REFERENCES proj.Software(ID) ON DELETE CASCADE;
GO
;

----------------------Market_Items FK----------------------
ALTER TABLE proj.Market_Items WITH CHECK ADD CONSTRAINT FK_MarketItems_Market FOREIGN KEY (Market_ID)
	REFERENCES proj.Market(ID) ON DELETE CASCADE;

ALTER TABLE proj.Market_Items WITH CHECK ADD CONSTRAINT FK_MarketItems_Item FOREIGN KEY (Item_UUID)
	REFERENCES proj.Item(UUID) ON DELETE CASCADE;
GO
;

----------------------Inventory FK----------------------
ALTER TABLE proj.Inventory WITH CHECK ADD CONSTRAINT FK_Inventory_AppUser FOREIGN KEY (AppUser_ID)
	REFERENCES proj.AppUser(ID) ON DELETE CASCADE;

ALTER TABLE proj.Inventory WITH CHECK ADD CONSTRAINT FK_Inventory_Item FOREIGN KEY (Item_UUID)
	REFERENCES proj.Item(UUID) ON DELETE CASCADE;
GO
;

----------------------FriendsList FK----------------------
ALTER TABLE proj.FriendsList WITH CHECK ADD CONSTRAINT FK_FriendsList_AppUser1 FOREIGN KEY (AppUser_ID1)
	REFERENCES proj.AppUser(ID) ON DELETE CASCADE;
GO
;

----------------------Wishlist FK----------------------
ALTER TABLE proj.Wishlist WITH CHECK ADD CONSTRAINT FK_Wishlist_AppUser FOREIGN KEY (AppUser_ID)
	REFERENCES proj.AppUser(ID) ON DELETE CASCADE;

ALTER TABLE proj.Wishlist WITH CHECK ADD CONSTRAINT FK_Wishlist_Software FOREIGN KEY (Software_ID)
	REFERENCES proj.Software(ID) ON DELETE CASCADE;
GO
;

----------------------Purchase_Returns FK----------------------
ALTER TABLE proj.Purchase_Returns WITH CHECK ADD CONSTRAINT FK_PurchaseReturns_AppUser FOREIGN KEY (AppUser_ID)
	REFERENCES proj.AppUser(ID) ON DELETE CASCADE;

ALTER TABLE proj.Purchase_Returns WITH CHECK ADD CONSTRAINT FK_PurchaseReturns_Purchases FOREIGN KEY (Purchase_ID)
	REFERENCES proj.Purchases(ID) ON DELETE CASCADE;