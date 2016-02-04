within IDEAS.Buildings.Data.Interfaces;
partial record Frame "Record structure for window frames"

  extends Modelica.Icons.MaterialProperty;

  parameter Boolean present=true;
  parameter Real U_value=1.1 "U-value window frame";

  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>Frame.mo</code> partial describes the material data required for window frame modelling.</p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>No validation required.</p>
</html>"));
end Frame;
