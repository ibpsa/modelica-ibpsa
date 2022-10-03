within IBPSA.Fluid.HeatPumps.BaseClasses;
partial model PartialBlackBoxVapourCompressionCycle
  "Blackbox model of refrigerant cycle of a vapour compression machine"

  parameter Boolean use_rev=true
    "True if the vapour compression machine is reversible";

  IBPSA.Fluid.Interfaces.VapourCompressionMachineControlBus sigBus annotation (
      Placement(transformation(extent={{-18,86},{18,118}}), iconTransformation(
          extent={{-16,88},{18,118}})));
  Modelica.Blocks.Sources.Constant constZero(final k=0) if not use_rev
    "If no heating is used, the switches may still be connected"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    final unit="W", final displayUnit="kW")
    "Heat Flow to condenser"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(
    final unit="W", final displayUnit="kW")
    "Heat flow from evaporator"
    annotation (Placement(transformation(extent={{-100,-10},{-120,10}})));
  Modelica.Blocks.Logical.Switch switchQEva(
    u1(final unit="W", final displayUnit="kW"),
    u3(final unit="W", final displayUnit="kW"),
    y(final unit="W", final displayUnit="kW"))
    "If mode is false, Condenser becomes Evaporator and vice versa"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Modelica.Blocks.Logical.Switch switchQCon(
    y(final unit="W", final displayUnit="kW"),
    u1(final unit="W", final displayUnit="kW"),
    u3(final unit="W", final displayUnit="kW"))
    "If mode is false, Condenser becomes Evaporator and vice versa"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Interfaces.RealOutput Pel(
    final unit="W", final displayUnit="kW")
    "Electrical power consumed by compressor" annotation (Placement(
        transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=-90,
        origin={0.5,-110.5})));

  Modelica.Blocks.Logical.Switch switchPel(
    u1(final unit="W", final displayUnit="kW"),
    u3(final unit="W", final displayUnit="kW"),
    y(final unit="W", final displayUnit="kW"))
    "Whether to use cooling or heating power consumption" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-70})));
protected
  Modelica.Blocks.Routing.BooleanPassThrough pasTrModSet
    "Pass through to enable assertion for non-reversible device";
equation
  assert(
    use_rev or (use_rev == false and pasTrModSet.y == true),
    "Can't turn to reversible operation mode on 
    irreversible vapour compression machine",
    level=AssertionLevel.error);

  connect(switchQEva.y, QEva_flow)
    annotation (Line(points={{-81,0},{-110,0}}, color={0,0,127}));
  connect(switchPel.y, Pel) annotation (Line(points={{-1.9984e-15,-81},{
          -1.9984e-15,-95.75},{0.5,-95.75},{0.5,-110.5}}, color={0,0,127}));
  connect(sigBus.modeSet,  switchPel.u2) annotation (Line(
      points={{0,102},{0,22},{2.22045e-15,22},{2.22045e-15,-58}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(switchQCon.y, QCon_flow)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(sigBus.modeSet, switchQEva.u2) annotation (Line(
      points={{0,102},{0,0},{-58,0}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.modeSet, switchQCon.u2) annotation (Line(
      points={{0,102},{0,0},{58,0}},
      color={255,204,51},
      thickness=0.5));
  connect(pasTrModSet.u, sigBus.modeSet);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={238,46,47},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-24,88},{22,44}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(
          points={{-16,82},{20,74}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-18,52},{20,58}},
          color={28,108,200},
          thickness=0.5),
        Rectangle(
          extent={{-98,40},{-60,-28}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(
          points={{-20,-60},{-20,-70},{-20,-80},{20,-60},{20,-80},{-20,-60}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-122,34},{-66,34},{-82,10},{-66,-22},{-120,-22}},
          color={28,108,200},
          thickness=0.5),
        Rectangle(
          extent={{60,40},{98,-28}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(
          points={{120,34},{64,34},{80,10},{64,-22},{118,-22}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-80,40},{-80,68},{-24,68}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{22,66},{80,66},{80,40}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{78,-28},{78,-70}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{78,-70},{62,-70},{20,-70}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-80,-26},{-80,-68},{-20,-68}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 22, 2019</i> by Julian Matthes:<br/>
    Rebuild due to the introducion of the vapour compression machine
    partial model (see issue <a href=
    \"https://github.com/RWTH-EBC/IBPSA/issues/715\">#715</a>)
  </li>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/IBPSA/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This black-box model represents the refrigerant cycle of a vapour
  compression machine. Used in IBPSA.Fluid.HeatPumps.HeatPump and
  IBPSA.Fluid.Chiller.Chiller, this model serves the simulation of a
  reversible vapour compression machine. Thus, data both of chillers
  and heat pumps can be used to calculate the three relevant values
  <code>P_el</code>, <code>QCon</code> and <code>QEva</code>. 
  The <code>mode</code> of the machine is used to
  switch between the performance data of the chiller and the heat pump.
</p>
<p>
  The user can choose between different types of performance data or
  implement a new black-box model by extending from the <a href=
  \"modelica://IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialBlackBox\">
  IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialBlackBox</a> model.
</p>
</html>"));
end PartialBlackBoxVapourCompressionCycle;
