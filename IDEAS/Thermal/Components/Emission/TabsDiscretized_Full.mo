within IDEAS.Thermal.Components.Emission;
model TabsDiscretized_Full
  "Discretized tabs system, with discretized floor surface temperature too"

  extends IDEAS.Thermal.Components.Emission.Interfaces.Partial_Tabs;

  replaceable parameter IDEAS.Thermal.Components.BaseClasses.FH_Characteristics
                                                                       FHCharsDiscretized(A_Floor=
        A_Floor/n) constrainedby
    IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(
      A_Floor=A_Floor/n);

  parameter Integer n(min=2)=2 "number of discrete elements";

  IDEAS.Thermal.Components.Emission.Tabs[
                                   n] tabs(
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

  annotation (Diagram(graphics), Documentation(revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2012 April, Roel De Coninck: rebasing on common Partial_Emission</li>
<li>2011, Roel De Coninck: first version and validation</li>
</ul></p>
</html>", info="<html>
<p><b>Description</b> </p>
<p>Fully discretized <a href=\"modelica://IDEAS.Thermal.Components.Emission.Tabs\">tabs</a> model along the flow direction, including arrays of heatPorts at both sides.</p>
<p><h4>Assumptions and limitations </h4></p>
<p>Same as for the Tabs model. </p>
<p><h4>Model use</h4></p>
<p>Same as Tabs model, except that there is an additional parameter for the discretization in the flow direction. </p>
<p>It does <u>not make sense to use this model by connecting the array of heatPorts to a single heatPort</u> again. It can be connected to a single (zone) temperature throug an array of (convective or radiative) resistors.</p>
<p><h4>Validation </h4></p>
<p>See tabs model</p>
<p><h4>Example</h4></p>
<p>To be completed.</p>
</html>"));
end TabsDiscretized_Full;
