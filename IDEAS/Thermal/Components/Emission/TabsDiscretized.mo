within IDEAS.Thermal.Components.Emission;
model TabsDiscretized "Discretized tabs system"

  extends IDEAS.Thermal.Components.Emission.Interfaces.Partial_Tabs;

  replaceable parameter IDEAS.Thermal.Components.BaseClasses.FH_Characteristics
    FHCharsDiscretized(A_Floor=A_Floor/n) constrainedby
    IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(A_Floor=A_Floor/n);

  parameter Integer n(min=2) = 2 "number of discrete elements";

  IDEAS.Thermal.Components.Emission.Tabs[n] tabs(
    each medium=medium,
    each A_Floor=A_Floor/n,
    each m_flowMin=m_flowMin,
    each FHChars=FHCharsDiscretized)
    annotation (Placement(transformation(extent={{-54,-8},{-34,12}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m=
        n) annotation (Placement(transformation(extent={{-54,52},{-34,32}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector1(m
      =n) annotation (Placement(transformation(extent={{-54,-46},{-34,-26}})));
equation
  connect(flowPort_a, tabs[1].flowPort_a) annotation (Line(
      points={{-100,40},{-76,40},{-76,6},{-54,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tabs[n].flowPort_b, flowPort_b) annotation (Line(
      points={{-54,-2},{-76,-2},{-76,-40},{-100,-40}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalCollector.port_b, port_a) annotation (Line(
      points={{-44,52},{-44,74},{0,74},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tabs.port_a, thermalCollector.port_a) annotation (Line(
      points={{-44,12},{-44,32}},
      color={191,0,0},
      smooth=Smooth.None));

  for i in 1:n - 1 loop
    connect(tabs[i].flowPort_b, tabs[i + 1].flowPort_a);
  end for;

  connect(tabs.port_b, thermalCollector1.port_a) annotation (Line(
      points={{-44,-7.8},{-44,-26}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalCollector1.port_b, port_b) annotation (Line(
      points={{-44,-46},{-44,-80},{0,-80},{0,-98}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Documentation(revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2012 April, Roel De Coninck: rebasing on common Partial_Emission</li>
<li>2011, Roel De Coninck: first version and validation</li>
</ul></p>
</html>", info="<html>
<p><b>Description</b> </p>
<p>Discretized <a href=\"modelica://IDEAS.Thermal.Components.Emission.Tabs\">tabs</a> model along the flow direction. </p>
<p>However, there is only one single heatPort at each side of the tabs, so each NakedTabs discrete element sees the same boundary temperature. A fully discretized model can be found <a href=\"modelica://IDEAS.Thermal.Components.Emission.TabsDiscretized_Full\">here</a>.</p>
<p><h4>Assumptions and limitations </h4></p>
<p>Same as for the Tabs model. </p>
<p><h4>Model use</h4></p>
<p>Same as Tabs model, except that there is an additional parameter for the discretization in the flow direction. </p>
<p><h4>Validation </h4></p>
<p>See tabs model</p>
<p><h4>Example</h4></p>
<p>A specific example of the discretized tabs is given in<a href=\"modelica://IDEAS.Thermal.Components.Examples.Tabs_Disretized\"> IDEAS.Thermal.Components.Examples.Tabs_Disretized.</a></p>
</html>"));
end TabsDiscretized;
