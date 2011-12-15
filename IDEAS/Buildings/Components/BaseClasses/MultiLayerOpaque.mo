within IDEAS.Buildings.Components.BaseClasses;
model MultiLayerOpaque "multiple material layers in series"

  parameter Modelica.SIunits.Area A "total multilayer area";
  parameter Modelica.SIunits.Angle inc "inclination";
  parameter Integer nLay(min=1) "number of layers";
  parameter IDEAS.Buildings.Data.Interfaces.Material mats[nLay]
    "array of layer materials";

  IDEAS.Buildings.Components.BaseClasses.MonoLayerOpaque[nLay] nMat(
    each final A=A,
    each final inc=inc,
    mat=mats) "layers";

  final parameter Real R = sum(nMat.R) "total specific thermal resistance";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nLay] port_gain
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(T(start=289.15))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(T(start=289.15))
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsLw_b
    "output of the interior emissivity for radiative heat losses"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsSw_b
    "output of the interior emissivity for radiative heat losses"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsLw_a
    "output of the interior emissivity for radiative heat losses"
    annotation (Placement(transformation(extent={{-90,70},{-110,90}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsSw_a
    "output of the interior emissivity for radiative heat losses"
    annotation (Placement(transformation(extent={{-90,30},{-110,50}})));

equation
connect(port_a,nMat[1].port_a);

  for j in 1:nLay-1 loop
    connect(nMat[j].port_b,nMat[j+1].port_a);
  end for;

connect(nMat.port_gain,port_gain);
connect(port_b,nMat[nLay].port_b);

iEpsLw_a = mats[1].epsLw;
iEpsSw_a = mats[1].epsSw;
iEpsLw_b = mats[nLay].epsLw;
iEpsSw_b = mats[nLay].epsSw;

  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-90,80},{20,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Text(
          extent={{-150,113},{150,73}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{20,80},{40,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Forward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{40,80},{80,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{20,80},{20,-80}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{40,80},{40,-80}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Ellipse(
          extent={{-40,-42},{40,38}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-39,40},{39,-40}},
          lineColor={127,0,0},
          fontName="Calibri",
          origin={0,-1},
          rotation=90,
          textString="S")}));
end MultiLayerOpaque;
