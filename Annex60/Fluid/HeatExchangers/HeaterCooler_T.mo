within Annex60.Fluid.HeatExchangers;
model HeaterCooler_T
  "Ideal heater or cooler with a prescribed outlet temperature"
  extends Annex60.Fluid.Interfaces.PartialTwoPortInterface;
  extends Annex60.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxHeat(
    min=0,
    max=Modelica.Constants.inf) = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxCool(
    min=-Modelica.Constants.inf,
    max=0.0) = - Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)";

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Set point temperature of the fluid that leaves port_b"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}, rotation=0)));
    // fixme  Modelica.SIunits.HeatFlowRate Q_flow=-preHea.port.Q_flow "Heat flow rate";

  // Models for conservation equations and pressure drop
protected
  Annex60.Fluid.FixedResistances.FixedResistanceDpM preDro(
    redeclare final package Medium = Medium,
    final use_dh=false,
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp_nominal) "Pressure drop model"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Annex60.Fluid.Interfaces.PrescribedOutletState heaCoo(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small,
    final show_T=false,
    final show_V_flow=false,
    final Q_flow_maxHeat=Q_flow_maxHeat,
    final Q_flow_maxCool=Q_flow_maxCool) "Heater or cooler"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(port_a, preDro.port_a) annotation (Line(
      points={{-100,0},{-50,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preDro.port_b, heaCoo.port_a) annotation (Line(
      points={{-30,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaCoo.port_b, port_b) annotation (Line(
      points={{40,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaCoo.TSet, TSet) annotation (Line(
      points={{18,8},{0,8},{0,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,5},{99,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,61},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-106,98},{-62,70}},
          lineColor={0,0,255},
          textString="T")}),
defaultComponentName="hea",
Documentation(info="<html>
<p>
Model for an ideal heater or cooler with a prescribed outlet temperature of the medium.
</p>
<p>
This model adds an heat amount to the medium that the outlet temperature reaches the value <code>TSet</code>. 
If the maximum positive or negative value is greater than <code>Q_flow_maxHeat</code> or smaller than 
<code>Q_flow_maxCool</code> the outlet temperature is calculated with these max./min. values. So, for the calculation of
the ideal heating or cooling demand of the heater/cooler the default value of the parameter <code>Q_flow_maxHeat</code>
is set to <code>Modelica.Constant.inf</code> and <code>Q_flow_maxCool</code> to <code>-Modelica.Constant.inf</code>.

The input signal <code>Tset</code> (set temperature in K) has to be positive and the calculated heat flow rate <code>Q_flow</code> 
can be positive or negative.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 19, 2014, by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics));
end HeaterCooler_T;
