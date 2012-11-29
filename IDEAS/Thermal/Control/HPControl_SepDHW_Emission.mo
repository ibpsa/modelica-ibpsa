within IDEAS.Thermal.Control;
model HPControl_SepDHW_Emission
  "Control for system with seperated DHW TES loading"
  extends PartialHPControl;

equation
  TTopSet = TDHWSet + dTSafetyTop;
  TBotSet = TDHWSet + dTSafetyBot;

  // onOff refers to TES loading.  There is no on/off control for the emission system: the
  // heat pump gets the heating curve + 2K as setpoint temperature and will go on only if
  // there is a flowrate through the HP.

  if noEvent(TTankTop < TTopSet and TTankBot < (TBotSet-dTSafetyBot)) then
    // top too cold, system MUST be on except if bottom is still very hot (temp inversion?)
    onOff = 1;
    THPSet = TTopSet + dTHPTankSet;
  elseif noEvent(TTankBot < TBotSet and onOff > 0.5) then
    // HP running, top is fine, bottom too cold: keep running
    onOff = 1;
    THPSet = TTopSet + dTHPTankSet;
  else
    // all other cases: shut down
    onOff = 0;
    THPSet = heatingCurve.TSup + 2;
  end if;

  connect(heatingCurve.TSup, THeaCur) annotation (Line(
      points={{1,56},{8,56},{8,-40},{104,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end HPControl_SepDHW_Emission;
