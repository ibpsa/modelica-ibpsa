within IBPSA.Utilities.IO.SDF;
model TimeTable "Look-up table for time dependent signals with linear/periodic extrapolation"
  extends Modelica.Blocks.Interfaces.MO(final nout=size(datasetNames, 1));

  parameter Boolean readFromFile = false "false = Read before compilation";
  parameter String fileName = "" "File name" annotation (Dialog(loadSelector(filter="SDF Files (*.sdf);; Dymola Result Files (*.mat);;All Files (*.*)", caption="Select a file")));
  parameter String datasetNames[:] = fill("", 1) "Dataset names";
  parameter String datasetUnits[:] = fill("", size(datasetNames, 1)) "Dataset units";
  parameter String scaleUnit = "" "Scale unit";
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range";
  parameter Real offset[:]= fill(0, nout) "Offsets of output signals";
  parameter Modelica.Units.SI.Time startTime=0 "Output = offset for time < startTime";
  parameter Modelica.Units.SI.Time shiftTime=startTime "Shift time of first table column";
  parameter Modelica.Blocks.Types.TimeEvents timeEvents=Modelica.Blocks.Types.TimeEvents.AtDiscontinuities
    "Time event handling of table interpolation";
  parameter Boolean verboseExtrapolation=false
    "= true, if warning messages are to be printed if time is outside the table definition range";
protected
  parameter Real table[:,:] = SDF.Functions.readTimeSeries(fileName,
        datasetNames, datasetUnits, scaleUnit) annotation(Evaluate=readFromFile);

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(tableOnFile=false,
      table=table,
    startTime=startTime,
    smoothness=smoothness,
    extrapolation=extrapolation,
    offset=offset,
    shiftTime=shiftTime,
    timeEvents=timeEvents,
    verboseExtrapolation=verboseExtrapolation)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(combiTimeTable.y, y)
    annotation (Line(points={{11,0},{58,0},{58,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
    Line(points={{-66,68},{-66,-74}},
      color={95,95,95}),
    Line(points={{-74,-66},{82,-66}},
      color={95,95,95}),
    Polygon(lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid,
      points={{82,-66},{66,-60},{66,-72},{82,-66}}),
      Rectangle(
          extent={{-46,44},{44,-46}},
          lineColor={47,49,172},
          fillColor={255,255,125},
          fillPattern=FillPattern.Solid),
      Line(
        points={{-16,44},{-16,-46}},
        color={161,159,189}),
      Line(
        points={{14,44},{14,-46}},
        color={161,159,189}),
      Line(
        points={{1,44},{1,-46}},
        color={161,159,189},
          origin={-2,-17},
          rotation=90),
      Line(
        points={{1,56},{1,-34}},
        color={161,159,189},
          origin={10,13},
          rotation=90),
      Rectangle(
          extent={{-46,44},{44,-46}},
          lineColor={47,49,172}),
    Polygon(lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid,
      points={{8,0},{-8,6},{-8,-6},{8,0}},
          origin={-66,68},
          rotation=90)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TimeTable;
