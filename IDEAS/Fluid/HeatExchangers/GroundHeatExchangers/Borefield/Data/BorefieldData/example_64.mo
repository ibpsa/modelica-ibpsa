within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData;
record example_64 =         Records.BorefieldData (
    pathModelica = "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData.example_64",
    pathAbsolute = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/example_64.mo"),
    redeclare replaceable record Soi = SoilData.example,
    redeclare replaceable record Fil =
        FillingData.example,
    redeclare replaceable record Geo =
        GeometricData.example_64,
    redeclare replaceable record SteRes =
        StepResponse.example,
    redeclare replaceable record Adv = Advanced.example);
