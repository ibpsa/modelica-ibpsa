within IDEAS.Electric.Data.PvPanels;
record SanyoHIP230HDE1=IDEAS.Electric.Data.Interfaces.PvPanel (
I_phr=7.2206 "Light current under reference conditions",
I_or=9.5489*10^(-9)
      "Diode reverse saturation current under reference conditions",
R_sr=0.3709 "Series resistance under reference conditions",
R_shr=4694.1 "Shunt resistance under reference conditions",
V_tr=0.0345 "modified ideality factor under reference conditions",
I_scr=7.22 "Short circuit current under reference conditions",
V_ocr=42.3 "Open circuit voltage under reference conditions",
I_mpr=6.71 "Maximum power point current under reference conditions",
V_mpr=34.3 "Maximum power point voltage under reference conditions",
kV=-0.106 "Temperature coefficient for open circuit voltage",
kI=0.00217 "Temperature coefficient for short circuit current",
T_ref=298.15 "Reference temperature in Kelvin") "Sanyo HIP-230HDE1";
