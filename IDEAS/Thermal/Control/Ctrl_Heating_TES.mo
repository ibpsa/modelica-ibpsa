within IDEAS.Thermal.Control;
model Ctrl_Heating_TES
  "Heating curve control for heating based on a water storage tank"
  extends Interfaces.Partial_Ctrl_Heating_TES;

equation
  TTopSet = max(TDHWSet, heatingCurve.TSup) + dTSafetyTop;
  TBotSet = max(TDHWSet, heatingCurve.TSup) + dTSafetyBot;
  THPSet = TTopSet + dTHPTankSet;

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

  connect(heatingCurve.TSup, THeaCur) annotation (Line(
      points={{1,56},{-8,56},{-8,-40},{104,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end Ctrl_Heating_TES;
