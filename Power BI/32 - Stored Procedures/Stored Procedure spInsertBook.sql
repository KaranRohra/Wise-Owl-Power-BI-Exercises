use books;

DELETE FROM tblAuthor;
DELETE FROM tblBook;

SELECT * FROM tblBook;
SELECT * FROM tblAuthor;

GO
ALTER PROC [dbo].[spInsertBook](
	@BookTitle varchar(50),
	@AuthorFirstName varchar(50),
	@AuthorLastName varchar(50)
) AS

BEGIN TRANSACTION
PRINT 'Just begun - ' + 
	CAST(@@TRANCOUNT AS varchar(2)) 

DECLARE @AuthorId int


IF (SELECT FirstName + LastName FROM tblAuthor WHERE FirstName = @AuthorFirstName AND LastName = @AuthorLastName) IN (@AuthorFirstName + @AuthorLastName)
	BEGIN
		SET @AuthorId = (SELECT AuthorId FROM tblAuthor WHERE FirstName = @AuthorFirstName AND LastName = @AuthorLastName)
	END
ELSE
	BEGIN
		INSERT INTO tblAuthor (
			FirstName, LastName
		) VALUES (
			@AuthorFirstName,
			@AuthorLastName
		)
		SET @AuthorId = @@Identity
	END


PRINT 'Created author - ' + 
	CAST(@@TRANCOUNT AS varchar(2)) 

-- now try to insert book title
INSERT INTO tblBook (
	AuthorId, 
	BookName
) VALUES (
	@AuthorId, 
	@BookTitle
)



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
