within Annex60.Fluid.HeatExchangers;
model HeaterCooler_T
  "Ideal heater or cooler with a prescribed outlet temperature"
  extends Annex60.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare final Annex60.Fluid.MixingVolumes.MixingVolume vol(prescribedHeatFlowRate=true),
    final showDesignFlowDirection=false);
    model TemperatureControlledHeatFlow
    "Prescribed heat flow boundary condition, depending on a set temperature TSet"
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      "Medium in the component"
      annotation (choicesAllMatching = true);
    parameter Modelica.SIunits.HeatFlowRate Q_flow_maxHeat
      "Maximum heat flow rate for heating (positive)";
    parameter Modelica.SIunits.HeatFlowRate Q_flow_maxCool
      "Maximum heat flow rate for cooling (negative)";
    Modelica.Blocks.Interfaces.RealInput TSet(unit="K")
      "Set temperature of the heater"
      annotation (Placement(transformation(origin={-100,0},extent={{20,-20},{-20,20}},rotation=180)));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port
      annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
    input Medium.SpecificEnthalpy h_outflow "Specific thermodynamic enthalpy";
    input Medium.MassFlowRate m_flow "Mass flow rate";
    input Modelica.SIunits.Pressure p "Pressure";
    input Modelica.SIunits.MassFraction Xi[Medium.nXi] "Mass fraction";
    equation
      // fixme: this triggers a state event at m_flow=0 which must be fixed.
      if m_flow > 0 then
        if Q_flow_maxHeat <> Modelica.Constants.inf and  Q_flow_maxCool == - Modelica.Constants.inf then
          port.Q_flow = - Annex60.Utilities.Math.Functions.smoothLimit((Medium.specificEnthalpy(Medium.setState_pTX(p=p, T=TSet, X=Xi)) - h_outflow) * m_flow, - Modelica.Constants.inf, Q_flow_maxHeat, 0.1);
        elseif Q_flow_maxHeat == Modelica.Constants.inf and  Q_flow_maxCool <> - Modelica.Constants.inf then
          port.Q_flow = - Annex60.Utilities.Math.Functions.smoothLimit((Medium.specificEnthalpy(Medium.setState_pTX(p=p, T=TSet, X=Xi)) - h_outflow) * m_flow, Q_flow_maxCool, Q_flow_maxHeat, 0.1);
        else
          port.Q_flow = - (Medium.specificEnthalpy(Medium.setState_pTX(p=p, T=TSet, X=Xi)) - h_outflow) * m_flow;
        end if;
      else
        port.Q_flow = 0.0;
      end if;
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={
          Line(
            points={{-60,-20},{40,-20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-60,20},{40,20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-80,0},{-60,-20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-80,0},{-60,20}},
            color={191,0,0},
            thickness=0.5),
          Polygon(
            points={{40,0},{40,40},{70,20},{40,0}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{40,-40},{40,0},{70,-20},{40,-40}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{70,40},{90,-40}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,100},{150,60}},
            textString="%name",
            lineColor={0,0,255}),
          Text(
            extent={{-100,48},{-60,0}},
            lineColor={255,0,0},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid,
            textString="T")}),
      Documentation(info="<HTML>
  <p>
  This model allows a specified amount of heat flow rate to be \"injected\"
  into a thermal system at a given port. The amount of heat
  is given by the input signal T_set into the model. The heat flows into the
  component to which the component PrescribedHeatFlow is connected,
  if the input signal is positive.
  </p>
  </html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}), graphics={
          Line(
            points={{-60,-20},{68,-20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-60,20},{68,20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-80,0},{-60,-20}},
            color={191,0,0},
            thickness=0.5),
          Line(
            points={{-80,0},{-60,20}},
            color={191,0,0},
            thickness=0.5),
          Polygon(
            points={{60,0},{60,40},{90,20},{60,0}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{60,-40},{60,0},{90,-20},{60,-40}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid)}));
    end TemperatureControlledHeatFlow;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxHeat(
    min=0,max=Modelica.Constants.inf) = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxCool(
    min=-Modelica.Constants.inf,max=0.0) = - Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)";
  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Set point for leaving temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}, rotation=0)));
  Modelica.SIunits.HeatFlowRate Q_flow=-preHea.port.Q_flow
    "Current heat flow rate";
  TemperatureControlledHeatFlow preHea(
    redeclare package Medium = Medium,
    Q_flow_maxHeat = Q_flow_maxHeat,
    Q_flow_maxCool = Q_flow_maxCool,
    m_flow = port_a.m_flow,
    h_outflow = inStream(port_a.h_outflow),
    Xi = inStream(port_a.Xi_outflow),
    p = port_a.p) "Prescribed heat flow"
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
        Rectangle(
          extent={{-100,61},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-122,106},{-78,78}},
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

The input signal <code>u</code> (set temperature in K) has to be positive and the calculated heat flow rate <code>Q_flow</code> 
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics));
end HeaterCooler_T;
