within IDEAS.Occupants.Stochastic.BaseClasses;
model ApplianceCycle

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GainAppAir;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GainAppRad;
  Modelica.Blocks.Interfaces.IntegerInput occ;
  Real power;

  parameter Integer n(min=1);
  parameter IDEAS.Occupants.Stochastic.Data.BaseClasses.Appliance[n] appData;

protected
  IDEAS.Occupants.Stochastic.BaseClasses.ActivityProb actProb;
  IDEAS.Occupants.Stochastic.BaseClasses.RandomChainVector randomVector(n=3*n,
      interval=interval);
  parameter Integer interval = 60;

  Real[n] delay;
  Real[n] minLeft;
  Integer[n] state;
  Real[n] appPower;
  Real[n] appPowerRad;
  Real[n] appPowerConv;
  Boolean[n] action;

initial equation
  for i in 1:n loop
    delay[i]=0;
    state[i]=0;
    minLeft[i]=0;
    appPower[i] = appData[i].powerStandby;
    appPowerRad[i] = appData[i].powerStandby*appData[i].frad;
    appPowerConv[i] = appData[i].powerStandby*appData[i].fconv;
  end for;

equation

  actProb.occ = occ;

  when time < 0.1 then
    for i in 1:n loop
      delay[i]=randomVector.r[i]*appData[i].delay*5;
    end for;
  end when;

  when sample(0,interval) then
    for i in 1:n loop
      action[i] = IDEAS.Occupants.Stochastic.BaseClasses.AppAction(
        P=1,
        cal=1,
        r=randomVector.r[i]);
    end for;
  end when;

  when sample(0,interval) then
    for i in 1:n loop
      (state[i],minLeft[i]) =
        IDEAS.Occupants.Stochastic.BaseClasses.StateChange(
        stateBefore=pre(state[i]),
        action=pre(action[i]),
        lengthCycle=appData[i].lengthCycle,
        minLeftBefore=pre(minLeft[i]),
        occ=occ,
        r1=randomVector.r[2*i],
        r2=randomVector.r[3*i],
        seed={randomVector.seed1[1],randomVector.seed1[2],randomVector.seed1[3]});
    end for;
  end when;

  when sample(0,interval) then
    for i in 1:n loop
      if state[i] > 0 then
        appPower[i] = state[i]*appData[i].powerCycle;
        appPowerRad[i] = state[i]*appData[i].powerCycle*appData[i].frad;
        appPowerConv[i] = state[i]*appData[i].powerCycle*appData[i].fconv;
      else
        appPower[i] = state[i]*appData[i].powerStandby;
        appPowerRad[i] = state[i]*appData[i].powerStandby*appData[i].frad;
        appPowerConv[i] = state[i]*appData[i].powerStandby*appData[i].fconv;
      end if;
    end for;
  end when;

  power = sum(appPower);
  GainAppAir.Q_flow = -sum(appPowerConv);
  GainAppRad.Q_flow = -sum(appPowerRad);

end ApplianceCycle;
