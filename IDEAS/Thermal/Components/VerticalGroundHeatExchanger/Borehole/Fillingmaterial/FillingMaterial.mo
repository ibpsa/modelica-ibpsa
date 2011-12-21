within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Borehole.Fillingmaterial;
model FillingMaterial "The filling material."
// **************
// This model represents a fillingmaterial of a borehole. It contains a capacitor and the
// contact resistor between the pipe and the filling material and the contact resistance between
// the earth and the filling material.
// The necessairy information is given with the recordFillingMaterialCapacitor and
// the RecordContactResistanceEarthBoreHole.
// **************
      // * parameters *
      // **************
// This parameter contains the information for the capacitor of filling material.
parameter RecordFillingMaterialCapacitor recordFillingMaterialCapacitor;
// This parameter contains the information for the contactresistor of filling material and the earth.
parameter RecordContactResistanceEarthBoreHole
    recordContactResistanceEarthBoreHole;
// This parameter contains the information for the contactresistor of filling material and the pipes.
parameter RecordContactResistanceBorepipeFilling
    recordContactResistanceBorepipeFilling;
      // **************
      // * variables *
      // **************
// This variable represents the contact resistance between the earth and the filling material.
 VerticalGroundHeatExchanger.Borehole.Fillingmaterial.ContactResistanceFillingsideEarth
    contactResistanceFillingsideEarth(
      recordContactResistanceEarthBoreHole=
        recordContactResistanceEarthBoreHole);
// This variable represents the filling material capacitor.
VerticalGroundHeatExchanger.Borehole.Fillingmaterial.FillingMaterialCapacitor
    fillingMaterialCapacitor(recordFillingMaterialCapacitor=
        recordFillingMaterialCapacitor);
// This variable represents the contact resistoance between the filling material and the pipes.
VerticalGroundHeatExchanger.Borehole.Fillingmaterial.ContactResistanceFillingsidePipe
    contactResistanceFillingsideUpwardPipe(
      recordContactResistanceBorepipeFilling=
        recordContactResistanceBorepipeFilling);
// This variable represents the contact resistoance between the filling material and the pipes.
VerticalGroundHeatExchanger.Borehole.Fillingmaterial.ContactResistanceFillingsidePipe
    contactResistanceFillingsideDownwardPipe(
      recordContactResistanceBorepipeFilling=
        recordContactResistanceBorepipeFilling);
// This variable represents the vertical resistor for conduction in the vertical direction.
VerticalHeatExchangerModels.VerticalResistor verticalResistor(
    lambda=recordContactResistanceEarthBoreHole.lambdaFillMaterial,
    depthOfEarth=recordFillingMaterialCapacitor.depthOfEarth/2,
    innerRadius=recordFillingMaterialCapacitor.innerRadius,
    outerRadius=recordFillingMaterialCapacitor.outerRadius);
VerticalHeatExchangerModels.VerticalResistor verticalResistorUp(
    lambda=recordContactResistanceEarthBoreHole.lambdaFillMaterial,
    depthOfEarth=recordFillingMaterialCapacitor.depthOfEarth/2,
    innerRadius=recordFillingMaterialCapacitor.innerRadius,
    outerRadius=recordFillingMaterialCapacitor.outerRadius);
equation

          // Everything is connected to one point. Towards the pipes is port_a. In the vertical direction, port_a is the most upper port.
  connect(contactResistanceFillingsideEarth.port_a,fillingMaterialCapacitor.portA);
  connect(contactResistanceFillingsideUpwardPipe.port_b,fillingMaterialCapacitor.portA);
  connect(contactResistanceFillingsideDownwardPipe.port_b,fillingMaterialCapacitor.portA);
  connect(fillingMaterialCapacitor.portA, verticalResistor.port_a);
  connect(fillingMaterialCapacitor.portA, verticalResistorUp.port_b);
end FillingMaterial;
