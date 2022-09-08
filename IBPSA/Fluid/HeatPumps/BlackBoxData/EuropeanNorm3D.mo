within IBPSA.Fluid.HeatPumps.BlackBoxData;
model EuropeanNorm3D "3D table with data for heat pump"
  extends IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
  datasource="EuropeanNorm3D",
  QUseBlackBox_flow_nominal=evaluate(
    externalTable,
    {y_nominal, TEva_nominal, TCon_nominal},
    nDTableQCon.interpMethod,
    nDTableQCon.extrapMethod));
  parameter Real nConv=100
    "Gain value multiplied with relative compressor speed n to calculate matching value based on sdf tables";
  parameter SDF.Types.InterpolationMethod interpMethod=SDF.Types.InterpolationMethod.Linear
    "Interpolation method";
  parameter SDF.Types.ExtrapolationMethod extrapMethod=SDF.Types.ExtrapolationMethod.None
    "Extrapolation method";
  parameter String filename_Pel=
      "modelica://Resources/Data/Fluid/BaseClasses/PerformanceData/LookUpTableND/VZH088AG.sdf"
                                   "File name of sdf table data"
    annotation (Dialog(group="Electrical Power",loadSelector(filter="SDF Files (*.sdf);;All Files (*.*)", caption="Select SDF file")));
  parameter String dataset_Pel="/Pel"
                                  "Dataset name"
    annotation (Dialog(group="Electrical Power"));
  parameter String dataUnit_Pel="W"
                                   "Data unit"
    annotation (Dialog(group="Electrical Power"));
  parameter String scaleUnits_Pel[3]={"K","K",""}
                                                 "Scale units"
    annotation (Dialog(group="Electrical Power"));
  parameter String filename_QCon=
      "modelica://Resources/Data/Fluid/BaseClasses/PerformanceData/LookUpTableND/VZH088AG.sdf"
                                    "File name of sdf table data"
    annotation (Dialog(group="Condenser heat flow",loadSelector(filter="SDF Files (*.sdf);;All Files (*.*)", caption="Select SDF file")));
  parameter String dataset_QCon="/QCon"
                                   "Dataset name"
    annotation (Dialog(group="Condenser heat flow"));
  parameter String dataUnit_QCon="W"
                                    "Data unit"
    annotation (Dialog(group="Condenser heat flow"));
  parameter String scaleUnits_QCon[3]={"K","K",""}
                                                  "Scale units"
    annotation (Dialog(group="Condenser heat flow"));

  Modelica.Blocks.Math.Gain nConGain(final k=nConv)
    "Convert relative speed n to an absolute value for interpolation in sdf tables"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,150})));
 Modelica.Blocks.Math.UnitConversions.To_degC t_Ev_in
    annotation (extent=[-88,38; -76,50], Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=90,
        origin={-10,150})));
  Modelica.Blocks.Math.UnitConversions.To_degC t_Co_ou annotation (extent=[-88,38;
        -76,50], Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,150})));
  Modelica.Blocks.Logical.Switch       switchPel
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-10})));
  Modelica.Blocks.Logical.Switch       switchQCon
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,-10})));
  Modelica.Blocks.Sources.Constant constZero(final k=0)
    "Power if HP is turned off"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-30})));
  SDF.NDTable nDTableQCon(
    final nin=3,
    final readFromFile=true,
    final filename=filename_QCon,
    final dataset=dataset_QCon,
    final dataUnit=dataUnit_QCon,
    final scaleUnits=scaleUnits_QCon,
    final interpMethod=interpMethod,
    final extrapMethod=extrapMethod) "SDF-Table data for condenser heat flow"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,70})));
  SDF.NDTable nDTablePel(
    final nin=3,
    final readFromFile=true,
    final filename=filename_Pel,
    final dataset=dataset_Pel,
    final dataUnit=dataUnit_Pel,
    final scaleUnits=scaleUnits_Pel,
    final interpMethod=interpMethod,
    final extrapMethod=extrapMethod) "SDF table data for electrical power"
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,70})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1(
    final n1=1,
    final n2=1,
    final n3=1) "Concat all inputs into an array"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,150})));

  Modelica.Blocks.Math.Product scalingFacTimesQCon annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,30})));
  Modelica.Blocks.Math.Product scalingFacTimesPel annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,30})));
protected
  Modelica.Blocks.Sources.Constant realCorr(final k=finalScalingFactor)
    "Calculates correction of table output based on scaling factor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,30})));
  function evaluate
    input SDF.Types.ExternalNDTable table;
    input Real[:] params;
    input SDF.Types.InterpolationMethod interpMethod;
    input SDF.Types.ExtrapolationMethod extrapMethod;
    output Real value;
    external "C" value = ModelicaNDTable_evaluate(table, size(params, 1), params, interpMethod, extrapMethod) annotation (
      Include="#include <ModelicaNDTable.c>",
      IncludeDirectory="modelica://SDF/Resources/C-Sources");
  end evaluate;

  parameter SDF.Types.ExternalNDTable externalTable=SDF.Types.ExternalNDTable(nDTableQCon.nin, SDF.Functions.readTableData(
        Modelica.Utilities.Files.loadResource(nDTableQCon.filename),
        nDTableQCon.dataset,
        nDTableQCon.dataUnit,
        nDTableQCon.scaleUnits));
equation

  connect(constZero.y, switchQCon.u3) annotation (Line(points={{10,-19},{10,-6},
          {-14,-6},{-14,6},{-38,6},{-38,2}},
                               color={0,0,127}));
  connect(constZero.y, switchPel.u3) annotation (Line(points={{10,-19},{10,2},{42,
          2}},            color={0,0,127}));
  connect(multiplex3_1.y, nDTableQCon.u) annotation (Line(points={{70,139},{70,88},
          {-70,88},{-70,82}},             color={0,0,127}));
  connect(multiplex3_1.y, nDTablePel.u) annotation (Line(points={{70,139},{70,88},
          {50,88},{50,82}},                  color={0,0,127}));
  connect(sigBus.TEvaInMea, t_Ev_in.u) annotation (Line(
      points={{1,104},{0,104},{0,106},{-10,106},{-10,138}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sigBus.TConOutMea, t_Co_ou.u) annotation (Line(
      points={{1,104},{30,104},{30,138}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sigBus.ySet, nConGain.u) annotation (Line(
      points={{1,104},{-50,104},{-50,138}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(nConGain.y, multiplex3_1.u3[1]) annotation (Line(points={{-50,161},{-50,
          166},{54,166},{54,162},{63,162}},                    color={0,0,127}));
  connect(t_Co_ou.y, multiplex3_1.u1[1]) annotation (Line(points={{30,161},{30,174},
          {78,174},{78,168},{77,168},{77,162}},
                                        color={0,0,127}));
  connect(t_Ev_in.y, multiplex3_1.u2[1]) annotation (Line(points={{-10,161},{56,
          161},{56,168},{70,168},{70,162}},
                                color={0,0,127}));
  connect(realCorr.y, scalingFacTimesQCon.u1) annotation (Line(points={{-19,30},
          {-14,30},{-14,48},{-64,48},{-64,42}},
                                    color={0,0,127}));
  connect(nDTableQCon.y, scalingFacTimesQCon.u2) annotation (Line(points={{-70,59},
          {-70,50},{-76,50},{-76,42}},    color={0,0,127}));
  connect(scalingFacTimesQCon.y, switchQCon.u1) annotation (Line(points={{-70,19},
          {-70,6},{-44,6},{-44,8},{-16,8},{-16,2},{-22,2}},
                                                       color={0,0,127}));
  connect(realCorr.y, scalingFacTimesPel.u2) annotation (Line(points={{-19,30},{
          -14,30},{-14,48},{64,48},{64,42}},
                                  color={0,0,127}));
  connect(nDTablePel.y, scalingFacTimesPel.u1)
    annotation (Line(points={{50,59},{50,50},{76,50},{76,42}},
                                                color={0,0,127}));
  connect(scalingFacTimesPel.y, switchPel.u1) annotation (Line(points={{70,19},{
          70,2},{58,2}},                        color={0,0,127}));
  connect(switchPel.y, calcRedQCon.u2) annotation (Line(points={{50,-21},{50,-50},
          {64,-50},{64,-58}},            color={0,0,127}));
  connect(switchPel.y, Pel) annotation (Line(points={{50,-21},{50,-26},{-12,-26},
          {-12,-94},{0,-94},{0,-110}},
                     color={0,0,127}));
  connect(switchQCon.y, feedbackHeatFlowEvaporator.u1) annotation (Line(points={{-30,-21},
          {-30,-22},{-50,-22},{-50,4},{-84,4},{-84,-10},{-78,-10}},  color={0,0,
          127}));
  connect(switchPel.y, feedbackHeatFlowEvaporator.u2) annotation (Line(points={{50,-21},
          {50,-26},{-70,-26},{-70,-18}},
                 color={0,0,127}));
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
  annotation (Icon(coordinateSystem(extent={{-100,-100},{100,180}}),
                   graphics={
    Line(points={{-60.0,40.0},{-60.0,-40.0},{60.0,-40.0},{60.0,40.0},{30.0,40.0},{30.0,-40.0},{-30.0,-40.0},{-30.0,40.0},{-60.0,40.0},{-60.0,20.0},{60.0,20.0},{60.0,0.0},{-60.0,0.0},{-60.0,-20.0},{60.0,-20.0},{60.0,-40.0},{-60.0,-40.0},{-60.0,40.0},{60.0,40.0},{60.0,-40.0}}),
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
  for the innerCycle of the heat pump model. This model assumes one
  provides data for inverter controlled heat pumps or chillers.
  However, this basis structure can be used to create own models, where
  electrical power and condenser depend on other inputs, such as
  ambient temperature.
</p>
<ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", revisions="<html>
<ul>
  <li>
    <i>May 21, 2021</i> by Fabian Wuellhorst:<br/>
    Make use of BaseClasses (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/1092\">#1092</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,180}})));
end EuropeanNorm3D;
