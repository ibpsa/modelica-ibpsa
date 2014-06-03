within IDEAS.Fluid.Domestic_Hot_Water;
partial model partial_DHW "partial DHW model"
  import IDEAS;

  parameter Modelica.SIunits.Temperature TDHWSet(max=273.15 + 60) = 273.15 + 45
    "DHW temperature setpoint";
  parameter Modelica.SIunits.Temperature TColdWaterNom=273.15 + 10
    "Nominal cold water temperature";
  parameter Modelica.SIunits.MassFlowRate m_flow_max = m_flow_nominal
    "maximum mass flow rate of DHW (not necessarily at TDHWSet)";

  // we need to specify the flowrate in the pump and mixingValve as relative values between 0 and 1
  // so we compute a maximum flowrate and use this as nominal flowrate for these components
  // We suppose the flowrate will always be lower than 1e3 kg/s.

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";

public
  Modelica.Fluid.Interfaces.FluidPort_a port_hot(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=TColdWaterNom)
    annotation (Placement(transformation(extent={{26,-40},{46,-20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_cold(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem_hot(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=tau) annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-30,46},{-14,62}})));
  Modelica.Blocks.Sources.Constant TTapWat_val(k=TColdWaterNom)
    "Water temperature for the tapwater"
    annotation (Placement(transformation(extent={{-100,18},{-86,32}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{-4,22},{10,36}})));
  Modelica.Blocks.Sources.Constant TDHW_val(k=TDHWSet)
    "Temperature of the Domestic hot water"
    annotation (Placement(transformation(extent={{-100,48},{-86,62}})));

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
    annotation (Placement(transformation(extent={{80,10},{100,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  parameter SI.Time tau=30 "Tin time constant at nominal flow rate";
  Modelica.Blocks.Math.Add TemDifDHWTap(k2=-1)
    "Temperature difference between supply and net"
    annotation (Placement(transformation(extent={{-60,40},{-42,58}})));
  Modelica.Blocks.Math.Add TemDifHotTap(k2=-1)
    "Temperature difference between the port_hot temperature and the tapwater"
    annotation (Placement(transformation(extent={{-60,34},{-42,16}})));

  Modelica.SIunits.Temperature TDHW_actual = max(senTem_hot.T,TDHWSet);
  IDEAS.Utilities.Math.SmoothLimit smoothLimit(                   lower=0,
    deltaX=0.01*m_flow_nominal,
    upper=m_flow_max)
    annotation (Placement(transformation(extent={{20,22},{34,36}})));
  IDEAS.Utilities.Math.SmoothMin smoothMin(deltaX=0.1)
    annotation (Placement(transformation(extent={{-30,18},{-16,32}})));
  Modelica.Blocks.Sources.RealExpression minValTemDiff(y=0.1)
    "minimal value of the temperature difference, to avoid division by zero."
    annotation (Placement(transformation(extent={{-46,-4},{-38,12}})));
equation
  connect(port_hot, senTem_hot.port_a) annotation (Line(
      points={{-100,4.44089e-16},{-88,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(division.u1, product.y) annotation (Line(
      points={{-5.4,33.2},{-8,33.2},{-8,54},{-13.2,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealSource.port_a, senTem_hot.port_b) annotation (Line(
      points={{40,0},{-68,0}},
      color={0,127,255},
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
      points={{80,-30},{90,-30},{90,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(realExpression.y, prescribedTemperature.T) annotation (Line(
      points={{47,-30},{58,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TDHW_val.y, TemDifDHWTap.u1) annotation (Line(
      points={{-85.3,55},{-76,55},{-76,54.4},{-61.8,54.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TTapWat_val.y, TemDifDHWTap.u2) annotation (Line(
      points={{-85.3,25},{-76,25},{-76,43.6},{-61.8,43.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem_hot.T, TemDifHotTap.u1) annotation (Line(
      points={{-78,11},{-78,19.6},{-61.8,19.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TTapWat_val.y, TemDifHotTap.u2) annotation (Line(
      points={{-85.3,25},{-76,25},{-76,30.4},{-61.8,30.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TemDifDHWTap.y, product.u2) annotation (Line(
      points={{-41.1,49},{-36.55,49},{-36.55,49.2},{-31.6,49.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(division.y, smoothLimit.u) annotation (Line(
      points={{10.7,29},{18.6,29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoothLimit.y, idealSource.m_flow_in) annotation (Line(
      points={{34.7,29},{44,29},{44,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoothMin.y, division.u2) annotation (Line(
      points={{-15.3,25},{-18,24.8},{-5.4,24.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TemDifHotTap.y, smoothMin.u1) annotation (Line(
      points={{-41.1,25},{-38,25},{-38,29.2},{-31.4,29.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(minValTemDiff.y, smoothMin.u2) annotation (Line(
      points={{-37.6,4},{-36,4},{-36,20.8},{-31.4,20.8}},
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
<li><i>flowPortCold</i>: connection to the inlet of cold water in the hot water source (designation: <i>cold</i>)</li>
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
