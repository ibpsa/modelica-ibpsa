within IDEAS.Buildings.Components.InterzonalAirFlow;
model n50Open
  "n50Open: fixed pressure boundary, n50 air leakage into zone"
  extends IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses.PartialInterzonalAirFlown50;
equation
  connect(bou.ports[2], ports[2]) annotation (Line(points={{2,0},{2,-50},{2,-100},
          {22,-100}},color={0,127,255}));
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
<p>
In addition to these mass flow rates, a fixed mass flow rate, 
corresponding to air infiltration, is injected into the zone.
The mass flow rate is computed from the zone <code>n50</code> value.
</p>
</html>"));
end n50Open;
