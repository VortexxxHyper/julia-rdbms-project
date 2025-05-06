using DataFrames, SQLite, Tables

db = SQLite.DB("explore-sqlite.db")

try
    SQLite.execute(db, """
        CREATE TABLE IF NOT EXISTS Student (
            ArmyNr    INTEGER PRIMARY KEY,
            FirstName TEXT,
            LastName  TEXT
        )
    """)

    SQLite.execute(db, """
        CREATE TABLE IF NOT EXISTS Offering (
            CourseCode INTEGER PRIMARY KEY,
            CourseName TEXT
        )
    """)

    SQLite.execute(db, """
        CREATE TABLE IF NOT EXISTS Enrollment (
            ArmyNr INTEGER,
            CourseCode INTEGER,
            FOREIGN KEY (ArmyNr) REFERENCES Student(ArmyNr) ON DELETE CASCADE,
            FOREIGN KEY (CourseCode) REFERENCES Offering(CourseCode) ON DELETE CASCADE
        )
    """)

    SQLite.execute(db, """
        INSERT INTO Student (ArmyNr, FirstName, LastName) 
        VALUES 
            (1, 'Alice', 'Johnson'),
            (2, 'Bob', 'Smith'),
            (3, 'Charlie', 'Brown'),
            (4, 'Diana', 'Green')
    """)

    SQLite.execute(db, """
        INSERT INTO Offering (CourseCode, CourseName) 
        VALUES 
            (101, 'Math'),
            (102, 'Physics'),
            (103, 'History'),
            (104, 'Computer Science')
    """)

    SQLite.execute(db, """
        INSERT INTO Enrollment (ArmyNr, CourseCode) 
        VALUES 
            (1, 101),
            (1, 102),
            (2, 101),
            (2, 103),
            (3, 104),
            (4, 101),
            (4, 102),
            (4, 103)
    """)

    println("Student Table:")
    students = DataFrame(DBInterface.execute(db, "SELECT * FROM Student"))
    println(students)

    println("\nOffering Table:")
    offerings = DataFrame(DBInterface.execute(db, "SELECT * FROM Offering"))
    println(offerings)

    println("\nEnrollment Table:")
    enrollments = DataFrame(DBInterface.execute(db, "SELECT * FROM Enrollment"))
    println(enrollments)
finally
    SQLite.close(db)
end