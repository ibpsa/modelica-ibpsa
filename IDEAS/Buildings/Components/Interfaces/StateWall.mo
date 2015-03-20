within IDEAS.Buildings.Components.Interfaces;
partial model StateWall "Partial model for building envelope components"


  outer IDEAS.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
  ZoneBus propsBus_a(numAzi=sim.numAzi) "Inner side (last layer)"
                     annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40})));
		
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-50,-100},{50,100}}), graphics),
    Documentation(revisions="<html>
<ul>
<li>
February 10, 2015 by Filip Jorissen:<br/>
Adjusted implementation for grouping of solar calculations.
</li>
</ul>
</html>"));

end StateWall;
