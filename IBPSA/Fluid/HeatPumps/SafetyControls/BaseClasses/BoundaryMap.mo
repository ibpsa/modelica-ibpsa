within IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses;
model BoundaryMap
  "Model which returns false if the input parameters 
  are out of the given charasteristic map"
  extends IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses.BoundaryMapIcon(
      final icoMin=-70, final icoMax=70);
  parameter Real dT
    "Delta value used to avoid state events when used as a safety control"
  annotation (Dialog(tab="Safety Control", group="Operational Envelope"));
  Modelica.Blocks.Interfaces.BooleanOutput noErr
    "If an error occurs, this will be false"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TEva(unit="K", displayUnit="degC")
    "Evaporator side temperature"
    annotation (Placement(transformation(extent={{-130,-54},{-102,-26}})));

  Modelica.Blocks.Tables.CombiTable1Ds uppTab(
    final table=tabUpp_internal,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    final tableOnFile=false) "Table with envelope data"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.MathBoolean.Nor nor(nu=3)
    "If no condition violates the envelope, this is true"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Logical.Hysteresis hysLef(
    final uLow=-0.05,
    final uHigh=0,
    pre_y_start=false) "Hysteresis for left side of envelope"
  annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Logical.Hysteresis hysRig(
    final uLow=-0.05,
    final uHigh=0,
    pre_y_start=false) "Hysteresis for right side of envelope"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Sources.Constant conTEvaMin(k=TEvaMin)
    "Constant evaporator minimal temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.Constant conTEvaMax(k=TEvaMax)
    "Constant evaporator maximal temperature"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  Modelica.Blocks.Math.Add addMax(final k1=+1, final k2=-1)
    "TEva minus TEvaMax"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Math.Add addMin(final k1=-1, final k2=+1)
    "TEvaMin minus TEva"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Math.UnitConversions.To_degC toDegCTEva
    "Boundary map takes degC as input" annotation (extent=[-88,38; -76,50],
      Placement(transformation(extent={{-94,0},{-74,20}})));
    Modelica.Blocks.Math.UnitConversions.To_degC toDegCTCon
    "Boundary map takes degC as input" annotation (extent=[-88,38; -76,50],
      Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Interfaces.RealInput TCon(unit="K", displayUnit="degC")
    "Condenser side temperature"
    annotation (Placement(transformation(extent={{-128,26},{-100,54}})));
  Modelica.Blocks.Math.Add subTConMax(final k1=+1, final k2=-1)
    "Subtract TConMax from current value"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Logical.Hysteresis hysUpp(
    final uLow=-dT,
    final uHigh=0,
    pre_y_start=false) "Hysteresis for upper temperature limit"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
equation
  connect(nor.y, noErr)
    annotation (Line(points={{81.5,0},{110,0}}, color={255,0,255}));
  connect(hysLef.y, nor.u[1]) annotation (Line(points={{41,-30},{50,-30},{50,-2.33333},
          {60,-2.33333}}, color={255,0,255}));
  connect(hysRig.y, nor.u[2]) annotation (Line(points={{41,-70},{50,-70},{50,-5.55112e-16},
          {60,-5.55112e-16}}, color={255,0,255}));
  connect(addMax.u2, conTEvaMax.y) annotation (Line(points={{-22,-76},{-32,-76},
          {-32,-90},{-39,-90}}, color={0,0,127}));
  connect(addMin.u2, conTEvaMin.y) annotation (Line(points={{-22,-36},{-32,-36},
          {-32,-50},{-39,-50}}, color={0,0,127}));
  connect(addMax.y, hysRig.u)
    annotation (Line(points={{1,-70},{18,-70}}, color={0,0,127}));
  connect(addMin.y, hysLef.u)
    annotation (Line(points={{1,-30},{18,-30}}, color={0,0,127}));
  connect(toDegCTCon.u, TCon) annotation (Line(points={{-62,90},{-96,90},{-96,40},
          {-114,40}},  color={0,0,127}));
  connect(uppTab.u, toDegCTEva.y) annotation (Line(points={{-62,50},{-66,50},{-66,
          10},{-73,10}}, color={0,0,127}));
  connect(TEva, toDegCTEva.u)
    annotation (Line(points={{-116,-40},{-98,-40},{-98,10},{-96,10}},
                                                  color={0,0,127}));
  connect(toDegCTEva.y, addMin.u1) annotation (Line(points={{-73,10},{-66,10},{-66,
          -24},{-22,-24}}, color={0,0,127}));
  connect(toDegCTEva.y, addMax.u1) annotation (Line(points={{-73,10},{-66,10},{-66,
          -64},{-22,-64}}, color={0,0,127}));
  connect(hysUpp.u, subTConMax.y)
    annotation (Line(points={{18,10},{6,10},{6,70},{1,70}}, color={0,0,127}));
  connect(hysUpp.y, nor.u[3]) annotation (Line(points={{41,10},{50,10},{50,2.33333},
          {60,2.33333}}, color={255,0,255}));
  connect(subTConMax.u1, toDegCTCon.y) annotation (Line(points={{-22,76},{-32,76},
          {-32,90},{-39,90}}, color={0,0,127}));
  connect(uppTab.y[1], subTConMax.u2) annotation (Line(points={{-39,50},{-30,50},
          {-30,64},{-22,64}}, color={0,0,127}));
annotation (Diagram(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<p>Given an input of TCon and TEva, the model returns true if the given point is outside of the given operational envelope. </p><p>The maximal and minmal TCon depend on TEva and are defined by the upper and lower boundaries in form of 1Ds-Tables. </p><p>The maximal and minimal TEva values are obtained trough the table and are constant. </p>
<p>For the boundaries of the TCon input value, a dynamic hysteresis is used to ensure a used device will stay off a certain time after shutdown.</p><p>This is similar to the hysteresis in a pressure-based safety control, which prevents operation outside this envelope in real devices.</p>
</html>",
        revisions="<html>
<ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on IPBSA guidelines <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>November 26, 2018;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue 
    <a href=\"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>) 
  </li>
</ul>
</html>"));
end BoundaryMap;
