within IBPSA.Airflow.Multizone.BaseClasses;
partial model PowerLawResistance_mflow
  "partial for Mass Flow resistance that uses the power law"
  extends IBPSA.Airflow.Multizone.BaseClasses.PartialOneWayFlowelement( final m_flow_nominal=Modelica.Constants.small);

parameter Real m(min=0.5, max=1)=0.66
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";

  parameter Real k=0.000015223 "Flow coefficient, k = m_flow/ dp^m";
protected
  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";

  parameter Real a = gamma
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b = 1/8*m^2 - 3*gamma - 3/2*m + 35.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real c = -1/4*m^2 + 3*gamma + 5/2*m - 21.0/4
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real d = 1/8*m^2 - gamma - m + 15.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
equation

  m_flow = IBPSA.Airflow.Multizone.BaseClasses.powerLawFixedM(
    k=k,
    dp=dp,
    m=m,
    a=a,
    b=b,
    c=c,
    d=d,
    dp_turbulent=dp_turbulent);


  annotation (
    Documentation(info="<html>
<p>This model describes the mass flow rate and pressure difference relation in the form </p>
<p>m_flow = k * dp^m,</p>
<p>where k  and m are parameters. For turbulent flow, set m=1/2 and for laminar flow, set m=1. </p>
<p>The model is used as a base for the interzonal air flow models. </p>
</html>",
revisions="<html>
<ul>
<li>
Jun 26, 2020, by Klaas De Jonge:<br/>
Powerlaw resistance describing mass flow. This model is the same as PowerLawResistance but with the mass flow rate as a function of dP in stead of volume flow rate
</li>
</ul>
</html>"));
end PowerLawResistance_mflow;
