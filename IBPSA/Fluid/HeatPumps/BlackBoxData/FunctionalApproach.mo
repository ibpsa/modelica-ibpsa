within IBPSA.Fluid.HeatPumps.BlackBoxData;
model FunctionalApproach
  "Calculating heat pump data based on a avaiable functional relationships"
  extends IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialBlackBox;

  replaceable function PolyData =
      IBPSA.Fluid.HeatPumps.BlackBoxData.Functions.BaseClasses.PartialBaseFct
                                                                           "Function to calculate peformance Data" annotation(choicesAllMatching=true);
  Modelica.Blocks.Sources.RealExpression internal_Pel(final y=Char[1]*
        scalingFactor)                                                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,50})));
  Modelica.Blocks.Sources.RealExpression internal_QCon(final y=Char[2]*
        scalingFactor)                                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,50})));
  Modelica.Blocks.Logical.Switch       switchPel
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-10})));
  Modelica.Blocks.Logical.Switch       switchQCon
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-10})));
  Modelica.Blocks.Sources.Constant constZero(final k=0)
                                             annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,30})));
  Modelica.Blocks.Routing.RealPassThrough passThroughYSet;
  Modelica.Blocks.Routing.RealPassThrough passThroughTConOut;
  Modelica.Blocks.Routing.RealPassThrough passThroughTEvaIn;
  Modelica.Blocks.Routing.RealPassThrough passThroughMFlowEva;
  Modelica.Blocks.Routing.RealPassThrough passThroughMFlowCon;
protected
  Real Char[2];
equation
  Char =PolyData(
    passThroughYSet.y,
    passThroughTConOut.y,
    passThroughTEvaIn.y,
    passThroughMFlowCon.y,
    passThroughMFlowEva.y);
  connect(switchQCon.u3, constZero.y) annotation (Line(points={{-58,2},{-58,8},{
          -10,8},{-10,19}},                           color={0,0,127}));
  connect(switchQCon.y, feedbackHeatFlowEvaporator.u1) annotation (Line(points={{-50,-21},
          {-50,-26},{-84,-26},{-84,-10},{-78,-10}},     color={0,0,127}));
  connect(switchQCon.u1, internal_QCon.y) annotation (Line(points={{-42,2},{-42,
          50},{-59,50}},        color={0,0,127}));
  connect(constZero.y, switchPel.u3) annotation (Line(points={{-10,19},{-10,8},{
          42,8},{42,2}},color={0,0,127}));
  connect(switchPel.y, calcRedQCon.u2) annotation (Line(points={{50,-21},{50,-50},
          {64,-50},{64,-58}},                color={0,0,127}));
  connect(switchPel.y, Pel) annotation (Line(points={{50,-21},{50,-44},{0,-44},{
          0,-110}},  color={0,0,127}));
  connect(switchPel.u1, internal_Pel.y)
    annotation (Line(points={{58,2},{58,0},{68,0},{68,50},{61,50}},
                                                             color={0,0,127}));
  connect(switchPel.y, feedbackHeatFlowEvaporator.u2) annotation (Line(points={{50,-21},
          {50,-32},{-70,-32},{-70,-18}},                        color={0,0,127}));
  connect(switchPel.u2, sigBus.onOffMea) annotation (Line(points={{50,2},{50,12},
          {20,12},{20,96},{1,96},{1,104}},              color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchQCon.u2, sigBus.onOffMea) annotation (Line(points={{-50,2},{-50,
          96},{1,96},{1,104}},                           color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(passThroughYSet.u, sigBus.ySet);
  connect(passThroughTConOut.u, sigBus.TConOutMea);
  connect(passThroughTEvaIn.u, sigBus.TEvaInMea);
  connect(passThroughMFlowEva.u, sigBus.m_flowEvaMea);
  connect(passThroughMFlowCon.u, sigBus.m_flowConMea);
  annotation (Icon(graphics={
        Text(
          lineColor={0,0,255},
          extent={{-136,109},{164,149}},
          textString="%name"),
        Ellipse(
          lineColor = {108,88,49},
          fillColor = {255,215,136},
          fillPattern = FillPattern.Solid,
          extent={{-86,-96},{88,64}}),
        Text(
          lineColor={108,88,49},
          extent={{-90,-108},{90,72}},
          textString="f")}), Documentation(revisions="<html><ul>
  <li>
    <i>May 21, 2021ф</i> by Fabian Wüllhorst:<br/>
    Make use of BaseClasses (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/1092\">#1092</a>)
  </li>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This model is used to calculate the three values based on a
  functional approach. The user can choose between several functions or
  use their own.
</p>
<p>
  As the <a href=
  \"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.Functions.Characteristics.PartialBaseFct\">
  base function</a> only returns the electrical power and the condenser
  heat flow, the evaporator heat flow is calculated with the following
  energy balance:
</p>
<p>
  <i>QEva = QCon - P_el</i>
</p>
</html>"));
end FunctionalApproach;
