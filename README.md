# Labels

[![Build Status](https://travis-ci.org/mwsohn/Labels.jl.svg?branch=master)](https://travis-ci.org/mwsohn/Labels.jl)

[![Coverage Status](https://coveralls.io/repos/mwsohn/Labels.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/mwsohn/Labels.jl?branch=master)

[![codecov.io](http://codecov.io/github/mwsohn/Labels.jl/coverage.svg?branch=master)](http://codecov.io/github/mwsohn/Labels.jl?branch=master)

This package implements a simple method of labeling DataFrame variables and values.

## Installation

To install `Labels`, use the following:

```
pkg> add https://github.com/mwsohn/Labels.jl
```

## What it is for and how it is defined

It is a collection of three dictionaries that provides functionality
by which one can attach variable and value labels to a dataframe much like
SAS's "formats" library used along with the "PROC FORMAT" statement. It consists of
one type definition of `Labels`, which consists of three dictionaries that take
symbols as the keys. They are as follows:

- `varlab` - a dictionary used to represent variable labels. They `key` must be a symbol,
representing a column in a dataframe and the `value` is a string that provides a
description of the variable.

- `vallab` - a dictionary used to represent value labels. The `key` is a symbol,
representing the label name and the `value` is a dictionary whose keys are integers and
values are strings.

- `lblname` - a dictionary that links label names to variable names, both of which are symbols.

The package provides two functions that will assist users with finding labels.

- `varlab(l::Labels,s::Symbol)` - returns the variable description for `s` if it exists in
the `l` Labels object; otherwise an empty string will be returned

- `vallab(l::Labels,s::Symbol,i::Int)` - returns the description of the value `i` associated
with the value label `s`

## Building Labels

There are three ways to build a Labels object.

### 1. Building from an empty Labels object

This method is useful to construct the Labels object manually or to add a few
labels later when new variables and/or values are created.

```
julia> using Labels

julia> label = Labels()
Labels.Label(Dict{Symbol,String}(), Dict{Symbol,Dict}(), Dict{Symbol,Symbol}())

julia> label.var[:race] = "Race/ethnicity"
"Race/ethnicity"

julia> label.val[:racelab] = Dict(1=>"White",2=>"Black",3=>"Hispanic",4=>"Other")
Dict{Int64,String} with 4 entries:
  4 => "Other"
  2 => "Black"
  3 => "Hispanic"
  1 => "White"

```

### 2. Building from individual dictionaries

One can define label dictionaries and then combine them into a `Labels` object later.

```
julia> var_labels = Dict(:race => "Race/ethnicity",:sex => "Gender", :age => "Age in years", :income => "Household Income")
Dict{Symbol,String} with 4 entries:
  :income => "Household Income"
  :race   => "Race/ethnicity"
  :sex    => "Gender"
  :age    => "Age in years"

julia> val_labels = Dict(
  :race => Dict(1=>"White",2=>"Black",3=>"Hispanic",4=>"Other"),
  :sex => Dict(1=>"Female",2=>"Male"),
  :income => Dict(1=>"< \$25,000", 2=>"\$25,000 - \$49,999",3 => "\$50,000 - \$74,999", 4 => ">= \$50,000"))
Dict{Symbol,Dict{Int64,String}} with 3 entries:
    :income => Dict(4=>">= \$50,000",2=>"\$25,000 - \$49,999",3=>"\$50,000 - \$74,999",1=>"< \$25,000…
    :race   => Dict(4=>"Other",2=>"Black",3=>"Hispanic",1=>"White")
    :sex    => Dict(2=>"Male",1=>"Female")

julia> lblname = Dict(:race => :racelab, :sex => :sexlab, :income => :incomelab)
Dict{Symbol,Symbol} with 3 entries:
  :income => :incomelab
  :race   => :racelab
  :sex    => :sexlab

julia> labl = Label(var_labels,val_labels,lblname)
Labels.Label(Dict(:income=>"Household Income",:race=>"Race/ethnicity",:sex=>"Gender",:age=>"Age in y
ears"), Dict{Symbol,Dict}(Pair{Symbol,Dict}(:income, Dict(4=>">= \$50,000",2=>"\$25,000 - \$49,999",
3=>"\$50,000 - \$74,999",1=>"< \$25,000")),Pair{Symbol,Dict}(:race, Dict(4=>"Other",2=>"Black",3=>"H
ispanic",1=>"White")),Pair{Symbol,Dict}(:sex, Dict(2=>"Male",1=>"Female"))), Dict(:income=>:incomelab,:
race=>:racelab,:sex=>:sexlab))
```

### 3. Automatic conversion from Stata

`read_stata` function in the [Stella](https://github.com/mwsohn/Stella.jl) package
utilizes David Anthoff's [ReadStat](https://github.com/davidanthoff/ReadStat.jl) package
to convert the data set. It returns a tuple of a `DataFrame` and a `Labels` object, the
latter of which contains all the variable and value labels defined in the original stata
data set.

## How it can be used

### 1. A single variable label can be obtained using `varlab` function

```
julia> varlab(labl,:sex)
"Gender"

julia> varlab(label,:race)
"Race/ethnicity"
```

### 2. A single value label can be obtained using `vallab` function

```
julia> vallab(label,:race,2)
"Black"

julia> vallab(labl,:income,3)
"\$50,000 - \$74,999"
```

### 3. `lblname` (label name) can be looked up using `lblname` function`

```
julia> lblname(labl,:income)
:incomelab

julia> lblname(labl,:sex)
:sexlab
```

### 4. `Labels` are supported in manu functions included in the [Stella.jl](https://github.com/mwsohn/Stella.jl) package.
