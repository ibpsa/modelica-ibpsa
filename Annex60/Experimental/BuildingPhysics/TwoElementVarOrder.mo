within Annex60.Experimental.BuildingPhysics;
model TwoElementVarOrder
  "Two elements for thermal masses (external and internal) with variable order"
  extends OneElementVarOrder(thermSplitterIntGains(dimension=2, splitFactor={
          AExtInd/(AExtInd + AInt),AInt/(AExtInd + AInt)}),
      thermSplitterSolRad(dimension=2, splitFactor={AExtInd/(AExtInd + AInt),
          AInt/(AExtInd + AInt)}));
  parameter Modelica.SIunits.Area AInt "Surface area of internal thermal mass"  annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaIntInd
    "Coefficient of heat transfer for surface of internal thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Integer nInt(min = 1)
    "Number of RC-elements for internal thermal mass"                               annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.ThermalResistance RInt[nInt]
    "Vector of resistances for each RC-element for internal mass" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.HeatCapacity CInt[nInt]
    "Vector of heat capacity of thermal masses for each RC-element" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRad
    "Coefficient of heat transfer for linearized radiation exchange between thermal masses"
                                                                                            annotation(Dialog(group="Thermal mass"));
  BaseClasses.IntMassVarRC intMassVarRC(
    n=nInt,
    RInt=RInt,
    CInt=CInt)
    annotation (Placement(transformation(extent={{96,-10},{76,12}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor heatConInt
    annotation (Placement(transformation(extent={{62,10},{42,-10}})));
  Modelica.Blocks.Sources.Constant alphaInt(k=AInt/alphaIntInd)    annotation (
      Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={52,-33})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadBetWalls(R=AExtInd
        /alphaRad)
    annotation (Placement(transformation(extent={{18,-78},{38,-58}})));
equation
  connect(intMassVarRC.port_b, thermSplitterIntGains.signalOutput[1])
    annotation (Line(
      points={{76.8,0},{68,0},{68,-54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermSplitterSolRad.signalOutput[1], intMassVarRC.port_b) annotation (
     Line(
      points={{-18,88},{68,88},{68,0},{76.8,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatConInt.solid, intMassVarRC.port_b) annotation (Line(
      points={{62,0},{76.8,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatConInt.fluid, portIntGainsConv) annotation (Line(
      points={{42,0},{42,18},{18,18},{18,28},{90,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alphaInt.y, heatConInt.Rc) annotation (Line(
      points={{52,-27.5},{52,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extMassVarRC.port_b, heatConExt.solid) annotation (Line(
      points={{-42.8,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResRadBetWalls.port_a, heatConExt.solid) annotation (Line(
      points={{18,-68},{-14,-68},{-14,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResRadBetWalls.port_b, intMassVarRC.port_b) annotation (Line(
      points={{38,-68},{68,-68},{68,0},{76.8,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<ul>
<li>April 18, 2014, by Moritz Lauster:<br>First implementation. </li>
</ul>
</html>"));
end TwoElementVarOrder;
