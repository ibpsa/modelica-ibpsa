within Annex60.Fluid.Interfaces;
model AdaptorModelicaFluid "Adaptor to connect to Modelica.Fluid"
  replaceable package MediumAnnex60 =
      Modelica.Media.Interfaces.PartialMedium
    "Medium used in the Annex60 Library"
      annotation (choicesAllMatching = true);
  replaceable package MediumMSL = MediumAnnex60
    "Medium used in the Modelica Standard Library"
      annotation (choicesAllMatching = true);
  FluidPort_a portAnnex60(
    redeclare final package Medium = MediumAnnex60)
    "Port that connects to models of the Annex60 library"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b portMSL(
    redeclare final package Medium = MediumMSL)
    "Port that connects to models of the Modelica Standard Library"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  portAnnex60.m_flow     = - portMSL.m_flow;
  portAnnex60.p          = portMSL.p;
  portAnnex60.T_outflow  = MediumMSL.temperature_phX(
                             p=portMSL.p,
                             h=inStream(portMSL.h_outflow),
                             X=inStream(portMSL.Xi_outflow));
  portAnnex60.Xi_outflow  = inStream(portMSL.Xi_outflow);
  portAnnex60.C_outflow   = inStream(portMSL.C_outflow);

  portMSL.h_outflow      = MediumMSL.specificEnthalpy_pTX(
                             p=portAnnex60.p,
                             T=inStream(portAnnex60.T_outflow),
                             X=inStream(portAnnex60.Xi_outflow));
  portMSL.Xi_outflow     = inStream(portAnnex60.Xi_outflow);
  portMSL.C_outflow      = inStream(portAnnex60.C_outflow);

annotation (defaultComponentName="ada",
preferredView="info",
Documentation(info="<html>
<p>
This model is a an adaptor that connect models between
Model that tests the adaptor from
<a href=\"modelica://Annex60.Fluid\">Annex60.Fluid</a>
and
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 23, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Line(
          points={{-90,0},{94,0}},
          color={0,0,255},
          smooth=Smooth.None),   Text(
          extent={{-153,59},{147,19}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}));
end AdaptorModelicaFluid;
