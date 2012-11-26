within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.Earth;
model BlockEarthLayerNotInUse
     // **************
      // * parameters *
      // **************
      // This record contains all the parameters concerning the earth.
      parameter RecordEarthLayer recordEarthLayer;
      // Radius of the pipe.
      parameter Modelica.SIunits.Radius radiusPipe;
      // Radius of the pipe.
      parameter Modelica.SIunits.Radius radiusBorehole = recordEarthLayer.radius[1];
      // Calculate all the inductances of the earth resistor
      parameter CalculateResistorsBlock calculatedRecordsEarthResistor(
       depthOfEarth=recordEarthLayer.depthOfEarthUnder,
      radius=recordEarthLayer.radius,
      lambda=recordEarthLayer.lambda,
      radiusPipe=radiusPipe,
      radiusBorehole=radiusBorehole);
      // Calculate all the capacities of the earth capacitors
      parameter CalculateCapacitorsBlock calculatedRecordsEarthCapacitor(radius=recordEarthLayer.radius,
      depthOfEarth=recordEarthLayer.depthOfEarthUnder,
      densityEarth=recordEarthLayer.densityEarth,
      heatCapacitanceEarth=recordEarthLayer.heatCapacitanceEarth,
      radiusPipe=radiusPipe);
      parameter Real[size(capacitors,1)+1] radia = ConstructArray(               radiusPipe,recordEarthLayer.radius,size(capacitors,1)+1);
      parameter Real[size(capacitors,1)] innerRadius = radia[1:size(capacitors,1)];
      parameter Real[size(capacitors,1)] outerRadius = radia[2:size(capacitors,1) +1];
      parameter Real numberOfLayer = 1;
      parameter Real differenceToBottum= recordEarthLayer.metersOfEarthBlock - recordEarthLayer.depthOfEarthUnder*(numberOfLayer - 1/2);
public
      EarthResistor[size(recordEarthLayer.radius,1)+2] resistors(thermalResistance=calculatedRecordsEarthResistor.thermalResistance); //,each
      //startTemperature =       recordEarthLayer.startTemperature);
      // Define all the earth capacitors.
      EarthCapacitor[size(recordEarthLayer.radius,1)+1] capacitors(capacity = calculatedRecordsEarthCapacitor.capacities, each
      startTemperature =       -recordEarthLayer.gradient*differenceToBottum + recordEarthLayer.bottumTemperature);
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperature(  Q_flow=0);
      //Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedFlow(T=recordEarthLayer.endTemperature);
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedFlow(Q_flow=0);
      VerticalHeatExchangerModels.VerticalResistor[size(capacitors, 1)]
    verticalResistors(
    each lambda=recordEarthLayer.lambda,
    each depthOfEarth=recordEarthLayer.depthOfEarthUnder/2,
    innerRadius=innerRadius,
    outerRadius=outerRadius);
       VerticalHeatExchangerModels.VerticalResistor[size(capacitors, 1)]
    verticalResistorsUp(
    each lambda=recordEarthLayer.lambda,
    each depthOfEarth=recordEarthLayer.depthOfEarthUnder/2,
    innerRadius=innerRadius,
    outerRadius=outerRadius);
equation
      connect(resistors[1].port_a, fixedFlow.port);
      // Connect every resistorside with a capacitor.
       for index in 1:size(capacitors,1) loop
          connect(resistors[index].port_b,capacitors[index].portA);
       end for;
        // Connect every resistorside with an other capacitor
       for index in 1:size(capacitors,1) loop
          connect(resistors[index + 1].port_a,capacitors[index].portA);
       end for;
       // Connect every capacitor with a vertikal resistor downwards.
       for index in 1:size(capacitors,1) loop
          connect(verticalResistors[index].port_a,capacitors[index].portA);
       end for;
       // Connect every capacitor with a vertikal resistor upwards.
       for index in 1:size(capacitors,1) loop
          connect(verticalResistorsUp[index].port_b,capacitors[index].portA);
       end for;
       connect(resistors[size(resistors,1)].port_b, fixedTemperature.port);
end BlockEarthLayerNotInUse;
