within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData;
record example_accurate =            Records.BorefieldData (
    pathModelica = "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData.example_accurate",
    pathAbsolute = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/example_accurate.mo"),
    redeclare replaceable record Soi = SoilData.example,
    redeclare replaceable record Fil =
        FillingData.example,
    redeclare replaceable record Geo =
        GeometricData.example,
    redeclare replaceable record SteRes =
        StepResponse.example_accurate,
    redeclare replaceable record Adv = Advanced.example);
