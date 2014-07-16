within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.VerticalSingleBorehole.BoreholeComponents;
function geoFluxCalculation
  // the number of layers is not yet variable since current Dymola version cannot handle this
  //parameter Integer nbrLayers = 17;
  input Modelica.SIunits.Radius[17, 1] rInner "inner radii of the layers";
  input Modelica.SIunits.Radius[17] rOuter "outer radii of the layers";
  input Modelica.SIunits.HeatFlux geoFluxValue "flux from the earth core";
  output Modelica.SIunits.HeatFlowRate[17] geoFlux
    "geothermal flux for every radial part";

algorithm
  for i in 1:17 loop
    geoFlux[i] := geoFluxValue*Modelica.Constants.pi*((rOuter[i])^2 - rInner[i,
      1]^2);
  end for;

end geoFluxCalculation;
