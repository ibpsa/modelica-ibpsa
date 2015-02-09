within IDEAS.Buildings.Components;
model RadSolData
  parameter Boolean solDataInBus=
    incidenceAngles.roofInc == inc or
    (inc==IDEAS.Constants.Wall
      and abs(sin((azi-incidenceAngles.offset)*incidenceAngles.numAng))<0.05);

  parameter SI.Angle inc "inclination";
  parameter SI.Angle azi "azimuth";
  parameter SI.Angle lat "latitude";
  parameter Integer solDataIndex = 1+integer(floor(mod((azi-incidenceAngles.offset)/Modelica.Constants.pi/2,1)*incidenceAngles.numAng));
protected
  Climate.Meteo.Solar.ShadedRadSol radSol(
    final inc=inc,
    final azi=azi,
    lat=lat,
    numAng=incidenceAngles.numAng) if
                      not solDataInBus
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-94,24},{-74,44}})));
  outer IncidenceAngles incidenceAngles
    annotation (Placement(transformation(extent={{-100,-98},{-80,-78}})));

  Interfaces.SolBus solBus
    annotation (HideResults=true,Placement(transformation(extent={{-80,14},{-40,54}})));
public
  Modelica.Blocks.Interfaces.RealOutput solDir
    annotation (Placement(transformation(extent={{96,10},{116,30}})));
  Modelica.Blocks.Interfaces.RealOutput solDif
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));

  BoundaryConditions.WeatherData.Bus weaBus(numSolBus=incidenceAngles.numAng + 1)
    annotation (HideResults=true,Placement(transformation(extent={{90,70},{110,90}})));

  Modelica.Blocks.Interfaces.RealOutput angInc
    annotation (Placement(transformation(extent={{96,-50},{116,-30}})));
  Modelica.Blocks.Interfaces.RealOutput angZen
    annotation (Placement(transformation(extent={{96,-70},{116,-50}})));
  Modelica.Blocks.Interfaces.RealOutput angAzi
    annotation (Placement(transformation(extent={{96,-90},{116,-70}})));
  Modelica.Blocks.Interfaces.RealOutput Tenv "Environment temperature"
    annotation (Placement(transformation(extent={{96,-30},{116,-10}})));
equation

  if solDataInBus then
    connect(solBus,weaBus.solBus[solDataIndex]);
  end if;
  connect(solDir, solBus.iSolDir) annotation (Line(
      points={{106,20},{-60,20},{-60,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDif, solBus.iSolDif) annotation (Line(
      points={{106,0},{-60,0},{-60,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angInc, solBus.angInc) annotation (Line(
      points={{106,-40},{-60,-40},{-60,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angZen, solBus.angZen) annotation (Line(
      points={{106,-60},{-60,-60},{-60,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angAzi, solBus.angAzi) annotation (Line(
      points={{106,-80},{-60,-80},{-60,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tenv, solBus.Tenv) annotation (Line(
      points={{106,-20},{-60,-20},{-60,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.weaBus, weaBus) annotation (Line(
      points={{-94,42},{-94,80},{100,80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  connect(radSol.solBus, solBus) annotation (Line(
      points={{-74,34},{-60,34}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end RadSolData;
