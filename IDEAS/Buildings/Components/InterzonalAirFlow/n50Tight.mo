within IDEAS.Buildings.Components.InterzonalAirFlow;
model n50Tight
  "n50Tight: n50 air leakage into and from airtight zone"
  extends IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses.PartialInterzonalAirFlown50;
  Fluid.Interfaces.IdealSource airExfiltration(
    redeclare package Medium = Medium,
    control_m_flow=true,
    allowFlowReversal=false,
    control_dp=false) "Fixed air exfiltration rate" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-50})));
equation
  connect(airExfiltration.m_flow_in, airInfiltration.m_flow_in)
    annotation (Line(points={{2,-56},{-18,-56},{-18,-44}},  color={0,0,127}));
  connect(airExfiltration.port_b, bou.ports[2])
    annotation (Line(points={{10,-40},{10,0},{2,0}},  color={0,127,255}));
  connect(airExfiltration.port_a, ports[2]) annotation (Line(points={{10,-60},{10,
          -100},{22,-100},{22,-100}},
                                    color={0,127,255}));
end n50Tight;
