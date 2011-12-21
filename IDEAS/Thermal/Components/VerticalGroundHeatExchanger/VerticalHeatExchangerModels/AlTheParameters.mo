within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.VerticalHeatExchangerModels;
record AlTheParameters
  "Record containing all the parameters, all others should extend from this one"
// **************
// This record contains all the parameters that are changable.
// The first part contains the physicalparameters.
// The second part contains the numerical parameters.
// **************
      // **************
      //  * First part *
      // **************
            // **************
            // Parameters the heatExchanger
            // **************
                // This represents the total depth of the borehole (m)
                parameter Modelica.SIunits.Length totalDepthHeatExchanger =  160;
                // This represents the depth of the earth under the borehole (m)
                parameter Modelica.SIunits.Length bottumDepth =  totalDepthHeatExchanger*0.2;
            // **************
            // Parameters the holes
            // **************
                  // This is the radius of the borehole (m)
                  parameter Modelica.SIunits.Radius radiusBorehole = 0.13; //0.1016;
                  // This is the radius of the pipes (m)
                  parameter Modelica.SIunits.Radius radiusPipe = 0.025;
            // **************?
            // Parameters of the brine
            // **************
                  // This is the density of the brine (kg/m³)
                  parameter Modelica.SIunits.Density densitySole =  1000;
                  // This is the specific heat capacity of the brine (J/(kg.K))
                  parameter Modelica.SIunits.SpecificHeatCapacity
    heatCapacitanceSole =                                                                4180;
                  // This is the start temperature of the brine in the pipes (K)
                  parameter Modelica.SIunits.Temperature
    startTemperaturePipe =                                                      6.85;
                  // This is the thermal diffusity of the brine (m²/s)
                  parameter Modelica.SIunits.ThermalDiffusivity alphaSole = 4.36*lambdaFillMaterial/(2*radiusPipe);
            // **************
            // Parameters of the fillingmaterial.
            // **************
                  // This is the thermal conductivity of the filling material (W/(m.K))
                  parameter Modelica.SIunits.ThermalConductivity
    lambdaFillMaterial =                                                               2.9;//0.7; 2.9
                  // This is the specific heat capacity of the filling material(J/(kg.K)).
                  parameter Modelica.SIunits.SpecificHeatCapacity
    heatCapacitanceFillig =                                                              861;//  861; 1790
                  // This is the density of the filling material (kg/m³).
                  parameter Modelica.SIunits.Density densityFillig =  1605;
            // **************
            // Parameters of the earth.
            // **************
                  // This is the density of the earth (kg/m³)
                  parameter Modelica.SIunits.Density densityEarth= 1605;
                  // This is the specific heat capacity of the earth (J/(kg.K))
                  parameter Modelica.SIunits.SpecificHeatCapacity
    heatCapacitanceEarth =                                                              861;
                  // This is the start temperature of the earth (K)
                  parameter Modelica.SIunits.Temperature
    startTemperatureEarth =                                                      6.85;
                  // This is the thermal conductivity of the earth (T)
                  parameter Modelica.SIunits.ThermalConductivity
    lambdaEarth =                                                               0.7; //0.7
                  // This is the end temperature of the earth (K)
                  parameter Modelica.SIunits.Temperature endTemperature = 6.85;
                  // This is the temperature of the earth outside if fixed(K)
                  parameter Modelica.SIunits.Temperature outSideTemperature = 300-273.15;
      // **************
      //  * Second part *
      // **************
                // This parameter represents the number of vertical layers you want to divide your borehole.
                parameter Integer numberOfVerticalBoreholeLayers = 10;
                // This parameter represents the number of vertical layers you want to divide the soil underneath the borehole.
                parameter Integer numberOfVerticalBottumLayers = 7;
               // This number represents the number of horizontalnodes outside the borehole.
                parameter Integer numberOfHorizontalNodes = 8;
                // This represents the 1/numberOfVerticalBoreholeLayers of the total depth of the borehole (m)
                parameter Modelica.SIunits.Length depthOfEarth =  totalDepthHeatExchanger/numberOfVerticalBoreholeLayers; //10*depthOfEarth = depth of total borehole
                // This represents the 1/numberOfVerticalBottumLayers of the total depth of the earth beneath (m)
                parameter Modelica.SIunits.Length depthOfEarthUnder =  bottumDepth/numberOfVerticalBottumLayers; //10*depthOfEarth = depth of total borehole
                // This parameter represents the outsideRadius, depending on the simulation time, remember to choose wisely...
                parameter Modelica.SIunits.Radius outSideRadius = 60;
                // The thermalgradient in the ground (temperature increase per meter)
                parameter Real gradient = 0.1142/100;
                // The lowest temperature of the ground. 9.85 is the average temperature...
                parameter Real bottumTemperature = 9.85+gradient*(bottumDepth+totalDepthHeatExchanger);
end AlTheParameters;
