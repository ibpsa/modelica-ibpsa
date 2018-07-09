within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples;
model BoreholeTwoUTube "Test for double U-tube borehole model"
  extends IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples.partialBorehole(
      redeclare
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeTwoUTube
      borHol,
    borFieDat(conDat=
          IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.SandBox_validation(
          borCon=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Types.BoreholeConfiguration.DoubleUTubeParallel)));

  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Boreholes/Examples/BoreholeTwoUTube.mos"
        "Simulate and Plot"));
end BoreholeTwoUTube;
