within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Earth;
model EarthCapacitor
// **************
// This model represents a earth capacitor with a given start temperature and a given capaicty.
// **************
      // **************
      // * parameters *
      // **************
            // The start temperature of the capacitor (K)
           parameter Modelica.SIunits.Temperature startTemperature=288;
            // The heat capacity of the capacitor (J/K)
            parameter Modelica.SIunits.HeatCapacity capacity=500;
      // **************
      // * Variables *
      // **************
            // The temperature of the capacitor (K)
            Modelica.SIunits.Temperature temperature(start=startTemperature);
            // The connection port of the capacitor
            Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portA;
//Real energy(start=0);
equation
  temperature = portA.T;
  capacity*der(temperature) = portA.Q_flow;
// energy = (startTemperature - portA.T)*capacity;
end EarthCapacitor;
