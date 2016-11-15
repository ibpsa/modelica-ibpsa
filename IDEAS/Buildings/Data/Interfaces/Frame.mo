within IDEAS.Buildings.Data.Interfaces;
partial record Frame "Template record for window frames"

  extends Modelica.Icons.MaterialProperty;

  parameter Boolean present=true;
  parameter Real U_value=1.1 "U-value window frame";

  annotation (Documentation(info="<html>
<p>
This record may be used to define the thermal properties of a window frame.
</p>
</html>", revisions="<html>
<ul>
<li>
November 15, 2016, by Filip Jorissen:<br/>
Revised documentation for IDEAS 1.0.
</li>
</ul>
</html>"));
end Frame;
