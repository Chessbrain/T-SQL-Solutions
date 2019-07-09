-- Why this solutions exists:
-- Basically, my thought behind this solution was to separate functionalities so everything is not in one place.
-- For example if you need to calculate the Median somewhere else and not just in this PROCEDURE.
-- As well as simply for easier to read code.

CREATE TYPE MedianTable AS TABLE (
[Number] int NULL
)
GO

-- I've created a TABLE data type because it is (as far as I know) the only way to send a table parameter to a function

CREATE FUNCTION fnMedian (@input as MedianTable READONLY, @count as int)
RETURNS INT
AS
BEGIN
RETURN (
	SELECT Median FROM 
		(
		SELECT	o.number AS [Median],
				rn=ROW_NUMBER() OVER (ORDER BY o.number ASC)
		FROM    @input AS o        
		) AS x
	WHERE rn =ROUND(@count/2.0,0)                   
)
END
GO

CREATE PROCEDURE dbo.spAvg_Median 
    @input nvarchar(20) 
AS
BEGIN
    declare @split AS MedianTable
    declare @count int

    INSERT INTO @split SELECT VALUE FROM string_split(@input, ',')
    SELECT @count=count(*) from @split

	SELECT	AVG(A.number) as [Average], 
			dbo.fnMedian(@split, @count) AS [Median]
	FROM @split A
END
RETURN 0 
GO

EXEC dbo.spAvg_Median'1,5,9,8,7'