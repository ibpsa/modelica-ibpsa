within IBPSA.ThermalZones.ReducedOrder.Examples;
model SimpleRoomFourElementsTraceSubstance
  "Illustrates the use of a thermal zone considering a trace substance"
  extends Modelica.Icons.Example;
  extends IBPSA.ThermalZones.ReducedOrder.Examples.SimpleRoomFourElements(thermalZoneFourElements(
      redeclare package Medium = Medium,
      use_C_flow=true,
      nPorts=2));

  replaceable package Medium = IBPSA.Media.Air (extraPropertiesNames={"C_flow"}) "Medium model" annotation (choicesAllMatching=true);

  parameter Real airChaRat(unit="1/s") = 2/3600 "Air change rate";

  Modelica.Blocks.Sources.Pulse traSub(
    amplitude=10.4*2*(28.949/44.01),
    width=50,
    period=86400,
    offset=0) "Source of trace substance (for example CO2)"
    annotation (Placement(transformation(extent={{-88,-58},{-68,-38}})));
  IBPSA.Fluid.Sources.MassFlowSource_T souAir(
    redeclare package Medium = Medium,
    use_C_in=true,
    m_flow=airChaRat*rho_default*thermalZoneFourElements.VAir,
    nPorts=1) "source of air"
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-41,-65})));
  IBPSA.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium,
    C={400},
    nPorts=1) "sink of air" annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=-90,
        origin={-22,-68})));
  Modelica.Blocks.Sources.Ramp traSubAmb(
    height=1000,
    duration(displayUnit="d") = 604800,
    offset=200)
    annotation (Placement(transformation(extent={{-88,-88},{-68,-68}})));

protected
  final parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Medium state at default values";
  // Density at medium default values, used to compute the size of control volumes
  final parameter Modelica.SIunits.Density rho_default=Medium.density(
    state=state_default) "Density, used to compute fluid mass";

equation
  connect(traSub.y, thermalZoneFourElements.C_flow[1])
    annotation (Line(points={{-67,-48},{0,-48},{0,26},{43,26}},color={0,0,127}));
  connect(souAir.ports[1], thermalZoneFourElements.ports[1])
    annotation (Line(points={{-41,-58},{2,-58},{2,-24},{44,-24},{44,-1.95},{83,-1.95}},color={0,127,255}));
  connect(sinAir.ports[1], thermalZoneFourElements.ports[2])
    annotation (Line(points={{-22,-62},{2,-62},{2,-24},{44,-24},{44,-1.95},{83,-1.95}},color={0,127,255}));
  connect(traSubAmb.y, souAir.C_in[1])
    annotation (Line(points={{-67,-78},{-35.4,-78},{-35.4,-73.4}}, color={0,0,127}));
  annotation ( Documentation(info="<html>
<p>This example shows the application of
  <a href=\"IBPSA.ThermalZones.ReducedOrder.RC.FourElements\">
  IBPSA.ThermalZones.ReducedOrder.RC.FourElements</a>
  considering a trace substance such as CO2
  in combination with
  <a href=\"IBPSA.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow\">
 IBPSA.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow</a>
  and
  <a href=\"IBPSA.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane\">
  IBPSA.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane</a>.
  Solar radiation on tilted surface is calculated using models of
  IBPSA. The thermal zone is a simple room defined in Guideline
  VDI 6007 Part 1 (VDI, 2012).
  The trace substance calculation is based on the CO2 emissions of 2 persons.
  They stay in the thermal zone for 12 hours every 24 hours. The air exchange rate is 2 1/h.
  All further models, parameters and inputs
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
</html>",   revisions="<html>
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
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Examples/SimpleRoomFourElementsTraceSubstance.mos"
        "Simulate and plot"));
end SimpleRoomFourElementsTraceSubstance;
