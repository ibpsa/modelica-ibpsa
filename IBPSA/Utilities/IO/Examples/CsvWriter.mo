within IBPSA.Utilities.IO.Examples;
model CsvWriter "Example of csv writer use"
  extends Modelica.Icons.Example;
  IBPSA.Utilities.IO.CsvWriter csvWriter(nIn=2, sampleTime=1)
    "Model that writes two inputs to csv file"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.Cosine cos(freqHz=0.345) "Cosine"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Step step(startTime=5) "Step function"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  IBPSA.Utilities.IO.CsvWriter csvWriterDuplicate(
    nIn=2,
    sampleTime=1,
    fileName="test.csv",
    delimiter="    ",
    writeHeader=false)
    "Duplicate to test for conflicts when instantiating multiple csv writers"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
  connect(cos.y, csvWriter.u[1]) annotation (Line(points={{-59,30},{-40,30},{
          -40,-1},{-22,-1}}, color={0,0,127}));
  connect(step.y, csvWriter.u[2]) annotation (Line(points={{-59,-30},{-40,-30},
          {-40,1},{-22,1}},color={0,0,127}));
  connect(csvWriterDuplicate.u, csvWriter.u)
    annotation (Line(points={{-22,-30},{-22,0}}, color={0,0,127}));
  annotation (experiment(StopTime=10), Documentation(revisions="<html>
<ul>
<li>
May 10, 2018 by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/924\">#924</a>.
</li>
</ul>
</html>", info="<html>
<p>
This model demonstrates the use of the csv file writer.
</p>
</html>"));
end CsvWriter;
