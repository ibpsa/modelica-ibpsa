within IBPSA.Fluid.HeatPumps.BlackBoxData;
model EuropeanNorm3D "3D table with data for heat pump"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
      datSou="EuropeanNorm3D", QUseBlaBox_flow_nominal=evaluate(
        externalTable,
        {y_nominal,TEva_nominal,TCon_nominal},
        tabQCon_flow.interpMethod,
        tabQCon_flow.extrapMethod));
  parameter Real nComSpeGain=100
    "Gain value multiplied with relative compressor speed 
    n to calculate matching value based on sdf tables";
  parameter SDF.Types.InterpolationMethod intMet=
    SDF.Types.InterpolationMethod.Linear
    "Interpolation method";
  parameter SDF.Types.ExtrapolationMethod extMet=
    SDF.Types.ExtrapolationMethod.None
    "Extrapolation method";
  parameter String filename_Pel
      "File name of sdf table data"
    annotation (Dialog(group="Electrical Power",
      loadSelector(filter="SDF Files (*.sdf);;All Files (*.*)",
      caption="Select SDF file")));
  parameter String dataset_Pel="/Pel" "Dataset name"
    annotation (Dialog(group="Electrical Power"));
  parameter String dataUnit_Pel="W"
                                   "Data unit"
    annotation (Dialog(group="Electrical Power"));
  parameter String scaleUnits_Pel[3]={"K","K",""} "Scale units"
    annotation (Dialog(group="Electrical Power"));
  parameter String filename_QCon "File name of sdf table data"
    annotation (Dialog(group="Condenser heat flow",
        loadSelector(filter="SDF Files (*.sdf);;All Files (*.*)",
        caption="Select SDF file")));
  parameter String dataset_QCon="/QCon" "Dataset name"
    annotation (Dialog(group="Condenser heat flow"));
  parameter String dataUnit_QCon="W"
                                    "Data unit"
    annotation (Dialog(group="Condenser heat flow"));
  parameter String scaleUnits_QCon[3]={"K","K",""} "Scale units"
    annotation (Dialog(group="Condenser heat flow"));

  Modelica.Blocks.Math.Gain nComGain(final k=nComSpeGain)
    "Convert relative speed n to an 
    absolute value for interpolation in sdf tables"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
    rotation=90,
        origin={-70,150})));
  Modelica.Blocks.Math.UnitConversions.To_degC TEvaInToDegC
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
    rotation=90,
        origin={32,130})));
  Modelica.Blocks.Math.UnitConversions.To_degC TConOutToDegC
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
        origin={-30,130})));
  Modelica.Blocks.Logical.Switch switchPel
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-10})));
  Modelica.Blocks.Logical.Switch switchQCon
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,-10})));
  Modelica.Blocks.Sources.Constant constZero(final k=0)
    "Power if HP is turned off"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-10})));
  SDF.NDTable tabQCon_flow(
    final nin=3,
    final readFromFile=true,
    final filename=filename_QCon,
    final dataset=dataset_QCon,
    final dataUnit=dataUnit_QCon,
    final scaleUnits=scaleUnits_QCon,
    final interpMethod=intMet,
    final extrapMethod=extMet) "SDF-Table data for condenser heat flow"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
        origin={70,50})));
  SDF.NDTable tabPel(
    final nin=3,
    final readFromFile=true,
    final filename=filename_Pel,
    final dataset=dataset_Pel,
    final dataUnit=dataUnit_Pel,
    final scaleUnits=scaleUnits_Pel,
    final interpMethod=intMet,
    final extrapMethod=extMet) "SDF table data for electrical power"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
        origin={-30,50})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1(
    final n1=1,
    final n2=1,
    final n3=1) "Concat all inputs into an array"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,150})));

  Modelica.Blocks.Math.Product scaFacGainQCon annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, rotation=-90,
        origin={-70,50})));
  Modelica.Blocks.Math.Product scaFacGainPel annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, rotation=-90,
        origin={30,50})));
protected
  Modelica.Blocks.Sources.Constant constScaFac(final k=scaFac)
    "Calculates correction of table output based on scaling factor"
    annotation (Placement(
        transformation(extent={{-100,120},{-80,140}},
                                                   rotation=0)));
  function evaluate
    input SDF.Types.ExternalNDTable table;
    input Real[:] params;
    input SDF.Types.InterpolationMethod interpMethod;
    input SDF.Types.ExtrapolationMethod extrapMethod;
    output Real value;
    external "C" value = ModelicaNDTable_evaluate(
      table, size(params, 1), params, interpMethod, extrapMethod)
      annotation (Include="#include <ModelicaNDTable.c>",
      IncludeDirectory="modelica://SDF/Resources/C-Sources");
  end evaluate;

  parameter SDF.Types.ExternalNDTable externalTable=SDF.Types.ExternalNDTable(
      tabQCon_flow.nin, SDF.Functions.readTableData(
      Modelica.Utilities.Files.loadResource(tabQCon_flow.filename),
      tabQCon_flow.dataset,
      tabQCon_flow.dataUnit,
      tabQCon_flow.scaleUnits));
equation

  connect(constZero.y, switchQCon.u3) annotation (Line(points={{10,1},{10,6},{
          -24,6},{-24,8},{-38,8},{-38,2}},
                               color={0,0,127}));
  connect(constZero.y, switchPel.u3) annotation (Line(points={{10,1},{10,6},{34,
          6},{34,2},{42,2}},
                          color={0,0,127}));
  connect(multiplex3_1.y, tabQCon_flow.u) annotation (Line(points={{70,139},{70,
          134},{54,134},{54,64},{64,64},{64,68},{70,68},{70,62}},
                              color={0,0,127}));
  connect(multiplex3_1.y, tabPel.u) annotation (Line(points={{70,139},{70,134},
          {54,134},{54,76},{-30,76},{-30,62}},
                       color={0,0,127}));
  connect(sigBus.TEvaInMea, TEvaInToDegC.u) annotation (Line(
      points={{1,104},{16,104},{16,118},{32,118}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sigBus.TConOutMea, TConOutToDegC.u) annotation (Line(
      points={{1,104},{-30,104},{-30,118}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sigBus.ySet,nComGain.u)  annotation (Line(
      points={{1,104},{-70,104},{-70,138}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(nComGain.y, multiplex3_1.u3[1]) annotation (Line(points={{-70,161},{
          -70,164},{56,164},{56,162},{63,162}},                color={0,0,127}));
  connect(TConOutToDegC.y, multiplex3_1.u1[1]) annotation (Line(points={{-30,141},
          {-30,168},{77,168},{77,162}},                color={0,0,127}));
  connect(TEvaInToDegC.y, multiplex3_1.u2[1]) annotation (Line(points={{32,141},
          {32,170},{70,170},{70,162}},     color={0,0,127}));
  connect(constScaFac.y, scaFacGainQCon.u1) annotation (Line(points={{-79,130},
          {-74,130},{-74,86},{-56,86},{-56,70},{-64,70},{-64,62}},
                                      color={0,0,127}));
  connect(scaFacGainQCon.y, switchQCon.u1) annotation (Line(points={{-70,39},{
          -70,14},{-22,14},{-22,2}},                color={0,0,127}));
  connect(constScaFac.y, scaFacGainPel.u2) annotation (Line(points={{-79,130},{
          -74,130},{-74,86},{-56,86},{-56,66},{18,66},{18,68},{24,68},{24,62}},
                                        color={0,0,127}));
  connect(tabPel.y, scaFacGainPel.u1)
    annotation (Line(points={{-30,39},{-30,34},{-16,34},{-16,72},{36,72},{36,62}},
                                                            color={0,0,127}));
  connect(scaFacGainPel.y, switchPel.u1)
    annotation (Line(points={{30,39},{30,12},{56,12},{56,6},{64,6},{64,2},{58,2}},
                                                    color={0,0,127}));
  connect(switchPel.y, redQCon.u2) annotation (Line(points={{50,-21},{50,-50},
          {64,-50},{64,-58}}, color={0,0,127}));
  connect(switchPel.y, PEle) annotation (Line(points={{50,-21},{50,-26},{-12,-26},
          {-12,-94},{0,-94},{0,-110}}, color={0,0,127}));
  connect(switchQCon.y, feeHeaFloEva.u1) annotation (Line(points={{-30,-21},{-30,
          -22},{-50,-22},{-50,4},{-84,4},{-84,-10},{-78,-10}}, color={0,0,127}));
  connect(switchPel.y, feeHeaFloEva.u2) annotation (Line(points={{50,-21},{50,
          -26},{-70,-26},{-70,-18}}, color={0,0,127}));
  connect(switchQCon.u2, sigBus.onOffMea) annotation (Line(points={{-30,2},{-30,
          12},{-94,12},{-94,96},{1,96},{1,104}},                 color={255,0,
          255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchPel.u2, sigBus.onOffMea) annotation (Line(points={{50,2},{52,2},
          {52,8},{90,8},{90,96},{1,96},{1,104}},               color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(tabQCon_flow.y, scaFacGainQCon.u2) annotation (Line(points={{70,39},{
          70,26},{0,26},{0,82},{-76,82},{-76,62},{-76,62}}, color={0,0,127}));
  annotation (Icon(graphics={
    Line(points={
          {-60.0,40.0},{-60.0,-40.0},{60.0,-40.0},
          {60.0,40.0},{30.0,40.0},{30.0,-40.0},{-30.0,-40.0},{-30.0,40.0},
          {-60.0,40.0},{-60.0,20.0},{60.0,20.0},{60.0,0.0},{-60.0,0.0},
          {-60.0,-20.0},{60.0,-20.0},{60.0,-40.0},{-60.0,-40.0},{-60.0,40.0},
          {60.0,40.0},{60.0,-40.0}}),
    Line(points={{0.0,40.0},{0.0,-40.0}}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,0.0},{-30.0,20.0}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,-40.0},{-30.0,-20.0}}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-60,-20},{-30,0}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-60,-40},{-30,-20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-30,-40},{0,-20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{0,-40},{30,-20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{30,-40},{60,-20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{30,-20},{60,0}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{0,-20},{30,0}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{0,0},{30,20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{30,0},{60,20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{0,20},{30,40}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{30,20},{60,40}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-60,20},{-30,40}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-30,20},{0,40}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-30,0},{0,20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-30,-20},{0,0}},
          lineColor={0,0,0})}),                Documentation(info="<html><p>
  Basic models showing the concept of using n-dimensional table data
  for the black-box vapour compression cycle of the heat pump model. 
  This model assumes one provides data for inverter controlled heat pumps or chillers.
  However, this basis structure can be used to create own models, where
  electrical power and condenser depend on other inputs, such as
  ambient temperature.
</p>
<ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", revisions="<html>
<ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on IPBSA guidelines <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 21, 2021</i> by Fabian Wuellhorst:<br/>
    Make use of BaseClasses (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/1092\">#1092</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,180}})));
end EuropeanNorm3D;
