within IDEAS.Fluid.Production.BaseClasses;
model HeatSource_HP_BW
  "Brine/Water, Computation of theoretical condensation power of the refrigerant based on interpolation data.  Takes into account losses of the heat pump to the environment"

  /*
  This model is based on catalogue data from Viessmann for the vitocal 300-G, type BW/BWC 108 (8kW nominal power) 
  
  First, the thermal power and electricity consumption are interpolated for the 
  evaporator and condensing set temperature.  The results
  are rescaled to the nominal power of the modelled heatpump (with QNom/QNom_data).
    
  The heat pump is an on/off heat pump, and a hysteresis is foreseen around the condensor set temperature
  for on/off switching 
   
  ATTENTION
  This model takes into account environmental heat losses of the heat pump (at condensor side).
  In order to keep the same nominal COP's during operation of the heat pump, these heat losses are added
  to the computed power.  Therefore, the heat losses are only really 'losses' when the heat pump is 
  NOT operating. 
  
  The COP is calculated as the heat delivered to the condensor divided by the electrical consumption (P). 
  
  */
  //protected

  replaceable package MediumPrimary =
      Modelica.Media.Interfaces.PartialMedium
    "Medium at the secondary side of the heat pump";

  replaceable package MediumSecondary =
      Modelica.Media.Interfaces.PartialMedium
    "Medium at the primary side of the heat pump";
  final parameter Modelica.SIunits.Power QNomRef=8270
    "Nominal power of the Viesmann Vitocal 300-G BW/BWC 108.  See datafile";
  parameter Modelica.SIunits.ThermalConductance UALoss
    "UA of heat losses of HP to environment";
  parameter Modelica.SIunits.Power QNom
    "The power at nominal conditions (0/35)";

public
  Modelica.SIunits.Power PEl "Resulting electrical power";
  Modelica.SIunits.Temperature TEvaporator "Evaporator temperature";
  input Modelica.SIunits.Temperature TCondensor_in "Condensor temperature";
  input Modelica.SIunits.Temperature TCondensor_set
    "Condensor setpoint temperature.  Not always possible to reach it";
  input Modelica.SIunits.MassFlowRate m_flowCondensor
    "Condensor mass flow rate";
  input Modelica.SIunits.Temperature TEnvironment
    "Temperature of environment for heat losses";
  Real modulation(min=0, max=100)
    "Current modulation percentage, has no function in this on/off heat pump";

protected
  Modelica.Blocks.Tables.CombiTable2D P100(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
      table=[0, 0, 15; 35, 1.8, 1.99; 45, 2.2, 2.41; 55, 2.72, 2.98])
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Tables.CombiTable2D Q100(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
      table=[0, 0, 15; 35, 8.27, 12.25; 45, 7.75, 11.63; 55, 7.38, 11.07])
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Tables.CombiTable2D evap100(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
      table=[0, 0, 15; 35, 6.6, 10.73; 45, 5.82, 9.76; 55, 5.06, 8.63])
    "Evaporator power, in kW"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Modelica.SIunits.HeatFlowRate QLossesToCompensate "Environment losses";
  Modelica.SIunits.HeatFlowRate QCond;
  Modelica.SIunits.HeatFlowRate QEvap;
  Modelica.SIunits.Power PComp;
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "heatPort connection to water in condensor"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  IDEAS.BaseClasses.Control.Hyst_NoEvent onOff(
    uLow=-2.5,
    uHigh=2.5,
    y(start=0),
    enableRelease=true) "on-off, based on modulationInit"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  IDEAS.Fluid.FixedResistances.Pipe_HeatPort evaporator(
    m=3,
    redeclare package Medium = MediumPrimary,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    T_start=556.3)
    annotation (Placement(transformation(extent={{-10,-66},{10,-46}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-52,-52},{-32,-32}})));
  parameter SI.MassFlowRate m_flow_nominal "Nominal mass flow rate";
  parameter SI.Pressure dp_nominal=0 "Nominal pressure drop";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumPrimary) "Fluid inlet"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumPrimary) "Fluid outlet"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=-QEvap)
    annotation (Placement(transformation(extent={{-18,-16},{-44,4}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{36,-10},{56,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=-QCond -
        QLossesToCompensate)
    annotation (Placement(transformation(extent={{-14,-16},{22,4}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1
    annotation (Placement(transformation(extent={{64,-10},{84,10}})));
equation
  TEvaporator = MediumPrimary.temperature(MediumPrimary.setState_phX(MediumPrimary.p_default, inStream(port_a.h_outflow), MediumPrimary.X_default));
  onOff.u = TCondensor_set - heatPort.T;
  onOff.release = noEvent(if m_flowCondensor > 0 then 1.0 else 0.0);
  //QAsked = m_flowCondensor * medium.cp * (TCondensor_set - TCondensor_in);
  P100.u1 = heatPort.T - 273.15;
  P100.u2 = TEvaporator - 273.15;
  Q100.u1 = heatPort.T - 273.15;
  Q100.u2 = TEvaporator - 273.15;
  evap100.u1 = heatPort.T - 273.15;
  evap100.u2 = TEvaporator - 273.15;

  // all these are in W

  QCond = Q100.y*QNom/QNomRef*1000;
  PComp = P100.y*QNom/QNomRef*1000;
  QEvap = evap100.y*QNom/QNomRef*1000;

  // compensation of heat losses (only when the hp is operating)
  QLossesToCompensate = UALoss*(heatPort.T - TEnvironment);
  modulation = onOff.y*100;
  PEl = onOff.y*PComp;

  connect(evaporator.heatPort, prescribedHeatFlow.port) annotation (Line(
      points={{6.66134e-16,-46},{6.66134e-16,-42},{-32,-42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(evaporator.port_a, port_a) annotation (Line(
      points={{-10,-56},{-40,-56},{-40,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(evaporator.port_b, port_b) annotation (Line(
      points={{10,-56},{40,-56},{40,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(product.u1, onOff.y) annotation (Line(
      points={{-58,6},{-4,6},{-4,18},{52,18},{52,30},{40.6,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, product.u2) annotation (Line(
      points={{-45.3,-6},{-58,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{-81,6.66134e-16},{-90,6.66134e-16},{-90,-42},{-52,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression1.y, product1.u2) annotation (Line(
      points={{23.8,-6},{34,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow1.port, heatPort) annotation (Line(
      points={{84,4.44089e-16},{92,4.44089e-16},{92,0},{100,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(product1.u1, onOff.y) annotation (Line(
      points={{34,6},{20,6},{20,18},{52,18},{52,30},{40.6,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow1.Q_flow, product1.y) annotation (Line(
      points={{64,8.88178e-16},{64,6.66134e-16},{57,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Documentation(info="<html>
<p><b>Description</b> </p>
<p>This&nbsp;model&nbsp;is&nbsp;based&nbsp;on&nbsp;catalogue&nbsp;data&nbsp;from&nbsp;Viessmann&nbsp;for&nbsp;the&nbsp;vitocal&nbsp;300-G,&nbsp;type&nbsp;BW/BWC&nbsp;108&nbsp;(8kW&nbsp;nominal&nbsp;power at 0/35 degC) and the full heat pump is implemented as <a href=\"modelica://IDEAS.Thermal.Components.Production.HP_BrineWater\">IDEAS.Thermal.Components.Production.HP_BrineWater</a> .</p>
<p>First,&nbsp;the&nbsp;thermal&nbsp;power&nbsp;and&nbsp;electricity&nbsp;consumption&nbsp;are&nbsp;interpolated&nbsp;for&nbsp;the&nbsp;evaporator&nbsp;and&nbsp;condensing&nbsp;temperature.&nbsp;&nbsp;The&nbsp;results&nbsp;are&nbsp;rescaled&nbsp;to&nbsp;the&nbsp;nominal&nbsp;power&nbsp;of&nbsp;the&nbsp;modelled&nbsp;heatpump&nbsp;(with&nbsp;QNom/QNom_data)&nbsp;and&nbsp;stored&nbsp;in&nbsp;2&nbsp;different&nbsp;vectors,&nbsp;Q_vector&nbsp;and&nbsp;P_vector.</p>
<p>There is hysteresis&nbsp;for&nbsp;on/off&nbsp;cycling based on the difference between TSet and the current condenser temperature. </p>
<p><h4>ATTENTION</h4></p>
<p>This&nbsp;model&nbsp;takes&nbsp;into&nbsp;account&nbsp;environmental&nbsp;heat&nbsp;losses&nbsp;of&nbsp;the&nbsp;heat pump.&nbsp;&nbsp;In&nbsp;order&nbsp;to&nbsp;keep&nbsp;the&nbsp;same&nbsp;nominal&nbsp;efficiency&nbsp;during&nbsp;operation,&nbsp;these&nbsp;heat&nbsp;losses&nbsp;are&nbsp;added&nbsp;to&nbsp;the&nbsp;computed&nbsp;power.&nbsp;&nbsp;Therefore,&nbsp;the&nbsp;heat&nbsp;losses&nbsp;are&nbsp;only&nbsp;really&nbsp;&apos;losses&apos;&nbsp;when&nbsp;the&nbsp;heat pump&nbsp;is&nbsp;NOT&nbsp;operating.&nbsp;</p>
<p>The&nbsp;COP&nbsp;is&nbsp;calculated&nbsp;as&nbsp;the&nbsp;heat&nbsp;delivered&nbsp;to&nbsp;the&nbsp;condensor&nbsp;divided&nbsp;by&nbsp;the&nbsp;electrical&nbsp;consumption&nbsp;(P).</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Based on interpolation in manufacturer data for&nbsp;Viessmann&nbsp;for&nbsp;the&nbsp;vitocal&nbsp;300-G,&nbsp;type&nbsp;BW/BWC&nbsp;108&nbsp;(8kW&nbsp;nominal&nbsp;power at 0/35 degC)</li>
<li>Ensure not to operate the heat pump outside of the manufacturer data. No check is made if this happens, and this can lead to strange and wrong results.</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>This model is used in the <a href=\"modelica://IDEAS.Thermal.Components.Production.HP_BrineWater\">IDEAS.Thermal.Components.Production.HP_BrineWater</a>  model and derivatives with boreholes. If a different heat pumpr is to be simulated, copy this model and adapt the interpolation tables.</p>
<p><h4>Validation </h4></p>
<p>No specific validation foreseen.</p>
</html>"));
end HeatSource_HP_BW;
