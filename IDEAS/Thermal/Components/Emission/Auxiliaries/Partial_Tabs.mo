within IDEAS.Thermal.Components.Emission.Auxiliaries;
partial model Partial_Tabs "Partial tabs model"

  replaceable parameter Thermal.Components.Emission.FH_Characteristics FHChars(A_Floor=
        A_Floor) constrainedby Thermal.Components.Emission.FH_Characteristics(
      A_Floor=A_Floor)                                                    annotation (choicesAllMatching = true);

  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Medium in the component";
  parameter Modelica.SIunits.MassFlowRate m_flowMin
    "Minimal flowrate when in operation";
  parameter Modelica.SIunits.Area A_Floor=1 "Total Surface of the TABS";

  Thermal.Components.Interfaces.FlowPort_a flowPort_a(medium=medium)
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(medium=medium)
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_b
    annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));

  annotation (Diagram(graphics));

end Partial_Tabs;
