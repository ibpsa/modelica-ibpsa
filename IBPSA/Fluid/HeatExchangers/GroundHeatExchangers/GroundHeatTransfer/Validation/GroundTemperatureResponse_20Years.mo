within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.Validation;
model GroundTemperatureResponse_20Years
  "Long term validation of ground temperature response model"
  extends Modelica.Icons.Example;

  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.Template
    borFieDat(conDat(
      borCon=Types.BoreholeConfiguration.SingleUTube,
      nbBor=1,
      cooBor={{0,0}},
      mBor_flow_nominal=0.3,
      dp_nominal=5e4,
      hBor=100,
      rBor=0.05,
      dBor=4,
      rTub=0.02,
      kTub=0.5,
      eTub=0.002,
      xC=0.05),
    soiDat(
      kSoi=1,
      cSoi=1,
      dSoi=1e6),
    filDat(
      kFil=0,
      cFil=Modelica.Constants.small,
      dFil=Modelica.Constants.small,
      steadyState=true))
      "Borefield parameters"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  GroundHeatTransfer.GroundTemperatureResponse groTemRes(
    tLoaAgg=3600,
    p_max=5,
    borFieDat=borFieDat,
    forceGFunCalc=true) "Ground temperature response of borehole"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat injected into borehole"
    annotation (Placement(transformation(extent={{40,0},{20,20}})));
  Modelica.Blocks.Sources.CombiTimeTable timTabQ(
    tableOnFile=true,
    tableName="tab1",
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://IBPSA/Resources/Fluid/HeatExchangers/GroundHeatExchangers/GroundHeatTransfer/Validation/GroundTemperatureResponse_20Years.txt"))
        "Table for heat injected, using constant segments"
    annotation (Placement(transformation(extent={{80,0},{60,20}})));

  Modelica.Blocks.Math.Add add(
    k2=-1,
    y(unit="K"))
    "Difference between FFT method and ground temperature response model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-70})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Borehole wall temperature"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Sources.CombiTimeTable timTabT(
    tableOnFile=true,
    tableName="tab1",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://IBPSA/Resources/Fluid/HeatExchangers/GroundHeatExchangers/GroundHeatTransfer/Validation/GroundTemperatureResponse_20Years.txt"),
    y(each unit="K", each displayUnit="degC"))
      "Table for resulting wall temperature using FFT and linearly interpolated"
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));

  Modelica.Blocks.Sources.Constant const(k=273.15)
    "Cosntant ground temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(preHeaFlo.port, groTemRes.borWall)
    annotation (Line(points={{20,10},{0,10}}, color={191,0,0}));
  connect(temSen.port, groTemRes.borWall) annotation (Line(points={{20,-30},{10,
          -30},{10,10},{0,10}}, color={191,0,0}));
  connect(temSen.T, add.u2)
    annotation (Line(points={{40,-30},{44,-30},{44,-58}}, color={0,0,127}));
  connect(timTabQ.y[1], preHeaFlo.Q_flow)
    annotation (Line(points={{59,10},{40,10}}, color={0,0,127}));
  connect(timTabT.y[1], add.u1)
    annotation (Line(points={{59,-30},{56,-30},{56,-58}}, color={0,0,127}));
  connect(groTemRes.TSoi, const.y)
    annotation (Line(points={{-22,10},{-39,10}}, color={0,0,127}));

  annotation (experiment(StopTime=630720000),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/GroundHeatTransfer/Validation/GroundTemperatureResponse_20Years.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This validation case applies the asymetrical synthetic load profile developed
by Pinel (2003) over a 20 year period by directly injecting the heat at the
borehole wall in the ground temperature response model. The difference between
the resulting borehole wall temperature and the same temperature precalculated
by using a fast Fourier transform is calculated with the <code>add</code>
component. The fast Fourier transform calculation was done using the same
g-function as was calculated by
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.gFunction\">
IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.gFunction</a>.
</p>
<h4>References</h4>
<p>
Pinel, P. 2003. <i>Am&eacute;lioration, validation et implantation d’un algorithme de calcul
pour &eacute;valuer le transfert thermique dans les puits verticaux de syst&egrave;mes de pompes &agrave; chaleur g&eacute;othermiques</i>,
M.A.Sc. Thesis, &Eacute;cole Polytechnique de Montréal.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end GroundTemperatureResponse_20Years;
