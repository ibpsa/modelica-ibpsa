within IBPSA.Fluid.HeatPumps.SafetyControls.Examples.BaseClasses;
partial model PartialSafetyControlExample

  Interfaces.VapourCompressionMachineControlBus sigBusHP
    "Bus-connector for the heat pump"
    annotation (Placement(transformation(extent={{-70,-72},{-30,-32}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(
    pre_y_start = false, uHigh = 0.01, uLow = 0.01 / 2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-50})));
equation
  connect(hysteresis.y, sigBusHP.onOffMea) annotation (Line(points={{-1,-50},{-26,
          -50},{-26,-52},{-50,-52}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialSafetyControlExample;
