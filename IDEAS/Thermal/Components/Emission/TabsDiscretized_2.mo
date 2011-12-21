within IDEAS.Thermal.Components.Emission;
model TabsDiscretized_2
  "Discretized tabs system, with discretized floor surface temperature too"

  extends Thermal.Components.Emission.Auxiliaries.Partial_Tabs;

  replaceable parameter Thermal.Components.Emission.FH_Characteristics FHCharsDiscretized(A_Floor=
        A_Floor/n) constrainedby Thermal.Components.Emission.FH_Characteristics(
      A_Floor=A_Floor/n);

  parameter Integer n(min=2)=2 "number of discrete elements";

  Thermal.Components.Emission.Tabs[n] tabs(
    each medium=medium,
    each A_Floor=A_Floor/n,
    each m_flowMin=m_flowMin,
    each FHChars=FHCharsDiscretized)
    annotation (Placement(transformation(extent={{-54,-8},{-34,12}})));

equation
  connect(flowPort_a, tabs[1].flowPort_a) annotation (Line(
      points={{-100,40},{-76,40},{-76,6},{-54,6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tabs[n].flowPort_b, flowPort_b) annotation (Line(
      points={{-54,-2},{-76,-2},{-76,-40},{-100,-40}},
      color={255,0,0},
      smooth=Smooth.None));

  for i in 1:n-1 loop
    connect(tabs[i].flowPort_b,tabs[i+1].flowPort_a);
  end for;
  for i in 1:n loop
    connect(tabs[i].port_b, port_b);
  end for;

  annotation (Diagram(graphics));
end TabsDiscretized_2;
