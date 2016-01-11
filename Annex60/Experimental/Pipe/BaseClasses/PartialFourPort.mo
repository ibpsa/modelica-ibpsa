within Annex60.Experimental.Pipe.BaseClasses;
partial model PartialFourPort "Partial component with four ports"
  import Modelica.Constants;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true);

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare final package Medium
      = Medium, m_flow(min=if allowFlowReversal then -Constants.inf else 0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare final package Medium
      = Medium, m_flow(max=if allowFlowReversal then +Constants.inf else 0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,50},{90,70}}),
        iconTransformation(extent={{110,50},{90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare final package Medium
      = Medium, m_flow(min=if allowFlowReversal then -Constants.inf else 0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare final package Medium
      = Medium, m_flow(max=if allowFlowReversal then +Constants.inf else 0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}}),
        iconTransformation(extent={{-90,-70},{-110,-50}})));
  // Model structure, e.g., used for visualization
protected
  parameter Boolean port_a1_exposesState=false
    "= true if port_a exposes the state of a fluid volume";
  parameter Boolean port_b1_exposesState=false
    "= true if port_b.p exposes the state of a fluid volume";
    parameter Boolean port_a2_exposesState=false
    "= true if port_a exposes the state of a fluid volume";
  parameter Boolean port_b2_exposesState=false
    "= true if port_b.p exposes the state of a fluid volume";
  parameter Boolean showDesignFlowDirection=true
    "= false to hide the arrow in the model icon";

  annotation (
    Documentation(info="<html>
<p>This partial model defines an interface for components with four ports. The treatment of the design flow direction and of flow reversal are predefined based on the parameter <code><span style=\"font-family: Courier New,courier;\">allowFlowReversal</span></code>. The component may transport fluid and may have internal storage for a given fluid <code><span style=\"font-family: Courier New,courier;\">Medium</span></code>. </p>
<p>An extending model providing direct access to internal storage of mass or energy through <code><span style=\"font-family: Courier New,courier;\">port_a1/2</span></code> or <code><span style=\"font-family: Courier New,courier;\">port_b1/2</span></code> should redefine the protected parameters <code><span style=\"font-family: Courier New,courier;\">port_a1/2_exposesState</span></code> and <code><span style=\"font-family: Courier New,courier;\">port_b1/2_exposesState</span></code> appropriately. This will be visualized at the port icons, in order to improve the understanding of fluid model diagrams. </p>
<h4>Implementation</h4>
<p>This model is is based on <a href=\"modelica://Annex60/Fluid/Interfaces/PartialTwoPort.mo\">Annex60.Fluid.Interfaces.PartialTwoPort</a>. It uses four ports instead of two.</p>
</html>", revisions="<html>
<ul>
<li>November 6, 2015, by Bram van der Heijde:<br>Adapted to <code><span style=\"font-family: Courier New,courier;\">PartialFourPort</span></code>.</li>
<li>October 21, 2014, by Michael Wetter:<br>Revised implementation. Declared medium in ports to be <code><span style=\"font-family: Courier New,courier;\">final</span></code>. </li>
<li>October 20, 2014, by Filip Jorissen:<br>First implementation as <code><span style=\"font-family: Courier New,courier;\">PartialTwoPort</span></code>. </li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),
        graphics={
        Polygon(
          points={{20,110},{60,95},{20,80},{20,110}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=showDesignFlowDirection),
        Polygon(
          points={{20,105},{50,95},{20,85},{20,105}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowFlowReversal),
        Line(
          points={{55,95},{-60,95}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=showDesignFlowDirection),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-110,84},{-90,34}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          visible=port_a1_exposesState),
        Ellipse(
          extent={{90,-35},{110,-85}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          visible=port_a2_exposesState),
        Ellipse(
          extent={{-110,-36},{-90,-86}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          visible=port_b2_exposesState),
        Ellipse(
          extent={{90,85},{110,35}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          visible=port_b1_exposesState),
        Polygon(
          points={{-20,15},{20,0},{-20,-15},{-20,15}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=showDesignFlowDirection,
          origin={-38,-95},
          rotation=180),
        Polygon(
          points={{-15,10},{15,0},{-15,-10},{-15,10}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowFlowReversal,
          origin={-33,-95},
          rotation=180),
        Line(
          points={{57.5,0},{-57.5,0}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=showDesignFlowDirection,
          origin={3.5,-95},
          rotation=180)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end PartialFourPort;
