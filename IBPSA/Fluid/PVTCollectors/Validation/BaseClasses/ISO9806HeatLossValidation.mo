within IBPSA.Fluid.PVTCollectors.Validation.BaseClasses;
model ISO9806HeatLossValidation
  "Validation variant with term‑by‑term breakdown of ISO9806:2017 standard thermal heat loss"
  extends .IBPSA.Fluid.PVTCollectors.BaseClasses.ISO9806HeatLoss;

  // Diagnostic variables
  .Modelica.Units.SI.Power a1_a2_term "Contribution from a1_a2 term";
  .Modelica.Units.SI.Power a3_term "Contribution from wind-speed dependence (a3)";
  .Modelica.Units.SI.Power a4_term "Contribution from sky long-wave (a4)";
  .Modelica.Units.SI.Power a6_term "Contribution from wind–irradiance coupling (a6)";
  .Modelica.Units.SI.Power a7_term "Contribution from wind–irradiance dependence of IR radiation exchange (a7)";
  .Modelica.Units.SI.Power a8_term "Contribution from radiation losses (a8)";
  .Modelica.Units.SI.Irradiance EL_term "Sky long-wave irradiance difference (HHorIR – σ·TEnv⁴)";

  // Cumulative sums
  .Modelica.Units.SI.Power pvt_st_st "a1_a2";
  .Modelica.Units.SI.Power pvt_a3 "a1_a2 + a3";
  .Modelica.Units.SI.Power pvt_a4 "a1_a2 + a3 + a4";
  .Modelica.Units.SI.Power pvt_a6 "a1_a2 + a3 + a4 + a6";
  .Modelica.Units.SI.Power pvt_a7 "a1_a2 + a3 + a4 + a6 + a7";
  .Modelica.Units.SI.Power pvt_a8 "a1_a2 + a3 + a4 + a6 + a7 + a8";

equation
  // term-by-term breakdown
  a1_a2_term = sum(A_c/nSeg * {dT[i]*(a1 - a2*dT[i]) for i in 1:nSeg});
  a3_term = sum(A_c/nSeg * {dT[i]*a3*(winSpePla-3) for i in 1:nSeg});
  a4_term = sum(A_c/nSeg * {a4*(HHorIR - .Modelica.Constants.sigma*TEnv^4) for i in 1:nSeg});
  a6_term = sum(A_c/nSeg * {-a6*(winSpePla-3)*HGloTil for i in 1:nSeg});
  a7_term = sum(A_c/nSeg * {-a7*(winSpePla-3)*(HHorIR - .Modelica.Constants.sigma*TEnv^4)     for i in 1:nSeg});
  a8_term = sum(A_c/nSeg * {-a8*(dT[i])^4 for i in 1:nSeg});
  EL_term = HHorIR - .Modelica.Constants.sigma*TEnv^4;

  // cumulative contributions
  pvt_st_st = a1_a2_term;
  pvt_a3 = pvt_st_st + a3_term;
  pvt_a4 = pvt_a3 + a4_term;
  pvt_a6 = pvt_a4 + a6_term;
  pvt_a7 = pvt_a6 + a7_term;
  pvt_a8 = pvt_a7 + a8_term;

  annotation (
    defaultComponentName="heaLosStcVal",
    Documentation(info="
<html>
<p>
Extends from the standard quasi‑dynamic heat‑loss model 
(<a href=\"modelica://IBPSA.Fluid.PVTCollectors.BaseClasses.ISO9806HeatLoss\">IBPSA.Fluid.PVTCollectors.BaseClasses.ISO9806QuasiDynamicHeatLoss</a>).  
For validation purposes, this block adds:
</p>
<ul>
<li>
A term‑by‑term breakdown of each thermal loss contribution;
</li>
<li>
Cumulative sums showing how each additional term builds up to the total heat loss.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
March 11, 2026, by Lone Meertens:<br/>
Updated thermal formulation from ISO 9806:2013 to ISO 9806:2017. 
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation PVT model. 
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">#1436</a>.
</li>
</ul>
</html>"));
end ISO9806HeatLossValidation;
