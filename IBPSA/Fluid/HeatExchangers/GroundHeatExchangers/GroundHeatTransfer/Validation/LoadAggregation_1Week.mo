within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.Validation;
model LoadAggregation_1Week
  "Short term validation of load aggregation model"
  import IBPSA;
  extends Modelica.Icons.Example;

  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.CylindricalGroundLayer
    soi(
    final steadyStateInitial=false,
    final soiDat=borFieDat.soiDat,
    final h=borFieDat.conDat.hBor,
    final r_a=borFieDat.conDat.rBor,
    final r_b=3,
    final TInt_start=borFieDat.conDat.T_start,
    final TExt_start=borFieDat.conDat.T_start,
    gridFac=1.2,
    final nSta=50)                             "Heat conduction in the soil"
    annotation (Placement(transformation(extent={{-12,50},{8,70}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow to soil"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));

  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.Template
    borFieDat(
    soiDat(
      k=1,
      c=1,
      d=1e6),
    filDat(
      k=0,
      c=Modelica.Constants.small,
      d=Modelica.Constants.small,
      steadyState=true),
    conDat(
      hBor=1e6,
      rBor=0.05,
      dBor=4,
      nbBh=1,
      cooBh={{0,0}}))
              "Borefield parameters"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/(24*3600),
    startTime=21600,
    amplitude=1e8)
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo1
    "Prescribed heat flow to soil"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  GroundHeatTransfer.GroundTemperatureResponse groTemRes(
    borFieDat=borFieDat,
    p_max=5,
    tLoaAgg=30)          "Heat conduction in the soil"
    annotation (Placement(transformation(extent={{8,-70},{-12,-50}})));
  Modelica.Blocks.Sources.Constant groTem(k=283.15) "Ground temperature"
    annotation (Placement(transformation(extent={{88,-10},{68,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem
    annotation (Placement(transformation(extent={{48,50},{28,70}})));
  Modelica.Blocks.Math.Add deltaT(k2=-1)
    "Temperature difference between borehole with discrete ground and borehole with analytical ground"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Borehole wall temperature sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,20})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen1
    "Borehole wall temperature sensor"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(preHeaFlo.port, soi.port_a) annotation (Line(
      points={{-30,60},{-12,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, preHeaFlo1.Q_flow) annotation (Line(points={{-71,0},{-60,0},{
          -60,-60},{-50,-60}},
                           color={0,0,127}));
  connect(sine.y, preHeaFlo.Q_flow) annotation (Line(points={{-71,0},{-60,0},{
          -60,60},{-50,60}},
                         color={0,0,127}));
  connect(preHeaFlo1.port, groTemRes.Tb)
    annotation (Line(points={{-30,-60},{-12,-60}}, color={191,0,0}));
  connect(groTem.y, groTemRes.Tg) annotation (Line(points={{67,0},{60,0},{60,
          -60},{10,-60}},
                    color={0,0,127}));
  connect(preTem.port, soi.port_b)
    annotation (Line(points={{28,60},{18,60},{8,60}}, color={191,0,0}));
  connect(preTem.T, groTem.y)
    annotation (Line(points={{50,60},{60,60},{60,0},{67,0}}, color={0,0,127}));
  connect(temSen1.T, deltaT.u2) annotation (Line(points={{10,-20},{20,-20},{20,
          -6},{28,-6}}, color={0,0,127}));
  connect(temSen.T, deltaT.u1)
    annotation (Line(points={{10,20},{20,20},{20,6},{28,6}}, color={0,0,127}));
  connect(soi.port_a, temSen.port) annotation (Line(points={{-12,60},{-20,60},{
          -20,20},{-10,20}}, color={191,0,0}));
  connect(temSen1.port, groTemRes.Tb) annotation (Line(points={{-10,-20},{-20,
          -20},{-20,-60},{-12,-60}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=187200),
    __Dymola_experimentSetupOutput);
end LoadAggregation_1Week;
