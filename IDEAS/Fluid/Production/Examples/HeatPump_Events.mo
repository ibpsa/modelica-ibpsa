within IDEAS.Fluid.Production.Examples;
model HeatPump_Events
  extends HeatPump_BrineWater(pump(m_flow_nominal=0.3), heatPump(avoidEvents=
          avoidEvents.k));
  Modelica.Blocks.Sources.BooleanConstant avoidEvents(k=true)
    "Switch to see influence on generated events"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  annotation (
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This model demonstrates the use of the &apos;AvoidEvents&apos; parameter. The parameter can be switched to see the impact on number of events and on the simulation time.</p>
</html>", revisions="<html>
<ul>
<li>November 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end HeatPump_Events;
