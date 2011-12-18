within IDEAS.Buildings.Components;
model SlabOnGround "opaque floor on ground slab"

extends IDEAS.Buildings.Components.Interfaces.StateWall;

replaceable Data.Interfaces.Construction constructionType(insulationType=insulationType, insulationTickness=insulationThickness)
    "Type of building construction" annotation (choicesAllMatching = true, Placement(transformation(extent={{-38,72},
            {-34,76}})),Dialog(group="Construction details"));
replaceable Data.Interfaces.Insulation insulationType(d=insulationThickness)
    "Type of thermal insulation" annotation (choicesAllMatching = true, Placement(transformation(extent={{-38,84},
            {-34,88}})),Dialog(group="Construction details"));
parameter Modelica.SIunits.Length insulationThickness
    "Thermal insulation thickness" annotation(Dialog(group="Construction details"));
parameter Modelica.SIunits.Area AWall "Total wall area";
parameter Modelica.SIunits.Area PWall "Total wall perimeter";
parameter Modelica.SIunits.Angle inc
    "Inclination of the wall, i.e. 90° denotes vertical";
parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0° denotes South";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb
    "port for gains by embedded active layers"
  annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

protected
final parameter IDEAS.Buildings.Data.Materials.Ground ground1(d=0.50);
final parameter IDEAS.Buildings.Data.Materials.Ground ground2(d=0.33);
final parameter IDEAS.Buildings.Data.Materials.Ground ground3(d=0.17);

Modelica.SIunits.HeatFlowRate Qm = U*AWall*(22-9)-Lpi*4*cos(2*3.1415/12*(m-1+alfa))+Lpe*9*cos(2*3.1415/12*(m-1-beta));

Modelica.SIunits.Length B = AWall/(0.5*PWall)
    "Characteristic dimension of the slab on ground";
Modelica.SIunits.Length dt = sum(constructionType.mats.d)+ground1.k*layMul.R
    "Equivalent thickness";
Real U = ground1.k/(0.457*B+dt);
Real alfa = 1.5-12/(2*3.14)*atan(dt/(dt+delta));
Real beta = 1.5-0.42*log(delta/(dt+1));
Real delta = sqrt(3.15*10^7*ground1.k/3.14/ground1.rho/ground1.c);
Real Lpi = AWall*ground1.k/dt*sqrt(1/((1+delta/dt)^2+1));
Real Lpe = 0.37*PWall*ground1.k*log(delta/dt+1);
Real m = 12*time/31536000;

protected
  IDEAS.Buildings.Components.BaseClasses.MultiLayerOpaque layMul(
    A=AWall,
    inc=inc,
    nLay=constructionType.nLay,
    mats=constructionType.mats)
    "Declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection intCon(A=AWall, inc=inc)
    "Convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.MultiLayerOpaque layGro(
    A=AWall,
    inc=inc,
    nLay=3,
    mats={ground1,ground2,ground3})
    "Declaration of array of resistances and capacitances for ground simulation"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

public
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow periodicFlow(T_ref=
        284.15)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,-8})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TGro
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
equation
periodicFlow.Q_flow = Qm;
TGro.T = sim.Tground;

  connect(layMul.port_b, intCon.port_a)       annotation (Line(
      points={{10,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layGro.port_b, layMul.port_a)             annotation (Line(
      points={{-20,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TGro.port, layGro.port_a)                  annotation (Line(
      points={{-50,-30},{-40,-30}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(intCon.port_b, surfCon_a) annotation (Line(
      points={{40,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, surfRad_a) annotation (Line(
      points={{10,-30},{16,-30},{16,-60},{50,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw_a) annotation (Line(
      points={{10,-22},{14,-22},{14,30},{56,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw_a) annotation (Line(
      points={{10,-26},{16,-26},{16,0},{56,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.port_gain[constructionType.locGain], port_emb) annotation (Line(
      points={{0,-40},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_a, periodicFlow.port) annotation (Line(
      points={{-10,-30},{-14,-30},{-14,-8},{-20,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.area, area_a) annotation (Line(
      points={{0,-20},{0,60},{56,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},
            {50,100}}),
                   graphics={
        Rectangle(
          extent={{-50,-90},{50,-70}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-50,-20},{-30,-20},{-30,-70},{-30,-70},{-30,-70}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-50,-90},{-50,-90}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-30,60},{-30,80},{50,80}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-50,66},{-50,100},{50,100}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-44,60},{-44,-20}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-70},{50,-70}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}),
                                         graphics));
end SlabOnGround;
