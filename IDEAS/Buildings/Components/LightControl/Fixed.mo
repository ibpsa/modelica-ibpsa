within IDEAS.Buildings.Components.LightControl;
block Fixed "Fixed lighting"
  extends BaseClasses.PartialLights(   final useCtrlInput=false,
  final useOccInput=false);
  parameter Real ctrlFix(min=0)=0 "Fixed control signal";
  Modelica.Blocks.Sources.Constant constCtrl(final k=ctrlFix)
    "Constant block for lighting control"
    annotation (Placement(transformation(extent={{
            -12,-10},{8,10}})));
    //FIX-ME: parameter is Real instead of Integer since this way we include the possibility of adjustable lights

equation
  connect(constCtrl.y, ctrl) annotation (Line(
        points={{9,0},{120,0}}, color={0,0,127}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
August 28, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</ul>
</html>", info="<html>
<p>This block defines a fixed lighting control</p>
</html>"));
end Fixed;
