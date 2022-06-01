within IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.BaseClasses;
partial model PartialIceFac "Partial model to calculate the icing factor"
  Interfaces.VapourCompressionMachineControlBus             sigBus
    "Bus-connector used in a heat pump" annotation (Placement(
        transformation(
        extent={{-15,-14},{15,14}},
        rotation=0,
        origin={-101,0})));
  Modelica.Blocks.Interfaces.RealOutput iceFac
    "Efficiency factor (0..1) to estimate influence of icing. 0 means no heat is transferred through heat exchanger (fully frozen). 1 means no icing/frosting."
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialIceFac;
