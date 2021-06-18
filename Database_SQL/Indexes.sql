USE p1g6;
GO
;

CREATE UNIQUE NONCLUSTERED INDEX IXSKU ON proj.Purchases(SKU);
GO
;

CREATE UNIQUE NONCLUSTERED INDEX IXPubName ON proj.Publisher(Legal_Name);
GO
;

CREATE UNIQUE NONCLUSTERED INDEX IXSoftName ON proj.Software(Official_Name);
GO
;

CREATE NONCLUSTERED INDEX IXIsAllowed ON proj.Publisher(IsAllowed);
GO
;

CREATE NONCLUSTERED INDEX IXUserQuery ON proj.Appuser(Email, Fname, Lname);
GO
;

CREATE NONCLUSTERED INDEX IXItemName ON proj.Item(Item_Name);
GO
;