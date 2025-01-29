within IBPSA.Utilities.IO.SDF;
model NDTable "N-dimensional lookup-table"
extends Modelica.Blocks.Interfaces.MISO;

parameter Boolean readFromFile = true "Read data from file" annotation(Evaluate=true);
parameter String filename = "" "File name" annotation (Dialog(loadSelector(filter="SDF Files (*.sdf);;All Files (*.*)", caption="Select SDF file")));
parameter String dataset = "" "Dataset name";
parameter String dataUnit = "" "Data unit";
parameter String scaleUnits[nin] = fill("", nin) "Scale units";

parameter SDF.Types.InterpolationMethod interpMethod=SDF.Types.InterpolationMethod.Linear
    "Interpolation method";
parameter SDF.Types.ExtrapolationMethod extrapMethod=SDF.Types.ExtrapolationMethod.None
    "Extrapolation method";

 parameter Real data[:] = { 0}   "Table data (as returned by readTableData())" annotation(Dialog(enable=not readFromFile), Evaluate=true);

protected
  function evaluate
    input SDF.Types.ExternalNDTable table;
    input Real[:] params;
    input SDF.Types.InterpolationMethod interpMethod;
    input SDF.Types.ExtrapolationMethod extrapMethod;
    output Real value;
    external "C" value = ModelicaNDTable_evaluate(table, size(params, 1), params, interpMethod, extrapMethod) annotation (
      Include="#include <ModelicaNDTable.c>",
      IncludeDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/C-Sources");
  end evaluate;

  SDF.Types.ExternalNDTable externalTable=SDF.Types.ExternalNDTable(nin, if readFromFile then SDF.Functions.readTableData(
        Modelica.Utilities.Files.loadResource(filename),
        dataset,
        dataUnit,
        scaleUnits) else data);

equation
                 y = evaluate(
    externalTable,
    u,
    interpMethod,
    extrapMethod);

  annotation (Documentation(info="<html>
<body>
<p>The <strong>NDTable</strong> block is a multi-dimensional lookup-table (up to 32 dimensions) that supports various inter- and extrapolation methods.</p>
</body>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics={
      Rectangle(
          extent={{-58,60},{62,-60}},
          lineColor={47,49,172},
          fillColor={255,255,125},
          fillPattern=FillPattern.Solid),
      Line(
        points={{-18,60},{-18,-60}},
        color={161,159,189}),
      Line(
        points={{22,60},{22,-60}},
        color={161,159,189}),
      Line(
        points={{1,64},{1,-56}},
        color={161,159,189},
          origin={6,-21},
          rotation=90),
      Line(
        points={{1,76},{1,-44}},
        color={161,159,189},
          origin={18,19},
          rotation=90),
        Text(
          extent={{-147,-152},{153,-112}},
          lineColor={0,0,0},
          textString="nin=%nin"),
      Rectangle(
          extent={{-58,60},{62,-60}},
          lineColor={47,49,172})}));
end NDTable;
