using DataFrames
using SQLite
using Tables

# Establish a connection to the SQLite database
db = SQLite.DB("explore-sqlite.db")

try
    # 1. Create the Student table
    SQLite.execute(db, """
        CREATE TABLE IF NOT EXISTS Student (
            ArmyNr    INTEGER PRIMARY KEY,
            FirstName TEXT,
            LastName  TEXT
        )
    """)

    # 2. Create the Offering table
    SQLite.execute(db, """
        CREATE TABLE IF NOT EXISTS Offering (
            CourseCode INTEGER PRIMARY KEY,
            CourseName TEXT
        )
    """)

    # 3. Create the Enrollment table
    SQLite.execute(db, """
        CREATE TABLE IF NOT EXISTS Enrollment (
            ArmyNr INTEGER,
            CourseCode INTEGER,
            FOREIGN KEY (ArmyNr) REFERENCES Student(ArmyNr) ON DELETE CASCADE,
            FOREIGN KEY (CourseCode) REFERENCES Offering(CourseCode) ON DELETE CASCADE
        )
    """)

    # 4. Insert data into the Student table
    SQLite.execute(db, """
        INSERT INTO Student (ArmyNr, FirstName, LastName) 
        VALUES 
            (1, 'Alice', 'Johnson'),
            (2, 'Bob', 'Smith'),
            (3, 'Charlie', 'Brown'),
            (4, 'Diana', 'Green')
    """)

    # 5. Insert data into the Offering table
    SQLite.execute(db, """
        INSERT INTO Offering (CourseCode, CourseName) 
        VALUES 
            (101, 'Math'),
            (102, 'Physics'),
            (103, 'History'),
            (104, 'Computer Science')
    """)

    # 6. Insert data into the Enrollment table
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

    # 7. Optional: Display table using DataFrames in terminal as output
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
    # Ensure the database connection is always closed, even if an error occurs
    SQLite.close(db)
end
