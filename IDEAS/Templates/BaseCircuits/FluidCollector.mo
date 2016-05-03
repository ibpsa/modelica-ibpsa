within IDEAS.Templates.BaseCircuits;
model FluidCollector "Collects m fluid flows"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (__Dymola_choicesAllMatching=true);

  parameter Integer m(min=1)=3 "Number of collected heat flows";
  IDEAS.Fluid.Interfaces.FlowPort_a port_a[m](redeclare final package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,110},{10,90}})));
  IDEAS.Fluid.Interfaces.FlowPort_b port_b(redeclare final package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

equation
  for i in 1:m loop
    connect(port_a[i], port_b)
    annotation (Line(points={{0,100},{0,-100},{0,-100}},     color={0,128,255}));
  end for;

  annotation (        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Text(
          extent={{-150,-30},{150,-70}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-150,80},{150,50}},
          lineColor={0,0,0},
          textString="m=%m"),
        Line(
          points={{0,90},{0,40}},
          color={0,128,255}),
        Rectangle(
          extent={{-60,40},{60,30}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,30},{0,-30},{0,-90}},
          color={0,128,255}),
        Line(
          points={{0,-30},{-20,30}},
          color={0,128,255}),
        Line(
          points={{0,-30},{20,30}},
          color={0,128,255}),
        Line(
          points={{0,-30},{60,30}},
          color={0,128,255})}),
    Documentation(info="<html>
<p>
This is a model to collect the heat flows from <i>m</i> heatports to one single heatport.
</p>
</html>"));
end FluidCollector;
