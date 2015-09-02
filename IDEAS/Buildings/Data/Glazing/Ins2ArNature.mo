within IDEAS.Buildings.Data.Glazing;
record Ins2ArNature = IDEAS.Buildings.Data.Interfaces.Glazing (
    final nLay=3,
    final mats={Materials.Glass(d=0.006, epsLw_b=0.110),
                Materials.Argon(d=0.016),
                Materials.Glass(d=0.006, epsLw_a=0.10)},
    final SwTrans=[0, 0.260;
                   10, 0.261;
                   20, 0.257;
                   30, 0.251;
                   40, 0.243;
                   50, 0.229;
                   60, 0.200;
                   70, 0.145;
                   80, 0.066;
                   90, 0.000],
    final SwAbs=[0, 0.470, 0.0, 0.052;
                 10, 0.474, 0.0, 0.053;
                 20, 0.480, 0.0, 0.053;
                 30, 0.482, 0.0, 0.054;
                 40, 0.480, 0.0, 0.055;
                 50, 0.477, 0.0, 0.055;
                 60, 0.477, 0.0, 0.053;
                 70, 0.460, 0.0, 0.047;
                 80, 0.351, 0.0, 0.033;
                 90, 0.000, 0.0, 0.000],
    final SwTransDif=0.200,
    final SwAbsDif={0.477,0.0,0.053},
    final U_value=1.3,
    final g_value=0.333) "Low SHGC AR 1.3 6/16/6 (U = 1.3 W/m2K, g = 0.333)"
  annotation (Documentation(revisions="<html>
<ul>
<li>
September 2, 2015, by Filip Jorissen:<br/>
Moved epsLw definition to solid layer to be consistent 
with changed implementation of MultiLayerLucent.
</li>
</ul>
</html>"));
