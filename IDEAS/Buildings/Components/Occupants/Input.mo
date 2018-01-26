within IDEAS.Buildings.Components.Occupants;
block Input "Number of occupants from zone input nOcc"
  extends BaseClasses.PartialOccupants(final useInput=true);

equation
  connect(nOcc, nOccIn) annotation (Line(points={{120,0},{14,0},{14,0},{-100,0}},
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
