within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses.Functions;
function convectionResistanceCircularPipe
  "Thermal resistance from the fluid in pipes and the grout zones (Bauer et al. 2011)"

  // Geometry of the borehole
  input Modelica.SIunits.Height hSeg "Height of the element";
  input Modelica.SIunits.Radius rBor "Radius of the borehole";
  input Modelica.SIunits.Radius rTub "Tube radius";
  input Modelica.SIunits.Length eTub "Tube thickness";
  // thermal properties
  input Modelica.SIunits.ThermalConductivity kMed
    "Thermal conductivity of the fluid";
  input Modelica.SIunits.DynamicViscosity muMed
    "Dynamic viscosity of the fluid";
  input Modelica.SIunits.SpecificHeatCapacity cpMed
    "Specific heat capacity of the fluid";
  input Modelica.SIunits.MassFlowRate m_flow "Mass flow rate";
  input Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal mass flow rate";

  // Outputs
  output Modelica.SIunits.ThermalResistance RFluPip
    "Convection resistance (or conduction in fluid if no mass flow)";

protected
  parameter Modelica.SIunits.Radius rTub_in = rTub - eTub;
  Modelica.SIunits.CoefficientOfHeatTransfer h
    "Convective heat transfer coefficient of the fluid";

  Real k(unit="s/kg")
    "Coefficient used in the computation of the convective heat transfer coefficient";
  Modelica.SIunits.MassFlowRate m_flow_abs = IBPSA.Utilities.Math.Functions.spliceFunction(m_flow,-m_flow,m_flow,m_flow_nominal/30);
  Real Re "Reynolds number";
  Real Nu10k "Nusselt at Re=10000";
  Real Nu "Nusselt";

algorithm
  // Convection resistance and Reynolds number
  k := 2/(muMed*Modelica.Constants.pi*rTub_in);
  Re := m_flow_abs*k;

  if Re>=10000 then
    // Turbulent, fully-developped flow in a smooth circular pipe with
    // Dittus-Boelter correlation: h = 0.023*k_f*Re*Pr/(2*rTub)
    // Re = rho*v*DTub / mue_f
    //    = m_flow/(pi r^2) * DTub/mue_f = 2*m_flow / ( mue*pi*rTub)
    Nu := 0.023*(cpMed*muMed/kMed)^(0.35)*
      IBPSA.Utilities.Math.Functions.regNonZeroPower(
        x=Re,
        n=0.8,
        delta=0.01*m_flow_nominal*k);
  else
    // Laminar, fully-developped flow in a smooth circular pipe with uniform
    // imposed temperature: Nu=3.66 for Re<=2300. For 2300<Re<10000, a smooth
    // transition is created with the splice function.
    Nu10k := 0.023*(cpMed*muMed/kMed)^(0.35)*(10000)^(0.8);
    Nu := IBPSA.Utilities.Math.Functions.spliceFunction(Nu10k,3.66,Re-(2300+10000)/2,((2300+10000)/2)-2300);
  end if;
  h := Nu*kMed/(2*rTub_in);

  RFluPip := 1/(2*Modelica.Constants.pi*rTub_in*hSeg*h);

  annotation (Diagram(graphics), Documentation(info="<html>
<p>
This model computes the convection resistance in the pipes of a borehole segment 
with heigth <i>h<sub>Seg</sub></i>.
</p>
<p>
If the flow is laminar (<i>Re &le; 2300</i>, with <i>Re</i> being the Reynolds number of the flow),
the Nusselt number of the flow is assumed to be constant at 3.66. If the flow is turbulent (<i>Re &ge; 10,000</i>),
the correlation of Dittus-Boelter is used to find the convection heat transfer coefficient as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Nu = 0.023 &nbsp; Re<sup>0.8</sup> &nbsp; Pr<sup>n</sup>,
</p>
<p>
where <i>Nu</i> is the Nusselt number and 
<i>Pr</i> is the Prandlt number.
We selected <i>n=0.35</i>, as the reference uses <i>n=0.4</i> for heating and 
<i>n=0.3</i> for cooling. For the range <i>2300 &lt; Re &lt; 10,000</i>, a smooth
transition is created between the laminar and turbulent values.
</p>
</html>", revisions="<html>
<p>
<ul>
<li>
February 14, 2014, by Michael Wetter:<br/>
Removed unused input <code>rBor</code>.
Revised documentation.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation. 
Changed <code>cpFluid</code> to <code>cpMed</code> to use consistent notation.
Added regularization for computation of convective heat transfer coefficient to
avoid an event and a non-differentiability.
</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</p>
</html>"));
end convectionResistanceCircularPipe;
