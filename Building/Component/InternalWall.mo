within IDEAS.Building.Component;
model InternalWall "interior opaque wall between two zones"

extends IDEAS.Building.Elements.StateWallInt;

parameter Modelica.SIunits.Area A "wall area";
parameter Integer nLay(min=1) "number of material layers";
parameter Integer locGain(min=1) = 1 "location of possible embedded system";

replaceable parameter IDEAS.Building.Elements.Material mats[nLay]
    "array of materials"                                                               annotation(AllMatching=true);
parameter Real inc "inclination";

  Modelica.Blocks.Interfaces.RealOutput area "output of the area"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,100})));

protected
  IDEAS.Building.Component.Elements.InteriorConvection intCon_b(A=A, inc=
        inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  IDEAS.Building.Component.Elements.InteriorConvection intCon_a(A=A, inc=
        inc + Modelica.Constants.pi)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  IDEAS.Building.Component.Elements.MultiLayerOpaque   layMul(
    A=A,
    inc=inc,
    nLay=nLay,
    mats=mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_gain
    "port for gains by embedded active layers"
  annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

equation
area = A;

  connect(intCon_a.port_b, port_a)
                                  annotation (Line(
      points={{60,0},{80,0},{80,-20},{100,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon_b.port_b, port_b)
                                  annotation (Line(
      points={{-60,0},{-80,0},{-80,-20},{-100,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_a, iEpsLwa) annotation (Line(
      points={{20,16},{24,16},{24,60},{100,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLwb) annotation (Line(
      points={{-20,16},{-26,16},{-26,60},{-100,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intCon_b.port_a, layMul.port_b)
                                        annotation (Line(
      points={{-40,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_a, intCon_a.port_a)
                                        annotation (Line(
      points={{20,0},{40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_a, iEpsSwa) annotation (Line(
      points={{20,8},{30,8},{30,20},{100,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSwb) annotation (Line(
      points={{-20,8},{-32,8},{-32,20},{-100,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_bRad, layMul.port_b) annotation (Line(
      points={{-100,-60},{-32,-60},{-32,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_a, port_aRad) annotation (Line(
      points={{20,0},{30,0},{30,-60},{100,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_gain[locGain], port_gain) annotation (Line(
      points={{0,-20},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));

end InternalWall;
