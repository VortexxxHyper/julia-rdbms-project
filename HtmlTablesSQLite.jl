module HtmlTablesSQLite

import ..HtmlTables
using SQLite
using DBInterface

# Extend the public functions with SQLite implementation
function HtmlTables.htmlTable(tableName)
    dbpath = HtmlTables.getDbPath()
    databaseConnection = SQLite.DB(dbpath)
    SqlStatement = "SELECT * FROM $tableName"
    SqlResult = DBInterface.execute(databaseConnection, SqlStatement)
    headers = HtmlTables.htmlTableHeaders(SqlResult)
    data = HtmlTables.htmlTableData(SqlResult)
    return "<table>"*headers*data*"</table>"
end

function HtmlTables.htmlTableForQuery(SqlStatement)
    dbpath = HtmlTables.getDbPath()
    databaseConnection = SQLite.DB(dbpath)
    SqlResult = DBInterface.execute(databaseConnection, SqlStatement)
    headers = HtmlTables.htmlTableHeaders(SqlResult)
    data = HtmlTables.htmlTableData(SqlResult)
    return "<table>"*headers*data*"</table>"
end

# The other two functions can stay as they are for now (or implement later)
function HtmlTables.retrievePKtuplesForTable(tableName)
    # (you can copy the original code here if you need it later)
    error("retrievePKtuplesForTable not yet implemented for SQLite adapter")
end

function HtmlTables.executeInsert(SqlStatement)
    dbpath = HtmlTables.getDbPath()
    databaseConnection = SQLite.DB(dbpath)
    SqlResult = DBInterface.execute(databaseConnection, SqlStatement)
    return SqlResult
end

end  # module HtmlTablesSQLite