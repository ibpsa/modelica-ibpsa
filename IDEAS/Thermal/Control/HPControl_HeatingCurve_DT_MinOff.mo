within IDEAS.Thermal.Control;
model HPControl_HeatingCurve_DT_MinOff
  "Heating curve control, daytime priority + off-timer"
  extends PartialHPControl;

  parameter Modelica.SIunits.Time timeOff=60*15;
  Real debug(start = -1);
  Real smoothed;

  Modelica.Blocks.Sources.CombiTimeTable daytime(
                                    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,
        0; 43200,0; 43200,1; 68400,1; 68400,0; 86400,0])
    "Defines daytime, means period where storage tank can be charged"
    annotation (Placement(transformation(extent={{-64,-6},{-44,14}})));
  // this timer gives 0 during timing and 1 outside of timing
  IDEAS.BaseClasses.Control.Timer_NoEvents
                           timerOff(duration=timeOff)
    annotation (Placement(transformation(extent={{-62,-42},{-42,-22}})));
equation
  smoothed = smooth(1,timerOff.y);
  TTopSet = max(TDHWSet, heatingCurve.TSup) + dTSafetyTop + smooth(1, daytime.y[1])*5;
  TBotSet = max(TDHWSet, heatingCurve.TSup) + dTSafetyBot + smooth(1, daytime.y[1])*5;
  THPSet = TTopSet + dTHPTankSet;

  if noEvent(smooth(2, timerOff.y) > 0.5) then  // with noEvent it is NOT possible to run this model:
    // Error: Cannot reduce the DAE index and select states.
    if noEvent(TTankTop < TTopSet and TTankBot < (TBotSet-dTSafetyBot)) then
      // top too cold, off-time passed: system MUST be on except if bottom is still very hot (temp inversion?)
      onOff = 1;
      debug = 1;
    elseif noEvent(TTankBot < TBotSet and onOff > 0.5) then
      // HP running, top is fine, bottom too cold: keep running
      onOff = 1;
      debug = 2;
    else
      // all other cases: shut down
      onOff = 0;
      debug = 3;
    end if;
  else
    onOff = 0;
    debug = 4;
  end if;

algorithm
  timerOff.u := onOff;

end HPControl_HeatingCurve_DT_MinOff;
