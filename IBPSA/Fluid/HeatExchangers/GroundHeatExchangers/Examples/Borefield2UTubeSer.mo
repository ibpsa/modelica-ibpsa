within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Examples;
model Borefield2UTubeSer "Borefield with a 2-UTube configuration in series"
  extends IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Examples.BorefieldUTube(redeclare IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.borefield2UTube borFie, borFieDat(conDat=
          IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.ExampleConfigurationData(
          singleUTube=false, parallel2UTube=false)));
end Borefield2UTubeSer;
