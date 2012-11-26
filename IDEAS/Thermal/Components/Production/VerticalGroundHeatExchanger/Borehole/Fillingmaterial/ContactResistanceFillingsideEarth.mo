within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.Borehole.Fillingmaterial;
model ContactResistanceFillingsideEarth
  "The contact resistance towards the earth."
// **************
// This model represents a contact resistor between the earth and the filling material.
// The thermal conductance is calculated with the parameters given in the record of the contactResistance.
// **************
      // **************
      // * parameters *
      // **************
          // This record contains the essential information for calculating the thermal conductance.
          parameter RecordContactResistanceEarthBoreHole
    recordContactResistanceEarthBoreHole;
          // The thermal conductance (W/K) is calculated with the given information in recordContactResistanceEarthBoreHole
          parameter Modelica.SIunits.ThermalResistance thermalResistance = CalculateContactResistanceFillingsideEarth(
          recordContactResistanceEarthBoreHole.depthOfEarth,
          recordContactResistanceEarthBoreHole.lambdaFillMaterial,
          recordContactResistanceEarthBoreHole.radiusPipe,
          recordContactResistanceEarthBoreHole.radiusBorehole);
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
end ContactResistanceFillingsideEarth;
