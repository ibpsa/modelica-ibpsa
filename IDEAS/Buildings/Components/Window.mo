within IDEAS.Buildings.Components;
model Window "multipane window"

extends IDEAS.Buildings.Components.Interfaces.StateWall;

  parameter Modelica.SIunits.Area A "Total window area";
  parameter Modelica.SIunits.Angle inc
    "Inclination of the window, i.e. 90° denotes vertical";
  parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0° denotes South";
  parameter Boolean shading = false "Shading presence, i.e. true if present";
  parameter Modelica.SIunits.Efficiency shaCorr = 0.2
    "Total shading transmittance";

  replaceable parameter IDEAS.Buildings.Data.Interfaces.Glazing glazing
    "Glazing type" annotation (choicesAllMatching = true);

Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b iSolDir
    "direct solar gains transmitted by windows"                                                              annotation (Placement(transformation(extent={{-24,-110},{-4,-90}})));
Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b iSolDif
    "diffuse solar gains transmitted by windows"                                                              annotation (Placement(transformation(extent={{4,-110},{24,-90}})));

protected
  IDEAS.Buildings.Components.BaseClasses.SolarShading solSha(enable=shading,
      shaCorr=shaCorr)
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  IDEAS.Climate.Meteo.Solar.RadSol  radSol(inc=inc,azi=azi,A=A)
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  IDEAS.Buildings.Components.BaseClasses.MultiLayerLucent layMul(
    A=A,
    inc=inc,
    nLay=glazing.nLay,
    mats=glazing.mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorConvection eCon(A=A)
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection iCon(A=A, inc=inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorHeatRadidation skyRad(A=A, inc=
        inc)
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-20,-20},{-40,0}})));
  IDEAS.Buildings.Components.BaseClasses.SwWindowResponse solWin(
    nLay=glazing.nLay,
    SwAbs=glazing.SwAbs,
    SwTrans=glazing.SwTrans)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

equation
  connect(eCon.port_a, layMul.port_a)            annotation (Line(
      points={{-20,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(skyRad.port_a, layMul.port_a)        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolDir, iSolDir)      annotation (Line(
      points={{-2,-70},{-2,-70},{-2,-80},{-14,-80},{-14,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolDif, iSolDif)      annotation (Line(
      points={{2,-70},{0,-70},{0,-80},{14,-80},{14,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolAbs, layMul.port_gain) annotation (Line(
      points={{0,-50},{0,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radSol.solDir, solSha.solDir) annotation (Line(
      points={{-50,-54},{-40,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDif, solSha.solDif) annotation (Line(
      points={{-50,-58},{-40,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solSha.iSolDir, solWin.solDir) annotation (Line(
      points={{-20,-54},{-10,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solSha.iSolDif, solWin.solDif) annotation (Line(
      points={{-20,-58},{-10,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solSha.iAngInc, solWin.angInc) annotation (Line(
      points={{-20,-66},{-10,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_a, skyRad.epsLw) annotation (Line(
      points={{-10,-22},{-14,-22},{-14,-4},{-20,-4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(layMul.port_b, surfRad_a) annotation (Line(
      points={{10,-30},{16,-30},{16,-60},{50,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(iCon.port_b, surfCon_a) annotation (Line(
      points={{40,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw_a) annotation (Line(
      points={{10,-22},{14,-22},{14,30},{56,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.port_b, iCon.port_a) annotation (Line(
      points={{10,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radSol.angInc, solSha.angInc) annotation (Line(
      points={{-50,-64},{-50,-66},{-40,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw_a) annotation (Line(
      points={{10,-26},{18,-26},{18,0},{56,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.area, area_a) annotation (Line(
      points={{0,-20},{0,60},{56,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},
            {50,100}}),
                   graphics={
        Polygon(
          points={{-46,60},{50,24},{50,-50},{-30,-20},{-46,-20},{-46,60}},
          smooth=Smooth.None,
          pattern=LinePattern.None,
          fillColor={255,255,170},
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
