within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Validation;
model TrtValidationSingleBoreHoles2UTubeInSerie
  import IDEAS;
  extends
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Examples.SingleBoreHole2UTubeSerStepLoadScript(
    redeclare
      IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.SoilData.SoilTrt
      soi,
    redeclare
      IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.FillingData.FillingTrt
      fil(k=2.5),
    redeclare
      IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData.GeneralTrt2UTube
      gen);
end TrtValidationSingleBoreHoles2UTubeInSerie;
