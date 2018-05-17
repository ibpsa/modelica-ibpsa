within IDEAS.BoundaryConditions.SolarIrradiation;
model RadSolData "Selects or generates correct solar data for this surface"
  parameter Modelica.SIunits.Angle inc "inclination";
  parameter Modelica.SIunits.Angle azi "azimuth";
  parameter Modelica.SIunits.Angle lat "latitude";
  parameter Boolean useLinearisation = false
    "Set to true if used for linearisation";
  parameter Integer numIncAndAziInBus "Number of pre-computed combination of inc and azi for solar radiation";
  parameter Modelica.SIunits.Angle[numIncAndAziInBus,2] incAndAziInBus "Combination of {inclination, azimuth} for which the solar data is available in weaBus.";
  parameter Boolean outputAngles=true "Set to false when linearising only";

  input IDEAS.Buildings.Components.Interfaces.WeaBus
    weaBus(numSolBus=numIncAndAziInBus,
        outputAngles=outputAngles)
    annotation (HideResults=true,Placement(transformation(extent={{90,70},{110,90}})));

  Modelica.Blocks.Interfaces.RealOutput HDirTil
    "Direct solar irradiation on a tilted surface"
    annotation (Placement(transformation(extent={{96,30},{116,50}})));
  Modelica.Blocks.Interfaces.RealOutput HGroDifTil
    "Diffuse sky solar irradiance on a tilted surface"
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Interfaces.RealOutput HSkyDifTil
    "Diffuse sky solar irradiance on a tilted surface"
    annotation (Placement(transformation(extent={{96,10},{116,30}})));
  Modelica.Blocks.Interfaces.RealOutput angInc
    annotation (Placement(transformation(extent={{96,-50},{116,-30}})));
  Modelica.Blocks.Interfaces.RealOutput angZen
    annotation (Placement(transformation(extent={{96,-70},{116,-50}})));
  Modelica.Blocks.Interfaces.RealOutput angAzi
    annotation (Placement(transformation(extent={{96,-90},{116,-70}})));
  Modelica.Blocks.Interfaces.RealOutput angHou "Hour angle"
    annotation (Placement(transformation(extent={{96,-110},{116,-90}})));
  Modelica.Blocks.Interfaces.RealOutput Tenv "Environment temperature"
    annotation (Placement(transformation(extent={{96,-30},{116,-10}})));
protected
  final parameter Boolean solDataInBus=if sum( { if sum(abs({mod(incAndAziInBus[i,1],Modelica.Constants.pi*2),mod(incAndAziInBus[i,2],Modelica.Constants.pi*2)} -
  {mod(inc,Modelica.Constants.pi*2),mod(azi,Modelica.Constants.pi*2)}))<0.01 then 1 else 0 for i in 1:numIncAndAziInBus})   ==1 then true else false
    "True if the {inc,azi} combination is found in incAndAziInBus" annotation(Evaluate=true);
  final parameter Integer solDataIndex=sum( { if sum(abs({mod(incAndAziInBus[i,1],Modelica.Constants.pi*2),mod(incAndAziInBus[i,2],Modelica.Constants.pi*2)} -
  {mod(inc,Modelica.Constants.pi*2),mod(azi,Modelica.Constants.pi*2)}))<0.01 then i else 0 for i in 1:numIncAndAziInBus})
    "Index of the {inc,azi} combination in incAndAziInBus" annotation(Evaluate=true);
  IDEAS.BoundaryConditions.SolarIrradiation.ShadedRadSol radSol(
    final inc=inc,
    final azi=azi,
    lat=lat,
    outputAngles=outputAngles) if
                      not solDataInBus
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  output Buildings.Components.Interfaces.SolBus
                                         solBusDummy(outputAngles=outputAngles)
    "Required for avoiding warnings?"
                                     annotation (HideResults=true, Placement(
        transformation(extent={{-60,10},{-20,50}})));

  Modelica.Blocks.Sources.Constant constAngLin(k=1) if
                                                 solDataInBus and not outputAngles
    "Dummy inputs when linearising. This avoids unnecessary state space inputs."
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
equation
      assert( not useLinearisation or (useLinearisation and solDataInBus), "The solar data must come
      from the weabus when the model is linearised. Add the combination {inc,azi} = {"+String(inc)+","+String(azi)+"}
      to the parameter incAndAziInBus of the SimInfoManager.");
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
  connect(HDirTil, solBusDummy.HDirTil) annotation (Line(
      points={{106,40},{-39.9,40},{-39.9,30.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tenv, solBusDummy.Tenv) annotation (Line(
      points={{106,-20},{-39.9,-20},{-39.9,30.1}},
      color={0,0,127},
      smooth=Smooth.None));
  if not (solDataInBus and not outputAngles) then
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
  end if;
  connect(radSol.TePow4, weaBus.TePow4) annotation (Line(points={{-66,40.6},{-66,
          54},{100.05,54},{100.05,80.05}},
                                  color={0,0,127}));
  connect(radSol.TskyPow4, weaBus.TskyPow4) annotation (Line(points={{-72,40.6},
          {-72,56},{100.05,56},{100.05,80.05}},
                                       color={0,0,127}));
  connect(radSol.solDirPer, weaBus.solDirPer) annotation (Line(points={{-80.4,40},
          {-80.4,58},{100.05,58},{100.05,80.05}},
                                         color={0,0,127}));
  connect(radSol.solGloHor, weaBus.solGloHor) annotation (Line(points={{-80.4,38},
          {-82,38},{-82,60},{100.05,60},{100.05,80.05}}, color={0,0,127}));
  connect(radSol.solDifHor, weaBus.solDifHor) annotation (Line(points={{-80.4,36},
          {-84,36},{-84,62},{100.05,62},{100.05,80.05}},
                                                color={0,0,127}));
  connect(radSol.angDec, weaBus.angDec) annotation (Line(points={{-80.4,30},{-88,
          30},{-88,66},{100.05,66},{100.05,80.05}},
                                           color={0,0,127}));
  connect(radSol.angHou, weaBus.angHou) annotation (Line(points={{-80.4,28},{-90,
          28},{-90,68},{100.05,68},{100.05,80.05}},
                                           color={0,0,127}));
  connect(radSol.angZen, weaBus.angZen) annotation (Line(points={{-80.4,26},{-92,
          26},{-92,70},{100.05,70},{100.05,80.05}},
                                           color={0,0,127}));
  connect(radSol.F1, weaBus.F1) annotation (Line(points={{-80.4,22},{-94,22},{-94,
          72},{100.05,72},{100.05,80.05}},
                                  color={0,0,127}));
  connect(radSol.F2, weaBus.F2) annotation (Line(points={{-80.4,20},{-96,20},{-96,
          74},{100.05,74},{100.05,80.05}},
                                  color={0,0,127}));

    connect(constAngLin.y, angInc) annotation (Line(points={{-79,-60},{-78,-60},{-78,
          -40},{106,-40}}, color={0,0,127}));
  connect(constAngLin.y, angZen)
    annotation (Line(points={{-79,-60},{-78,-60},{106,-60}}, color={0,0,127}));
  connect(constAngLin.y, angAzi)
                                annotation (Line(points={{-79,-60},{-78,-60},{-78,
          -80},{106,-80}}, color={0,0,127}));
  connect(HSkyDifTil, solBusDummy.HSkyDifTil) annotation (Line(points={{106,20},
          {-39.9,20},{-39.9,30.1}}, color={0,0,127}));
  connect(HGroDifTil, solBusDummy.HGroDifTil) annotation (Line(points={{106,0},
          {-39.9,0},{-39.9,30.1}}, color={0,0,127}));
  connect(angHou, weaBus.angHou) annotation (Line(points={{106,-100},{80,-100},
          {80,80.05},{100.05,80.05}}, color={0,0,127}));
  connect(radSol.solTim, weaBus.solTim) annotation (Line(points={{-80.4,33},{-86,33},
          {-86,64},{100.05,64},{100.05,80.05}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Documentation(info="<html>
<p>This model usually takes the appropriate solar data from the bus. If the correct data is not contained by the bus, custom solar data is calculated.</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2018 by Iago Cupeiro &amp; Damien Picard:<br/>
Solved bug in linearisation
</li>
<li>
January 21, 2018 by Filip Jorissen:<br/>
Added <code>solTim</code> connection for revised azimuth computations.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/753\">
#753</a>.
</li>
<li>
May 26, 2017 by Filip Jorissen:<br/>
Revised implementation for renamed
ports <code>HDirTil</code> etc.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/735\">
#735</a>.
</li>
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
