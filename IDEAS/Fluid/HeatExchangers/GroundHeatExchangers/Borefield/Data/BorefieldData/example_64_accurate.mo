within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData;
record example_64_accurate =Records.BorefieldData (
    pathModelica = "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData.example_64_accurate",
    pathAbsolute = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/example_64_accurate.mo"),
    redeclare replaceable record Soi = SoilData.example,
    redeclare replaceable record Fill =
        FillingData.example,
    redeclare replaceable record Geo =
        GeometricData.example_64,
    redeclare replaceable record SteRes =
        StepResponse.example_accurate,
    redeclare replaceable record Adv = Advanced.example,
    redeclare replaceable record ShoTerRes = ShortTermResponse.example_accurate);
