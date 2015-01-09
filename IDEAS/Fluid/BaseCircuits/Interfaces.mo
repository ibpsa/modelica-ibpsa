within IDEAS.Fluid.BaseCircuits;
package Interfaces

    extends Modelica.Icons.InterfacesPackage;

  partial model CircuitInterface "Partial circuit for base circuits"

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

    //----Settings
    parameter Boolean includePipes=false
      "Set to true to include pipes in the basecircuit"
      annotation(Dialog(group = "Settings"));
    parameter Boolean measureSupplyT=false
      "Set to true to measure the supply temperature"
      annotation(Dialog(group = "Settings"));
    parameter Boolean measureReturnT=false
      "Set to true to measure the return temperature"
      annotation(Dialog(group = "Settings"));

    //----if includePipes
    parameter SI.Mass m=1 if includePipes
      "Mass of medium in the supply and return pipes"
      annotation(Dialog(group = "Pipes",
                       enable = includePipes));
    parameter SI.ThermalConductance UA=10 if includePipes
      "Thermal conductance of the insulation of the pipes"
      annotation(Dialog(group = "Pipes",
                       enable = includePipes));
    parameter Modelica.SIunits.Pressure dp=0 if includePipes
      "Pressure drop over a single pipe"
      annotation(Dialog(group = "Pipes",
                       enable = includePipes));

    //----Fluid parameters
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
    FixedResistances.InsulatedPipe pipeSupply(
      UA=UA,
      m=m/2,
      dp_nominal=dp,
      m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium) if includePipes
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-80,60})), choicesAllMatching=true);
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if includePipes
      annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
    FixedResistances.InsulatedPipe pipeReturn(
      UA=UA,
      dp_nominal=dp,
      m=m/2,
      m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium) if includePipes
      annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-52,-60})),                                            choicesAllMatching=true);
    Sensors.TemperatureTwoPort senTem(m_flow_nominal=m_flow_nominal) if
                                         measureSupplyT
      annotation (Placement(transformation(extent={{60,10},{80,30}})));
    Modelica.Blocks.Interfaces.RealOutput supplyT if
                                               measureSupplyT
      "Measurement of the supply T" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={70,108}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={76,104})));
    Sensors.TemperatureTwoPort senTem1(
                                      m_flow_nominal=m_flow_nominal) if
                                         measureReturnT
      annotation (Placement(transformation(extent={{-70,-70},{-90,-50}})));
    Modelica.Blocks.Interfaces.RealOutput returnT if
                                               measureReturnT
      "measurement of the return temperature" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-74,-106}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-76,-102})));
  equation

    connect(port_a1, pipeSupply.port_a) annotation (Line(
        points={{-100,60},{-90,60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pipeSupply.heatPort, heatPort) annotation (Line(
        points={{-80,56},{-80,-34},{-34,-34},{-34,-100},{0,-100}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(pipeReturn.heatPort, heatPort) annotation (Line(
        points={{-52,-56},{-52,-34},{-34,-34},{-34,-100},{0,-100}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(port_b1, senTem.port_b) annotation (Line(
        points={{100,60},{86,60},{86,20},{80,20}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(supplyT, supplyT) annotation (Line(
        points={{70,108},{70,108}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(senTem.T, supplyT) annotation (Line(
        points={{70,31},{70,108}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(port_b2, senTem1.port_b) annotation (Line(
        points={{-100,-60},{-90,-60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(senTem1.port_a, pipeReturn.port_b) annotation (Line(
        points={{-70,-60},{-62,-60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(senTem1.T, returnT) annotation (Line(
        points={{-80,-49},{-80,-44},{-74,-44},{-74,-106}},
        color={0,0,127},
        smooth=Smooth.None));
      annotation (Placement(transformation(extent={{60,10},{80,30}})),
                Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                           graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
                                 Line(
            points={{-100,-60},{100,-60}},
            color={0,0,127},
            smooth=Smooth.None,
            pattern=LinePattern.Dash),
                                     Line(
            points={{-100,60},{100,60}},
            color={0,0,127},
            smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics));
  end CircuitInterface;

  partial model PartialBaseCircuit "Partial for a mixing circuit"
    import IDEAS;

    //Extensions
    extends CircuitInterface;

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Line(
            points={{76,100},{82,80},{80,60}},
            color={255,0,0},
            smooth=Smooth.None),
          Ellipse(
            extent={{78,62},{82,58}},
            lineColor={255,0,0},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-3,20},{3,0},{1,-20}},
            color={255,0,0},
            smooth=Smooth.None,
            origin={-77,-80},
            rotation=180),
          Ellipse(
            extent={{-80,-58},{-76,-62}},
            lineColor={255,0,0},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid)}));
  end PartialBaseCircuit;

  partial model PartialCircuitBalancingValve

    //Extensions
    extends ValveParametersBot(
        rhoStdBot=Medium.density_pTX(101325, 273.15+4, Medium.X_default));
    extends PartialBaseCircuit(senTem(redeclare package Medium = Medium,
          m_flow_nominal=m_flow_nominal));

    //Components
    Modelica.Blocks.Sources.Constant const(k=1)
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
    replaceable Actuators.Valves.TwoWayLinear balancingValve(
          Kv=KvBot,
          Av=AvBot,
          Cv=CvBot,
          rhoStd=rhoStdBot,
          deltaM=deltaMBot,
          CvData=IDEAS.Fluid.Types.CvTypes.Kv,
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)           constrainedby
      Actuators.BaseClasses.PartialTwoWayValve
      annotation (Placement(transformation(extent={{-8,-70},{-28,-50}})));

  equation
    if not includePipes then
      if not measureReturnT then
        connect(balancingValve.port_b, port_b2);
      else
        connect(balancingValve.port_b, senTem1.port_a);
      end if;
    end if;

    connect(balancingValve.port_b, pipeReturn.port_a) annotation (Line(
        points={{-28,-60},{-42,-60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(const.y, balancingValve.y) annotation (Line(
        points={{-39,-20},{-18,-20},{-18,-48}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(port_a2, balancingValve.port_a) annotation (Line(
        points={{100,-60},{-8,-60}},
        color={0,127,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(graphics));
  end PartialCircuitBalancingValve;

  model PartialFlowCircuit
    import IDEAS;

    //Extensions
    extends PartialCircuitBalancingValve;

    //Parameters
    parameter Boolean measurePower=true
      "Set to false to remove the power consumption measurement of the flow regulator";

    replaceable IDEAS.Fluid.Interfaces.PartialTwoPortInterface flowRegulator(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
      annotation (Placement(transformation(extent={{-10,10},{10,30}})));
    Modelica.Blocks.Interfaces.RealInput u "Setpoint of the flow regulator"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,108})));
    Modelica.Blocks.Interfaces.RealOutput power if measurePower
      "Power consumption of the flow regulator"
                                               annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={40,108}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={42,104})));

  equation
    if not includePipes then
      connect(flowRegulator.port_a, port_a1);
    end if;

    if not measureSupplyT then
      connect(flowRegulator.port_b, port_b1);
    end if;

    connect(flowRegulator.port_b, senTem.port_a) annotation (Line(
        points={{10,20},{60,20}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pipeSupply.port_b, flowRegulator.port_a) annotation (Line(
        points={{-70,60},{-40,60},{-40,20},{-10,20}},
        color={0,127,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                 graphics={
          Line(
            points={{42,100},{48,80},{46,60}},
            color={255,0,0},
            smooth=Smooth.None),
          Ellipse(
            extent={{44,62},{48,58}},
            lineColor={255,0,0},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid)}));
  end PartialFlowCircuit;

  model PartialPumpCircuit

    //Extensions
    extends PartialFlowCircuit(redeclare Movers.BaseClasses.PartialFlowMachine
        flowRegulator(
          addPowerToMedium=addPowerToMedium,
          motorCooledByFluid=motorCooledByFluid,
          motorEfficiency=motorEfficiency,
          hydraulicEfficiency=hydraulicEfficiency));

    extends PumpParameters;

    annotation (Icon(graphics={
          Ellipse(extent={{-20,80},{20,40}},lineColor={0,0,127},
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{0,94},{4,80},{0,64}},
            color={0,255,128},
            smooth=Smooth.None),
          Polygon(
            points={{-12,76},{-12,44},{20,60},{-12,76}},
            lineColor={0,0,127},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end PartialPumpCircuit;

  model PartialValveCircuit

    //Extensions
    extends ValveParametersTop(
        rhoStdTot=Medium.density_pTX(101325, 273.15+4, Medium.X_default));
    extends PartialFlowCircuit(redeclare
        Actuators.BaseClasses.PartialTwoWayValve
        flowRegulator(
          Kv=KvTop,
          Av=AvTop,
          Cv=CvTop,
          rhoStd=rhoStdTop,
          deltaM=deltaMTop,
          CvData=IDEAS.Fluid.Types.CvTypes.Kv));

  equation
    connect(flowRegulator.y_actual, power) annotation (Line(
        points={{5,27},{40,27},{40,108}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(graphics={
          Polygon(
            points={{-20,70},{-20,50},{0,60},{-20,70}},
            lineColor={0,0,127},
            smooth=Smooth.None,
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{20,70},{20,50},{0,60},{20,70}},
            lineColor={0,0,127},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{0,40},{0,60}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{0,102},{6,80},{0,60}},
            color={0,255,128},
            smooth=Smooth.None),
          Rectangle(
            extent={{-4,44},{4,36}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end PartialValveCircuit;

  model PartialMixingCircuit "Partial for a mixing circuit"
    import IDEAS;

    //Extensions
    extends IDEAS.Fluid.BaseCircuits.Interfaces.PartialCircuitBalancingValve;

    //Parameters
    parameter Boolean includeMixingPipe=false
      "Set to true to include mixing pipe"
      annotation(Dialog(group = "Settings"));

    parameter SI.Mass mMix=1 "Mass of fluid inside the mixing valve"
    annotation(Dialog(group = "Mixing"));
    parameter SI.Mass mPipe=1 "Mass of fluid inside the middle pipe"
    annotation(Dialog(group = "Mixing",
                       enable = includeMixingPipe));
    parameter Modelica.SIunits.Pressure dpMixPipe=0
      "Pressure drop over the middle single pipe"
      annotation(Dialog(group = "Mixing",
                       enable = includeMixingPipe));
    parameter SI.ThermalConductance UAMix=10 if includePipes
      "Thermal conductance of the insulation of the middle pipe"
      annotation(Dialog(group = "Mixing",
                       enable = includeMixingPipe));
    IDEAS.Fluid.FixedResistances.InsulatedPipe pipeMix(
      UA=UAMix,
      m=mPipe,
      dp_nominal=dpMixPipe,
      m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium) if includeMixingPipe annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={0,0})), choicesAllMatching=true);
    IDEAS.Fluid.Valves.Thermostatic3WayValve thermostatic3WayValve(
      m_flow_nominal=m_flow_nominal,
      m=mMix,
      redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-10,50},{10,70}})));
    Modelica.Blocks.Interfaces.RealInput TMixedSet
      "Setpoint for the supply temperature"                                              annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,104}),   iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,100})));
  equation
    connect(thermostatic3WayValve.port_a2, pipeMix.port_a) annotation (Line(
        points={{0,50},{0,10}},
        color={0,127,255},
        smooth=Smooth.None));

    if not includeMixingPipe then
      connect(thermostatic3WayValve.port_a2, balancingValve.port_a);
    end if;

    if not measureSupplyT then
      connect(thermostatic3WayValve.port_b, port_b1);
    end if;
    connect(TMixedSet, thermostatic3WayValve.TMixedSet) annotation (Line(
        points={{0,104},{0,70}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(thermostatic3WayValve.port_a1, pipeSupply.port_b) annotation (Line(
        points={{-10,60},{-70,60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pipeMix.port_b, balancingValve.port_a) annotation (Line(
        points={{0,-10},{0,-60},{-8,-60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(thermostatic3WayValve.port_b, senTem.port_a) annotation (Line(
        points={{10,60},{40,60},{40,20},{60,20}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pipeMix.heatPort, heatPort) annotation (Line(
        points={{-4,0},{-80,0},{-80,-50},{-64,-50},{-64,-100},{0,-100}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Polygon(
            points={{-20,70},{-20,50},{0,60},{-20,70}},
            lineColor={0,0,127},
            smooth=Smooth.None,
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{20,70},{20,50},{0,60},{20,70}},
            lineColor={0,0,127},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{0,40},{0,60}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{0,100},{-6,80},{0,60}},
            color={0,255,128},
            smooth=Smooth.None),
          Polygon(
            points={{-10,10},{-10,-10},{10,0},{-10,10}},
            lineColor={0,0,127},
            smooth=Smooth.None,
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid,
            origin={0,50},
            rotation=90),
          Line(
            points={{0,40},{0,-60}},
            color={0,0,255},
            smooth=Smooth.None)}));
  end PartialMixingCircuit;

  partial model PumpParameters
    "Partial circuit for base circuits with pump parameters"

    parameter Boolean addPowerToMedium = false "Add heat to the medium"
                               annotation(Dialog(
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

  end PumpParameters;

  model ValveParametersBot

    parameter IDEAS.Fluid.Types.CvTypes CvDataBot=IDEAS.Fluid.Types.CvTypes.Kv
      "Selection of flow coefficient"
     annotation(Dialog(group = "Flow Coefficient Bot Valve"));
    parameter Real KvBot(
      fixed= if CvDataBot==IDEAS.Fluid.Types.CvTypes.Kv then true else false)
      "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]"
    annotation(Dialog(group = "Flow Coefficient Bot Valve",
                      enable = (CvDataBot==IDEAS.Fluid.Types.CvTypes.Kv)));
    parameter Real CvBot(
      fixed= if CvDataBot==IDEAS.Fluid.Types.CvTypes.Cv then true else false)
      "Cv (US) flow coefficient [USG/min/(psi)^(1/2)]"
    annotation(Dialog(group = "Flow Coefficient Bot Valve",
                      enable = (CvDataBot==IDEAS.Fluid.Types.CvTypes.Cv)));
    parameter Modelica.SIunits.Area AvBot(
      fixed= if CvDataBot==IDEAS.Fluid.Types.CvTypes.Av then true else false)
      "Av (metric) flow coefficient"
     annotation(Dialog(group = "Flow Coefficient Bot Valve",
                       enable = (CvDataBot==IDEAS.Fluid.Types.CvTypes.Av)));

    parameter Real deltaMBot = 0.02
      "Fraction of nominal flow rate where linearization starts, if y=1"
      annotation(Dialog(group="Pressure-flow linearization"));

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
      "Nominal mass flow rate";

    parameter Modelica.SIunits.Pressure dpValve_nominalBot(displayUnit="Pa",
                                                        min=0,
                                                        fixed= if CvDataBot==IDEAS.Fluid.Types.CvTypes.OpPoint then true else false)
      "Nominal pressure drop of fully open valve, used if CvData=IDEAS.Fluid.Types.CvTypes.OpPoint"
      annotation(Dialog(group="Nominal condition",
                 enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

    parameter Modelica.SIunits.Density rhoStdBot
      "Inlet density for which valve coefficients are defined"
    annotation(Dialog(group="Nominal condition", tab="Advanced"));

  protected
    parameter Real Kv_SIBot(
      min=0,
      fixed= false)
      "Flow coefficient for fully open valve in SI units, Kv=m_flow/sqrt(dp) [kg/s/(Pa)^(1/2)]"
    annotation(Dialog(group = "Flow Coefficient Bot Valve",
                      enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

  initial equation

    if  CvDataBot == IDEAS.Fluid.Types.CvTypes.OpPoint then
      Kv_SIBot =           m_flow_nominal/sqrt(dpValve_nominalBot);
      KvBot    =           Kv_SIBot/(rhoStdBot/3600/sqrt(1E5));
      CvBot    =           Kv_SIBot/(rhoStdBot*0.0631/1000/sqrt(6895));
      AvBot    =           Kv_SIBot/sqrt(rhoStdBot);
    elseif CvDataBot == IDEAS.Fluid.Types.CvTypes.Kv then
      Kv_SIBot =           KvBot*rhoStdBot/3600/sqrt(1E5)
        "Unit conversion m3/(h*sqrt(bar)) to kg/(s*sqrt(Pa))";
      CvBot    =           Kv_SIBot/(rhoStdBot*0.0631/1000/sqrt(6895));
      AvBot    =           Kv_SIBot/sqrt(rhoStdBot);
      dpValve_nominalBot =  (m_flow_nominal/Kv_SIBot)^2;
    elseif CvDataBot == IDEAS.Fluid.Types.CvTypes.Cv then
      Kv_SIBot =           CvBot*rhoStdBot*0.0631/1000/sqrt(6895)
        "Unit conversion USG/(min*sqrt(psi)) to kg/(s*sqrt(Pa))";
      KvBot    =           Kv_SIBot/(rhoStdBot/3600/sqrt(1E5));
      AvBot    =           Kv_SIBot/sqrt(rhoStdBot);
      dpValve_nominalBot =  (m_flow_nominal/Kv_SIBot)^2;
    else
      assert(CvDataBot == IDEAS.Fluid.Types.CvTypes.Av, "Invalid value for CvData.
Obtained CvData = "   + String(CvDataBot) + ".");
      Kv_SIBot =           AvBot*sqrt(rhoStdBot);
      KvBot    =           Kv_SIBot/(rhoStdBot/3600/sqrt(1E5));
      CvBot    =           Kv_SIBot/(rhoStdBot*0.0631/1000/sqrt(6895));
      dpValve_nominalBot =  (m_flow_nominal/Kv_SIBot)^2;
    end if;

  end ValveParametersBot;

  model ValveParametersTop

    parameter IDEAS.Fluid.Types.CvTypes CvDataTop=IDEAS.Fluid.Types.CvTypes.OpPoint
      "Selection of flow coefficient"
     annotation(Dialog(group = "Flow Coefficient Top Valve"));
    parameter Real KvTop(
      fixed= if CvDataTop==IDEAS.Fluid.Types.CvTypes.Kv then true else false)
      "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]"
    annotation(Dialog(group = "Flow Coefficient Top Valve",
                      enable = (CvDataTop==IDEAS.Fluid.Types.CvTypes.Kv)));
    parameter Real CvTop(
      fixed= if CvDataTop==IDEAS.Fluid.Types.CvTypes.Cv then true else false)
      "Cv (US) flow coefficient [USG/min/(psi)^(1/2)]"
    annotation(Dialog(group = "Flow Coefficient Top Valve",
                      enable = (CvDataTop==IDEAS.Fluid.Types.CvTypes.Cv)));
    parameter Modelica.SIunits.Area AvTop(
      fixed= if CvDataTop==IDEAS.Fluid.Types.CvTypes.Av then true else false)
      "Av (metric) flow coefficient"
     annotation(Dialog(group = "Flow Coefficient Top Valve",
                       enable = (CvDataTop==IDEAS.Fluid.Types.CvTypes.Av)));

    parameter Real deltaMTop = 0.02
      "Fraction of nominal flow rate where linearization starts, if y=1"
      annotation(Dialog(group="Pressure-flow linearization"));
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
      "Nominal mass flow rate"
      annotation(Dialog(group = "Nominal condition"));
    parameter Modelica.SIunits.Pressure dpValve_nominalTop(displayUnit="Pa",
                                                        min=0,
                                                        fixed= if CvDataTop==IDEAS.Fluid.Types.CvTypes.OpPoint then true else false)
      "Nominal pressure drop of fully open valve, used if CvData=IDEAS.Fluid.Types.CvTypes.OpPoint"
      annotation(Dialog(group="Nominal condition",
                 enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

    parameter Modelica.SIunits.Density rhoStdTop
      "Inlet density for which valve coefficients are defined"
    annotation(Dialog(group="Nominal condition", tab="Advanced"));

  protected
    parameter Real Kv_SITop(
      min=0,
      fixed= false)
      "Flow coefficient for fully open valve in SI units, Kv=m_flow/sqrt(dp) [kg/s/(Pa)^(1/2)]"
    annotation(Dialog(group = "Flow Coefficient Top Valve",
                      enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

  initial equation
    if  CvDataTop == IDEAS.Fluid.Types.CvTypes.OpPoint then
      Kv_SITop =           m_flow_nominal/sqrt(dpValve_nominalTop);
      KvTop    =           Kv_SITop/(rhoStdTop/3600/sqrt(1E5));
      CvTop    =           Kv_SITop/(rhoStdTop*0.0631/1000/sqrt(6895));
      AvTop    =           Kv_SITop/sqrt(rhoStdTop);
    elseif CvDataTop == IDEAS.Fluid.Types.CvTypes.Kv then
      Kv_SITop =           KvTop*rhoStdTop/3600/sqrt(1E5)
        "Unit conversion m3/(h*sqrt(bar)) to kg/(s*sqrt(Pa))";
      CvTop    =           Kv_SITop/(rhoStdTop*0.0631/1000/sqrt(6895));
      AvTop    =           Kv_SITop/sqrt(rhoStdTop);
      dpValve_nominalTop =  (m_flow_nominal/Kv_SITop)^2;
    elseif CvDataTop == IDEAS.Fluid.Types.CvTypes.Cv then
      Kv_SITop =           CvTop*rhoStdTop*0.0631/1000/sqrt(6895)
        "Unit conversion USG/(min*sqrt(psi)) to kg/(s*sqrt(Pa))";
      KvTop    =           Kv_SITop/(rhoStdTop/3600/sqrt(1E5));
      AvTop    =           Kv_SITop/sqrt(rhoStdTop);
      dpValve_nominalTop =  (m_flow_nominal/Kv_SITop)^2;
    else
      assert(CvDataTop == IDEAS.Fluid.Types.CvTypes.Av, "Invalid value for CvData.
Obtained CvData = "   + String(CvDataTop) + ".");
      Kv_SITop =           AvTop*sqrt(rhoStdTop);
      KvTop    =           Kv_SITop/(rhoStdTop/3600/sqrt(1E5));
      CvTop    =           Kv_SITop/(rhoStdTop*0.0631/1000/sqrt(6895));
      dpValve_nominalTop =  (m_flow_nominal/Kv_SITop)^2;
    end if;
  end ValveParametersTop;
end Interfaces;
