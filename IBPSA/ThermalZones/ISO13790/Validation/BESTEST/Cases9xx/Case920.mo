within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case920 "Case 900, but with windows on East and West side walls"
  extends Cases6xx.Case620(zon5R1C(redeclare
        IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Data.Case900Mass buiMas));
end Case920;
