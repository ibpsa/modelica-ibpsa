within IDEAS.Buildings.Components;
model CommonWall "common opaque wall with neighbors"

extends IDEAS.Buildings.Components.Interfaces.StateWall;

replaceable Data.Interfaces.Construction constructionType(insulationType=insulationType, insulationTickness=insulationTickness)
    "Type of building construction" annotation (choicesAllMatching = true, Placement(transformation(extent={{-38,72},
            {-34,76}})));
replaceable Data.Interfaces.Insulation insulationType
    "Type of thermal insulation" annotation (choicesAllMatching = true, Placement(transformation(extent={{-38,84},
            {-34,88}})));

parameter Modelica.SIunits.Length insulationTickness
    "Thermal insulation thickness";
parameter Modelica.SIunits.Area AWall "Total wall area";
parameter Modelica.SIunits.Angle inc
    "Inclination of the wall, i.e. 90° denotes vertical";
parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0° denotes South";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb
    "port for gains by embedded active layers"
  annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

protected
  IDEAS.Buildings.Components.BaseClasses.MultiLayerOpaque layMul(
    A=AWall,
    inc=inc,
    nLay=constructionType.nLay,
    mats=constructionType.mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection intCon_b(A=AWall, inc=
        inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection intCon_a(A=AWall, inc=
        inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{-14,-40},{-34,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        294.15)
    annotation (Placement(transformation(extent={{-58,-40},{-38,-20}})));
  Modelica.Blocks.Sources.Constant const(k=AWall)
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,0})));
equation
  connect(layMul.port_b, intCon_b.port_a)
                                      annotation (Line(
      points={{10,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, intCon_a.port_b) annotation (Line(
      points={{-38,-30},{-34,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon_a.port_a, layMul.port_a) annotation (Line(
      points={{-14,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_gain[constructionType.locGain], port_emb) annotation (Line(
      points={{0,-40},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon_b.port_b, surfCon_a) annotation (Line(
      points={{40,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, surfRad_a) annotation (Line(
      points={{10,-30},{14,-30},{14,-60},{50,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(const.y, area_a) annotation (Line(
      points={{6.73556e-016,11},{6.73556e-016,60},{56,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw_a) annotation (Line(
      points={{10,-22},{16,-22},{16,30},{56,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw_a) annotation (Line(
      points={{10,-26},{18,-26},{18,0},{56,0}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-50,
            -100},{50,100}}),
                        graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-100},{50,100}}),graphics));
end CommonWall;
