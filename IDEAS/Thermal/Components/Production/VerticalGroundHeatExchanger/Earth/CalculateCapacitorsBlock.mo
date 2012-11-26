within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.Earth;
model CalculateCapacitorsBlock
// **************
// This model calculates every heat capacity of the different rings, given its depth,
// the radius of the meshed earth, the density of the earth, the specific heat capacitance.
// **************
      // **************
      // * parameters *
      // **************
       parameter Modelica.SIunits.Radius radiusPipe;
          // The points of the radius of the mesh of the earth.
          parameter Modelica.SIunits.Radius radius[:];
          // This represents the 1/10 of the total depth of the borehole (m)
          parameter Modelica.SIunits.Length depthOfEarth=10;
          // This is the density of the earth.
          parameter Modelica.SIunits.Density densityEarth=1600;
          // This is the heat capacitance of the earth.
          parameter Modelica.SIunits.SpecificHeatCapacity
    heatCapacitanceEarth =                                                     10;
          // Here we calculate the different capacities.
          parameter Modelica.SIunits.HeatCapacity capacities[size(radius,1)+1] = CalculateEarthCapacitiesBlock(
          fill(depthOfEarth,size(radius,1)-1),
          fill(heatCapacitanceEarth,size(radius,1)-1),
          fill(densityEarth,size(radius,1)-1),
          radius[1:size(radius,1)-1],
          radius[2:size(radius,1)],
          radiusPipe);
end CalculateCapacitorsBlock;
