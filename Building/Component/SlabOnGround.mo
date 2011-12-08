within IDEAS.Building.Component;
model SlabOnGround "opaque floor on ground slab"

extends IDEAS.Building.Elements.StateWallGround;

final parameter IDEAS.Building.Data.Materials.Ground ground1(d=0.50);
final parameter IDEAS.Building.Data.Materials.Ground ground2(d=0.33);
final parameter IDEAS.Building.Data.Materials.Ground ground3(d=0.17);

parameter Modelica.SIunits.Area A "floor area";
parameter Modelica.SIunits.Length P "floor perimeter";
parameter Integer nLay(min=1) "number of material layers";
parameter Integer locGain(min=1) = 1 "location of possible embedded system";
replaceable parameter IDEAS.Building.Elements.Material mats[nLay]
    "array of materials";
parameter Modelica.SIunits.Angle inc "inclination";
parameter Modelica.SIunits.Angle azi = 0 "azimuth";

public
IDEAS.Building.Component.Elements.SummaryWall summary(Qloss = -port_b.Q_flow - port_bRad.Q_flow, QSolIrr = 0)
    "Summary of the thermal response";

Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_gain
    "port for gains by embedded active layers"
  annotation (Placement(transformation(extent={{90,-90},{110,-70}})));

protected
Modelica.SIunits.HeatFlowRate Qm = U*A*(22-9)-Lpi*4*cos(2*3.1415/12*(m-1+alfa))+Lpe*9*cos(2*3.1415/12*(m-1-beta));

Modelica.SIunits.Length B = A/(0.5*P)
    "characteristic dimension of the slab on ground";
Modelica.SIunits.Length dt = sum(mats.d)+ground1.k*layMul.R
    "equivalent thickness";
Real U = ground1.k/(0.457*B+dt);
Real alfa = 1.5-12/(2*3.14)*atan(dt/(dt+delta));
Real beta = 1.5-0.42*log(delta/(dt+1));
Real delta = sqrt(3.15*10^7*ground1.k/3.14/ground1.rho/ground1.c);
Real Lpi = A*ground1.k/dt*sqrt(1/((1+delta/dt)^2+1));
Real Lpe = 0.37*P*ground1.k*log(delta/dt+1);
Real m = 12*time/31536000;

protected
  IDEAS.Building.Component.Elements.MultiLayerOpaque layMul(
    A=A,
    inc=inc,
    nLay=nLay,
    mats=mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  IDEAS.Building.Component.Elements.InteriorConvection intCon(A=A, inc=inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  IDEAS.Building.Component.Elements.MultiLayerOpaque layGro(
    A=A,
    inc=inc,
    nLay=3,
    mats={ground1,ground2,ground3})
    "declaration of array of resistances and capacitances for ground simulation"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

public
  Modelica.Blocks.Interfaces.RealOutput area
    "output of the area for calculation of radiation in zones"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,100})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow periodicFlow(T_ref=
        284.15)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-32,40})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
equation
periodicFlow.Q_flow = Qm;
area = A;
prescribedTemperature.T = sim.Tground;

  connect(layMul.port_b, intCon.port_a)       annotation (Line(
      points={{20,0},{40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon.port_b, port_b)
                                annotation (Line(
      points={{60,0},{80,0},{80,20},{100,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, port_bRad)        annotation (Line(
      points={{20,0},{30,0},{30,-20},{100,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layGro.port_b, layMul.port_a)             annotation (Line(
      points={{-40,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_gain[locGain], port_gain)        annotation (Line(
      points={{0,-20},{0,-80},{100,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw)        annotation (Line(
      points={{20,16},{26,16},{26,52},{-20,52},{-20,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw)        annotation (Line(
      points={{20,8},{34,8},{34,60},{20,60},{20,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(periodicFlow.port, layMul.port_a)       annotation (Line(
      points={{-32,30},{-32,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, layGro.port_a) annotation (Line(
      points={{-70,0},{-60,0}},
      color={191,0,0},
      smooth=Smooth.None));

end SlabOnGround;
