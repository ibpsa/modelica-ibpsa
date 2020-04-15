within IBPSA.ThermalZones.ReducedOrder.Examples;
model SimpleRoomOneElementTraceSubstance "Illustrates the use of a thermal zone with one heat conduction element"
  extends Modelica.Icons.Example;
  extends IBPSA.ThermalZones.ReducedOrder.Examples.SimpleRoomOneElement(thermalZoneOneElement(redeclare package Medium = Media.Air (
            extraPropertiesNames={"C_flow"}), use_C_flow=true));

  Modelica.Blocks.Sources.Pulse traSub(
    amplitude=0.004,
    width=50,
    period=86400,
    offset=-0.002) "Source of trace substance (for example CO2)"
    annotation (Placement(transformation(extent={{-88,-58},{-68,-38}})));
equation
  connect(traSub.y, thermalZoneOneElement.C_flow[1]) annotation (Line(points={{
          -67,-48},{2,-48},{2,26},{43,26}}, color={0,0,127}));
  annotation ( Documentation(info="<html>
  <p>This example shows the application of
  <a href=\"IBPSA.ThermalZones.ReducedOrder.RC.OneElement\">
  IBPSA.ThermalZones.ReducedOrder.RC.OneElement</a>
  in combination with
  <a href=\"IBPSA.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow\">
 IBPSA.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow</a>
  and
  <a href=\"IBPSA.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane\">
  IBPSA.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane</a>.
  Solar radiation on tilted surface is calculated using models of
  IBPSA. The thermal zone is a simple room defined in Guideline
  VDI 6007 Part 1 (VDI, 2012). All models, parameters and inputs
  except sunblinds, separate handling of heat transfer through
  windows, no wall element for internal walls and solar radiation
  are similar to the ones defined for the guideline&apos;s test
  room. For solar radiation, the example relies on the standard
  weather file in IBPSA.</p>
  <p>The idea of the example is to show a typical application of all
  sub-models and to use the example in unit tests. The results are
  reasonable, but not related to any real use case or measurement
  data.</p>
  <h4>References</h4>
  <p>VDI. German Association of Engineers Guideline VDI 6007-1
  March 2012. Calculation of transient thermal response of rooms
  and buildings - modelling of rooms.</p>
  </html>", revisions="<html>
  <ul>
  <li>
  April 15, 2020, by Katharina Brinkmann:<br/>
  Extend <code>SimpleRoomOneElement</code> for testing trace substances
  </li>
  <li>
  July 11, 2019, by Katharina Brinkmann:<br/>
  Renamed <code>alphaWall</code> to <code>hConWall</code>,
  <code>alphaWin</code> to <code>hConWin</code>
  </li>
  <li>
  April 27, 2016, by Michael Wetter:<br/>
  Removed call to <code>Modelica.Utilities.Files.loadResource</code>
  as this did not work for the regression tests.
  </li>
  <li>February 25, 2016, by Moritz Lauster:<br/>
  Implemented.
  </li>
  </ul>
  </html>"),
  experiment(Tolerance=1e-6, StopTime=604800),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Examples/SimpleRoomOneElementTraceSubstance.mos"
        "Simulate and plot"));
end SimpleRoomOneElementTraceSubstance;
