# =============================================
# WAIS Server - using new HtmlTables structure
# =============================================

using Pkg
Pkg.activate(".")

include("HtmlTables.jl")

# For SQLite
# include("HtmlTablesSQLite.jl")
# using .HtmlTablesSQLite

# For MySQL
# include("HtmlTablesMySQL.jl")
# using .HtmlTablesMySQL

# For PostgreSQL
include("HtmlTablesPostgreSQL.jl")
using .HtmlTablesPostgreSQL
using .HtmlTables
using HTTP

ENV["htmltables_dbpath"] = raw"D:\MaP\GenieSearchLightTest\SearchLightDemo\demo2_ReservationSystem.db"

const TABLEFORMAT = "<style>table, th, td {border: 1px solid black;}</style>"
const ROUTER = HTTP.Router()

# ====================== HOME PAGE ======================
function home(req::HTTP.Messages.Request)
    """
    <html>
        <head><title>RMA Home</title></head>
        <body>
            <h1>Welcome to the Reservation Management Application (RMA)</h1>
            
            <h2>Simple table views:</h2>
            <a href='/Person'>Persons</a><br>
            <a href='/Location'>Locations</a><br>
            <a href='/Reservation'>Reservations</a><br><br>
            
            <h2>Join Query Results:</h2>
            <a href='/PersonWithPhones'>Person with phones</a><br>
            <a href='/ReservationInformation'>ReservationInformation</a><br>
            <a href='/ReservationInformationExtended'>ReservationInformationExtended</a><br>
            <a href='/ReservationInformationAdditionalPersons'>ReservationInformationAdditionalPersons</a>
        </body>
    </html>
    """
end

# ====================== SIMPLE TABLES ======================
function person(req) 
    HtmlTables.htmlTable("Person")
end

function location(req) 
    HtmlTables.htmlTable("Location")
end

function reservation(req) 
    HtmlTables.htmlTable("Reservation")
end

# ====================== JOIN QUERIES ======================
function personWithPhones(req)
    qry = "select p.*, ph.phoneNr from Person p INNER JOIN Phones ph on p.armyNr = ph.armyNr order by armyNr asc;"
    HtmlTables.htmlTableForQuery(qry)
end

function reservationInformation(req)
    qry = """
        select r.startDate, r.endDate, p.firstName, p.surName
        from Person p 
        inner join primaryContact pc ON p.armyNr = pc.armyNr
        inner join Reservation r ON pc.reservationId = r.reservationId
    """
    HtmlTables.htmlTableForQuery(qry)
end

function reservationInformationExtended(req)
    qry = """
        select 
            date(r.startDate) as StartDate, 
            cast(julianday(r.endDate)-julianday(r.startDate) as INT) as Duration, 
            p.surName, 
            p.firstName,
            l.building,
            l.floor,
            l.roomNr,
            l.maxCapacity
        from 
            Person p 
                inner join primaryContact pc 	ON 	p.armyNr = pc.armyNr
                inner join Reservation r		ON 	pc.reservationId = r.reservationId
                inner join hasLocation hl		ON 	r.reservationId = hl.reservationId
                INNER join Location l 			on 	hl.building = l.building
                                                    AND
                                                    hl.floor = l.floor
                                                    AND
                                                    hl.roomNr = l.roomNr;
    """
    HtmlTables.htmlTableForQuery(qry)
end

function reservationInformationAdditionalPersons(req)
    qry = """
        select 
            date(r.startDate) as StartDate, 
            p.firstName,
            p.surName, 
            r.reservationId,
            r.startDate,
            r.endDate,
            p2.firstName,
            p2.surName
        from 
            Person p 
                inner join primaryContact pc 	ON 	p.armyNr = pc.armyNr
                inner join Reservation r		ON 	pc.reservationId = r.reservationId
                inner join additionalPersons a 	ON 	r.reservationId = a.reservationId
                INNER join Person	p2			ON 	a.armyNr = p2.armyNr
    """
    HtmlTables.htmlTableForQuery(qry)
end

# ====================== REGISTER ROUTES ======================
HTTP.register!(ROUTER, "GET", "/", home)
HTTP.register!(ROUTER, "GET", "/Person", person)
HTTP.register!(ROUTER, "GET", "/Location", location)
HTTP.register!(ROUTER, "GET", "/Reservation", reservation)
HTTP.register!(ROUTER, "GET", "/PersonWithPhones", personWithPhones)
HTTP.register!(ROUTER, "GET", "/ReservationInformation", reservationInformation)
HTTP.register!(ROUTER, "GET", "/ReservationInformationExtended", reservationInformationExtended)
HTTP.register!(ROUTER, "GET", "/ReservationInformationAdditionalPersons", reservationInformationAdditionalPersons)

# ====================== START SERVER ======================
@info "WAIS server starting on http://127.0.0.1:8080"
server = HTTP.serve!(ROUTER, "127.0.0.1", 8080)

# Keep the server alive on Windows
while true
    sleep(1)
end