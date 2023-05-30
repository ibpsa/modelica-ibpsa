within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Frosting.BaseClasses;
partial model PartialIcingFactor "Partial model to calculate the icing factor"
  Interfaces.RefrigerantMachineControlBus sigBus
    "Bus-connector used in a heat pump" annotation (Placement(transformation(
        extent={{-15,-14},{15,14}},
        rotation=0,
        origin={-101,0})));
  Modelica.Blocks.Interfaces.RealOutput iceFac
    "Efficiency factor (0..1) to estimate influence of icing"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),   Text(
          extent={{-57.5,-35},{57.5,35}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash,
          textString="%name
",        origin={-1.5,105},
          rotation=180)}),                                       Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>Model to calculate the icing factor based on the data available in the 
    signal bus <code>sigBus</code> of the heat pump.</p>
    <p>The icing factor is an efficiency based factor between 0 and 1 
    to estimate influence of icing. 
    0 means no heat is transferred through heat exchanger (fully frozen). 
    1 means no icing/frosting.</p>
    <p>See the documentation of <a href=
    \"modelica://IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialRefrigerantCycle\">IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialRefrigerantCycle</a>
    for further information.</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialIcingFactor;
