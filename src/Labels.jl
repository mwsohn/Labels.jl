module Labels

################################################################################
##
## Dependencies
##
################################################################################

using DataFrames, DataAPI, JLD2

##############################################################################
##
## Exported methods and types (in addition to everything reexported above)
##
##############################################################################

export Label, datalab, varlab, varlabs, vallab, valfmt, save_labels, load_labels

mutable struct Label
    data::String
    var::Dict{Symbol,String}
    val::Dict{Symbol,Dict}
    valfmt::Dict{Symbol,Symbol}

    Label(data, var, val, valfmt) = new(data, var, val, valfmt)
    Label() = Label("", Dict(), Dict(), Dict() )
end

"""
    datalab(l::Label)

Returns data label from the `l` Label object.
"""
function datalab(l::Label)
    return l.data
end
function datalab(df::AbstractDataFrame)
    fn = nothing
    if "Labels" in metadatakeys(df)
        fn = metadata(df,"Labels")
    end
    if fn != nothing && isfile(fn)
        labels = load_object(fn)
        return labels.data
    end
    return nothing
end

"""
    varlab(l::Label,v::Symbol)

Produces the variable description associated with the `v` variable in the `l` Labels.
"""
function varlab(l::Label, v::Symbol)
    return haskey(l.var, v) ? l.var[v] : string(v)
end
function varlab(df::AbstractDataFrame, v::Symbol)
    fn = nothing
    if "Labels" in metadatakeys(df)
        fn = metadata(df,"Labels")
    end

    if fn != nothing && isfile(fn)
        labels = load_object(fn)
        if haskey(labels.var,v)
            return labels.var[v]
        end
    end

    # variable does not exist
    return string(v)
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
    vallab(l::Label, v::Symbol, vals::Vector)
    vallab(df::AbstractDataFrame, v::Symbol)
    vallab(df::AbstractDataFrame, v::Vector{Symbol})

Returns the value label associated with `val` value for the `v` variable in the `l` Labels.
"""
function vallab(l::Label, v::Symbol, val)
    if l == nothing
        return string(val)
    end

    lname = valfmt(l, v)

    if lname == nothing
        return string(val)
    end

    return haskey(l.val, lname) && haskey(l.val[lname], val) ? l.val[lname][val] : string(val)
end
function vallab(l::Label, v::Symbol, vals)
    if l == nothing
        return string.(vals)
    end
    
    lname = valfmt(l, v)

    if lname == nothing
        return string.(vals)
    end

    return [haskey(l.val, lname) && haskey(l.val[lname], val) ? l.val[lname][val] : string(val) for val in vals]
end
function vallab(indf::AbstractDataFrame,v::Symbol)
    if "Labels" in metadatakeys(indf) 
        labels = load_object(metadata(indf,"Labels"))
        if valfmt(labels,v) != nothing
            return labels.val[valfmt(labels,v)]
        end
    end
    return nothing
end
function vallab(indf::AbstractDataFrame,vv::Vector{Symbol})
    if "Labels" in metadatakeys(indf) 
        labels = load_object(metadata(indf,"Labels"))
        vdict = Dict()
        for v in vv
            vf = valfmt(labels,v)
            if vf != nothing && haskey(labels.val, vf)
                vdict[v] = labels.val[vf]
            end
        end 
        return vdict
    end
    return nothing
end

function valfmt(l::Label, v::Symbol)
    if haskey(l.valfmt,v)
        return l.valfmt[v]
    end
    return nothing
end

function save_labels(l::Label, df::AbstractDataFrame; filename::String = "")
    if filename == ""
        if "Labels" in metadatakeys!(df)
            filename = metadata(df,"Labels")
        else
            filename = "labels.jlfmt"
        end
    end

    save_object(filename,l)
    metadata!(df,"Labels",filename, style=:note);
end

function load_labels(filename::String)
    return JLD2.load_object(filename)
end
function load_labels(df::AbstractDataFrame)
    fn = nothing
    if "Labels" in metadatakeys(df)
        fn = metadata(df,"Labels")
    end
    if fn != nothing && fn != ""
        return load_labels(fn)
    end
    return nothing
end

end # end of module
