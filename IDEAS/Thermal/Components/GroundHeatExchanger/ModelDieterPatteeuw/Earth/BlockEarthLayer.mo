within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Earth;
model BlockEarthLayer "This model represents the earht below the borehole."
     // **************
      // * parameters *
      // **************
      // This record contains all the parameters concerning the earth.
      parameter RecordEarthLayer recordEarthLayer;
      // Radius of the pipe.
      parameter Modelica.SIunits.Radius radiusPipe;
      // Radius of the borehole
      parameter Modelica.SIunits.Radius radiusBorehole = recordEarthLayer.radius[1];
      // All gridpoints.
      parameter Real[size(recordEarthLayer.radius,1)+2] radia = ConstructArray( radiusPipe,recordEarthLayer.radius,size(recordEarthLayer.radius,1)+2);
      // All inner radia
      parameter Real[size(recordEarthLayer.radius,1)+1] innerRadius = radia[1:size(recordEarthLayer.radius,1)+1];
      // All outer radia
      parameter Real[size(recordEarthLayer.radius,1)+1] outerRadius = radia[2:size(recordEarthLayer.radius,1)+2];
      parameter Real numberOfLayer = 1;
      parameter Real differenceToBottum= recordEarthLayer.metersOfEarthBlock - recordEarthLayer.depthOfEarthUnder*(numberOfLayer - 1/2);
     // All earthrings below bottum

      parameter Integer numberOfEarthRings = size(recordEarthLayer.radius,1)+1;
public
      EarthringUnder[size(recordEarthLayer.radius, 1) + 1] earthRings(
    each recordEarthLayer=recordEarthLayer,
    innerRadius=innerRadius,
    outerRadius=outerRadius,
    each startTemperature=-recordEarthLayer.gradient*differenceToBottum +
        recordEarthLayer.bottumTemperature);

      // Fixed heatflow (boundary)
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperature(  Q_flow=0);
      // Fixed heatflow (boundary)
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedFlow(Q_flow=0);

      // Help Variable
      Real getLeftBoundaryTemperature;
equation

      // Connect boundary condition
      connect(earthRings[1].earthResistorInWard.port_a, fixedFlow.port);

      // Connect help variable
      getLeftBoundaryTemperature = fixedFlow.port.T;

      // Connect every earthring
       for index in 1:(size(earthRings,1)-1) loop
          connect(earthRings[index].earthResistorOutWard.port_b,earthRings[index+1].earthResistorInWard.port_a);
       end for;

       // Connect boundary
       connect(earthRings[size(earthRings,1)].earthResistorOutWard.port_b, fixedTemperature.port);
end BlockEarthLayer;
