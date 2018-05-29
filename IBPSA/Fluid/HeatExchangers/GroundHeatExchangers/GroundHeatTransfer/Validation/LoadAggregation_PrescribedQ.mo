within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.Validation;
model LoadAggregation_PrescribedQ
  "Load aggregation model with a constant prescribed load"
  extends Modelica.Icons.Example;

  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.Template
    borFieDat(conDat(
      hBor=100,
      rBor=0.05,
      dBor=4,
      nbBh=1,
      cooBh={{0,0}},
      tStep=3600),
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

  GroundHeatTransfer.GroundTemperatureResponse loaAgg(
    p_max=5,
    borFieDat=borFieDat,
    forceGFunCalc=true) "Load Aggregation in borehole"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    "Prescribed heat injected into borehole"
    annotation (Placement(transformation(extent={{40,0},{20,20}})));
  Modelica.Blocks.Sources.CombiTimeTable timTabQ(
    tableOnFile=true,
    tableName="tab1",
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/Fluid/HeatExchangers/GroundHeatExchangers/GroundHeatTransfer/Validation/LoadAggregation_20y_validation.txt"))
                 "Table for heat injected, using constant segments"
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
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/Fluid/HeatExchangers/GroundHeatExchangers/GroundHeatTransfer/Validation/LoadAggregation_20y_validation.txt"))
    "Table for resulting wall temperature using FFT and linearly interpolated"
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));

  Modelica.Blocks.Sources.Constant const(k=273.15)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
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
  connect(loaAgg.Tg, const.y)
    annotation (Line(points={{-22,10},{-39,10}}, color={0,0,127}));

  annotation (experiment(StopTime=630720000),
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/GroundHeatTransfer/Validation/LoadAggregation_PrescribedQ.mos"
        "Simulate and plot"),
              Documentation(info="<html>
<p>
This validation case applies the assymetrical synthetic load profile developed
by Pinel (2003) over a 20 year period by directly injecting the heat at the
borehole wall in the ground temperature response model. The difference between
the resulting borehole wall temperature and the same temperature precalculated
by using a fast Fourier transform is calculated with the <code>add</code>
component. The fast Fourier transform calculation was done using the same
g-function as was calculated by the <a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.gFunction\">
function used in the ground temperature response model</a>.
</p>
<h4>References</h4>
<p>
Pinel, P. 2003. <i>Amélioration, validation et implantation d’un algorithme de calcul
pour évaluer le transfert thermique dans les puits verticaux de systèmes de pompes à chaleur géothermiques</i>,
M.A.Sc. Thesis, École Polytechnique de Montréal.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2018, by Alex Laferriere:<br/>
First implementation.
</li>
</ul>
</html>"));
end LoadAggregation_PrescribedQ;
