within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Examples;
model Borefield2UTubePar "Borefield with a 2-UTube configuration in parallel"
  extends IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Examples.BorefieldUTube(redeclare IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.borefield2UTube borFie, borFieDat(conDat=
          IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.ExampleConfigurationData(
          singleUTube=false, parallel2UTube=true)));
end Borefield2UTubePar;
