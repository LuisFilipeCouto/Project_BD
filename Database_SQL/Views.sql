USE p1g6;
GO
;
-------------------------------VIEWS DA LOJA-------------------------------
CREATE VIEW proj.Show_All_Store_Games AS
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
;

CREATE VIEW proj.Show_All_Store_Tools AS
	SELECT		ID, Class AS Software_Type,Official_Name, Price, Release_Date, Legal_Name AS Publisher, Current_Version, STRING_AGG(Supported_OS, ', ') AS Supported_OS, Brief_Description
	FROM		(((proj.Store_Software	INNER JOIN	proj.Tool		ON	proj.Store_Software.Software_ID=proj.Tool.Software_ID)
										INNER JOIN	proj.Software	ON	proj.Software.ID=proj.Tool.Software_ID)
										INNER JOIN	proj.Publisher	ON	proj.Publisher.NIPC=proj.Software.Publisher_NIPC)
										LEFT JOIN	proj.SoftOS		ON	proj.SoftOS.Software_ID=proj.Software.ID	 	

	WHERE		(proj.Publisher.IsAllowed='1') AND (proj.Software.Publisher_NIPC IS NOT NULL)
	GROUP BY	ID, Class, Official_Name, Price, Release_Date, Legal_Name, Current_Version, Brief_Description
GO
;

CREATE VIEW proj.Show_Tools_Can_Add_Store AS
	SELECT	ID, Class AS Software_Type,Official_Name, Release_Date, Legal_Name AS Publisher, Current_Version, STRING_AGG(Supported_OS, ', ') AS Supported_OS, Brief_Description
	FROM	proj.Software LEFT JOIN proj.Store_Software ON proj.Software.ID=proj.Store_Software.Software_ID
							INNER JOIN proj.Publisher	ON proj.Publisher.NIPC=proj.Software.Publisher_NIPC
							INNER JOIN proj.Tool		ON proj.Software.ID=proj.Tool.Software_ID
							INNER JOIN proj.SoftOS		ON proj.Software.ID=proj.SoftOS.Software_ID
	WHERE	(proj.Store_Software.Software_ID IS NULL) AND (proj.Publisher.IsAllowed='1') AND (proj.Software.Publisher_NIPC IS NOT NULL)
	GROUP BY	ID, Class, Official_Name, Price, Release_Date, Legal_Name, Current_Version, Brief_Description;
GO
;

CREATE VIEW proj.Show_Games_Can_Add_Store AS
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
;

CREATE VIEW proj.Show_All_Allowed_Publishers AS
	SELECT	NIPC, Legal_Name AS Publisher, Street, Postcode, City, Country, Found_Date AS Foundation_Date
	FROM	proj.Publisher
	WHERE	IsAllowed='1'
GO
;

CREATE VIEW proj.Show_All_NotAllowed_Publishers AS
	SELECT	NIPC, Legal_Name AS Publisher, Street, Postcode, City, Country, Found_Date AS Foundation_Date
	FROM	proj.Publisher
	WHERE	IsAllowed='0'
GO
;


-------------------------------VIEWS DE UTILIZADORES-------------------------------
CREATE VIEW proj.Show_All_Users AS
	SELECT	ID, Email, Fname, Lname, Birthdate, Sex, Street, Postcode, City, Country, Balance 
	FROM	proj.AppUser
GO
;


-------------------------------VIEWS DE ITEMS-------------------------------
CREATE VIEW proj.Show_All_Items AS
	SELECT		UUID, Item_Name, Rarity, Market_Value, Category_Name, Game_ID, CanBeSold, ForSale, proj.AppUser.ID, Email, Fname, Lname
	FROM		proj.Item LEFT JOIN	proj.Item_Category ON proj.Item.Category=proj.Item_Category.ID
							INNER JOIN proj.Inventory ON proj.Item.UUID=proj.Inventory.Item_UUID
							INNER JOIN proj.AppUser ON proj.Inventory.AppUser_ID=proj.AppUser.ID
GO
;