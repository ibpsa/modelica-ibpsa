within IDEAS.Buildings.Components.BaseClasses;
model MonoLayerLucent "single non-opaque layer"

  parameter Modelica.SIunits.Area A "surface area";
  parameter IDEAS.Buildings.Data.Interfaces.Material mat "material";
  parameter Modelica.SIunits.Angle inc "Inclination angle";

  parameter Modelica.SIunits.Emissivity epsLw_a
    "Longwave emissivity of material connected at port_a";
  parameter Modelica.SIunits.Emissivity epsLw_b
    "Longwave emissivity on material connected at port_b";

  final parameter Modelica.SIunits.ThermalInsulance R=mat.R
    "Total specific thermal resistance";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_gain
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  IDEAS.Buildings.Components.BaseClasses.AirCavity airCavity(
    A=A,
    inc=inc,
    epsLw_a=epsLw_a,
    epsLw_b=epsLw_b,
    d=mat.d,
    dT_nominal=5,
    k=mat.k) if mat.gas
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

protected
  final parameter Modelica.SIunits.ThermalConductance G = A/R
    "Thermal conductance";
equation
  if not mat.gas then
    port_gain.T=(port_a.T+port_b.T)/2;
    port_a.Q_flow + port_b.Q_flow + port_gain.Q_flow = 0;
    port_a.Q_flow = G*(port_a.T - port_b.T);
  end if;

  connect(airCavity.port_emb, port_gain)
    annotation (Line(points={{0,10},{0,100}},         color={191,0,0}));
  connect(airCavity.port_a, port_a)
    annotation (Line(points={{-10,0},{-60,0},{-100,0}}, color={191,0,0}));
  connect(airCavity.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}},         color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(graphics={Rectangle(
          extent={{-90,80},{90,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),Text(
          extent={{-150,113},{150,73}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(info="<html>
<p>For the purpose of dynamic building simulation, the partial differential equation of the continuous time and space model of heat transport through a solid is most often simplified into ordinary differential equations with a finite number of parameters representing only one-dimensional heat transport through a construction layer. Within this context, the wall is modeled with lumped elements, i.e. a model where temperatures and heat fluxes are determined from a system composed of a sequence of discrete resistances and capacitances R_{n+1}, C_{n}. The number of capacitive elements $n$ used in modeling the transient thermal response of the wall denotes the order of the lumped capacitance model.</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-pqp0E04K.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-I7KXJhSH.png\"/> is the added energy to the lumped capacity, <img src=\"modelica://IDEAS/Images/equations/equation-B0HPmGTu.png\"/> is the temperature of the lumped capacity, <img src=\"modelica://IDEAS/Images/equations/equation-t7aqbnLB.png\"/> is the thermal capacity of the lumped capacity equal to<img src=\"modelica://IDEAS/Images/equations/equation-JieDs0oi.png\"/> for which rho denotes the density and <img src=\"modelica://IDEAS/Images/equations/equation-ml5CM4zK.png\"/> is the specific heat capacity of the material and <img src=\"modelica://IDEAS/Images/equations/equation-hOGNA6h5.png\"/> the equivalent thickness of the lumped element, where <img src=\"modelica://IDEAS/Images/equations/equation-1pDREAb7.png\"/> the heat flux through the lumped resistance and <img src=\"modelica://IDEAS/Images/equations/equation-XYf3O3hw.png\"/> is the total thermal resistance of the lumped resistance and where <img src=\"modelica://IDEAS/Images/equations/equation-dgS5sGAN.png\"/> are internal thermal source.</p>
</html>", revisions="<html>
<ul>
<li>
September 2, 2015, by Filip Jorissen:<br/>
epsLw is now defined as part of the material property of the solid layer, 
instead of the gas layer.
EpsLw_a and epsLw_b must therefore be defined as a parameter on the upper level.
</li>
</ul>
</html>"));
end MonoLayerLucent;
