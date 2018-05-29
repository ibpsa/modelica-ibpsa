within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Examples;
model BorefieldTwoUTubeSer
  "Borefield with a double U-Tube configuration in series"
  extends
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Examples.BorefieldOneUTube(
      redeclare
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BorefieldTwoUTube borFie,                                                                                     borFieDat(conDat=
          IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.ExampleConfigurationData(
          singleUTube=false, parallel2UTube=false)));
end BorefieldTwoUTubeSer;
