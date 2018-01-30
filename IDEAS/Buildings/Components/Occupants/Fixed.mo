within IDEAS.Buildings.Components.Occupants;
block Fixed "Fixed number of occupants"
  extends BaseClasses.PartialOccupants(final useInput=false);
  parameter Real nOccFix(min=0)=0 "Fixed number of occupants";
  Modelica.Blocks.Sources.Constant constOcc(final k=nOccFix)
    "Constant block for number of occupants"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));

equation
  connect(constOcc.y, nOcc)
    annotation (Line(points={{9,0},{120,0}}, color={0,0,127}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
July 26, 2018 by Filip Jorissen:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/760\">#760</a>.
</li>
</ul>
</html>"));
end Fixed;
