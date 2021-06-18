USE p1g6;
GO
;

CREATE TRIGGER deleteGameSoft ON proj.Game  
AFTER DELETE
AS
	BEGIN
		DECLARE @Software_ID INT;
		SELECT @Software_ID = Software_ID FROM deleted;
		IF NOT EXISTS(SELECT 1 FROM	proj.Game WHERE	Software_ID = @Software_ID)
				DELETE FROM proj.Software WHERE ID = @Software_ID;
	END
GO
;

CREATE TRIGGER deleteToolSoft ON proj.Tool  
AFTER DELETE
AS
	BEGIN
		DECLARE @Software_ID INT;
		SELECT @Software_ID = Software_ID FROM deleted;
		IF NOT EXISTS(SELECT 1 FROM	proj.Tool WHERE	Software_ID = @Software_ID)
				DELETE FROM proj.Software WHERE ID = @Software_ID;
	END
GO
;