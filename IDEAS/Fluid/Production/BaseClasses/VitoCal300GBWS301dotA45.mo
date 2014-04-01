within IDEAS.Fluid.Production.BaseClasses;
record VitoCal300GBWS301dotA45
  "Viessmann Vitocal 300-G, type BW 301.A45 heat pump data"
  extends OnOffHeatPumpData(
  mBrine=12.7,
  mFluid=12.7,
  m_flow_nominal_brine=1.8,
  m_flow_nominal_fluid=1,
  dp_nominal_brine=20000,
  dp_nominal_fluid=6000,
  G=680/15,
  copData(
    T_cond={308.15,318.15,328.15,333.15},
    T_evap={268.15,273.15,275.15,283.15,288.15, 293.15},
    result={{3.9,   4.6,  4.78, 5.5,   6.49, 6.98, 7.40},
            {3.09,  3.52, 3.7,  4.44,  5.02, 5.65, 6.33},
            {2.76,  2.76, 2.81, 3.4,   3.86, 4.36, 4.81},
            {2,     2.3,  2.46, 2.94,  3.36, 3.81, 4.26}}),
    powerData(
    T_cond={308.15,318.15,328.15,333.15},
    T_evap={268.15,273.15,275.15,283.15,288.15, 298.15},
    result={{9670, 9280, 9560, 10700, 10170, 10190},
            {11640, 11800, 11810, 11850, 11850, 12000},
            {14380, 14380, 14310, 14330, 14230, 14194},
            {15790, 15790, 15790, 15750, 15690, 15484}}));
  annotation (Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end VitoCal300GBWS301dotA45;
