within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData;
record example_accurate =            Records.BorefieldData (
    redeclare replaceable record Soi = SoilData.example,
    redeclare replaceable record Fill =
        FillingData.example,
    redeclare replaceable record Geo =
        GeometricData.example,
    redeclare replaceable record SteRes =
        StepResponse.example_accurate,
    redeclare replaceable record Adv = Advanced.example,
    redeclare replaceable record ShoTerRes =
        ShortTermResponse.example_accurate,
    redeclare replaceable record AggMat = AggregationMatrix.example_accurate);
