within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.Validation;
model GroundTemperatureResponse_SmallScaleValidation
  "Long term validation of ground temperature response model using the small scale experiment of Cimmino and Bernier (2015)"
  extends Modelica.Icons.Example;

  parameter Real sizFac=375.0 "Scaling factor of the experiment";
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SmallScale_validation
    borFieDat   "Borefield parameters"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  GroundHeatTransfer.GroundTemperatureResponse groTemRes(
    nCel=5,
    borFieDat=borFieDat,
    forceGFunCalc=true,
    tLoaAgg=360000)     "Ground temperature response of borehole"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat injected into borehole"
    annotation (Placement(transformation(extent={{20,0},{0,20}})));
  Modelica.Blocks.Sources.CombiTimeTable meaDat(
    tableOnFile=true,
    timeScale=sizFac^2,
    fileName=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/Fluid/HeatExchangers/GroundHeatExchangers/GroundHeatTransfer/Validation/Cimmino_Bernier_2015_SmallScaleValidation.txt"),
    columns={2,3,4,5,6,7,8,9},
    tableName="data",
    offset={0,0,0,273.15,273.15,273.15,273.15,273.15})
                     "Measurement data"
    annotation (Placement(transformation(extent={{80,0},{60,20}})));

  Modelica.Blocks.Math.Add add(
    k2=-1,
    y(unit="K"))
    "Difference between experiment data and ground temperature response model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-70})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Borehole wall temperature"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Modelica.Blocks.Math.Gain scaFac(k=sizFac)
                                          "Scaling factor of the experiment"
    annotation (Placement(transformation(extent={{50,0},{30,20}})));
equation
  connect(preHeaFlo.port, groTemRes.borWall)
    annotation (Line(points={{0,10},{-20,10}},color={191,0,0}));
  connect(temSen.port, groTemRes.borWall) annotation (Line(points={{0,-30},{-10,
          -30},{-10,10},{-20,10}},
                                color={191,0,0}));
  connect(temSen.T, add.u2)
    annotation (Line(points={{20,-30},{24,-30},{24,-58}}, color={0,0,127}));

  connect(preHeaFlo.Q_flow, scaFac.y)
    annotation (Line(points={{20,10},{29,10}},         color={0,0,127}));
  connect(meaDat.y[3], scaFac.u)
    annotation (Line(points={{59,10},{52,10}},           color={0,0,127}));
  connect(meaDat.y[4], add.u1) annotation (Line(points={{59,10},{56,10},{56,-58},
          {36,-58}}, color={0,0,127}));
  connect(meaDat.y[8], groTemRes.TSoi) annotation (Line(points={{59,10},{56,10},
          {56,40},{-58,40},{-58,10},{-42,10}},         color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=85050000000.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/GroundHeatTransfer/Validation/GroundTemperatureResponse_SmallScaleValidation.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This validation case simulates the experiment of Cimmino and Bernier (2015).
The experiment consists in the injection of heat at an average rate of 8.67 W
in a 0.40 m long borehole over a period of 168 h. Borehole wall tempratures
were measured by a series of 22 thermocouples welded to the stainless steel
pipe that contains the borehole and acts as the borehole wall.
</p>
<p>
Since the model is not adapted to the simulation of small scale boreholes, the
borehole dimensions are multiplied by a factor 375 to obtain a scaled-up 150.0 m
long borehole. The time values of the experimental data are then multiplied by a
factor 375<sup>2</sup>. The predicted borehole wall temperature is compared to
the experimental data.
</p>
<p>
A sharp increase in the rate of change of the borehole wall temperature is
observed at <i>t=500 years</i>. This is caused by a sudden change in the rate
of heat injected to the fluid at the same moment. The simulated borehole wall
temperature is more affected the measured borehole wall temperature since the
validation model does not consider the dynamics of the borehole and the fluid,
and that heat is directly injected at the borehole wall. In the experiment, the
sudden change in heat injection rate was dampened by the circulating fluid, the
borehole filling material, and the measurement apparatus.
</p>
<h4>References</h4>
<p>
Cimmino, M. and Bernier, M. 2015. <i>Experimental determination of the
g-functions of a small-scale geothermal borehole</i>. Geothermics 56: 60-71.
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end GroundTemperatureResponse_SmallScaleValidation;
