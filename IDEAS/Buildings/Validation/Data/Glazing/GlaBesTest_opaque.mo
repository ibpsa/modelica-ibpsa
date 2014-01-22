within IDEAS.Buildings.Validation.Data.Glazing;
record GlaBesTest_opaque =
                    IDEAS.Buildings.Data.Interfaces.Glazing (
    final nLay=3,
    final mats={IDEAS.Buildings.Data.Materials.Glass(d=0.003175),
        IDEAS.Buildings.Data.Materials.Glass(d=0.013),
        IDEAS.Buildings.Data.Materials.Glass(d=0.003175)},
    final SwTrans=[0, 0.00; 90, 0.00],
    final SwAbs=[0, 0.00, 0.0, 0.00; 90, 0.00, 0.0, 0.0],
    final U_value=3.0,
    final g_value=0.87,
    final SwAbsDif={0.00,0.00,0.00},
    final SwTransDif=0.00) "Bestest glazing data";
