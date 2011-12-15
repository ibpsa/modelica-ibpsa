within IDEAS.Buildings.Components.BaseClasses;
model MonoLayerOpaque "single material layer"

  parameter Modelica.SIunits.Area A "Layer area";
  parameter IDEAS.Buildings.Data.Interfaces.Material mat "Layer material";
  parameter Modelica.SIunits.Angle inc "Inclination";

  final parameter Real R = mat.d / mat.k "Total specific thermal resistance";
  final parameter Integer nRes = mat.nState * 2
    "Number of resistors in the RC-network";
  final parameter Integer nCap = mat.nState * 2 - 1
    "Odd number of capacitors in the RC-network";

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_gain
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(T(start=289.15))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(T(start=289.15))
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nRes] Res(each final G=A/mat.d*mat.k*nRes)
    "Resistors in the RC-network"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[nCap] Cap(each final C=A*mat.rho*mat.c*mat.d/nCap)
    "Capacitors in the RC-network"
    annotation (Placement(transformation(extent={{-10,0},{10,-20}})));

equation
connect(port_a, Res[1].port_a) annotation (Line(
      points={{-100,0},{-40,0}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
for k in 1:nCap loop
  connect(Res[k].port_b, Cap[k].port) annotation (Line(
      points={{-20,0},{0,0}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(Cap[k].port, Res[k+1].port_a) annotation (Line(
      points={{0,0},{20,0},{20,-30},{-60,-30},{-60,0},{-40,0}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
end for;
 connect(Res[nRes].port_b, port_b) annotation (Line(
      points={{-20,0},{100,0}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(port_gain, Cap[mat.nState].port) annotation (Line(
      points={{0,100},{0,0}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-90,80},{90,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Text(
          extent={{-150,113},{150,73}},
          textString="%name",
          lineColor={0,0,255}),
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
end MonoLayerOpaque;
