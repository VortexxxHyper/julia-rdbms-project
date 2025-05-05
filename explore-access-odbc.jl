using DataFrames
using DBInterface
using ODBC

# Define the DSN (Data Source Name) for the Access Database
const DSN_NAME = "explore-access-odbc"  # Ensure this DSN exists in ODBC settings

# Establish a connection to the MS Access database
conn = ODBC.Connection(DSN_NAME)

try
    # Drop the tables if they exist
    try
        DBInterface.execute(conn, "DROP TABLE Student")
    catch e
        println("Student table does not exist, skipping DROP.")
    end

    try
        DBInterface.execute(conn, "DROP TABLE Offering")
    catch e
        println("Offering table does not exist, skipping DROP.")
    end

    try
        DBInterface.execute(conn, "DROP TABLE Enrollment")
    catch e
        println("Enrollment table does not exist, skipping DROP.")
    end

    # 1. Create the Student table with AUTOINCREMENT instead of COUNTER
    try
        DBInterface.execute(conn, """
            CREATE TABLE Student (
                ArmyNr AUTOINCREMENT PRIMARY KEY,
                FirstName TEXT,
                LastName TEXT
            );
        """)
        println("Student table created successfully.")
    catch e
        println("Error creating Student table: ", e)
    end

    # 2. Create the Offering table
    try
        DBInterface.execute(conn, """
            CREATE TABLE Offering (
                CourseCode AUTOINCREMENT PRIMARY KEY,
                CourseName TEXT
            );
        """)
        println("Offering table created successfully.")
    catch e
        println("Error creating Offering table: ", e)
    end

    # 3. Create the Enrollment table
    try
        DBInterface.execute(conn, """
            CREATE TABLE Enrollment (
                EnrollmentID AUTOINCREMENT PRIMARY KEY,
                ArmyNr INTEGER,
                CourseCode INTEGER,
                FOREIGN KEY (ArmyNr) REFERENCES Student(ArmyNr),
                FOREIGN KEY (CourseCode) REFERENCES Offering(CourseCode)
            );
        """)
        println("Enrollment table created successfully.")
    catch e
        println("Error creating Enrollment table: ", e)
    end

    # 4. Insert data into the Student table (Don't specify ArmyNr as it's auto-generated)
    try
        DBInterface.execute(conn, "INSERT INTO Student (FirstName, LastName) VALUES ('Alice', 'Johnson');")
        DBInterface.execute(conn, "INSERT INTO Student (FirstName, LastName) VALUES ('Bob', 'Smith');")
        DBInterface.execute(conn, "INSERT INTO Student (FirstName, LastName) VALUES ('Charlie', 'Brown');")
        DBInterface.execute(conn, "INSERT INTO Student (FirstName, LastName) VALUES ('Diana', 'Green');")
        println("Data inserted into Student table.")
    catch e
        println("Error inserting data into Student table: ", e)
    end

    # 5. Insert data into the Offering table (Don't specify CourseCode as it's auto-generated)
    try
        DBInterface.execute(conn, "INSERT INTO Offering (CourseName) VALUES ('Math');")
        DBInterface.execute(conn, "INSERT INTO Offering (CourseName) VALUES ('Physics');")
        DBInterface.execute(conn, "INSERT INTO Offering (CourseName) VALUES ('History');")
        DBInterface.execute(conn, "INSERT INTO Offering (CourseName) VALUES ('Computer Science');")
        println("Data inserted into Offering table.")
    catch e
        println("Error inserting data into Offering table: ", e)
    end

    # 6. Insert data into the Enrollment table (Don't specify EnrollmentID as it's auto-generated)
    try
        DBInterface.execute(conn, "INSERT INTO Enrollment (ArmyNr, CourseCode) VALUES (1, 1);")
        DBInterface.execute(conn, "INSERT INTO Enrollment (ArmyNr, CourseCode) VALUES (1, 2);")
        DBInterface.execute(conn, "INSERT INTO Enrollment (ArmyNr, CourseCode) VALUES (2, 1);")
        DBInterface.execute(conn, "INSERT INTO Enrollment (ArmyNr, CourseCode) VALUES (2, 3);")
        DBInterface.execute(conn, "INSERT INTO Enrollment (ArmyNr, CourseCode) VALUES (3, 4);")
        DBInterface.execute(conn, "INSERT INTO Enrollment (ArmyNr, CourseCode) VALUES (4, 1);")
        DBInterface.execute(conn, "INSERT INTO Enrollment (ArmyNr, CourseCode) VALUES (4, 2);")
        DBInterface.execute(conn, "INSERT INTO Enrollment (ArmyNr, CourseCode) VALUES (4, 3);")
        println("Data inserted into Enrollment table.")
    catch e
        println("Error inserting data into Enrollment table: ", e)
    end

    # 7. Retrieve and display data from the Student, Offering, and Enrollment tables
    try
        println("\n--- Student Table ---")
        students = DataFrame(DBInterface.execute(conn, "SELECT * FROM Student"))
        println(students)
    catch e
        println("Error retrieving data from Student table: ", e)
    end

    try
        println("\n--- Offering Table ---")
        offerings = DataFrame(DBInterface.execute(conn, "SELECT * FROM Offering"))
        println(offerings)
    catch e
        println("Error retrieving data from Offering table: ", e)
    end

    try
        println("\n--- Enrollment Table ---")
        enrollments = DataFrame(DBInterface.execute(conn, "SELECT * FROM Enrollment"))
        println(enrollments)
    catch e
        println("Error retrieving data from Enrollment table: ", e)
    end

finally
    # Ensure the database connection is closed correctly
    DBInterface.close!(conn)
end
# Note: The above code assumes that the ODBC driver for MS Access is properly installed and configured on your system.
# The DSN_NAME should match the name you set up in your ODBC Data Source Administrator.