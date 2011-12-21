within IDEAS.Thermal.Control;
model SolarThermalControl_DT
  extends Partial_SolarThermalControl;

equation
  if noEvent(TCollector > (TTankBot + dTStart) and TSafety < TSafetyMax) then
    // collector hot enough.  System MUST be on except if safety issues.
    onOff = 1;
  elseif noEvent(TCollector > (TTankBot + dTStop) and TSafety < TSafetyMax and onOff > 0.5) then
    // system is running, everything is fine: keep running
    onOff = 1;
  else
    // all other cases: shut down
    onOff = 0;
  end if;

end SolarThermalControl_DT;
