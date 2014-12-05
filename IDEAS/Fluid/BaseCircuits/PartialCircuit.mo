within IDEAS.Fluid.BaseCircuits;
model PartialCircuit

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (__Dymola_choicesAllMatching=true);

  //Extensions
  extends IDEAS.Fluid.Interfaces.FourPort;
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;

  //Parameters
  parameter SI.Mass m=1 "Mass of medium";
  parameter Boolean dynamicBalance=true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation(Dialog(tab="Dynamics", group="Equations"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Line(
          points={{-100,60},{100,60}},
          color={0,0,255},
          smooth=Smooth.None), Line(
          points={{-100,-60},{100,-60}},
          color={0,0,255},
          smooth=Smooth.None)}));
end PartialCircuit;
