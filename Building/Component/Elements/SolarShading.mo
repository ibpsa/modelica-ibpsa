within IDEAS.Building.Component.Elements;
model SolarShading "solar shading"

extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Real shaCorr = 0.24
    "shortwave transmittance of shortwave radiation";
  parameter Boolean enable = false;

  final parameter Modelica.SIunits.Angle iAngDif = 60/180*Modelica.Constants.pi;

  Modelica.Blocks.Interfaces.RealInput solDir
    "direct solar illuminance on surface se"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput solDif
    "diffuse solar illuminance on surface s"
    annotation (Placement(transformation(extent={{-120,0},{-80,40}})));
  Modelica.Blocks.Interfaces.RealInput angInc "angle of incidence"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
  Modelica.Blocks.Interfaces.RealOutput iSolDir
    "direct solar illuminance on surface se"
    annotation (Placement(transformation(extent={{80,40},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput iSolDif
    "diffuse solar illuminance on surface s"
    annotation (Placement(transformation(extent={{80,0},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput iAngInc
    "angle of incidence after transmittance through shading (or not)"
    annotation (Placement(transformation(extent={{80,-80},{120,-40}})));
  Modelica.Blocks.Math.Add solTot
    annotation (Placement(transformation(extent={{-60,32},{-40,52}})));
  IDEAS.Building.Component.Elements.ShadingControl shaCtrl
    "control of the solar shading"
    annotation (Placement(transformation(extent={{-28,26},{-8,46}})));
equation
  connect(solDir, solTot.u1) annotation (Line(
      points={{-100,60},{-72,60},{-72,48},{-62,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDif, solTot.u2) annotation (Line(
      points={{-100,20},{-72,20},{-72,36},{-62,36}},
      color={0,0,127},
      smooth=Smooth.None));

if noEvent(shaCtrl.y > 0.5) and enable then
  iAngInc = iAngDif;
  iSolDif = (solDir+solDif)*shaCorr;
  iSolDir = 0;
else
  iAngInc = angInc;
  iSolDif = solDif;
  iSolDir = solDir;
end if;

  connect(solTot.y, shaCtrl.irr) annotation (Line(
      points={{-39,42},{-28,42}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end SolarShading;
