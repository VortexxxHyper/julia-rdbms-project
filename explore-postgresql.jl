using DataFrames, LibPQ, Tables

conn = LibPQ.Connection("dbname=postgres user=postgres password='162ssmw' host=localhost port=1620")

try
    execute(conn, """
        CREATE TABLE IF NOT EXISTS Student (
            ArmyNr    SERIAL PRIMARY KEY,
            FirstName TEXT,
            LastName  TEXT
        )
    """)

    execute(conn, """
        CREATE TABLE IF NOT EXISTS Offering (
            CourseCode SERIAL PRIMARY KEY,
            CourseName TEXT
        )
    """)

    execute(conn, """
        CREATE TABLE IF NOT EXISTS Enrollment (
            ArmyNr INTEGER,
            CourseCode INTEGER,
            FOREIGN KEY (ArmyNr) REFERENCES Student(ArmyNr) ON DELETE CASCADE,
            FOREIGN KEY (CourseCode) REFERENCES Offering(CourseCode) ON DELETE CASCADE
        )
    """)

    execute(conn, """
        INSERT INTO Student (FirstName, LastName) 
        VALUES 
            ('Alice', 'Johnson'),
            ('Bob', 'Smith'),
            ('Charlie', 'Brown'),
            ('Diana', 'Green')
    """)

    execute(conn, """
        INSERT INTO Offering (CourseName) 
        VALUES 
            ('Math'),
            ('Physics'),
            ('History'),
            ('Computer Science')
    """)

    execute(conn, """
        INSERT INTO Enrollment (ArmyNr, CourseCode) 
        VALUES 
            (1, 1),
            (1, 2),
            (2, 1),
            (2, 3),
            (3, 4),
            (4, 1),
            (4, 2),
            (4, 3)
    """)

    println("Student Table:")
    students = DataFrame(execute(conn, "SELECT * FROM Student"))
    println(students)

    println("\nOffering Table:")
    offerings = DataFrame(execute(conn, "SELECT * FROM Offering"))
    println(offerings)

    println("\nEnrollment Table:")
    enrollments = DataFrame(execute(conn, "SELECT * FROM Enrollment"))
    println(enrollments)
finally
    LibPQ.close(conn)
end
