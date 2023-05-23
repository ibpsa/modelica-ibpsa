within IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses;
model BoundaryMap
  "Model which returns false if the input parameters 
  are out of the given charasteristic map"
  parameter Real tab[:,2]
    "Table for boundary with second column as useful temperature side";
  parameter Real dT
    "Delta value used to avoid state events when used as a safety control"
  annotation (Dialog(tab="Safety Control", group="Operational Envelope"));
  parameter Boolean isUppBou "=true if it is an upper boundary, false for lower";
  Modelica.Blocks.Interfaces.BooleanOutput noErr
    "If an error occurs, this will be false"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TNotUse(unit="K", displayUnit="degC")
    "Not useful temperature side"
    annotation (Placement(transformation(extent={{-130,-54},{-102,-26}})));

  Modelica.Blocks.Tables.CombiTable1Ds tabBou(
    final table=tab,
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
  Modelica.Blocks.Sources.Constant conTNotUseMin(k=TNotUseMin)
    "Constant minimal temperature of not useful temperature side"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.Constant conTNotUseMax(k=TNotUseMax)
    "Constant maximal temperature of not useful temperature side"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  Modelica.Blocks.Math.Add subMax(final k1=+1, final k2=-1)
    "TNotUse minus TNotUseMax"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Math.Add sub(final k1=-1, final k2=+1)
    "TNotUseMin minus TNotUse"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Math.UnitConversions.To_degC toDegCelTNotUse
    "Boundary map takes degC as input" annotation (extent=[-88,38; -76,50],
      Placement(transformation(extent={{-90,0},{-70,20}})));
    Modelica.Blocks.Math.UnitConversions.To_degC toDegCelTUse
    "Boundary map takes degC as input" annotation (extent=[-88,38; -76,50],
      Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Interfaces.RealInput TUse(unit="K", displayUnit="degC")
    "Useful temperature side "
    annotation (Placement(transformation(extent={{-128,26},{-100,54}})));
  Modelica.Blocks.Math.Add subBou(final k1=if isUppBou then 1 else -1, final k2=
       if isUppBou then -1 else 1)
    "Subtract boundary from current value depending on lower or upper boundary"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Logical.Hysteresis hysBou(
    final uLow=-dT,
    final uHigh=0,
    pre_y_start=false) "Hysteresis for temperature limit"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

protected
  parameter Real icoMin=-70
    "Used to set the frame where the icon should appear";
  parameter Real icoMax=70 "Used to set the frame where the icon should appear";
  final parameter Real TNotUseMax(unit="degC") = tab[end, 1]
    "Maximal value of evaporator side";
  final parameter Real TNotUseMin(unit="degC") = tab[1, 1]
    "Minimal temperature at evaporator side";
  final parameter Real TUseMax(unit="degC") = max(tab[:, 2])
    "Maximal temperature of condenser side";
  final parameter Real TUseMin(unit="degC") = 0 "Minimal value of condenser side";
  final parameter Real points[size(scaTNotUse, 1),2]=
    transpose({scaTEvaToPoi,scaTUseToPoi})
    annotation (Hide=false);
  final parameter Real scaTNotUse[:](each unit="degC") = tab[:, 1]
    "Helper array with only not useful temperature side values";
  final parameter Real scaTUse[:](each unit="degC") = tab[:, 2]
    "Helper array with only useful temperature side values";
  final parameter Real scaTEvaToPoi[size(scaTNotUse, 1)](
    each min=-100,
    each max=100) = (scaTNotUse - fill(TNotUseMin, size(scaTNotUse, 1)))*(
    icoMax - icoMin)/(TNotUseMax - TNotUseMin) + fill(icoMin, size(scaTNotUse, 1))
    "Scale not useful side to icon size";
  final parameter Real scaTUseToPoi[size(scaTNotUse, 1)](
    each min=-100,
    each max=100) = (scaTUse - fill(TUseMin, size(scaTUse, 1)))*(icoMax -
    icoMin)/(TUseMax - TUseMin) + fill(icoMin, size(scaTUse, 1))
    "Scale useful side to icon size";

equation
  connect(nor.y, noErr)
    annotation (Line(points={{81.5,0},{110,0}}, color={255,0,255}));
  connect(hysLef.y, nor.u[1]) annotation (Line(points={{41,-30},{50,-30},{50,-2.33333},
          {60,-2.33333}}, color={255,0,255}));
  connect(hysRig.y, nor.u[2]) annotation (Line(points={{41,-70},{50,-70},{50,-5.55112e-16},
          {60,-5.55112e-16}}, color={255,0,255}));
  connect(subMax.u2, conTNotUseMax.y) annotation (Line(points={{-22,-76},{-32,-76},
          {-32,-90},{-39,-90}}, color={0,0,127}));
  connect(sub.u2, conTNotUseMin.y) annotation (Line(points={{-22,-36},{-32,-36},
          {-32,-50},{-39,-50}}, color={0,0,127}));
  connect(subMax.y, hysRig.u)
    annotation (Line(points={{1,-70},{18,-70}}, color={0,0,127}));
  connect(sub.y, hysLef.u)
    annotation (Line(points={{1,-30},{18,-30}}, color={0,0,127}));
  connect(toDegCelTUse.u,TUse)  annotation (Line(points={{-62,90},{-96,90},{-96,
          40},{-114,40}}, color={0,0,127}));
  connect(tabBou.u, toDegCelTNotUse.y) annotation (Line(points={{-62,50},{-66,
          50},{-66,10},{-69,10}}, color={0,0,127}));
  connect(TNotUse, toDegCelTNotUse.u) annotation (Line(points={{-116,-40},{-98,
          -40},{-98,10},{-92,10}}, color={0,0,127}));
  connect(toDegCelTNotUse.y, sub.u1) annotation (Line(points={{-69,10},{-66,10},
          {-66,-24},{-22,-24}}, color={0,0,127}));
  connect(toDegCelTNotUse.y, subMax.u1) annotation (Line(points={{-69,10},{-66,
          10},{-66,-64},{-22,-64}}, color={0,0,127}));
  connect(hysBou.u, subBou.y)
    annotation (Line(points={{18,10},{6,10},{6,70},{1,70}}, color={0,0,127}));
  connect(hysBou.y, nor.u[3]) annotation (Line(points={{41,10},{50,10},{50,2.33333},
          {60,2.33333}}, color={255,0,255}));
  connect(subBou.u1, toDegCelTUse.y) annotation (Line(points={{-22,76},{-32,76},
          {-32,90},{-39,90}}, color={0,0,127}));
  connect(tabBou.y[1], subBou.u2) annotation (Line(points={{-39,50},{-30,50},{-30,
          64},{-22,64}}, color={0,0,127}));


  annotation (Icon(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}), graphics={
                                    Line(points=DynamicSelect(
      {{-66,-66},{-66,50},{-44,66}, {68,66},{68,-66},{-66,-66}},points),
      color={238,46,47},
      thickness=0.5),
  Polygon(
    points={{icoMin-20,icoMax},{icoMin-20,icoMax},
            {icoMin-10,icoMax},{icoMin-15,icoMax+20}},
    lineColor={95,95,95},
    fillColor={95,95,95},
    fillPattern=FillPattern.Solid),
  Polygon(
    points={{icoMax+20,icoMin-10},{icoMax,icoMin-4},
            {icoMax,icoMin-16},{icoMax+20,icoMin-10}},
    lineColor={95,95,95},
    fillColor={95,95,95},
    fillPattern=FillPattern.Solid),
  Line(points={{icoMin-15,icoMax},
              {icoMin-15,icoMin-15}}, color={95,95,95}),
  Line(points={{icoMin-20,icoMin-10},
              {icoMax+10,icoMin-10}}, color={95,95,95})}),
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
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
