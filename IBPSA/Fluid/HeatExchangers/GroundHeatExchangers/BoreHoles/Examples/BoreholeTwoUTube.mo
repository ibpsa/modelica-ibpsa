within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples;
model BoreholeTwoUTube "Test for double U-tube borehole model"
  import IBPSA;
  extends
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples.BoreholeOneUTube(
    redeclare
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeTwoUTube
      borHolDis,
    redeclare
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeTwoUTube
      borHolAna,
    borFieDat=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SandBox_validation(
        conDat=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.SandBox_validation(
        singleUTube=false)));
  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Boreholes/Examples/BoreholeTwoUTube.mos"
        "Simulate and Plot"));
end BoreholeTwoUTube;
