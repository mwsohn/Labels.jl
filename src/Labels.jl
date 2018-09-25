module Labels

# package code goes here
export Label, varlab, vallab, lblname, defined

struct Label
    var::Dict{Symbol,String}
    val::Dict{Symbol,Dict}
    lblname::Dict{Symbol,Symbol}

    Label(var,val,lblname) = new(var,val,lblname)
    Label() = Label(Dict(),Dict(),Dict())
end

"""
    varlab(l::Label,v::Symbol)

Produces the variable description associated with the `v` variable in the `l` Labels.
"""
function varlab(l::Label,v::Symbol)
    return haskey(l.var,v) ? l.var[v] : string(v)
end

"""
    vallab(l::Label,v::Symbol,val)

Returns the value label associated with `val` value for the `v` variable in the `l` Labels.
"""
function vallab(l::Label,v::Symbol,val)
    lname = lblname(l,v)

    if lname == nothing
        return string(val)
    end

    return haskey(l.val,lname) && haskey(l.val[lname],val) ? l.val[lname][val] : string(val)
end

"""
    lblname(l::Label,v::Symbol)

Finds label name associated with `v` variable in the `l` Labels. If `v` does not have
associated label name, `nothing` is returned.
"""
function lblname(l::Label,v::Symbol)
    if haskey(l.lblname,v)
        return l.lblname[v]
    end
    # nothing is returned here
end
#
# function defined(l::Label,lbl::Symbol)
#     return in(lbl,collect(values(l.lblname)))
# end
#
# function defined(l::Label,v::Symbol)
#     return v in collect(keys(l.var)) || v in collect(keys(l.lblname))
# end

function lblname(l::Label,v::Symbol)
    if haskey(l.lblname,v)
        return l.lblname[v]
    end
end

end # module
