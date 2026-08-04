within IBPSA.Fluid.PVTCollectors.Data.Uncovered;
record UI_Validation =
  .IBPSA.Fluid.PVTCollectors.Data.Generic(
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
    final IAMDiff=(0.475*1-3*0.003)/(0.475-3*0.003),
    final eta0=0.475-3*0.003,
    final a1=7.411+3*1.7,
    final a2=0.0,
    final a3=1.7,
    final a4=0.437,
    final a6=0.003,
    final a7=0.0,
    final a8=0.0,
    final P_nominal=280,
    final beta=-0.0041,
    final etaEl=0.1687)
  "Parameters for an uncovered flat-plate PVT collector with rear cover and back-side thermal insulation"
annotation(
  defaultComponentPrefixes = "parameter",
  defaultComponentName     = "datPVTCol",
  Documentation(info="<html>
<p>
This record contains anonymized thermal and electrical performance parameters for
an <b>uncovered</b> photovoltaic–thermal (PVT) collector <b>with rear insulation</b>.  
The collector was originally tested under ISO 9806:2013 conditions and subsequently 
converted to the ISO 9806:2017 quasi‑dynamic formulation used by 
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.PVTCollector\">
IBPSA.Fluid.PVTCollectors.PVTCollector</a>, using the Excel conversion file located at 
<code>IBPSA.Resources.Data.Fluid.PVTCollectors</code>.  
Thermal performance parameters correspond to operation of the collector in maximum 
power point (MPP) mode.
</p>
<p>
This datasheet is used in the validation of 
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.PVTCollector\">IBPSA.Fluid.PVTCollectors.PVTQuasiDynamicCollector</a>, 
which can be found in the 
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.Validation.PVT_UI\">IBPSA.Fluid.PVTCollectors.Validation.PVT_UI</a> package. 
</p>

<h4>References</h4>
<li>
ISO 9806:2017. <i><a href='https://www.iso.org/standard/67978.html'>Solar thermal collectors — Test methods</a></i>. ISO.
</li>
<li>
IEA SHC Task 60 (2018). <i>PVT Systems: Application of PVT Collectors and New Solutions in HVAC Systems</i>.
<a href=\"https://www.iea-shc.org/task60\">iea-shc.org/task60</a>.
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
