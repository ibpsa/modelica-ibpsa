within IDEAS.Thermal.Control;
model Ctrl_Heating_TES_SetBack
  "Heating curve control for heating based on a water storage tank, incl. time based temperature set back"
  extends Interfaces.Partial_Ctrl_Heating_TES;

  Modelica.Blocks.Sources.CombiTimeTable daytime(
                                    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,
        0; 43200,0; 43200,1; 68400,1; 68400,0; 86400,0],
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Defines daytime, means period where storage tank can be charged"
    annotation (Placement(transformation(extent={{-64,-6},{-44,14}})));
equation
  TTopSet = max(TDHWSet, heatingCurve.TSup) + dTSafetyTop + smooth(daytime.y[1],1)*5;
  TBotSet = max(TDHWSet, heatingCurve.TSup) + dTSafetyBot + smooth(daytime.y[1],1)*5;
  THPSet = TTopSet + dTHPTankSet;
//algorithm
// Actually, I want this to be an algorithm instead of equation, but I get the following warning + error:
// Warning: Dymola is currently unable to differentiate algorithms.
// Error: Failed to reduce the DAE index.
  if noEvent(TTankTop < TTopSet and TTankBot < (TBotSet-dTSafetyBot)) then
    // top too cold, system MUST be on except if bottom is still very hot (temp inversion?)
    onOff = 1;
  elseif noEvent(TTankBot < TBotSet and onOff > 0.5) then
    // HP running, top is fine, bottom too cold: keep running
    onOff = 1;
  else
    // all other cases: shut down
    onOff = 0;
  end if;

end Ctrl_Heating_TES_SetBack;
