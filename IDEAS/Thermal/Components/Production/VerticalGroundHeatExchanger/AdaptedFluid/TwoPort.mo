within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.AdaptedFluid;
model TwoPort
  "FlowPort_a.m_flow is positive. It means, port_a is inwards en port_b is outwards. Made for a pipe"
// **************
// INPUT
// **************
  // Medius of the twoport.
  parameter Medium medium;
  // Diameter of the pipe.
  parameter Modelica.SIunits.Radius diam = 0.08;
  // Length of the pipe.
  parameter Modelica.SIunits.Length len = 12.5;
  // Total mass in the pipe.
  parameter Modelica.SIunits.Mass m = medium.rho * diam^2*3.14 * len
    "Mass of medium";
  parameter Modelica.SIunits.Temperature T0(start=293.15, displayUnit="degC")
    "Initial temperature of medium";
        parameter Real tapT(final min=0, final max=1)=1
    "Defines temperature of heatPort between inlet and outlet temperature";
        Modelica.SIunits.Pressure dp=flowPort_a.p - flowPort_b.p
    "Pressure drop a->b";
        Modelica.SIunits.VolumeFlowRate V_flow=flowPort_a.m_flow/medium.rho
    "Volume flow a->b";
        Modelica.SIunits.HeatFlowRate Q_flow "Heat exchange with ambient";
        output Modelica.SIunits.Temperature T(start=T0)
    "Outlet temperature of medium";
        output Modelica.SIunits.Temperature T_a=flowPort_a.h/medium.cp
    "Temperature at flowPort_a";
        output Modelica.SIunits.Temperature T_b=flowPort_b.h/medium.cp
    "Temperature at flowPort_b";
        output Modelica.SIunits.TemperatureDifference dT=if noEvent(V_flow>=0) then T-T_a else T_b-T
    "Temperature increase of coolant in flow direction";
protected
        Modelica.SIunits.SpecificEnthalpy h = medium.cp*T
    "Medium's specific enthalpy";
        Modelica.SIunits.Temperature T_q = T  - noEvent(sign(V_flow))*(1 - tapT)*dT
    "Temperature relevant for heat exchange with ambient";
public
        Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort_a flowPort_a(final
      medium= medium)
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                rotation=0)));
        Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort_b flowPort_b(final
      medium= medium)
          annotation (Placement(transformation(extent={{90,-10},{110,10}},
                rotation=0)));
equation
        // mass balance
        flowPort_a.m_flow + flowPort_b.m_flow = 0;
        // energy balance
        flowPort_a.H_flow + flowPort_b.H_flow + Q_flow = m*medium.cv*der(T);
        // massflow a->b mixing rule at a, energy flow at b defined by medium's temperature
        // massflow b->a mixing rule at b, energy flow at a defined by medium's temperature
        flowPort_a.H_flow = semiLinear(flowPort_a.m_flow,flowPort_a.h,h);
        flowPort_b.H_flow = semiLinear(flowPort_b.m_flow,flowPort_b.h,h);
    annotation(__Dymola_choicesAllMatching=true);
end TwoPort;
