within IBPSA.Fluid.PVTCollectors.Validation.PVT_UN.BaseClasses;
record UN_Validation =
  .IDEAS.Fluid.PVTCollectors.Data.Generic (
    final A=1.64,
    final CTyp=.IDEAS.Fluid.SolarCollectors.Types.HeatCapacity.TotalCapacity,
    final C=22100*1.64,
    final V=1.54/1000,
    final mDry=30,
    final mperA_flow_nominal=0.02,
    final dp_nominal=300000,
    final incAngDat=.Modelica.Units.Conversions.from_deg({0,10,20,30,40,50,60,70,80,90}),
    final incAngModDat={1,1,1,1,0.99,0.97,0.92,0.80,0.55,0.00},
    final colTyp=.IDEAS.Fluid.PVTCollectors.Types.CollectorType.Uncovered,
    final IAMDiff=0.97,
    final eta0=0.499,
    final a1=11.84,
    final a2=0.0,
    final a3=0.0,
    final a4=0.0,
    final a6=0.0,
    final a7=0.0,
    final a8=0.0,
    final P_nominal=300,
    final beta=-0.00375,
    final etaEl=0.183)
  "Parameters for an uncovered flat-plate PVT collector without rear cover or back-side insulation"
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
<p>
For this PVT collector, additional real-life measurement data is publicly available (Veynandt, 2023) and has been used in the validation of 
<a href=\"modelica://IDEAS.Fluid.PVTCollectors.PVTCollector\">IDEAS.Fluid.PVTCollectors.PVTQuasiDynamicCollector</a>, 
which can be found in the 
<a href=\"modelica://IDEAS.Fluid.PVTCollectors.Validation.PVT_UN\">IDEAS.Fluid.PVTCollectors.Validation.PVT_UN</a> package. 
</p>
<h4>Certificate</h4>
<ul>
<li> <a href=\"https://www.dincertco.de/logos/011-7S2354%20P.pdf\">
Solar Keymark Licence No. 11‑7S2354 P</a>. </li>
</ul>
<h4>References</h4>
<ul>
<li>
Veynandt, François, Franz Inschlag, et al. <i><a href='https://doi.org/10.1016/j.dib.2023.109417'>
Measurement data from real operation of a hybrid photovoltaic‑thermal solar collectors, used for the development of a data‑driven model</a></i>. 
Data in Brief 49 (2023): 109417. DOI: 10.1016/j.dib.2023.109417
</li>
<li>
Veynandt, François, Peter Klanatsky, et al. <i><a href='https://doi.org/10.1016/j.enbuild.2023.113277'>
Hybrid photovoltaic‑thermal solar collector modelling with parameter identification using operation data</a></i>. 
Energy and Buildings. 295 (2023): 113277. DOI: 10.1016/j.enbuild.2023.113277
</li>
<li>
Solar Keymark Network (2019). 
<i><a href='https://solarheateurope.eu/wp-content/uploads/2019/10/SKN-N0474R0_Thermal-performance-parameter-conversion-to-the-ISO9806-2017.pdf'>
Thermal performance parameter conversion to the ISO 9806‑2017 quasi‑dynamic method</a></i>. SKN‑N0474R0
</li>
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
