within IDEAS.Occupants.Stochastic;
model Occupancy
  "I.Richardson et al. (2008), A high-resolution domestic building occupancy model for energy demand simulations, Energy and Buildings 40, 1560-1566"

  parameter Integer nZones(min=1);

  IDEAS.Occupants.Stochastic.BaseClasses.RandomChain randomChain(seed=100*seed,
      interval=interval);

  replaceable parameter IDEAS.Occupants.Stochastic.Data.BaseClasses.Occupance occChain
                                         annotation (choicesAllMatching=true);
  parameter Real power;
  parameter Real[3] seed "random initialisation";
  discrete Integer occ(start=0);

protected
  parameter Real interval=occChain.period/occChain.s "Markov Chain interval";
  Real[occChain.s,occChain.n + 1,occChain.n + 1] occChainReal;
  discrete Integer t(start=1) "#interval in the period";
  discrete Integer occBefore;
  discrete Real[occChain.n + 1,occChain.n + 2] transMatrixCumul;

  parameter Integer yr = 2010;
  parameter Real DSTstart = 86400*(31+28+31-rem(5*yr/4+4,7))+2*3600;
  parameter Real DSTend = 86400*(31+28+31+30+31+30+31+31+30+31-rem(5*yr/4+1,7))+2*3600;

public
  outer IDEAS.Climate.SimInfoManager   sim
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon
        annotation (Placement(transformation(extent={{-110,10},{-90,30}}),
            iconTransformation(extent={{-110,10},{-90,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nZones] heatPortRad
        annotation (Placement(transformation(extent={{-110,-30},{-90,-10}}),
            iconTransformation(extent={{-110,-30},{-90,-10}})));
  Modelica.Blocks.Interfaces.RealOutput[nZones] TSet annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,100})));
    Modelica.Blocks.Interfaces.IntegerOutput Occ annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,-100})));
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
    occ = IDEAS.Occupants.Stochastic.BaseClasses.MarkovTransition(
      size=occChain.n + 1,
      transMatrixCumul=transMatrixCumul,
      random=randomChain.r,
      occBefore=occBefore);
      occBefore=pre(occ);
    end when;

    if Occ >=1 then
      TSet = ones(nZones)*294.15;
    else
      TSet = ones(nZones)*289.15;
    end if;

    heatPortCon.Q_flow = -ones(nZones)*0.60*occ*power/nZones;
    heatPortRad.Q_flow = -ones(nZones)*0.40*occ*power/nZones;

    annotation (Icon(graphics={
            Ellipse(
              extent={{-70,70},{70,-70}},
              lineColor={127,0,0},
              fillPattern=FillPattern.Solid,
              fillColor={127,0,0}),
            Ellipse(
              extent={{-60,60},{60,-60}},
              lineColor={127,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{2,0},{2,58},{14,56},{24,52},{32,48},{42,40},{48,32},{54,
                22},{58,10},{58,-4},{56,-16},{50,-28},{44,-38},{42,-40},{2,0}},
              smooth=Smooth.None,
              pattern=LinePattern.None,
              lineColor={0,0,0},
              fillColor={175,175,175},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-4,50},{2,-2}},
              lineColor={127,0,0},
              fillColor={127,0,0},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{2,0},{18,-16},{14,-20},{-4,-2},{2,0}},
              lineColor={127,0,0},
              smooth=Smooth.None,
              fillColor={127,0,0},
              fillPattern=FillPattern.Solid)}), Diagram(graphics));
end Occupancy;
