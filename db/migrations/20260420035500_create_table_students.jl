module CreateTableStudents

using SearchLight
using SearchLightPostgreSQL

function up()
    SearchLight.query("""
        CREATE TABLE students (
            army_nr INTEGER PRIMARY KEY,
            first_name VARCHAR(255),
            last_name VARCHAR(255)
        )
    """)
end

function down()
    SearchLight.query("DROP TABLE students")
end

end