within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData;
record example_64 =         Records.BorefieldData (
    redeclare replaceable record Soi = SoilData.example,
    redeclare replaceable record Fill =
        FillingData.example,
    redeclare replaceable record Geo =
        GeometricData.example_64,
    redeclare replaceable record SteRes =
        StepResponse.example,
    redeclare replaceable record Adv = Advanced.example,
    redeclare replaceable record ShoTerRes = ShortTermResponse.example);
