within IDEAS.Fluid.Production.BaseClasses;
record VitoCal300GBWS301dotA29
  "Viessmann Vitocal 300-G, type BW 301.A29 heat pump data"
  extends OnOffHeatPumpData(
  mBrine=9.1,
  mFluid=9.1,
  m_flow_nominal_brine=4200/3600,
  m_flow_nominal_fluid=2550/3600,
  dp_nominal_brine=12000,
  dp_nominal_fluid=4800,
  G=680/15,
  P_the_nominal = 29000,
  T_evap_min=273.15+7.5,
  T_cond_max=273.15+60,
  copData={{0, 263.15, 268.15,273.15,275.15,283.15,288.15, 293.15, 298.15},
            {308.15, 3.57, 3.7,4.83,5.06,6,7.01, 7.42, 7.76},
            {318.15, 2.67, 3.13,3.6,3.82,4.69,5.36, 5.97, 6.62},
            {328.15, 0, 0,2.68,2.86,3.59,4.06, 4.50, 4.94},
            {333.15, 0, 0, 0,2.34,3.11,3.54, 3.89, 4.26}},
  powerData={{0, 263.15, 268.15,273.15,275.15,283.15,288.15, 298.15},
            {308.15, 6460, 6970, 5960, 6010, 6200, 6310, 6864},
            {318.15, 7965, 7850, 7790, 7780, 7730, 7690, 7627},
            {328.15, 0, 0, 9750, 9700, 9500, 9380, 9237},
            {333.15, 0, 0, 0, 8600, 10300, 10390, 10169}});
  annotation (Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end VitoCal300GBWS301dotA29;
