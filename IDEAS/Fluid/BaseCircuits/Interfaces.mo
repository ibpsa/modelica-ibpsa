within IDEAS.Fluid.BaseCircuits;
package Interfaces

    extends Modelica.Icons.InterfacesPackage;

  partial model Circuit "Partial circuit for base circuits"

    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      "Medium in the component"
      annotation (__Dymola_choicesAllMatching=true);

    //Extensions
    extends IDEAS.Fluid.Interfaces.FourPort(
      redeclare package Medium1 = Medium,
      redeclare package Medium2 = Medium,
      final allowFlowReversal1 = allowFlowReversal,
      final allowFlowReversal2 = allowFlowReversal);
    extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;

    //Parameters
    parameter Boolean heatLosses=false "Set to true to include heat losses";
    parameter Integer nPipes
      "Number of pipes in the circuit for the mass distribution";
    parameter SI.Mass m=1 "Total mass of medium in all pipes";
    parameter SI.ThermalConductance UA=10
      "Thermal conductance of the insulation of the pipes";
    parameter Modelica.SIunits.Pressure dp=0 "Pressure drop over a single pipe";
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

    //Components
    FixedResistances.InsulatedPipe pipeReturn(
      UA=UA,
      dp_nominal=dp,
      m=m/nPipes,
      m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{80,-70},{60,-50}})), choicesAllMatching=true);
    FixedResistances.InsulatedPipe pipeSupply(
      UA=UA,
      m=m/nPipes,
      dp_nominal=dp,
      m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium)
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-70,60})), choicesAllMatching=true);
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if heatLosses
      annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  equation
    connect(pipeReturn.port_a, port_a2) annotation (Line(
        points={{80,-60},{100,-60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(port_a1, pipeSupply.port_a) annotation (Line(
        points={{-100,60},{-80,60}},
        color={0,127,255},
        smooth=Smooth.None));

    if heatLosses then
      connect(pipeSupply.heatPort, heatPort) annotation (Line(
        points={{-70,56},{-70,-100},{0,-100}},
        color={191,0,0},
        smooth=Smooth.None));
      connect(pipeReturn.heatPort, heatPort) annotation (Line(
        points={{70,-56},{70,-46},{86,-46},{86,-100},{0,-100}},
        color={191,0,0},
        smooth=Smooth.None));
    end if;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}), graphics={Line(
            points={{-100,60},{100,60}},
            color={0,0,127},
            smooth=Smooth.None), Line(
            points={{-100,-60},{100,-60}},
            color={0,0,127},
            smooth=Smooth.None,
            pattern=LinePattern.Dash)}),
                                   Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics));
  end Circuit;

  partial model CircuitWithPump
    "Partial circuit for base circuits with pump parameters"

    extends Circuit;

    parameter Boolean addPowerToMedium = false "Add heat to the medium" annotation(Dialog(
                     group = "Pump parameters"));

    parameter Boolean use_powerCharacteristic = false
      "Use powerCharacteristic (vs. efficiencyCharacteristic)" annotation(Dialog(
                     group = "Pump parameters"));

    parameter Boolean motorCooledByFluid = true
      "If true, then motor heat is added to fluid stream" annotation(Dialog(
                     group = "Pump parameters"));

    parameter
      IDEAS.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
        motorEfficiency(r_V={1}, eta={0.7})
      "Normalized volume flow rate vs. efficiency" annotation(Dialog(
                     group = "Pump parameters"));
    parameter
      IDEAS.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
        hydraulicEfficiency(r_V={1}, eta={0.7})
      "Normalized volume flow rate vs. efficiency" annotation(Dialog(
                     group = "Pump parameters"));

  end CircuitWithPump;
end Interfaces;
