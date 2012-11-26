within IDEAS.Thermal.Components.BaseClasses;
record FH_Characteristics
  "Record containing all parameters for a given floor heating"

  // The terminology from prEN 15377 is followed, even if I find the development of the theory
  // by Koschenz and Lehmann better (see Thermoaktive Bauteilsysteme tabs, from Empa)

  // First Version 20110622

  // Changed 20110629:
  // Important: this record ALSO contains the parameters that are specific to the building.

  parameter Modelica.SIunits.Length T(
    min=0.15,
    max=0.3)=0.2 "Pipe spacing, limits imposed by prEN 15377-3 p22";
  parameter Modelica.SIunits.Length d_a=0.02 "External diameter of the pipe";
  parameter Modelica.SIunits.Length s_r=0.0025 "Thickness of the pipe wall";
  parameter Modelica.SIunits.ThermalConductivity lambda_r=0.35
    "Thermal conductivity of the material of the pipe";
  parameter Modelica.SIunits.Length S_1=0.1
    "Thickness of the concrete/screed ABOVE the pipe layer";
  parameter Modelica.SIunits.Length S_2=0.1
    "Thickness of the concrete/screed UNDER the pipe layer";
  parameter Modelica.SIunits.Area A_Floor=1 "Tabs floor surface, CHANGE THIS!!";
  parameter Modelica.SIunits.ThermalConductivity lambda_b=1.8
    "Thermal conductivity of the concrete or screed layer";
  parameter Modelica.SIunits.SpecificHeatCapacity c_b=840
    "Thermal capacity of the concrete/screed material";
  parameter Modelica.SIunits.Density rho_b=2100
    "Density of the concrete/screed layer";
  constant Integer n1=3 "Number of discrete capacities in upper layer";
  constant Integer n2=3 "Number of discrete capacities in lower layer";

end FH_Characteristics;
