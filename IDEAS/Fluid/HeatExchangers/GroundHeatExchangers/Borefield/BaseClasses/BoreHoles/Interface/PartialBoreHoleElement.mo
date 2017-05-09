within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Interface;
partial model PartialBoreHoleElement
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true);
  parameter Data.Records.Soil soi "Thermal properties of the ground"
    annotation (Placement(transformation(extent={{-46,-116},{-26,-96}})));
  parameter Data.Records.Filling fil
    "Thermal properties of the filling material"
    annotation (Placement(transformation(extent={{-22,-116},{-2,-96}})));
  parameter Data.Records.General gen
    "General charachteristics of the borefield"
    annotation (Placement(transformation(extent={{2,-116},{22,-96}})));
  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material."
    annotation (Dialog(tab="Dynamics"));

equation
    assert(gen.rBor > gen.xC + gen.rTub + gen.eTub and
         0 < gen.xC - gen.rTub - gen.eTub,
         "The borehole geometry is not physical. Check rBor, rTub and xC to make sure that the tube is placed inside the halve of the borehole.");

end PartialBoreHoleElement;
