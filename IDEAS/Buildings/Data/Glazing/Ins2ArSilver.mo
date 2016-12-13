within IDEAS.Buildings.Data.Glazing;
record Ins2ArSilver = IDEAS.Buildings.Data.Interfaces.Glazing (
    final nLay=3,
    final mats={Materials.Glass(d=0.006, epsLw_a=0.110),
                Materials.Argon(d=0.016),
                Materials.Glass(d=0.006, epsLw_b=0.10)},
    final SwTrans= [0, 0.226;
                   10, 0.227;
                   20, 0.223;
                   30, 0.218;
                   40, 0.211;
                   50, 0.199;
                   60, 0.173;
                   70, 0.125;
                   80, 0.056;
                   90, 0.000],
    final SwAbs= [0, 0.520, 0.0, 0.045;
                 10, 0.525, 0.0, 0.046;
                 20, 0.530, 0.0, 0.047;
                 30, 0.532, 0.0, 0.048;
                 40, 0.529, 0.0, 0.048;
                 50, 0.525, 0.0, 0.048;
                 60, 0.521, 0.0, 0.046;
                 70, 0.496, 0.0, 0.040;
                 80, 0.373, 0.0, 0.028;
                 90, 0.000, 0.0, 0.000],
    final SwTransDif=0.173,
    final SwAbsDif={0.521,0.0,0.046},
    final U_value=1.3,
    final g_value=0.298) "Low SHGC AR 1.3 6/16/6 (U = 1.3 W/m2K, g = 0.298)"
  annotation (Documentation(revisions="<html>
<ul>
<li>
September 2, 2015, by Filip Jorissen:<br/>
Moved epsLw definition to solid layer to be consistent 
with changed implementation of MultiLayerLucent.
</li>
</ul>
</html>", info="<html>
<p>
Double insulated glazing system with Argon filling and low g value
</p>
</html>"));
