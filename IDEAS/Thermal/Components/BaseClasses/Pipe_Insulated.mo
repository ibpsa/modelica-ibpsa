within IDEAS.Thermal.Components.BaseClasses;
model Pipe_Insulated "Pipe with insulation, characterised by UA"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Medium in the component"
    annotation(choicesAllMatching=true);
  parameter Modelica.SIunits.Mass m(start=1) "Mass of medium";
  // I remove this parameter completely because it can lead to wrong models!!!
  // See note in evernote of RDC
  //parameter Real tapT(final min=0, final max=1)=1
  //  "Defines temperature of heatPort between inlet and outlet temperature";
  parameter Modelica.SIunits.Temperature TInitial=293.15
    "Initial temperature of all Temperature states";

  parameter SI.ThermalConductance UA "Thermal conductance of the insulation";

  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
             heatedPipe(m=m, medium=medium, TInitial=TInitial)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        UA) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-26})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
      Placement(transformation(extent={{-10,-50},{10,-30}}), iconTransformation(
          extent={{-10,-50},{10,-30}})));
  Interfaces.FlowPort_a flowPort_a(medium=medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FlowPort_b flowPort_b(medium=medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  connect(heatedPipe.heatPort, thermalConductor.port_b) annotation (Line(
      points={{0,-10},{0,-16},{6.12323e-016,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_a, heatPort) annotation (Line(
      points={{-6.12323e-016,-36},{0,-36},{0,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatedPipe.flowPort_a, flowPort_a) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(heatedPipe.flowPort_b, flowPort_b) annotation (Line(
      points={{10,0},{100,0}},
      color={0,128,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-40},{100,40}}),
                      graphics), Icon(coordinateSystem(extent={{-100,-40},{100,
            40}}, preserveAspectRatio=true),
                                      graphics={
        Line(
          points={{-68,20},{-68,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{68,20},{68,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-68,0},{-100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{68,0},{100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Rectangle(
          extent={{-60,20},{60,-20}},
          lineColor={100,100,100},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><b>General description</b> </p>
<p><h5>Goal</h5></p>
<p>Insulated pipe: heat exchange with the environment is based on UA-value of the insulation.</p>
<p><h5>Description </h5></p>
<p>Model for fluid flow through a pipe, including heat losses or gains with the environment through insulation. A dynamic heat balance is included, based on the in- and outlet enthalpy flow, the heat flux to/from environment and the internal mass m of the fluid content in the pipe. A stationary model is obtained when m=0 </p>
<p>m.cv.der(T) = ( h_flow_in - h_flow_out) - UA.(T - TAmb) </p>
<p><b>Note:</b> as can be seen from the equation, the pipe temperature T will converge to the ambient temperature when there is no mass flow rate. </p>
<p><h5>Assumptions and limitations </h5></p>
<p><ol>
<li>No pressure drop</li>
<li>Conservation of mass</li>
<li>Heat losses/gains with environment through conduction based on UA-value</li>
</ol></p>
<p><h4>Parameters</h4></p>
<p>The following parameters have to be set by the user</p>
<p><ol>
<li>medium</li>
<li>mass of fluid in the pipe (<b>Note:</b> Setting parameter m to zero leads to neglection of temperature transient cv.m.der(T).)</li>
<li>initial temperature of the fluid (defaults to 20&deg;C)</li>
<li>UA-value (W/K)</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>No validation performed; the model is based on physical principles</p>
<p><h4>Revision, history and contact </h4></p>
<p><ul>
<li>2013 May 23, Roel De Coninck, documentation;</li>
<li>2012 November, Roel De Coninck, first implementation. </li>
</ul></p>
</html>"));
end Pipe_Insulated;
