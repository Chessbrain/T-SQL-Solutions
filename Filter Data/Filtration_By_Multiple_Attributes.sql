-- This solution exists for cases when you have multiple checkboxes on your web page, 
-- and you want the user to be able to filter based on the selected items.

-- This solution will use Students and Semesters as an example.

CREATE TABLE Student(
Id int PRIMARY KEY IDENTITY (1,1) NOT NULL,
StudentName nvarchar(30) NOT NULL
)
GO

CREATE TABLE Semester(
Id int PRIMARY KEY IDENTITY (1,1) NOT NULL,
Semester nvarchar(10) NOT NULL
)
GO

CREATE TABLE EnrollmentTable(
Id int PRIMARY KEY IDENTITY (1,1) NOT NULL,
StudentId int CONSTRAINT FK_Enroll_Student FOREIGN KEY (StudentId) REFERENCES Student(Id),
SemesterId int CONSTRAINT FK_Enroll_Semester FOREIGN KEY (SemesterId) REFERENCES Semester(Id)
)
GO

-- Inserting some data 

INSERT INTO Student
VALUES ('A'), ('B'), ('C'), ('D'), ('E'), ('F'), ('G'), ('H'), ('I'), ('J'), ('K'), ('L'), ('M')
GO

INSERT INTO Semester
VALUES ('First'), ('Second'), ('Third')
GO

INSERT INTO EnrollmentTable
VALUES (1,1), (2,2), (3,2), (4,1), (5,3), (6,2), (7,3), (8,2), (9,1), (10,1), (11,2), (12,1), (13,3)
GO

-- MSSQL Does not allow forwarding TABLE data types to a FUNCTION or PROCEDURE unless they are user defined.
-- If you have more attributes you need to filter by, simply add them to this table.

CREATE TYPE SelectedElements AS TABLE (
ElementId int
)
GO

CREATE PROCEDURE sp_Student_BySemester (@SemesterIDs AS SelectedSemesters READONLY)
AS
BEGIN
	
	SELECT S.StudentName, SE.Semester
	FROM EnrollmentTable AS ET
		INNER JOIN @SemesterIDs AS SIDs
			ON ET.SemesterId = SIDs.SemesterId -- JOIN based on your selected fields
		INNER JOIN Semester AS SE
			ON SE.Id = SIDs.SemesterId
		INNER JOIN Student AS S
			ON ET.StudentId = S.Id

RETURN 0
END
GO

-- Testing the procedure

DECLARE @Input AS SelectedSemesters

INSERT INTO @Input VALUES (1),(2) -- Selecting students from the 1st and 2nd semester

EXEC sp_Student_BySemester @Input
GO
