within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Validation;
model TrtValidationMultipleBoreholeUTube
  "Validation based on thermal response test"
  extends
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Validation.BaseClasses.partial_trtValidation(
    redeclare replaceable
      IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData.BorefieldDataTrtUTube
      bfData,
    hea(
      Q_flow_nominal=3618,
      dp_nominal=1000),
    redeclare replaceable MultipleBoreHolesUTube  borFie(
                      lenSim=350000, dp_nominal=1000),
    realExpression(y=3.307*log(time + 1) - 6.2715 + 273.15));

 annotation (experiment(StopTime=309000), __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This model serves as a verification for the bore field model. It simulates a real thermal response test (TRT) where one bore hole was heated with a constant thermal power. The supply temperature was measured and fitted by correlation <code>T_measured</code>. </p>
<p>The model uses the real bore hole dimensions as well as the thermal conductivity that was obtained from the TRT test. Therefore its temperature response should be equal to <code>T_measured</code>. </p>
<p>This model is not unit tested becasue the generation of the aggregation matrix is not supported by BuildingsPy.</p>
</html>", revisions="<html>
<ul>
<li>
January 2015, by Filip Jorissen:<br>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="../../IDEAS/IDEAS/Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Validation/TrtValidationMultipleBoreholeUTube.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end TrtValidationMultipleBoreholeUTube;
