within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData;
record example =            Records.BorefieldData (
    redeclare replaceable record Soi = SoilData.example,
    redeclare replaceable record Fill =
        FillingData.example,
    redeclare replaceable record Geo =
        GeometricData.example,
    redeclare replaceable record SteRes =
        StepResponse.example,
    redeclare replaceable record Adv = Advanced.example,
    redeclare replaceable record ShoTerRes = ShortTermResponse.example);
