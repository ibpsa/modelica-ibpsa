within Annex60.Fluid.Interfaces;  
model TemperatureControlledHeatFlow 
  "Prescribed heat flow boundary condition, depending on a set temperature TSet"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxHeat
    "Maximum heat flow rate for heating (positive)";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxCool
    "Maximum heat flow rate for cooling (negative)";
  Modelica.Blocks.Interfaces.RealInput TSet(unit="K")
    "Set temperature"
    annotation (Placement(transformation(origin={-100,0},extent={{20,-20},{-20,20}},rotation=180)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port 
    annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
  input Medium.SpecificEnthalpy h_outflow
    "Specific thermodynamic enthalpy";
  input Medium.MassFlowRate m_flow
    "Mass flow rate";
  input Modelica.SIunits.Pressure p 
    "Pressure";
  input Modelica.SIunits.MassFraction Xi[Medium.nXi] 
    "Mass fraction";
  equation  
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
        is given by the input signal TSet into the model. The heat flows into the
        component to which the component TemperatureControlledHeatFlow is connected,
        if the input signal is positive.
        </p>
        </html>",
        revisions="<html>
        <ul>
        <li>
        November 28, 2014, by Christoph Nytsch-Geusen:<br/>
        First implementation.
        </li>
        </ul>
        </html>"), 
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
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
  