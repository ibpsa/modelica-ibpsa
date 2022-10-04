within IBPSA.Fluid.Interfaces;
expandable connector VapourCompressionMachineControlBus
  "Bus connector for reversible heat pump and chiller model"
  extends Modelica.Icons.SignalBus;
  annotation (Documentation(info="<html>
<p>Bus connector for a vapour compression machine. </p>
<p>Used in the reversbile modular approaches for chiller and heat pump in 
the models <a href=\"modelica://IBPSA.Fluid.Chillers.Chiller\">
IBPSA.Fluid.Chillers.Chiller</a> and 
<a href=\"modelica://IBPSA.Fluid.HeatPumps.HeatPump\">
IBPSA.Fluid.HeatPumps.HeatPump</a>.</p>
</html>", revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end VapourCompressionMachineControlBus;
