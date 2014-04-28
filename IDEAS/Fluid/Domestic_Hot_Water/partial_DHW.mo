within IDEAS.Fluid.Domestic_Hot_Water;
partial model partial_DHW "partial DHW model"
  import IDEAS;

  parameter Modelica.SIunits.Temperature TDHWSet(max=273.15 + 60) = 273.15 + 45
    "DHW temperature setpoint";
  parameter Modelica.SIunits.Temperature TCold=283.15;

  // we need to specify the flowrate in the pump and mixingValve as relative values between 0 and 1
  // so we compute a maximum flowrate and use this as nominal flowrate for these components
  // We suppose the flowrate will always be lower than 1e3 kg/s.

protected
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";

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


  Modelica.Blocks.Sources.RealExpression realExpression(y=TCold)
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_cold(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=tau)
            annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Math.Sum sum1(nin=2, k={1,-1})
    annotation (Placement(transformation(extent={{-56,16},{-40,32}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 10)
    annotation (Placement(transformation(extent={{-100,18},{-86,32}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Math.Sum sum2(nin=2, k={1,-1})
    annotation (Placement(transformation(extent={{-56,38},{-40,54}})));
  Modelica.Blocks.Sources.Constant const1(k=273.15 + 60)
    annotation (Placement(transformation(extent={{-100,46},{-86,60}})));

  IDEAS.Fluid.Interfaces.IdealSource idealSource(
    redeclare package Medium = Medium,
    control_m_flow=true,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    dynamicBalance=false,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  parameter SI.Time tau=30 "Tin time constant at nominal flow rate";
equation
  connect(port_hot, senTem.port_a) annotation (Line(
      points={{-100,4.44089e-16},{-88,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.T, sum1.u[1]) annotation (Line(
      points={{-78,11},{-78,22},{-57.6,22},{-57.6,23.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, sum1.u[2]) annotation (Line(
      points={{-85.3,25},{-58,25},{-58,24},{-57.6,24},{-57.6,24.8}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(division.u1, product.y) annotation (Line(
      points={{18,36},{8,36},{8,50},{1,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, sum2.u[1]) annotation (Line(
      points={{-85.3,53},{-71.65,53},{-71.65,45.2},{-57.6,45.2}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(sum2.u[2], const.y) annotation (Line(
      points={{-57.6,46.8},{-78,46.8},{-78,25},{-85.3,25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.u2, sum2.y) annotation (Line(
      points={{-22,44},{-30,44},{-30,46},{-39.2,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sum1.y, division.u2) annotation (Line(
      points={{-39.2,24},{18,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealSource.port_a, senTem.port_b) annotation (Line(
      points={{40,0},{-68,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(division.y, idealSource.m_flow_in) annotation (Line(
      points={{41,30},{42,30},{42,8},{44,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealSource.port_b, pipe_HeatPort.port_a) annotation (Line(
      points={{60,0},{80,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort.port_b, port_cold) annotation (Line(
      points={{100,0},{140,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, pipe_HeatPort.heatPort) annotation (Line(
      points={{80,80},{90,80},{90,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(realExpression.y, prescribedTemperature.T) annotation (Line(
      points={{41,80},{58,80}},
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
