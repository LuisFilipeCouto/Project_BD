USE p1g6;
GO
;
--------------------DADOS SOBRE UTILIZADORES--------------------
CREATE FUNCTION proj.getOwnedSoftwareByUserID(@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT		proj.Software.ID, Official_Name, Class AS Type_of_Software, STRING_AGG(Supported_OS, ', ') AS Supported_OS, Release_Date, SKU
			FROM		proj.Purchases	LEFT JOIN proj.Purchase_Returns ON proj.Purchases.ID=proj.Purchase_Returns.Purchase_ID
										INNER JOIN proj.Software ON proj.Purchases.Software_ID=proj.Software.ID
										LEFT JOIN	proj.SoftOS	ON proj.SoftOS.Software_ID=proj.Software.ID
			WHERE		(proj.Purchase_Returns.Purchase_ID IS NULL) AND (proj.Purchases.AppUser_ID=@AppUser_ID)
			GROUP BY	proj.Software.ID, Official_Name, Class, Release_Date, SKU);
GO
;

CREATE FUNCTION	proj.getPurchasesByUserID(@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	Software_ID, SKU, Finalize_Date, Cost
			FROM	proj.Purchases
			WHERE	AppUser_ID=@AppUser_ID);
GO
;

CREATE FUNCTION proj.getPurchaseReturnsByUserID(@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	Software_ID, SKU, Return_Date, Cost
			FROM	proj.Purchase_Returns INNER JOIN proj.Purchases ON proj.Purchase_Returns.Purchase_ID=proj.Purchases.ID
			WHERE	proj.Purchase_Returns.AppUser_ID=@AppUser_ID);
GO
;

CREATE FUNCTION proj.getFriendsListByUserID(@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	ID, Email, Fname, Lname 
			FROM	proj.FriendsList INNER JOIN proj.AppUser ON proj.FriendsList.AppUser_ID2=proj.AppUser.ID
			WHERE	AppUser_ID1=@AppUser_ID);
GO
;

CREATE FUNCTION proj.getNotFriendsWithByUserID(@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	ID, Email, Fname, Lname  
			FROM	proj.AppUser
			WHERE	ID NOT IN (SELECT	AppUser_ID2 
								FROM	proj.FriendsList 
								WHERE	(AppUser_ID1=@AppUser_ID) AND (ID <> @AppUser_ID)));
GO
;

CREATE FUNCTION	proj.getWishlistByUserID(@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT		proj.Software.ID, Official_Name, Class AS Type_of_Software, Price, Legal_Name AS Publisher, STRING_AGG(Supported_OS, ', ') AS Supported_OS, Release_Date
			FROM		proj.Wishlist	INNER JOIN proj.Software ON proj.Wishlist.Software_ID=proj.Software.ID
										INNER JOIN proj.Publisher ON proj.Software.Publisher_NIPC=proj.Publisher.NIPC
										INNER JOIN proj.Store_Software ON proj.Software.ID=proj.Store_Software.Software_ID
										LEFT JOIN proj.SoftOS ON proj.SoftOS.Software_ID=proj.Software.ID
			WHERE		proj.Wishlist.AppUser_ID=@AppUser_ID
			GROUP BY	proj.Software.ID, Official_Name, Price, Legal_Name, Class, Release_Date);
GO
;

CREATE FUNCTION proj.getInventoryByUserID(@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	Item_Name, Category_Name AS Category, Rarity, CanBeSold, Market_Value, CAST(Game_ID AS NVARCHAR) + ' - ' + Official_Name AS Origin_Game, Item_UUID, ForSale
			FROM	proj.Inventory	INNER JOIN proj.Item ON proj.Inventory.Item_UUID=proj.Item.UUID
									INNER JOIN proj.Item_Category ON proj.Item.Category=proj.Item_Category.ID
									INNER JOIN proj.Game ON proj.Item.Game_ID=proj.Game.Software_ID
									INNER JOIN proj.Software ON proj.Game.Software_ID=proj.Software.ID
			WHERE	AppUser_ID=@AppUser_ID);						
GO
;

CREATE FUNCTION proj.getMarketByUserID(@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	Item_Name, Category_Name AS Category, Rarity, Market_Value, CAST(Game_ID AS NVARCHAR) + ' - ' + Official_Name AS Origin_Game, proj.Market_Items.Item_UUID
			FROM	proj.Market_Items	INNER JOIN proj.Item ON proj.Market_Items.Item_UUID=proj.Item.UUID
										INNER JOIN proj.Item_Category ON proj.Item.Category=proj.Item_Category.ID
										INNER JOIN proj.Game ON proj.Item.Game_ID=proj.Game.Software_ID
										INNER JOIN proj.Software ON proj.Game.Software_ID=proj.Software.ID
										INNER JOIN proj.Inventory ON proj.Item.UUID=proj.Inventory.Item_UUID
			WHERE	AppUser_ID <> @AppUser_ID);		
GO
;

CREATE FUNCTION proj.getItemsForSaleByUserID(@AppUser_ID INT) RETURNS TABLE AS
	RETURN(SELECT	Item_Name, Category_Name AS Category, Rarity, CanBeSold, Market_Value, CAST(Game_ID AS NVARCHAR) + ' - ' + Official_Name AS Origin_Game, Item_UUID
			FROM	proj.Inventory	INNER JOIN proj.Item ON proj.Inventory.Item_UUID=proj.Item.UUID
									INNER JOIN proj.Item_Category ON proj.Item.Category=proj.Item_Category.ID
									INNER JOIN proj.Game ON proj.Item.Game_ID=proj.Game.Software_ID
									INNER JOIN proj.Software ON proj.Game.Software_ID=proj.Software.ID
			WHERE	(AppUser_ID=@AppUser_ID) AND (ForSale='Y'));	
GO
;


--------------------DADOS SOBRE PUBLICADORAS--------------------
CREATE FUNCTION proj.getGamesByPublisher(@Publisher_NIPC CHAR(9)) RETURNS TABLE AS
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
;

CREATE FUNCTION proj.getToolsByPublisher(@Publisher_NIPC CHAR(9)) RETURNS TABLE AS
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
;


--------------------ESTATISTICAS DA LOJA--------------------
CREATE FUNCTION	proj.getGameSales() RETURNS TABLE AS
	RETURN(SELECT		proj.Game.Software_ID, proj.Software.Official_Name, COUNT(proj.Purchases.Software_ID) AS Sold_Copies
			FROM		proj.Purchases	INNER JOIN proj.Game ON proj.Purchases.Software_ID=proj.Game.Software_ID
										INNER JOIN proj.Software ON proj.Game.Software_ID=proj.Software.ID
			GROUP BY	proj.Game.Software_ID, proj.Software.Official_Name);
GO
;

CREATE FUNCTION	proj.getToolSales() RETURNS TABLE AS
	RETURN(SELECT		proj.Tool.Software_ID, proj.Software.Official_Name, COUNT(proj.Purchases.Software_ID) AS Sold_Copies
			FROM		proj.Purchases	INNER JOIN proj.Tool ON proj.Purchases.Software_ID=proj.Tool.Software_ID
										INNER JOIN proj.Software ON proj.Tool.Software_ID=proj.Software.ID
			GROUP BY	proj.Tool.Software_ID, proj.Software.Official_Name);
GO
;

CREATE FUNCTION proj.getPublisherSales() RETURNS TABLE AS
	RETURN(SELECT		NIPC, Legal_Name AS Publisher, COUNT(Software_ID) AS Total_Sales
			FROM		proj.Purchases	INNER JOIN proj.Software ON proj.Purchases.Software_ID=proj.Software.ID
										INNER JOIN proj.Publisher ON proj.Software.Publisher_NIPC=proj.Publisher.NIPC
			GROUP BY	NIPC, Legal_Name);
GO
;

CREATE FUNCTION proj.getMostSupportedOS() RETURNS TABLE AS
	RETURN(SELECT Supported_OS AS OS_Name, COUNT(*) AS Numb
			FROM proj.Store_Software INNER JOIN proj.Software ON proj.Store_Software.Software_ID=proj.Software.ID
										INNER JOIN proj.SoftOS ON proj.Software.ID=proj.SoftOS.Software_ID
			GROUP BY Supported_OS 
			HAVING COUNT(*) = (SELECT MAX(Numb) FROM (SELECT		Supported_OS, COUNT(*) AS Numb
														FROM		proj.Store_Software INNER JOIN proj.Software ON proj.Store_Software.Software_ID=proj.Software.ID
																						INNER JOIN proj.SoftOS ON proj.Software.ID=proj.SoftOS.Software_ID
														GROUP BY	Supported_OS) AS X));
GO
;

CREATE FUNCTION proj.getAverageGamePrice()	RETURNS DECIMAL(19,2) AS
	BEGIN
		DECLARE @averageGamePrice DECIMAL(19,4);
		SELECT	@averageGamePrice = AVG(Price)
		FROM	proj.Store_Software INNER JOIN proj.Game ON proj.Store_Software.Software_ID=proj.Game.Software_ID;
		RETURN	@averageGamePrice;
	END
GO
;

CREATE FUNCTION proj.getAverageToolPrice() RETURNS DECIMAL(19,2) AS
	BEGIN
		DECLARE @averageToolPrice DECIMAL(19,4);
		SELECT	@averageToolPrice = AVG(Price)
		FROM	proj.Store_Software INNER JOIN proj.Tool ON proj.Store_Software.Software_ID=proj.Tool.Software_ID;
		RETURN	@averageToolPrice;
	END
GO
;


--------------------ESTATISTICAS DE UTILIZADORES--------------------
CREATE FUNCTION	proj.getSexRepresentation() RETURNS TABLE AS
	RETURN(SELECT		Sex, CAST(COUNT(ID)*100/(SELECT COUNT(ID) FROM proj.AppUser) AS DECIMAL(4,2)) AS [Percentage]
			FROM		proj.AppUser
			GROUP BY	Sex);
GO
;

CREATE FUNCTION	proj.getUsersByCountry() RETURNS TABLE AS
	RETURN(SELECT		Country, COUNT(*) AS Users
			FROM		proj.AppUser
			GROUP BY	Country);
GO
;

CREATE FUNCTION	proj.getUserStoreStatistics() RETURNS TABLE AS
	RETURN (SELECT	AppUser_ID, SUM(Cost) AS Total_Spent, SUM(Cost)/COUNT(*) AS Avg_Purchase_Cost
			FROM		proj.Purchases
			GROUP BY	AppUser_ID);
GO
;

CREATE FUNCTION	proj.getWishedSoftware() RETURNS TABLE AS
	RETURN(SELECT		Software_ID, Official_Name AS Software_Name, COUNT(*) AS Number_of_Wishers
			FROM		proj.Wishlist INNER JOIN proj.Software ON proj.Wishlist.Software_ID=proj.Software.ID
			GROUP BY	Software_ID, Official_Name);
GO
;

CREATE FUNCTION	proj.getTotalMoneySpent() RETURNS DECIMAL(19, 2) AS
	BEGIN
		DECLARE		@TotalMoneySpent DECIMAL(19, 4);
		SELECT		@TotalMoneySpent = SUM(Cost)
		FROM		proj.Purchases;
		RETURN @TotalMoneySpent;
	END
GO
;

CREATE FUNCTION	proj.getAverageNumberFriends() RETURNS INT AS
	BEGIN
		DECLARE		@averageNumberFriends INT;
		SELECT		@averageNumberFriends = AVG(T.Number_Friends)
		FROM		(SELECT		AppUser_ID1, COUNT(AppUser_ID2) AS Number_Friends
						FROM	proj.FriendsList
						GROUP BY AppUser_ID1) AS T;
		RETURN @averageNumberFriends;
	END
GO
;

CREATE FUNCTION	proj.getAverageUserAge() RETURNS INT AS
	BEGIN
		DECLARE		@averageUserAge INT;
		SELECT		@averageUserAge = AVG(DATEDIFF(year, Birthdate, GETDATE()))
		FROM		proj.AppUser;
		RETURN @averageUserAge;
	END
GO
;