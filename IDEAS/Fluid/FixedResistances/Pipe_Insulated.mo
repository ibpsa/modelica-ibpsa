within IDEAS.Fluid.FixedResistances;
model Pipe_Insulated "Pipe with insulation, characterised by UA"
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=true, dp_nominal = 0);

  parameter Modelica.SIunits.Mass m(start=1) "Mass of medium";
  // I remove this parameter completely because it can lead to wrong models!!!
  // See note in evernote of RDC
  //parameter Real tapT(final min=0, final max=1)=1
  //  "Defines temperature of heatPort between inlet and outlet temperature";

  parameter SI.ThermalConductance UA "Thermal conductance of the insulation";

  IDEAS.Fluid.FixedResistances.Pipe_HeatPort heatedPipe(
    m=m,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    from_dp=from_dp,
    dp_nominal=dp_nominal,
    linearizeFlowResistance=linearizeFlowResistance,
    deltaM=deltaM)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        UA) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={0,-22})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
      Placement(transformation(extent={{-10,-50},{10,-30}}), iconTransformation(
          extent={{-10,-50},{10,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) "Fluid inlet"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) "Fluid outlet"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  parameter SI.MassFlowRate m_flow_nominal "Nominal mass flow rate";
equation
  connect(heatedPipe.heatPort, thermalConductor.port_b) annotation (Line(
      points={{0,-10},{0,-18},{2.22045e-016,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_a, heatPort) annotation (Line(
      points={{-4.44089e-016,-26},{0,-26},{0,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_a, heatedPipe.port_a) annotation (Line(
      points={{-100,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatedPipe.port_b, port_b) annotation (Line(
      points={{10,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-40},{100,40}}, preserveAspectRatio=false),
                    graphics),
    Icon(coordinateSystem(extent={{-100,-40},{100,40}}, preserveAspectRatio=
            true), graphics={
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
<p><b>Description</b> </p>
<p>Insulated pipe: heat exchange with the environment is based on UA-value of the insulation.</p>
<p>Model for fluid flow through a pipe, including heat losses or gains with the environment through insulation. A dynamic heat balance is included, based on the in- and outlet enthalpy flow, the heat flux to/from environment and the internal mass m of the fluid content in the pipe. A stationary model is obtained when m=0 </p>
<p>m.cv.der(T) = ( h_flow_in - h_flow_out) - UA.(T - TAmb) </p>
<p><b>Note:</b> as can be seen from the equation, the pipe temperature T will converge to the ambient temperature when there is no mass flow rate. </p>
<p><h4>Assumptions and limitations </h4></p>
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
<p><h4><font color=\"#008000\">Examples</font></h4></p>
<p>Many models use an insulated pipe.  A very basic example can be found in the <a href=\"modelica://IDEAS.Thermal.Components.Examples.OpenHydraulicSystem\">OpenHydraulicSystem</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2014 March, Filip Jorissen, Annex60 compatibility</li>
<li>2013 May 23, Roel De Coninck, documentation;</li>
<li>2012 November, Roel De Coninck, first implementation. </li>
</ul></p>
</html>"));
end Pipe_Insulated;
