within Annex60.Fluid.HeatExchangers;
model HeaterCooler_T
  "Ideal heater or cooler with a prescribed outlet temperature"
  extends Annex60.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare final Annex60.Fluid.MixingVolumes.MixingVolume vol(prescribedHeatFlowRate=true),
    final showDesignFlowDirection=false);
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxHeat(
    min=0,
    max=Modelica.Constants.inf) = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxCool(
    min=-Modelica.Constants.inf,
    max=0.0) = - Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)";
  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Set point for leaving temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}, rotation=0)));
  Modelica.SIunits.HeatFlowRate Q_flow=-preHea.port.Q_flow "Heat flow rate";
protected
  Modelica.Blocks.Sources.RealExpression h_in(y=inStream(port_a.h_outflow))
    "Instreaming enthalpy"
    annotation (Placement(transformation(extent={{-80,66},{-60,86}})));
  Modelica.Blocks.Sources.RealExpression Xi[Medium.nXi](y=inStream(port_a.Xi_outflow)) if
       Medium.nXi > 0 "Inlet mass fractions"
    annotation (Placement(transformation(extent={{-80,52},{-60,72}})));
  Modelica.Blocks.Sources.RealExpression m_in_flow(y=port_a.m_flow)
    "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,38},{-60,58}})));
  Modelica.Blocks.Sources.RealExpression p(y=vol.ports[1].p) "Pressure"
    annotation (Placement(transformation(extent={{-80,26},{-60,46}})));

  Fluid.Interfaces.TemperatureControlledHeatFlow preHea(
    redeclare final package Medium = Medium,
    final Q_flow_maxHeat = Q_flow_maxHeat,
    final Q_flow_maxCool = Q_flow_maxCool,
    final m_flow_small =   m_flow_small) "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-38,50},{-18,70}})));

equation
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{-18,60},{-9,60},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TSet, preHea.TSet) annotation (Line(
      points={{-120,60},{-94,60},{-94,92},{-46,92},{-46,68},{-40,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHea.h_in, h_in.y) annotation (Line(
      points={{-40,64},{-50,64},{-50,76},{-59,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Xi.y, preHea.Xi) annotation (Line(
      points={{-59,62},{-50,62},{-50,60},{-40,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHea.m_flow, m_in_flow.y) annotation (Line(
      points={{-40,56},{-50,56},{-50,48},{-59,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, preHea.p) annotation (Line(
      points={{-59,36},{-46,36},{-46,52},{-40,52}},
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
