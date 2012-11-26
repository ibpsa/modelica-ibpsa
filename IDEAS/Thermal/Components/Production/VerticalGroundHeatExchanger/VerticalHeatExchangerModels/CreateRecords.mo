within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.VerticalHeatExchangerModels;
model CreateRecords
// **************
// This model creates all the necaissairy records for running the model.
// The model gets the information for creating the records from the ultimate record:
// AlTheParameters!
// **************
//parameter Real[6] radius = {0.057,  0.11868,  0.2420,  0.488,  0.982238,  2};
// This record contains the information for creating all the records.
parameter AlTheParameters alTheParameters;
// In this piece, the radius is calculated.
 parameter Real[alTheParameters.numberOfHorizontalNodes] radiustotal = EssentialCalculations.CalculateRadius(
 alTheParameters.radiusBorehole,
 alTheParameters.outSideRadius,
 alTheParameters.numberOfHorizontalNodes);
parameter Real[alTheParameters.numberOfHorizontalNodes] radius = radiustotal;
// This is the record for the pipes.
parameter Borehole.Borehole.RecordPipes recordPipeCapacitor(
    radiusPipe=alTheParameters.radiusPipe,
    depthOfEarth=alTheParameters.depthOfEarth,
    densitySole=alTheParameters.densitySole,
    heatCapacitanceSole=alTheParameters.heatCapacitanceSole,
    startTemperature=alTheParameters.startTemperaturePipe + 273.15,
    alphaSole=alTheParameters.alphaSole,
    lambdaFillMaterial=alTheParameters.lambdaFillMaterial);
// This is the record for the contactresistance between the pipes and the filling material.
parameter
    VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordContactResistanceBorepipeFilling
    recordContactResistanceBorepipeFilling(
    depthOfEarth=alTheParameters.depthOfEarth,
    alphaSole=alTheParameters.alphaSole,
    radiusPipe=alTheParameters.radiusPipe,
    radiusBorehole=alTheParameters.radiusBorehole,
    lambdaFilling=alTheParameters.lambdaFillMaterial);
// This is the record for the contactresistance between the pipes and the earth.
parameter
    VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordContactResistanceEarthBoreHole
    recordContactResistanceEarthBoreHole(
    depthOfEarth=alTheParameters.depthOfEarth,
    lambdaFillMaterial=alTheParameters.lambdaFillMaterial,
    lambdaEarth=alTheParameters.lambdaEarth,
    radiusPipe=alTheParameters.radiusPipe,
    radiusBorehole=alTheParameters.radiusBorehole);
// This is the record for the earth layer.
parameter Earth.RecordEarthLayer recordEarthLayer(
    radius=radius,
    depthOfEarth=alTheParameters.depthOfEarth,
    depthOfEarthUnder=alTheParameters.depthOfEarthUnder,
    densityEarth=alTheParameters.densityEarth,
    lambda=alTheParameters.lambdaEarth,
    heatCapacitanceEarth=alTheParameters.heatCapacitanceEarth,
    startTemperature=alTheParameters.startTemperatureEarth + 273.15,
    endTemperature=alTheParameters.endTemperature + 273.15,
    outSideTemperature=alTheParameters.outSideTemperature + 273.15,
    numberOfVerticalBottumLayers=alTheParameters.numberOfVerticalBottumLayers,
    numberOfHorizontalNodes=alTheParameters.numberOfHorizontalNodes,
    gradient=alTheParameters.gradient,
    bottumTemperature=alTheParameters.bottumTemperature + 273.15,
    totalDepth=alTheParameters.totalDepthHeatExchanger +
        alTheParameters.bottumDepth,
    metersOfEarthBlock=alTheParameters.bottumDepth);

// This is the record for the filling material.
parameter
    VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordFillingMaterialCapacitor
    recordFillingMaterialCapacitor(
    startTemperature=alTheParameters.startTemperatureEarth + 273.15,
    depthOfEarth=alTheParameters.depthOfEarth,
    heatCapacitanceFillig=alTheParameters.heatCapacitanceFillig,
    densityFillig=alTheParameters.densityFillig,
    innerRadius=alTheParameters.radiusPipe,
    outerRadius=alTheParameters.radiusBorehole);
end CreateRecords;
