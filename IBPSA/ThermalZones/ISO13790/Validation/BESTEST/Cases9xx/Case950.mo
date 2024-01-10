within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case950 "Case 900, but cooling based on schedule, night venting, and no heating"
  extends Cases6xx.Case650(zonHVAC(redeclare
        IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Data.Case900Mass buiMas));
end Case950;
