within IBPSA.Fluid.Sources.Examples;
model Outside_CpData_Angles
  "Test model for source and sink with outside weather data and wind pressure using user-defined Cp values"
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Air "Medium model for air";
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
      winDirSou=IBPSA.BoundaryConditions.Types.DataSource.Input)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  parameter Modelica.Units.SI.Angle incAng[:] = {0, 45, 90, 135, 180, 225, 270, 315, 360}*2*Modelica.Constants.pi/360
    "Wind incidence angles";
  parameter Real Cp_sym[:] = {0.4, 0.1, -0.3, -0.35, -0.2, -0.35, -0.3, 0.1, 0.4}
    "Cp values";
  parameter Real Cp_Asym[:]={0.4,0.1,-0.3,-0.35,-0.2,-0.6,-0.9,-0.1,0.4}
    "Cp values";
  IBPSA.Fluid.Sources.Outside_CpData Symmetric_N(
    redeclare package Medium = Medium,
    incAng=incAng,
    Cp=Cp_sym,
    azi=IBPSA.Types.Azimuth.N) "Model with outside conditions"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  IBPSA.Fluid.Sources.Outside_CpData Asymmetric_N(
    redeclare package Medium = Medium,
    incAng=incAng,
    Cp=Cp_Asym,
    azi=IBPSA.Types.Azimuth.N) "Model with outside conditions"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.Ramp Winddir(
    height=2*Modelica.Constants.pi,
    duration=10,
    startTime=5)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  IBPSA.Fluid.Sources.Outside_CpData Asymmetric_W(
    redeclare package Medium = Medium,
    incAng=incAng,
    Cp=Cp_Asym,
    azi=IBPSA.Types.Azimuth.W) "Model with outside conditions"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  IBPSA.Fluid.Sources.Outside_CpData Symmetric_W(
    redeclare package Medium = Medium,
    incAng=incAng,
    Cp=Cp_sym,
    azi=IBPSA.Types.Azimuth.W) "Model with outside conditions"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
equation
  connect(weaDat.weaBus, Symmetric_N.weaBus) annotation (Line(
      points={{-20,10},{-8,10},{-8,-9.8},{0,-9.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, Asymmetric_N.weaBus) annotation (Line(
      points={{-20,10},{-6,10},{-6,30.2},{0,30.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Winddir.y, weaDat.winDir_in) annotation (Line(points={{-59,10},{-48,10},
          {-48,4},{-41,4}}, color={0,0,127}));
  connect(Asymmetric_W.weaBus, weaDat.weaBus) annotation (Line(
      points={{0,70.2},{-10,70.2},{-10,10},{-20,10}},
      color={255,204,51},
      thickness=0.5));
  connect(Symmetric_W.weaBus, weaDat.weaBus) annotation (Line(
      points={{0,-49.8},{-10,-49.8},{-10,10},{-20,10}},
      color={255,204,51},
      thickness=0.5));
  annotation (__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Sources/Examples/Outside_CpData_Angles.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model demonstrates the use of a source for ambient conditions that computes
the wind pressure on a facade of a building using a user-defined wind pressure profile.
Weather data are used for San Francisco, for a period of a week
where the wind blows primarily from North-West.
The plot shows that the wind pressure on the north- and west-facing
facade is positive,
whereas it is negative for the south- and east-facing facades.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
Jun 28, 2021 by Klaas De Jonge:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=20,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end Outside_CpData_Angles;
