within IDEAS.Building.Data.Glazing;
record Ins2_Ar_nature =
              IDEAS.Building.Elements.Glazing (
  nLay=3,
  mats={IDEAS.Building.Data.Materials.Glass(d=0.006),
        IDEAS.Building.Data.Materials.Argon(d=0.016),
        IDEAS.Building.Data.Materials.Glass(d=0.006)},
  SwTrans=[0,0.260;
          10,0.261;
          20,0.257;
          30,0.251;
          40,0.243;
          50,0.229;
          60,0.200;
          70,0.145;
          80,0.066;
          90,0.000],
   SwAbs=[0,0.470,0.0,0.052;
         10,0.474,0.0,0.053;
         20,0.480,0.0,0.053;
         30,0.482,0.0,0.054;
         40,0.480,0.0,0.055;
         50,0.477,0.0,0.055;
         60,0.477,0.0,0.053;
         70,0.460,0.0,0.047;
         80,0.351,0.0,0.033;
         90,0.000,0.0,0.000],
    U_value=1.3,
    g_value=0.333) "Double pane window (U = 1.3 W/m2K, g = 0.333)";
