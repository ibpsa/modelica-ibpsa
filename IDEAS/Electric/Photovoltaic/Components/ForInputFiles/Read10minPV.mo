within IDEAS.Electric.Photovoltaic.Components.ForInputFiles;
model Read10minPV
Real P_paneel;
protected
parameter String fileName= "Input/onePVpanel10min";

Modelica.Blocks.Tables.CombiTable1Ds P(
    final smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile = true,
    tableName = "data",
    fileName = fileName,
    columns = {2});

equation
time=P.u;
P_paneel=P.y[1];
annotation (defaultComponentName="PV1", defaultComponentPrefixes="inner",  missingInnerMessage="Your model is using an outer \"PV1\" component. An inner \"PV1\" component is not defined. For simulation drag ELECTAPub.PV.ForInputFiles.Read10minPV into your model.",
        Icon(graphics={                                                                     Bitmap(
          extent={{-100,100},{100,-100}},
          fileName="modelica://IDEAS/Electric/PV.png"),
          Bitmap(extent={{124,-106},{34,-32}}, fileName="modelica://BWF/../bluetooth.png")}));
end Read10minPV;
