within IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses;
partial model PartialBlackBox
  "Partial black box model of vapour compression cycles used for heat pump applications"
  replaceable Frosting.BaseClasses.PartialIceFac iceFacCalc
    constrainedby Frosting.BaseClasses.PartialIceFac
    "Replaceable model to calculate the icing factor"
    annotation (choicesAllMatching=true, Dialog(group="Frosting supression", enable=calc_iceFac), Placement(transformation(extent={{-100,
            -52},{-80,-32}})));

  Modelica.Blocks.Interfaces.RealOutput Pel(final unit="W", final displayUnit="kW")
    "Electrical Power consumed by HP"                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W", final
      displayUnit="kW") "Heat flow rate through Condenser" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,-110})));
  IBPSA.Fluid.Interfaces.VapourCompressionMachineControlBus sigBus
    "Bus-connector used in a heat pump" annotation (Placement(
        transformation(
        extent={{-15,-14},{15,14}},
        rotation=0,
        origin={1,104})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final unit="W", final
      displayUnit="kW") "Heat flow rate through Evaporator" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-110})));
  Modelica.Blocks.Math.Add calcRedQCon
    "Based on redcued heat flow to the evaporator, the heat flow to the condenser is also reduced"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-70})));
  Modelica.Blocks.Math.Product proRedQEva
    "Based on the icing factor, the heat flow to the evaporator is reduced"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-50,-70})));

protected
  parameter Real scalingFactor=1 "Scaling factor of heat pump";
  Modelica.Blocks.Math.Feedback feedbackHeatFlowEvaporator
    "Calculates evaporator heat flow with total energy balance"                 annotation(Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=0,
        origin={-70,-10})));
equation
  connect(proRedQEva.y, QEva_flow) annotation (Line(points={{-50,-81},{-50,-88},
          {0,-88},{0,-52},{88,-52},{88,-96},{80,-96},{80,-110}},
                               color={0,0,127}));
  connect(proRedQEva.y, calcRedQCon.u1) annotation (Line(points={{-50,-81},{-50,
          -88},{0,-88},{0,-52},{76,-52},{76,-58}},                color={0,0,
          127}));
  connect(calcRedQCon.y, QCon_flow) annotation (Line(points={{70,-81},{70,-96},{
          -80,-96},{-80,-110}},                      color={0,0,127}));
  connect(proRedQEva.u2, feedbackHeatFlowEvaporator.y) annotation (Line(
        points={{-44,-58},{-44,-10},{-61,-10}},         color={0,0,127}));
  connect(iceFacCalc.iceFac, proRedQEva.u1) annotation (Line(points={{-79,-42},{
          -56,-42},{-56,-58}},                      color={0,0,127}));
  connect(iceFacCalc.sigBus, sigBus) annotation (Line(
      points={{-100.1,-42},{-102,-42},{-102,104},{1,104}},
      color={255,204,51},
      thickness=0.5));
  connect(iceFacCalc.iceFac, sigBus.iceFacMea) annotation (Line(points={{-79,-42},
          {-72,-42},{-72,-28},{-102,-28},{-102,104},{1,104}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),   Text(
          extent={{-57.5,-35},{57.5,35}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash,
          textString="%name
",        origin={-3.5,-15},
          rotation=180)}),Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Partial model for calculation of <span style=
  \"font-family: Courier New;\">P_el</span>, <span style=
  \"font-family: Courier New;\">QCon</span> and <span style=
  \"font-family: Courier New;\">QEva</span> based on the values in the
  <span style=\"font-family: Courier New;\">sigBusHP</span>.
</p>
</html>"));
end PartialBlackBox;
