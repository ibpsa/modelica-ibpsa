within IBPSA.Fluid.PVTCollectors.Data.Covered;
record CI_Jonas2018 =
  .IBPSA.Fluid.PVTCollectors.Data.Generic(
    final A=1.79,
    final CTyp=.IBPSA.Fluid.SolarCollectors.Types.HeatCapacity.TotalCapacity,
    final C=16631*1.79,
    final V=5/1000,
    final mDry=26,
    final mperA_flow_nominal=0.03,
    final dp_nominal=60000,
    final incAngDat=.Modelica.Units.Conversions.from_deg({0,10,20,30,40,50,60,70,90}),
    final incAngModDat={1,1,0.99,0.98,0.97,0.95,0.92,0.88,0.00},
    final colTyp=.IBPSA.Fluid.PVTCollectors.Types.CollectorType.Covered,
    final IAMDiff=(0.573*0.94-3*0.003)/(0.573-3*0.003),
    final eta0=0.573-3*0.003,
    final a1=5.008 + 3*0.011,
    final a2=0.059,
    final a3=0.011,
    final a4=0.039,
    final a6=0.003,
    final a7=0.0,
    final a8=0.0,
    final P_nominal=280,
    final beta=-0.00370,
    final etaEl=0.1390)
  "Parameter set for a covered, insulated PVT collector based on Jonas et al. (2018)"
annotation(
  defaultComponentPrefixes = "parameter",
  defaultComponentName     = "datPVTCol",
  Documentation(info="<html>
<p>
This record contains thermal and electrical parameters for a <b>covered</b> and <b>insulated</b> PVT collector, 
based on experimental identification results from Jonas et al. (2018). 
These parameters were used in the validation of a TRNSYS PVT collector model under ISO 9806:2013 and converted 
to the ISO 9806:2017 quasi‑dynamic formulation used by <a href=\"modelica://IBPSA.Fluid.PVTCollectors.PVTCollector\">
IBPSA.Fluid.PVTCollectors.PVTCollector</a> using the Excel 
file located in <code>IBPSA/Resources/Data/Fluid/PVTCollectors</code>.
</p>
<p>
This record can be used as a generic representation of a covered, insulated PVT collector. 
However, if you know the brand and model of the PVT collector you plan to simulate or install, 
it is recommended to use the actual datasheet parameters in a custom 
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.Data.Generic\">
IBPSA.Fluid.PVTCollectors.Data.GenericQuasiDynamic</a> record.
</p>
<h4>References</h4>
<ul>
<li>
Jonas, D., Theis, D., Frey, G. (2018). <i><a href='https://doi.org/10.18086/eurosun2018.02.16'>
Implementation and Experimental Validation of a Photovoltaic-Thermal (PVT) Collector Model in TRNSYS</a></i>. 
EuroSun 2018. DOI: 10.18086/eurosun2018.02.16
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
