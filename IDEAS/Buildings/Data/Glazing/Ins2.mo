within IDEAS.Buildings.Data.Glazing;
record Ins2 = IDEAS.Buildings.Data.Interfaces.Glazing (
    final nLay=3,
    final mats={
      Materials.Glass(d=0.004,epsLw_a=0.04),
      Materials.Air(d=0.015),
      Materials.Glass(d=0.004, epsLw_b=0.04)},
    final SwTrans=[0, 0.521;
                  10, 0.524;
                  20, 0.517;
                  30, 0.508;
                  40, 0.495;
                  50, 0.472;
                  60, 0.418;
                  70, 0.312;
                  80, 0.153;
                  90, 0.000],
    final SwAbs=[0, 0.102, 0.0, 0.022;
                10, 0.104, 0.0, 0.022;
                20, 0.112, 0.0, 0.023;
                30, 0.117, 0.0, 0.023;
                40, 0.119, 0.0, 0.025;
                50, 0.123, 0.0, 0.026;
                60, 0.135, 0.0, 0.027;
                70, 0.142, 0.0, 0.029;
                80, 0.105, 0.0, 0.031;
                90, 0.000, 0.0, 0.000],
    final SwTransDif=0.418,
    final SwAbsDif={0.135,0.0,0.027},
    final U_value=1.4,
    final g_value=0.755)
  "Saint Gobain ClimaPlus Futur AR 1.4 4/15/4 (U = 1.4 W/m2K, g = 0.755)"
  annotation (Documentation(revisions="<html>
<ul>
<li>
September 2, 2015, by Filip Jorissen:<br/>
Moved epsLw definition to solid layer to be consistent 
with changed implementation of MultiLayerLucent.
</li>
</ul>
</html>"));
