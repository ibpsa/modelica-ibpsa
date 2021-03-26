within IBPSA.Airflow.Multizone.BaseClasses;
partial model PowerLawResistance_mflow
  "Partial model for mass flow resistance that uses the power law"
  extends IBPSA.Airflow.Multizone.BaseClasses.PartialOneWayFlowElement( final m_flow_nominal=Modelica.Constants.small);
  // fixme : Partial models usually start with Partial... (for example, PartialPowerLawResistance_mflow). I am not sure if this is a strict requirement (PowerLawResistance does not start with Partial).
  // fixme : The nomenclature is not uniform in the Multizone package. Some models use _MassFlow and others use _m_flow.

  parameter Real m(min=0.5, max=1)=0.66
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";

  parameter Real k=0.000015223 "Flow coefficient, k = m_flow/ dp^m";
  // fixme : Is it correct for the parameter to have the same default value as in the volume flow case (in PowerLawResistance)?
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

// fixme : Equations are presented in subsection 3 of "Documentation" in the style guide (https://github.com/ibpsa/modelica-ibpsa/wiki/Style-Guide)
// fixme : Hyperlinks are presented in subsection 7 of "Documentation" in the style guide (https://github.com/ibpsa/modelica-ibpsa/wiki/Style-Guide)
// fixme : I have edited the documentation below for both.
  annotation (
    Documentation(info="<html>
<p>This model describes the mass flow rate and pressure difference relation in the form </p>
<p align=\"center\" style=\"font-style:italic;\">
m_flow = k * dp^m,
</p>
<p>where <i>k</i> and <i>m</i> are parameters. For turbulent flow, set <i>m=1/2</i> and for laminar flow, set <i>m=1</i>. </p>
<p>The model is used as a base for the interzonal air flow models. </p>
</html>",
revisions="<html>
<ul>
<li>
Jun 26, 2020, by Klaas De Jonge:<br/>
Power law resistance describing mass flow. This model is the same as <a href=\"modelica://IBPSA.Airflow.Multizone.BaseClasses.PowerLawResistance\"> IBPSA.Airflow.Multizone.BaseClasses.PowerLawResistance</a> but with the mass flow rate as a function of dP in stead of volume flow rate
</li>
</ul>
</html>"));
end PowerLawResistance_mflow;
