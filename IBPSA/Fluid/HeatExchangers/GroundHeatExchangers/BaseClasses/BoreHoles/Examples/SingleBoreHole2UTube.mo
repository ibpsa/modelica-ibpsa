within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.BoreHoles.Examples;
model SingleBoreHole2UTube
  import IBPSA;
  extends SingleBoreHoleUTube(
    redeclare
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.BoreHoles.SingleBoreHole2UTube
      borHolDis,
    redeclare
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.BoreHoles.SingleBoreHole2UTube
      borHolAna,
    borFieDat=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SandBox_validation(
        conDat=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.SandBox_validation(
        singleUTube=false)));
  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/BaseClasses/Boreholes/Examples/SingleBoreHole2UTube.mos"
        "Simulate and Plot"));
end SingleBoreHole2UTube;
