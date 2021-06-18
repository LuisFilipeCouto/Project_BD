USE p1g6
GO
;

-------------------------------QUERIES-------------------------------
CREATE PROC proj.searchAppUser(@StringFind NVARCHAR(128)) --OBTER QUALQUER UTILIZADOR ONDE ID, FNAME, LNAME OU EMAIL CONTENHAM @StringFind
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%';  
	SELECT	* 
	FROM	proj.AppUser
	WHERE	(ID LIKE @StringFind) OR (Email LIKE @StringFind)  OR (Fname LIKE @StringFind) OR (Lname LIKE @StringFind);
GO
;

CREATE PROC proj.searchNonFriend(@AppUser_ID INT, @StringFind NVARCHAR(128)) --OBTER UTILIZADOR NAO AMIGO DE OUTRO UTILIZADOR ONDE ID, FNAME, LNAME OU EMAIL CONTENHAM @StringFind
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%';  
	SELECT	* 
	FROM	proj.getNotFriendsWithByUserID(@AppUser_ID) 
	WHERE	(ID LIKE @StringFind) OR (Email LIKE @StringFind)  OR (Fname LIKE @StringFind) OR (Lname LIKE @StringFind);
GO
;

CREATE PROC proj.searchPublisher(@StringFind NVARCHAR(255)) --OBTER PUBLICADORA ONDE NIPC OU LEGAL_NAME CONTENHAM @StringFind
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%';  
	SELECT	* 
	FROM	proj.Publisher 
	WHERE	(NIPC LIKE @StringFind)  OR (Legal_Name LIKE @StringFind);
GO
;

CREATE PROC proj.searchGame(@Publisher_NIPC INT, @StringFind NVARCHAR(255)) --OBTER JOGO ONDE ID OU OFFICIAL_NAME CONTEM @StringFind
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%';  
	SELECT	* 
	FROM	proj.getGamesByPublisher(@Publisher_NIPC)
	WHERE	(ID LIKE @StringFind) OR (Official_Name LIKE @StringFind);
GO
;

CREATE PROC proj.searchTool(@Publisher_NIPC INT, @StringFind NVARCHAR(255)) --OBTER APLICACAO ONDE ID OU OFFICIAL_NAME CONTEM @StringFind
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%';  
	SELECT	* 
	FROM	proj.getToolsByPublisher(@Publisher_NIPC)
	WHERE	(ID LIKE @StringFind) OR (Official_Name LIKE @StringFind);
GO
;

CREATE PROC proj.searchItem(@StringFind NVARCHAR(255)) --OBTER ITEM ONDE UUID OU ITEM_NAME CONTEM @StringFind
AS
	SELECT	@StringFind = '%' + RTRIM(@StringFind) + '%';  
	SELECT	* 
	FROM	proj.Show_All_Items
	WHERE	(UUID LIKE @StringFind) OR (Item_Name LIKE @StringFind);
GO
;

CREATE PROC proj.searchRandomUserID(@User_ID INT OUTPUT) --OBTER ID DE UM UTILIZADOR ALEATORIO
AS
	SELECT @User_ID = (SELECT TOP 1 ID 
						FROM		proj.AppUser
						ORDER BY	NEWID());
GO
;


--------------------------------CRIAR-------------------------------
CREATE PROC proj.createAppUser(@Email NVARCHAR(128), @Fname NVARCHAR(64), @Lname NVARCHAR(64), @Birthdate DATE, @Sex NVARCHAR(1), @Street NVARCHAR(255), @Postcode NVARCHAR(64), @City NVARCHAR(255), @Country NVARCHAR(32)) --CRIAR NOVO UTILIZADOR
AS
	DECLARE @Balance Decimal(19, 4);
	SET @Balance = 0;
	INSERT INTO proj.AppUser(Email, Fname, Lname, Birthdate, Sex, Street, Postcode, City, Country, Balance) VALUES(@Email, @Fname, @Lname, @Birthdate, @Sex, @Street, @Postcode, @City, @Country, @Balance);
GO
;

CREATE PROC proj.createPublisher(@NIPC CHAR(9), @Legal_Name NVARCHAR(255), @Street NVARCHAR(255), @Postcode NVARCHAR(64), @City NVARCHAR(255), @Country NVARCHAR(32), @Found_Date DATE, @IsAllowed BIT) --CRIAR NOVA PUBLICADORA
AS
	INSERT INTO proj.Publisher VALUES (@NIPC, @Legal_Name, @Street, @Postcode, @City, @Country, @Found_Date, @IsAllowed);
GO
;

CREATE PROC proj.createGame(@Official_Name NVARCHAR(255), @Release_Date DATE, @Publisher_NIPC CHAR(9), @Age_Rating NVARCHAR(9), @Brief_Description NVARCHAR(255), @Game_Type NVARCHAR(1024), @SupportedOS NVARCHAR(1024)) --CRIAR NOVO JOGO
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
;

CREATE PROC proj.createTool(@Official_Name NVARCHAR(255), @Release_Date DATE, @Publisher_NIPC CHAR(9), @Current_Version	NVARCHAR(64), @Brief_Description NVARCHAR(255), @SupportedOS NVARCHAR(1024)) --CRIAR NOVA APLICAÇÃO
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
;

CREATE PROC proj.createItem(@Item_Name NVARCHAR(64), @Rarity INT, @Market_Value	DECIMAL(19, 4), @Category INT, @Game_ID INT, @AppUser_ID INT) --CRIAR NOVO ITEM
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
;


--------------------------------APAGAR-------------------------------
CREATE PROC proj.deletePublisher(@Publisher_NIPC CHAR(9)) --APAGAR PUBLICADORA EXISTENTE
AS
	BEGIN TRANSACTION
		DELETE FROM proj.Wishlist WHERE Software_ID IN (SELECT		ID
														FROM	proj.Software
														WHERE	Publisher_NIPC=@Publisher_NIPC);
		DELETE FROM proj.Publisher WHERE NIPC=@Publisher_NIPC;
	COMMIT TRANSACTION
GO
;

CREATE PROC proj.deleteAppUser(@AppUser_ID INT) --APAGAR UTILIZADOR EXISTENTE
AS	
	BEGIN TRANSACTION
		DELETE FROM proj.AppUser WHERE ID = @AppUser_ID;
		DELETE FROM proj.Item WHERE UUID IN(SELECT	Item_UUID 
											FROM	proj.Inventory
											WHERE	AppUser_ID=@AppUser_ID);
	COMMIT TRANSACTION
GO
;

CREATE PROC proj.deleteGame(@Software_ID INT) --APAGAR JOGO EXISTENTE
AS	
	DELETE FROM proj.Game WHERE Software_ID = @Software_ID;
GO
;

CREATE PROC proj.deleteTool(@Software_ID INT) --APAGAR APLICACAO EXISTENTE
AS	
	DELETE FROM proj.Tool WHERE Software_ID = @Software_ID;
GO
;

CREATE PROC proj.deleteItem(@UUID NVARCHAR(50), @AppUser_ID INT) --APAGAR ITEM EXISTENTE
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
;


--------------------------------ADICIONAR-----------------------------
CREATE PROC proj.addStore_Software(@Software_ID INT, @Price DECIMAL(19, 4)) --ADICIONAR SOFTWARE A LOJA
AS	
	INSERT INTO proj.Store_Software(Software_ID, Price) VALUES (@Software_ID, @Price);
GO
;

CREATE PROC proj.addAuthorizationList(@Publisher_NIPC CHAR(9)) --ADICIONAR PUBLICADORA A LISTA DE AUTORIZACAO
AS
	BEGIN TRANSACTION
		UPDATE proj.Publisher SET IsAllowed='1' WHERE NIPC=@Publisher_NIPC;
		INSERT INTO proj.Authorization_List VALUES ('1', @Publisher_NIPC);
	COMMIT TRANSACTION
GO
;

CREATE PROC proj.addBalance(@AppUser_ID INT, @Value DECIMAL(19, 4)) --ADICIONAR SALDO A CARTEIRA DE UM UTILIZADOR
AS
	DECLARE @User_Balance AS DECIMAL(19, 4);
	SET @User_Balance = (SELECT Balance FROM proj.AppUser WHERE ID=@AppUser_ID);

	DECLARE @New_Balance AS DECIMAL(19, 4);
	SET @New_Balance = @User_Balance + @Value;

	UPDATE proj.AppUser SET Balance=@New_Balance WHERE ID=@AppUser_ID;
GO
;

CREATE PROC proj.addFriend(@AppUser_ID1 INT, @AppUser_ID2 INT) --ADICIONAR UTILIZADOR A LISTA DE AMIGOS
AS
	BEGIN TRANSACTION
		INSERT INTO proj.FriendsList(AppUser_ID1, AppUser_ID2) VALUES (@Appuser_ID1, @AppUser_ID2);
		INSERT INTO proj.FriendsList(AppUser_ID1, AppUser_ID2) VALUES (@Appuser_ID2, @AppUser_ID1);
	COMMIT TRANSACTION
GO
;

CREATE PROC proj.addWishlist(@AppUser_ID INT, @Software_ID INT) --ADICIONAR SOFTWARE A LISTA DE DESEJOS
AS
	INSERT INTO proj.Wishlist(AppUser_ID, Software_ID) VALUES (@Appuser_ID, @Software_ID);
GO
;


-----------------------------REMOVER-------------------------------
CREATE PROC proj.removeStoreSoftware(@Software_ID INT) --REMOVER SOFTWARE DA LOJA
AS
	BEGIN TRANSACTION
		DELETE FROM proj.Wishlist WHERE Software_ID=@Software_ID;
		DELETE FROM proj.Store_Software WHERE Software_ID=@Software_ID;
	COMMIT TRANSACTION
GO
;

CREATE PROC proj.removeAuthorizationList(@Publisher_NIPC CHAR(9)) --REMOVER PUBLICADORA DA LISTA DE AUTORIZACAO
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
;

CREATE PROC proj.removeFriend(@AppUser_ID1 INT, @AppUser_ID2 INT) --REMOVER UTILIZADOR DA LISTA DE AMIGOS
AS	
	BEGIN TRANSACTION
		DELETE FROM proj.FriendsList WHERE (AppUser_ID1 = @AppUser_ID1) AND (AppUser_ID2 = @AppUser_ID2);
		DELETE FROM proj.FriendsList WHERE (AppUser_ID1 = @AppUser_ID2) AND (AppUser_ID2 = @AppUser_ID1);
	COMMIT TRANSACTION
GO
;

CREATE PROC proj.removeWishlist(@AppUser_ID INT, @Software_ID INT) --REMOVER SOFTWARE DA LISTA DE DESEJOS
AS
	DELETE FROM proj.Wishlist WHERE (AppUser_ID=@Appuser_ID) AND (Software_ID=@Software_ID);
GO
;

CREATE PROC proj.removeItemFromMarket(@Item_UUID NVARCHAR(50)) --REMOVER ITEM DO MERCADO
AS
	BEGIN TRANSACTION
		DELETE FROM proj.Market_Items WHERE Item_UUID=@Item_UUID;
		UPDATE proj.Item SET ForSale = 'N' WHERE UUID=@Item_UUID;
	COMMIT TRANSACTION
GO
;


--------------------------------EDITAR-------------------------------
CREATE PROC proj.editSoftwarePrice(@Software_ID INT, @New_Price DECIMAL(19, 4)) --EDITAR PREÇO DO SOFTWARE NA LOJA
AS
	UPDATE proj.Store_Software SET Price=@New_Price WHERE Software_ID=@Software_ID;
GO
;

CREATE PROC proj.editAppUser(@AppUser_ID INT, @Email NVARCHAR(128), @Fname NVARCHAR(64), @Lname NVARCHAR(64), @Birthdate DATE, @Sex NVARCHAR(1), @Street NVARCHAR(255), @Postcode NVARCHAR(64), @City NVARCHAR(255), @Country NVARCHAR(32)) --EDITAR UTILIZADOR
AS
	UPDATE proj.AppUser SET Email=@Email, Fname=@Fname, Lname=@Lname, Birthdate=@Birthdate, Sex=@Sex, Street=@Street, Postcode=@Postcode, City=@City, Country=@Country WHERE ID=@AppUser_ID;
GO
;

CREATE PROC proj.editPublisher(@CurrentNIPC CHAR(9), @NewNIPC CHAR(9), @Legal_Name	NVARCHAR(255), @Street NVARCHAR(255), @Postcode NVARCHAR(64), @City	NVARCHAR(255), @Country	NVARCHAR(32), @IsAllowed BIT) --EDITAR PUBLICADORA EXISTENTE
AS
	UPDATE proj.Publisher SET NIPC=@NewNIPC, Legal_Name=@Legal_Name, Street=@Street, Postcode=@Postcode, City=@City, Country=@Country, IsAllowed=@IsAllowed WHERE NIPC=@CurrentNIPC;
GO
;

CREATE PROC proj.editGame(@Software_ID INT, @Official_Name NVARCHAR(255), @Release_Date DATE, @Age_Rating NVARCHAR(9), @Brief_Description NVARCHAR(255), @Game_Type NVARCHAR(1024), @SupportedOS NVARCHAR(1024)) --EDITAR JOGO EXISTENTE
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
;

CREATE PROC proj.editTool(@Software_ID INT, @Official_Name NVARCHAR(255), @Release_Date DATE, @Current_Version NVARCHAR(9), @Brief_Description NVARCHAR(255), @SupportedOS NVARCHAR(1024)) --EDITAR JOGO EXISTENTE
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
;

CREATE PROC proj.editItem(@UUID NVARCHAR(50), @Item_Name NVARCHAR(64), @Rarity INT, @Market_Value DECIMAL(19, 4), @Category INT, @Game_ID INT, @AppUser_ID INT) --EDITAR ITEM
AS
	IF(@Category IN('2', '3', '4')) --Se pertencer a uma categoria que pode ser vendida
		UPDATE proj.Item SET Item_Name=@Item_Name, Rarity=@Rarity, Market_Value=@Market_Value, Category=@Category, Game_ID=@Game_ID WHERE UUID=@UUID;
	ELSE
		UPDATE proj.Item SET Item_Name=@Item_Name, Rarity=@Rarity, Market_Value=NULL, Category=@Category, Game_ID=@Game_ID WHERE UUID=@UUID;
GO
;


--------------------------------VARIOS-------------------------------
CREATE PROC proj.buySoftware(@AppUser_ID INT, @Software_ID INT) --COMPRAR SOFTWARE DA LOJA
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
;

CREATE PROC proj.returnSoftware(@AppUser_ID INT, @Software_SKU NVARCHAR(50)) --DEVOLVER SOFTWARE A LOJA
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
;

CREATE PROC proj.buyMarketItem(@Buyer_ID INT, @Item_UUID NVARCHAR(50)) --COMPRAR ITEM DO MERCADO
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
;

CREATE PROC proj.sellMarketItem(@Seller_ID INT, @Item_UUID NVARCHAR(50)) --POR ITEM A VENDA NO MERCADO
AS
		DECLARE @CanBeSold AS BIT;
		SET @CanBeSold = (SELECT CanBeSold FROM proj.Item INNER JOIN proj.Item_Category ON proj.Item.Category=proj.Item_Category.ID WHERE proj.Item.UUID=@Item_UUID);

		IF(@CanBeSold = '1')
			BEGIN
				BEGIN TRANSACTION
					INSERT INTO proj.Market_Items VALUES (@Seller_ID, @Item_UUID);
					UPDATE proj.Item SET ForSale = 'Y' WHERE UUID=@Item_UUID;
				COMMIT TRANSACTION
			END
		ELSE
			RAISERROR('Artigo não pode ser colocado a venda', 16, 1);
GO
;
