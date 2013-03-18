within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.VerticalHeatExchangerModels;
model VerticalResistor "This represents a vertical resistor in the grid."
// **************
// This model represents a contact resistance between the filling material and the pipes.
// The thermal conductance is calculated with the parameters given in the record of the contactResistance.
// **************
      // **************
      // * parameters *
      // **************
            parameter Modelica.SIunits.Length depthOfEarth;
            // This is the thermal conductivity of the earth (T)
            parameter Modelica.SIunits.ThermalConductivity lambda;
            parameter Modelica.SIunits.Radius innerRadius;
            // This is outer radius of the ring (m)
            parameter Modelica.SIunits.Radius outerRadius;
          // The thermal conductance (W/K) is calculated with the given information in recordContactResistanceBorepipeFilling
          parameter Modelica.SIunits.ThermalResistance thermalResistance = CalculateVerticalResistance(
          depthOfEarth,
          lambda,
          innerRadius,
          outerRadius);
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
end VerticalResistor;
