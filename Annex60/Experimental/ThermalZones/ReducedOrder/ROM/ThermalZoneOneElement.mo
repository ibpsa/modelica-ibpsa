within Annex60.Experimental.ThermalZones.ReducedOrder.ROM;
model ThermalZoneOneElement "Thermal Zone with one element for exterior walls"

  parameter Modelica.SIunits.Volume VAir "Air volume of the zone" annotation(Dialog(group="Thermal zone"));
  package Medium = Annex60.Media.Air;
  parameter Integer nPorts=0 "Number of fluid ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Modelica.SIunits.ThermalResistance RWin "Resistor for windows"
                           annotation(Dialog(group="Windows"));
  parameter Modelica.SIunits.Area AExt "Area of exterior walls"
                                                               annotation(Dialog(group="Exterior walls"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaExt
    "Coefficient of heat transfer of exterior walls (indoor)" annotation(Dialog(group="Exterior walls"));
  parameter Modelica.SIunits.Area AWin "Area of windows"
                      annotation(Dialog(group="Windows"));
  parameter Modelica.SIunits.Area ATransparent
    "Surface area of transparent (solar radiation transmittend) elements" annotation(Dialog(group="Windows"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaWin
    "Coefficient of heat transfer of windows (indoor)" annotation(Dialog(group="Windows"));
  parameter Modelica.SIunits.TransmissionCoefficient gWin
    "Total energy transmittance of windows" annotation(Dialog(group="Windows"));
  parameter Real ratioWinConRad
    "Ratio for windows between indoor convective and radiative heat emission" annotation(Dialog(group="Windows"));
  parameter Integer nExt(min = 1) "Number of RC-elements of exterior walls" annotation(Dialog(group="Exterior walls"));
  parameter Modelica.SIunits.ThermalResistance RExt[nExt]
    "Vector of resistances of exterior walls, from inside to outside" annotation(Dialog(group="Exterior walls"));
  parameter Modelica.SIunits.ThermalResistance RExtRem
    "Resistance of remaining resistor RExtRem between capacitance n and outside"
                                                                                    annotation(Dialog(group="Exterior walls"));
  parameter Modelica.SIunits.HeatCapacity CExt[nExt]
    "Vector of heat capacities of exterior walls, from inside to outside"                  annotation(Dialog(group="Exterior walls"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRad
    "Coefficient of heat transfer for linearized radiation exchange between walls"
                                                                                        annotation(Dialog(group="Thermal zone"));
  parameter Modelica.SIunits.Temperature T_start
    "Initial temperature for thermal masses (incl. indoor air)";
protected
  parameter Modelica.SIunits.Area ATot=sum(AArray);
  parameter Modelica.SIunits.Area[:] AArray = {AExt, AWin};
  parameter Integer dimension = sum({if A>0 then 1 else 0 for A in AArray});
  parameter Real splitFactor[dimension]=Annex60.Experimental.ThermalZones.ReducedOrder.BaseClasses.splitFacVal(dimension,AArray);

public
  Fluid.MixingVolumes.MixingVolume volAir(m_flow_nominal=0.00001, V=VAir,
    redeclare package Medium = Medium,
    nPorts=nPorts,
    T_start=T_start) "indoor air volume"
    annotation (Placement(transformation(extent={{38,-10},{18,10}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
    redeclare package Medium = Medium)
    "auxilliary fluid inlets and outlets to indoor air volume"
                                       annotation (
      Placement(transformation(
        extent={{-45,-12},{45,12}},
        rotation=0,
        origin={85,-172}),iconTransformation(
        extent={{-30.5,-8},{30.5,8}},
        rotation=0,
        origin={150,-171.5})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a extWall if    AExt > 0
    "ambient port for exterior walls" annotation (Placement(transformation(
          extent={{-240,-46},{-220,-26}}), iconTransformation(extent={{-240,-46},
            {-220,-26}})));
  Modelica.Thermal.HeatTransfer.Components.Convection         convExtWall if
                                                                            AExt > 0
    "convective heat transfer of exterior walls"
    annotation (Placement(transformation(extent={{-114,-26},{-94,-46}})));
  Modelica.Blocks.Sources.Constant alphaExtWallConst(k=AExt*alphaExt) if  AExt > 0
    "coefficient of convective heat transfer for exterior walls"
    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={-104,-57})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a intGainsConv
    "auxilliary port for internal convective gains" annotation (Placement(
        transformation(extent={{220,28},{240,48}}), iconTransformation(extent={{
            220,28},{240,48}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resWin(R=RWin) if        AWin > 0
    "resistor for windows"
    annotation (Placement(transformation(extent={{-180,28},{-160,48}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a window if     AWin > 0
    "ambient port for windows" annotation (Placement(transformation(extent={{-240,
            28},{-220,48}}), iconTransformation(extent={{-240,28},{-220,48}})));
  Modelica.Thermal.HeatTransfer.Components.Convection         convWin if    AWin > 0
    "convective heat transfer of windows"
    annotation (Placement(transformation(extent={{-116,28},{-96,48}})));
  Modelica.Blocks.Sources.Constant alphaWinConst(k=AWin*alphaWin) if     AWin > 0
    "coefficient of convective heat transfer for windows"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-106,66})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow convHeatSol if      ratioWinConRad > 0
    "solar heat considered as convection"
    annotation (Placement(transformation(extent={{-178,114},{-158,134}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow radHeatSol
    "solar heat considered as radiation"
    annotation (Placement(transformation(extent={{-178,136},{-158,156}})));
  Modelica.Blocks.Math.Gain eRadSol(k=gWin*(1 - ratioWinConRad)*ATransparent)
    "emission coefficient of solar radiation considered as radiation"
    annotation (Placement(transformation(extent={{-196,141},{-186,151}})));
  Modelica.Blocks.Math.Gain eConvSol(k=gWin*ratioWinConRad*ATransparent) if   ratioWinConRad > 0
    "emission coefficient of solar radiation considered as convection"
    annotation (Placement(transformation(extent={{-196,119},{-186,129}})));
  Modelica.Blocks.Interfaces.RealInput solRad(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "solar radiation transmitted through aggregated window" annotation (Placement(
        transformation(extent={{-260,118},{-220,158}}),
                                                     iconTransformation(extent={{-240,
            138},{-220,158}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a intGainsRad if     ATot > 0
    "auxilliary port for internal radiative gains" annotation (Placement(
        transformation(extent={{220,90},{240,110}}), iconTransformation(extent={
            {220,90},{240,110}})));
  BaseClasses.ThermSplitter thermSplitterIntGains(splitFactor=splitFactor,
      dimension=dimension) if                                                                      ATot > 0
    "splits incoming internal gains into seperate gains for each wall element, weighted by their area"
    annotation (Placement(transformation(extent={{210,78},{190,98}})));
  BaseClasses.ThermSplitter thermSplitterSolRad(splitFactor=splitFactor,
      dimension=dimension) if                                                                    ATot > 0
    "splits incoming solar radiation into seperate gains for each wall element, weighted by their area"
    annotation (Placement(transformation(extent={{-152,138},{-136,154}})));
  BaseClasses.ExtMassVarRC extWallRC(
    n=nExt,
    RExt=RExt,
    CExt=CExt,
    RExtRem=RExtRem,
    T_start=T_start) if AExt > 0 "RC-element for exterior walls"
    annotation (Placement(transformation(extent={{-158,-46},{-178,-24}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resExtWallWin(G=min(
        AExt, AWin)*alphaRad) if     AExt > 0 and AWin > 0
    "resistor between exterior walls and windows" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-146,8})));

equation
  connect(volAir.ports, ports) annotation (Line(
      points={{28,-10},{28,-66},{56,-66},{56,-122},{86,-122},{86,-172},{85,-172}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volAir.heatPort, intGainsConv) annotation (Line(
      points={{38,0},{64,0},{64,38},{230,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resWin.port_a, window) annotation (Line(
      points={{-180,38},{-230,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resWin.port_b, convWin.solid) annotation (Line(
      points={{-160,38},{-116,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eRadSol.y, radHeatSol.Q_flow) annotation (Line(
      points={{-185.5,146},{-178,146}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermSplitterIntGains.signalInput, intGainsRad) annotation (Line(
      points={{210,88},{230,88},{230,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radHeatSol.port, thermSplitterSolRad.signalInput) annotation (Line(
      points={{-158,146},{-152,146}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extWallRC.port_b, extWall) annotation (Line(
      points={{-177.2,-36},{-230,-36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extWallRC.port_a, convExtWall.solid) annotation (Line(
      points={{-158.6,-36},{-114,-36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eConvSol.y, convHeatSol.Q_flow) annotation (Line(
      points={{-185.5,124},{-178,124}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(eConvSol.u, solRad) annotation (Line(
      points={{-197,124},{-218,124},{-218,138},{-240,138}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  if AExt > 0 and AWin > 0 then
    connect(thermSplitterSolRad.signalOutput[1], convExtWall.solid) annotation (
       Line(
        points={{-136,146},{-68,146},{-68,-8},{-126,-8},{-126,-36},{-114,-36}},
        color={191,0,0},
        smooth=Smooth.None));

    connect(thermSplitterIntGains.signalOutput[1], convExtWall.solid)
      annotation (Line(
        points={{190,88},{-62,88},{-62,-12},{-120,-12},{-120,-36},{-114,-36}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(thermSplitterSolRad.signalOutput[2], convWin.solid) annotation (
        Line(points={{-136,146},{-76,146},{-76,92},{-134,92},{-134,38},{-116,38}},
          color={191,0,0}));
    connect(thermSplitterIntGains.signalOutput[2], convWin.solid) annotation (
        Line(points={{190,88},{190,84},{-126,84},{-126,62},{-126,38},{-116,38}},
          color={191,0,0}));
  elseif not AExt > 0 and AWin > 0 then
    connect(thermSplitterSolRad.signalOutput[1], convWin.solid);
    connect(thermSplitterIntGains.signalOutput[1], convWin.solid);
  elseif AExt > 0 and not AWin > 0 then
    connect(thermSplitterSolRad.signalOutput[1], convExtWall.solid);
    connect(thermSplitterIntGains.signalOutput[1], convExtWall.solid);
  end if;
  connect(eRadSol.u, solRad) annotation (Line(points={{-197,146},{-212,146},{-212,
          138},{-240,138}}, color={0,0,127}));
  connect(convHeatSol.port, volAir.heatPort) annotation (Line(
      points={{-158,124},{-62,124},{-62,94},{64,94},{64,0},{62,0},{38,0}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(convWin.fluid, volAir.heatPort) annotation (Line(points={{-96,38},{64,
          38},{64,0},{38,0}}, color={191,0,0}));
  connect(volAir.heatPort, convExtWall.fluid) annotation (Line(points={{38,0},{64,
          0},{64,-36},{-94,-36}}, color={191,0,0}));
  connect(resExtWallWin.port_b, convExtWall.solid) annotation (Line(points={{-146,
          -2},{-144,-2},{-144,-36},{-114,-36}}, color={191,0,0}));
  connect(resExtWallWin.port_a, convWin.solid)
    annotation (Line(points={{-146,18},{-146,38},{-116,38}}, color={191,0,0}));
  connect(alphaWinConst.y, convWin.Gc) annotation (Line(points={{-106,59.4},{
          -106,53.7},{-106,48}}, color={0,0,127}));
  connect(alphaExtWallConst.y, convExtWall.Gc) annotation (Line(points={{-104,
          -51.5},{-104,-46},{-104,-46}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -180},{240,180}},
        grid={2,2}),  graphics={
        Rectangle(
          extent={{-206,78},{-92,24}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
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
          textString="Exterior Walls"),
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
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,-180},{240,
            180}},
        grid={2,2}),
         graphics={
        Rectangle(
          extent={{-220,160},{220,-160}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Forward),
        Rectangle(
          extent={{-210,150},{210,-150}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-210,-150},{-108,-58},{-108,60},{-210,150}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-108,60},{2,60},{108,60},{210,134}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{108,60},{108,-58},{210,-150}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-108,-58},{108,-58}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-260,236},{24,152}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={236,99,92},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-68,60},{56,-64}},
          lineColor={0,0,0},
          textString="1")}),
    Documentation(info="<html>
<h4>Main equations</h4>
<h4>Assumption and limitations</h4>
<ul>
<li>Linearized indoor radiative heat exchange</li>
</ul>
<h4>Design decisions</h4>
<ul>
<li>Regarding different handling of internal gains and solar radiation: Although internal as well as external gains count as simple heat flows, solar radiation uses a real input, while internal gains utilize two heat ports, one for convective and one for radiative gains. Considering solar radiation typically requires several models upstream to calculate angle-dependent irradiation or window models. We decided to keep that seperately to this thermal zone model. Thus, solar radiation is handled as a basic <code><span style=\"font-family: Courier New,courier;\">RadiantEnergyFluenceRate</span></code>. For internal gains, the user might need to distinguish between convective and radiative heat sources. In addition, it might help to have access to the indoor air temperature and the mean radiation temperature. To this purpose, we introduced two heat ports for internal gains.</li>
<li>Consideration indoor radiative heat gains: For an exact consideration, each element participating at radiative heat exchange need to have a temperature and an area. For solar radiation and radiative internal gains, it is common to define the heat flow independently of temperature and thus of area as well, assuming that that the temperature of the source is high compared to the wall surface temperatures. By using a ThermSplitter that distributes the heat flow of the source over the walls according to their area, we support this simplified approach.</li>
<li>For solar radiation through windows, the area <code><span style=\"font-family: Courier New,courier;\">ATransparent </span></code>is used. In most cases, this should be equal to  <code><span style=\"font-family: Courier New,courier;\">AWin,</span></code>but there might be cases (e.g. windows are lumped with exterior walls and solar radiation is present) where the areas differ.</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 17, 2015, by Moritz Lauster:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalZoneOneElement;
