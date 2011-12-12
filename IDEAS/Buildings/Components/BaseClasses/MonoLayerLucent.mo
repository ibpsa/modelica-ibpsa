within IDEAS.Buildings.Components.BaseClasses;
model MonoLayerLucent "single non-opaque layer"

extends IDEAS.Buildings.Components.Interfaces.StateDouble;
extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Area A "surface area";
  parameter IDEAS.Buildings.Data.Interfaces.Material mat "material";
  parameter Modelica.SIunits.Angle inc "inclination";

  parameter Modelica.SIunits.Emissivity epsLw_a = 0.90
    "longwave emissivity on exterior side";
  parameter Modelica.SIunits.Emissivity epsLw_b = 0.90
    "longwave emissivity on interior side";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_gain
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

protected
  Real h "conductance";
  Real beta = 1/((port_a.T+port_b.T)/2)
    "thermal expansion coefficient of the mterial, if a gas";
  Real Gr = if mat.gas then 9.81*beta*(mat.rho^2)*(mat.d^3)/(mat.mhu^2)*abs(dT) else 0
    "Grrashof number";
  Real Nu = if mat.gas then IDEAS.BaseClasses.Math.MaxSmooth(
                                                          1,0.0384*abs(Gr)^(0.37),0.01) else 1
    "Nusselt number";

algorithm
h := mat.k/mat.d*Nu;

equation

port_a.Q_flow + port_b.Q_flow + port_gain.Q_flow = 0 "no heat is stored";
port_gain.T = 293.15;

if mat.gas then
  port_a.Q_flow = A*h*(port_a.T-port_b.T) + A*Modelica.Constants.sigma*(epsLw_a*epsLw_b)/(1-(1-epsLw_a)*(1-epsLw_b))*(port_a.T^4-port_b.T^4);
else
  port_a.Q_flow = A*h*(port_a.T-port_b.T);
end if;

  annotation (Diagram(graphics), Icon(graphics={
        Line(
          points={{-100,0},{100,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-68,10},{-28,-8}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,10},{66,-8}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{0,20},{0,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-20,44},{20,34}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,30},{20,20}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,100},{0,40}},
          color={127,0,0},
          smooth=Smooth.None)}));
end MonoLayerLucent;
