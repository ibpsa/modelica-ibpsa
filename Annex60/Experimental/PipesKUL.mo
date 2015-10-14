within Annex60.Experimental;
package PipesKUL
  "Pipes for the modelling of district heating, according to the KU Leuven model"
  // Originally at https://github.com/arnoutaertgeerts/DistrictHeating
  // First implementation by Arnout Aertgeerts

  model PlugFlowLosslessPipe
    "Pipe with a temperature plug flow without pressure losses"
     //Extensions
    extends Annex60.Fluid.Interfaces.PartialTwoPortInterface;

    //Parameters
    parameter Modelica.SIunits.Length L "Pipe length";
    parameter Modelica.SIunits.Length D "Pipe diameter";
    final parameter Modelica.SIunits.CrossSection A = Modelica.Constants.pi*(D/2)^2;

    //Variables
    Real u "Normalized speed";
    Real x "Normalized transport quantity";

  equation
    dp=0;

    // Mass balance (no storage)
    port_a.m_flow + port_b.m_flow = 0;

    // Transport of substances
    port_a.Xi_outflow = inStream(port_b.Xi_outflow);
    port_b.Xi_outflow = inStream(port_a.Xi_outflow);

    port_a.C_outflow = inStream(port_b.C_outflow);
    port_b.C_outflow = inStream(port_a.C_outflow);

    //Normalized speed of the fluid [1/s]
    u = port_a.m_flow/(1000*A*L);
    der(x) = u;

    //Spatial distribution of the enthalpy
    (port_a.h_outflow, port_b.h_outflow) =
      spatialDistribution(
        inStream(port_a.h_outflow),
        inStream(port_b.h_outflow),
        x,
        true,
        {0.0, 1},
        {inStream(port_a.h_outflow),
        inStream(port_b.h_outflow)});

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,60},{100,-60}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={192,192,192}),
          Rectangle(
            extent={{-100,50},{100,-48}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={217,236,256}),
          Rectangle(
            extent={{-20,50},{20,-48}},
            lineColor={175,175,175},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={175,175,175})}));
  end PlugFlowLosslessPipe;

  model PlugFlowPipe
    "Adiabatic pipe model with a temperature plug flow and pressure losses"
    //Extensions
    extends Annex60.Fluid.Interfaces.PartialTwoPortInterface;
    extends Annex60.Fluid.Interfaces.TwoPortFlowResistanceParameters;

    //Parameters
    parameter Modelica.SIunits.Length pipeLength;
    parameter Modelica.SIunits.Length pipeDiameter;

    //Components
    Annex60.Experimental.PipesKUL.PlugFlowLosslessPipe plug(
      L=pipeLength,
      D=pipeDiameter,
      m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    Annex60.Fluid.FixedResistances.FixedResistanceDpM
                                                    res(
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal,
      redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal,
      from_dp=from_dp,
      linearized=linearizeFlowResistance)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  equation
    connect(port_a, res.port_a) annotation (Line(
        points={{-100,0},{-60,0}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(res.port_b, plug.port_a) annotation (Line(
        points={{-40,0},{40,0}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(plug.port_b, port_b) annotation (Line(
        points={{60,0},{100,0}},
        color={0,127,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(graphics={
          Polygon(
            points={{20,-70},{60,-85},{20,-100},{20,-70}},
            lineColor={0,128,255},
            smooth=Smooth.None,
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid,
            visible=showDesignFlowDirection),
          Polygon(
            points={{20,-75},{50,-85},{20,-95},{20,-75}},
            lineColor={255,255,255},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            visible=allowFlowReversal),
          Line(
            points={{55,-85},{-60,-85}},
            color={0,128,255},
            smooth=Smooth.None,
            visible=showDesignFlowDirection),
          Rectangle(
            extent={{-100,42},{100,-40}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={192,192,192}),
          Rectangle(
            extent={{-100,32},{100,-26}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255}),
          Rectangle(
            extent={{-26,32},{30,-26}},
            lineColor={0,0,255},
            fillPattern=FillPattern.HorizontalCylinder)}));
  end PlugFlowPipe;

  model PlugFlowHeatLosses
    "Pipe model with a temperature plug flow, pressure losses and heat exchange to the environment"

    //Extensions
    extends Annex60.Fluid.Interfaces.PartialTwoPortInterface;
    extends Annex60.Fluid.Interfaces.LumpedVolumeDeclarations(
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState);
    extends Annex60.Fluid.Interfaces.TwoPortFlowResistanceParameters;

    //Parameters
    parameter Modelica.SIunits.Length L;
    parameter Modelica.SIunits.Length D;
    parameter Modelica.SIunits.Length h=0.02 "Insulation thickness";

    final constant Real pi = Modelica.Constants.pi;
    final parameter Modelica.SIunits.Area A=pi*(D/2)^2;
    final parameter Modelica.SIunits.Volume V=L*A;

    parameter Modelica.SIunits.Density rho = 1000 "Mass density of fluid";
    parameter Modelica.SIunits.SpecificHeatCapacity cp=4187
      "Specific heat of fluid";

    parameter Boolean dynamicBalance = true
      "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
      annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
    parameter Modelica.SIunits.ThermalConductivity lambdaI=0.026
      "Heat conductivity";

    parameter Modelica.SIunits.ThermalConductivity R=1/(lambdaI*2*pi/Modelica.Math.log((D/2+h)/(D/2)));
    final parameter Real C=rho*pi*(D/2)^2*cp;

    //Variables
    Real u;
    Modelica.SIunits.Power Q_Losses;

    //Components
    Annex60.Experimental.PipesKUL.PlugFlowPipe plugFlowPipe(
      pipeLength=L,
      pipeDiameter=D,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal,
      redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal,
      from_dp=from_dp,
      linearizeFlowResistance=linearizeFlowResistance,
      deltaM=deltaM)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

    Modelica.Blocks.Interfaces.RealInput TBoundary annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,110}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={2,50})));
    Annex60.Experimental.TimeDelays.PDETime pDETime
      annotation (Placement(transformation(extent={{-28,24},{-8,44}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=u)
      annotation (Placement(transformation(extent={{-58,24},{-38,44}})));
    BaseClasses.ExponentialDecay tempDecay(C=C, R=R)
      annotation (Placement(transformation(extent={{12,20},{32,40}})));
    Annex60.Fluid.Sensors.TemperatureTwoPort senTem(m_flow_nominal=m_flow_nominal,
        redeclare package Medium = Medium,
      tau=0)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Annex60.Fluid.MixingVolumes.MixingVolume idealHeater(
      m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium,
      nPorts=2,
      final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      V=V,
      massDynamics=massDynamics,
      allowFlowReversal=allowFlowReversal)
      annotation (Placement(transformation(extent={{62,0},{82,20}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1
      annotation (Placement(transformation(extent={{46,4},{58,16}})));
  equation
    //Normalized speed of the fluid [1/s]
    u = port_a.m_flow/(rho*V);
    Q_Losses = -idealHeater.heatPort.Q_flow/L;

    connect(port_a, plugFlowPipe.port_a) annotation (Line(
        points={{-100,0},{-60,0}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pDETime.u, realExpression.y) annotation (Line(
        points={{-30,34},{-37,34}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(plugFlowPipe.port_b, senTem.port_a) annotation (Line(
        points={{-40,0},{-10,0}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(senTem.T, tempDecay.TIn) annotation (Line(
        points={{0,11},{0,26},{10,26}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(pDETime.tau, tempDecay.td) annotation (Line(
        points={{-7,34},{10,34}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TBoundary, tempDecay.Tb) annotation (Line(
        points={{0,110},{0,60},{22,60},{22,42}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(idealHeater.heatPort, prescribedTemperature1.port)
      annotation (Line(points={{62,10},{58,10}}, color={191,0,0}));
    connect(senTem.port_b, idealHeater.ports[1])
      annotation (Line(points={{10,0},{70,0}}, color={0,127,255}));
    connect(idealHeater.ports[2], port_b)
      annotation (Line(points={{74,0},{74,0},{100,0}}, color={0,127,255}));
    connect(tempDecay.TOut, prescribedTemperature1.T) annotation (Line(points={{33,
            30},{40,30},{40,10},{44.8,10}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}),
                     graphics={
          Polygon(
            points={{20,-70},{60,-85},{20,-100},{20,-70}},
            lineColor={0,128,255},
            smooth=Smooth.None,
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid,
            visible=showDesignFlowDirection),
          Polygon(
            points={{20,-75},{50,-85},{20,-95},{20,-75}},
            lineColor={255,255,255},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            visible=allowFlowReversal),
          Polygon(
            points={{20,-75},{50,-85},{20,-95},{20,-75}},
            lineColor={255,255,255},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            visible=allowFlowReversal),
          Rectangle(
            extent={{-100,40},{100,-40}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={192,192,192}),
          Rectangle(
            extent={{-100,30},{100,-30}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255}),
          Rectangle(
            extent={{-26,30},{30,-30}},
            lineColor={0,0,255},
            fillPattern=FillPattern.HorizontalCylinder),
          Line(
            points={{55,-85},{-60,-85}},
            color={0,128,255},
            smooth=Smooth.None,
            visible=showDesignFlowDirection),
          Rectangle(
            extent={{-100,50},{100,40}},
            lineColor={175,175,175},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward),
          Rectangle(
            extent={{-100,-40},{100,-50}},
            lineColor={175,175,175},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward)}),
                             Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}})));
  end PlugFlowHeatLosses;

  model PlugFlowHeatLossTwinPipe "Pipe model for double pipes (supply and return in counterflow) with a 
  temperature plug flow, pressure losses and heat exchange to the environment (i.e. ambient temperature)"
    /* This model implements heat losses for double district heating pipes, based
  on Wallentén's steady-state heat loss equations. The solution is exact for steady-state
  flow. In case of temperature discontinuities, limited instantaneous errors in the heat
  losses occur, but they cancel out in case of periodic behaviour. 
  
  The boundary temperature that needs to be supplied to the model is the 
  temperature at the outer surface of the pipe system. */

    //Extensions
    extends Annex60.Fluid.Interfaces.LumpedVolumeDeclarations(
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState);

    extends Annex60.Fluid.Interfaces.TwoPortFlowResistanceParameters;

    extends Annex60.Fluid.Interfaces.PartialFourPortInterface(
      redeclare final package Medium1=Medium,
      redeclare final package Medium2=Medium,
      final m1_flow_nominal=m_flow_nominal,
      final m2_flow_nominal=m_flow_nominal,
      final allowFlowReversal1=allowFlowReversal,
      final allowFlowReversal2=allowFlowReversal);

    //Parameters
    parameter Modelica.SIunits.Length L;
    parameter Modelica.SIunits.Length D;
    parameter Real ha;
    parameter Real hs;

    final constant Real pi = Modelica.Constants.pi;
    final parameter Modelica.SIunits.Volume V=L*pi*(D/2)^2;

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal;
    parameter Boolean allowFlowReversal annotation(Dialog(tab="Assumptions"), Evaluate=true);

    parameter Modelica.SIunits.Density rho = 1000 "Mass density of fluid";
    parameter Modelica.SIunits.SpecificHeatCapacity cp=4187
      "Specific heat of fluid";

    parameter Boolean dynamicBalance = true
      "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
      annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
    parameter Modelica.SIunits.ThermalConductivity k=0.026 "Heat conductivity";

    final parameter Modelica.SIunits.ThermalConductivity Ra=1/(k*2*pi*ha);
    final parameter Modelica.SIunits.ThermalConductivity Rs=1/(k*2*pi*hs);

    final parameter Real C=rho*pi*(D/2)^2*cp;

    //Variables
    Real u;
    Modelica.SIunits.Power Q_Losses;
    Modelica.SIunits.Power Q_1;
    Modelica.SIunits.Power Q_2;

    //Components
    Annex60.Experimental.PipesKUL.PlugFlowPipe pipe1(
      pipeLength=L,
      pipeDiameter=D,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal,
      redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal,
      from_dp=from_dp,
      linearizeFlowResistance=linearizeFlowResistance,
      deltaM=deltaM)
      annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

    Modelica.Blocks.Interfaces.RealInput TBoundary annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,110}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={0,100})));
    Annex60.Experimental.TimeDelays.PDETime pDETime
      annotation (Placement(transformation(extent={{-50,8},{-30,28}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=u)
      annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
    Annex60.Fluid.Sensors.TemperatureTwoPort senTem1(
      m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium,
      tau=0,
      allowFlowReversal=allowFlowReversal)
             annotation (Placement(transformation(extent={{-24,70},{-4,50}})));
    Annex60.Fluid.MixingVolumes.MixingVolume    idealHeater1(
      m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium,
      nPorts=2,
      final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      V=V,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      allowFlowReversal=allowFlowReversal)
      annotation (Placement(transformation(extent={{60,60},{80,40}})));
    Annex60.Experimental.PipesKUL.PlugFlowPipe pipe2(
      pipeLength=L,
      pipeDiameter=D,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal,
      redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal,
      from_dp=from_dp,
      linearizeFlowResistance=linearizeFlowResistance,
      deltaM=deltaM)
      annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
    Annex60.Fluid.Sensors.TemperatureTwoPort senTem2(
                                                  m_flow_nominal=m_flow_nominal,
        redeclare package Medium = Medium,
      tau=0,
      allowFlowReversal=allowFlowReversal)
      annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
    Annex60.Fluid.MixingVolumes.MixingVolume       idealHeater2(
      m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium,
      nPorts=2,
      final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      V=V,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      allowFlowReversal=allowFlowReversal)
      annotation (Placement(transformation(extent={{-60,-60},{-80,-40}})));
    BaseClasses.TwinExponentialDecay twinExponentialDecay(
      C=C,
      Ra=Ra,
      Rs=Rs)
      annotation (Placement(transformation(extent={{12,0},{32,20}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
      annotation (Placement(transformation(extent={{-44,-56},{-56,-44}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1
      annotation (Placement(transformation(extent={{44,44},{56,56}})));
  equation
    //Normalized speed of the fluid [1/s]
    u = port_a1.m_flow/(rho*V);
    Q_Losses = -idealHeater1.heatPort.Q_flow/L -idealHeater2.heatPort.Q_flow/L;
    Q_1 = -idealHeater1.heatPort.Q_flow/L;
    Q_2 = -idealHeater2.heatPort.Q_flow/L;

    connect(pDETime.u, realExpression.y) annotation (Line(
        points={{-52,18},{-59,18}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(pipe1.port_b, senTem1.port_a) annotation (Line(
        points={{-40,60},{-24,60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pipe1.port_a, port_a1) annotation (Line(
        points={{-60,60},{-100,60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pipe2.port_b, senTem2.port_a) annotation (Line(
        points={{60,-60},{10,-60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pipe2.port_a, port_a2) annotation (Line(
        points={{80,-60},{100,-60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pDETime.tau, twinExponentialDecay.td) annotation (Line(
        points={{-29,18},{10,18}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TBoundary, twinExponentialDecay.Tb) annotation (Line(
        points={{0,110},{0,14},{10,14}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(senTem1.T, twinExponentialDecay.T1) annotation (Line(
        points={{-14,49},{-14,8},{10,8}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(senTem2.T, twinExponentialDecay.T2) annotation (Line(
        points={{0,-49},{0,4},{10,4}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(senTem1.port_b, idealHeater1.ports[1])
      annotation (Line(points={{-4,60},{68,60}}, color={0,127,255}));
    connect(idealHeater1.ports[2], port_b1)
      annotation (Line(points={{72,60},{72,60},{100,60}}, color={0,127,255}));
    connect(senTem2.port_b, idealHeater2.ports[1])
      annotation (Line(points={{-10,-60},{-68,-60}}, color={0,127,255}));
    connect(idealHeater2.ports[2], port_b2) annotation (Line(points={{-72,-60},{-72,
            -60},{-100,-60}}, color={0,127,255}));
    connect(idealHeater2.heatPort, prescribedTemperature.port)
      annotation (Line(points={{-60,-50},{-56,-50}}, color={191,0,0}));
    connect(idealHeater1.heatPort, prescribedTemperature1.port)
      annotation (Line(points={{60,50},{56,50}}, color={191,0,0}));
    connect(twinExponentialDecay.T1Out, prescribedTemperature1.T) annotation (
        Line(points={{33,14},{40,14},{40,50},{42.8,50}}, color={0,0,127}));
    connect(prescribedTemperature.T, twinExponentialDecay.T2Out) annotation (Line(
          points={{-42.8,-50},{-34,-50},{-34,-40},{40,-40},{40,6},{33,6}}, color={
            0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}),
                     graphics={
          Rectangle(
            extent={{-100,90},{100,28}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={192,192,192}),
          Rectangle(
            extent={{-100,84},{100,34}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255}),
          Rectangle(
            extent={{-26,84},{28,34}},
            lineColor={0,0,255},
            fillPattern=FillPattern.HorizontalCylinder),
          Line(
            points={{55,-85},{-60,-85}},
            color={0,128,255},
            smooth=Smooth.None,
            visible=showDesignFlowDirection),
          Rectangle(
            extent={{-100,100},{100,90}},
            lineColor={175,175,175},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward),
          Rectangle(
            extent={{-100,28},{100,18}},
            lineColor={175,175,175},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward),
          Rectangle(
            extent={{-100,-28},{100,-90}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={192,192,192}),
          Rectangle(
            extent={{-100,-34},{100,-84}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255}),
          Rectangle(
            extent={{-100,-18},{100,-28}},
            lineColor={175,175,175},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward),
          Rectangle(
            extent={{-100,-90},{100,-100}},
            lineColor={175,175,175},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward),
          Rectangle(
            extent={{-26,-34},{28,-84}},
            lineColor={0,0,255},
            fillPattern=FillPattern.HorizontalCylinder),
          Polygon(
            points={{8,70},{8,50},{28,60},{8,70}},
            lineColor={175,175,175},
            smooth=Smooth.None,
            fillColor={0,128,255},
            fillPattern=FillPattern.Forward),
          Line(
            points={{8,60},{-90,60}},
            color={175,175,175},
            smooth=Smooth.None),
          Polygon(
            points={{-6,-50},{-6,-70},{-26,-60},{-6,-50}},
            lineColor={175,175,175},
            smooth=Smooth.None,
            fillColor={0,128,255},
            fillPattern=FillPattern.Forward),
          Line(
            points={{92,-60},{-6,-60}},
            color={175,175,175},
            smooth=Smooth.None)}),
                             Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}})));
  end PlugFlowHeatLossTwinPipe;

  package DoublePipes

    model DHWallenten "District heating pipe based on Wallenten, using the old 
  implementation with a single or multiple (in case of discretization) fluid 
  volumes. The volume-averaged temperature is used as an input to the heat loss 
  equations. Different lay-outs (shared insulation, separate insulation, ground or air)
  are allowed."

      //Extensions
      extends BaseClasses.PartialDistrictHeatingPipe;

      //Parameters
      parameter Integer nSeg=5;

      //Variables
      Modelica.SIunits.Temperature T1;
      Modelica.SIunits.Temperature T2;

      Modelica.SIunits.Temperature Ts "Temperature of the symmetrical problem";
      Modelica.SIunits.Temperature Ta "Temperature of the asymmetrical problem";

      Types.PowerPerLength Qs "Symmetrical heat losses";
      Types.PowerPerLength Qa "Assymmetrical heat losses";

      //Components
      IDEAS.Fluid.Sensors.TemperatureTwoPort TIn1(
        redeclare package Medium=Medium,
        tau=tau,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=m_flow_nominal)
        annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TOut1(
        redeclare package Medium=Medium,
        tau=tau,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=m_flow_nominal)
        annotation (Placement(transformation(extent={{60,50},{80,70}})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TOut2(
        redeclare package Medium=Medium,
        tau=tau,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=m_flow_nominal)
        annotation (Placement(transformation(extent={{-60,-70},{-80,-50}})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TIn2(
        redeclare package Medium=Medium,
        tau=tau,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=m_flow_nominal)
        annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Q2Losses annotation (
         Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,-34})));
      Buildings.Fluid.FixedResistances.Pipe      Pipe1(
        redeclare package Medium = Medium,
        massDynamics=massDynamics,
        energyDynamics=energyDynamics,
        length=L,
        diameter=Di,
        lambdaIns=lambdaI,
        nSeg=nSeg,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=m_flow_nominal,
        from_dp=from_dp,
        linearizeFlowResistance=linearizeFlowResistance,
        deltaM=deltaM,
        thicknessIns=0.000001,
        dp_nominal=dp_nominal)
        annotation (Placement(transformation(extent={{-10,50},{10,70}})));
      Buildings.Fluid.FixedResistances.Pipe      Pipe2(
        redeclare package Medium = Medium,
        massDynamics=massDynamics,
        energyDynamics=energyDynamics,
        length=L,
        lambdaIns=lambdaI,
        diameter=Di,
        nSeg=nSeg,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=m_flow_nominal,
        from_dp=from_dp,
        linearizeFlowResistance=linearizeFlowResistance,
        deltaM=deltaM,
        thicknessIns=0.000001,
        dp_nominal=dp_nominal)
        annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Q1Losses annotation (
         Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,92})));
      Modelica.Blocks.Sources.RealExpression SupplyHeatLosses(y=-Q1)
        annotation (Placement(transformation(extent={{-40,96},{-20,116}})));
      Modelica.Blocks.Sources.RealExpression ReturnHeatLosses(y=-Q2)
        annotation (Placement(transformation(extent={{-40,-22},{-20,-2}})));

    equation
      T1 = (TIn1.T + TOut1.T)/2;
      T2 = (TIn2.T + TOut2.T)/2;

      Ts = (T1 + T2)/2;
      Ta = (T1 - T2)/2;

      Qs=(Ts-Tg)*2*Modelica.Constants.pi*lambdaI*hs;
      Qa=Ta*2*Modelica.Constants.pi*lambdaI*ha;

      Q1 = (Qs + Qa)*L;
      Q2 = (Qs - Qa)*L;

      connect(port_a1, TIn1.port_a) annotation (Line(
          points={{-100,60},{-80,60}},
          color={0,127,255},
          smooth=Smooth.None));

      connect(TOut1.port_b, port_b1) annotation (Line(
          points={{80,60},{100,60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(port_b2, TOut2.port_b) annotation (Line(
          points={{-100,-60},{-80,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TIn2.port_a, port_a2) annotation (Line(
          points={{80,-60},{100,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(Q2Losses.port, Pipe2.heatPort) annotation (Line(
          points={{0,-44},{0,-55}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(SupplyHeatLosses.y, Q1Losses.Q_flow) annotation (Line(
          points={{-19,106},{0,106},{0,102}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ReturnHeatLosses.y, Q2Losses.Q_flow) annotation (Line(
          points={{-19,-12},{0,-12},{0,-24}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(TIn1.port_b, Pipe1.port_a) annotation (Line(
          points={{-60,60},{-10,60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(Pipe1.port_b, TOut1.port_a) annotation (Line(
          points={{10,60},{60,60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TOut2.port_a, Pipe2.port_b) annotation (Line(
          points={{-60,-60},{-10,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(Pipe2.port_a, TIn2.port_b) annotation (Line(
          points={{10,-60},{60,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(Q1Losses.port, Pipe1.heatPort) annotation (Line(
          points={{0,82},{0,65}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},
                {100,140}}), graphics),
                                     Diagram(coordinateSystem(extent={{-100,-140},{
                100,140}},  preserveAspectRatio=false)),
                  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -120},{100,120}}), graphics));
    end DHWallenten;

    model DHDeltaCircuit "District heating pipe model based on the resistor delta circuit, still using 
  fluid volumes with an average temperature based heat loss calculation. Different lay-outs (shared insulation, separate insulation, ground or air)
  are allowed."

      //Extensions
      extends BaseClasses.PartialDistrictHeatingPipe(
        final allowFlowReversal=true);

      //Parameters
      parameter Integer nSeg=5;

      final parameter Types.ThermalResistanceLength R12 = (2*Ra*Rs)/(Rs-Ra);
      final parameter Types.ThermalResistanceLength Rbou = Rs;

      //Components
      Buildings.Fluid.FixedResistances.Pipe      Pipe1(
        redeclare package Medium = Medium,
        massDynamics=massDynamics,
        energyDynamics=energyDynamics,
        length=L,
        diameter=Di,
        nSeg=nSeg,
        useMultipleHeatPorts=true,
        lambdaIns=lambdaI,
        thicknessIns=10e-10,
        allowFlowReversal=allowFlowReversal,
        from_dp=from_dp,
        linearizeFlowResistance=linearizeFlowResistance,
        deltaM=deltaM,
        m_flow_nominal=m_flow_nominal,
        dp_nominal=dp_nominal)
        annotation (Placement(transformation(extent={{10,50},{-10,70}})));
      Buildings.Fluid.FixedResistances.Pipe      Pipe2(
        redeclare package Medium = Medium,
        massDynamics=massDynamics,
        energyDynamics=energyDynamics,
        length=L,
        diameter=Di,
        nSeg=nSeg,
        useMultipleHeatPorts=true,
        lambdaIns=lambdaI,
        thicknessIns=10e-10,
        from_dp=from_dp,
        linearizeFlowResistance=linearizeFlowResistance,
        deltaM=deltaM,
        m_flow_nominal=m_flow_nominal,
        dp_nominal=dp_nominal,
        allowFlowReversal=true)
        annotation (Placement(transformation(extent={{10,-50},{-10,-70}})));

      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature[nSeg]
        prescribedTemperature annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-50,0})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor R12m[nSeg](R=R12*
            nSeg/L)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,0})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor R1[nSeg](R=Rbou*nSeg/
            L)                                                          annotation (
         Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-20,24})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor R2[nSeg](R=Rbou*nSeg/
            L)                                                          annotation (
         Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=270,
            origin={-20,-24})));
    equation

       Q1 = sum(R1.Q_flow) + sum(R12m.Q_flow);
       Q2 = sum(R2.Q_flow) - sum(R12m.Q_flow);

      for i in 1:nSeg loop
        connect(Tg, prescribedTemperature[i].T) annotation (Line(
          points={{0,-142},{0,-100},{-80,-100},{-80,0},{-62,0}},
          color={0,0,127},
          smooth=Smooth.None));
      end for;

      connect(Pipe2.port_b, port_b2) annotation (Line(
          points={{-10,-60},{-100,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(Pipe2.port_a, port_a2) annotation (Line(
          points={{10,-60},{100,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(Pipe1.port_b, port_a1) annotation (Line(
          points={{-10,60},{-100,60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(Pipe1.port_a, port_b1) annotation (Line(
          points={{10,60},{100,60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(R12m.port_a, Pipe1.heatPorts) annotation (Line(
          points={{0,10},{0,55}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(R12m.port_b, Pipe2.heatPorts) annotation (Line(
          points={{0,-10},{0,-55}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(R1.port_a, Pipe1.heatPorts) annotation (Line(
          points={{-20,34},{-20,40},{0,40},{0,55}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(R2.port_a, Pipe2.heatPorts) annotation (Line(
          points={{-20,-34},{-20,-40},{0,-40},{0,-55}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(R2.port_b, R1.port_b) annotation (Line(
          points={{-20,-14},{-20,14}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(prescribedTemperature.port, R1.port_b) annotation (Line(
          points={{-40,0},{-20,0},{-20,14}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -140},{100,140}}),
                             graphics={Polygon(
              points={{0,20},{-20,-20},{20,-20},{0,20}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              smooth=Smooth.None,
              fillColor={0,127,0})}),Diagram(coordinateSystem(extent={{-100,-140},{100,
                140}},      preserveAspectRatio=false)),
                  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -120},{100,120}}), graphics));
    end DHDeltaCircuit;

    model DHPlugWallenten "Wallenten based DH pipe with plug flow. Heat losses are
  calculated using decoupled pipe equations, i.e. the other pipe only influences
  the heat loss of one pipe by means of an average temperature. Different lay-outs (shared insulation, separate insulation, ground or air)
  are allowed."

      //Extensions
      extends BaseClasses.PartialDistrictHeatingPipe(
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState);

      final parameter Real a = (Rs-Ra)/(Ra+Rs);
      final parameter Real b = 1-a;

      final parameter Real R = (2*Rs*Ra)/(Rs+Ra);

      parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1;

      //Variables
      Modelica.SIunits.Temperature T1Bou;
      Modelica.SIunits.Temperature T2Bou;

      Modelica.SIunits.Temperature T1Avg;
      Modelica.SIunits.Temperature T2Avg;

      //Components
      PlugFlowHeatLosses plugFlow1(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        L=L,
        D=Di,
        rho=rho,
        lambdaI=lambdaI,
        R=R,
        allowFlowReversal=allowFlowReversal,
        massDynamics=massDynamics,
        computeFlowResistance=computeFlowResistance,
        from_dp=from_dp,
        dp_nominal=dp_nominal,
        linearizeFlowResistance=linearizeFlowResistance,
        deltaM=deltaM)
        annotation (Placement(transformation(extent={{-10,50},{10,70}})));
      PlugFlowHeatLosses plugFlow2(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        L=L,
        D=Di,
        rho=rho,
        lambdaI=lambdaI,
        R=R,
        allowFlowReversal=allowFlowReversal,
        massDynamics=massDynamics,
        computeFlowResistance=computeFlowResistance,
        from_dp=from_dp,
        dp_nominal=dp_nominal,
        linearizeFlowResistance=linearizeFlowResistance,
        deltaM=deltaM)
        annotation (Placement(transformation(extent={{10,-50},{-10,-70}})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T2In(
        redeclare package Medium = Medium, m_flow_nominal=m_flow_nominal,
        allowFlowReversal=allowFlowReversal)
        annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T2Out(
        redeclare package Medium=Medium, m_flow_nominal=m_flow_nominal,
        allowFlowReversal=allowFlowReversal)
        annotation (Placement(transformation(extent={{40,-70},{20,-50}})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T1Out(
        redeclare package Medium=Medium, m_flow_nominal=m_flow_nominal,
        allowFlowReversal=allowFlowReversal)
        annotation (Placement(transformation(extent={{20,50},{40,70}})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T1In(
        redeclare package Medium = Medium, m_flow_nominal=m_flow_nominal,
        allowFlowReversal=allowFlowReversal)
                                        annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
    public
      Modelica.Blocks.Sources.RealExpression SupplyBoundaryTemperature(y=T1Bou)
        annotation (Placement(transformation(extent={{-32,90},{-12,110}})));
      Modelica.Blocks.Sources.RealExpression ReturnBoundaryTemperature(y=T2Bou)
        annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
    equation
      T1Avg = (T1In.T + T1Out.T)/2;
      T2Avg = (T2In.T + T2Out.T)/2;

      T1Bou = T2Avg*a + Tg*b;
      T2Bou = T1Avg*a + Tg*b;

      Q1 = plugFlow1.Q_Losses*L;
      Q2 = plugFlow2.Q_Losses*L;

      connect(plugFlow2.port_b, T2In.port_a) annotation (Line(
          points={{-10,-60},{-20,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T2Out.port_b, plugFlow2.port_a) annotation (Line(
          points={{20,-60},{10,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T2In.port_b, port_b2) annotation (Line(
          points={{-40,-60},{-100,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T2Out.port_a, port_a2) annotation (Line(
          points={{40,-60},{100,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(plugFlow1.port_b, T1Out.port_a) annotation (Line(
          points={{10,60},{20,60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T1Out.port_b, port_b1) annotation (Line(
          points={{40,60},{100,60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T1In.port_b, plugFlow1.port_a) annotation (Line(
          points={{-20,60},{-10,60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(port_a1, T1In.port_a) annotation (Line(
          points={{-100,60},{-40,60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(SupplyBoundaryTemperature.y, plugFlow1.TBoundary) annotation (Line(
          points={{-11,100},{0.2,100},{0.2,65}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ReturnBoundaryTemperature.y, plugFlow2.TBoundary) annotation (Line(
          points={{-19,-100},{-0.2,-100},{-0.2,-65}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Icon(coordinateSystem(extent={{-100,-140},{100,140}}), graphics={
                                     Text(
              extent={{-151,147},{149,107}},
              lineColor={0,0,255},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={0,127,255},
              textString="%name"),
            Rectangle(
              extent={{-28,-30},{28,-90}},
              lineColor={0,0,255},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{-28,90},{28,30}},
              lineColor={255,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={255,0,0})}),            Diagram(coordinateSystem(extent={{-100,
                -140},{100,140}}, preserveAspectRatio=false)));
    end DHPlugWallenten;

    model DHPlugDelta "District heating pipe with plug flow. The heat losses are 
  calculated according to the solution of Wallentén's equation applied to a coupled
  system of equations for the two pipes. Exact solution for steady-state flow. Different lay-outs (shared insulation, separate insulation, ground or air)
  are allowed."

      //Extensions
      extends BaseClasses.PartialDistrictHeatingPipe(
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState);

      //Components
      PlugFlowHeatLossTwinPipe plugFlowHeatLossTwinPipe(
        redeclare package Medium = Medium,
        L=L,
        ha=ha,
        hs=hs,
        m_flow_nominal=m_flow_nominal,
        k=lambdaI,
        D=Di,
        computeFlowResistance=computeFlowResistance,
        from_dp=from_dp,
        dp_nominal=dp_nominal,
        linearizeFlowResistance=linearizeFlowResistance,
        deltaM=deltaM,
        allowFlowReversal=allowFlowReversal)
        annotation (Placement(transformation(extent={{-30,-30},{30,30}})));
    equation
      Q1 = plugFlowHeatLossTwinPipe.Q_1*L;
      Q2 = plugFlowHeatLossTwinPipe.Q_2*L;

      connect(port_a1, plugFlowHeatLossTwinPipe.port_a1) annotation (Line(
          points={{-100,60},{-60,60},{-60,18},{-30,18}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(plugFlowHeatLossTwinPipe.port_b1, port_b1) annotation (Line(
          points={{30,18},{60,18},{60,60},{100,60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(plugFlowHeatLossTwinPipe.port_b2, port_b2) annotation (Line(
          points={{-30,-18},{-60,-18},{-60,-60},{-100,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(plugFlowHeatLossTwinPipe.port_a2, port_a2) annotation (Line(
          points={{30,-18},{60,-18},{60,-60},{100,-60}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(Tg, plugFlowHeatLossTwinPipe.TBoundary) annotation (Line(
          points={{0,-142},{0,-44},{50,-44},{50,54},{0,54},{0,30}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Icon(coordinateSystem(extent={{-100,-140},{100,140}}), graphics={
                                     Text(
              extent={{-151,147},{149,107}},
              lineColor={0,0,255},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={0,127,255},
              textString="%name"),
            Rectangle(
              extent={{-28,90},{28,30}},
              lineColor={255,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={255,0,0}),
            Rectangle(
              extent={{-28,-30},{28,-90}},
              lineColor={0,0,255},
              fillPattern=FillPattern.HorizontalCylinder),
            Polygon(
              points={{0,20},{-20,-20},{20,-20},{0,20}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              smooth=Smooth.None,
              fillColor={0,127,0})}),            Diagram(coordinateSystem(extent={{-100,
                -140},{100,140}}, preserveAspectRatio=false), graphics));
    end DHPlugDelta;

    package Configurations
      model TwinPipeGround "Twin pipes in the ground"

        //Extensions
        extends BaseClasses.BaseConfiguration(
          hs=1/hsInvers,
          ha=1/haInvers);

      protected
        final parameter Real hsInvers=
          2*lambdaI/lambdaG*Modelica.Math.log(2*Heff/rc) +
          Modelica.Math.log(rc^2/(2*e*ri)) +
          sigma*Modelica.Math.log(rc^4/(rc^4-e^4));
        final parameter Real haInvers=
          Modelica.Math.log(2*e/ri) +
          sigma*Modelica.Math.log((rc^2+e^2)/(rc^2-e^2));
        final parameter Real sigma = (lambdaI-lambdaG)/(lambdaI+lambdaG);

        annotation (Icon(graphics={
              Ellipse(
                extent={{-78,-30},{-18,30}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{18,-28},{78,32}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,255},
                fillColor={127,0,0},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={175,175,175},
                fillColor={255,255,255},
                fillPattern=FillPattern.Forward),
              Ellipse(
                extent={{-72,-28},{-12,32}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{10,-28},{70,32}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid)}));
      end TwinPipeGround;

      model TwinPipeAir "Twin pipes above the ground"

        //Extensions
        extends BaseClasses.BaseConfiguration(
          hs=1/hsInvers,
          ha=1/haInvers);

      protected
        parameter Real hsInvers=
          Modelica.Math.log(rc^2/(2*e*ri)) -
          Modelica.Math.log(rc^4/(rc^4-e^4));
        parameter Real haInvers=
          Modelica.Math.log(2*e/ri) -
          Modelica.Math.log((rc^2+e^2)/(rc^2-e^2));

        annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                  {100,100}}), graphics={
              Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,255},
                fillColor={0,128,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={175,175,175},
                fillColor={255,255,255},
                fillPattern=FillPattern.Forward),
              Ellipse(
                extent={{-72,-28},{-12,32}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{10,-28},{70,32}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid)}));
      end TwinPipeAir;

      model TwinPipeSeparate "Twin pipes in separate insulation"

        //Extensions
        extends BaseClasses.BaseConfiguration(
          hs=1/hsInvers,
          ha=1/haInvers);
        //Parameters
      protected
        parameter Real hsInvers=
          Modelica.Math.log(2*Heff/ro) + beta +
          Modelica.Math.log(sqrt(1 + (Heff/e)^2));
        parameter Real haInvers=
          Modelica.Math.log(2*Heff/ro) + beta -
          Modelica.Math.log(sqrt(1 + (Heff/e)^2));

        annotation (Icon(graphics={
              Ellipse(
                extent={{-80,-34},{-12,34}},
                lineColor={0,0,255},
                fillColor={175,175,175},
                fillPattern=FillPattern.Forward),
              Ellipse(
                extent={{-76,-30},{-16,30}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{16,-30},{76,30}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{12,-34},{80,34}},
                lineColor={0,0,255},
                fillColor={175,175,175},
                fillPattern=FillPattern.Forward),
              Ellipse(
                extent={{16,-30},{76,30}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid)}));
      end TwinPipeSeparate;
    end Configurations;
  end DoublePipes;

  package Examples
    extends Modelica.Icons.ExamplesPackage;

    model MassflowPulse
      import DistrictHeating;
      extends Modelica.Icons.Example;
      import IDEAS;

      IDEAS.Fluid.Sources.FixedBoundary bou2(
        p=100000,
        T=273.15 + 70,
        redeclare package Medium = IDEAS.Media.Water.Simple,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-88,0})));

      IDEAS.Fluid.Sources.FixedBoundary bou3(
        use_T=false,
        use_p=true,
        p=100000,
        nPorts=1,
        redeclare package Medium = IDEAS.Media.Water.Simple)
                  annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={88,0})));

      IDEAS.Fluid.Sensors.TemperatureTwoPort TPlugIn(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-36,0})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TPlugOut(m_flow_nominal=0.1,
          redeclare package Medium = IDEAS.Media.Water.Simple) annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={58,0})));

      DistrictHeating.Pipes.PlugFlowHeatLosses plug(
        D=0.05,
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=1,
        dp_nominal=0,
        k=0.026,
        L=50)
        annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
      Buildings.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=273.15 + 20)
        annotation (Placement(transformation(extent={{-96,60},{-76,80}})));
      Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
        annotation (Placement(transformation(extent={{-36,34},{-28,42}})));
      IDEAS.Fluid.Sources.FixedBoundary bou4(
        p=100000,
        T=273.15 + 70,
        redeclare package Medium = IDEAS.Media.Water.Simple,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-88,-40})));
      IDEAS.Fluid.Sources.FixedBoundary bou5(
        use_T=false,
        use_p=true,
        p=100000,
        nPorts=1,
        redeclare package Medium = IDEAS.Media.Water.Simple)
                  annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={88,-40})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TMocIn(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-34,-40})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TMocOut(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={58,-40})));
      Modelica.Fluid.Pipes.DynamicPipe MSL(
        length=plug.L,
        diameter=plug.D,
        use_HeatTransfer=true,
        redeclare package Medium = Annex60.Media.Water,
        T_start=273.15 + 20,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer
            (T_ambient=273.15 + 20, alpha0=plug.k*plug.S/(plug.pi*plug.D)),
        nNodes=100)
        annotation (Placement(transformation(extent={{-6,-50},{14,-30}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne(m=MSL.nNodes)
        "Connector to assign multiple heat ports to one heat port" annotation (
          Placement(transformation(
            extent={{-6,-6},{6,6}},
            rotation=180,
            origin={4,-26})));
      IDEAS.Fluid.Sources.FixedBoundary bou6(
        p=100000,
        T=273.15 + 70,
        redeclare package Medium = IDEAS.Media.Water.Simple,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-88,-80})));
      IDEAS.Fluid.Sources.FixedBoundary bou7(
        use_T=false,
        use_p=true,
        p=100000,
        nPorts=1,
        redeclare package Medium = IDEAS.Media.Water.Simple)
                  annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={88,-80})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TVolIn(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-34,-80})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TVolOut(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={58,-80})));
      Annex60.Fluid.MixingVolumes.MixingVolume vol(
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=1,
        nPorts=2,
        V=plug.V)
        annotation (Placement(transformation(extent={{34,-80},{14,-60}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor1(R=
            plug.r/plug.L) annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={40,50})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan(redeclare package Medium
          = Annex60.Media.Water, m_flow_nominal=0.5)
        annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan1(redeclare package Medium
          = Annex60.Media.Water, m_flow_nominal=0.5)
        annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan2(redeclare package Medium
          = Annex60.Media.Water, m_flow_nominal=0.5)
        annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
      Modelica.Blocks.Sources.Pulse pulse(
        width=10,
        period=1000,
        amplitude=0.9,
        offset=0.1)
        annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    equation
      connect(TPlugOut.port_b, bou3.ports[1]) annotation (Line(
          points={{68,0},{78,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TPlugIn.port_b, plug.port_a) annotation (Line(
          points={{-26,0},{-22,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(plug.port_b, TPlugOut.port_a) annotation (Line(
          points={{-2,0},{48,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(fixedTemperature.port, temperatureSensor.port) annotation (Line(
          points={{-76,70},{-62,70},{-62,38},{-36,38}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(temperatureSensor.T, plug.TBoundary) annotation (Line(
          points={{-28,38},{-11.8,38},{-11.8,5}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(TMocOut.port_b, bou5.ports[1]) annotation (Line(
          points={{68,-40},{78,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TMocIn.port_b, MSL.port_a) annotation (Line(
          points={{-24,-40},{-6,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(MSL.port_b, TMocOut.port_a) annotation (Line(
          points={{14,-40},{48,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(colAllToOne.port_a, MSL.heatPorts) annotation (Line(
          points={{4,-32},{4,-35.6},{4.1,-35.6}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(colAllToOne.port_b, temperatureSensor.port) annotation (Line(
          points={{4,-20},{4,70},{-62,70},{-62,38},{-36,38}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(TVolOut.port_b, bou7.ports[1]) annotation (Line(
          points={{68,-80},{78,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TVolIn.port_b, vol.ports[1]) annotation (Line(
          points={{-24,-80},{26,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(vol.ports[2], TVolOut.port_a) annotation (Line(
          points={{22,-80},{48,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(vol.heatPort, thermalResistor1.port_b) annotation (Line(
          points={{34,-70},{40,-70},{40,40}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(thermalResistor1.port_a, temperatureSensor.port) annotation (Line(
          points={{40,60},{40,70},{-62,70},{-62,38},{-36,38}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(bou2.ports[1], fan.port_a) annotation (Line(
          points={{-78,0},{-70,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(fan.port_b, TPlugIn.port_a) annotation (Line(
          points={{-50,0},{-46,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(bou4.ports[1], fan1.port_a) annotation (Line(
          points={{-78,-40},{-70,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TMocIn.port_a, fan1.port_b) annotation (Line(
          points={{-44,-40},{-50,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(bou6.ports[1], fan2.port_a) annotation (Line(
          points={{-78,-80},{-70,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TVolIn.port_a, fan2.port_b) annotation (Line(
          points={{-44,-80},{-50,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(fan1.m_flow_in, fan2.m_flow_in) annotation (Line(
          points={{-60.2,-28},{-60.2,-20},{-68,-20},{-68,-60},{-60.2,-60},{-60.2,
              -68}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pulse.y, fan.m_flow_in) annotation (Line(
          points={{-79,30},{-60.2,30},{-60.2,12}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pulse.y, fan2.m_flow_in) annotation (Line(
          points={{-79,30},{-68,30},{-68,-60},{-60.2,-60},{-60.2,-68}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), Icon(coordinateSystem(extent={{-100,
                -100},{100,100}})),
        experiment(StopTime=25000),
        __Dymola_experimentSetupOutput,
        __Dymola_Commands(executeCall(ensureSimulated=true) = RunScript(
            "C:/Users/u0098668/Documents/Modelica/DistrictHeating/DistrictHeating/simulate and plot.mos")
            "Simulate and plot"));
    end MassflowPulse;

    model TemperaturePulse
      import DistrictHeating;
      extends Modelica.Icons.Example;
      import IDEAS;

      IDEAS.Fluid.Sources.FixedBoundary bou2(
        p=100000,
        T=273.15 + 70,
        redeclare package Medium = IDEAS.Media.Water.Simple,
        nPorts=1) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-96,0})));

      IDEAS.Fluid.Sources.FixedBoundary bou3(
        use_T=false,
        use_p=true,
        p=100000,
        nPorts=1,
        redeclare package Medium = IDEAS.Media.Water.Simple)
                  annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={88,0})));

      IDEAS.Fluid.Sensors.TemperatureTwoPort TPlugIn(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-24,0})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TPlugOut(m_flow_nominal=0.1,
          redeclare package Medium = IDEAS.Media.Water.Simple) annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={58,0})));

      DistrictHeating.Pipes.PlugFlowHeatLosses plug(
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=1,
        dp_nominal=0,
        k=0.026,
        L=100,
        D=0.05)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      Buildings.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=273.15 + 20)
        annotation (Placement(transformation(extent={{-96,60},{-76,80}})));
      Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
        annotation (Placement(transformation(extent={{-36,34},{-28,42}})));
      IDEAS.Fluid.Sources.FixedBoundary bou4(
        p=100000,
        T=273.15 + 70,
        redeclare package Medium = IDEAS.Media.Water.Simple,
        nPorts=1) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-96,-40})));
      IDEAS.Fluid.Sources.FixedBoundary bou5(
        use_T=false,
        use_p=true,
        p=100000,
        nPorts=1,
        redeclare package Medium = IDEAS.Media.Water.Simple)
                  annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={88,-40})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TMocIn(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-22,-40})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TMocOut(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={58,-40})));
      Modelica.Fluid.Pipes.DynamicPipe MSL(
        length=plug.L,
        diameter=plug.D,
        use_HeatTransfer=true,
        redeclare package Medium = Annex60.Media.Water,
        T_start=273.15 + 20,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer
            (T_ambient=273.15 + 20, alpha0=plug.k*plug.S/(plug.pi*plug.D)),
        nNodes=pip.nSeg)
        annotation (Placement(transformation(extent={{-2,-50},{18,-30}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne(m=MSL.nNodes)
        "Connector to assign multiple heat ports to one heat port" annotation (
          Placement(transformation(
            extent={{-6,-6},{6,6}},
            rotation=180,
            origin={8,-26})));
      IDEAS.Fluid.Sources.FixedBoundary bou6(
        p=100000,
        T=273.15 + 70,
        redeclare package Medium = IDEAS.Media.Water.Simple,
        nPorts=1) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-96,-80})));
      IDEAS.Fluid.Sources.FixedBoundary bou7(
        use_T=false,
        use_p=true,
        p=100000,
        nPorts=1,
        redeclare package Medium = IDEAS.Media.Water.Simple)
                  annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={88,-80})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TVolIn(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-22,-80})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TVolOut(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={58,-80})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan(redeclare package Medium
          = Annex60.Media.Water, m_flow_nominal=0.5)
        annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan1(redeclare package Medium
          = Annex60.Media.Water, m_flow_nominal=0.5)
        annotation (Placement(transformation(extent={{-58,-50},{-38,-30}})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan2(redeclare package Medium
          = Annex60.Media.Water, m_flow_nominal=0.5)
        annotation (Placement(transformation(extent={{-58,-90},{-38,-70}})));
      Modelica.Blocks.Sources.Pulse pulse(
        width=5,
        period=86400,
        offset=273.15 + 50,
        amplitude=35)
        annotation (Placement(transformation(extent={{-70,-26},{-78,-18}})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater(
        dp_nominal=0,
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=0.1)
        annotation (Placement(transformation(extent={{-84,-10},{-64,10}})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater1(
        dp_nominal=0,
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=0.1)
        annotation (Placement(transformation(extent={{-84,-50},{-64,-30}})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater2(
        dp_nominal=0,
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=0.1)
        annotation (Placement(transformation(extent={{-84,-90},{-64,-70}})));
      Modelica.Blocks.Sources.Pulse pulse1(
        period=86400,
        amplitude=0,
        width=0,
        offset=0.2)
        annotation (Placement(transformation(extent={{-66,-26},{-58,-18}})));
      DistrictHeating.Pipes.PlugFlowHeatLosses plug1(
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=1,
        dp_nominal=0,
        L=plug.L,
        D=plug.D,
        k=plug.k)
        annotation (Placement(transformation(extent={{18,-10},{38,10}})));
      Modelica.Fluid.Pipes.DynamicPipe MSL1(
        length=plug.L,
        diameter=plug.D,
        use_HeatTransfer=true,
        redeclare package Medium = Annex60.Media.Water,
        T_start=273.15 + 20,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer
            (T_ambient=273.15 + 20, alpha0=plug.k*plug.S/(plug.pi*plug.D)),
        nNodes=pip.nSeg)
        annotation (Placement(transformation(extent={{24,-50},{44,-30}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne1(m=MSL.nNodes)
        "Connector to assign multiple heat ports to one heat port" annotation (
          Placement(transformation(
            extent={{-6,-6},{6,6}},
            rotation=180,
            origin={34,-26})));
      Buildings.Fluid.FixedResistances.Pipe pip(
        redeclare package Medium = Annex60.Media.Water,
        lambdaIns=plug.k,
        diameter=plug.D,
        length=plug.L,
        m_flow_nominal=0.1,
        dp_nominal=0,
        nSeg=50,
        thicknessIns=plug.h)
                  annotation (Placement(transformation(extent={{-6,-90},{14,-70}})));
      Buildings.Fluid.FixedResistances.Pipe pip1(
        redeclare package Medium = Annex60.Media.Water,
        lambdaIns=plug.k,
        diameter=plug.D,
        length=plug.L,
        m_flow_nominal=0.1,
        nSeg=pip.nSeg,
        thicknessIns=plug.h)
        annotation (Placement(transformation(extent={{24,-90},{44,-70}})));
    equation
      connect(TPlugOut.port_b, bou3.ports[1]) annotation (Line(
          points={{68,0},{78,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TPlugIn.port_b, plug.port_a) annotation (Line(
          points={{-14,0},{-10,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(fixedTemperature.port, temperatureSensor.port) annotation (Line(
          points={{-76,70},{-62,70},{-62,38},{-36,38}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(temperatureSensor.T, plug.TBoundary) annotation (Line(
          points={{-28,38},{0.2,38},{0.2,5}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(TMocOut.port_b, bou5.ports[1]) annotation (Line(
          points={{68,-40},{78,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TMocIn.port_b, MSL.port_a) annotation (Line(
          points={{-12,-40},{-2,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(colAllToOne.port_a, MSL.heatPorts) annotation (Line(
          points={{8,-32},{8,-35.6},{8.1,-35.6}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(colAllToOne.port_b, temperatureSensor.port) annotation (Line(
          points={{8,-20},{8,70},{-62,70},{-62,38},{-36,38}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(TVolOut.port_b, bou7.ports[1]) annotation (Line(
          points={{68,-80},{78,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(fan.port_b, TPlugIn.port_a) annotation (Line(
          points={{-38,0},{-34,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TMocIn.port_a, fan1.port_b) annotation (Line(
          points={{-32,-40},{-38,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TVolIn.port_a, fan2.port_b) annotation (Line(
          points={{-32,-80},{-38,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(bou2.ports[1], idealHeater.port_a) annotation (Line(
          points={{-92,0},{-84,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater.port_b, fan.port_a) annotation (Line(
          points={{-64,0},{-58,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(bou4.ports[1], idealHeater1.port_a) annotation (Line(
          points={{-92,-40},{-84,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater1.port_b, fan1.port_a) annotation (Line(
          points={{-64,-40},{-58,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(bou6.ports[1], idealHeater2.port_a) annotation (Line(
          points={{-92,-80},{-84,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater2.port_b, fan2.port_a) annotation (Line(
          points={{-64,-80},{-58,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(pulse.y, idealHeater2.TSet) annotation (Line(
          points={{-78.4,-22},{-90,-22},{-90,-74},{-86,-74}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(idealHeater1.TSet, idealHeater2.TSet) annotation (Line(
          points={{-86,-34},{-90,-34},{-90,-74},{-86,-74}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(idealHeater.TSet, idealHeater2.TSet) annotation (Line(
          points={{-86,6},{-90,6},{-90,-74},{-86,-74}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pulse1.y, fan1.m_flow_in) annotation (Line(
          points={{-57.6,-22},{-48.2,-22},{-48.2,-28}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pulse1.y, fan2.m_flow_in) annotation (Line(
          points={{-57.6,-22},{-54,-22},{-54,-64},{-48.2,-64},{-48.2,-68}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(fan.m_flow_in, fan2.m_flow_in) annotation (Line(
          points={{-48.2,12},{-48,12},{-48,18},{-54,18},{-54,-64},{-48.2,-64},{
              -48.2,-68}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(plug.port_b, plug1.port_a) annotation (Line(
          points={{10,0},{18,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(plug1.port_b, TPlugOut.port_a) annotation (Line(
          points={{38,0},{48,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(plug1.TBoundary, plug.TBoundary) annotation (Line(
          points={{28.2,5},{28.2,38},{0.2,38},{0.2,5}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(MSL.port_b, MSL1.port_a) annotation (Line(
          points={{18,-40},{24,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(MSL1.port_b, TMocOut.port_a) annotation (Line(
          points={{44,-40},{48,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(MSL1.heatPorts, colAllToOne1.port_a) annotation (Line(
          points={{34.1,-35.6},{34,-35.6},{34,-32}},
          color={127,0,0},
          smooth=Smooth.None));
      connect(colAllToOne1.port_b, temperatureSensor.port) annotation (Line(
          points={{34,-20},{34,-16},{8,-16},{8,70},{-62,70},{-62,38},{-36,38}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(TVolIn.port_b, pip.port_a) annotation (Line(
          points={{-12,-80},{-6,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(pip.port_b, pip1.port_a) annotation (Line(
          points={{14,-80},{24,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TVolOut.port_a, pip1.port_b) annotation (Line(
          points={{48,-80},{44,-80}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(pip.heatPort, temperatureSensor.port) annotation (Line(
          points={{4,-75},{4,-64},{20,-64},{20,-16},{8,-16},{8,70},{-62,70},{-62,38},
              {-36,38}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(pip1.heatPort, temperatureSensor.port) annotation (Line(
          points={{34,-75},{34,-64},{20,-64},{20,-16},{8,-16},{8,70},{-62,70},{-62,
              38},{-36,38}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), Icon(coordinateSystem(extent={{-100,
                -100},{100,100}})),
        experiment(StopTime=180000),
        __Dymola_experimentSetupOutput,
        __Dymola_Commands(executeCall(ensureSimulated=true) = RunScript(
            "C:/Users/u0098668/Documents/Modelica/DistrictHeating/DistrictHeating/simulate and plot.mos")
            "Simulate and plot"));
    end TemperaturePulse;

    model MSL
      import DistrictHeating;
      extends Modelica.Icons.Example;
      import IDEAS;

      Buildings.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=273.15 + 20)
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
      IDEAS.Fluid.Sources.FixedBoundary bou4(
        p=100000,
        T=273.15 + 70,
        redeclare package Medium = IDEAS.Media.Water.Simple,
        nPorts=1) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-94,-30})));
      IDEAS.Fluid.Sources.FixedBoundary bou5(
        use_T=false,
        use_p=true,
        p=100000,
        nPorts=1,
        redeclare package Medium = IDEAS.Media.Water.Simple)
                  annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={90,-30})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TMocIn(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-20,-30})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TMocOut(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={60,-30})));
      Modelica.Fluid.Pipes.DynamicPipe MSL(
        use_HeatTransfer=true,
        redeclare package Medium = Annex60.Media.Water,
        T_start=273.15 + 20,
        length=50,
        diameter=0.05,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer
            (T_ambient=273.15 + 20, alpha0=0.026*18.6373/(Modelica.Constants.pi*
                0.05)),
        nNodes=20)
        annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne(m=MSL.nNodes)
        "Connector to assign multiple heat ports to one heat port" annotation (
          Placement(transformation(
            extent={{-6,-6},{6,6}},
            rotation=180,
            origin={10,-16})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan1(redeclare package Medium
          = Annex60.Media.Water, m_flow_nominal=0.5)
        annotation (Placement(transformation(extent={{-56,-40},{-36,-20}})));
      Modelica.Blocks.Sources.Pulse pulse(
        width=5,
        period=86400,
        offset=273.15 + 50,
        amplitude=20)
        annotation (Placement(transformation(extent={{-68,-16},{-76,-8}})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater1(
        dp_nominal=0,
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=0.1)
        annotation (Placement(transformation(extent={{-82,-40},{-62,-20}})));
      Modelica.Blocks.Sources.Pulse pulse1(
        period=86400,
        amplitude=0,
        width=0,
        offset=0.1)
        annotation (Placement(transformation(extent={{-64,-16},{-56,-8}})));
      Modelica.Fluid.Pipes.DynamicPipe MSL1(
        use_HeatTransfer=true,
        redeclare package Medium = Annex60.Media.Water,
        T_start=273.15 + 20,
        length=50,
        diameter=0.05,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer
            (T_ambient=273.15 + 20, alpha0=0.026*18.6373/(Modelica.Constants.pi*
                0.05)),
        nNodes=MSL.nNodes)
        annotation (Placement(transformation(extent={{26,-40},{46,-20}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne1(m=MSL.nNodes)
        "Connector to assign multiple heat ports to one heat port" annotation (
          Placement(transformation(
            extent={{-6,-6},{6,6}},
            rotation=180,
            origin={36,-16})));
    equation
      connect(TMocOut.port_b,bou5. ports[1]) annotation (Line(
          points={{70,-30},{80,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TMocIn.port_b,MSL. port_a) annotation (Line(
          points={{-10,-30},{0,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(colAllToOne.port_a,MSL. heatPorts) annotation (Line(
          points={{10,-22},{10,-25.6},{10.1,-25.6}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(TMocIn.port_a, fan1.port_b) annotation (Line(
          points={{-30,-30},{-36,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(bou4.ports[1], idealHeater1.port_a) annotation (Line(
          points={{-90,-30},{-82,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater1.port_b, fan1.port_a) annotation (Line(
          points={{-62,-30},{-56,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(pulse1.y, fan1.m_flow_in) annotation (Line(
          points={{-55.6,-12},{-46.2,-12},{-46.2,-18}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(MSL.port_b, MSL1.port_a) annotation (Line(
          points={{20,-30},{26,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(MSL1.port_b, TMocOut.port_a) annotation (Line(
          points={{46,-30},{50,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(MSL1.heatPorts, colAllToOne1.port_a) annotation (Line(
          points={{36.1,-25.6},{36,-25.6},{36,-22}},
          color={127,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port, colAllToOne.port_b) annotation (Line(
          points={{0,10},{10,10},{10,-10}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port, colAllToOne1.port_b) annotation (Line(
          points={{0,10},{36,10},{36,-10}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(pulse.y, idealHeater1.TSet) annotation (Line(
          points={{-76.4,-12},{-88,-12},{-88,-24},{-84,-24}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), Icon(coordinateSystem(extent={{-100,
                -100},{100,100}})),
        experiment(StopTime=604800),
        __Dymola_experimentSetupOutput);
    end MSL;

    model PlugFlow
      import DistrictHeating;
      extends Modelica.Icons.Example;
      import IDEAS;

      IDEAS.Fluid.Sources.FixedBoundary bou2(
        p=100000,
        T=273.15 + 70,
        redeclare package Medium = IDEAS.Media.Water.Simple,
        nPorts=1,
        use_T=false)
                  annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-94,10})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TPlugIn(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple,
        tau=0)                                       annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-22,10})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TPlugOut(m_flow_nominal=0.1,
          redeclare package Medium = IDEAS.Media.Water.Simple,
        tau=0)                                                 annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={60,10})));
      DistrictHeating.Pipes.PlugFlowHeatLosses plug(
        D=0.05,
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=1,
        dp_nominal=0,
        k=0.026,
        L=100)
        annotation (Placement(transformation(extent={{-6,0},{14,20}})));
      Buildings.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=273.15 + 20)
        annotation (Placement(transformation(extent={{-94,70},{-74,90}})));
      Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
        annotation (Placement(transformation(extent={{-34,76},{-26,84}})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan(
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=0.5,
        massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
        annotation (Placement(transformation(extent={{-56,0},{-36,20}})));
      Modelica.Blocks.Sources.Pulse pulse(
        width=5,
        period=86400,
        offset=273.15 + 50,
        amplitude=20)
        annotation (Placement(transformation(extent={{-68,30},{-76,38}})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater(
        dp_nominal=0,
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=0.1)
        annotation (Placement(transformation(extent={{-82,0},{-62,20}})));
      Modelica.Blocks.Sources.Pulse pulse1(
        period=86400,
        amplitude=0,
        width=0,
        offset=0.1)
        annotation (Placement(transformation(extent={{-60,30},{-52,38}})));
      DistrictHeating.Pipes.PlugFlowHeatLosses plug1(
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=1,
        dp_nominal=0,
        L=plug.L,
        D=plug.D,
        h=plug.h,
        k=plug.k)
        annotation (Placement(transformation(extent={{20,0},{40,20}})));
    equation
      connect(TPlugIn.port_b,plug. port_a) annotation (Line(
          points={{-12,10},{-6,10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(fixedTemperature.port,temperatureSensor. port) annotation (Line(
          points={{-74,80},{-34,80}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(temperatureSensor.T,plug. TBoundary) annotation (Line(
          points={{-26,80},{4.2,80},{4.2,15}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(fan.port_b, TPlugIn.port_a) annotation (Line(
          points={{-36,10},{-32,10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(bou2.ports[1], idealHeater.port_a) annotation (Line(
          points={{-90,10},{-82,10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater.port_b, fan.port_a) annotation (Line(
          points={{-62,10},{-56,10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(plug.port_b, plug1.port_a) annotation (Line(
          points={{14,10},{20,10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(plug1.port_b, TPlugOut.port_a) annotation (Line(
          points={{40,10},{50,10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(plug1.TBoundary, plug.TBoundary) annotation (Line(
          points={{30.2,15},{30.2,80},{4.2,80},{4.2,15}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pulse1.y, fan.m_flow_in) annotation (Line(
          points={{-51.6,34},{-46.2,34},{-46.2,22}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pulse.y, idealHeater.TSet) annotation (Line(
          points={{-76.4,34},{-88,34},{-88,16},{-84,16}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(TPlugOut.port_b, idealHeater.port_a) annotation (Line(
          points={{70,10},{76,10},{76,-20},{-86,-20},{-86,10},{-82,10}},
          color={0,127,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), Icon(coordinateSystem(extent={{-100,
                -100},{100,100}})),
        experiment(StopTime=604800),
        __Dymola_experimentSetupOutput,
        __Dymola_Commands(executeCall(ensureSimulated=true) = RunScript(
            "C:/Users/u0098668/Documents/Modelica/DistrictHeating/DistrictHeating/simulate and plot.mos")
            "Simulate and plot"));
    end PlugFlow;

    model Pipes
      import DistrictHeating;
      extends Modelica.Icons.Example;
      import IDEAS;

      Buildings.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=273.15 + 20)
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
      IDEAS.Fluid.Sources.FixedBoundary bou4(
        p=100000,
        T=273.15 + 70,
        redeclare package Medium = IDEAS.Media.Water.Simple,
        nPorts=1) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-94,-30})));
      IDEAS.Fluid.Sources.FixedBoundary bou5(
        use_T=false,
        use_p=true,
        p=100000,
        nPorts=1,
        redeclare package Medium = IDEAS.Media.Water.Simple)
                  annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={90,-30})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TMocIn(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-20,-30})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort TMocOut(m_flow_nominal=0.1, redeclare
          package Medium = IDEAS.Media.Water.Simple) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={60,-30})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan1(redeclare package Medium
          = Annex60.Media.Water, m_flow_nominal=0.5)
        annotation (Placement(transformation(extent={{-56,-40},{-36,-20}})));
      Modelica.Blocks.Sources.Pulse pulse(
        width=5,
        period=86400,
        offset=273.15 + 50,
        amplitude=20)
        annotation (Placement(transformation(extent={{-68,-16},{-76,-8}})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater1(
        dp_nominal=0,
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=0.1)
        annotation (Placement(transformation(extent={{-82,-40},{-62,-20}})));
      Modelica.Blocks.Sources.Pulse pulse1(
        period=86400,
        amplitude=0,
        width=0,
        offset=0.1)
        annotation (Placement(transformation(extent={{-64,-16},{-56,-8}})));
      Buildings.Fluid.FixedResistances.Pipe pip(
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=0.1,
        dp_nominal=0,
        thicknessIns=0.02,
        lambdaIns=0.026,
        diameter=0.05,
        length=100,
        nSeg=2) annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
      Buildings.Fluid.FixedResistances.Pipe pip1(
        redeclare package Medium = Annex60.Media.Water,
        m_flow_nominal=0.1,
        dp_nominal=0,
        nSeg=pip.nSeg,
        thicknessIns=pip.thicknessIns,
        lambdaIns=pip.lambdaIns,
        diameter=pip.diameter,
        length=pip.length)
        annotation (Placement(transformation(extent={{26,-40},{46,-20}})));
    equation
      connect(TMocOut.port_b,bou5. ports[1]) annotation (Line(
          points={{70,-30},{80,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TMocIn.port_a, fan1.port_b) annotation (Line(
          points={{-30,-30},{-36,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(bou4.ports[1], idealHeater1.port_a) annotation (Line(
          points={{-90,-30},{-82,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater1.port_b, fan1.port_a) annotation (Line(
          points={{-62,-30},{-56,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(pulse1.y, fan1.m_flow_in) annotation (Line(
          points={{-55.6,-12},{-46.2,-12},{-46.2,-18}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pulse.y, idealHeater1.TSet) annotation (Line(
          points={{-76.4,-12},{-88,-12},{-88,-24},{-84,-24}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(TMocIn.port_b, pip.port_a) annotation (Line(
          points={{-10,-30},{0,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(pip.port_b, pip1.port_a) annotation (Line(
          points={{20,-30},{26,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TMocOut.port_a, pip1.port_b) annotation (Line(
          points={{50,-30},{46,-30}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(fixedTemperature.port, pip.heatPort) annotation (Line(
          points={{0,10},{10,10},{10,-25}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port, pip1.heatPort) annotation (Line(
          points={{0,10},{36,10},{36,-25}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), Icon(coordinateSystem(extent={{-100,
                -100},{100,100}})),
        experiment(StopTime=604800),
        __Dymola_experimentSetupOutput);
    end Pipes;

    model TwinPipes

      extends Modelica.Icons.Example;
      IDEAS.Fluid.Sources.FixedBoundary bou2(
        T=273.15 + 70,
        use_T=false,
        nPorts=1,
        redeclare package Medium = Annex60.Media.Water)
                  annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-80,48})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T1PlugIn(m_flow_nominal=0.1,
          redeclare package Medium = Annex60.Media.Water)      annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-30,70})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T2PlugIn(m_flow_nominal=0.1,
          redeclare package Medium = Annex60.Media.Water)      annotation (
          Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={32,38})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan(
                                 m_flow_nominal=0.5,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{-64,60},{-44,80}})));
      Modelica.Blocks.Sources.Pulse pulse(
        period=86400,
        width=4,
        offset=273.15 + 50,
        amplitude=20)
        annotation (Placement(transformation(extent={{-86,86},{-94,94}})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater(
        dp_nominal=0,
        m_flow_nominal=0.1,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{-88,60},{-68,80}})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater1(
        dp_nominal=0,
        m_flow_nominal=0.1,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{84,28},{64,48}})));
      Modelica.Blocks.Sources.Pulse pulse1(
        period=86400,
        startTime=7200,
        width=60,
        amplitude=-0.09,
        offset=0.1)
        annotation (Placement(transformation(extent={{-80,86},{-72,94}})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T1PlugOut(
        m_flow_nominal=0.1,
        tau=0,
        redeclare package Medium = Annex60.Media.Water)
               annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={32,70})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T2PlugOut(m_flow_nominal=0.1,
          redeclare package Medium = Annex60.Media.Water)      annotation (
          Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={-30,40})));
      Modelica.Blocks.Sources.Constant const(k=273.15 + 10)
        annotation (Placement(transformation(extent={{42,58},{50,66}})));
      Modelica.Blocks.Sources.Constant const1(k=273.15 + 5)  annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-12,20})));
      IDEAS.Fluid.Sources.FixedBoundary bou1(
        T=273.15 + 70,
        use_T=false,
        nPorts=1,
        redeclare package Medium = Annex60.Media.Water)
                  annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-80,-20})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T1PipeIn(m_flow_nominal=0.1,
          redeclare package Medium = Annex60.Media.Water)      annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-30,6})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T2PipeIn(m_flow_nominal=0.1,
          redeclare package Medium = Annex60.Media.Water)      annotation (
          Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={30,-24})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan1(
                                 m_flow_nominal=0.5,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{-64,-4},{-44,16}})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater2(
        dp_nominal=0,
        m_flow_nominal=0.1,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{-88,-4},{-68,16}})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater3(
        dp_nominal=0,
        m_flow_nominal=0.1,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{64,-4},{84,16}})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T1PipeOut(
        m_flow_nominal=0.1,
        tau=0,
        redeclare package Medium = Annex60.Media.Water)
               annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={30,6})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T2PipeOut(m_flow_nominal=0.1,
          redeclare package Medium = Annex60.Media.Water)      annotation (
          Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={-30,-28})));
      IDEAS.Fluid.Sources.FixedBoundary bou3(
        T=273.15 + 70,
        use_T=false,
        nPorts=1,
        redeclare package Medium = Annex60.Media.Water)
                  annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-80,-78})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T2TRIn(m_flow_nominal=0.1, redeclare
          package Medium = Annex60.Media.Water)      annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={30,-86})));
      Annex60.Fluid.Movers.FlowControlled_m_flow fan2(
                                 m_flow_nominal=0.5,
        massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        addPowerToMedium=false,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{-64,-66},{-44,-46}})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater5(
        dp_nominal=0,
        m_flow_nominal=0.1,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{62,-66},{82,-46}})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T1TROut(
        m_flow_nominal=0.1,
        tau=0,
        redeclare package Medium = Annex60.Media.Water)
               annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={30,-56})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T2TROut(m_flow_nominal=0.1, redeclare
          package Medium = Annex60.Media.Water)      annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={-30,-90})));
      IDEAS.Fluid.Sensors.TemperatureTwoPort T1TRIn(
        m_flow_nominal=0.1,
        tau=0,
        redeclare package Medium = Annex60.Media.Water)
               annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-30,-56})));
      Annex60.Fluid.HeatExchangers.HeaterCooler_T    idealHeater4(
        dp_nominal=0,
        m_flow_nominal=0.1,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{-88,-66},{-68,-46}})));
      DoublePipes.DHPlugWallenten dHPlugWallenten(
        redeclare DoublePipes.Configurations.TwinPipeGround
          baseConfiguration,
        L=100,
        Di=0.05,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{-10,42},{10,70}})));
      DoublePipes.DHPlugDelta dHPipePlugDelta(
        L=dHPlugWallenten.L,
        rho=dHPlugWallenten.rho,
        H=dHPlugWallenten.H,
        E=dHPlugWallenten.E,
        Do=dHPlugWallenten.Do,
        Di=dHPlugWallenten.Di,
        Dc=dHPlugWallenten.Dc,
        dp_nominal=dHPlugWallenten.dp_nominal,
        m_flow_nominal=dHPlugWallenten.m_flow_nominal,
        lambdaG=dHPlugWallenten.lambdaG,
        lambdaI=dHPlugWallenten.lambdaI,
        lambdaGS=dHPlugWallenten.lambdaGS,
        tau=dHPlugWallenten.tau,
        redeclare DoublePipes.Configurations.TwinPipeGround
          baseConfiguration,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{-10,-22},{10,6}})));
      DoublePipes.DHDeltaCircuit dHDeltaCircuit(
        L=dHPlugWallenten.L,
        rho=dHPlugWallenten.rho,
        H=dHPlugWallenten.H,
        E=dHPlugWallenten.E,
        Do=dHPlugWallenten.Do,
        Di=dHPlugWallenten.Di,
        Dc=dHPlugWallenten.Dc,
        dp_nominal=dHPlugWallenten.dp_nominal,
        m_flow_nominal=dHPlugWallenten.m_flow_nominal,
        lambdaG=dHPlugWallenten.lambdaG,
        lambdaI=dHPlugWallenten.lambdaI,
        lambdaGS=dHPlugWallenten.lambdaGS,
        tau=dHPlugWallenten.tau,
        redeclare DoublePipes.Configurations.TwinPipeGround
          baseConfiguration,
        nSeg=100,
        redeclare package Medium = Annex60.Media.Water)
        annotation (Placement(transformation(extent={{-10,-86},{10,-58}})));
    equation

      connect(fan.port_b, T1PlugIn.port_a) annotation (Line(
          points={{-44,70},{-40,70}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater.port_b,fan. port_a) annotation (Line(
          points={{-68,70},{-64,70}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(const.y,idealHeater1. TSet) annotation (Line(
          points={{50.4,62},{94,62},{94,44},{86,44}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T1PlugOut.port_b, idealHeater1.port_a) annotation (Line(
          points={{42,70},{96,70},{96,38},{84,38}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater1.port_b, T2PlugIn.port_a) annotation (Line(
          points={{64,38},{42,38}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T2PlugOut.port_b, idealHeater.port_a) annotation (Line(
          points={{-40,40},{-92,40},{-92,70},{-88,70}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(fan1.port_b, T1PipeIn.port_a) annotation (Line(
          points={{-44,6},{-40,6}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater2.port_b, fan1.port_a) annotation (Line(
          points={{-68,6},{-64,6}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T1PipeOut.port_b, idealHeater3.port_a) annotation (Line(
          points={{40,6},{64,6}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater3.port_b, T2PipeIn.port_a) annotation (Line(
          points={{84,6},{90,6},{90,-24},{40,-24}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T2PipeOut.port_b, idealHeater2.port_a) annotation (Line(
          points={{-40,-28},{-90,-28},{-90,6},{-88,6}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater2.TSet, idealHeater.TSet) annotation (Line(
          points={{-90,12},{-96,12},{-96,76},{-90,76}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(bou2.ports[1], idealHeater.port_a) annotation (Line(
          points={{-80,44},{-80,40},{-92,40},{-92,70},{-88,70}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(bou1.ports[1], idealHeater2.port_a) annotation (Line(
          points={{-80,-24},{-80,-28},{-90,-28},{-90,6},{-88,6}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T1TROut.port_b, idealHeater5.port_a) annotation (Line(
          points={{40,-56},{62,-56}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater5.port_b, T2TRIn.port_a) annotation (Line(
          points={{82,-56},{88,-56},{88,-86},{40,-86}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(const.y, idealHeater3.TSet) annotation (Line(
          points={{50.4,62},{56,62},{56,12},{62,12}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(idealHeater5.TSet, idealHeater3.TSet) annotation (Line(
          points={{60,-50},{56,-50},{56,12},{62,12}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(fan1.m_flow_in, fan.m_flow_in) annotation (Line(
          points={{-54.2,18},{-54.2,26},{-64,26},{-64,90},{-54.2,90},{-54.2,82}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(fan2.port_b, T1TRIn.port_a) annotation (Line(
          points={{-44,-56},{-40,-56}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(idealHeater4.TSet, idealHeater.TSet) annotation (Line(
          points={{-90,-50},{-96,-50},{-96,76},{-90,76}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T2TROut.port_b, idealHeater4.port_a) annotation (Line(
          points={{-40,-90},{-92,-90},{-92,-56},{-88,-56}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(bou3.ports[1], idealHeater4.port_a) annotation (Line(
          points={{-80,-82},{-80,-90},{-92,-90},{-92,-56},{-88,-56}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(pulse.y, idealHeater.TSet) annotation (Line(
          points={{-94.4,90},{-96,90},{-96,76},{-90,76}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(idealHeater4.port_b, fan2.port_a) annotation (Line(
          points={{-68,-56},{-64,-56}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(fan2.m_flow_in, fan.m_flow_in) annotation (Line(
          points={{-54.2,-44},{-54.2,-34},{-64,-34},{-64,90},{-54.2,90},{-54.2,82}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(pulse1.y, fan.m_flow_in) annotation (Line(
          points={{-71.6,90},{-54.2,90},{-54.2,82}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T1TRIn.port_b, dHDeltaCircuit.port_a1) annotation (Line(
          points={{-20,-56},{-16,-56},{-16,-66},{-10,-66}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T2TROut.port_a, dHDeltaCircuit.port_b2) annotation (Line(
          points={{-20,-90},{-14,-90},{-14,-78},{-10,-78}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(dHDeltaCircuit.port_b1, T1TROut.port_a) annotation (Line(
          points={{10,-66},{16,-66},{16,-56},{20,-56}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(dHDeltaCircuit.port_a2, T2TRIn.port_b) annotation (Line(
          points={{10,-78},{16,-78},{16,-86},{20,-86}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T1PipeIn.port_b, dHPipePlugDelta.port_a1) annotation (Line(
          points={{-20,6},{-16,6},{-16,-2},{-10,-2}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T2PipeOut.port_a, dHPipePlugDelta.port_b2) annotation (Line(
          points={{-20,-28},{-14,-28},{-14,-14},{-10,-14}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(dHPipePlugDelta.port_b1, T1PipeOut.port_a) annotation (Line(
          points={{10,-2},{16,-2},{16,6},{20,6}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(dHPipePlugDelta.port_a2, T2PipeIn.port_b) annotation (Line(
          points={{10,-14},{16,-14},{16,-24},{20,-24}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T1PlugIn.port_b, dHPlugWallenten.port_a1) annotation (Line(
          points={{-20,70},{-18,70},{-18,62},{-10,62}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(T2PlugOut.port_a, dHPlugWallenten.port_b2) annotation (Line(
          points={{-20,40},{-16,40},{-16,50},{-10,50}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(dHPlugWallenten.port_b1, T1PlugOut.port_a) annotation (Line(
          points={{10,62},{16,62},{16,70},{22,70}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(dHPlugWallenten.port_a2, T2PlugIn.port_b) annotation (Line(
          points={{10,50},{14,50},{14,38},{22,38}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(const1.y, dHPlugWallenten.Tg) annotation (Line(
          points={{-7.6,20},{0,20},{0,41.8}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(const1.y, dHPipePlugDelta.Tg) annotation (Line(
          points={{-7.6,20},{14,20},{14,-30},{0,-30},{0,-22.2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(dHDeltaCircuit.Tg, dHPipePlugDelta.Tg) annotation (Line(
          points={{0,-86.2},{0,-94},{14,-94},{14,-30},{0,-30},{0,-22.2}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics),
        experiment(StopTime=200000),
        __Dymola_experimentSetupOutput);
    end TwinPipes;
  end Examples;

  package BaseClasses "Base-classes for the pipe models"
    extends Modelica.Icons.BasesPackage;
    partial model PartialDistrictHeatingPipe
      "Partial model for a district heating pipe. Different configurations are allowed (influence the calculation of the model resistances). Standard IsoPlus pipes added (see PipeConfig) for easy insertion of pipe dimensions."

      //Extensions
      extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState);

      extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(dp_nominal=
            dp_nominal_meter*par.L);

      extends IDEAS.Fluid.Interfaces.PartialFourPortInterface(
        redeclare final package Medium1 = Medium,
        redeclare final package Medium2 = Medium,
        final m1_flow_nominal=m_flow_nominal,
        final m2_flow_nominal=m_flow_nominal,
        final allowFlowReversal1=allowFlowReversal,
        final allowFlowReversal2=allowFlowReversal);

      parameter Modelica.SIunits.Density rho=1000 "Density of the medium";
      parameter Types.PressurePerLength dp_nominal_meter=20
        "Nominal pressure drop/meter over the pipe";

      parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1;
      parameter Boolean allowFlowReversal=false
        annotation (Dialog(tab="Assumptions"), Evaluate=true);

      final parameter Modelica.SIunits.Mass m=Modelica.Constants.pi*par.Di*par.Di/4*par.L*rho;

      parameter Modelica.SIunits.Time tau=120
        "Time constant of the temperature sensors";
      final parameter Real hs=baseConfiguration.hs
        "Heat loss factor for the symmetrical problem";
      final parameter Real ha=baseConfiguration.ha
        "Heat loss factor fot the anti-symmetrical problem";

      final parameter Types.ThermalResistanceLength Rs=1/(2*Modelica.Constants.pi*
          par.lambdaI*hs);
      final parameter Types.ThermalResistanceLength Ra=1/(2*Modelica.Constants.pi*
          par.lambdaI*ha);

      Modelica.SIunits.Power Q1;
      Modelica.SIunits.Power Q2;
      Modelica.SIunits.Power QLosses;

      //Inputs
      Modelica.Blocks.Interfaces.RealInput Tg "Temperature of the ground"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=90,
            origin={0,-142}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=90,
            origin={0,-142})));

      //Components
      inner DistrictHeatingPipeParameters par(redeclare PipeConfig.PipeData dim);
      replaceable DoublePipes.Configurations.TwinPipeSeparate baseConfiguration(
        H=par.H,
        E=par.E,
        Do=par.Do,
        Di=par.Di,
        Dc=par.Dc,
        lambdaG=par.lambdaG,
        lambdaI=par.lambdaI,
        lambdaGS=par.lambdaGS) constrainedby BaseConfiguration(
        H=par.H,
        E=par.E,
        Do=par.Do,
        Di=par.Di,
        Dc=par.Dc,
        lambdaG=par.lambdaG,
        lambdaI=par.lambdaI,
        lambdaGS=par.lambdaGS) annotation (Placement(transformation(extent={{70,108},{90,
                128}})), choicesAllMatching=true);

    equation
      QLosses = Q1 + Q2;

      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}}),
            graphics={
            Rectangle(
              extent={{-100,-20},{100,-100}},
              lineColor={175,175,175},
              fillPattern=FillPattern.Forward,
              fillColor={255,255,255}),
            Rectangle(
              extent={{-100,100},{100,20}},
              lineColor={175,175,175},
              fillPattern=FillPattern.Forward,
              fillColor={255,255,255}),
            Polygon(
              points={{30,18},{60,8},{30,-4},{30,18}},
              smooth=Smooth.None,
              fillColor={255,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              pattern=LinePattern.None,
              lineColor={0,0,0}),
            Polygon(
              points={{30,14},{52,8},{30,0},{30,14}},
              smooth=Smooth.None,
              fillColor={255,255,255},
              fillPattern=FillPattern.HorizontalCylinder,
              pattern=LinePattern.None,
              lineColor={0,0,0}),
            Line(
              points={{-60,8},{56,8}},
              color={255,0,0},
              smooth=Smooth.None),
            Polygon(
              points={{-30,4},{-60,-6},{-30,-18},{-30,4}},
              smooth=Smooth.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.HorizontalCylinder,
              pattern=LinePattern.None,
              lineColor={0,0,0}),
            Polygon(
              points={{-30,0},{-52,-6},{-30,-14},{-30,0}},
              smooth=Smooth.None,
              fillColor={255,255,255},
              fillPattern=FillPattern.HorizontalCylinder,
              pattern=LinePattern.None,
              lineColor={0,0,0}),
            Line(
              points={{60,-6},{-58,-6}},
              color={0,0,255},
              smooth=Smooth.None),
            Rectangle(
              extent={{-100,-30},{100,-90}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={0,127,255}),
            Rectangle(
              extent={{-100,90},{100,30}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={255,128,0})}),
        Diagram(coordinateSystem(extent={{-100,-140},{100,140}},
              preserveAspectRatio=false), graphics),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,
                120}}), graphics));
    end PartialDistrictHeatingPipe;

    model DistrictHeatingPipeParameters

      //Parameters
      parameter Modelica.SIunits.Length L=10 "Total length of the pipe";

      parameter Modelica.SIunits.Length H=2 "Buried depth of the pipe";
      parameter Modelica.SIunits.Length E=dim.E
        "Horizontal distance between pipes";
       parameter Modelica.SIunits.Length Do=dim.Do "Equivalent outer diameter";
       parameter Modelica.SIunits.Length Di=dim.Di "Equivalent inner diameter";
       parameter Modelica.SIunits.Length Dc=dim.Dc
        "Diameter of circumscribing pipe";

      replaceable PipeConfig.PipeData dim constrainedby PipeConfig.PipeData
        "Standard pipe measurements" annotation (choicesAllMatching=true);

      parameter Modelica.SIunits.ThermalConductivity lambdaG=2
        "Thermal conductivity of the ground [W/mK]";
       parameter Modelica.SIunits.ThermalConductivity lambdaI=dim.lambdaI
        "Thermal conductivity of the insulation [W/mK]";
      parameter Modelica.SIunits.ThermalConductivity lambdaGS=14.6
        "Thermal conductivity of the ground surface [W/mK]";

    end DistrictHeatingPipeParameters;

    partial model BaseConfiguration "Base for DH configuration models"

      //Shape factors
      parameter Real hs;
      parameter Real ha;

      extends DistrictHeatingPipeParameters;

      final parameter Real beta = lambdaG/lambdaI*Modelica.Math.log(ro/ri)
        "Dimensionless parameter describing the insulation";

      //Calculated parameters
    protected
      final parameter Modelica.SIunits.Length Heff=H + lambdaG/lambdaGS
        "Corrected depth";
      final parameter Modelica.SIunits.Length ro = Do/2
        "Equivalent outer radius";
      final parameter Modelica.SIunits.Length ri = Di/2
        "Equivalent inner radius";
      final parameter Modelica.SIunits.Length rc = Dc/2 "Circumscribing radius";
      final parameter Modelica.SIunits.Length e = E/2
        "Half the distance between the center of the pipes";

      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), Icon(graphics={Ellipse(
              extent={{-78,-30},{-18,30}},
              lineColor={0,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Ellipse(
              extent={{18,-28},{78,32}},
              lineColor={0,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}));
    end BaseConfiguration;

    model FixedResistanceDpM "Fixed flow resistance with dp and m_flow as parameter, adapted from Buildings 
  library in order to enable calculations with pipe diameter as input"
      extends Buildings.Fluid.BaseClasses.PartialResistance(
        final m_flow_turbulent = if (computeFlowResistance and use_dh) then
                           eta_default*dh/4*Modelica.Constants.pi*ReC
                           elseif (computeFlowResistance) then
                           deltaM * m_flow_nominal_pos
             else 0);
      parameter Boolean use_dh = true
        "Set to true to specify hydraulic diameter"
           annotation(Evaluate=true,
                      Dialog(enable = not linearized));
      parameter Modelica.SIunits.Length dh=1 "Hydraulic diameter"
           annotation(Dialog(enable = use_dh and not linearized));
      parameter Real ReC(min=0)=4000
        "Reynolds number where transition to turbulent starts"
           annotation(Dialog(enable = use_dh and not linearized));
      parameter Real deltaM(min=0.01) = 0.3
        "Fraction of nominal mass flow rate where transition to turbulent occurs"
           annotation(Evaluate=true,
                      Dialog(enable = not use_dh and not linearized));

      final parameter Real k(unit="") = if computeFlowResistance then
            m_flow_nominal_pos / sqrt(dp_nominal_pos) else 0
        "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
    protected
      final parameter Boolean computeFlowResistance=(dp_nominal_pos > Modelica.Constants.eps)
        "Flag to enable/disable computation of flow resistance"
       annotation(Evaluate=true);
    initial equation
     if computeFlowResistance then
       assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
     end if;

     assert(m_flow_nominal_pos > 0, "m_flow_nominal_pos must be non-zero. Check parameters.");
     assert(m_flow_nominal_pos > m_flow_turbulent,
       "In FixedResistanceDpM, m_flow_nominal is smaller than m_flow_turbulent.
  m_flow_nominal = "     + String(m_flow_nominal) + "
  dh      = "     + String(dh) + "
 To correct it, set dh < "     +
         String(     4*m_flow_nominal/eta_default/Modelica.Constants.pi/ReC) + "
  Suggested value:   dh = "     +
                    String(1/10*4*m_flow_nominal/eta_default/Modelica.Constants.pi/ReC),
                    AssertionLevel.warning);

    equation
      // Pressure drop calculation
      if computeFlowResistance then
        if linearized then
          m_flow*m_flow_nominal_pos = k^2*dp;
        else
          if homotopyInitialization then
            if from_dp then
              m_flow=homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k,
                                       m_flow_turbulent=m_flow_turbulent),
                                       simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
            else
              dp=homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k,
                                       m_flow_turbulent=m_flow_turbulent),
                        simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
             end if;  // from_dp
          else // do not use homotopy
            if from_dp then
              m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k,
                                       m_flow_turbulent=m_flow_turbulent);
            else
              dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k,
                                       m_flow_turbulent=m_flow_turbulent);
            end if;  // from_dp
          end if; // homotopyInitialization
        end if; // linearized
      else // do not compute flow resistance
        dp = 0;
      end if;  // computeFlowResistance

      annotation (defaultComponentName="res",
    Documentation(info="<html>
<p>
This is a model of a resistance with a fixed flow coefficient.
The mass flow rate is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775; = k
&radic;<span style=\"text-decoration:overline;\">&Delta;P</span>,
</p>
<p>
where
<i>k</i> is a constant and
<i>&Delta;P</i> is the pressure drop.
The constant <i>k</i> is equal to
<code>k=m_flow_nominal/sqrt(dp_nominal)</code>,
where <code>m_flow_nominal</code> and <code>dp_nominal</code>
are parameters.
In the region
<code>abs(m_flow) &lt; m_flow_turbulent</code>,
the square root is replaced by a differentiable function
with finite slope.
The value of <code>m_flow_turbulent</code> is
computed as follows:
</p>
<ul>
<li>
If the parameter <code>use_dh</code> is <code>false</code>
(the default setting),
the equation
<code>m_flow_turbulent = deltaM * abs(m_flow_nominal)</code>,
where <code>deltaM=0.3</code> and
<code>m_flow_nominal</code> are parameters that can be set by the user.
</li>
<li>
Otherwise, the equation
<code>m_flow_turbulent = eta_nominal*dh/4*&pi;*ReC</code> is used,
where
<code>eta_nominal</code> is the dynamic viscosity, obtained from
the medium model. The parameter
<code>dh</code> is the hydraulic diameter and
<code>ReC=4000</code> is the critical Reynolds number, which both
can be set by the user.
</li>
</ul>
<p>
The figure below shows the pressure drop for the parameters
<code>m_flow_nominal=5</code> kg/s,
<code>dp_nominal=10</code> Pa and
<code>deltaM=0.3</code>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/FixedResistanceDpM.png\"/>
</p>
<p>
If the parameter
<code>show_T</code> is set to <code>true</code>,
then the model will compute the
temperature at its ports. Note that this can lead to state events
when the mass flow rate approaches zero,
which can increase computing time.
</p>
<p>
The parameter <code>from_dp</code> is used to determine
whether the mass flow rate is computed as a function of the
pressure drop (if <code>from_dp=true</code>), or vice versa.
This setting can affect the size of the nonlinear system of equations.
</p>
<p>
If the parameter <code>linearized</code> is set to <code>true</code>,
then the pressure drop is computed as a linear function of the
mass flow rate.
</p>
<p>
Setting <code>allowFlowReversal=false</code> can lead to simpler
equations. However, this should only be set to <code>false</code>
if one can guarantee that the flow never reverses its direction.
This can be difficult to guarantee, as pressure imbalance after
the initialization, or due to medium expansion and contraction,
can lead to reverse flow.
</p>
<h4>Notes</h4>
<p>
For more detailed models that compute the actual flow friction,
models from the package
<a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>
can be used and combined with models from the
<code>Buildings</code> library.
</p>
<h4>Implementation</h4>
<p>
The pressure drop is computed by calling a function in the package
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels\">
Buildings.Fluid.BaseClasses.FlowModels</a>,
This package contains regularized implementations of the equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
and its inverse function.
</p>
<p>
To decouple the energy equation from the mass equations,
the pressure drop is a function of the mass flow rate,
and not the volume flow rate.
This leads to simpler equations.
</p>
</html>",     revisions="<html>
<ul>
<li>
November 26, 2014, by Michael Wetter:<br/>
Added the required <code>annotation(Evaluate=true)</code> so
that the system of nonlinear equations in
<a href=\"modelica://Buildings.Fluid.FixedResistances.Examples.FixedResistancesExplicit\">
Buildings.Fluid.FixedResistances.Examples.FixedResistancesExplicit</a>
remains the same.
</li>
<li>
November 20, 2014, by Michael Wetter:<br/>
Rewrote the warning message using an <code>assert</code> with
<code>AssertionLevel.warning</code>
as this is the proper way to write warnings in Modelica.
</li>
<li>
August 5, 2014, by Michael Wetter:<br/>
Corrected error in documentation of computation of <code>k</code>.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
January 16, 2012 by Michael Wetter:<br/>
To simplify object inheritance tree, revised base classes
<code>Buildings.Fluid.BaseClasses.PartialResistance</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialActuator</code>
and model
<code>Buildings.Fluid.FixedResistances.FixedResistanceDpM</code>.
</li>
<li>
May 30, 2008 by Michael Wetter:<br/>
Added parameters <code>use_dh</code> and <code>deltaM</code> for easier parameterization.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics={Text(
              extent={{-102,86},{-4,22}},
              lineColor={0,0,255},
              textString="dp_nominal=%dp_nominal"), Text(
              extent={{-106,106},{6,60}},
              lineColor={0,0,255},
              textString="m0=%m_flow_nominal")}));
    end FixedResistanceDpM;

    model Pipe
      "Model of a pipe with finite volume discretization along the flow path"
      extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
      extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
      showDesignFlowDirection = false,
      final show_T=true);
      extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
        final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));

      parameter Integer nSeg(min=1) = 10 "Number of volume segments";
      parameter Modelica.SIunits.Length thicknessIns "Thickness of insulation";
      parameter Modelica.SIunits.ThermalConductivity lambdaIns
        "Heat conductivity of insulation";
      parameter Modelica.SIunits.Length diameter
        "Pipe diameter (without insulation)";

      parameter Modelica.SIunits.Length length "Length of the pipe";
      parameter Real ReC=4000
        "Reynolds number where transition to turbulent starts"
        annotation (Dialog(tab="Flow resistance"));

      parameter Boolean homotopyInitialization = true
        "= true, use homotopy method"
        annotation(Evaluate=true, Dialog(tab="Advanced"));

      Buildings.Fluid.FixedResistances.FixedResistanceDpM preDro(
        redeclare final package Medium = Medium,
        final from_dp=from_dp,
        use_dh=true,
        dh=diameter,
        final show_T=show_T,
        final m_flow_nominal=m_flow_nominal,
        final dp_nominal=dp_nominal,
        final allowFlowReversal=allowFlowReversal,
        final linearized=linearizeFlowResistance,
        final ReC=ReC,
        final homotopyInitialization=homotopyInitialization) "Flow resistance"
        annotation (Placement(transformation(extent={{20,-10},{40,10}})));
      Buildings.Fluid.MixingVolumes.MixingVolume[nSeg] vol(
        redeclare each final package Medium = Medium,
        each energyDynamics=energyDynamics,
        each massDynamics=massDynamics,
        each final V=VPipe/nSeg,
        each nPorts=2,
        each final m_flow_nominal=m_flow_nominal,
        each prescribedHeatFlowRate=true,
        each p_start=p_start,
        each T_start=T_start,
        each X_start=X_start,
        each C_start=C_start,
        each C_nominal=C_nominal,
        each final m_flow_small=m_flow_small,
        each final allowFlowReversal=allowFlowReversal) "Volume for pipe fluid"
                                                      annotation (Placement(
            transformation(extent={{53,-20},{73,-40}})));

    protected
      parameter Modelica.SIunits.Volume VPipe=Modelica.Constants.pi*(diameter/2.0)^
          2*length "Pipe volume";
      parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
          T=Medium.T_default,
          p=Medium.p_default,
          X=Medium.X_default[1:Medium.nXi]) "Default state";
      parameter Modelica.SIunits.Density rho_default = Medium.density(state_default);
      parameter Modelica.SIunits.DynamicViscosity mu_default = Medium.dynamicViscosity(state_default)
        "Dynamic viscosity at nominal condition";
    equation
      connect(port_a, preDro.port_a) annotation (Line(
          points={{-100,5.55112e-016},{-72,5.55112e-016},{-72,1.16573e-015},{-58,
              1.16573e-015},{-58,0},{20,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(preDro.port_b, vol[1].ports[1]) annotation (Line(
          points={{40,0},{61,0},{61,-20}},
          color={0,127,255},
          smooth=Smooth.None));
      if nSeg > 1 then
        for i in 1:(nSeg - 1) loop
          connect(vol[i].ports[2], vol[i + 1].ports[1]);
        end for;
      end if;
      connect(vol[nSeg].ports[2], port_b) annotation (Line(
          points={{65,-20},{66,-20},{66,0},{100,0}},
          color={0,127,255},
          smooth=Smooth.None));
      annotation (
        Icon(graphics={
            Rectangle(
              extent={{-100,60},{100,-60}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={192,192,192}),
            Rectangle(
              extent={{-100,50},{100,-48}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={217,236,256}),
            Text(
              extent={{-42,12},{40,-12}},
              lineColor={0,0,0},
              textString="%nSeg")}),
        Documentation(info="<html>
<p>
Model of a pipe with flow resistance and optional heat storage.
This model can be used for modeling the heat exchange between the pipe and environment.
The model consists of a flow resistance
<a href=\"modelica://Buildings.Fluid.FixedResistances.FixedResistanceDpM\">
Buildings.Fluid.FixedResistances.FixedResistanceDpM</a>
and <code>nSeg</code> mixing volumes
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>.
</p>
</html>",     revisions="<html>
<ul>
<li>
February 5, 2015, by Michael Wetter:<br/>
Renamed <code>res</code> to <code>preDro</code> for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/292\">#292</a>.
</li>
<li>
October 10, 2014, by Michael Wetter:<br/>
Changed minimum attribute for <code>nSeg</code> from 2 to 1.
This is required for the radiant slab model.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
September 13, 2013 by Michael Wetter:<br/>
Replaced <code>nominal</code> with <code>default</code> values
as they are computed using the default Medium values.
</li>
<li>
February 15, 2012 by Michael Wetter:<br/>
Changed base class from which the model extends.
Propagated parameters of volume to the top if this model.
</li>
<li>
February 12, 2012 by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
    end Pipe;

    model ExponentialDecay "Calculates decay in temperature for given inlet, delay and boundary conditions 
  for a single pipe"
      /* Tb is a generic boundary temperature. For one single pipe, this will be the ambient temperature.
  To account for the presence of a second pipe, Tb will be a combination of the ambient temperature
  and the temperature of the other pipe (average pipe temperature over its length). However,
  in this case calculation with TwinExponentialDecay is advisable to calculate a more accurate
  temperature change. */

      parameter Real C;
      parameter Real R;

      final parameter Real tau=R*C;

      Modelica.Blocks.Interfaces.RealInput TIn
        "Inlet temperature at time t-delay"
        annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
      Modelica.Blocks.Interfaces.RealInput td
        "Delay time for current package of fluid"
        annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
      Modelica.Blocks.Interfaces.RealInput Tb
        "Boundary temperature - Fluid would cool down to this temperature if it were to stay long enough in pipe"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=270,
            origin={0,120})));
      Modelica.Blocks.Interfaces.RealOutput TOut "Oulet temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));

    equation
      TOut = Tb + (TIn - Tb)*Modelica.Math.exp(-td/tau);

        annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), Icon(coordinateSystem(
              preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                    Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
            Text(
              extent={{-60,140},{60,100}},
              lineColor={0,0,255},
              textString="%name"),
            Line(
              points={{-80,82},{-80,-78}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(
              points={{-80,-78},{80,-78}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(
              points={{-90,62},{-80,82},{-70,62}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(
              points={{-10,-10},{0,10},{10,-10}},
              color={0,0,0},
              smooth=Smooth.None,
              origin={70,-78},
              rotation=270),
            Line(
              points={{-80,60},{-34,-56},{52,-60}},
              color={255,128,0},
              smooth=Smooth.Bezier),
            Text(
              extent={{-50,86},{86,16}},
              lineColor={0,0,255},
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid,
              textString="exp(-t/tau)")}));
    end ExponentialDecay;

    model TwinExponentialDecay "Calculates decay in temperature for given inlet, delay and boundary conditions. 
  Calculation based on coupled calculation for two pipes, integrating Wallentén's 
  equations over the length of the pipes"

      //Parameters
      parameter Real C;
      parameter Real Ra;
      parameter Real Rs;

      final parameter Real tau=C*sqrt(Ra*Rs);

      //Variables
      Real lambda;

      Modelica.Blocks.Interfaces.RealInput T1
        "Inlet temperature at time t-delay"
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-120,-20})));
      Modelica.Blocks.Interfaces.RealInput td
        "Delay time for current package of fluid"
        annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
      Modelica.Blocks.Interfaces.RealInput Tb
        "Boundary temperature - Fluid would cool down to this temperature if it were to stay long enough in pipe"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-120,40})));
      Modelica.Blocks.Interfaces.RealOutput T1Out "Oulet temperature"
        annotation (Placement(transformation(extent={{100,30},{120,50}})));

      Modelica.Blocks.Interfaces.RealInput T2
        "Inlet temperature at time t-delay"
        annotation (Placement(transformation(extent={{20,-20},{-20,20}},
            rotation=180,
            origin={-120,-60})));
      Modelica.Blocks.Interfaces.RealOutput T2Out "Oulet temperature"
        annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
    equation
      lambda = Modelica.Math.exp(td/tau);

      T1Out = (
        Tb*((2*sqrt(Ra*Rs)+2*Ra)*lambda^2-4*lambda*sqrt(Ra*Rs)+2*sqrt(Ra*Rs)-2*Ra)
        + 4*lambda*sqrt(Ra*Rs)*T1
        + T2*((Rs-Ra)*lambda^2+Ra-Rs))
       /((2*sqrt(Ra*Rs)+Ra+Rs)*lambda^2+2*sqrt(Ra*Rs)-Ra-Rs);

      T2Out = (
        Tb*((2*sqrt(Ra*Rs)+2*Ra)*lambda^2-4*lambda*sqrt(Ra*Rs)+2*sqrt(Ra*Rs)-2*Ra)
        + 4*lambda*sqrt(Ra*Rs)*T2
        + T1*((Rs-Ra)*lambda^2+Ra-Rs))
       /((2*sqrt(Ra*Rs)+Ra+Rs)*lambda^2+2*sqrt(Ra*Rs)-Ra-Rs);

        annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), Icon(coordinateSystem(
              preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                    Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
            Text(
              extent={{-60,140},{60,100}},
              lineColor={0,0,255},
              textString="%name"),
            Line(
              points={{-80,82},{-80,-78}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(
              points={{-80,-78},{80,-78}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(
              points={{-90,62},{-80,82},{-70,62}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(
              points={{-10,-10},{0,10},{10,-10}},
              color={0,0,0},
              smooth=Smooth.None,
              origin={70,-78},
              rotation=270),
            Line(
              points={{-80,60},{-34,-56},{52,-60}},
              color={255,128,0},
              smooth=Smooth.Bezier),
            Line(
              points={{66,60},{20,-56},{-66,-60}},
              color={255,128,0},
              smooth=Smooth.Bezier,
              origin={-14,2},
              rotation=360)}));
    end TwinExponentialDecay;

    package PipeConfig
      "Contains different configuration records of district heating pipes"

      record PipeData "Contains pipe properties from catalogs"

         parameter Modelica.SIunits.Length Di=0.1 "Equivalent inner diameter";
         parameter Modelica.SIunits.Length Do=Di "Equivalent outer diameter";

         parameter Modelica.SIunits.Length h=Di
          "Horizontal distance between pipe walls";
         parameter Modelica.SIunits.Length Dc=2.5*Di
          "Diameter of circumscribing pipe";

        final parameter Modelica.SIunits.Length E=h + Di
          "Horizontal distance between pipe centers";

         parameter Modelica.SIunits.ThermalConductivity lambdaI=0.026
          "Thermal conductivity of pipe insulation material";

      end PipeData;

      package IsoPlusDoubleStandard "IsoPlus standard double pipes"

        record IsoPlusDR20S "Standard DN 20 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            Di=20e-3,
            Do=26.9e-3,
            h=20e-3,
            Dc=125e-3);
        end IsoPlusDR20S;

        record IsoPlusDR25S "Standard DN 25 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=20e-3,
            Di=25e-3,
            Do=33.7e-3,
            Dc=140e-3);
        end IsoPlusDR25S;

        record IsoPlusDR32S "Standard DN 32 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=20e-3,
            Di=32e-3,
            Do=42.4e-3,
            Dc=160e-3);
        end IsoPlusDR32S;

        record IsoPlusDR40S "Standard DN 40 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=20e-3,
            Di=40e-3,
            Do=48.3e-3,
            Dc=160e-3);
        end IsoPlusDR40S;

        record IsoPlusDR50S "Standard DN 50 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=20e-3,
            Di=50e-3,
            Do=60.3e-3,
            Dc=200e-3);
        end IsoPlusDR50S;

        record IsoPlusDR65S "Standard DN 65 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=20e-3,
            Di=65e-3,
            Do=76.1e-3,
            Dc=225e-3);
        end IsoPlusDR65S;

        record IsoPlusDR80S "Standard DN 80 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            Di=80e-3,
            Do=88.9e-3,
            h=25e-3,
            Dc=250e-3);
        end IsoPlusDR80S;

        record IsoPlusDR100S "Standard DN 100 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=25e-3,
            Di=100e-3,
            Do=114.3e-3,
            Dc=315e-3);
        end IsoPlusDR100S;

        record IsoPlusDR125S "Standard DN 125 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            Di=125e-3,
            Do=139.7e-3,
            h=30e-3,
            Dc=400e-3);
        end IsoPlusDR125S;

        record IsoPlusDR150S "Standard DN 150 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            Di=150e-3,
            Do=168.3e-3,
            h=40e-3,
            Dc=450e-3);
        end IsoPlusDR150S;

        record IsoPlusDR200S "Standard DN 200 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            Di=200e-3,
            Do=219.1e-3,
            h=45e-3,
            Dc=560e-3);
        end IsoPlusDR200S;
      end IsoPlusDoubleStandard;

      package IsoPlusDoubleReinforced "IsoPlus reinforced double pipes"

        record IsoPlusDR20S "Reinforced DN 20 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            Di=20e-3,
            Do=26.9e-3,
            h=20e-3,
            Dc=140e-3);
        end IsoPlusDR20S;

        record IsoPlusDR25S "Reinforced DN 25 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=20e-3,
            Di=25e-3,
            Do=33.7e-3,
            Dc=160e-3);
        end IsoPlusDR25S;

        record IsoPlusDR32S "Reinforced DN 32 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=20e-3,
            Di=32e-3,
            Do=42.4e-3,
            Dc=180e-3);
        end IsoPlusDR32S;

        record IsoPlusDR40S "Reinforced DN 40 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=20e-3,
            Di=40e-3,
            Do=48.3e-3,
            Dc=180e-3);
        end IsoPlusDR40S;

        record IsoPlusDR50S "Reinforced DN 50 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=20e-3,
            Di=50e-3,
            Do=60.3e-3,
            Dc=225e-3);
        end IsoPlusDR50S;

        record IsoPlusDR65S "Reinforced DN 65 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=20e-3,
            Di=65e-3,
            Do=76.1e-3,
            Dc=250e-3);
        end IsoPlusDR65S;

        record IsoPlusDR80S "Reinforced DN 80 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            Di=80e-3,
            Do=88.9e-3,
            h=25e-3,
            Dc=280e-3);
        end IsoPlusDR80S;

        record IsoPlusDR100S "Reinforced DN 100 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            h=25e-3,
            Di=100e-3,
            Do=114.3e-3,
            Dc=355e-3);
        end IsoPlusDR100S;

        record IsoPlusDR125S "Reinforced DN 125 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            Di=125e-3,
            Do=139.7e-3,
            h=30e-3,
            Dc=450e-3);
        end IsoPlusDR125S;

        record IsoPlusDR150S "Reinforced DN 150 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            Di=150e-3,
            Do=168.3e-3,
            h=40e-3,
            Dc=500e-3);
        end IsoPlusDR150S;

        record IsoPlusDR200S "Reinforced DN 200 IsoPlus double pipe"
          import DistrictHeating;
          extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
            Di=200e-3,
            Do=219.1e-3,
            h=45e-3,
            Dc=630e-3);
        end IsoPlusDR200S;
      end IsoPlusDoubleReinforced;

      partial record IsoPlusDouble "IsoPlus double pipes"
        extends PipeData(lambdaI=0.0275);
      end IsoPlusDouble;
    end PipeConfig;
  end BaseClasses;

  package Types
    type ThermalResistanceLength = Real (final quantity="ThermalResistanceLength", final unit=
               "(m.K)/W");
    type PressurePerLength =
                          Real (
        final quantity="PressurePerLength",
        final unit="Pa/m");
    type PowerPerLength =
      Real (final quantity="PowerPerLength",
        final unit="W/m");
  end Types;
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          fillPattern=FillPattern.None,
          extent={{-100,-100},{100,100}},
          radius=25.0),
      Ellipse(
        extent={{-62,40},{-42,-40}},
        lineColor={0,0,0},
        fillPattern=FillPattern.Solid,
        fillColor={175,175,175}),
      Line(
        points={{-52,40},{60,40}},
        color={0,0,0},
        smooth=Smooth.None),
      Ellipse(
        extent={{50,40},{70,-40}},
        lineColor={0,0,0},
        fillPattern=FillPattern.Solid,
        fillColor={0,0,255}),
      Line(
        points={{-52,-40},{60,-40}},
        color={0,0,0},
        smooth=Smooth.None)}));
end PipesKUL;
