within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Inertias.BaseClasses;
partial model PartialInertia "Partial inertia model"
  extends Modelica.Blocks.Interfaces.SISO;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Partial model to account for Intertia. It is a SISO model to enable any options for inertia options.</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialInertia;
