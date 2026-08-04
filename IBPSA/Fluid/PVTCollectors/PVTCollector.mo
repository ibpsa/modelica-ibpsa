within IBPSA.Fluid.PVTCollectors;
model PVTCollector
  "Model of a photovoltaic–thermal (PVT) collector using the ISO 9806:2017 thermal method with integrated thermal-electrical coupling"
  extends .IBPSA.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector(
     redeclare .IBPSA.Fluid.PVTCollectors.Data.Generic per);

  parameter .Modelica.Units.SI.Efficiency eleLosFac(min=0, max=1) = 0.10
    "Electrical system loss factor" annotation(Dialog(group="Electrical parameters"));
  parameter .IBPSA.Fluid.PVTCollectors.Types.CollectorType collectorType = per.colTyp
    "Collector type used to select a default tauAlpEff";
  parameter .Modelica.Units.SI.DimensionlessRatio tauAlpEff(min=0, max=1) =
    (if collectorType == .IBPSA.Fluid.PVTCollectors.Types.CollectorType.Uncovered then 0.901 else 0.84)
    "Effective transmittance-absorptance product";
  parameter .Modelica.Units.SI.CoefficientOfHeatTransfer UAbsFluid(min=0) =
  ((tauAlpEff - per.etaEl) * (per.a1)) / ((tauAlpEff - per.etaEl) - per.eta0)
    "Internal heat transfer coefficient between the fluid and PV cells; computed from datasheet parameters by default."
    annotation(Dialog(tab="Advanced", group="Electrical parameters"));

  .Modelica.Units.SI.HeatFlux qThSeg[nSeg] "Thermal power per segment";

  .Modelica.Blocks.Interfaces.RealOutput Pel "Total electrical power output [W]"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
        iconTransformation(extent={{100,-60},{120,-40}})));
  .Modelica.Blocks.Interfaces.RealOutput Qth "Total thermal power output[W]"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

  .IBPSA.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain solGaiStc(
    redeclare final package Medium = Medium,
    final nSeg=nSeg,
    final incAngDat=per.incAngDat,
    final incAngModDat=per.incAngModDat,
    final iamDiff=per.IAMDiff,
    final eta0=per.eta0,
    final use_shaCoe_in=use_shaCoe_in,
    final shaCoe=shaCoe,
    final A_c=ATot_internal)
    "Calculates the heat gained from the sun using the ISO 9806:2017 quasi-dynamic standard calculations"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  .IBPSA.Fluid.PVTCollectors.BaseClasses.ISO9806HeatLoss heaLosStc(
    redeclare final package Medium = Medium,
    final nSeg=nSeg,
    final a1=per.a1,
    final a2=per.a2,
    final a3=per.a3,
    final a4=per.a4,
    final a6=per.a6,
    final a7=per.a7,
    final a8=per.a8,
    final A_c=ATot_internal)
    "Calculates the heat lost to the surroundings using the ISO 9806:2017 quasi-dynamic standard calculations"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  .IBPSA.Fluid.PVTCollectors.BaseClasses.ElectricalPVT eleGen(
    final nSeg = nSeg,
    final A_c = ATot_internal,
    final eleLosFac = eleLosFac,
    final beta = per.beta,
    final P_nominal = per.P_nominal,
    final A = per.A,
    final eta0 = per.eta0,
    final tauAlpEff = tauAlpEff,
    final a1 = per.a1,
    final etaEl = per.etaEl,
    final UAbsFluid = UAbsFluid)
    "Calculates the electrical power output of the PVT model"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  .IBPSA.Fluid.PVTCollectors.BaseClasses.WindSpeedTilted winSpe(
    final azi=azi,
    final til=til)
    "Calculates the effective wind speed in the collector plane"
    annotation (Placement(transformation(extent={{-80,16},{-60,36}})));

  .Modelica.Blocks.Math.Add HGloTil "Total global irradiance on collector plane"
    annotation (Placement(transformation(extent={{-55,-95},{-45,-85}})));
  .Modelica.Blocks.Sources.RealExpression[nSeg] qThSegExp(final y=qThSeg)
  "Thermal heat flux of each segment (for diagnostics)"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

equation

  // Compute thermal power per segment
  for i in 1:nSeg loop
    qThSeg[i] = (QGai[i].Q_flow + QLos[i].Q_flow) / (ATot_internal / nSeg);
  end for;

  // Assign electrical and thermal outputs
  Pel = eleGen.Pel;
  Qth = sum(QGai.Q_flow + QLos.Q_flow);

  connect(shaCoe_internal, solGaiStc.shaCoe_in);
  connect(HDirTil.inc, solGaiStc.incAng) annotation (Line(
      points={{-59,46},{-50,46},{-50,48},{-22,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.H, solGaiStc.HSkyDifTil) annotation (Line(
      points={{-59,80},{-30,80},{-30,58},{-22,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solGaiStc.HDirTil) annotation (Line(
      points={{-59,50},{-50,50},{-50,52},{-22,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solGaiStc.QSol_flow, QGai.Q_flow) annotation (Line(
      points={{1,50},{50,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, solGaiStc.TFlu) annotation (Line(
      points={{-11,-20},{-30,-20},{-30,42},{-22,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLosStc.QLos_flow, QLos.Q_flow) annotation (Line(points={{1,20},{50,20}}, color={0,0,127}));
  connect(heaLosStc.TFlu, temSen.T) annotation (Line(points={{-22,14},{-30,14},{
          -30,-20},{-11,-20}}, color={0,0,127}));
  connect(weaBus.TDryBul, heaLosStc.TEnv) annotation (Line(
      points={{-99.95,80.05},{-100,80.05},{-100,80},{-90,80},{-90,68},{-56,68},{
          -56,26},{-22,26}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HHorIR, heaLosStc.HHorIR) annotation (Line(
      points={{-99.95,80.05},{-90,80.05},{-90,68},{-56,68},{-56,20},{-22,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(temSen.T, eleGen.Tflu) annotation (Line(points={{-11,-20},{-30,-20}, {-30,-64},{-22,-64}}, color={0,0,127}));
  connect(HDifTilIso.H, HGloTil.u1) annotation (Line(points={{-59,80},{-54,80},{
          -54,14},{-64,14},{-64,-87},{-56,-87}}, color={0,0,127}));
  connect(HDirTil.H, HGloTil.u2) annotation (Line(points={{-59,50},{-50,50},{-50,
          52},{-46,52},{-46,14},{-64,14},{-64,-93},{-56,-93}}, color={0,0,127}));
  connect(HGloTil.y, eleGen.HGloTil) annotation (Line(
      points={{-44.5,-90},{-30,-90},{-30,-76},{-22,-76}},
      color={0,0,127}));
  connect(qThSegExp.y,eleGen.qth)  annotation (Line(
      points={{-39,-70},{-22,-70}},
      color={0,0,127}));
  connect(weaBus.winSpe, winSpe.winSpe) annotation (Line(
      points={{-99.95,80.05},{-90,80.05},{-90,32},{-82,32}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.winDir, winSpe.winDir) annotation (Line(
      points={{-99.95,80.05},{-90,80.05},{-90,26},{-82,26}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(winSpe.winSpeTil, heaLosStc.winSpePla) annotation (Line(points={{-59,32},
          {-42,32},{-42,23},{-22,23}}, color={0,0,127}));
  connect(HGloTil.y, heaLosStc.HGloTil) annotation (Line(points={{-44.5,-90},{-34,
          -90},{-34,17},{-22,17}}, color={0,0,127}));
    annotation (
  defaultComponentName = "pvtCol",
Documentation(info="<html>
<p>
This component models a photovoltaic–thermal (PVT) collector by coupling
the ISO 9806:2017 quasi-dynamic thermal method with an internal electrical model.
The model uses only datasheet parameters (no measured calibration data) and
has been validated experimentally for unglazed PVT collectors (with and without rear insulation)
under a wide range of weather conditions.
</p>
<p>
The main equations used in this model can be found in the following submodels, as described in the 
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.UsersGuide\">
IBPSA.Fluid.PVTCollectors.UsersGuide.
</a>
</p>
<ul>
<li>
Electrical generation: see 
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.BaseClasses.ElectricalPVT\">
IBPSA.Fluid.PVTCollectors.BaseClasses.ElectricalPVT
</a>
</li>
<li>
Quasi-dynamic thermal losses: see 
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.BaseClasses.ISO9806HeatLoss\">
IBPSA.Fluid.PVTCollectors.BaseClasses.ISO9806QuasiDynamicHeatLoss
</a>
</li>
<li>
Solar (thermal) heat gain: see 
<a href=\"modelica://IBPSA.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain\">
IBPSA.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain
</a>
</li>
</ul>
<h4>Implementation Notes</h4>
<p>
This model supports PVT collectors, discretised into segments to capture temperature gradients. 
It is compatible with dynamic simulations where irradiance and fluid temperatures vary over time.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 11, 2026, by Lone Meertens:<br/>
Updated thermal formulation from ISO 9806:2013 to ISO 9806:2017. 
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation PVT model.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">#1436</a>.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
graphics={
Rectangle(extent={{-84,100},{84,-100}}, lineColor={27,0,55}, fillColor={26,0,55}, fillPattern=FillPattern.Solid),
Line(points={{-100,0},{-76,0},{-76,-90},{66,-90},{66,-60},{-64,-60},{-64,-30},{66,-30},{66,0},{-64,0},{-64,28},{66,28},{66,60},{-64,60},{-64,86},{78,86},{78,0},{98,0},{100,0}}, color={0,128,255}, thickness=1),
Ellipse(extent={{-24,26},{28,-26}}, lineColor={255,255,0}, fillColor={255,255,0}, fillPattern=FillPattern.Solid),
Line(points={{-6,-6},{8,8}}, color={255,255,0}, origin={-24,30}, rotation=90),
Line(points={{-50,0},{-30,0}}, color={255,255,0}),
Line(points={{-36,-40},{-20,-24}}, color={255,255,0}),
Line(points={{-10,0},{10,0}}, color={255,255,0}, origin={2,-40}, rotation=90),
Line(points={{-8,-8},{6,6}}, color={255,255,0}, origin={30,-30}, rotation=90),
Line(points={{32,0},{52,0}}, color={255,255,0}),
Line(points={{-8,-8},{6,6}}, color={255,255,0}, origin={28,32}, rotation=180),
Line(points={{-10,0},{10,0}}, color={255,255,0}, origin={0,40}, rotation=90),
Polygon(points={{72,96},{36,26},{60,34},{48,-24},{88,58},{64,48},{72,96}}, lineColor={0,0,0}, fillColor={0,255,0}, fillPattern=FillPattern.Solid)}));
end PVTCollector;
