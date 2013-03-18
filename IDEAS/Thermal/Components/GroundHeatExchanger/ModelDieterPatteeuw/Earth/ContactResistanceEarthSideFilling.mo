within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Earth;
model ContactResistanceEarthSideFilling
// **************
// This model represents a contact resistor between the earth and the filling material.
// The thermal conductance is calculated with the parameters given in the record of the contactResistance.
// **************
      // **************
      // * parameters *
      // **************
          // This record contains the essential information for calculating the thermal conductance.
          parameter RecordEarthLayer recordEarthLayer;
          // The thermal conductance (W/K) is calculated with the given information in recordContactResistanceEarthBoreHole
          parameter Modelica.SIunits.ThermalResistance thermalResistance = CalculateContactResistanceEarthSideFilling(
          recordEarthLayer.depthOfEarth,
          recordEarthLayer.lambda,
          recordEarthLayer.radius[1],
          recordEarthLayer.radius[2]);
      // **************
      // * variables *
      // **************
          // The inputport
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a;
          // The outputport
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b;
equation
thermalResistance*port_a.Q_flow = (port_a.T - port_b.T);
port_a.Q_flow = -port_b.Q_flow;
end ContactResistanceEarthSideFilling;
