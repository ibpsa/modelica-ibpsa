within IDEAS.Buildings.Components.LightControl;
block Fixed "Fixed lighting"
  extends BaseClasses.PartialLights(   final useCtrlInput=false,
  final useOccInput=false);
  parameter Real nOccFix(min=0)=0 "Fixed number of occupants";
  Modelica.Blocks.Sources.Constant constOcc(final k=nOccFix)
    "Constant block for lighting control"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
    //FIX-ME: parameter is Real instead of Integer since this way we include the possibility of adjustable lights

equation
  connect(constOcc.y,ctrl)
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
