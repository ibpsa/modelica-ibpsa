within Annex60.Experimental.ThermalZones;
model ThermalZoneOneElement
  "Thermal Zone with one element for thermal mass with variable order"

  parameter Modelica.SIunits.Volume VAir "Air Volume of the zone" annotation(Dialog(group="Thermal zone"));
  package Medium = Annex60.Media.Air;
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Modelica.SIunits.ThermalResistance RWin
    "Resistor for elements without notable thermal mass" annotation(Dialog(group="Windows"));
  parameter Modelica.SIunits.Area AExtInd = 0
    "Indoor surface area of thermal mass"                                       annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaExtInd
    "Coefficient of heat transfer for indoor surface of thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.Area AWinInd = 0.1
    "Indoor surface area of elements without notable thermal mass" annotation(Dialog(group="Windows"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaWinInd
    "Coefficient of heat transfer for elements without notable thermal mass" annotation(Dialog(group="Windows"));
  parameter Modelica.SIunits.TransmissionCoefficient gWin
    "Total energy transmittance of windows" annotation(Dialog(group="Windows"));
  parameter Real ratioWinConRad=0
    "Ratio for windows between indoor convective and radiative heat emission" annotation(Dialog(group="Windows"));
  parameter Integer nExt(min = 1)=1 "Number of RC-elements for thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.ThermalResistance RExt[nExt]
    "Vector of resistances for each RC-element, from inside to outside" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.ThermalResistance RExtRem
    "Resistance of remaining resistor RExtRem between capacitance n and outside"
                                                                                 annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.HeatCapacity CExt[nExt]
    "Vector of heat capacity of thermal masses for each RC-element, from inside to outside"
                                                                                           annotation(Dialog(group="Thermal mass"));

  Fluid.MixingVolumes.MixingVolume volAir(m_flow_nominal=0.00001, V=VAir,
    redeclare package Medium = Medium,
    nPorts=nPorts)
    annotation (Placement(transformation(extent={{18,-10},{38,10}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
    redeclare package Medium = Medium) annotation (
      Placement(transformation(
        extent={{-45,-12},{45,12}},
        rotation=0,
        origin={-23,-114}),
                          iconTransformation(
        extent={{-30.5,-8},{30.5,8}},
        rotation=0,
        origin={0,-111.5})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portExtAmb if AExtInd > 0 annotation (
      Placement(transformation(extent={{-120,-32},{-100,-12}}),
        iconTransformation(extent={{-120,-32},{-100,-12}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor heatConExt if AExtInd > 0
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
  Modelica.Blocks.Sources.Constant alphaExt(k=1/(AExtInd*alphaExtInd)) if AExtInd > 0
                                            annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={0,-21})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portIntGainsConv
    "Heat port for sensible internal gains" annotation (Placement(
        transformation(extent={{100,18},{120,38}}),iconTransformation(extent={{100,18},
            {120,38}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResWin(R=RWin) if AWinInd > 0
    annotation (Placement(transformation(extent={{-74,26},{-54,46}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portWinAmb if AWinInd > 0 annotation (
      Placement(transformation(extent={{-120,8},{-100,28}}),iconTransformation(
          extent={{-120,8},{-100,28}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor heatConWin if AWinInd > 0
    annotation (Placement(transformation(extent={{-10,26},{10,46}})));
  Modelica.Blocks.Sources.Constant alphaWin(k=1/(AWinInd*alphaWinInd)) if AWinInd > 0
                                            annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,64})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow solRadToHeatConv if ratioWinConRad > 0
    annotation (Placement(transformation(extent={{-72,56},{-52,76}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow solRadToHeatRad
    annotation (Placement(transformation(extent={{-72,78},{-52,98}})));
  Modelica.Blocks.Math.Gain emiCoeffWinRad(k=gWin*(1 - ratioWinConRad)*AWinInd)
    annotation (Placement(transformation(extent={{-90,83},{-80,93}})));
  Modelica.Blocks.Math.Gain emiCoeffWinConv(k=gWin*ratioWinConRad*AWinInd) if ratioWinConRad > 0
    annotation (Placement(transformation(extent={{-90,61},{-80,71}})));
  Modelica.Blocks.Interfaces.RealInput solRad annotation (Placement(
        transformation(extent={{-140,24},{-100,64}}),iconTransformation(extent={{-120,44},
            {-100,64}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portIntGainsRad
    annotation (Placement(transformation(extent={{100,-34},{120,-14}}),
        iconTransformation(extent={{100,-34},{120,-14}})));
  BaseClasses.ThermSplitter thermSplitterIntGains(dimension=1)
    annotation (Placement(transformation(extent={{92,-46},{72,-26}})));
  BaseClasses.ThermSplitter thermSplitterSolRad(dimension=1)
    annotation (Placement(transformation(extent={{-46,80},{-30,96}})));
  BaseClasses.ExtMassVarRC extMassVarRC(
    n=nExt,
    RExt=RExt,
    CExt=CExt,
    RExtRem=RExtRem) if AExtInd > 0
    annotation (Placement(transformation(extent={{-54,-10},{-74,12}})));
equation
  connect(volAir.ports, ports) annotation (Line(
      points={{28,-10},{28,-74},{-26,-74},{-26,-114},{-23,-114}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatConExt.fluid, volAir.heatPort) annotation (Line(
      points={{10,0},{18,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(volAir.heatPort, portIntGainsConv) annotation (Line(
      points={{18,0},{18,28},{110,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResWin.port_a, portWinAmb) annotation (Line(
      points={{-74,36},{-78,36},{-78,18},{-110,18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alphaExt.y, heatConExt.Rc) annotation (Line(
      points={{0,-15.5},{0,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermalResWin.port_b, heatConWin.solid) annotation (Line(
      points={{-54,36},{-10,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alphaWin.y, heatConWin.Rc) annotation (Line(
      points={{-1.11022e-015,57.4},{-1.11022e-015,46},{0,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatConWin.fluid, volAir.heatPort) annotation (Line(
      points={{10,36},{18,36},{18,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emiCoeffWinRad.y, solRadToHeatRad.Q_flow) annotation (Line(
      points={{-79.5,88},{-72,88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(emiCoeffWinRad.u, solRad) annotation (Line(
      points={{-91,88},{-96,88},{-96,44},{-120,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermSplitterIntGains.signalInput, portIntGainsRad) annotation (Line(
      points={{92,-36},{110,-36},{110,-24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermSplitterIntGains.signalOutput[1], heatConExt.solid) annotation (
      Line(
      points={{72,-36},{-20,-36},{-20,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solRadToHeatRad.port, thermSplitterSolRad.signalInput) annotation (
      Line(
      points={{-52,88},{-46,88}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermSplitterSolRad.signalOutput[1], heatConExt.solid) annotation (
      Line(
      points={{-30,88},{-14,88},{-14,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extMassVarRC.port_b, portExtAmb) annotation (Line(
      points={{-73.2,0},{-110,0},{-110,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extMassVarRC.port_a, heatConExt.solid) annotation (Line(
      points={{-54.6,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emiCoeffWinConv.y, solRadToHeatConv.Q_flow) annotation (Line(points={{-79.5,66},{-72,66}},color={0,0,127},smooth=Smooth.None,
        pattern=LinePattern.Dash));
  connect(emiCoeffWinConv.u, solRad) annotation (Line(points={{-91,66},{-94,66},{-94,44},{-120,44}},color={0,0,127},smooth=Smooth.None,
        pattern=LinePattern.Dash));
  connect(solRadToHeatConv.port, volAir.heatPort) annotation (Line(points={{-52,66},{-40,66},{-40,14},{18,14},{18,0}},color={191,0,0},smooth=Smooth.
            None,
        pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,100}}),
                      graphics={
        Rectangle(
          extent={{-100,99},{-12,57}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-41,106},{-13,86}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Solar Radiation"),
        Rectangle(
          extent={{-100,20},{12,-29}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-99,-15},{-71,-35}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="External Mass"),
        Polygon(
          points={{20,23},{20,77},{-10,77},{-10,54},{-100,54},{-100,23},{20,23}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,34},{-80,19}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Windows"),
        Rectangle(
          extent={{14,20},{40,-12}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{21,24},{39,10}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Indoor Air")}),
    experiment(StopTime=864000),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,100}}),
         graphics={
        Rectangle(
          extent={{-100,80},{100,-102}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Forward),
        Rectangle(
          extent={{-94,76},{94,-94}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-94,-94},{-36,-34},{-36,34},{-94,76}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-36,34},{6,34},{38,34},{94,76}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{38,34},{38,-34},{94,-94}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-36,-34},{38,-34}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{0,12},{16,0}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,12},{0,0}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,0},{16,-12}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,0},{0,-12}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-76,110},{70,74}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={236,99,92},
          fillPattern=FillPattern.Solid,
          textString="%name")}),
    Documentation(info="<html>
<h4>Main equations</h4>
<h4>Assumption and limitations</h4>
<h4>Typical use and important parameters</h4>
<h4>Options</h4>
<h4>Validation</h4>
<h4>Implementation</h4>
<h4>References</h4>
</html>", revisions="<html>
<ul>
<li>
April 17, 2015, by Moritz Lauster:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalZoneOneElement;
