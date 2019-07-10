-- This query uses 0x0a for ROWTERMINATOR because TSVs sometimes give unintended results when using \t due to arrays.
-- If arrays exist in the source data, keep in mind this query does not split the arrays into separate rows on input.

BULK INSERT T
FROM 'FilePath'
WITH (
	FIRSTROW = 2, -- Exclude this if your data does not have a header.
	ROWTERMINATOR = '0x0a'
)
GO