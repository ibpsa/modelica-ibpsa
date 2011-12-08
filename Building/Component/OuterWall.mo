within IDEAS.Building.Component;
model OuterWall "exterior opaque wall"

extends IDEAS.Building.Elements.StateWallExt;

parameter Modelica.SIunits.Area A "wall area";
parameter Integer nLay(min=1) "number of material layers";
parameter Integer locGain(min=1) = 1 "location of possible embedded system";
replaceable parameter IDEAS.Building.Elements.Material[nLay] mats
    "array of materials"                                                               annotation(AllMatching=true);
parameter Modelica.SIunits.Angle inc "inclination of the wall";
parameter Modelica.SIunits.Angle azi "azimuth of the wall";

Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_gain
    "port for gains by embedded active layers"
  annotation (Placement(transformation(extent={{90,-90},{110,-70}})));

public
  IDEAS.Building.Component.Elements.SummaryWall  summary(Qloss=-port_b.Q_flow
         - port_bRad.Q_flow, QSolIrr=radSol.solDir/A + radSol.solDif/A)
    "Summary of the thermal response";
  Modelica.Blocks.Interfaces.RealOutput area "output of the area"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,100})));

protected
  IDEAS.Elements.Meteo.Solar.RadSol radSol(inc=inc,azi=azi,A=A)
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  IDEAS.Building.Component.Elements.MultiLayerOpaque   layMul(
    A=A,
    inc=inc,
    nLay=nLay,
    mats=mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  IDEAS.Building.Component.Elements.ExteriorConvection extCon(A=A)
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-40,20},{-60,40}})));
  IDEAS.Building.Component.Elements.InteriorConvection intCon(A=A, inc=inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  IDEAS.Building.Component.Elements.ExteriorSolarAbsorption solAbs(
                                                                  A=A)
    "determination of absorbed solar radiation by wall based on incident radiation"
 annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  IDEAS.Building.Component.Elements.ExteriorHeatRadidation extRad(A=A, inc=
        inc)
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-40,-40},{-60,-20}})));

equation
  connect(radSol.solDir, solAbs.solDir) annotation (Line(
      points={{-68,6},{-60,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDif, solAbs.solDif) annotation (Line(
      points={{-68,2},{-60,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extCon.port_a, layMul.port_a)          annotation (Line(
      points={{-40,30},{-30,30},{-30,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solAbs.port_a, layMul.port_a)        annotation (Line(
      points={{-40,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extRad.port_a, layMul.port_a)        annotation (Line(
      points={{-40,-30},{-30,-30},{-30,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, intCon.port_a)
                                      annotation (Line(
      points={{20,0},{40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon.port_b, port_b)
                               annotation (Line(
      points={{60,0},{80,0},{80,20},{100,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, port_bRad) annotation (Line(
      points={{20,0},{28,0},{28,-20},{100,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw) annotation (Line(
      points={{20,16},{28,16},{28,50},{-20,50},{-20,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw) annotation (Line(
      points={{20,8},{32,8},{32,54},{0,54},{0,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.port_gain[locGain], port_gain) annotation (Line(
      points={{0,-20},{0,-80},{100,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_a, solAbs.epsSw) annotation (Line(
      points={{-20,8},{-34,8},{-34,6},{-40,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_a,extRad. epsLw) annotation (Line(
      points={{-20,16},{-26,16},{-26,-24},{-40,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iEpsLw, iEpsLw) annotation (Line(
      points={{-20,100},{-20,100},{-20,100}},
      color={0,0,127},
      smooth=Smooth.None));

  area = A;

end OuterWall;
