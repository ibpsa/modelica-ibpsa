within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Earth;
model CalculateResistorsBlock
// **************
// This model calculates every thermal conductance of the different rings, given its depth,
// the radius of the meshed earth, the thermal counductivity of the earth for the block underneath the borehole.
// **************
      // **************
      // * parameters *
      // **************
          // This represents the 1/10 of the total depth of the borehole (m)
          parameter Modelica.SIunits.Radius radiusPipe;
          parameter Modelica.SIunits.Radius radiusBorehole;
          parameter Modelica.SIunits.Length depthOfEarth=10;
          // The points of the radius of the mesh of the earth.
          parameter Modelica.SIunits.Radius radius[:];
          // The thermal Conductivity.
          parameter Modelica.SIunits.ThermalConductivity lambda=0.1;
          // Here we calculate the innerWeigthedRadius, given the radius. (the weighted radius = the weighted inner radius)
          parameter Modelica.SIunits.Radius[size(radius,1)-1]
    weightedRadius =                                                           EssentialCalculations.CalculateMassWeightedRadius(                      radius);
          // Here we calculate the outerWeigthedRadius, given the radius.
          parameter Modelica.SIunits.Radius[size(radius,1)-1]
    weightedOuterRadius =                                                           EssentialCalculations.CalculateWeightedOuterRadius(                      radius, weightedRadius);
          // Here we calculate the thermal conductance.
          parameter Modelica.SIunits.ThermalResistance[size(radius,1)+2]
    thermalResistance =           CalculateThermalResistanceBlock(
                fill(depthOfEarth,size(radius,1)-1),
                fill(lambda,size(radius,1)-1),
                weightedRadius,
                weightedOuterRadius,radiusPipe,radiusBorehole);
end CalculateResistorsBlock;
