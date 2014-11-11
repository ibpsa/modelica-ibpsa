within Annex60.Fluid.Interfaces.Examples;
model PrescribedOutletState "Test model for prescribed outlet state"
  import Annex60;
  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water.Simple;
  Annex60.Fluid.Interfaces.PrescribedOutletState prescribedOutletState
    annotation (Placement(transformation(extent={{-10,-6},{10,14}})));
equation

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-54,82},{-26,60}},
          lineColor={0,0,255},
          textString="fixme: add test model")}));
end PrescribedOutletState;
