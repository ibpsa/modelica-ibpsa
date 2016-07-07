within IDEAS.BoundaryConditions.Climate.Meteo.Solar;
model RadSolData "Selects or generates correct solar data for this surface"
  parameter SI.Angle inc "inclination";
  parameter SI.Angle azi "azimuth";
  parameter SI.Angle lat "latitude";
  parameter Integer numAzi "Number of irradation data calculated in solBus";
  parameter SI.Angle ceilingInc "Roof inclination angle in solBus";
  parameter SI.Angle offsetAzi
    "Offset azimuth angle of irradation data calculated in solBus";
  parameter Boolean solDataInBus=
   isRoof or
    (IDEAS.Utilities.Math.Functions.isAngle(inc,IDEAS.Types.Tilt.Wall)
      and abs(sin((azi-offsetAzi)*numAzi))<0.05)
    "True if solBus contains correct data for this surface"
    annotation(Evaluate=true);
  final parameter Integer solDataIndex=
    if isRoof then
      1 else
      2+integer(floor(mod((azi-offsetAzi)/Modelica.Constants.pi/2,1)*numAzi))
    "Solbus index for this surface";

  input IDEAS.Buildings.Components.Interfaces.WeaBus
                                     weaBus(numSolBus=numAzi + 1)
    annotation (HideResults=true,Placement(transformation(extent={{90,70},{110,90}})));

  Modelica.Blocks.Interfaces.RealOutput solDir
    annotation (Placement(transformation(extent={{96,10},{116,30}})));
  Modelica.Blocks.Interfaces.RealOutput solDif
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));

  Modelica.Blocks.Interfaces.RealOutput angInc
    annotation (Placement(transformation(extent={{96,-50},{116,-30}})));
  Modelica.Blocks.Interfaces.RealOutput angZen
    annotation (Placement(transformation(extent={{96,-70},{116,-50}})));
  Modelica.Blocks.Interfaces.RealOutput angAzi
    annotation (Placement(transformation(extent={{96,-90},{116,-70}})));
  Modelica.Blocks.Interfaces.RealOutput Tenv "Environment temperature"
    annotation (Placement(transformation(extent={{96,-30},{116,-10}})));
protected
      parameter Boolean isRoof = IDEAS.Utilities.Math.Functions.isAngle(ceilingInc, inc)
    "Surface is a horizontal surface";
  IDEAS.BoundaryConditions.Climate.Meteo.Solar.ShadedRadSol radSol(
    final inc=inc,
    final azi=azi,
    lat=lat,
    numAzi=numAzi) if not solDataInBus
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  output Buildings.Components.Interfaces.SolBus
                                         solBusDummy
    "Required for avoiding warnings?"
                                     annotation (HideResults=true, Placement(
        transformation(extent={{-60,10},{-20,50}})));
equation

  connect(radSol.solBus, solBusDummy) annotation (Line(
      points={{-60,30},{-40,30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  if solDataInBus then
    connect(weaBus.solBus[solDataIndex], solBusDummy) annotation (Line(
      points={{100.05,80.05},{-40,80.05},{-40,30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  end if;
  connect(solDir, solBusDummy.iSolDir) annotation (Line(
      points={{106,20},{-40,20},{-40,30.1},{-39.9,30.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDif, solBusDummy.iSolDif) annotation (Line(
      points={{106,0},{-40,0},{-40,2},{-39.9,2},{-39.9,30.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tenv, solBusDummy.Tenv) annotation (Line(
      points={{106,-20},{-39.9,-20},{-39.9,30.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angInc, solBusDummy.angInc) annotation (Line(
      points={{106,-40},{-40,-40},{-40,-42},{-39.9,-42},{-39.9,30.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angZen, solBusDummy.angZen) annotation (Line(
      points={{106,-60},{-39.9,-60},{-39.9,30.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angAzi, solBusDummy.angAzi) annotation (Line(
      points={{106,-80},{-39.9,-80},{-39.9,30.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.TePow4, weaBus.TePow4) annotation (Line(points={{-66,40.6},{-66,
          56},{100,56},{100,80}}, color={0,0,127}));
  connect(radSol.TskyPow4, weaBus.TskyPow4) annotation (Line(points={{-72,40.6},
          {-72,58},{100,58},{100,80}}, color={0,0,127}));
  connect(radSol.solDirPer, weaBus.solDirPer) annotation (Line(points={{-80.4,40},
          {-80.4,60},{100,60},{100,80}}, color={0,0,127}));
  connect(radSol.solGloHor, weaBus.solGloHor) annotation (Line(points={{-80.4,38},
          {-82,38},{-82,62},{-82,62},{100,62},{100,80}}, color={0,0,127}));
  connect(radSol.solDifHor, weaBus.solDifHor) annotation (Line(points={{-80.4,36},
          {-84,36},{-84,64},{100,64},{100,80}}, color={0,0,127}));
  connect(radSol.angDec, weaBus.angDec) annotation (Line(points={{-80.4,30},{-86,
          30},{-86,66},{100,66},{100,80}}, color={0,0,127}));
  connect(radSol.angHou, weaBus.angHou) annotation (Line(points={{-80.4,28},{-88,
          28},{-88,68},{100,68},{100,80}}, color={0,0,127}));
  connect(radSol.angZen, weaBus.angZen) annotation (Line(points={{-80.4,26},{-90,
          26},{-90,70},{100,70},{100,80}}, color={0,0,127}));
  connect(radSol.F1, weaBus.F1) annotation (Line(points={{-80.4,22},{-92,22},{-92,
          72},{100,72},{100,80}}, color={0,0,127}));
  connect(radSol.F2, weaBus.F2) annotation (Line(points={{-80.4,20},{-94,20},{-94,
          74},{100,74},{100,80}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Documentation(info="<html>
<p>This model usually takes the appropriate solar data from the bus. If the correct data is not contained by the bus, custom solar data is calculated.</p>
</html>", revisions="<html>
<ul>
<li>
March 25, 2016 by Filip Jorissen:<br/>
Reworked radSol implementation to use RealInputs instead of weaBus.
This simplifies translation and interpretation.
</li>
<li>
February 10, 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end RadSolData;
