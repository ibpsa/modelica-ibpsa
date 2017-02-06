within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Validation.BaseClasses;
partial model partial_trtValidation
  extends Examples.borefield8x1(
    pum(
      addPowerToMedium=false),
    hea(
      Q_flow_nominal=bfData.gen.q_ste*bfData.gen.hBor,
      dp_nominal=0),
    load(startTime=0),
    T_start=bfData.gen.T_start,
    borFie(dp_nominal=1000));

  parameter Boolean verifyWithData = false;

  Modelica.Blocks.Sources.RealExpression realExpression
    annotation (Placement(transformation(extent={{-6,50},{40,70}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin TMea_in
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Modelica.Blocks.Sources.RealExpression realExpression1
    annotation (Placement(transformation(extent={{-6,28},{40,48}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin TMea_out
    annotation (Placement(transformation(extent={{50,28},{70,48}})));

  Real Rb_sim = ((senTem_in.T + senTem_out.T)/2 - borFie.TWall)/max(hea.Q_flow / bfData.gen.hBor,1);
  Modelica.Blocks.Sources.CombiTimeTable TRet_measured(
    tableOnFile=true,
    tableName="data",
    columns={2},
    offset={0},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) if verifyWithData
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));

  Modelica.Blocks.Sources.CombiTimeTable TIn_measured(
    tableOnFile=true,
    tableName="data",
    columns={2},
    offset={0},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) if verifyWithData
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(realExpression.y, TMea_in.Kelvin)
    annotation (Line(points={{42.3,60},{48,60},{48,60}}, color={0,0,127}));
  connect(realExpression1.y, TMea_out.Kelvin)
    annotation (Line(points={{42.3,38},{45.15,38},{48,38}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end partial_trtValidation;
