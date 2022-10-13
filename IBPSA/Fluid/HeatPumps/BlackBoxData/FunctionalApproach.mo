within IBPSA.Fluid.HeatPumps.BlackBoxData;
model FunctionalApproach
  "Calculating heat pump data based on a avaiable functional relationships"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
      datSou="FunctionalApproach", QUseBlaBox_flow_nominal=Cha_nominal[2]);

  replaceable function ChaFun =
      IBPSA.Fluid.HeatPumps.BlackBoxData.Functions.BaseClasses.PartialBaseFct
    "Function to calculate peformance characteristics" annotation(choicesAllMatching=true);
  Modelica.Blocks.Sources.RealExpression PelInternal(final y=Cha[1]*scaFac)
    annotation (Placement(transformation(extent={{40,40},{60,60}},
    rotation=0)));
  Modelica.Blocks.Sources.RealExpression QConInternal_flow(final y=Cha[2]*
        scaFac)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}},
    rotation=0)));
  Modelica.Blocks.Logical.Switch switchPel
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-10})));
  Modelica.Blocks.Logical.Switch switchQCon
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
  Real Cha[2] "Performance characeristics";
  parameter Real Cha_nominal[2]=ChaFun(
      y_nominal,
      TCon_nominal,
      TEva_nominal,
      mCon_flow_nominal,
      mEva_flow_nominal)
    "Characeteristics in nominal point used for scaling";
equation
  Cha = ChaFun(
    passThroughYSet.y,
    passThroughTConOut.y,
    passThroughTEvaIn.y,
    passThroughMFlowCon.y,
    passThroughMFlowEva.y);
  connect(switchQCon.u3, constZero.y)
    annotation (Line(points={{-58,2},{-58,8},{-10,8},{-10,19}},
                     color={0,0,127}));
  connect(switchQCon.y, feeHeaFloEva.u1) annotation (Line(points={{-50,-21},{-50,
          -26},{-84,-26},{-84,-10},{-78,-10}}, color={0,0,127}));
  connect(switchQCon.u1, QConInternal_flow.y)
    annotation (Line(points={{-42,2},{-42,50},{-59,50}},
                                                      color={0,0,127}));
  connect(constZero.y, switchPel.u3)
    annotation (Line(points={{-10,19},{-10,8},{
          42,8},{42,2}},color={0,0,127}));
  connect(switchPel.y, redQCon.u2) annotation (Line(points={{50,-21},{50,-50},{64,
          -50},{64,-58}}, color={0,0,127}));
  connect(switchPel.y, PEle) annotation (Line(points={{50,-21},{50,-44},{0,-44},
          {0,-110}}, color={0,0,127}));
  connect(switchPel.u1, PelInternal.y) annotation (Line(points={{58,2},{58,0},{
          68,0},{68,50},{61,50}},
                             color={0,0,127}));
  connect(switchPel.y, feeHeaFloEva.u2) annotation (Line(points={{50,-21},{50,-32},
          {-70,-32},{-70,-18}}, color={0,0,127}));
  connect(switchPel.u2, sigBus.onOffMea)
    annotation (Line(points={{50,2},{50,12},{20,12},{20,96},{1,96},{1,104}},
                  color={255,0,255}),
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
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Ellipse(
          lineColor = {108,88,49},
          fillColor = {255,215,136},
          fillPattern = FillPattern.Solid,
          extent={{-86,-96},{88,64}}),
        Text(
          extent={{-157,59},{152,-74}},
          textColor={0,140,72},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="f")}), Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on IPBSA guidelines <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 21, 2021</i> by Fabian Wuellhorst:<br/>
    Make use of BaseClasses (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/1092\">AixLib #1092</a>)
  </li>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>This model is used to calculate the three values based on a functional approach. </p>
<p>The user can choose between several functions or implement their own. </p>
<p>As the <a href=\"modelica://IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions.PartialBaseFct\">
IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions.PartialBaseFct </a>
only returns the electrical power and the condenser heat flow, 
the evaporator heat flow is calculated with the following energy balance: </p>
<p><span style=\"font-family: Courier New;\">QEva = QCon - P_el</span> </p>
</html>"));
end FunctionalApproach;
