within Annex60.Experimental.BuildingPhysics;
model ThermalZoneTwoElements
  "Thermal Zone with two elements for thermal masses (external and internal) with variable order"
  extends ThermalZoneOneElement(
                             thermSplitterIntGains(dimension=2, splitFactor={
          AExtInd/(AExtInd + AInt),AInt/(AExtInd + AInt)}),
      thermSplitterSolRad(dimension=2, splitFactor={AExtInd/(AExtInd + AInt),
          AInt/(AExtInd + AInt)}));
  parameter Modelica.SIunits.Area AInt "Surface area of internal thermal mass"  annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaIntInd
    "Coefficient of heat transfer for surface of internal thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Integer nInt(min = 1)
    "Number of RC-elements for internal thermal mass"                               annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.ThermalResistance RInt[nInt]
    "Vector of resistances for each RC-element for internal mass, from port to capacitances"
                                                                                             annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.HeatCapacity CInt[nInt]
    "Vector of heat capacity of thermal masses for each RC-element, from port to central mass"
                                                                                               annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRad
    "Coefficient of heat transfer for linearized radiation exchange between thermal masses"
                                                                                            annotation(Dialog(group="Thermal mass"));
  BaseClasses.IntMassVarRC intMassVarRC(
    n=nInt,
    RInt=RInt,
    CInt=CInt)
    annotation (Placement(transformation(extent={{76,-10},{96,12}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor heatConInt
    annotation (Placement(transformation(extent={{62,10},{42,-10}})));
  Modelica.Blocks.Sources.Constant alphaInt(k=1/(AInt*alphaIntInd))
                                                                   annotation (
      Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={52,-33})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadBetWalls(R=1/(
        AExtInd*alphaRad))
    annotation (Placement(transformation(extent={{-10,-78},{10,-58}})));
equation
  connect(heatConInt.fluid, portIntGainsConv) annotation (Line(
      points={{42,0},{42,18},{18,18},{18,28},{90,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alphaInt.y, heatConInt.Rc) annotation (Line(
      points={{52,-27.5},{52,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermalResRadBetWalls.port_a, heatConExt.solid) annotation (Line(
      points={{-10,-68},{-14,-68},{-14,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatConInt.solid, intMassVarRC.port_a) annotation (Line(
      points={{62,0},{76.8,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intMassVarRC.port_a, thermalResRadBetWalls.port_b) annotation (Line(
      points={{76.8,0},{68,0},{68,-68},{10,-68}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermSplitterIntGains.signalOutput[1], intMassVarRC.port_a)
    annotation (Line(
      points={{68,-46},{68,0},{76.8,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermSplitterSolRad.signalOutput[1], intMassVarRC.port_a) annotation
    (Line(
      points={{-18,88},{68,88},{68,0},{76.8,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<ul>
<li>April 18, 2014, by Moritz Lauster:<br>First implementation. </li>
</ul>
</html>"));
end ThermalZoneTwoElements;
