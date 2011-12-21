within IDEAS.Occupants.Stochastic.Data.BaseClasses;
record Lighting

extends Modelica.Icons.MaterialProperty;

parameter Integer n(min=2) "number of bulbs";
parameter Integer[n] power "power of each bulb";

end Lighting;
