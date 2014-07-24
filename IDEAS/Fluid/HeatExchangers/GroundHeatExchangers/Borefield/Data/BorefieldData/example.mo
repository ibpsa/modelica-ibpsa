within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData;
record example =            Records.BorefieldData (
    pathModelica = "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData.example",
    pathAbsolute = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/example.mo"),
    redeclare replaceable record Soi = SoilData.example,
    redeclare replaceable record Fil =
        FillingData.example,
    redeclare replaceable record Geo =
        GeometricData.example,
    redeclare replaceable record SteRes =
        StepResponse.example,
    redeclare replaceable record Adv = Advanced.example);
