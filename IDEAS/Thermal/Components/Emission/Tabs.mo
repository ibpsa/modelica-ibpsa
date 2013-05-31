within IDEAS.Thermal.Components.Emission;
model Tabs "Tabs system, not discretized"

  extends IDEAS.Thermal.Components.Emission.Interfaces.Partial_Tabs;

  replaceable EmbeddedPipe                                    embeddedPipe(
    medium=medium,
    FHChars=FHChars,
    m_flowMin=m_flowMin) constrainedby
    IDEAS.Thermal.Components.Emission.Interfaces.Partial_EmbeddedPipe(
    medium=medium,
    FHChars=FHChars,
    m_flowMin=m_flowMin)
    annotation (choices(
      choice(redeclare IDEAS.Thermal.Components.Emission.EmbeddedPipe_prEN15377
                                                                              embeddedPipe),
      choice(redeclare IDEAS.Thermal.Components.Emission.EmbeddedPipe              embeddedPipe)),
      Placement(transformation(extent={{-56,-8},{-36,12}})));

  IDEAS.Thermal.Components.Emission.NakedTabs
            nakedTabs(FHChars=FHChars, n1=FHChars.n1, n2=FHChars.n2) annotation (Placement(transformation(extent={{-12,-8},{8,12}})));
    // It's a bit stupid to explicitly pass n1 and n2 again, but it's the only way to avoid warnings/errors in dymola 2012.
equation
  connect(flowPort_a, embeddedPipe.flowPort_a) annotation (Line(
      points={{-100,40},{-70,40},{-70,-4.25},{-56,-4.25}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flowPort_b, embeddedPipe.flowPort_b) annotation (Line(
      points={{-100,-40},{-26,-40},{-26,8.25},{-36,8.25}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(nakedTabs.port_a, port_a) annotation (Line(
      points={{-2,12},{-2,100},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs.port_b, port_b) annotation (Line(
      points={{-2,-7.8},{-2,-98},{0,-98}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(embeddedPipe.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{-51.8333,11.75},{-51.8333,20},{-18,20},{-18,2},{-12,2}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics),
    Documentation(revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2012 April, Roel De Coninck: rebasing on common Partial_Emission</li>
<li>2011, Roel De Coninck: first version and validation</li>
</ul></p>
</html>", info="<html>
<p><b>Description</b> </p>
<p>The Tabs model integrates an <a href=\"modelica://IDEAS.Thermal.Components.Emission.EmbeddedPipe\">EmbeddedPipe</a> and a <a href=\"modelica://IDEAS.Thermal.Components.Emission.NakedTabs\">NakedTabs</a> into a complete thermal emission system.  This model is not disretized along the length of the embedded pipe (along the flow).  For a model with discretization along the flow direction, choose either the <a href=\"modelica://IDEAS.Thermal.Components.Emission.TabsDiscretized\">TabsDiscretized</a> or <a href=\"modelica://IDEAS.Thermal.Components.Emission.TabsDiscretized_Full\">TabsDiscretized_Full</a> model. </p>
<p><h4>Assumptions and limitations </h4></p>
<p>See the <a href=\"modelica://IDEAS.Thermal.Components.Emission.EmbeddedPipe\">EmbeddedPipe</a> and a <a href=\"modelica://IDEAS.Thermal.Components.Emission.NakedTabs\">NakedTabs</a> models for more information. </p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Which are the important, the tuning and the &QUOT;negligeable&QUOT; parameters. </li>
<li>What are the default value of the model and how have then been chosen. </li>
</ol></p>
<p><h4>Validation </h4></p>
<p>Description of the validation procedure and results </p>
<p><h4>Example (optional) </h4></p>
<p>Link to an example for the component and (optional) examples where the component is used. </p>
</html>"));
end Tabs;
