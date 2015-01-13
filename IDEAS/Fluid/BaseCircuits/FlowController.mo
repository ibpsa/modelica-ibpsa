within IDEAS.Fluid.BaseCircuits;
model FlowController
  //Extensions
  extends Interfaces.PartialValveCircuit(
    redeclare Actuators.Valves.TwoWayEqualPercentage flowRegulator,
    final measurePower=false);
equation
  connect(u, flowRegulator.y) annotation (Line(
      points={{0,108},{0,72}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Documentation(info="<html><p>
  This model is the base circuit implementation of a combination of a regulation and balancing valve to control a flow in a pressurizeµd hydraulic circuit. The regulation valve is an equal-percentage opening valve and is modelled using the <a href=\"modelica://IDEAS.Fluid.Actuators.Valves.TwoWayEqualPercentage\">IDEAS.Fluid.Actuators.Valves.TwoWayEqualPercentage</a> model with a variable opening to control the flow. 
  <p>The balancing valve is characterized by a fixed Kv value which can be adjusted to obtain the desired flow through the circuit dependent on the pressure head of the circuit.</p></html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),            graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{0,102},{6,80},{0,60}},
          color={0,255,128},
          smooth=Smooth.None)}));
end FlowController;
