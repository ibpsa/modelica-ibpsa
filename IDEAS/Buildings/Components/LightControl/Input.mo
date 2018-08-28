within IDEAS.Buildings.Components.LightControl;
block Input "Lighting control from zone input lightCtrl"
  extends BaseClasses.PartialLights(   final useCtrlInput=true);

equation
  connect(ctrl, lightCtrl) annotation (Line(
        points={{120,0},{14,0},{14,-20},{-120,-20}},
        color={0,0,127}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
August 28, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</ul>
</html>", info="<html>
<p>This block defines a controllable lighting control</p>
</html>"));
end Input;
