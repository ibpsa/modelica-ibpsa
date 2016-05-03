within IDEAS.Buildings.GreyboxModels.BaseClasses;
model Window "multipane window"

  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Area A "window area";

  parameter Modelica.SIunits.Angle inc "inclination";
  parameter Modelica.SIunits.Angle azi "azimuth";
  parameter Boolean shading=false "shading presence";
  parameter Modelica.SIunits.Efficiency shaCorr=0.2 "shading transmittance";

  replaceable parameter IDEAS.Buildings.Data.Interfaces.Glazing glazing
    constrainedby IDEAS.Buildings.Data.Interfaces.Glazing "glazing type";

protected
  IDEAS.BoundaryConditions.Climate.Meteo.Solar.RadSol radSol(
    inc=inc,
    azi=azi,
    A=A)
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  IDEAS.Buildings.GreyboxModels.BaseClasses.SwWindowResponse solWin(
    nLay=glazing.nLay,
    SwAbs=glazing.SwAbs,
    SwTrans=glazing.SwTrans)
    annotation (Placement(transformation(extent={{-8,-60},{12,-40}})));

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a solGain
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation

  connect(radSol.angInc, solWin.angInc) annotation (Line(
      points={{-60,-54},{-40,-54},{-40,-56},{-8,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDir, solWin.solDir) annotation (Line(
      points={{-60,-44},{-8,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDif, solWin.solDif) annotation (Line(
      points={{-60,-48},{-8,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solWin.iSol, solGain) annotation (Line(
      points={{0,-60},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end Window;
