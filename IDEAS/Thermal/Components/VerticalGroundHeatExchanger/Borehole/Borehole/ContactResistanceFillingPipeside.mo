within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Borehole.Borehole;
model ContactResistanceFillingPipeside "The contact resistance for the pipes."
// **************
// This model represents a contact resistance between the filling material and the pipes.
// The thermal conductance is calculated with the parameters given in the record of the contactResistance.
// **************
      // **************
      // * parameters *
      // **************
          // This record contains the essential information for calculating the thermal conductance.
          parameter RecordPipes recordPipeCapacitor;
          // The thermal conductance (W/K) is calculated with the given information in recordContactResistanceBorepipeFilling
          parameter Modelica.SIunits.ThermalResistance thermalResistance = CalculateContactResistanceFillingPipeside(
          recordPipeCapacitor.depthOfEarth,
          recordPipeCapacitor.alphaSole,
          recordPipeCapacitor.radiusPipe);
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
end ContactResistanceFillingPipeside;
