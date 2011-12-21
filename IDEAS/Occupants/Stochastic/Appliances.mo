within IDEAS.Occupants.Stochastic;
model Appliances
  "I.Richardson et al. (2010), Domestic electricity use: A high-resolution energy demand model, Energy and Buildings 42, 1878-1887"

parameter Real[4] seed;
parameter Integer nLoads(min=1);
parameter Integer nZones(min=1);
parameter IDEAS.Occupants.Stochastic.Data.BaseClasses.Appliance[nLoads] appData;

protected
IDEAS.Occupants.Stochastic.BaseClasses.ActivityProb actProb;
IDEAS.Occupants.Stochastic.BaseClasses.RandomChainVector randomVector(
    seed=10000*seed,
    n=3*nLoads,
    interval=interval);
parameter Integer interval = 60;

Real[nLoads] delay;
Real[nLoads] minLeft;
Integer[nLoads] state;
Real[nLoads] appPowerRad;
Real[nLoads] appPowerConv;
Boolean[nLoads] action;

public
outer IDEAS.Climate.SimInfoManager sim annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon annotation (Placement(transformation(extent={{-110,10},{-90,30}}),
          iconTransformation(extent={{-110,10},{-90,30}})));
Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nZones] heatPortRad annotation (Placement(transformation(extent={{-110,-30},{-90,-10}}),
          iconTransformation(extent={{-110,-30},{-90,-10}})));
Modelica.Blocks.Interfaces.RealOutput[nLoads] P annotation (Placement(transformation(extent={{90,10},{110,30}})));
Modelica.Blocks.Interfaces.RealOutput[nLoads] Q annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
Modelica.Blocks.Interfaces.IntegerInput Occ annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));

initial equation

    for i in 1:nLoads loop
      delay[i]=0;
      state[i]=0;
      minLeft[i]=0;
      P[i] = appData[i].powerStandby;
      Q[i] = 0;
      appPowerRad[i] = appData[i].powerStandby*appData[i].frad;
      appPowerConv[i] = appData[i].powerStandby*appData[i].fconv;
    end for;

equation

    actProb.occ = Occ;

    when time < 0.1 then
      for i in 1:nLoads loop
        delay[i]=randomVector.r[i]*appData[i].delay*2;
      end for;
    end when;

    when sample(0,interval) then
      for i in 1:nLoads loop
        if appData[i].profile < 1 then
        action[i] = IDEAS.Occupants.Stochastic.BaseClasses.AppAction(
          P=1,
          cal=appData[i].cal,
          r=randomVector.r[i]);
        elseif appData[i].profile > 98 then
        action[i] = IDEAS.Occupants.Stochastic.BaseClasses.AppAction(
          P=Occ,
          cal=appData[i].cal,
          r=randomVector.r[i]);
        else
        action[i] = IDEAS.Occupants.Stochastic.BaseClasses.AppAction(
          P=actProb.actProb[appData[i].profile],
          cal=appData[i].cal,
          r=randomVector.r[i]);
        end if;
      end for;
    end when;

    when sample(0,interval) then
      for i in 1:nLoads loop
      (state[i],minLeft[i]) =
        IDEAS.Occupants.Stochastic.BaseClasses.StateChange(
        stateBefore=pre(state[i]),
        action=pre(action[i]),
        lengthCycle=appData[i].lengthCycle,
        minLeftBefore=pre(minLeft[i]),
        occ=Occ,
        r1=randomVector.r[2*i],
        r2=randomVector.r[3*i],
        seed={randomVector.seed1[1],randomVector.seed1[2],randomVector.seed1[3]});
      end for;
    end when;

    when sample(0,interval) then
      for i in 1:nLoads loop
        if state[i] > 0 then
          P[i] = state[i]*appData[i].powerCycle;
          appPowerRad[i] = state[i]*appData[i].powerCycle*appData[i].frad;
          appPowerConv[i] = state[i]*appData[i].powerCycle*appData[i].fconv;
        else
          P[i] = state[i]*appData[i].powerStandby;
          appPowerRad[i] = state[i]*appData[i].powerStandby*appData[i].frad;
          appPowerConv[i] = state[i]*appData[i].powerStandby*appData[i].fconv;
        end if;
      end for;
    end when;

    heatPortCon.Q_flow = -ones(nZones)*sum(appPowerConv)/nZones;
    heatPortCon.Q_flow = -ones(nZones)*sum(appPowerRad)/nZones;
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
end Appliances;
