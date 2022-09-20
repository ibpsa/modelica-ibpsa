within IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias.BaseClasses;
partial model PartialInertia "Partial inertia model"
  extends Modelica.Blocks.Interfaces.SISO;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Partial model to account for Intertia. Just a SISO model.</p>
</html>"));
end PartialInertia;
