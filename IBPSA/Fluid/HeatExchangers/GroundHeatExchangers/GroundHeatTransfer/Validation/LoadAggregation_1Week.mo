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
    annotation (Placement(transformation(extent={{-12,30},{8,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow to soil"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));

  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.Template
    borFieDat(conDat(
      hBor=100,
      rBor=0.05,
      dBor=4,
      nbBh=1,
      cooBh={{0,0}}),
    soiDat(
      k=1,
      c=1,
      d=1e6),
    filDat(
      k=0,
      c=Modelica.Constants.small,
      d=Modelica.Constants.small,
      steadyState=true))
              "Borefield parameters"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Modelica.Blocks.Sources.Sine sine(
    amplitude=10000,
    freqHz=1/(24*3600),
    startTime=21600)
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo1
    "Prescribed heat flow to soil"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  GroundHeatTransfer.GroundTemperatureResponse groTemRes(
    borFieDat=borFieDat,
    p_max=5,
    tLoaAgg=300)         "Heat conduction in the soil"
    annotation (Placement(transformation(extent={{8,-50},{-12,-30}})));
  Modelica.Blocks.Sources.Constant groTem(k=283.15) "Ground temperature"
    annotation (Placement(transformation(extent={{88,-10},{68,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem
    annotation (Placement(transformation(extent={{48,30},{28,50}})));
equation
  connect(preHeaFlo.port, soi.port_a) annotation (Line(
      points={{-30,40},{-12,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, preHeaFlo1.Q_flow) annotation (Line(points={{-71,0},{-60,0},{
          -60,-40},{-50,-40}},
                           color={0,0,127}));
  connect(sine.y, preHeaFlo.Q_flow) annotation (Line(points={{-71,0},{-60,0},{
          -60,40},{-50,40}},
                         color={0,0,127}));
  connect(preHeaFlo1.port, groTemRes.Tb)
    annotation (Line(points={{-30,-40},{-12,-40}}, color={191,0,0}));
  connect(groTem.y, groTemRes.Tg) annotation (Line(points={{67,0},{60,0},{60,
          -40},{10,-40}},
                    color={0,0,127}));
  connect(preTem.port, soi.port_b)
    annotation (Line(points={{28,40},{18,40},{8,40}}, color={191,0,0}));
  connect(preTem.T, groTem.y)
    annotation (Line(points={{50,40},{60,40},{60,0},{67,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=187200),
    __Dymola_experimentSetupOutput);
end LoadAggregation_1Week;
