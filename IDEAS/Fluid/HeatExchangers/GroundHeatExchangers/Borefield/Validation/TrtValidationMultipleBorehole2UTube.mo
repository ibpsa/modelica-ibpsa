within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Validation;
model TrtValidationMultipleBorehole2UTube
  extends BaseClasses.partial_trtValidation(
    redeclare replaceable Data.BorefieldData.BorefieldDataTrt2UTube bfData,
    hea(
      Q_flow_nominal=3618,
      dp_nominal=0),
    redeclare replaceable MultipleBoreHoles2UTube borFie(
                      lenSim=350000,
      show_T=true,
      dp_nominal=10000),
    realExpression(y=3.307*log(time + 1) - 6.2715 + 273.15));
  annotation (experiment(StopTime=309000), __Dymola_experimentSetupOutput(
        events=false));
end TrtValidationMultipleBorehole2UTube;
