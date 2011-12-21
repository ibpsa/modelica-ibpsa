within IDEAS.Thermal.Components.Interfaces.Partials;
partial model TwoPort "Partial model of two port"

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

  Modelica.SIunits.HeatFlowRate Q_flow(start=0) "Heat exchange with ambient";
  Modelica.SIunits.Temperature T(start=TInitial) "Outlet temperature of medium";
  Modelica.SIunits.Temperature T_a(start=TInitial)=flowPort_a.h/
    medium.cp "Temperature at flowPort_a";
  Modelica.SIunits.Temperature T_b(start=TInitial)=flowPort_b.h/
    medium.cp "Temperature at flowPort_b";

  Modelica.SIunits.TemperatureDifference dT(start=0)=if noEvent(
    flowPort_a.m_flow >= 0) then T - T_a else T_b - T
    "Outlet temperature minus inlet temperature";

  Modelica.SIunits.SpecificEnthalpy h=medium.cp*T "Medium's specific enthalpy";

public
  FlowPort_a flowPort_a(final medium=medium, h(min=1140947, max=1558647))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
          rotation=0)));
  FlowPort_b flowPort_b(final medium=medium, h(min=1140947, max=1558647))
    annotation (Placement(transformation(extent={{90,-10},{110,10}},
          rotation=0)));
equation
  // mass balance
  flowPort_a.m_flow + flowPort_b.m_flow = 0;

  // no equation about pressure drop here in order to allow pumps to extend from this partial

  // energy balance
  if m>Modelica.Constants.small then
    flowPort_a.H_flow + flowPort_b.H_flow + Q_flow = m*medium.cv*der(T);
  else
    flowPort_a.H_flow + flowPort_b.H_flow + Q_flow = 0;
  end if;
  // massflow a->b mixing rule at a, energy flow at b defined by medium's temperature
  // massflow b->a mixing rule at b, energy flow at a defined by medium's temperature
  flowPort_a.H_flow = semiLinear(flowPort_a.m_flow,flowPort_a.h,h);
  flowPort_b.H_flow = semiLinear(flowPort_b.m_flow,flowPort_b.h,h);
annotation (Documentation(info="<HTML>
Partial model with two flowPorts.<br>
Possible heat exchange with the ambient is defined by Q_flow; setting this = 0 means no energy exchange.<br>
Setting parameter m (mass of medium within pipe) to zero
leads to neglection of temperature transient cv*m*der(T).<br>
Mixing rule is applied.<br>
Parameter 0 &lt; tapT &lt; 1 defines temperature of heatPort between medium's inlet and outlet temperature.
</HTML>"));
end TwoPort;
