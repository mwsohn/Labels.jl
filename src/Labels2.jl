module Labels2

################################################################################
##
## Dependencies
##
################################################################################

using DataFrames

##############################################################################
##
## Exported methods and types (in addition to everything reexported above)
##
##############################################################################

export set_data_label!, data_label, delete_data_label!,
    set_col_label!, col_label, delete_col_label!,
    set_value_key!, value_key, delete_value_key!,
    set_value_dict!, value_dict, delete_value_dict!,
    value_label, Label

struct Label
    data::String
    var::Dict{Symbol,String}
    val::Dict{Symbol,Dict}
    valkey::Dict{Symbol,Symbol}

    Label(data, var, val, valkey) = new(data, var, val, valkey)
    Label() = Label(String, Dict(), Dict(), Dict())
end

"""
    get_labels(df::AbstractDataFrame)

Extracts all labels saved in the `df` DataFrame and returns them
as a Label object.
"""
function get_labels(_df::AbstractDataFrame)

    label = Label()

    # data label
    if "Data Label" in metadatakeys(_df)
        label.data = metadata(_df,"Data Label")
    end

    # value dictionary
    if "Value Dictionary" in metadatakeys(_df)
        label.val = metadata(_df,"Value Dictionary")
    end

    for v in propertynames(_df)

        # column labels
        if "Column Label" in colmetadatakeys(_df, v)
            label.var[v] = colmetadata(_df,v,"Column Label")
        end

        # value label names
        if "Value Label Key" in colmetadatakeys(_df, v)
            label.valname[v] = colmetadata(_df,v,"Value Label Key")
        end
    end

    return label
end

function set_labels!(_df::AbstractDataFrame, label::Dict)

    # data label
    if label.data != nothing || label.data != ""
        metadata!(_df, label.data, "Data Label", style=:default)
    end

    # value dictionary
    if length(label.val) > 0
        # select value labels linked to a column in the DataFrame
        # not implemented yet
        metadata!(_df, label.val, "Value Dictionary", style=:default)
    end

    for v in propertynames(_df)

        # column labels
        if haskey(label.var,v)
            colmetadata!(_df, v, "Column Label", label.var[v], style=:note)
        end

        # value label names
        if haskey(label.val,v)
            colmetadata!(_df, v, "Value Label Key", label.val[v], style=:default)
        end
    end

    return nothing
end

function select_labels(df::AbstractDataFrame, valdict::Dict)

    vdict = Dict()
    vkeys = keys(value_key(df)) # value_key returns a dictionary whose keys are value label keys

    for el in keys(valdict)
        if el in vkeys
            vdict[el] = valdict[el]
        end
    end

    if length(vdict) > 0
        return vdict
    end

    return nothing
end


"""
    set_data_label!(df::AbstractDataFrame,label::String)

Saves a data `label` to the `df` DataFrame. A data label is a description of the DataFrame.
It does not return anything nor generates any message. 
It saves the `label` as a metadata in the `df` with the "Data Label"
as the key and `:default` as the style. 
"""
function set_data_label!(_df::AbstractDataFrame,label::String)
    metadata!(_df,"Data Label",label,style=:default)
    return nothing
end

"""
    data_label(df::AbstractDataFrame)

Extracts and returns the data label from the `df`.
"""
function data_label(_df::AbstractDataFrame)
    if "Data Label" in metadatakeys(_df)
        return metadata(_df,"Data Label")
    end
    return nothing
end

"""
    delete_data_label!(df::AbstractDataFrame)

Deletes the data label from the `df` DataFrame
"""
function delete_data_label!(_df::AbstractDataFrame)
    if "Data Label" in metadatakeys(_df)
        deletemetadata!(_df,"Data Label")
    end
    return nothing
end

"""
    set_value_dict!(df::AbstractDataFrame,vlib::Dict)

Saves a value dictionary in the `df` as a metadata under "Value Dictionary"
as the key and `:default` as the style. A value dictionary is a dictionary, whose
keys are symbols known as "value labels" and values are
a dictionary of value-description pairs.

An example of a value dictionary consisting of two value labels:

vlib = Dict(
    :racelab = Dict(1 => "White", 2 => "Black", 3 => "Hispanic", 4 => "Other"),
    :bmilab = Dict(1 => "Normal (< 25)", 2 => "Overweight (25 - 39.9)", 3 => "Obese (≥ 30)")
)
"""
function set_value_dict!(_df::AbstractDataFrame,vlib::Dict)
    metadata!(_df,"Value Dictionary",vlib, style=:default)
    return nothing
end

"""
    value_dict(df::AbstractDataFrame)

Extracts and returns a value dictionary if is is saved in the `df`.
"""
function value_dict(_df::AbstractDataFrame)
    if "Value Dictionary" in metadatakeys(_df)
        return metadata(_df,"Value Dictionary")
    end
end

"""
    delete_value_dict(df::AbstractDataFrame)

Deletes a value dictionary saved in the `df`.
"""
function delete_value_dict!(_df::AbstractDataFrame)
    if "Value Dictionary" in metadatakeys(_df)
        deletemetadata(_df, "Value Dictionary")
    end
    return nothing
end

"""
    set_col_label!(df::AbstractDataFrame,labels::Dict)
    set_col_label!(df::AbstractDataFrame, varname::Union{String,Symbol}, label::String)

Saves variable labels in the `df`. This function takes a dictionary whose keys are
column names and values are variable labels for multiple variable labels
or a column name and its label to attach a label to a single column. The labels are
saved as a colmetadata in the `df` with "Label" as the key and ":note" as the style.
"""
function set_col_label!(_df::DataFrame,labels::Dict)
    colnames = names(_df)
    for (key,val) in labels
        if string(key) in colnames
            colmetadata!(_df,key,"Column Label",val, style=:note)
        end
    end
    return nothing
end
function set_col_label!(_df::AbstractDataFrame,varname::Union{String,Symbol},label::String)
    colmetadata!(_df,varname,"Column Label",label,style=:note)
    return nothing
end

"""
    col_label(df::AbstractDataFrame)
    col_label(df::AbstractDataFrame, colname::Union{String,Symbol})

Retrieves and returns column labels. If a `df` is passed, all column labels will be returned
as a diction whose keys are the column namen and values are the labels. If a `df` and a column
name are passed, the label for the column will be return if it exists. Otherwise, nothing will
be returned.
"""
function col_label(_df::AbstractDataFrame)
    label = Dict()
    for v in propertynames(_df)
        if "Column Label" in colmetadatakeys(_df,v)
            label[v] = colmetadata(_df,v,"Column Label")
        end
    end
    return label
end
function col_label(_df::AbstractDataFrame,varname::Union{String,Symbol})
    if "Column Label" in colmetadatakeys(_df,varname)
        return colmetadata(_df,varname,"Column Label")
    end
    return nothing
end

"""
    delete_col_label!(_df::AbstractDataFrame,varname::Union{String,Symbol})

Deletes a column label if you specify a column name. If you pass a `df` alone,
entire column labels will be deleted.
"""
function delete_col_label!(_df::AbstractDataFrame,varname::Union{String,Symbol})
    if "Column Label" in colmetadatakeys(_df,varname)
        deletecolmetadata!(_df,varname,"Column Label")
    end
    return nothing
end
function delete_col_label!(_df::AbstractDataFrame)
    for varname in propertynames(_df)
        if "Column Label" in colmetadatakeys(_df, varname)
            deletecolmetadata!(_df, varname, "Column Label")
        end
    end
    return nothing
end

"""
    set_value_key!(df::AbstractDataFrame, colname::Union{Symbol,String}, vlabname::Symbol)
    set_value_key!(_df::AbstractDataFrame,vlabnames::Dict)

Saves a value label to the colmetadata for a column if a column name is passed. If a dictionary
with column names and their value label keys is passed, all of them will be saved in the colmetadata
with "Value Label Key" as the key and `:default` as the style.
"""
function set_value_key!(_df::AbstractDataFrame, varname::Union{Symbol,String}, vlabname::Symbol)
    colmetadata!(_df,varname,"Value Label Key",vlabname)
    return nothing
end
function set_value_key!(_df::AbstractDataFrame,vlabnames::Dict)
    for v in keys(vlabnames)
        colmetadata!(_df, v, "Value Label Key", vlabnames[v])
    end
    return nothing
end

function value_key(_df::AbstractDataFrame, varname::Union{Symbol,String})
    if "Value Label Key" in colmetadatakeys(_df,varname)
        return colmetadata(_df,varname,"Value Label Key")
    end
end
function value_key(_df::AbstractDataFrame, varnames::AbstractVector)
    ldict = Dict()
    for v in varnames
        if haskey(colmetadata(_df,v),"Value Label Key")
            ldict[v] = colmetadata(_df,v,"Value Label Key")
        end
    end
    if length(ldict) > 0
        return ldict
    end
    return nothing
end
function value_key(_df::AbstractDataFrame)
    valdict = Dict()
    for v in propertynames(_df)
        if "Value Label Key" in colmetadatakeys(_df, v)
            lblname = colmetadata(_df, v, "Value Label Key")
            if lblname != ""
                valdict[v] = lblname
            end
        end
    end
    return valdict
end

"""
    delete_value_key!(_df::AbstractDataFrame, varname::Union{Symbol,String})
    delete_value_key!(_df::AbstractDataFrame, colnames::AbstractVector)
    delete_value_key!(_df::AbstractDataFrame)

Deletes value label keys. If a single column name is passed, only the key attached to the column
name will be deleted. If a vector column names is passed, all the keys for all columns in the vector
will be deleted. If just the `df` is passed, all value label keys in the `df` will be deleted.
"""
function delete_value_key!(_df::AbstractDataFrame, varname::Union{Symbol,String})
    if "Value Label Key" in colmetadatakeys(_df, varname)
        deletecolmetadata!(_df, varname, "Value Label Key")
    end
    return nothing
end
function delete_value_key!(_df::AbstractDataFrame, colnames::AbstractVector)
    for v in colnames
        if "Value Label Key" in colmetadatakeys(_df, v)
            deletecolmetadata!(_df, v, "Value Label Key")
        end
    end
    return nothing
end
function delete_value_key!(_df::AbstractDataFrame)
    for v in propertynames(_df)
        if "Value Label Key" in colmetadatakeys(_df, v)
            deletecolmetadata!(_df, v, "Value Label Key")
        end
    end
    return nothing
end

"""
    value_label(df::AbstractDataFrame, varname::Union{Symbol,String})
    value_label(df::AbstractDataFrame, varnames::AbstractVector)

Returns value labels. If a column name is specified, the dictionary of
value labels is returned. If a vector of column names are passed,
a dictionary of dictionaries of value lables whose keys are column
names is returned.
"""
function value_label(_df::AbstractDataFrame, varname::Union{Symbol,String})
    valdict = value_dict(_df)
    lname = value_key(_df,varname)
    if length(valdict) > 0 && haskey(valdict,lname)
        return Dict(varname => valdict[lname])
    end
    return nothing
end
function value_label(_df::AbstractDataFrame, varnames::AbstractVector)
    valdict = value_dict(_df) 
    lname = lblname(_df,varnames)
    if length(valdict) == 0 || length(lname) == 0
        return nothing
    end
    vdict = Dict(x => valdict[lname[x]] for x in keys(lname))
    if length(vdict) > 0
        return vdict
    end
    return nothing
end


end # end of module
