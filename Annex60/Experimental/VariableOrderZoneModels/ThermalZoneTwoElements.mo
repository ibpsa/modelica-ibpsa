within Annex60.Experimental.VariableOrderZoneModels;
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
    CInt=CInt) if AInt > 0
    annotation (Placement(transformation(extent={{96,-10},{116,12}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor heatConInt if AInt > 0
    annotation (Placement(transformation(extent={{62,10},{42,-10}})));
  Modelica.Blocks.Sources.Constant alphaInt(k=1/(AInt*alphaIntInd)) if AInt > 0
                                                                   annotation (
      Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={52,-21})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadExtInt(R=1/(min(
        AExtInd, AInt)*alphaRad)) if AExtInd > 0 and AInt > 0
    annotation (Placement(transformation(extent={{-6,-60},{14,-40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadWinInt(R=1/(min(
        AWinInd, AInt)*alphaRad)) if AWinInd > 0 and AInt > 0
    annotation (Placement(transformation(extent={{36,40},{56,60}})));
equation
  connect(heatConInt.fluid, portIntGainsConv) annotation (Line(
      points={{42,0},{42,14},{18,14},{18,28},{110,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alphaInt.y, heatConInt.Rc) annotation (Line(
      points={{52,-15.5},{52,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermalResRadExtInt.port_a, heatConExt.solid) annotation (Line(
      points={{-6,-50},{-24,-50},{-24,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatConInt.solid, intMassVarRC.port_a) annotation (Line(
      points={{62,0},{96.8,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intMassVarRC.port_a, thermalResRadExtInt.port_b) annotation (Line(
      points={{96.8,0},{66,0},{66,-50},{14,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermSplitterIntGains.signalOutput[2], intMassVarRC.port_a)
    annotation (Line(
      points={{72,-36},{72,-18},{72,-18},{72,0},{96.8,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermSplitterSolRad.signalOutput[2], intMassVarRC.port_a) annotation (
     Line(
      points={{-30,88},{72,88},{72,0},{96.8,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResRadWinInt.port_b, intMassVarRC.port_a) annotation (Line(
      points={{56,50},{66,50},{66,0},{96.8,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResRadWinInt.port_a, heatConWin.solid) annotation (Line(
      points={{36,50},{-44,50},{-44,36},{-10,36}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,100}}), graphics={
        Rectangle(
          extent={{22,65},{70,30}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,-37},{26,-72}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,20},{120,20},{120,-12},{64,-12},{64,-30},{42,-30},{42,20}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{93,25},{120,8}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Internal Mass"),
        Text(
          extent={{-16,-55},{22,-81}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Radiation Exchange"),
        Text(
          extent={{28,47},{66,21}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Radiation Exchange")}),
                                          Documentation(revisions="<html>
<ul>
<li>April 18, 2015, by Moritz Lauster:<br>First implementation. </li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-120,-120},{120,100}})));
end ThermalZoneTwoElements;
