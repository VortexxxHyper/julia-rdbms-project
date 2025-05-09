using DataFrames, MySQL, Tables, DBInterface

conn = DBInterface.connect(MySQL.Connection, "127.0.0.1", "root", "162ssmw")
DBInterface.execute(conn, "USE mysql")

try
    DBInterface.execute(conn, """
            CREATE TABLE IF NOT EXISTS Student (
                ArmyNr    INT AUTO_INCREMENT PRIMARY KEY,
                FirstName VARCHAR(255),
                LastName  VARCHAR(255)
            )
        """)

    DBInterface.execute(conn, """
            CREATE TABLE IF NOT EXISTS Offering (
                CourseCode INT AUTO_INCREMENT PRIMARY KEY,
                CourseName VARCHAR(255)
            )
        """)

    DBInterface.execute(conn, """
            CREATE TABLE IF NOT EXISTS Enrollment (
                ArmyNr INT,
                CourseCode INT,
                FOREIGN KEY (ArmyNr) REFERENCES Student(ArmyNr) ON DELETE CASCADE,
                FOREIGN KEY (CourseCode) REFERENCES Offering(CourseCode) ON DELETE CASCADE
            )
        """)

    DBInterface.execute(conn, """
            INSERT INTO Student (FirstName, LastName) 
            VALUES 
                ('Alice', 'Johnson'),
                ('Bob', 'Smith'),
                ('Charlie', 'Brown'),
                ('Diana', 'Green')
        """)

    DBInterface.execute(conn, """
            INSERT INTO Offering (CourseName) 
            VALUES 
                ('Math'),
                ('Physics'),
                ('History'),
                ('Computer Science')
        """)

    DBInterface.execute(conn, """
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
    students = DataFrame(DBInterface.execute(conn, "SELECT * FROM Student"))
    println(students)

    println("\nOffering Table:")
    offerings = DataFrame(DBInterface.execute(conn, "SELECT * FROM Offering"))
    println(offerings)

    println("\nEnrollment Table:")
    enrollments = DataFrame(DBInterface.execute(conn, "SELECT * FROM Enrollment"))
    println(enrollments)

finally
    MySQL.close(conn)
end
