within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.Aggregation.Validation;
model LoadAggregation_WithHistory
  "Load aggregation model with a constant prescribed load"
  extends Modelica.Icons.Example;

  GroundTemperatureResponse loaAgg(
    ks=1,
    as=1e-6,
    lenAggSte=3600,
    p_max=5,
    H=100,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://BEE/Resources/gfunct_data/Single_borehole_depth_100.txt"),
    prevQfromFile=true,
    prevQFilNam=Modelica.Utilities.Files.loadResource(
        "modelica://BEE/Resources/Fluid/Geothermal/BoreholeHeatExchangers/BaseClasses/Aggregation/Validation/Data_for_Load_History.txt"))
    "Load Aggregation in borehole"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=273.15)
    "Ground temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    "Prescribed heat injected into borehole"
    annotation (Placement(transformation(extent={{40,0},{20,20}})));
  Modelica.Blocks.Sources.CombiTimeTable timTabQ(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://BEE/Resources/Fluid/Geothermal/BoreholeHeatExchangers/BaseClasses/Aggregation/Validation/LoadAggregation_20y_validation.txt"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={2}) "Table for heat injected, using constant segments"
    annotation (Placement(transformation(extent={{80,0},{60,20}})));

  Modelica.Blocks.Math.Add add(k2=-1)
    "Difference between FFT method and load aggregation method"
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-70})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    "Borehole wall temperature"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Sources.CombiTimeTable timTabT(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://BEE/Resources/Fluid/Geothermal/BoreholeHeatExchangers/BaseClasses/Aggregation/Validation/LoadAggregation_20y_validation.txt"),
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Table for resulting wall temperature using FFT and linearly interpolated"
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));

equation
  connect(fixedTemperature.port, loaAgg.Tg)
    annotation (Line(points={{-40,10},{-30,10},{-20,10}}, color={191,0,0}));
  connect(prescribedHeatFlow.port, loaAgg.Tb)
    annotation (Line(points={{20,10},{0,10}}, color={191,0,0}));
  connect(temperatureSensor.port, loaAgg.Tb) annotation (Line(points={{20,-30},
          {10,-30},{10,10},{0,10}}, color={191,0,0}));
  connect(temperatureSensor.T, add.u2)
    annotation (Line(points={{40,-30},{44,-30},{44,-58}}, color={0,0,127}));
  connect(timTabQ.y[1], prescribedHeatFlow.Q_flow)
    annotation (Line(points={{59,10},{40,10}}, color={0,0,127}));
  connect(timTabT.y[1], add.u1)
    annotation (Line(points={{59,-30},{56,-30},{56,-58}}, color={0,0,127}));
  annotation (experiment(StartTime=599184000,StopTime=630720000),
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
__Dymola_Commands(file="modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/BaseClasses/Aggregation/Validation/LoadAggregation_WithHistory.mos"
        "Simulate and plot"));
end LoadAggregation_WithHistory;
