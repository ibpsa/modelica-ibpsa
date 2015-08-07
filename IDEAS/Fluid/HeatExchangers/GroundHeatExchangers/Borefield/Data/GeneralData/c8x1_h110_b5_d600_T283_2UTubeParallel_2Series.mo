within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData;
record c8x1_h110_b5_d600_T283_2UTubeParallel_2Series "Line configuration of 8 boreholes of 110 meter with a spacing of 5.5 meter from each other. Initial temperature is 283K and the discretization is 600 seconds.
  The borehole configuration uses double U-tubes (in parallel) and the boreholes are in series 2 by 2."
  extends c8x1_h110_b5_d600_T283(
    pathMod=
        "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData.c8x1_h110_b5_d600_T283_2UTubeParallel_2Series",
    pathCom=Modelica.Utilities.Files.loadResource(
        "modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/GeneralData/c8x1_h110_b5_d600_T283_2UTubeParallel_2Series.mo"),
    nbSer = 2,
    singleUTube = false,
    parallel2UTube = true);
end c8x1_h110_b5_d600_T283_2UTubeParallel_2Series;
