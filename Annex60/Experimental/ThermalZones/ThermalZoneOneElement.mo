within Annex60.Experimental.ThermalZones;
model ThermalZoneOneElement
  "Thermal Zone with one element for thermal mass with variable order"

  parameter Modelica.SIunits.Volume VAir "Air Volume of the zone" annotation(Dialog(group="Thermal zone"));
  package Medium = Annex60.Media.Air;
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Modelica.SIunits.ThermalResistance RWin
    "Resistor for elements without notable thermal mass" annotation(Dialog(group="Windows"));
  parameter Modelica.SIunits.Area AExtInd = 0.1
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
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRad
    "Coefficient of heat transfer for linearized radiation exchange between thermal masses"
                                                                                            annotation(Dialog(group="Thermal mass"));
protected
            parameter Modelica.SIunits.Area ASum=AExtInd + AWinInd;

public
  Fluid.MixingVolumes.MixingVolume volAir(m_flow_nominal=0.00001, V=VAir,
    redeclare package Medium = Medium,
    nPorts=nPorts)
    annotation (Placement(transformation(extent={{38,-10},{18,10}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
    redeclare package Medium = Medium) annotation (
      Placement(transformation(
        extent={{-45,-12},{45,12}},
        rotation=0,
        origin={85,-172}),iconTransformation(
        extent={{-30.5,-8},{30.5,8}},
        rotation=0,
        origin={0,-111.5})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portExtAmb if AExtInd > 0 annotation (
      Placement(transformation(extent={{-244,-46},{-224,-26}}),
        iconTransformation(extent={{-244,-46},{-224,-26}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor heatConExt if AExtInd > 0
    annotation (Placement(transformation(extent={{-114,-26},{-94,-46}})));
  Modelica.Blocks.Sources.Constant alphaExt(k=1/(AExtInd*alphaExtInd)) if AExtInd > 0
                                            annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={-104,-57})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portIntGainsConv
    "Heat port for sensible internal gains" annotation (Placement(
        transformation(extent={{218,28},{238,48}}),iconTransformation(extent={{218,28},
            {238,48}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResWin(R=RWin) if AWinInd > 0
    annotation (Placement(transformation(extent={{-180,28},{-160,48}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portWinAmb if AWinInd > 0 annotation (
      Placement(transformation(extent={{-244,28},{-224,48}}),
                                                            iconTransformation(
          extent={{-244,28},{-224,48}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor heatConWin if AWinInd > 0
    annotation (Placement(transformation(extent={{-116,28},{-96,48}})));
  Modelica.Blocks.Sources.Constant alphaWin(k=1/(AWinInd*alphaWinInd)) if AWinInd > 0
                                            annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-106,66})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow solRadToHeatConv if ratioWinConRad > 0
    annotation (Placement(transformation(extent={{-178,114},{-158,134}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow solRadToHeatRad
    annotation (Placement(transformation(extent={{-178,136},{-158,156}})));
  Modelica.Blocks.Math.Gain emiCoeffWinRad(k=gWin*(1 - ratioWinConRad)*AWinInd)
    annotation (Placement(transformation(extent={{-196,141},{-186,151}})));
  Modelica.Blocks.Math.Gain emiCoeffWinConv(k=gWin*ratioWinConRad*AWinInd) if ratioWinConRad > 0
    annotation (Placement(transformation(extent={{-196,119},{-186,129}})));
  Modelica.Blocks.Interfaces.RealInput solRad annotation (Placement(
        transformation(extent={{-258,118},{-218,158}}),
                                                     iconTransformation(extent={{-238,
            138},{-218,158}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portIntGainsRad if ASum > 0
    annotation (Placement(transformation(extent={{218,90},{238,110}}),
        iconTransformation(extent={{218,90},{238,110}})));
  BaseClasses.ThermSplitter thermSplitterIntGains(splitFactor=if not AExtInd > 0 and AWinInd > 0 then {AWinInd/(AExtInd + AWinInd)} else if not AWinInd > 0 and AExtInd > 0 then {AExtInd/(AExtInd + AWinInd)} else {
          AExtInd/(AExtInd + AWinInd),AWinInd/(AExtInd + AWinInd)}, dimension=if not AExtInd > 0 and not AWinInd > 0 then 0 else if not AExtInd > 0 and AWinInd > 0 then 1 else if not AWinInd > 0 and AExtInd > 0 then 1 else 2) if ASum > 0
    annotation (Placement(transformation(extent={{210,78},{190,98}})));
  BaseClasses.ThermSplitter thermSplitterSolRad(splitFactor=if not AExtInd > 0 and AWinInd > 0 then {AWinInd/(AExtInd + AWinInd)} else if not AWinInd > 0 and AExtInd > 0 then {AExtInd/(AExtInd + AWinInd)} else {
          AExtInd/(AExtInd + AWinInd),AWinInd/(AExtInd + AWinInd)}, dimension=if not AExtInd > 0 and not AWinInd > 0 then 0 else if not AExtInd > 0 and AWinInd > 0 then 1 else if not AWinInd > 0 and AExtInd > 0 then 1 else 2) if ASum > 0
    annotation (Placement(transformation(extent={{-152,138},{-136,154}})));
  BaseClasses.ExtMassVarRC extMassVarRC(
    n=nExt,
    RExt=RExt,
    CExt=CExt,
    RExtRem=RExtRem) if AExtInd > 0
    annotation (Placement(transformation(extent={{-158,-46},{-178,-24}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadExtWin(R=1/(min(
        AExtInd, AWinInd)*alphaRad)) if
                                     AExtInd > 0 and AWinInd > 0
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-146,4})));
equation
  connect(volAir.ports, ports) annotation (Line(
      points={{28,-10},{28,-66},{56,-66},{56,-122},{86,-122},{86,-172},{85,-172}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volAir.heatPort, portIntGainsConv) annotation (Line(
      points={{38,0},{64,0},{64,38},{228,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResWin.port_a, portWinAmb) annotation (Line(
      points={{-180,38},{-234,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alphaExt.y, heatConExt.Rc) annotation (Line(
      points={{-104,-51.5},{-104,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermalResWin.port_b, heatConWin.solid) annotation (Line(
      points={{-160,38},{-116,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alphaWin.y, heatConWin.Rc) annotation (Line(
      points={{-106,59.4},{-106,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(emiCoeffWinRad.y, solRadToHeatRad.Q_flow) annotation (Line(
      points={{-185.5,146},{-178,146}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermSplitterIntGains.signalInput, portIntGainsRad) annotation (Line(
        points={{210,88},{228,88},{228,100}},
        color={191,0,0},
        smooth=Smooth.None));
  connect(solRadToHeatRad.port, thermSplitterSolRad.signalInput) annotation (
      Line(
        points={{-158,146},{-152,146}},
        color={191,0,0},
        smooth=Smooth.None));
  connect(extMassVarRC.port_b, portExtAmb) annotation (Line(
      points={{-177.2,-36},{-234,-36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extMassVarRC.port_a, heatConExt.solid) annotation (Line(
      points={{-158.6,-36},{-114,-36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emiCoeffWinConv.y, solRadToHeatConv.Q_flow) annotation (Line(points={{-185.5,
          124},{-178,124}},                                                                         color={0,0,127},smooth=Smooth.None,
        pattern=LinePattern.Dash));
  connect(emiCoeffWinConv.u, solRad) annotation (Line(points={{-197,124},{-218,124},
          {-218,138},{-238,138}},                                                                   color={0,0,127},smooth=Smooth.None,
        pattern=LinePattern.Dash));
  if AExtInd > 0 and AWinInd > 0 then
    connect(thermSplitterSolRad.signalOutput[1], heatConExt.solid) annotation (
      Line(
      points={{-136,146},{-68,146},{-68,6},{-126,6},{-126,-36},{-114,-36}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(thermSplitterIntGains.signalOutput[1], heatConExt.solid) annotation (
      Line(
        points={{190,88},{-62,88},{-62,-4},{-120,-4},{-120,-36},{-114,-36}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(thermSplitterSolRad.signalOutput[2], heatConWin.solid) annotation (
      Line(points={{-136,146},{-76,146},{-76,92},{-134,92},{-134,38},{-116,38}},
        color={191,0,0}));
    connect(thermSplitterIntGains.signalOutput[2], heatConWin.solid) annotation (
      Line(points={{190,88},{190,84},{-126,84},{-126,62},{-126,38},{-116,38},{-116,
            38}},
        color={191,0,0}));
  elseif not AExtInd > 0 and AWinInd > 0 then
    connect(thermSplitterSolRad.signalOutput[1], heatConWin.solid);
    connect(thermSplitterIntGains.signalOutput[1], heatConWin.solid);
  elseif AExtInd > 0 and not AWinInd > 0 then
    connect(thermSplitterSolRad.signalOutput[1], heatConExt.solid);
    connect(thermSplitterIntGains.signalOutput[1], heatConExt.solid);
  end if;
  connect(emiCoeffWinRad.u, solRad) annotation (Line(points={{-197,146},{-212,146},
          {-212,138},{-238,138}}, color={0,0,127}));
  connect(solRadToHeatConv.port, volAir.heatPort) annotation (Line(
      points={{-158,124},{-62,124},{-62,94},{64,94},{64,0},{62,0},{62,0},{38,0},
          {38,0}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(heatConWin.fluid, volAir.heatPort) annotation (Line(points={{-96,38},{
          64,38},{64,0},{38,0}}, color={191,0,0}));
  connect(volAir.heatPort, heatConExt.fluid) annotation (Line(points={{38,0},{64,
          0},{64,-36},{-94,-36}}, color={191,0,0}));
  connect(thermalResRadExtWin.port_b, heatConExt.solid) annotation (Line(points=
         {{-146,-6},{-144,-6},{-144,-36},{-114,-36}}, color={191,0,0}));
  connect(thermalResRadExtWin.port_a, heatConWin.solid)
    annotation (Line(points={{-146,14},{-146,38},{-116,38}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -180},{240,180}},
        grid={2,2}),  graphics={
        Rectangle(
          extent={{-206,174},{-118,115}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-201,180},{-144,152}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Solar Radiation"),
        Rectangle(
          extent={{-204,-16},{-86,-70}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-201,-55},{-146,-72}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="External Mass"),
        Polygon(
          points={{-86,25},{-86,79},{-116,79},{-116,78},{-206,78},{-206,25},{-86,
              25}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-202,80},{-168,62}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Windows"),
        Rectangle(
          extent={{6,30},{50,-14}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{9,30},{46,16}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Indoor Air")}),
    experiment(StopTime=864000),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,-180},{240,180}},
        grid={2,2}),
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
          points={{-94,-94},{-40,-34},{-40,26},{-94,76}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,26},{6,26},{42,26},{94,76}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{42,26},{42,-34},{94,-94}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,-34},{42,-34}},
          color={0,0,0},
          smooth=Smooth.None),
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
