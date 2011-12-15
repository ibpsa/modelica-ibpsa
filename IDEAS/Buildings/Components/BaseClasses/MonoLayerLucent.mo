within IDEAS.Buildings.Components.BaseClasses;
model MonoLayerLucent "single non-opaque layer"

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
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(T(start=289.15))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(T(start=289.15))
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  Real h "conductance";
  Real beta = 1/((port_a.T+port_b.T)/2)
    "thermal expansion coefficient of the mterial, if a gas";
  Real Gr = if mat.gas then 9.81*beta*(mat.rho^2)*(mat.d^3)/(mat.mhu^2)*abs(port_a.T-port_b.T) else 0
    "Grrashof number";
  Real Nu = if mat.gas then IDEAS.BaseClasses.Math.MaxSmooth(1,0.0384*abs(Gr)^(0.37),0.01) else 1
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
        Rectangle(
          extent={{-90,80},{90,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Text(
          extent={{-150,113},{150,73}},
          textString="%name",
          lineColor={0,0,255})}));
end MonoLayerLucent;
