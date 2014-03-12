within IDEAS.Thermal.Components.Emission.Interfaces;
partial model Partial_Tabs "Partial tabs model"

  replaceable parameter IDEAS.Thermal.Components.BaseClasses.FH_Characteristics
    FHChars(A_Floor=A_Floor) constrainedby
    IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(A_Floor=A_Floor)
    annotation (choicesAllMatching=true);

  parameter Modelica.SIunits.MassFlowRate m_flowMin
    "Minimal flowrate when in operation";
  parameter Modelica.SIunits.Area A_Floor=1 "Total Surface of the TABS";

  Thermal.Components.Interfaces.FlowPort_a flowPort_a(redeclare package Medium
      = Medium)
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(redeclare package Medium
      = Medium)
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_b
    annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Documentation(info="<html>
<p>This partial model mainly specifies the interfaces of a TABS:</p>
<p>- two flowPorts, for the fluid connections (in and out)</p>
<p>- two heatPorts, for heat transfer to the upper and lower side. By not connecting a heatPort, no heat transfer through that port wil occur (=perfectly insulated).</p>
<p>Furthermore, it specifies a Floor area and the floor characteristics.</p>
<p>It takes two models to create a full TABS: an embedded pipe and a naked tabs.  Actually, the embedded pipe components are often used together with a building component, and in that case the naked tabs model and this partial model are not needed: the embedded heatPort of the EmbeddedPipe is connected to the corresponding layer in the building model. </p>
</html>"));

end Partial_Tabs;
