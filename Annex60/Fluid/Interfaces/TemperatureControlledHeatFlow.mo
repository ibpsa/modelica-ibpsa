within Annex60.Fluid.Interfaces;
model TemperatureControlledHeatFlow
  "Prescribed heat flow boundary condition, depending on a set temperature TSet"
replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
  annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxHeat
    "Maximum heat flow rate for heating (positive)";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxCool
    "Maximum heat flow rate for cooling (negative)";

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0)
    "Small mass flow rate for regularization of zero flow";

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K") "Set point temperature" annotation (
     Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput h_in(unit="J/kg") "Inflowing enthalpy"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput m_flow(unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput p(unit="Pa") "Pressure"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealInput Xi[Medium.nXi](each unit="1")
    "Mass fraction"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port
    "Heat port to be connected to the volume"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  parameter Boolean restrictHeat = Q_flow_maxHeat <> Modelica.Constants.inf
    "Flag, true if maximum heating power is restricted";
  parameter Boolean restrictCool = Q_flow_maxCool <> -Modelica.Constants.inf
    "Flag, true if maximum cooling power is restricted";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(
        Medium.setState_pTX(
          p=Medium.p_default,
          T=Medium.T_default,
          X=Medium.X_default)) "Specific heat capacity at default medium state";
   parameter Modelica.SIunits.TemperatureDifference dT_small = 1E-2
    "Small temperature difference used for regularization";

   parameter Modelica.SIunits.HeatFlowRate Q_flow_small = m_flow_small*cp_default*dT_small
    "Small value for heat flow rate that is used in the regularization";

   Modelica.SIunits.HeatFlowRate QUnl_flow
    "Heat flow rate to be added to the fluid flow in case of unlimited capacity";

equation
  // fixme: need to handle reverse flow
  if allowFlowReversal then
    gai = xxx;
    QUnl_flow = gai * m_flow * (Medium.specificEnthalpy(
    Medium.setState_pTX(
      p=p,
      T=TSet,
      X=Xi)) - h_in);
  else
    gai = 0;
    QUnl_flow = m_flow * (Medium.specificEnthalpy(
    Medium.setState_pTX(
      p=p,
      T=TSet,
      X=Xi)) - h_in);
  end if;

  if restrictHeat and restrictCool then
    port.Q_flow = -Annex60.Utilities.Math.Functions.smoothLimit(
      x=QUnl_flow,
      l=Q_flow_maxCool,
      u=Q_flow_maxHeat,
      deltaX=Q_flow_small);
  elseif restrictHeat then
    port.Q_flow = -Annex60.Utilities.Math.Functions.smoothMin(
      x1=QUnl_flow,
      x2=Q_flow_maxHeat,
      deltaX=Q_flow_small);
  elseif restrictCool then
    port.Q_flow = -Annex60.Utilities.Math.Functions.smoothMax(
      x1=QUnl_flow,
      x2=Q_flow_maxCool,
      deltaX=Q_flow_small);
  else
    port.Q_flow = QUnl_flow;
  end if;

annotation (
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                      graphics={
      Line(
        points={{-20,-20},{40,-20}},
        color={191,0,0},
        thickness=0.5),
      Line(
        points={{-20,20},{40,20}},
        color={191,0,0},
        thickness=0.5),
      Line(
        points={{-40,0},{-20,-20}},
        color={191,0,0},
        thickness=0.5),
      Line(
        points={{-40,0},{-20,20}},
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
        extent={{-146,140},{154,100}},
        textString="%name",
        lineColor={0,0,255}),
      Line(
        points={{-60,0},{-40,0}},
        color={191,0,0},
        thickness=0.5),
        Text(
          extent={{-98,90},{-52,70}},
          lineColor={0,0,127},
          textString="T"),
        Text(
          extent={{-98,52},{-52,32}},
          lineColor={0,0,127},
          textString="h"),
        Text(
          extent={{-100,10},{-54,-10}},
          lineColor={0,0,127},
          textString="Xi"),
        Text(
          extent={{-98,-30},{-52,-50}},
          lineColor={0,0,127},
          textString="m_flow"),
        Text(
          extent={{-98,-68},{-52,-88}},
          lineColor={0,0,127},
          textString="p")}),
  Documentation(info="<HTML>
  <p>
  This model allows a specified amount of heat flow rate to be \"injected\"
  into a thermal system at a given port. The amount of heat
  is given by the input signal T_set into the model. The heat flows into the
  component to which the component PrescribedHeatFlow is connected,
  if the input signal is positive.
  </p>
  </html>"),
         Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),
                       graphics={
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
