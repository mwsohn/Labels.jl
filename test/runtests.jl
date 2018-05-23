using Labels
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

# write your own tests here
label = Label()

label.var[:race] = "Race/ethnicity"
label.val[:race] = Dict(1=>"White",2=>"Black",3=>"Hispanic",4=>"Other")
label.lblname[:race] = :race

@test varlab(label,:race) == "Race/ethnicity"
@test vallab(label,:race,1) == "White"
