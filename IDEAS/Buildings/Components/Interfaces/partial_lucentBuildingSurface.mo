within IDEAS.Buildings.Components.Interfaces;
partial model partial_lucentBuildingSurface
  "Partial component for the transparent surfaces of the building envelope"
  extends partial_buildingSurface;

    annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-50,-100},{50,100}}),
        graphics),
    Documentation(revisions="<html>
<ul>
<li>
February 6, 2016 by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end partial_lucentBuildingSurface;
