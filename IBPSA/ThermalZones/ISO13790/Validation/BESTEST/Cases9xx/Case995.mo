within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case995 "Case 900, but with single heating and cooling setpoint and increased exterior wall and roof insulation"
  extends Cases6xx.Case695(zonHVAC(redeclare
        IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Data.Case900Mass buiMas));
end Case995;
