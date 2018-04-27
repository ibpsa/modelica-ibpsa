within IDEAS.Buildings.Components.InterzonalAirFlow;
model AirOpen
  "AirOpen: idealised, fixed pressure boundary"
  extends
    IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses.PartialInterzonalAirFlowBoundary(nPorts=1,bou(nPorts=1));
equation
  connect(bou.ports[1], ports[1]) annotation (Line(points={{-6.66134e-16,0},{2,0},{2,-100}},
                     color={0,127,255}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
April 27, 2018 by Filip Jorissen:<br/>
First version.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/796\">#796</a>.
</li>
</ul>
</html>", info="<html>
<p>
This model represents an non-air tight zone. 
I.e. the zone air volume is internally fixed to a constant pressure
and the sum of the air injected through the two fluid ports
is consequently injected in the environment (as if all windows are opened).
If a net mass flow rate leaves the zone, then air is extracted
from the environment with the ambient temperature and humidity.
</p>
</html>"));
end AirOpen;
