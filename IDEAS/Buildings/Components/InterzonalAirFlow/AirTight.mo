within IDEAS.Buildings.Components.InterzonalAirFlow;
model AirTight
  "Airtight: Air tight zone without air infiltration"
  extends IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses.PartialInterzonalAirFlow(nPorts=0);
equation
  connect(port_a_interior, port_b_exterior) annotation (Line(points={{-60,-100},
          {-60,0},{-20,0},{-20,100}}, color={0,127,255}));
  connect(port_a_exterior, port_b_interior) annotation (Line(points={{20,100},{20,
          0},{60,0},{60,-100}}, color={0,127,255}));
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
This model represents an air tight zone. 
I.e. the zone only exchanges mass through its 
fluid ports and not through air infiltration. 
</p>
</html>"), Icon(graphics={
        Rectangle(
          extent={{-70,40},{-100,0}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None)}));
end AirTight;
