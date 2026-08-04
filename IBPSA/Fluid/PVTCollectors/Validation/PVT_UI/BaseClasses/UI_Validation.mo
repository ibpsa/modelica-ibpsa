within IBPSA.Fluid.PVTCollectors.Validation.PVT_UI.BaseClasses;
record UI_Validation =
  .IBPSA.Fluid.PVTCollectors.Data.Generic (
    final A=1.66,
    final CTyp=.IBPSA.Fluid.SolarCollectors.Types.HeatCapacity.TotalCapacity,
    final C=42200*1.66,
    final V=5/1000,
    final mDry=28,
    final mperA_flow_nominal=0.03,
    final dp_nominal=60000,
    final incAngDat=.Modelica.Units.Conversions.from_deg({0,10,20,30,40,50,60,70,90}),
    final incAngModDat={1,1,1,0.99,0.99,0.98,0.96,0.92,0.00},
    final colTyp=.IBPSA.Fluid.PVTCollectors.Types.CollectorType.Uncovered,
    final IAMDiff=0.98,
    final eta0=0.475,
    final a1=12.51,
    final a2=0.0,
    final a3=0.0,
    final a4=0.0,
    final a6=0.0,
    final a7=0.0,
    final a8=0.0,
    final P_nominal=280,
    final beta=-0.0041,
    final etaEl=0.1687)
  "Parameters for an uncovered flat-plate PVT collector with rear cover and back-side thermal insulation"
annotation(
  defaultComponentPrefixes = "parameter",
  defaultComponentName     = "datPVTColVal",
  Documentation(info="<html>
<p>
For comparison with the simplified steady-state thermal formulation, this validation 
record is adapted to use the thermal coefficients <i>a<sub>1</sub></i> and 
<i>a<sub>2</sub></i> reported under the EU Ecodesign Regulation CDR&nbsp;812/2013, 
which are provided directly in the collector datasheet.
</p>
<h4>References</h4>
<ul>
<li>
Meertens, L.; Jansen, J.; Helsen, L. (2026).
<i>Development and Experimental Validation of an Open-Source 
Photovoltaic‑Thermal Collector Modelica Model that Only Needs
Datasheet Parameters</i>. Submitted to 
Mathematical and Computer Modelling of Dynamical Systems,
Special Issue on Modelica, FMI, and Open Standards.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
March 11, 2026, by Lone Meertens:<br/>
Added new record for comparing the full ISO&nbsp;9806:2017 PVT model 
with the simplified EU Ecodesign Regulation CDR&nbsp;812/2013 datasheet parameters.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
</ul>
</html>"));
