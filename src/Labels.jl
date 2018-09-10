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

function varlab(l::Label,v::Symbol)
    return haskey(l.var,v) ? l.var[v] : ""
end

function vallab(l::Label,v::Symbol,val::Integer)
    if haskey(l.lblname,v)
        lblname = l.lblname[v]
    else
        return ""
    end
    return haskey(l.val,lblname) ? l.val[lblname][val] : string(val)
end

function defined(l::Label,v::Symbol)
    return v in collect(keys(l.var)) || v in collect(keys(l.lblname))
end

function lblname(l::Label,v::Symbol)
    for k in keys(l.lblname)
        if l.lblname[k] == v
            return k
        end
    end
    # return nothing
end

end # module
