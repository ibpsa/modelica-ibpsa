within IDEAS.Buildings.Components.BaseClasses;
model MonoLayerLucent "single non-opaque layer"

  parameter Modelica.SIunits.Area A "surface area";
  parameter IDEAS.Buildings.Data.Interfaces.Material mat "material";
  parameter Modelica.SIunits.Angle inc "inclination";

  parameter Modelica.SIunits.Emissivity epsLw_a=mat.epsLw_a
    "longwave emissivity on exterior side";
  parameter Modelica.SIunits.Emissivity epsLw_b=mat.epsLw_b
    "longwave emissivity on interior side";

  final parameter Real R=mat.R "Total specific thermal resistance";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_gain
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(T(start=293.15))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(T(start=293.15))
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  /*
  The effective Nusselt nuber is to be calculated as :
  
  Real beta=1/((port_a.T + port_b.T)/2) 
    "thermal expansion coefficient of the mterial, if a gas";
  Real Gr=if mat.gas then 9.81*beta*(mat.rho^2)*(mat.d^3)/(mat.mhu^2)*abs(
      port_a.T - port_b.T) else 0 "Grrashof number";
  Real Nu = if mat.gas then IDEAS.BaseClasses.Math.MaxSmooth(1,0.0384*abs(Gr)^(0.37),0.01) else 1 
    "Nusselt number";
  Real h =  mat.k/mat.d*Nu;

  But no influence is found on the results of the simulation, whereas removing this equation and 
  setting Nu equal to 1 speeds up the simuation significantly (eg. by 30 per cent)
*/

equation
  port_gain.T = 293.15;
  port_a.Q_flow + port_b.Q_flow + port_gain.Q_flow = 0 "no heat is stored";

  if mat.gas then
//    port_a.Q_flow = A/R*(port_a.T - port_b.T) + A*Modelica.Constants.sigma*(1/(
//      (1/epsLw_a) + (1/epsLw_b) - 1))*(port_a.T^4 - port_b.T^4);
    port_a.Q_flow = A/R*(port_a.T - port_b.T) + A*5.86*(1/(
      (1/epsLw_a) + (1/epsLw_b) - 1))*(port_a.T - port_b.T);
  else
    port_a.Q_flow = A*(port_a.T - port_b.T)/R;
  end if;

  annotation (
    Diagram(graphics),
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
</html>"));
end MonoLayerLucent;
