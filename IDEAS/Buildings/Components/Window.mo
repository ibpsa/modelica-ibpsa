within IDEAS.Buildings.Components;
model Window "multipane window"

extends IDEAS.Buildings.Components.Interfaces.StateWall;

  parameter Modelica.SIunits.Area A "window area";

  parameter Modelica.SIunits.Angle inc "inclination";
  parameter Modelica.SIunits.Angle azi "azimuth";
  parameter Boolean shading = false "shading presence";
  parameter Modelica.SIunits.Efficiency shaCorr = 0.2 "shading transmittance";

  replaceable parameter IDEAS.Buildings.Data.Interfaces.Glazing glazing
    "glazing type" annotation (choicesAllMatching = true);

Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b iSolDir
    "direct solar gains transmitted by windows"                                                              annotation (Placement(transformation(extent={{-24,-110},{-4,-90}})));
Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b iSolDif
    "diffuse solar gains transmitted by windows"                                                              annotation (Placement(transformation(extent={{4,-110},{24,-90}})));

protected
  IDEAS.Buildings.Components.BaseClasses.SolarShading solSha(enable=shading,
      shaCorr=shaCorr)
    annotation (Placement(transformation(extent={{-26,-68},{-10,-52}})));

  IDEAS.Climate.Meteo.Solar.RadSol  radSol(inc=inc,azi=azi,A=A)
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-46,-68},{-30,-52}})));
  IDEAS.Buildings.Components.BaseClasses.MultiLayerLucent layMul(
    A=A,
    inc=inc,
    nLay=glazing.nLay,
    mats=glazing.mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-8,-40},{12,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorConvection eCon(A=A)
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-30,-38},{-46,-22}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection iCon(A=A, inc=inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorHeatRadidation skyRad(A=A, inc=
        inc)
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-30,-16},{-46,0}})));
  IDEAS.Buildings.Components.BaseClasses.SwWindowResponse solWin(
    nLay=glazing.nLay,
    SwAbs=glazing.SwAbs,
    SwTrans=glazing.SwTrans)
    annotation (Placement(transformation(extent={{-6,-68},{10,-52}})));

public
  Modelica.Blocks.Sources.Constant const(k=A)
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={2,0})));
equation
  connect(eCon.port_a, layMul.port_a)            annotation (Line(
      points={{-30,-30},{-8,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(skyRad.port_a, layMul.port_a)        annotation (Line(
      points={{-30,-8},{-16,-8},{-16,-30},{-8,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolDir, iSolDir)      annotation (Line(
      points={{0.4,-68},{0.4,-80},{-14,-80},{-14,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolDif, iSolDif)      annotation (Line(
      points={{3.6,-68},{3.6,-80},{14,-80},{14,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolAbs, layMul.port_gain) annotation (Line(
      points={{2,-52},{2,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radSol.solDir, solSha.solDir) annotation (Line(
      points={{-30,-55.2},{-26,-55.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDif, solSha.solDif) annotation (Line(
      points={{-30,-58.4},{-26,-58.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solSha.iSolDir, solWin.solDir) annotation (Line(
      points={{-10,-55.2},{-6,-55.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solSha.iSolDif, solWin.solDif) annotation (Line(
      points={{-10,-58.4},{-6,-58.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solSha.iAngInc, solWin.angInc) annotation (Line(
      points={{-10,-64.8},{-6,-64.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_a, skyRad.epsLw) annotation (Line(
      points={{-8,-22},{-14,-22},{-14,-3.2},{-30,-3.2}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(layMul.port_b, surfRad_a) annotation (Line(
      points={{12,-30},{16,-30},{16,-60},{50,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(iCon.port_b, surfCon_a) annotation (Line(
      points={{40,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw_a) annotation (Line(
      points={{12,-22},{12,-22},{14,-22},{14,30},{56,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.port_b, iCon.port_a) annotation (Line(
      points={{12,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radSol.angInc, solSha.angInc) annotation (Line(
      points={{-30,-63.2},{-30,-64.8},{-26,-64.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw_a) annotation (Line(
      points={{12,-26},{18,-26},{18,0},{56,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, area_a) annotation (Line(
      points={{2,11},{2,60},{56,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},
            {50,100}}),
                   graphics={
        Polygon(
          points={{-46,60},{50,24},{50,-50},{-30,-20},{-46,-20},{-46,60}},
          smooth=Smooth.None,
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{-50,60},{-30,60},{-30,80},{50,80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-30,-20},{-30,-70},{-30,-70},{52,-70}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-50,66},{-50,100},{50,100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-50,-90},{50,-90}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-46,60},{-46,-20}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}),            Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                                                   graphics));
end Window;
