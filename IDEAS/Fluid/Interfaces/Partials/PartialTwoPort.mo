within IDEAS.Fluid.Interfaces.Partials;
partial model PartialTwoPort
  "Partial model of two port without internal connections"
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(redeclare
      replaceable package Medium =
        IDEAS.Media.Water.Simple);
  extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface(redeclare replaceable
      package Medium =
        IDEAS.Media.Water.Simple);

  parameter Modelica.SIunits.Mass m(start=1) = 1 "Mass of medium";
  // I remove this parameter completely because it can lead to wrong models!!!
  // See note in evernote of RDC
  //parameter Real tapT(final min=0, final max=1)=1
  //  "Defines temperature of heatPort between inlet and outlet temperature";

 // Modelica.SIunits.Temperature T(start=TInitial) "Outlet temperature of medium";
//  Modelica.SIunits.Temperature T_a(start=TInitial) = flowPort_a.h/medium.cp
 //   "Temperature at flowPort_a";
 // Modelica.SIunits.Temperature T_b(start=TInitial) = flowPort_b.h/medium.cp
  //  "Temperature at flowPort_b";

 // Modelica.SIunits.TemperatureDifference dT(start=0) = if noEvent(flowPort_a.m_flow
  //   >= 0) then T - T_a else T_b - T
  //  "Outlet temperature minus inlet temperature";

  //Modelica.SIunits.SpecificEnthalpy h(start=Medium.specificEnthalpy(Medium.setState_pTX(Medium.p_default, TInitial, Medium.X_default)))
    //"Medium's specific enthalpy";

  IDEAS.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    energyDynamics=if dynamicBalance then energyDynamics else Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if dynamicBalance then massDynamics else Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    m_flow_nominal=m_flow_nominal,
    p_start=p_start,
    allowFlowReversal=allowFlowReversal,
    nPorts=1,
    final V=m/Medium.density(Medium.setState_phX(Medium.p_default, Medium.h_default, Medium.X_default)),
    C_nominal=C_nominal,
    mFactor=mFactor,
    m_flow_small=m_flow_small)
    annotation (Placement(transformation(extent={{-44,0},{-64,20}})));

  parameter Boolean dynamicBalance = true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));

equation
  connect(port_a, vol.ports[1]) annotation (Line(
      points={{-100,0},{-54,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p><b>General description</b> </p>
<p><h5>Goal</h5></p>
<p>Partial model with two flowPorts.</p>
<p><h5>Description </h5></p>
<p>This model is deviated from Modelica.Thermal.FluidHeatFlow.Interfaces.Partials.TwoPort</p>
<p>Possible heat exchange with the ambient is defined by Q_flow; setting this = 0 means no energy exchange.</p>
<p>Setting parameter m (mass of medium within component) to zero leads to neglection of temperature transient cv*m*der(T).</p>
<p>Mass flow can go in both directions, the temperature T is mapped to the outlet temperature. Mixing rule is applied. </p>
<p><h5>Assumptions and limitations </h5></p>
<p><ol>
<li>This model makes assumption of mass balance: outlet flowrate = inlet flowrate</li>
<li>This model includes the energy balance equation as a first order differential equation,<b> unless m=0</b></li>
</ol></p>
<p><h4>Parameters</h4></p>
<p>Partial model, see extensions for implementation details.</p>
<p><h4>Validation </h4></p>
<p>Based on physical principles, no validation performed.</p>
</html>", revisions="<html>
<ul>
<li>
March 2014 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics));
end PartialTwoPort;
