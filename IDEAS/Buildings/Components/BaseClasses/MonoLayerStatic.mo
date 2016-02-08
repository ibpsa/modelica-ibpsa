within IDEAS.Buildings.Components.BaseClasses;
model MonoLayerStatic "Static layer for uniform solid."

  parameter Modelica.SIunits.ThermalInsulance R = mat.R
    "Total specific thermal resistance";

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor  monoLaySolSta_a(R=R/2)
    "Static monolayer for solid"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_gain
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor monoLaySolSta_b(G=R/2)
    "Static monolayer for solid"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  connect(monoLaySolSta_a.port_b, monoLaySolSta_b.port_a)
    annotation (Line(points={{-40,0},{40,0}}, color={191,0,0}));
  connect(port_gain, monoLaySolSta_b.port_a) annotation (Line(points={{0,100},{0,
          100},{0,16},{0,0},{40,0}}, color={191,0,0}));
  connect(monoLaySolSta_a.port_a, port_a)
    annotation (Line(points={{-60,0},{-100,0},{-100,0}}, color={191,0,0}));
  connect(monoLaySolSta_b.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(graphics={
        Rectangle(
          extent={{-86,80},{24,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Text(
          extent={{-150,-69},{150,-109}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{24,80},{44,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Forward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{44,80},{84,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{24,80},{24,-80}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{44,80},{44,-80}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Ellipse(
          extent={{-36,-42},{44,38}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-39,40},{39,-40}},
          lineColor={127,0,0},
          fontName="Calibri",
          origin={4,-1},
          rotation=90,
          textString="S")}));
end MonoLayerStatic;
