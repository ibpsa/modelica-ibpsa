within IDEAS.Templates.BaseCircuits;
model MixingCircuit_Linear "Mixing circuit with linear three way valve"
  extends Interfaces.PartialMixingCircuit(redeclare
      Fluid.Actuators.Valves.ThreeWayLinear partialThreeWayValve);

end MixingCircuit_Linear;
