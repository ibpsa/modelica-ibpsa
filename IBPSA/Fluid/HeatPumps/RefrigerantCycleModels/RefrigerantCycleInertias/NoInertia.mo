within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.RefrigerantCycleInertias;
model NoInertia "No inertia"
  extends BaseClasses.PartialInertia;
equation
  connect(u, y) annotation (Line(points={{-120,0},{110,0}}, color={0,0,127}));
  annotation (Icon(graphics={Line(points={{-100,0},{102,0}}, color={0,0,127})}),
      Documentation(info="<html>
<p>Model for no inertia.</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end NoInertia;
