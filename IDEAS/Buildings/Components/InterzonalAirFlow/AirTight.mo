within IDEAS.Buildings.Components.InterzonalAirFlow;
model AirTight
  "Model representing air tight zone without air infiltration"
  extends IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses.PartialInterzonalAirFlow(nPorts=0);
equation
  connect(port_a_interior, port_b_exterior) annotation (Line(points={{-60,-100},
          {-60,0},{-20,0},{-20,100}}, color={0,127,255}));
  connect(port_a_exterior, port_b_interior) annotation (Line(points={{20,100},{20,
          0},{60,0},{60,-100}}, color={0,127,255}));
end AirTight;
