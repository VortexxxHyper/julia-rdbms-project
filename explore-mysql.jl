# Dependencies:
# - DataFrames: For handling tabular data.
# - MySQL: For connecting to and executing queries on a MySQL database.
# - Tables: For interoperability between tabular data structures.
#
# Usage:
# - Ensure MySQL 8.4.4 LTS is installed and running.
# - Run this script in a Julia environment.

using DataFrames
using MySQL
using Tables
using DBInterface

# Establish a connection to the MySQL database using DBInterface.connect
# Parameters:
# - "127.0.0.1": Hostname of the MySQL server
# - "root": Username for authentication
# - "162ssmw": Password for authentication
# - "mysql": Database name to connect to
# - 3306: Port number for the MySQL server
conn = DBInterface.connect(MySQL.Connection, "127.0.0.1", "root", "162ssmw")
DBInterface.execute(conn, "USE mysql")

try
    # 1. Create the Student table
    DBInterface.execute(conn, """
            CREATE TABLE IF NOT EXISTS Student (
                ArmyNr    INT AUTO_INCREMENT PRIMARY KEY,
                FirstName VARCHAR(255),
                LastName  VARCHAR(255)
            )
        """)

    # 2. Create the Offering table
    DBInterface.execute(conn, """
            CREATE TABLE IF NOT EXISTS Offering (
                CourseCode INT AUTO_INCREMENT PRIMARY KEY,
                CourseName VARCHAR(255)
            )
        """)

    # 3. Create the Enrollment table
    DBInterface.execute(conn, """
            CREATE TABLE IF NOT EXISTS Enrollment (
                ArmyNr INT,
                CourseCode INT,
                FOREIGN KEY (ArmyNr) REFERENCES Student(ArmyNr) ON DELETE CASCADE,
                FOREIGN KEY (CourseCode) REFERENCES Offering(CourseCode) ON DELETE CASCADE
            )
        """)

    # 4. Insert data into the Student table
    DBInterface.execute(conn, """
            INSERT INTO Student (FirstName, LastName) 
            VALUES 
                ('Alice', 'Johnson'),
                ('Bob', 'Smith'),
                ('Charlie', 'Brown'),
                ('Diana', 'Green')
        """)

    # 5. Insert data into the Offering table
    DBInterface.execute(conn, """
            INSERT INTO Offering (CourseName) 
            VALUES 
                ('Math'),
                ('Physics'),
                ('History'),
                ('Computer Science')
        """)

    # 6. Insert data into the Enrollment table
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

    # 7. Display tables using DataFrames in the terminal output
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
    # Ensure the database connection is always closed, even if an error occurs
    MySQL.close(conn)
end
