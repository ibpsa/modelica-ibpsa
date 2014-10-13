within IDEAS.Buildings.Components.BaseClasses;
model MonoLayerOpaque "single material layer"

  parameter Modelica.SIunits.Area A "Layer area";
  parameter IDEAS.Buildings.Data.Interfaces.Material mat "Layer material";
  parameter Modelica.SIunits.Angle inc "Inclination";

  parameter Modelica.SIunits.Temperature T_start=293.15
    "Start temperature for each of the states";

  final parameter Real R = mat.R "Total specific thermal resistance";

  final parameter Boolean notFictive = (mat.d <> 0);

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  MonoLayerOpaqueNf monoLayerOpaqueNf(A=A, mat=mat, inc=inc, T_start=T_start) if notFictive
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(port_a, monoLayerOpaqueNf.port_a) annotation (Line(
      points={{-100,0},{-56,0},{-56,-40},{-10,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(monoLayerOpaqueNf.port_b, port_b) annotation (Line(
      points={{10,-40},{56,-40},{56,0},{100,0}},
      color={191,0,0},
      smooth=Smooth.None));

if not notFictive then
  connect(port_a, port_b) annotation (Line(
      points={{-100,0},{100,0}},
      color={191,0,0},
      smooth=Smooth.None));
end if;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics),
    Icon(graphics={Rectangle(
          extent={{-90,80},{90,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),Text(
          extent={{-150,113},{150,73}},
          textString="%name",
          lineColor={0,0,255}),Ellipse(
          extent={{-40,-42},{40,38}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),Text(
          extent={{-39,40},{39,-40}},
          lineColor={127,0,0},
          fontName="Calibri",
          origin={0,-1},
          rotation=90,
          textString="S")}),
    Documentation(info="<html>
<p>For the purpose of dynamic building simulation, the partial differential equation of the continuous time and space model of heat transport through a solid is most often simplified into ordinary differential equations with a finite number of parameters representing only one-dimensional heat transport through a construction layer. Within this context, the wall is modeled with lumped elements, i.e. a model where temperatures and heat fluxes are determined from a system composed of a sequence of discrete resistances and capacitances R_{n+1}, C_{n}. The number of capacitive elements $n$ used in modeling the transient thermal response of the wall denotes the order of the lumped capacitance model.</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-pqp0E04K.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-I7KXJhSH.png\"/> is the added energy to the lumped capacity, <img src=\"modelica://IDEAS/Images/equations/equation-B0HPmGTu.png\"/> is the temperature of the lumped capacity, <img src=\"modelica://IDEAS/Images/equations/equation-t7aqbnLB.png\"/> is the thermal capacity of the lumped capacity equal to<img src=\"modelica://IDEAS/Images/equations/equation-JieDs0oi.png\"/> for which rho denotes the density and <img src=\"modelica://IDEAS/Images/equations/equation-ml5CM4zK.png\"/> is the specific heat capacity of the material and <img src=\"modelica://IDEAS/Images/equations/equation-hOGNA6h5.png\"/> the equivalent thickness of the lumped element, where <img src=\"modelica://IDEAS/Images/equations/equation-1pDREAb7.png\"/> the heat flux through the lumped resistance and <img src=\"modelica://IDEAS/Images/equations/equation-XYf3O3hw.png\"/> is the total thermal resistance of the lumped resistance and where <img src=\"modelica://IDEAS/Images/equations/equation-dgS5sGAN.png\"/> are internal thermal source.</p>
</html>"));
end MonoLayerOpaque;
