within IDEAS.Thermal.Control;
model HPControl_HeatingCurve_SepDHW "Heating curve control"
  extends PartialHPControl_SepDHW;

equation
  if heating then
    TTopSetHeating = heatingCurve.TSup + dTSafetyTop;
    TBotSetHeating = heatingCurve.TSup;

    if noEvent(TTankTopHeating < TTopSetHeating) then
      // top too cold, system MUST be on
      onOffHeating = 1;
     elseif noEvent(TTankBotHeating < TBotSetHeating and onOffHeating > 0.5) then
      // HP running, top is fine, bottom too cold: keep running
      onOffHeating = 1;
     else
      // all other cases: shut down
      onOffHeating = 0;
     end if;

  else
    TTopSetHeating = 0;
    TBotSetHeating = 0;
    onOffHeating = 0;
  end if;

  if DHW then
    TTopSetDHW = TDHWSet + dTSafetyTop;
    TBotSetDHW = TDHWSet + dTSafetyBot;

    if noEvent(TTankTopDHW < TTopSetDHW) then
      // top too cold, system MUST be on
      onOffDHW = 1;
     elseif noEvent(TTankBotDHW < TBotSetDHW and onOffDHW > 0.5) then
      // HP running, top is fine, bottom too cold: keep running
      onOffDHW = 1;
     else
      // all other cases: shut down
      onOffDHW = 0;
     end if;

  else
    TTopSetDHW = 0;
    TBotSetDHW = 0;
    onOffDHW = 0;
  end if;

  THPSet = max(TTopSetHeating, TTopSetDHW) + dTHPTankSet;

end HPControl_HeatingCurve_SepDHW;
