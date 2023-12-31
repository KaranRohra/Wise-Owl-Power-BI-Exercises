/*

	All code and data belongs to Wise Owl, and must not be reproduced or distributed
	in any way without prior written permission
	
	Note that this code is not written as a training aid, but instead is just
	a means to create a SQL Server database on the user's computer
	
	Code assumes Books database does not already exist
	
*/

USE Master
go

-- drop database if exists
BEGIN TRY
	DROP Database Books
END TRY

BEGIN CATCH
	-- database can't exist
END CATCH

-- create new database
CREATE DATABASE Books
go

USE Books
GO

/****** Object:  Table [dbo].[tblAuthor]    Script Date: 02/05/2010 16:25:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAuthor](
	[AuthorId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AuthorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [uqNames] UNIQUE NONCLUSTERED 
(
	[FirstName] ASC,
	[LastName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [tblAuthor_LastName_Index] ON [dbo].[tblAuthor] 
(
	[AuthorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tblAuthor] ON
INSERT [dbo].[tblAuthor] ([AuthorId], [FirstName], [LastName]) VALUES (2, N'John', N'Wyndham')
INSERT [dbo].[tblAuthor] ([AuthorId], [FirstName], [LastName]) VALUES (3, N'Lynne Reid', N'Banks')
INSERT [dbo].[tblAuthor] ([AuthorId], [FirstName], [LastName]) VALUES (1, N'Stieg', N'Larsson')
SET IDENTITY_INSERT [dbo].[tblAuthor] OFF
/****** Object:  StoredProcedure [dbo].[spSub]    Script Date: 02/05/2010 16:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spSub] AS

DECLARE @i int

SET @i = 'text'
GO
/****** Object:  StoredProcedure [dbo].[spShowError]    Script Date: 02/05/2010 16:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[spShowError] AS

RAISERROR('This went pear-shaped', 12,1)
GO
/****** Object:  Table [dbo].[tblBook]    Script Date: 02/05/2010 16:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBook](
	[BookId] [int] IDENTITY(1,1) NOT NULL,
	[BookName] [varchar](100) NOT NULL,
	[AuthorId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[BookId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [tblBook_BookName_Index] ON [dbo].[tblBook] 
(
	[BookId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tblBook] ON
INSERT [dbo].[tblBook] ([BookId], [BookName], [AuthorId]) VALUES (1, N'The Day of the Triffids', 2)
INSERT [dbo].[tblBook] ([BookId], [BookName], [AuthorId]) VALUES (2, N'Girl with Dragon Tattoo', 1)
INSERT [dbo].[tblBook] ([BookId], [BookName], [AuthorId]) VALUES (3, N'The Chrysalids', 2)
INSERT [dbo].[tblBook] ([BookId], [BookName], [AuthorId]) VALUES (4, N'The Kraken wakes', 2)
INSERT [dbo].[tblBook] ([BookId], [BookName], [AuthorId]) VALUES (5, N'Girl who Played with fire', 1)
SET IDENTITY_INSERT [dbo].[tblBook] OFF
/****** Object:  StoredProcedure [dbo].[spMain]    Script Date: 02/05/2010 16:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spMain] AS

BEGIN TRY
	EXECUTE spSub 
END TRY

BEGIN CATCH
	SELECT 'Error report in MAIN'
	RETURN -1
END CATCH
	
SELECT 'Finished normally'
GO
/****** Object:  StoredProcedure [dbo].[spInsertBook]    Script Date: 02/05/2010 16:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spInsertBook](
	@BookTitle varchar(50),
	@AuthorFirstName varchar(50),
	@AuthorLastName varchar(50)
) AS

BEGIN TRANSACTION
PRINT 'Just begun - ' + 
	CAST(@@TRANCOUNT AS varchar(2)) 

DECLARE @AuthorId int

BEGIN TRY
	INSERT INTO tblAuthor (
		FirstName, LastName
	) VALUES (
		@AuthorFirstName,
		@AuthorLastName
	)
	SET @AuthorId = @@Identity
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
	SELECT 'Can not create author'
	RETURN -1
END CATCH

PRINT 'Created author - ' + 
	CAST(@@TRANCOUNT AS varchar(2)) 

-- now try to insert book title
BEGIN TRY
	INSERT INTO tblBook (
		AuthorId, 
		BookName
	) VALUES (
		@AuthorId, 
		@BookTitle
	)
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
	SELECT 'Can not create book'
	RETURN -2
END CATCH

PRINT 'Created book - ' + 
	CAST(@@TRANCOUNT AS varchar(2)) 

-- if we get here, everything's OK
COMMIT TRANSACTION

-- list out the final books
SELECT 
	b.BookName,
	a.FirstName + ' ' + a.LastName as Author
FROM
	tblAuthor as a
	JOIN tblBook AS b ON a.AuthorId = b.AuthorId
ORDER BY
	b.BookId desc
GO
/****** Object:  StoredProcedure [dbo].[spCreateAndLinkBookTables]    Script Date: 02/05/2010 16:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spCreateAndLinkBookTables]
AS

-- delete any existing tables (explained in separate chapter)
if object_id('tblBook','U') is not null DROP TABLE tblBook
if object_id('tblAuthor','U') is not null DROP TABLE tblAuthor

-- create a table of authors, with the AuthorId being primary key
-- and forcing entries in other 2 columns (disallowing nulls)
CREATE TABLE tblAuthor (
	AuthorId int IDENTITY(1,1) PRIMARY KEY,
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL
)

-- index the LastName column, and make sure don't enter author with
-- the same name twice by making combination of columns unique
CREATE INDEX tblAuthor_LastName_Index ON tblAuthor(AuthorId)
ALTER TABLE tblAuthor ADD CONSTRAINT uqNames UNIQUE (FirstName,LastName)

-- create 2 new authors in our new table
INSERT INTO tblAuthor( FirstName, LastName) VALUES ('Stieg', 'Larsson')
INSERT INTO tblAuthor( FirstName, LastName ) VALUES ('John', 'Wyndham')
INSERT INTO tblAuthor( FirstName, LastName ) VALUES ('Lynne Reid', 'Banks')

-- create table of books, with the BookId being the primary key
-- and no empty book names allowed 
CREATE TABLE tblBook (
	BookId int IDENTITY(1,1) PRIMARY KEY,
	BookName varchar(100) NOT NULL,
	AuthorId int
)

-- index the book's name, for faster sorting
CREATE INDEX tblBook_BookName_Index ON tblBook(BookId)

-- set relationship between the two tables, enforcing 
-- referential integrity and cascade update/delete
ALTER TABLE 
	tblBook 
ADD CONSTRAINT
	fk_tblBook_tblAuthor FOREIGN KEY (AuthorId) 
	REFERENCES tblAuthor(AuthorId)

	-- optional extra settings to enforce cascade
	-- updating and cascade deleting
	ON UPDATE CASCADE 
	ON DELETE CASCADE

-- insert a few books
INSERT INTO tblBook (BookName, AuthorId) VALUES ('The Day of the Triffids', 2)
INSERT INTO tblBook (BookName, AuthorId) VALUES ('Girl with Dragon Tattoo', 1)
INSERT INTO tblBook (BookName, AuthorId) VALUES ('The Chrysalids', 2)
INSERT INTO tblBook (BookName, AuthorId) VALUES ('The Kraken wakes', 2)
INSERT INTO tblBook (BookName, AuthorId) VALUES ('Girl who Played with fire', 1)
GO
/****** Object:  ForeignKey [fk_tblBook_tblAuthor]    Script Date: 02/05/2010 16:25:46 ******/
ALTER TABLE [dbo].[tblBook]  WITH CHECK ADD  CONSTRAINT [fk_tblBook_tblAuthor] FOREIGN KEY([AuthorId])
REFERENCES [dbo].[tblAuthor] ([AuthorId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblBook] CHECK CONSTRAINT [fk_tblBook_tblAuthor]
GO
