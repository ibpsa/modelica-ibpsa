within IDEAS.Building.Component;
model Window "multipane window"

extends IDEAS.Building.Elements.StateWindow;
//extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Area A "window area";

  parameter Modelica.SIunits.Angle inc "inclination";
  parameter Modelica.SIunits.Angle azi "azimuth";
  parameter Boolean shading = false "shading presence";
  parameter Modelica.SIunits.Efficiency shaCorr = 0.2 "shading transmittance";

  replaceable parameter IDEAS.Building.Elements.Glazing glazing "glazing type"  annotation(AllMatching=true);

public
  IDEAS.Building.Component.Elements.SummaryWall  summary(Qloss=-port_b.Q_flow
         - port_bRad.Q_flow, QSolIrr=radSol.solDir/A + radSol.solDif/A)
    "Summary of the thermal response";
  IDEAS.Building.Component.Elements.SolarShading solSha(enable=shading,
      shaCorr=shaCorr)
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Interfaces.RealOutput area
    "output of the interior emissivity for radiative heat losses"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,100})));

protected
  IDEAS.Elements.Meteo.Solar.RadSol radSol(inc=inc,azi=azi,A=A)
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  IDEAS.Building.Component.Elements.MultiLayerLucent     layMul(
    A=A,
    inc=inc,
    nLay=glazing.nLay,
    mats=glazing.mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  IDEAS.Building.Component.Elements.ExteriorConvection eCon(A=A)
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-60,20},{-80,40}})));
  IDEAS.Building.Component.Elements.InteriorConvection iCon(A=A, inc=inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  IDEAS.Building.Component.Elements.ExteriorHeatRadidation skyRad(A=A, inc=
        inc)
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-60,-20},{-80,0}})));
  IDEAS.Building.Component.Elements.SwWindowResponse solWin(
    nLay=glazing.nLay,
    SwAbs=glazing.SwAbs,
    SwTrans=glazing.SwTrans)
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

equation
  area = A;

  connect(eCon.port_a, layMul.port_a)            annotation (Line(
      points={{-60,30},{-50,30},{-50,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(skyRad.port_a, layMul.port_a)        annotation (Line(
      points={{-60,-10},{-50,-10},{-50,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, iCon.port_a) annotation (Line(
      points={{20,0},{40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(iCon.port_b, port_b) annotation (Line(
      points={{60,0},{80,0},{80,20},{100,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, port_bRad) annotation (Line(
      points={{20,0},{32,0},{32,-20},{100,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw) annotation (Line(
      points={{20,16},{28,16},{28,46},{-20,46},{-20,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw) annotation (Line(
      points={{20,8},{32,8},{32,54},{20,54},{20,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solWin.iSolDir, port_bSolDir) annotation (Line(
      points={{-2,-60},{-2,-80},{-20,-80},{-20,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolDif, port_bSolDif) annotation (Line(
      points={{2,-60},{2,-80},{20,-80},{20,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolAbs, layMul.port_gain) annotation (Line(
      points={{0,-40},{0,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radSol.solDir, solSha.solDir) annotation (Line(
      points={{-60,-44},{-40,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDif, solSha.solDif) annotation (Line(
      points={{-60,-48},{-40,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solSha.iSolDir, solWin.solDir) annotation (Line(
      points={{-20,-44},{-10,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solSha.iSolDif, solWin.solDif) annotation (Line(
      points={{-20,-48},{-10,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solSha.iAngInc, solWin.angInc) annotation (Line(
      points={{-20,-56},{-10,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.angInc, solSha.angInc) annotation (Line(
      points={{-60,-54},{-62,-54},{-62,-56},{-40,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_a, skyRad.epsLw) annotation (Line(
      points={{-20,16},{-32,16},{-32,-4},{-60,-4}},
      color={0,0,127},
      smooth=Smooth.None));

end Window;
