within IBPSA.Fluid.PVTCollectors.Validation.PVT_UN;
model PVTCollectorValidation
  "Validation model of a photovoltaic–thermal (PVT) collector using the ISO 9806:2017 thermal method with integrated electrical coupling"
  extends .IDEAS.Fluid.PVTCollectors.Validation.BaseClasses.PartialPVTCollectorValidation(
    eleLosFac = 0.07);

  outer .Modelica.Blocks.Sources.CombiTimeTable meaDat(
    tableOnFile=true,
    tableName="data",
    fileName=.Modelica.Utilities.Files.loadResource(
        "modelica://IDEAS/Resources/Data/Fluid/PvtCollectors/Validation/PVT_UN/PVT_UN_measurements.txt"),
    columns=1:25) annotation (Placement(transformation(extent={{78,70},
            {58,90}})));

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

  replaceable .IDEAS.Fluid.PVTCollectors.Validation.BaseClasses.ISO9806SolarGainHGloTil
    solGaiStc(
    redeclare final package Medium = Medium,
    final nSeg=nSeg,
    final eta0=per.eta0,
    final use_shaCoe_in=use_shaCoe_in,
    final shaCoe=shaCoe,
    final A_c=ATot_internal)
    "Calculates the heat from the sun using the ISO 9806:2017 quasi-dynamic standard calculations"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
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

  .Modelica.Blocks.Sources.RealExpression Gglob(y=meaDat.y[4]) "[W/m2]"
    annotation (Placement(transformation(extent={{-51.5,66},{-32.5,82}})));
  .Modelica.Blocks.Sources.RealExpression globIrrTil(y=(meaDat.y[4])) "[W/m2]"
    annotation (Placement(transformation(extent={{-67.5,6},{-48.5,22}})));
  .Modelica.Blocks.Sources.RealExpression winSpe(y=(meaDat.y[10])) "[W/m2]"
    annotation (Placement(transformation(extent={{-67.5,28},{-48.5,44}})));
  .Modelica.Blocks.Sources.RealExpression HHorIr(y=.Modelica.Constants.sigma*(
        meaDat.y[23] + 273.15)^4) "[W/m2]"
    annotation (Placement(transformation(extent={{-67.5,18},{-48.5,34}})));
  .Modelica.Thermal.HeatTransfer.Celsius.ToKelvin TFluKel annotation (Placement(transformation(extent={{21,77},
            {11,87}})));
  .Modelica.Blocks.Sources.RealExpression[nSeg] qThSegExp(final y=qThSeg)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

equation
   // Assign electrical and thermal outputs
  Pel = eleGen.Pel;
  Qth = sum(QGai.Q_flow + QLos.Q_flow);

  // Compute thermal power per segment
  for i in 1:nSeg loop
    qThSeg[i] = (QGai[i].Q_flow + QLos[i].Q_flow) / (ATot_internal / nSeg);
  end for;

  connect(heaLosStc.TFlu, temSen.T) annotation (Line(
      points={{-22,14},{-30,14},{-30,-20},{-11,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLosStc.QLos_flow, QLos.Q_flow) annotation (Line(
      points={{1,20},{26,20},{26,20},{50,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(globIrrTil.y, heaLosStc.HGloTil) annotation (Line(points={{-47.55,14},
          {-32,14},{-32,18},{-22,18}}, color={0,0,127}));
  connect(winSpe.y, heaLosStc.winSpePla) annotation (Line(points={{-47.55,36},{
          -32,36},{-32,22},{-22,22}},
                                  color={0,0,127}));
  connect(solGaiStc.QSol_flow, QGai.Q_flow)
    annotation (Line(points={{1,50},{50,50}}, color={0,0,127}));
  connect(temSen.T, solGaiStc.TFlu) annotation (Line(points={{-11,-20},{-30,-20},
          {-30,42},{-22,42}}, color={0,0,127}));
  connect(Gglob.y, solGaiStc.HGlob) annotation (Line(points={{-31.55,74},{-30,74},
          {-30,58},{-22,58}}, color={0,0,127}));
  connect(eleGen.HGloTil, Gglob.y) annotation (Line(points={{-22,-76},{-30,-76},
          {-30,74},{-31.55,74}}, color={0,0,127}));
  connect(eleGen.Tflu, temSen.T) annotation (Line(points={{-22,-64},{-26,-64},{
          -26,-20},{-11,-20}}, color={0,0,127}));
  connect(HHorIr.y, heaLosStc.HHorIR) annotation (Line(points={{-47.55,26},{-36,
          26},{-36,20},{-22,20}}, color={0,0,127}));
  connect(heaLosStc.TEnv, TFluKel.Kelvin) annotation (Line(points={{-22,26},{-22,
          30},{-36,30},{-36,82},{10.5,82}}, color={0,0,127}));
  connect(TFluKel.Celsius, meaDat.y[5]) annotation (Line(points={{22,82},{54,82},
          {54,80},{57,80}}, color={0,0,127}));
  connect(qThSegExp.y,eleGen.qth)  annotation (Line(
      points={{-39,-70},{-22,-70}},
      color={0,0,127}));
  annotation (
  defaultComponentName="pvtCol",
  Documentation(info="<html>
<p>
Validation model of a photovoltaic–thermal (PVT) collector using the ISO 9806:2017 quasi-dynamic thermal method with integrated electrical coupling.  
Discretizes the collector into segments, computes heat loss and gain per ISO 9806:2017, 
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
<a href=\"modelica://IDEAS.Fluid.PVTCollectors.Validation.BaseClasses.ISO9806SolarGainHGloTil\">
IDEAS.Fluid.PVTCollectors.Validation.PVT_UN.BaseClasses.ISO9806SolarGainHGloTil
</a>
</li>
</ul>

<h4>Implementation Notes</h4>
<p> 
This validation model exclusively relies on measurement data provided by the 
CombiTimeTable <code>meaDat</code>. However, because it extends  
<a href='modelica://IDEAS.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector'>
IDEAS.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector</a> and to limit 
the number of extra components, the weather reader <code>IDEAS.BoundaryConditions.WeatherData.ReaderTMY3</code> 
remains instantiated and connected to the inherited <code>weaBus</code>. The 
reader is retained only to satisfy the parent class connector and is <em>not</em> 
used during simulation: all weather inputs (irradiance, ambient temperature, 
wind speed, etc.) are taken from <code>meaDat</code>, so the reader does not affect 
the model results. 
</p>
<p>
This model is designed for (unglazed) PVT collectors and discretizes the flow path 
into <code>nSeg</code> segments to capture temperature gradients.  It is compatible 
with dynamic simulations in which irradiance, ambient and fluid temperatures, 
and wind speed vary over time. 
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
Updated thermal formulation from ISO 9806:2013 to ISO 9806:2017 and added
conversion support. This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
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
