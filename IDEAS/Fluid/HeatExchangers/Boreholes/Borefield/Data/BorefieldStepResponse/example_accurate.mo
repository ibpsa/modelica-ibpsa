within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.BorefieldStepResponse;
record example_accurate =            Records.BorefieldStepResponse (
    redeclare replaceable record Soi = SoilData.example,
    redeclare replaceable record BhFill =
        BoreholeFillingData.example,
    redeclare replaceable record BfGeo =
        BorefieldGeometricData.example,
    redeclare replaceable record GenStePar =
        GenericStepParam.example_accurate,
    redeclare replaceable record Adv = Advanced.example,
    redeclare replaceable record ResWet =
        ResponseWetter.example_accurate);
