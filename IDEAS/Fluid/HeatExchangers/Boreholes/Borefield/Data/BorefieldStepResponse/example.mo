within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.BorefieldStepResponse;
record example =            Records.BorefieldStepResponse (
    redeclare replaceable record Soi = SoilData.example,
    redeclare replaceable record BhFill =
        BoreholeFillingData.example,
    redeclare replaceable record BfGeo =
        BorefieldGeometricData.example,
    redeclare replaceable record GenStePar =
        GenericStepParam.example,
    redeclare replaceable record Adv = Advanced.example,
    redeclare replaceable record ResWet = ResponseWetter.example);
