within Annex60.Experimental.BuildingPhysics;
partial model ThermalZoneOneElement
  "Thermal Zone with one element for thermal mass with variable order"

  parameter Modelica.SIunits.Volume VAir "Air Volume of the zone" annotation(Dialog(group="Thermal zone"));
  package Medium = Annex60.Media.Air;
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Modelica.SIunits.ThermalResistance RWin
    "Resistor for elements without notable thermal mass" annotation(Dialog(group="Windows"));
  parameter Modelica.SIunits.Area AExtInd "Indoor surface area of thermal mass"
                                                                                annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaExtInd
    "Coefficient of heat transfer for indoor surface of thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.Area AWinInd
    "Indoor surface area of elements without notable thermal mass" annotation(Dialog(group="Windows"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaWinInd
    "Coefficient of heat transfer for elements without notable thermal mass" annotation(Dialog(group="Windows"));
  parameter Modelica.SIunits.TransmissionCoefficient gWin
    "Total energy transmittance of windows" annotation(Dialog(group="Windows"));
  parameter Real ratioWinConRad
    "Ratio for windows between indoor convective and radiative heat emission" annotation(Dialog(group="Windows"));
  parameter Integer nExt(min = 1) "Number of RC-elements for thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.ThermalResistance RExt[nExt]
    "Vector of resistances for each RC-element, from inside to outside" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.ThermalResistance RExtRem
    "Resistance of remaining resistor RExtLast between capacitance n and outside"
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
        origin={-25,-94}),iconTransformation(
        extent={{-30.5,-8},{30.5,8}},
        rotation=0,
        origin={0,-79.5})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portExtAmb annotation (
      Placement(transformation(extent={{-100,-32},{-80,-12}}),
        iconTransformation(extent={{-100,-32},{-80,-12}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor heatConExt
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
  Modelica.Blocks.Sources.Constant alphaExt(k=1/(AExtInd*alphaExtInd))
                                            annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={0,-31})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portIntGainsConv
    "Heat port for sensible internal gains" annotation (Placement(
        transformation(extent={{80,18},{100,38}}), iconTransformation(extent={{80,
            18},{100,38}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResWin(R=RWin)
    annotation (Placement(transformation(extent={{-62,26},{-42,46}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portWinAmb annotation (
      Placement(transformation(extent={{-100,8},{-80,28}}), iconTransformation(
          extent={{-100,8},{-80,28}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor heatConWin
    annotation (Placement(transformation(extent={{-10,26},{10,46}})));
  Modelica.Blocks.Sources.Constant alphaWin(k=1/(AWinInd*alphaWinInd))
                                            annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,64})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow solRadToHeatConv
    annotation (Placement(transformation(extent={{-60,56},{-40,76}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow solRadToHeatRad
    annotation (Placement(transformation(extent={{-60,78},{-40,98}})));
  Modelica.Blocks.Math.Gain emiCoeffWinRad(k=gWin*(1 - ratioWinConRad)*AWinInd)
    annotation (Placement(transformation(extent={{-78,83},{-68,93}})));
  Modelica.Blocks.Math.Gain emiCoeffWinConv(k=gWin*ratioWinConRad*AWinInd)
    annotation (Placement(transformation(extent={{-78,61},{-68,71}})));
  Modelica.Blocks.Interfaces.RealInput solRad annotation (Placement(
        transformation(extent={{-120,24},{-80,64}}), iconTransformation(extent={
            {-100,44},{-80,64}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portIntGainsRad
    annotation (Placement(transformation(extent={{80,-34},{100,-14}}),
        iconTransformation(extent={{80,-34},{100,-14}})));
  BaseClasses.ThermSplitter thermSplitterIntGains(dimension=1)
    annotation (Placement(transformation(extent={{88,-56},{68,-36}})));
  BaseClasses.ThermSplitter thermSplitterSolRad(dimension=1)
    annotation (Placement(transformation(extent={{-34,80},{-18,96}})));
  BaseClasses.ExtMassVarRC extMassVarRC(
    n=nExt,
    RExt=RExt,
    CExt=CExt,
    RExtRem=RExtRem)
    annotation (Placement(transformation(extent={{-42,-10},{-62,12}})));
equation
  connect(volAir.ports, ports) annotation (Line(
      points={{28,-10},{28,-64},{-26,-64},{-26,-78},{-26,-78},{-26,-94},{-25,-94}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatConExt.fluid, volAir.heatPort) annotation (Line(
      points={{10,0},{18,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(volAir.heatPort, portIntGainsConv) annotation (Line(
      points={{18,0},{18,28},{90,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResWin.port_a, portWinAmb) annotation (Line(
      points={{-62,36},{-76,36},{-76,18},{-90,18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alphaExt.y, heatConExt.Rc) annotation (Line(
      points={{0,-25.5},{0,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermalResWin.port_b, heatConWin.solid) annotation (Line(
      points={{-42,36},{-10,36}},
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
  connect(solRadToHeatConv.port, volAir.heatPort) annotation (Line(
      points={{-40,66},{-20,66},{-20,18},{18,18},{18,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emiCoeffWinRad.y, solRadToHeatRad.Q_flow) annotation (Line(
      points={{-67.5,88},{-60,88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(emiCoeffWinConv.y, solRadToHeatConv.Q_flow) annotation (Line(
      points={{-67.5,66},{-60,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(emiCoeffWinConv.u, solRad) annotation (Line(
      points={{-79,66},{-82,66},{-82,44},{-100,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(emiCoeffWinRad.u, solRad) annotation (Line(
      points={{-79,88},{-84,88},{-84,44},{-100,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermSplitterIntGains.signalInput, portIntGainsRad) annotation (Line(
      points={{88,-46},{90,-46},{90,-24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermSplitterIntGains.signalOutput[1], heatConExt.solid) annotation (
      Line(
      points={{68,-46},{-14,-46},{-14,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solRadToHeatRad.port, thermSplitterSolRad.signalInput) annotation (
      Line(
      points={{-40,88},{-34,88}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermSplitterSolRad.signalOutput[1], heatConExt.solid) annotation (
      Line(
      points={{-18,88},{-14,88},{-14,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extMassVarRC.port_b, portExtAmb) annotation (Line(
      points={{-61.2,0},{-90,0},{-90,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extMassVarRC.port_a, heatConExt.solid) annotation (Line(
      points={{-42.6,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=864000),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics={
        Rectangle(
          extent={{-80,74},{80,-70}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Forward),
        Rectangle(
          extent={{-64,60},{64,-56}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-64,-56},{-32,-28},{-32,38},{-64,60}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-32,38},{10,38},{38,38},{64,60}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{38,38},{38,-28},{64,-56}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-32,-28},{38,-28}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{2,16},{18,4}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,16},{2,4}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,4},{18,-8}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,4},{2,-8}},
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
April 17, 2014, by Moritz Lauster:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalZoneOneElement;
