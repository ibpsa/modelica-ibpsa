within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Extras;
model GroundCoupledHeatPump "Heat pump connected to ta borefield"

  parameter Integer lenSim "Simulation length ([s]). By default = 100 days";

  replaceable parameter Data.Records.BorefieldData bfData
    constrainedby Data.Records.BorefieldData
    annotation (Placement(transformation(extent={{-86,-44},{-66,-24}})));

  Extras.MultipleBoreHoles_signals multipleBoreHoles_IDEAS_opt(bfData=bfData,
      lenSim=lenSim)
    annotation (Placement(transformation(extent={{-24,-60},{36,0}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_bui(unit="W")
    "Heat flow to the building (positive if building is heated, negative if building is cooled down)"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,106})));
  Modelica.Blocks.Interfaces.RealOutput COP annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={-80,-104}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={-86,-104})));
  Modelica.Blocks.Interfaces.RealOutput T_bf_in(unit="K", displayUnit="degC") annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={-28,-104}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={-30,-104})));
  Modelica.Blocks.Interfaces.RealOutput T_bf_out(unit="K", displayUnit="degC") annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={32,-104})));
  Modelica.Blocks.Interfaces.RealInput T_sup_bui(unit="K", displayUnit="degC")
    "Supply temperature to the building" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,106})));
  Modelica.Blocks.Sources.RealExpression Q_flow_bf(y=Q_flow_bf_val)
    "Heat flow injected (if positive) or extracted (if negative) from the borefield"
    annotation (Placement(transformation(extent={{-38,-4},{-18,16}})));

  Modelica.SIunits.HeatFlowRate Q_flow_bf_val
    "Heat flow injected (if positive) or extracted (if negative) from the borefield";

  Modelica.Blocks.Interfaces.RealOutput EER(unit="") annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={-58,-104})));
  Modelica.Blocks.Interfaces.RealOutput PEl(unit="W")
    "Electrical power of the heat pump"                                                    annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={80,-104})));
equation
  // Electrical power
  COP = 5;
  EER = 10;
  if Q_flow_bui > Modelica.Constants.eps then
    // Heating mode
    PEl = Q_flow_bui / COP;
  elseif Q_flow_bui < - Modelica.Constants.eps then
    // Cooling mode
    PEl = -Q_flow_bui / EER;
  else
    // Off
    PEl = 0;
  end if;

  // Extracted/Injected heat to the borefield
  Q_flow_bf_val = Q_flow_bui - PEl;

  connect(T_bf_in, T_bf_in) annotation (Line(
      points={{-28,-104},{-28,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multipleBoreHoles_IDEAS_opt.T_sou, T_bf_out) annotation (Line(
      points={{27,-30},{32,-30},{32,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multipleBoreHoles_IDEAS_opt.T_sin, T_bf_in) annotation (Line(
      points={{-15,-30},{-28,-30},{-28,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow_bf.y, multipleBoreHoles_IDEAS_opt.Q_flow) annotation (Line(
      points={{-17,6},{6,6},{6,-11.5714}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(EER, EER) annotation (Line(
      points={{-58,-104},{-58,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-80,6},{80,-82}},
          lineThickness=0.5,
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(extent={{-40,80},{40,20}}, lineColor={0,0,0}),
        Text(
          extent={{-40,78},{40,18}},
          lineColor={0,0,0},
          textString="HP"),
        Line(
          points={{-60,0},{-60,-80},{-40,-80},{-40,-78},{-40,0},{-10,0},{-10,-80},
              {10,-80},{10,0},{40,0},{40,-80},{60,-80},{60,0},{68,0},{68,26},{40,
              26}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-60,0},{-70,0},{-70,24},{-40,24}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5)}));
end GroundCoupledHeatPump;
