within IDEAS.Occupants.Stochastic;
model Lighting
  "I.Richardson et al. (2009), Domestic lighting: A high-resolution energy demand model"

  parameter Integer nZones(min=1);
  parameter Integer nLoads = lightData.n;

  Integer[nLoads] lightPowers;
  replaceable parameter IDEAS.Occupants.Stochastic.Data.BaseClasses.Lighting lightData
                                          annotation (choicesAllMatching=true);

  parameter Real[3] seed={7,12,3} "random initialisation";
  parameter Integer interval = 60;
  constant Real cal=0.0081537 "calibration scalar";

protected
    IDEAS.Occupants.Stochastic.BaseClasses.RandomChainVector randomVector(n=3*
        lightData.n, interval=interval);
    Real effOcc;
    Real irrTreshold;
    Real[nLoads] rating;
    Real[nLoads] relUse;
    Real[nLoads] minLeft;
    Integer[nLoads] state;
    Boolean[nLoads] action;

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon
      annotation (Placement(transformation(extent={{-110,10},{-90,30}}),
          iconTransformation(extent={{-110,10},{-90,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nZones] heatPortRad
      annotation (Placement(transformation(extent={{-110,-30},{-90,-10}}),
          iconTransformation(extent={{-110,-30},{-90,-10}})));
  Modelica.Blocks.Interfaces.RealOutput[nLoads] P
      annotation (Placement(transformation(extent={{90,10},{110,30}})));
  Modelica.Blocks.Interfaces.RealOutput[nLoads] Q
      annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
  Modelica.Blocks.Interfaces.IntegerInput Occ annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));
  outer Climate.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

initial equation

  for i in 1:lightData.n loop
    rating[i]=0;
    relUse[i]=0;
    action[i]=false;
    state[i]=0;
    minLeft[i]=0;
    P[i] = 0;
  end for;

equation

    effOcc = -0.0087*Occ^4 + 0.1138*Occ^3 - 0.5654*Occ^2 + 1.4871*Occ - 0.045;

  irrTreshold = IDEAS.Occupants.Stochastic.BaseClasses.NormalVariate(
    mu=60,
    sigma=10,
    si=seed);

    when time < 0.1 then
      for i in 1:lightData.n loop
        rating[i]=randomVector.r[i];
        relUse[i]=-cal*ln(rating[i]);
      end for;
    end when;

    when sample(0,interval) then
      for i in 1:lightData.n loop
      action[i] = IDEAS.Occupants.Stochastic.BaseClasses.LightAction(
        irr=sim.irr,
        irrTreshold=irrTreshold,
        r=randomVector.r[i]);
      end for;
    end when;

    when sample(0,interval) then
      for i in 1:lightData.n loop
      (state[i],minLeft[i]) =
        IDEAS.Occupants.Stochastic.BaseClasses.LightChange(
        stateBefore=pre(state[i]),
        action=pre(action[i]),
        minLeftBefore=pre(minLeft[i]),
        effOcc=effOcc,
        relUse=relUse[i],
        r1=randomVector.r[2*i],
        r2=randomVector.r[3*i]);
      end for;
    end when;

    when sample(0,interval) then
      for i in 1:lightData.n loop
        P[i] = state[i]*lightData.power[i];
      end for;
    end when;

    heatPortCon.Q_flow = -0.2*ones(nZones)*sum(lightPowers)/nZones;
    heatPortRad.Q_flow = -0.8*ones(nZones)*sum(lightPowers)/nZones;
    Q = ones(nLoads)*0;

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
            points={{2,0},{2,58},{14,56},{24,52},{32,48},{42,40},{48,32},{54,22},
                {58,10},{58,-4},{56,-16},{50,-28},{44,-38},{42,-40},{2,0}},
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
end Lighting;
