# Labels2

A package to save and retrieve data, variable, and value labels in Julia DataFrames metadata and colmetadata.
Three levels of labels are implemented in this package. The first is the desciption of the data set itself.
It can be used to denote what version of the current data set is. The second is column (or variable) descriptions. 
The third is the value labels

## Installation

```
    ] add https://github.com/mwsohn/Labels2.jl
```

## Labels for the Julia DataFrames

This package uses metadata and colmetadata implemented in DataAPI. The following table shows label types,
their keys, and styles.

| Type             | Key              | Location     | Style     | Julia Datatype |
| :--------------- | :--------------- | :----------- | :-------- | :------------- |
| Data             | Data Label       | metadata     | :default  | String         |
| Column           | Column Label     | colmetadata  | :note     | String         |
| Value Dictionary | Value Dictionary | metadata     | :default  | Dictionary     |
| Value Key        | Value Key        | colmetadata  | :default  | Symbol         |

where `Key` indicates the key for metadata or colmetadata dictionaries, and
`Location` where the label is saved. For example,
the key is used to save and retrieve a Data label to and from a `df` DataFrame as follows:

```
metadata!(df,"Data Label","1978 automobile data")
```

or 

```
data_description = metadata(df,"Data Label")
```

## Value Dictionary

A Value Dictionary is a dictionary whose keys are value labels and whose values
are dictionaries of value => description pairs. So it is a dictionary of dictionaries.

An example of a value dictionary consisting of two value labels:

```
vlib = Dict(
    :racelab = Dict(1 => "White", 2 => "Black", 3 => "Hispanic", 4 => "Other"),
    :bmilab = Dict(1 => "Normal (< 25)", 2 => "Overweight (25 - 39.9)", 3 => "Obese (≥ 30)")
)
```

`vlib` is a name of the Value Dictionary; `:racelab` is the key (Value Label) to a dictionary that maps
the race values to their descriptions:

1 = White\
2 = Black\
3 = Hispanic\
4 = Other\

Likewise, `:bmilab` is the key to a dictionary that maps BMI values to their descriptions:

1 = Normal (< 25)\
2 = Overweight (25 - 29.9)\
3 = Obese (≥ 30)\

The Value Dictionary is therefore a collection of value descriptions saved as a metadata
object. These value descriptions are linked to each column using a value label. A value label
should be a Symbol and saved as a colmetadata object.

## How to Save Labels to a DataFrame

Four functions are defined for saving labels to a DataFrame. 

`set_data_label!` is used to save a data description, `set_col_label!` 
to save a column description, `set_value_key!` to attach value keys to
columns, and `set_value_dict!` to save the Value Dictionary. 

### Examples

```
set_data_label!(auto, "1978 automobile data")
```

saves the data description to the `auto` DataFrame.


```
set_col_label!(auto,:mpg, "Mileage (mpg)")
```

is used to save a column description "Mileage (mpg)" for `:mpg`.
A set of column descriptions can be defined as a dictionary and
save them all in a DataFrame all at once as follows.

```
varlabs = Dict(
    :make => "Make and model",
    :price => "Price",
    :mpg => "Mileage (mpg)",
    :foreign => "Car origin"
)

set_col_label!(auto,varlabs)
```

A value dictionary named `vlib` (defined above) can be saved using

```
set_value_dict!(df,vlib)
```

The value names (or keys) can be saved one at a time or as a set using

```
set_value_key!(df,:bmi, :bmilab)
set_value_key!(df, Dict(:race => :racelab, :bmi => :bmilab))
```

## How to retrieve labels

Each level of labels are retrieved using:

`data_label`, `col_label`, and `value_label` for data, column, and value labels.
`value_key` is used to retrieve the value name (or key) attached to a column.
`value_dictionary` is used to retrieve the entire value dictionary.

## How they are used/implemented











