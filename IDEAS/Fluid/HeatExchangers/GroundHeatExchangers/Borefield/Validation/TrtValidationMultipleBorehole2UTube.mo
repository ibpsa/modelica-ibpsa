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
        events=false),
    Documentation(info="<html>
<p>
Validation based on TRT measurement.
</p>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Validation/TrtValidationMultipleBorehole2UTube.mos"
        "Simulate and plot"));
end TrtValidationMultipleBorehole2UTube;
