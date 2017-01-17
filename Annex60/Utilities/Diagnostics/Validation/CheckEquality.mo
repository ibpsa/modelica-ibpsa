within Annex60.Utilities.Diagnostics.Validation;
model CheckEquality "Validation model for the check equality model"
  import Annex60;
  extends Modelica.Icons.Example;

  Annex60.Utilities.Diagnostics.CheckEquality cheEqu
    annotation (Placement(transformation(extent={{-10,8},{10,28}})));
  Modelica.Blocks.Sources.Constant con(k=0.1) "Input"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.Constant con1(k=0.12) "Input"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Annex60.Utilities.Diagnostics.CheckEquality cheEqu1
    annotation (Placement(transformation(extent={{-10,-72},{10,-52}})));
  Modelica.Blocks.Sources.Constant con2(k=0.1) "Input"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.Constant con3(k=0.1) "Input"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
equation

  connect(con.y, cheEqu.u1) annotation (Line(points={{-39,40},{-20,40},{-20,24},
          {-12,24}}, color={0,0,127}));
  connect(con1.y, cheEqu.u2) annotation (Line(points={{-39,0},{-20,0},{-20,12},{
          -12,12}}, color={0,0,127}));
  connect(con2.y, cheEqu1.u1) annotation (Line(points={{-39,-40},{-20,-40},{-20,
          -56},{-12,-56}}, color={0,0,127}));
  connect(con3.y, cheEqu1.u2) annotation (Line(points={{-39,-80},{-20,-80},{-20,
          -68},{-12,-68}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file="Resources/Scripts/Dymola/Utilities/Diagnostics/Validation/CheckEquality.mos"
        "Simulate and plot"),
  Documentation(
    info="<html>
<p>
This model validates the use of the
<a href=\"modelica://Annex60.Utilities.Diagnostics.CheckEquality\">
Annex60.Utilities.Diagnostics.CheckEquality</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
Januray 17, 2017, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-6, StartTime=0.0, StopTime=1.0));
end CheckEquality;
