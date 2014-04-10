within IDEAS.Fluid.Domestic_Hot_Water;
partial model partial_DHW "partial DHW model"
  import IDEAS;
  import Buildings;

  parameter Modelica.SIunits.Temperature TDHWSet(max=273.15 + 60) = 273.15 + 45
    "DHW temperature setpoint";
  parameter Modelica.SIunits.Temperature TCold=283.15;

  // we need to specify the flowrate in the pump and mixingValve as relative values between 0 and 1
  // so we compute a maximum flowrate and use this as nominal flowrate for these components
  // We suppose the flowrate will always be lower than 1e3 kg/s.

protected
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1e3
    "only used to set a reference";

  /*
  Slows down the simulation too much.  Should be in post processing
  Real m_flowIntegrated(start = 0, fixed = true);
  Real m_flowDiscomfort(start=0);
  Real discomfort; //base 1
  Real discomfortWeighted;
  Real dTDiscomfort;
  */

public
  Modelica.Fluid.Interfaces.FluidPort_a port_hot(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));

  Fluid.Movers.Pump pumpHot(
    useInput=true,
    m_flow_nominal=m_flow_nominal,
    m=1,
    redeclare package Medium = Medium)
         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={64,0})));

  Modelica.Blocks.Interfaces.RealInput mDHW60C
    "Mass flowrate of DHW at 60 degC in kg/s" annotation (Placement(
        transformation(extent={{-74,70},{-34,110}}), iconTransformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={20,100})));
  IDEAS.Fluid.Sources.Boundary_pT cold(
    redeclare package Medium = Medium,
    use_T_in=true,
    p=500000,
    nPorts=2) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,-10})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=TCold)
    annotation (Placement(transformation(extent={{44,-36},{64,-16}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_cold(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=30) annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-20,64},{0,84}})));
  Modelica.Blocks.Math.Sum sum1(nin=2, k={1,-1})
    annotation (Placement(transformation(extent={{-58,40},{-42,56}})));
  Buildings.HeatTransfer.Radiosity.Constant const(k=273.15 + 10)
    annotation (Placement(transformation(extent={{-102,42},{-88,56}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{12,44},{32,64}})));
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal)
    annotation (Placement(transformation(extent={{-30,40},{-14,56}})));
  Modelica.Blocks.Math.Sum sum2(nin=2, k={1,-1})
    annotation (Placement(transformation(extent={{-58,62},{-42,78}})));
  Buildings.HeatTransfer.Radiosity.Constant const1(k=273.15 + 60)
    annotation (Placement(transformation(extent={{-102,70},{-88,84}})));

equation
  connect(realExpression.y, cold.T_in) annotation (Line(
      points={{65,-26},{96,-26},{96,-24},{96,-24},{96,-22},{96,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cold.ports[1], port_cold) annotation (Line(
      points={{98,8.88178e-16},{126,8.88178e-16},{126,0},{140,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumpHot.port_b, cold.ports[2]) annotation (Line(
      points={{74,4.44089e-16},{102,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_hot, senTem.port_a) annotation (Line(
      points={{-100,4.44089e-16},{-88,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_b, pumpHot.port_a) annotation (Line(
      points={{-68,4.44089e-16},{54,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.T, sum1.u[1]) annotation (Line(
      points={{-78,11},{-78,46},{-59.6,46},{-59.6,47.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.u1, mDHW60C) annotation (Line(
      points={{-22,80},{-30,80},{-30,90},{-54,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.JOut, sum1.u[2]) annotation (Line(
      points={{-87.3,49},{-60,49},{-60,48},{-60,48},{-59.6,48},{-59.6,48.8}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(division.u1, product.y) annotation (Line(
      points={{10,60},{6,60},{6,74},{1,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(division.y, pumpHot.m_flowSet) annotation (Line(
      points={{33,54},{64,54},{64,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, division.u2) annotation (Line(
      points={{-13.2,48},{10,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, sum1.y) annotation (Line(
      points={{-31.6,48},{-41.2,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.JOut, sum2.u[1]) annotation (Line(
      points={{-87.3,77},{-73.65,77},{-73.65,69.2},{-59.6,69.2}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(sum2.u[2], const.JOut) annotation (Line(
      points={{-59.6,70.8},{-80,70.8},{-80,49},{-87.3,49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.u2, sum2.y) annotation (Line(
      points={{-22,68},{-32,68},{-32,70},{-41.2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-40},{140,100}}, preserveAspectRatio=false),
                   graphics),
    Icon(coordinateSystem(extent={{-100,-40},{140,100}}, preserveAspectRatio=
            false), graphics={
        Line(
          points={{-20,30},{20,-30},{-20,-30},{20,30},{-20,30}},
          color={100,100,100},
          smooth=Smooth.None,
          origin={-30,0},
          rotation=-90),
        Line(
          points={{-70,0},{-70,0},{-100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{20,40},{20,0},{20,0}},
          color={100,100,100},
          smooth=Smooth.None),
        Line(
          points={{0,40},{40,40},{34,80},{4,80},{0,40}},
          color={100,100,100},
          smooth=Smooth.None),
        Line(
          points={{-70,20},{-70,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{140,0},{140,0},{110,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{110,18},{110,-22}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-20,30},{20,-30},{-20,-30},{20,30},{-20,30}},
          color={100,100,100},
          smooth=Smooth.None,
          origin={70,0},
          rotation=-90),
        Line(
          points={{0,0},{40,0},{40,-2}},
          color={100,100,100},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Partial model of a domestic hot water (DHW) system composed mainly of a thermostatic mixing valve. The model foresees a cold water flowPort which has to be connected to the system (eg. storage tank).</p>
<p>The model has two flowPorts and a realInput:</p>
<p><ul>
<li><i>port_hot</i>: connection to the hot water source (designation: <i>hot</i>)</li>
<li><i>flowPortDold</i>: connection to the inlet of cold water in the hot water source (designation: <i>cold</i>)</li>
<li><i>mDHW60C</i>: desired flowrate of DHW water (designation: <i>mixed</i>), equivalent at 60&deg;C</li>
</ul></p>
<p>In a first step, the desired DHW flow rate is computed based on <i>mDHW60C</i> and the set temperature <i>TDHWSet</i>.  The model tries to reach the given DHW flow rate at a the desired mixing temperature <i>TDHWSet </i>by mixing the hot water with cold water. The resulting hot flowrate will be extracted automatically from the hot source, and through the connection of flowPortCold to the hot source, this same flow rate will be injected (at TCold) in the production system. </p>
<p>There are currently two implementations of this partial model:</p>
<p><ol>
<li><a href=\"modelica://IDEAS.Thermal.Components.Domestic_Hot_Water.DHW_ProfileReader\">Reading in mDHW60c from a table</a></li>
<li><a href=\"modelica://IDEAS.Thermal.Components.Domestic_Hot_Water.DHW_RealInput\">Getting mDHW60c from a realInput</a></li>
</ol></p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>No heat losses</li>
<li>Inertia is foreseen through the inclusion of a water volume on the hot water side (default=1 liter). This parameter is not propagated to the interface, but it can be changed by modifying pumpHot.m.  Putting this water content to zero may lead to numerical problems (not tested)</li>
<li>If THot &LT; TDHWSEt, there is no mixing and TMixed = THot</li>
<li>Fixed TDHWSet and TCold as parameters</li>
<li>The mixed DHW is not available as an outlet or flowPort, it is assumed to be &apos;consumed&apos;. </li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Set the parameters for cold water temperature and the DHW set temperature (mixed)</li>
<li>Connect <i>port_hot </i>to the hot water source</li>
<li>Connect <i>flowPortCold</i> to the cold water inlet of the hot water source</li>
<li>Depending on the implementation: fill out the table or provide a realInput for <i>mDHW60C</i></li>
<li>Thanks to the use of <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Ambient\">ambient</a> components in this model, it is <b>NOT</b> required to add additional pumps, ambients or AbsolutePressure to the DHW circuit.</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>The model is verified to work properly by simulation of the different operating conditions.</p>
<p><h4>Examples</h4></p>
<p>An example of this model is given in <a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP\">IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: documentation.</li>
<li>2012 September, Roel De Coninck, simplification of equations.</li>
<li>2012 August, Roel De Coninck, first implementation.</li>
</ul></p>
</html>"));
end partial_DHW;
