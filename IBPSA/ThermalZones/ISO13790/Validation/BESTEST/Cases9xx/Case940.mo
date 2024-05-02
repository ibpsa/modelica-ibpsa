within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case940 "Case 900, but with heating schedule"
  extends Cases6xx.Case640(zonHVAC(redeclare
        IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Data.Case900Mass buiMas));
end Case940;
