within IBPSA.ThermalZones.ReducedOrder.Examples;
model SimpleRoomFourElementsTraceSubstance
  "Illustrates the use of a thermal zone with four heat conduction elements and a balance of a trace substance"
  extends Modelica.Icons.Example;
  extends IBPSA.ThermalZones.ReducedOrder.Examples.SimpleRoomFourElements(thermalZoneFourElements(redeclare package Medium = Media.Air (
            extraPropertiesNames={"C_flow"}), use_C_flow=true));

  Modelica.Blocks.Sources.Pulse traSub(
    amplitude=0.004,
    width=50,
    period=86400,
    offset=-0.002) "Source of trace substance (for example CO2)"
    annotation (Placement(transformation(extent={{-88,-58},{-68,-38}})));
equation
  connect(eqAirTemp.TEqAirWin, preTem1.T)
    annotation (Line(points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},
    color={0,0,127}));
  connect(eqAirTemp.TEqAir, preTem.T)
    annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
    color={0,0,127}));
  connect(weaDat.weaBus, weaBus)
    annotation (Line(points={{-76,62},{-74,62},{-74,18},{-84,18},{-84,12},
    {-83,12},{-83,6}},color={255,204,51},
    thickness=0.5), Text(textString="%second",index=1,extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, eqAirTemp.TDryBul)
    annotation (Line(points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
    color={255,204,51},
    thickness=0.5), Text(textString="%first",index=-1,extent={{-6,3},{-6,3}}));
  connect(intGai.y[1], perRad.Q_flow)
    annotation (Line(points={{22.8,-52},{28,-52},{28,-32},{48,-32}},
    color={0,0,127}));
  connect(intGai.y[2], perCon.Q_flow)
    annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
  connect(intGai.y[3], macConv.Q_flow)
    annotation (Line(points={{22.8,-52},{28,-52},{28,-74},{48,-74}},
    color={0,0,127}));
  connect(const.y, eqAirTemp.sunblind)
    annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8}},
    color={0,0,127}));
  connect(HDifTil.HSkyDifTil, corGDouPan.HSkyDifTil)
    annotation (Line(points={{-47,36},{-28,36},{-6,36},{-6,58},{0,58},{0,57.8},{
    4,57.8},{4,58}},
    color={0,0,127}));
  connect(HDirTil.H, corGDouPan.HDirTil)
    annotation (Line(points={{-47,62},{4,62},{4,62}},  color={0,0,127}));
  connect(HDirTil.H,solRad. u1)
    annotation (Line(points={{-47,62},{-42,62},{-42,14},{-39,14}},
    color={0,0,127}));
  connect(HDifTil.H,solRad. u2)
    annotation (Line(points={{-47,30},{-44,30},{-44,8},{-39,8}},
    color={0,0,127}));
  connect(HDifTil.HGroDifTil, corGDouPan.HGroDifTil)
    annotation (Line(points={{-47,24},{-4,24},{-4,54},{4,54}},
    color={0,0,127}));
  connect(solRad.y, eqAirTemp.HSol)
    annotation (Line(points={{-27.5,11},{-26,11},{-26,2}},
    color={0,0,127}));
  connect(weaDat.weaBus, HDifTil[1].weaBus)
    annotation (Line(points={{-76,62},{-74,62},{-74,30},{-68,30}},
    color={255,204,51},thickness=0.5));
  connect(weaDat.weaBus, HDifTil[2].weaBus)
    annotation (Line(points={{-76,62},{-74,62},{-74,30},{-68,30}},
    color={255,204,51},thickness=0.5));
  connect(weaDat.weaBus, HDirTil[1].weaBus)
    annotation (Line(
    points={{-76,62},{-76,62},{-68,62}},
    color={255,204,51},
    thickness=0.5));
  connect(weaDat.weaBus, HDirTil[2].weaBus)
    annotation (Line(
    points={{-76,62},{-76,62},{-68,62}},
    color={255,204,51},
    thickness=0.5));
  connect(perRad.port, thermalZoneFourElements.intGainsRad)
    annotation (
    Line(points={{68,-32},{84,-32},{100,-32},{100,24},{92,24}},
    color={191,0,0}));
  connect(theConWin.solid, thermalZoneFourElements.window)
    annotation (Line(points={{38,21},{40,21},{40,20},{44,20}},   color=
    {191,0,0}));
  connect(preTem1.port, theConWin.fluid)
    annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
  connect(thermalZoneFourElements.extWall, theConWall.solid)
    annotation (Line(points={{44,12},{40,12},{40,1},{36,1}},
    color={191,0,0}));
  connect(theConWall.fluid, preTem.port)
    annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
  connect(hConWall.y, theConWall.Gc)
    annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
  connect(hConWin.y, theConWin.Gc)
    annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
  connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
    annotation (Line(
    points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
    color={255,204,51},
    thickness=0.5), Text(
    textString="%first",
    index=-1,
    extent={{-6,3},{-6,3}}));
  connect(macConv.port, thermalZoneFourElements.intGainsConv)
    annotation (
    Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
    0,0}));
  connect(perCon.port, thermalZoneFourElements.intGainsConv)
    annotation (
    Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
  connect(preTemFloor.port, thermalZoneFourElements.floor)
    annotation (Line(points={{67,-6},{68,-6},{68,-2}}, color={191,0,0}));
  connect(TSoil.y, preTemFloor.T)
  annotation (Line(points={{79.6,-22},{67,-22},{67,-19.2}}, color={0,0,127}));
  connect(preTemRoof.port, theConRoof.fluid)
    annotation (Line(points={{67,58},{67,58},{67,52}}, color={191,0,0}));
  connect(theConRoof.solid, thermalZoneFourElements.roof)
    annotation (Line(points={{67,42},{66.9,42},{66.9,34}}, color={191,0,0}));
  connect(eqAirTempVDI.TEqAir, preTemRoof.T)
    annotation (Line(
    points={{51,84},{67,84},{67,71.2}}, color={0,0,127}));
  connect(theConRoof.Gc, hConRoof.y)
    annotation (Line(points={{72,47},{81.6,47},{81.6,47}},color={0,0,127}));
  connect(eqAirTempVDI.TDryBul, eqAirTemp.TDryBul)
    annotation (Line(points={{28,78},{-96,78},{-96,-2},{-38,-2},{-38,-10},{-26,-10}},
    color={0,0,127}));
  connect(eqAirTempVDI.TBlaSky, eqAirTemp.TBlaSky)
    annotation (Line(points={{28,84},{-34,84},{-98,84},{-98,-8},{-58,-8},{-58,2},
          {-32,2},{-32,-4},{-26,-4}},
    color={0,0,127}));
  connect(eqAirTempVDI.HSol[1], weaBus.HGloHor)
    annotation (Line(points={{28,90},{-100,90},{-100,6},{-83,6}},
    color={0,0,127}),Text(
    textString="%second",
    index=1,
    extent={{6,3},{6,3}}));
  connect(HDirTil.inc, corGDouPan.inc)
    annotation (Line(points={{-47,58},{-28,58},{-10,58},{-10,50},{4,50}},
    color={0,0,127}));
  connect(const1.y, eqAirTempVDI.sunblind[1])
    annotation (Line(points={{61.7,93},{56,93},{56,98},{40,98},{40,96}},
                                      color={0,0,127}));
  connect(corGDouPan.solarRadWinTrans, thermalZoneFourElements.solRad)
    annotation (Line(points={{27,56},{40,56},{40,31},{43,31}}, color={0,0,127}));
  connect(traSub.y, thermalZoneFourElements.C_flow[1]) annotation (Line(points=
          {{-67,-48},{-12,-48},{-12,26},{43,26}}, color={0,0,127}));
  annotation ( Documentation(info="<html>
  <p>This example shows the application of
  <a href=\"IBPSA.ThermalZones.ReducedOrder.RC.FourElements\">
  IBPSA.ThermalZones.ReducedOrder.RC.FourElements</a>
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
  windows, an extra wall element for ground floor (with additional
  area), an extra wall element for roof (with additional area) and
  solar radiation are similar to the ones defined for the
  guideline&apos;s test room. For solar radiation, the example
  relies on the standard weather file in IBPSA.</p>
  <p>The idea of the example is to show a typical application of
  all sub-models and to use the example in unit tests. The results
  are reasonable, but not related to any real use case or measurement
  data.</p>
  <h4>References</h4>
  <p>VDI. German Association of Engineers Guideline VDI
  6007-1 March 2012. Calculation of transient thermal response of
  rooms and buildings - modelling of rooms.</p>
  </html>", revisions="<html>
  <ul>
  <li>
  April 15, 2020, by Katharina Brinkmann:<br/>
  Extend <code>SimpleRoomFourElements</code> for testing trace substances
  </li>
  <li>
  July 11, 2019, by Katharina Brinkmann:<br/>
  Renamed <code>alphaWall</code> to <code>hConWall</code>,
  <code>alphaRoof</code> to <code>hConRoof</code>,
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
  experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Examples/SimpleRoomFourElementsTraceSubstance.mos"
        "Simulate and plot"));
end SimpleRoomFourElementsTraceSubstance;
