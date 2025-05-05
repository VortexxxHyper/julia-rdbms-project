# This script demonstrates how to interact with a PostgreSQL database using Julia.
# It simply copies the explor-sqlite.jl but into a PostgreSQL environemnt.
#
# Dependencies:
# - DataFrames: For handling tabular data.
# - LibPQ: For connecting to and executing queries on a PostgreSQL database.
# - Tables: For interoperability between tabular data structures.
#
# Usage:
# - Ensure PostgreSQL is installed and running on your system (using pgAdmin 4).
# - Run this script in a Julia environment.

using DataFrames
using LibPQ
using Tables

# Establish a connection to the PostgreSQL database
conn = LibPQ.Connection("dbname=postgres user=postgres password='162ssmw' host=localhost port=1620")

try
    # 1. Create the Student table
    execute(conn, """
        CREATE TABLE IF NOT EXISTS Student (
            ArmyNr    SERIAL PRIMARY KEY,
            FirstName TEXT,
            LastName  TEXT
        )
    """)

    # 2. Create the Offering table
    execute(conn, """
        CREATE TABLE IF NOT EXISTS Offering (
            CourseCode SERIAL PRIMARY KEY,
            CourseName TEXT
        )
    """)

    # 3. Create the Enrollment table
    execute(conn, """
        CREATE TABLE IF NOT EXISTS Enrollment (
            ArmyNr INTEGER,
            CourseCode INTEGER,
            FOREIGN KEY (ArmyNr) REFERENCES Student(ArmyNr) ON DELETE CASCADE,
            FOREIGN KEY (CourseCode) REFERENCES Offering(CourseCode) ON DELETE CASCADE
        )
    """)

    # 4. Insert data into the Student table
    execute(conn, """
        INSERT INTO Student (FirstName, LastName) 
        VALUES 
            ('Alice', 'Johnson'),
            ('Bob', 'Smith'),
            ('Charlie', 'Brown'),
            ('Diana', 'Green')
    """)

    # 5. Insert data into the Offering table
    execute(conn, """
        INSERT INTO Offering (CourseName) 
        VALUES 
            ('Math'),
            ('Physics'),
            ('History'),
            ('Computer Science')
    """)

    # 6. Insert data into the Enrollment table
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

    # 7. Display table using DataFrames in terminal as output
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
    # Ensure the database connection is always closed, even if an error occurs
    LibPQ.close(conn)
end