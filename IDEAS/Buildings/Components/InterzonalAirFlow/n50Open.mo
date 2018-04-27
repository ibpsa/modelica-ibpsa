within IDEAS.Buildings.Components.InterzonalAirFlow;
model n50Open
  "n50Open: fixed pressure boundary, n50 air leakage into zone"
  extends IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses.PartialInterzonalAirFlown50;
equation
  connect(bou.ports[2], ports[2]) annotation (Line(points={{2,0},{2,-50},{2,-100},
          {22,-100}},color={0,127,255}));
end n50Open;
