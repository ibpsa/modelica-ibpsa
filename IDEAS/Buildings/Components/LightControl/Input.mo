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
July 26, 2018 by Filip Jorissen:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/760\">#760</a>.
</li>
</ul>
</html>"));
end Input;
