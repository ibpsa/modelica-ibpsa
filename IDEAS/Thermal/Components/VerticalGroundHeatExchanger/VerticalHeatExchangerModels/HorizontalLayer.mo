within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.VerticalHeatExchangerModels;
model HorizontalLayer
  "This model represents one horizontalLayer, containing fillingmateria, earthlayer and borepipes."
// **************
// This model represents one horizontal layer.
// A horizontal layer consists of earth, filling material and the borehole.
// All three of them are connected described by Bianchi.
// **************
      // **************
      // * parameters *
      // **************
      // These records contain the information for constructing the horizontal layer.
parameter VerticalGroundHeatExchanger.Borehole.Borehole.RecordPipes recordPipeCapacitor;
parameter Earth.RecordEarthLayer recordEarthLayer;
parameter
    VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordContactResistanceEarthBoreHole
    recordContactResistanceEarthBoreHole;
parameter
    VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordFillingMaterialCapacitor
    recordFillingMaterialCapacitor;
parameter
    VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordContactResistanceBorepipeFilling
    recordContactResistanceBorepipeFilling;
parameter AdaptedFluid.Medium medium;
parameter Real numberOfLayer;
parameter Real offset = 0;
parameter Real differenceToBottum= recordEarthLayer.totalDepth - recordEarthLayer.depthOfEarth*(numberOfLayer - 1/2);
parameter Modelica.SIunits.Temperature TIni = -recordEarthLayer.gradient*differenceToBottum +
        recordEarthLayer.bottumTemperature;
      // **************
      // * variables *
      // **************
// This variable represents a piece of borehole containing the pipes. This piece is replaceable with a bottumPieceOfBorehole for representing
// the bottum horizontal layer.
replaceable VerticalGroundHeatExchanger.Borehole.Borehole.PipesOfBorehole
                                                                  pieceOfBoreHole(
    recordPipeCapacitor=recordPipeCapacitor,
    medium=medium,
    upwardPipe(T0=TIni),
    downwardPipe(T0=TIni));
Earth.EarthLayer earthLayer(
    recordEarthLayer=recordEarthLayer,
    numberOfLayer=numberOfLayer,
    offset=offset,
    earthRings(each startTemperature=TIni));
 VerticalGroundHeatExchanger.Borehole.Fillingmaterial.FillingMaterial
    fillingMaterial(
    recordFillingMaterialCapacitor=recordFillingMaterialCapacitor,
    recordContactResistanceEarthBoreHole=
        recordContactResistanceEarthBoreHole,
    recordContactResistanceBorepipeFilling=
        recordContactResistanceBorepipeFilling,
    fillingMaterialCapacitor(temperature(start=TIni, fixed=true)));
equation
    // connect(earthLayer.contactResistanceEarthSideFilling.port_a,fillingMaterial.fillingMaterialCapacitor.portA);
    connect(earthLayer.earthRings[1].earthResistorInWard.port_a,fillingMaterial.contactResistanceFillingsideEarth.port_b);
    connect(fillingMaterial.contactResistanceFillingsideUpwardPipe.port_a,pieceOfBoreHole.contactResistanceUpwardPipe.port_b);
    connect(fillingMaterial.contactResistanceFillingsideDownwardPipe.port_a,pieceOfBoreHole.contactResistanceDownwardPipe.port_b);
  annotation (Documentation(info="<html>
<p>This model represents one horizontal layer.</p>
<p>A horizontal layer consists of earth, filling material and the borehole. All three of them are connected as described by Bianchi.</p>
<p>The intitial temperature of each earth ring, the filling material and of the brine in the pipes is identical. It depends on the position of the layer, the vertical temperature gradient in the ground and the (initial) ground temperature at the bottom of the borehole. </p>
</html>", revisions="<html>
<p>Original version by Harm Leenders, 2011</p>
<p>Initialisation of brine and filling material temperature at ground temperature by Roel De Coninck, 26/11/2011</p>
</html>"));
end HorizontalLayer;
