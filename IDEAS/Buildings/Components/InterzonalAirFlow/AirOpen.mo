within IDEAS.Buildings.Components.InterzonalAirFlow;
model AirOpen
  "AirOpen: idealised, fixed pressure boundary"
  extends
    IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses.PartialInterzonalAirFlowBoundary(nPorts=1,bou(nPorts=1));
equation
  connect(bou.ports[1], ports[1]) annotation (Line(points={{-6.66134e-16,0},{2,0},{2,-100}},
                     color={0,127,255}));
end AirOpen;
