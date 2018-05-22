within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.BoreHoles.Examples;
model SingleBoreHole2UTube
  import IBPSA;
  extends SingleBoreHoleUTube(
                         redeclare
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.BoreHoles.SingleBoreHole2UTube
      borHol,                                                             borFieDat = IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SandBox_validation(conDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.SandBox_validation(singleUTube=false)));
end SingleBoreHole2UTube;
