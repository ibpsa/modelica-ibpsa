within IDEAS.Buildings.Components.BaseClasses;
model MonoLayerOpaqueNf "Non-fictive single material layer"

  parameter Modelica.SIunits.Area A "Layer area";
  parameter IDEAS.Buildings.Data.Interfaces.Material mat "Layer material";
  parameter Modelica.SIunits.Angle inc "Inclination";

  parameter Modelica.SIunits.Temperature T_start=293.15
    "Start temperature for each of the states";

  final parameter Boolean present = mat.d <> 0;

  final parameter Integer nSta=mat.nSta;
  final parameter Integer nFlo=mat.nSta + 1;
  final parameter Modelica.SIunits.ThermalInsulance R = mat.R
    "Total specific thermal resistance";
  final parameter Modelica.SIunits.ThermalConductance G = (A*mat.k*nSta)/mat.d;
  final parameter Modelica.SIunits.HeatCapacity C = (A*mat.rho*mat.c*mat.d)/nSta;

  Modelica.Blocks.Interfaces.RealOutput E(unit="J") = sum(T)*C;

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.SIunits.Temperature[nSta] T(start=ones(nSta)*T_start)
    "Temperature at the states";
  Modelica.SIunits.HeatFlowRate[nFlo] Q_flow
    "Heat flow rate from state i to i+1";

equation
  // connectors
  port_a.Q_flow = +Q_flow[1];
  port_b.Q_flow = -Q_flow[nFlo];

  // edge resistances
  port_a.T - T[1] = Q_flow[1]/(G*2);
  T[nSta] - port_b.T = Q_flow[nSta + 1]/(G*2);

  // Q_flow[i] is heat flowing from (i-1) to (i)
  for i in 2:nSta loop
    T[i - 1] - T[i] = Q_flow[i]/G;
  end for;

  // Heat storages in the masses
  for i in 1:nSta loop
    der(T[i]) = (Q_flow[i] - Q_flow[i + 1])/C;
  end for;

  annotation (
    Diagram(graphics),
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
end MonoLayerOpaqueNf;
