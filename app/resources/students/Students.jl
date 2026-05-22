module Students

using SearchLight
import SearchLight: AbstractModel, DbId
import Base: @kwdef

export Student

@kwdef mutable struct Student <: AbstractModel
    army_nr::DbId = DbId()          # Custom PK (ArmyNr) — exactly like your bachelor thesis
    first_name::String = ""
    last_name::String = ""
end

# Tell SearchLight to use army_nr as primary key (override default id)
primarykey(::Type{Student}) = :army_nr

end