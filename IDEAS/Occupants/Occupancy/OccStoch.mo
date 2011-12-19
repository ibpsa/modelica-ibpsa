within IDEAS.Occupants.Occupancy;
model OccStoch

Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GainOccAir;
Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GainOccRad;

IDEAS.Occupants.Occupancy.BaseClasses.RandomChain randomChain(seed=100*seed,
      interval=interval);

parameter BWF.Bui.Occupance occChain annotation (choicesAllMatching=true);
parameter Real power;

discrete Integer occ(start=0);

parameter Real[3] seed "random initialisation";

protected
parameter Real interval = occChain.period/occChain.s "Markov Chain interval";
Real[occChain.s,occChain.n+1,occChain.n+1] occChainReal;
discrete Integer t(start=1) "#interval in the period";
discrete Integer occBefore;
discrete Real[occChain.n+1,occChain.n+2] transMatrixCumul;

  parameter Integer yr = 2010;
  parameter Real DSTstart = 86400*(31+28+31-rem(5*yr/4+4,7))+2*3600;
  parameter Real DSTend = 86400*(31+28+31+30+31+30+31+31+30+31-rem(5*yr/4+1,7))+2*3600;

public
  outer Commons.SimInfoManager   sim
    annotation (Placement(transformation(extent={{-78,60},{-58,80}})));
initial equation
  t=0;
  occBefore=0;

equation

  if sim.workday >= 0.5 then
    occChainReal = occChain.Twd;
  else
    occChainReal = occChain.Twe;
  end if;

  when sample(0,interval) then
    if integer(time) == integer(DSTstart) then
      t = if pre(t)+1 <= occChain.s then pre(t) -5 else 1;
    elseif integer(time) == integer(DSTend) then
       t = if pre(t)+1 <= occChain.s then pre(t) + 7 else 1;
    else
      t = if pre(t)+1 <= occChain.s then pre(t) + 1 else 1;
    end if;
  end when;

  when sample(0,interval) then
    for i in 1:occChain.n+1 loop
        for j in 1:occChain.n+2 loop
          if j<2 then
            transMatrixCumul[i,j] = 0;
          else
            transMatrixCumul[i,j] = sum(occChainReal[t,i,k] for k in 1:j-1);
          end if;
        end for;
    end for;
  end when;

  when sample(0,interval) then
    occ = IDEAS.Occupants.Occupancy.BaseClasses.MarkovTransition(
      size=occChain.n + 1,
      transMatrixCumul=transMatrixCumul,
      random=randomChain.r,
      occBefore=occBefore);
    occBefore=pre(occ);
  end when;

GainOccAir.Q_flow=-0.60*occ*power;
GainOccRad.Q_flow=-0.40*occ*power;

end OccStoch;
