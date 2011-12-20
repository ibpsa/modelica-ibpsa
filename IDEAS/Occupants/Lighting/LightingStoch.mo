within IDEAS.Occupants.Lighting;
model LightingStoch

  Integer power;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GainLightAir;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GainLightRad;
  parameter BWF.Bui.Lighting lightData;

  Modelica.Blocks.Interfaces.RealInput irr;
  Modelica.Blocks.Interfaces.IntegerInput occ;

  parameter Real[3] seed={7,12,3} "random initialisation";
  parameter Integer interval = 60;
  constant Real cal=0.0081537 "calibration scalar";

protected
  IDEAS.Occupants.Occupancy.BaseClasses.RandomChainVector
                                                 randomVector(n=3*lightData.n,interval=interval);

  Real effOcc;
  Real irrTreshold;
  Real[lightData.n] rating;
  Real[lightData.n] relUse;
  Real[lightData.n] minLeft;
  Integer[lightData.n] state;
  Boolean[lightData.n] action;
  Integer[lightData.n] lightPowers;

initial equation

  for i in 1:lightData.n loop
    rating[i]=0;
    relUse[i]=0;
    action[i]=false;
    state[i]=0;
    minLeft[i]=0;
    lightPowers[i] = 0;
  end for;

equation

  effOcc = -0.0087*occ^4 + 0.1138*occ^3 - 0.5654*occ^2 + 1.4871*occ - 0.045;

  irrTreshold = IDEAS.Occupants.Occupancy.BaseClasses.NormalVariate(
                                                           mu=60,sigma=10,si=seed);

  when time < 0.1 then
    for i in 1:lightData.n loop
      rating[i]=randomVector.r[i];
      relUse[i]=-cal*ln(rating[i]);
    end for;
  end when;

  when sample(0,interval) then
    for i in 1:lightData.n loop
      action[i] = IDEAS.Occupants.Lighting.BaseClasses.Action(
          irr=irr,
          irrTreshold=irrTreshold,
          r=randomVector.r[i]);
    end for;
  end when;

  when sample(0,interval) then
    for i in 1:lightData.n loop
      (state[i],minLeft[i]) = IDEAS.Occupants.Lighting.BaseClasses.LightChange(
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
      lightPowers[i] = state[i]*lightData.power[i];
    end for;
  end when;

  power = sum(lightPowers);
  GainLightAir.Q_flow = -0.2*power;
  GainLightRad.Q_flow = -0.8*power;

end LightingStoch;
