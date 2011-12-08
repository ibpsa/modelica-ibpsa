within IDEAS.Building.Component;
model CommonWall "common opaque wall with neighbors"

extends IDEAS.Building.Elements.StateWallExt;

parameter Modelica.SIunits.Area A "wall area";
parameter Integer nLay(min=1) "number of material layers";
replaceable parameter IDEAS.Building.Elements.Material mats[nLay]
    "array of materials" annotation(AllMatching=true);
parameter Real inc "inclination";
parameter Real azi "azimuth";

//port_nb.Qdesign = A*(port_nb.Tset-sim.Tdes)/(layerMultiple.R+0.11+0.29);
/*the -8°C must be set parameter in the SIM*/

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        294.15)
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Modelica.Blocks.Interfaces.RealOutput area "output of the area"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,100})));

protected
  IDEAS.Building.Component.Elements.MultiLayerOpaque   layMul(
    A=A,
    inc=inc,
    nLay=nLay,
    mats=mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  IDEAS.Building.Component.Elements.InteriorConvection intCon_b(A=A, inc=
        inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  IDEAS.Building.Component.Elements.InteriorConvection intCon_a(A=A, inc=
        inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));

equation
  area = A;

  connect(layMul.iEpsLw_b, iEpsLw) annotation (Line(
      points={{20,16},{24,16},{24,56},{-20,56},{-20,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw) annotation (Line(
      points={{20,8},{32,8},{32,64},{0,64},{0,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.port_b, intCon_b.port_a)
                                      annotation (Line(
      points={{20,0},{40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon_b.port_b, port_b)
                               annotation (Line(
      points={{60,0},{90,0},{90,20},{100,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, port_bRad) annotation (Line(
      points={{20,0},{30,0},{30,-20},{100,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, intCon_a.port_b) annotation (Line(
      points={{-68,0},{-60,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon_a.port_a, layMul.port_a) annotation (Line(
      points={{-40,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
    annotation (Diagram(graphics), Icon(graphics));
end CommonWall;
