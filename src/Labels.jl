module Labels

################################################################################
##
## Dependencies
##
################################################################################

using DataFrames, DataAPI

##############################################################################
##
## Exported methods and types (in addition to everything reexported above)
##
##############################################################################

export Label, datalab, varlab, varlabs, vallab, save_labels, load_labels

mutable struct Label
    data::String
    var::Dict{Symbol,String}
    val::Dict{Symbol,Dict}
    valfmt::Dict{Symbol,Symbol}

    Label(data, var, val, valkey) = new(data, var, val, valfmt)
    Label() = Label("", Dict(), Dict(), Dict() )
end

"""
    datalab(l::Label)

Returns data label from the `l` Label object.
"""
function datalab(l::Label)
    return l.data
end

"""
    varlab(l::Label,v::Symbol)

Produces the variable description associated with the `v` variable in the `l` Labels.
"""
function varlab(l::Label, v::Symbol)
    return haskey(l.var, v) ? l.var[v] : string(v)
end

"""
    varlabs(l::Label,vv::Vector{Symbol})

Produces a vector of variable descriptions associated with variables
in the `vv` vector from the `l` Labels.
"""
function varlabs(l::Label, vv::Vector{Symbol})
    vec = []
    for v in vv
        push!(vec, haskey(l.var, v) ? l.var[v] : string(v))
    end
    return vec
end

"""
    vallab(l::Label,v::Symbol,val)

Returns the value label associated with `val` value for the `v` variable in the `l` Labels.
"""
function vallab(l::Label, v::Symbol, val)
    lname = valfmt(l, v)

    if lname == nothing
        return string(val)
    end

    return haskey(l.val, lname) && haskey(l.val[lname], val) ? l.val[lname][val] : string(val)
end

function valfmt(l::Label, v::Symbol)
    if haskey(l.valfmt,v)
        return string(l.valfmt[v])
    end
    return ""
end

function save_labels(l::Label, df::AbstractDataFrame; filename::String = "")
    if filename == ""
        filename = "labels.jlfmt"
    end

    save_object(filename,l)
    metadata!(df,"Labels",l, style=:note);
end

function load_labels(filename::String)
    return load_object(filename)
end
function load_labels(df::AbstractDataFrame)
    fn = metadata(df,"Labels")
    if fn != nothing || fn != ""
        return load_labels(fn)
    end
end

end # end of module
