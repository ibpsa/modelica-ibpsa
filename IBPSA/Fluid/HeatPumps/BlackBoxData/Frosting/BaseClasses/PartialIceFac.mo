within IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.BaseClasses;
partial model PartialIceFac "Partial model to calculate the icing factor"
  Interfaces.VapourCompressionMachineControlBus sigBus
    "Bus-connector used in a heat pump" annotation (Placement(
        transformation(
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
    signal bus of the heat pump.</p>
    <p>Efficiency factor (0..1) to estimate influence of icing. 
    0 means no heat is transferred through heat exchanger (fully frozen). 
    1 means no icing/frosting.</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialIceFac;
