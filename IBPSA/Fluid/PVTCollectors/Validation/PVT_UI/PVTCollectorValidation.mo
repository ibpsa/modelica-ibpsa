within IBPSA.Fluid.PVTCollectors.Validation.PVT_UI;
model PVTCollectorValidation
  "Validation model of a photovoltaic–thermal (PVT) collector using the ISO 9806:2017 thermal method with integrated electrical coupling"
  extends Validation.BaseClasses.PartialPVTCollectorValidation(
    eleLosFac = 0.09);

  outer .Modelica.Blocks.Sources.CombiTimeTable meaDat(
    tableOnFile=true,
    tableName="data",
    fileName=.Modelica.Utilities.Files.loadResource("modelica://PvTfluod/Resources/Validation/MeasurementData/Typ1_modelica.txt"),
    columns=1:25) annotation (Placement(transformation(extent={{26,68},
            {6,88}})));

  replaceable .IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain solGaiStc(
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
  .IDEAS.Fluid.PVTCollectors.Validation.BaseClasses.ISO9806HeatLossValidation
    heaLosStc(
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
  .IDEAS.Fluid.PVTCollectors.BaseClasses.ElectricalPVT eleGen(
    final nSeg = nSeg,
    final A_c = ATot_internal,
    final eleLosFac = eleLosFac,
    final beta = per.beta,
    final P_nominal = per.P_nominal,
    final A = per.A,
    final eta0 = per.eta0,
    final tauAlpEff = tauAlpEff,
    final a1 = per.a1,
    final etaEl = per.etaEl)
    "Calculates the electrical power output of the PVT model"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  .IDEAS.Fluid.PVTCollectors.Validation.BaseClasses.LongWaveRadiation longWaveRad(
    final til = til)
    "Long‑wave radiation exchange model for tilted PVT surface"
    annotation (Placement(transformation(extent={{-58,-66},{-38,-46}})));
  .Modelica.Blocks.Sources.RealExpression Qdir(y = meaDat.y[2] - meaDat.y[3])
    "Direct irradiance in the collector plane (global minus diffuse) [W/m2]"
    annotation (Placement(transformation(extent={{-49.5,82},{-30.5,98}})));
  .Modelica.Blocks.Math.Gain degToRad(k = .Modelica.Constants.pi/180)
    "Gain converting degrees to radians"
    annotation (Placement(transformation(
      extent={{-5,-5},{5,5}},
      rotation=270,
      origin={-40,60})));
  .Modelica.Blocks.Sources.RealExpression winSpe(y = meaDat.y[10])
    "Measured wind speed at collector location [m/s]"
    annotation (Placement(transformation(extent={{-55.5,12},{-36.5,28}})));
  .Modelica.Blocks.Sources.RealExpression I_tot(y = meaDat.y[2])
    "Total global irradiance in the collector plane [W/m2]"
    annotation (Placement(transformation(extent={{-55.5,2},{-36.5,18}})));
  .Modelica.Thermal.HeatTransfer.Celsius.ToKelvin TAmbKel
    "Converter from ambient air temperature in °C to Kelvin"
    annotation (Placement(transformation(extent={{-45,23},{-35,33}})));
  .Modelica.Blocks.Sources.RealExpression rH(y = meaDat.y[8])
    "Relative humidity from measurements [%]"
    annotation (Placement(transformation(extent={{-93.5,-82},{-74.5,-66}})));
  .Modelica.Blocks.Sources.RealExpression Tamb(y = meaDat.y[12] + 273.15)
    "Ambient air temperature converted to Kelvin [K]"
    annotation (Placement(transformation(extent={{-93.5,-94},{-74.5,-78}})));
  .Modelica.Blocks.Sources.RealExpression patm(y = meaDat.y[9])
    "Measured atmospheric pressure [bar]"
    annotation (Placement(transformation(extent={{-93.5,-70},{-74.5,-54}})));
  .Modelica.Blocks.Sources.RealExpression Ediff(y = meaDat.y[3])
    "Diffuse irradiance component in the collector plane [W/m2]"
    annotation (Placement(transformation(extent={{-93.5,-58},{-74.5,-42}})));
  .Modelica.Blocks.Sources.RealExpression Eglob(y = meaDat.y[2])
    "Global irradiance in the collector plane [W/m2]"
    annotation (Placement(transformation(extent={{-93.5,-46},{-74.5,-30}})));
  .Modelica.Blocks.Sources.RealExpression[nSeg] qThSegExp(final y = qThSeg)
    "Thermal heat‑flux per collector segment (diagnostic output)"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

equation
  Pel = eleGen.Pel;
  Qth = sum(QGai.Q_flow + QLos.Q_flow);

  for i in 1:nSeg loop
    qThSeg[i] = (QGai[i].Q_flow + QLos[i].Q_flow) / (ATot_internal / nSeg);
  end for;

  connect(shaCoe_internal, solGaiStc.shaCoe_in);
  connect(heaLosStc.TFlu, temSen.T) annotation (Line(
      points={{-22,14},{-30,14},{-30,-20},{-11,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLosStc.QLos_flow, QLos.Q_flow) annotation (Line(
      points={{1,20},{26,20},{26,20},{50,20}},
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
  connect(solGaiStc.HDirTil, Qdir.y) annotation (Line(points={{-22,52},{-26,52},
          {-26,90},{-29.55,90}}, color={0,0,127}));
  connect(solGaiStc.incAng, degToRad.y) annotation (Line(points={{-22,48},{-40,48},{-40,54.5}}, color={0,0,127}));
  connect(heaLosStc.TEnv, TAmbKel.Kelvin) annotation (Line(points={{-22,26},{-34,26},{-34,28},{-34.5,28}},
                                                            color={0,0,127}));
  connect(longWaveRad.rH, rH.y) annotation (Line(points={{-60,-60.4},{-70,-60.4},
          {-70,-74},{-73.55,-74}}, color={0,0,127}));
  connect(Tamb.y, longWaveRad.Tamb) annotation (Line(points={{-73.55,-86},{-68,
          -86},{-68,-64.8},{-60,-64.8}}, color={0,0,127}));
  connect(patm.y, longWaveRad.patm) annotation (Line(points={{-73.55,-62},{-72,
          -62},{-72,-56},{-60,-56}}, color={0,0,127}));
  connect(Ediff.y, longWaveRad.Edif_h) annotation (Line(points={{-73.55,-50},{
          -73.55,-51.6},{-60,-51.6}}, color={0,0,127}));
  connect(Eglob.y, longWaveRad.Eglobh_h) annotation (Line(points={{-73.55,-38},
          {-68,-38},{-68,-47.2},{-60,-47.2}}, color={0,0,127}));
  connect(heaLosStc.HGloTil, I_tot.y) annotation (Line(points={{-22,17},{-34,17},
          {-34,10},{-35.55,10}}, color={0,0,127}));
  connect(heaLosStc.HHorIR, longWaveRad.lonRad) annotation (Line(points={{-22,
          20},{-26,20},{-26,-55.9},{-36.3,-55.9}}, color={0,0,127}));
  connect(meaDat.y[5], degToRad.u) annotation (Line(points={{5,78},{-40,78},{-40,66}}, color={0,0,127}));
  connect(TAmbKel.Celsius, meaDat.y[12]) annotation (Line(points={{-46,28},{-68,
          28},{-68,78},{5,78}}, color={0,0,127}));
  connect(solGaiStc.HSkyDifTil, meaDat.y[3]) annotation (Line(points={{-22,58},{
          -24,58},{-24,78},{5,78}}, color={0,0,127}));
  connect(temSen.T, eleGen.Tflu) annotation (Line(points={{-11,-20},{-30,-20},{-30,
          -64},{-22,-64}}, color={0,0,127}));
  connect(Eglob.y, eleGen.HGloTil) annotation (Line(points={{-73.55,-38},{-32,-38},
          {-32,-76},{-22,-76}}, color={0,0,127}));
  connect(qThSegExp.y,eleGen.qth)  annotation (Line(
      points={{-39,-90},{-30,-90},{-30,-70},{-22,-70}},
      color={0,0,127}));
  connect(winSpe.y, heaLosStc.winSpePla) annotation (Line(points={{-35.55,20},{
          -34,20},{-34,23},{-22,23}}, color={0,0,127}));
 annotation (
  defaultComponentName="pvtCol",
  Documentation(info="<html>
<p>
Validation model of a photovoltaic–thermal (PVT) collector using the ISO 9806:2017 
quasi-dynamic thermal method with integrated electrical coupling.  
Discretizes the collector into segments, computes heat loss and gain per ISO 9806, 
and calculates electrical output via the PVWatts-based submodel, relying solely on datasheet parameters.
</p>
<h4>Extends</h4>
<ul>
<li>
<a href=\"modelica://IDEAS.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector\">
IDEAS.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector
</a>
</li>
</ul>
<h4>Submodel References</h4>
<ul>
<li>
Electrical generation: 
<a href=\"modelica://IDEAS.Fluid.PVTCollectors.BaseClasses.ElectricalPVT\">
IDEAS.Fluid.PVTCollectors.BaseClasses.ElectricalPVT
</a>
</li>
<li>
Quasi-dynamic thermal losses: 
<a href=\"modelica://IDEAS.Fluid.PVTCollectors.BaseClasses.ISO9806HeatLoss\">
IDEAS.Fluid.PVTCollectors.BaseClasses.ISO9806QuasiDynamicHeatLoss
</a>
</li>
<li>
Solar (thermal) heat gain: see 
<a href=\"modelica://IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain\">
IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain
</a>
</li>
<li>
Long-wave radiation (derived due to faulty measurements): 
<a href=\"modelica://IDEAS.Fluid.PVTCollectors.Validation.BaseClasses.LongWaveRadiation\">
IDEAS.Fluid.PVTCollectors.Validation.PVT_UI.BaseClasses.LongWaveRadiation
</a>
</li>
</ul>
<h4>Implementation Notes</h4>
<p> 
This validation model exclusively relies on measurement data provided by the 
CombiTimeTable <code>meaDat</code>. However, because it extends <a href='modelica://IDEAS.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector'>
IDEAS.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector</a> and to limit 
the number of extra components, the weather reader <code>IDEAS.BoundaryConditions.WeatherData.ReaderTMY3</code> 
remains instantiated and connected to the inherited <code>weaBus</code>. The 
reader is retained only to satisfy the parent class connector and is <em>not</em> 
used during simulation: all weather inputs (irradiance, ambient temperature, 
wind speed, etc.) are taken from <code>meaDat</code>, so the reader does not 
affect the model results. 
</p>
<p>
This model is designed for PVT collectors and discretizes the flow 
path into <code>nSeg</code> segments to capture temperature gradients. It is 
compatible with dynamic simulations in which irradiance, ambient and fluid temperatures,
and wind speed vary over time. Because direct measurements of long-wave sky 
irradiance were found to be faulty, the model instead computes long-wave radiation 
using the dedicated <a href=\"modelica://IDEAS.Fluid.PVTCollectors.Validation.BaseClasses.LongWaveRadiation\">LongWaveRadiation</a> model.
</p>
<h4>References</h4>
<ul>
<li>
Dobos, A. P. (2014). <i><a href='https://docs.nrel.gov/docs/fy14osti/62641.pdf'>PVWatts Version 5 Manual</a></i>. NREL/TP-6A20-62641
</li>
<li>
ISO 9806:2017. <i><a href='https://www.iso.org/standard/67978.html'>Solar thermal collectors — Test methods</a></i>. ISO.
</li>
<li>
Meertens, L.; Jansen, J.; Helsen, L. (2026).
<i>Development and Experimental Validation of an Open-Source 
Photovoltaic‑Thermal Collector Modelica Model that Only Needs
Datasheet Parameters</i>. Submitted to 
Mathematical and Computer Modelling of Dynamical Systems,
Special Issue on Modelica, FMI, and Open Standards.
</li>
</ul>
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
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
      graphics={
        Rectangle(
          extent={{-84,100},{84,-100}},
          lineColor={27,0,55},
          fillColor={26,0,55},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-76,0},{-76,-90},{66,-90},{66,-60},{-64,-60},{-64,
              -30},{66,-30},{66,0},{-64,0},{-64,28},{66,28},{66,60},{-64,60},{
              -64,86},{78,86},{78,0},{98,0},{100,0}},
          color={0,128,255},
          thickness=1,
          smooth=Smooth.None),
        Ellipse(
          extent={{-24,26},{28,-26}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-6,-6},{8,8}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={-24,30},
          rotation=90),
        Line(
          points={{-50,0},{-30,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-36,-40},{-20,-24}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-10,0},{10,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={2,-40},
          rotation=90),
        Line(
          points={{-8,-8},{6,6}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={30,-30},
          rotation=90),
        Line(
          points={{32,0},{52,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-8,-8},{6,6}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={28,32},
          rotation=180),
        Line(
          points={{-10,0},{10,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={0,40},
          rotation=90),
        Polygon(
          points={{72,96},{36,26},{60,34},{48,-24},{88,58},{64,48},{72,96}},
          lineColor={0,0,0},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid)}));
end PVTCollectorValidation;
