within Annex60.Fluid.HeatExchangers;
model HeaterCooler_T "Ideal heater or cooler with a prescribed outlet temperature"
  extends Annex60.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare final Annex60.Fluid.MixingVolumes.MixingVolume vol(prescribedHeatFlowRate=true),
    final showDesignFlowDirection=false);
  
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxHeat(
    min=0,max=Modelica.Constants.inf) = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxCool(
    min=-Modelica.Constants.inf,max=0.0) = - Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)";
  Modelica.Blocks.Interfaces.RealInput TSet(unit = "K") 
    "Control input (set temperature)"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}, rotation=0)));
  Modelica.SIunits.HeatFlowRate Q_flow=-preHea.port.Q_flow
    "Current heat flow rate";
  Annex60.Fluid.Interfaces.TemperatureControlledHeatFlow preHea(
    redeclare package Medium = Medium, 
    Q_flow_maxHeat = Q_flow_maxHeat, 
    Q_flow_maxCool = Q_flow_maxCool,
    m_flow = port_a.m_flow, 
    h_outflow = inStream(port_a.h_outflow), 
    Xi = inStream(port_a.Xi_outflow), 
    p = port_a.p)
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
equation
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{-20,60},{-9,60},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TSet, preHea.TSet) annotation (Line(
      points={{-120,60},{-40,60}},
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
        Text(
          extent={{-56,-12},{54,-72}},
          lineColor={0,0,255},
          textString="T=%TSet"),
        Rectangle(
          extent={{-100,61},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-122,106},{-78,78}},
          lineColor={0,0,255},
          textString="TSet")}),
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

The input signal <code>TSet</code> (set temperature in K) has to be positive and the calculated heat flow rate <code>Q_flow</code> 
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