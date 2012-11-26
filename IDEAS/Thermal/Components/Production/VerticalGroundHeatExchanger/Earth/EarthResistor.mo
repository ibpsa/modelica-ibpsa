within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.Earth;
model EarthResistor
extends Modelica.Thermal.HeatTransfer.Components.ThermalConductor(G=1/thermalResistance);
// **************
// This model represents a earth resistor with a given thermal conductance.
// **************
      // **************
      // * parameters *
      // **************
          // The thermal conductance (W/K)
          parameter Modelica.SIunits.ThermalResistance thermalResistance = 0.125;
          //parameter Modelica.SIunits.Temperature startTemperature=280;
end EarthResistor;
