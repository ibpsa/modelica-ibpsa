within IDEAS.Buildings.Components.Occupants;
block Input "Number of occupants defined using zone input nOcc"
  extends BaseClasses.PartialOccupants(final useInput=true);

equation
  assert(not linearise, "Linearising the model when using an occupancy control input. 
    Make sure to add the lighting control input as an input for the linearisation to work correctly.",
    level=AssertionLevel.warning);
  connect(nOcc, nOccIn) annotation (Line(points={{120,0},{14,0},{14,0},{-120,0}},
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
