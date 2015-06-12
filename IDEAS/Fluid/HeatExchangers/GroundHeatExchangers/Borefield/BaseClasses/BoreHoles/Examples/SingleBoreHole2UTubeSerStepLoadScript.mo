within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Examples;
model SingleBoreHole2UTubeSerStepLoadScript
  extends SingleBoreHoleUTubeSerStepLoadScript(
    redeclare SingleBoreHoles2UTubeInSerie borHolSer,
    redeclare Data.GeneralData.GeneralTrt gen(singleUTube=false),
    redeclare Data.FillingData.FillingTrt fil,
    redeclare Data.SoilData.SoilTrt soi);

  annotation (experiment(
      StopTime=360000,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"), __Dymola_experimentSetupOutput(events=false));
end SingleBoreHole2UTubeSerStepLoadScript;
