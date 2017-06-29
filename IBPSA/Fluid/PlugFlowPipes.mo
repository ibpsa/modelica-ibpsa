within IBPSA.Fluid;
package PlugFlowPipes
  "Plug flow pipe models that can be used in district heating and cooling networks"
  model PlugFlowPipe
    "Pipe model using spatialDistribution for temperature delay with modified delay tracker"
    extends IBPSA.Fluid.Interfaces.PartialTwoPort_vector;
    parameter Modelica.SIunits.Diameter diameter "Pipe diameter";
    parameter Modelica.SIunits.Length length "Pipe length";
    parameter Modelica.SIunits.Length thicknessIns "Thickness of pipe insulation";

    /*parameter Modelica.SIunits.ThermalConductivity k = 0.005 
    "Heat conductivity of pipe's surroundings";*/

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
      "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

    parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
      m_flow_nominal) "Small mass flow rate for regularization of zero flow"
      annotation (Dialog(tab="Advanced"));

    parameter Modelica.SIunits.Height roughness=2.5e-5
      "Average height of surface asperities (default: smooth steel pipe)"
      annotation (Dialog(group="Geometry"));

    parameter Fluid.PlugFlowPipes.Types.ThermalResistanceLength R=1/(lambdaI*2*
        Modelica.Constants.pi/Modelica.Math.log((diameter/2 + thicknessIns)/(
        diameter/2)));
    parameter Fluid.PlugFlowPipes.Types.ThermalCapacityPerLength C=rho_default*
        Modelica.Constants.pi*(diameter/2)^2*cp_default;
    parameter Modelica.SIunits.ThermalConductivity lambdaI=0.026
      "Heat conductivity";

    parameter Modelica.SIunits.HeatCapacity walCap=length*((diameter + 2*
        thickness)^2 - diameter^2)*Modelica.Constants.pi/4*cpipe*rho_wall
      "Heat capacity of pipe wall";
    parameter Modelica.SIunits.SpecificHeatCapacity cpipe=500 "For steel";
    parameter Modelica.SIunits.Density rho_wall=8000 "For steel";
    final parameter Modelica.SIunits.Volume V=walCap/(rho_default*cp_default)
      "Equivalent water volume to represent pipe wall thermal inertia";

    // fixme: shouldn't dp(nominal) be around 100 Pa/m?
    // fixme: propagate use_dh and set default to false

  protected
    parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
        T=Medium.T_default,
        p=Medium.p_default,
        X=Medium.X_default) "Default medium state";

    parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
        p=Medium.p_default,
        T=Medium.T_default,
        X=Medium.X_default)
      "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
      annotation (Dialog(group="Advanced"));

  //   parameter Modelica.SIunits.DynamicViscosity mu_default=
  //       Medium.dynamicViscosity(Medium.setState_pTX(
  //       p=Medium.p_default,
  //       T=Medium.T_default,
  //       X=Medium.X_default))
  //     "Default dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
  //     annotation (Dialog(group="Advanced", enable=use_mu_default));

    parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
        Medium.specificHeatCapacityCp(state=sta_default)
      "Heat capacity of medium";

  public
    Fluid.PlugFlowPipes.BaseClasses.PipeCore pipeCore(
      redeclare package Medium = Medium,
      diameter=diameter,
      length=length,
      thicknessIns=thicknessIns,
      C=C,
      R=R,
      m_flow_small=m_flow_small,
      m_flow_nominal=m_flow_nominal,
      T_ini_in=T_ini_in,
      T_ini_out=T_ini_out,
      m_flowInit=m_flowInit,
      initDelay=initDelay) "Describing the pipe behavior"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
      annotation (Placement(transformation(extent={{-10,90},{10,110}})));

    parameter Boolean from_dp=false
      "= true, use m_flow = f(dp) else dp = f(m_flow)"
      annotation (Evaluate=true, Dialog(tab="Advanced"));
    parameter Modelica.SIunits.Length thickness=0.002 "Pipe wall thickness";

    parameter Modelica.SIunits.Temperature T_ini_in=Medium.T_default
      "Initialization temperature at pipe inlet"
      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature T_ini_out=Medium.T_default
      "Initialization temperature at pipe outlet"
      annotation (Dialog(tab="Initialization"));
    parameter Boolean initDelay=false
      "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.MassFlowRate m_flowInit=0
      annotation (Dialog(tab="Initialization", enable=initDelay));

    Fluid.MixingVolumes.MixingVolume vol(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      V=V,
      nPorts=nPorts+1,
      T_start=T_ini_out)
      annotation (Placement(transformation(extent={{60,20},{80,40}})));
  equation

    connect(pipeCore.heatPort, heatPort) annotation (Line(points={{0,10},{0,10},{
            0,100}},         color={191,0,0}));

    connect(pipeCore.port_b, vol.ports[1])
      annotation (Line(points={{10,0},{70,0},{70,20}}, color={0,127,255}));
      for i in 1:nPorts loop
        connect(vol.ports[i+1], ports_b[i]);
      end for
      annotation (Line(points={{70,20},{72,20},{72,6},{72,
            0},{100,0}}, color={0,127,255}));
    connect(pipeCore.port_a, port_a)
      annotation (Line(points={{-10,0},{-56,0},{-100,0}},
                                                  color={0,127,255}));
    annotation (
      Line(points={{70,20},{72,20},{72,0},{100,0}}, color={0,127,255}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})),
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
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
            extent={{-100,50},{100,40}},
            lineColor={175,175,175},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward),
          Rectangle(
            extent={{-100,-40},{100,-50}},
            lineColor={175,175,175},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward),
          Polygon(
            points={{0,100},{40,62},{20,62},{20,38},{-20,38},{-20,62},{-40,62},{0,
                100}},
            lineColor={0,0,0},
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-30,30},{28,-30}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={215,202,187})}),
      Documentation(revisions="<html>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">July 4, 2016 by Bram van der Heijde:<br>Introduce <code></span><span style=\"font-family: Courier New,courier;\">pipVol</code></span><span style=\"font-family: MS Shell Dlg 2;\">.</span></li>
<li>October 10, 2015 by Marcus Fuchs:<br>Copy Icon from KUL implementation and rename model; Replace resistance and temperature delay by an adiabatic pipe; </li>
<li>September, 2015 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>",   info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Implementation of a pipe with heat loss using the time delay based heat losses and the spatialDistribution operator for the temperature wave propagation through the length of the pipe. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The heat loss component adds a heat loss in design direction, and leaves the enthalpy unchanged in opposite flow direction. Therefore it is used in front of and behind the time delay. The delay time is calculated once on the pipe level and supplied to both heat loss operators. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This component uses a modified delay operator.</span></p>
</html>"));
  end PlugFlowPipe;
  extends Modelica.Icons.VariantsPackage;
  package BaseClasses
    extends Modelica.Icons.BasesPackage;
    model HeatLossPipeDelay
      "Heat loss model for pipe with delay as an input variable"
      extends Fluid.Interfaces.PartialTwoPortTransport;

      parameter Modelica.SIunits.Diameter diameter "Pipe diameter";
      parameter Modelica.SIunits.Length length "Pipe length";

      parameter Modelica.SIunits.Area A_cross=Modelica.Constants.pi*diameter*
          diameter/4 "Cross sectional area";

      parameter Fluid.PlugFlowPipes.Types.ThermalCapacityPerLength C;
      parameter Fluid.PlugFlowPipes.Types.ThermalResistanceLength R;
      final parameter Modelica.SIunits.Time tau_char=R*C;

      Modelica.SIunits.Temp_K Tin_a(start=T_ini) "Temperature at port_a for in-flowing fluid";
      Modelica.SIunits.Temp_K Tout_b(start=T_ini) "Temperature at port_b for out-flowing fluid";
      Modelica.SIunits.Temperature T_amb=heatPort.T "Environment temperature";
      Modelica.SIunits.HeatFlowRate Qloss "Heat losses from pipe to environment";
      Modelica.SIunits.EnthalpyFlowRate portA=inStream(port_a.h_outflow);
      Modelica.SIunits.EnthalpyFlowRate portB=inStream(port_b.h_outflow);

    protected
      parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
          T=Medium.T_default,
          p=Medium.p_default,
          X=Medium.X_default) "Default medium state";
      parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
          Medium.specificHeatCapacityCp(state=sta_default)
        "Heat capacity of medium";

    public
      Modelica.Blocks.Interfaces.RealInput tau(unit="s") "Time delay at pipe level"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=270,
            origin={-60,100})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
        "Heat port to connect environment"
        annotation (Placement(transformation(extent={{-10,90},{10,110}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatLoss annotation (
         Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,38})));
      Modelica.Blocks.Sources.RealExpression realExpression(y=Qloss)
        annotation (Placement(transformation(extent={{-34,-10},{-14,10}})));
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5;
      parameter Modelica.Media.Interfaces.Types.Temperature T_ini=Medium.T_default
        "Initial output temperature";
    equation
      dp = 0;

      port_a.h_outflow = inStream(port_b.h_outflow);
      port_b.h_outflow = Medium.specificEnthalpy_pTX(
        port_a.p,
        Tout_b,
        inStream(port_a.Xi_outflow)) "Calculate enthalpy of output state";

      Tin_a = Medium.temperature_phX(
        port_a.p,
        inStream(port_a.h_outflow),
        inStream(port_a.Xi_outflow));

      // Heat losses
      Tout_b = T_amb + (Tin_a - T_amb)*Modelica.Math.exp(-tau/tau_char);
      Qloss = IBPSA.Utilities.Math.Functions.spliceFunction(
        pos= (Tin_a-Tout_b)*cp_default,
        neg= 0,
        x= port_a.m_flow,
        deltax= m_flow_nominal/1000)  *port_a.m_flow;

      connect(heatLoss.port, heatPort)
        annotation (Line(points={{0,48},{0,100}}, color={191,0,0}));
      connect(realExpression.y, heatLoss.Q_flow)
        annotation (Line(points={{-13,0},{-6,0},{0,0},{0,28}}, color={0,0,127}));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics={
            Rectangle(
              extent={{-80,80},{80,-68}},
              lineColor={255,255,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-52,2},{42,2},{42,8},{66,0},{42,-8},{42,-2},{-52,-2},{-52,2}},
              lineColor={0,128,255},
              fillPattern=FillPattern.Solid,
              fillColor={170,213,255}),
            Polygon(
              points={{0,60},{38,2},{20,2},{20,-46},{-18,-46},{-18,2},{-36,2},{0,60}},
              lineColor={0,0,0},
              fillColor={238,46,47},
              fillPattern=FillPattern.Solid)}),
        Documentation(info="<html>
<p>Heat losses are only considered in design direction. For heat loss consideration in both directions use one of these models at both ends of a <code><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow</span></code> model.</p>
<p>This component requires the delay time and the instantaneous ambient temperature as an input. This component is to be used in single pipes or in more advanced configurations where no influence from other pipes is considered. </p>
</html>",     revisions="<html>
<ul>
<li>November 6, 2015 by Bram van der Heijde:<br>Make time delay input instead of calculation inside this model. </li>
<li>September, 2015 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}})));
    end HeatLossPipeDelay;

    model TimeDelay "Delay time for given normalized velocity"

      Modelica.Blocks.Interfaces.RealInput m_flow "Mass flow of fluid" annotation (
          Placement(transformation(extent={{-140,-20},{-100,20}}),
            iconTransformation(extent={{-140,-20},{-100,20}})));
      parameter Modelica.SIunits.Length length "Pipe length";
      parameter Modelica.SIunits.Length diameter=0.05 "diameter of pipe";
      parameter Modelica.SIunits.Density rho=1000 "Standard density of fluid";
      parameter Boolean initDelay=false
        "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
        annotation (Dialog(group="Initialization"));
      parameter Modelica.SIunits.Time time0=0 "Start time of simulation";
      parameter Modelica.SIunits.MassFlowRate m_flowInit=0
        annotation (Dialog(group="Initialization", enable=initDelay));

      final parameter Modelica.SIunits.Time tInStart= if initDelay then min(length/
          m_flowInit*(rho*diameter^2/4*Modelica.Constants.pi),0) else 0
        "Initial value of input time at inlet";
      final parameter Modelica.SIunits.Time tOutStart=if initDelay then min(-length/
          m_flowInit*(rho*diameter^2/4*Modelica.Constants.pi),0) else 0
        "Initial value of input time at outlet";

      Modelica.SIunits.Time time_out_rev "Reverse flow direction output time";
      Modelica.SIunits.Time time_out_des "Design flow direction output time";

      Real x(start=0) "Spatial coordinate for spatialDistribution operator";
      Modelica.SIunits.Frequency u "Normalized fluid velocity (1/s)";
      Modelica.Blocks.Interfaces.RealOutput tau
        "Time delay for design flow direction"
        annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
      Modelica.Blocks.Interfaces.RealOutput tauRev "Time delay for reverse flow"
        annotation (Placement(transformation(extent={{100,30},{120,50}})));

      parameter Real epsilon=1e-10;

    equation
      u = m_flow/(rho*(diameter^2)/4*Modelica.Constants.pi)/length;

      der(x) = u;
      (time_out_rev,time_out_des) = spatialDistribution(
        time,
        time,
        x,
        u >= 0,
        {0.0,1.0},
        {time + tInStart,time + tOutStart});

      tau = time - time_out_des;
      tauRev = time - time_out_rev;

      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}})),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics={
            Rectangle(
              extent={{-100,-100},{100,100}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-92,0},{-80.7,34.2},{-73.5,53.1},{-67.1,66.4},{-61.4,74.6},{-55.8,
                  79.1},{-50.2,79.8},{-44.6,76.6},{-38.9,69.7},{-33.3,59.4},{-26.9,44.1},
                  {-18.83,21.2},{-1.9,-30.8},{5.3,-50.2},{11.7,-64.2},{17.3,-73.1},{
                  23,-78.4},{28.6,-80},{34.2,-77.6},{39.9,-71.5},{45.5,-61.9},{51.9,
                  -47.2},{60,-24.8},{68,0}},
              color={0,0,127},
              smooth=Smooth.Bezier),
            Line(points={{-64,0},{-52.7,34.2},{-45.5,53.1},{-39.1,66.4},{-33.4,74.6},
                  {-27.8,79.1},{-22.2,79.8},{-16.6,76.6},{-10.9,69.7},{-5.3,59.4},{1.1,
                  44.1},{9.17,21.2},{26.1,-30.8},{33.3,-50.2},{39.7,-64.2},{45.3,-73.1},
                  {51,-78.4},{56.6,-80},{62.2,-77.6},{67.9,-71.5},{73.5,-61.9},{79.9,
                  -47.2},{88,-24.8},{96,0}}, smooth=Smooth.Bezier),
            Text(
              extent={{20,100},{82,30}},
              lineColor={0,0,255},
              textString="PDE"),
            Text(
              extent={{-82,-30},{-20,-100}},
              lineColor={0,0,255},
              textString="tau"),
            Text(
              extent={{-60,140},{60,100}},
              lineColor={0,0,255},
              textString="%name")}),
        Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Calculates time delay as the difference between the current simulation time and the inlet time. The inlet time is propagated with the corresponding fluid parcel using the spatialDistribution function. Calculates time delay as the difference between the current simulation time and the inlet time. The inlet time is propagated with the corresponding fluid parcel using the spatialDistribution function. This components requires the mass flow through (one of) the pipe(s) and the pipe dimensions in order to derive information about the fluid propagation. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This component has a different handling of zero flow periods in order to prevent glitches in the output delay time. </span></p>
</html>",     revisions="<html>
<ul>
<li>September 9, 2016 by Bram van der Heijde:</li>
<p>Rename from PDETime_massFlowMod to TimeDelayMod</p>
<li><span style=\"font-family: MS Shell Dlg 2;\">December 2015 by Carles Ribas Tugores:<br>Modification in delay calculation to fix issues.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">November 6, 2015 by Bram van der Heijde:<br>Adapted flow parameter to mass flow rate instead of velocity. This change should also fix the reverse and zero flow issues.</span></li>
<li>October 13, 2015 by Marcus Fuchs:<br>Use <code>abs()</code> of normalized velocity input in order to avoid negative delay times. </li>
<li>July 2015 by Arnout Aertgeerts:<br>First implementation. </li>
</ul>
</html>"));
    end TimeDelay;

    model PipeLosslessPlugFlow
      "Lossless pipe model with spatialDistribution plug flow implementation"
      extends IBPSA.Fluid.Interfaces.PartialTwoPort;

      parameter Real initialPoints[:](each min=0, each max=1) = {0.0, 1.0}
        "Initial points for spatialDistribution";
        // fixme: use T_start[:] and propagate to top level, then use it to assign h_start (or initialValuesH)
      parameter Modelica.SIunits.SpecificEnthalpy initialValuesH[:]=
         {Medium.h_default, Medium.h_default}
        "Inital enthalpy values for spatialDistribution";

      parameter Modelica.SIunits.Diameter D "Pipe diameter"; // fixme call it diameter
      parameter Modelica.SIunits.Length L "Pipe length";   // fixme: call it lenghth
      final parameter Modelica.SIunits.Area A = Modelica.Constants.pi * (D/2)^2
        "Cross-sectional area of pipe";

      // Advanced
      // Note: value of dp_start shall be refined by derived model,
      // based on local dp_nominal
      parameter Medium.AbsolutePressure dp_start = 0
        "Guess value of dp = port_a.p - port_b.p"
        annotation(Dialog(tab = "Advanced"));
      parameter Medium.MassFlowRate m_flow_start = 0
        "Guess value of m_flow = port_a.m_flow"
        annotation(Dialog(tab = "Advanced"));
      // Note: value of m_flow_small shall be refined by derived model,
      // based on local m_flow_nominal
      parameter Medium.MassFlowRate m_flow_small
        "Small mass flow rate for regularization of zero flow"
        annotation(Dialog(tab = "Advanced"));

      // Diagnostics
      parameter Boolean show_T = true
        "= true, if temperatures at port_a and port_b are computed"
        annotation(Dialog(tab="Advanced",group="Diagnostics"));

      Modelica.SIunits.Length x(start=0)
        "Spatial coordiante for spatialDistribution operator";
      Modelica.SIunits.Velocity v "Flow velocity of medium in pipe";

      // Variables
      Medium.MassFlowRate m_flow(
         min=if allowFlowReversal then -Modelica.Constants.inf else 0,
         start = m_flow_start) "Mass flow rate in design flow direction";
      Modelica.SIunits.Pressure dp(start=dp_start)
        "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";

      Modelica.SIunits.VolumeFlowRate V_flow=
          m_flow/Modelica.Fluid.Utilities.regStep(m_flow,
                      Medium.density(
                        Medium.setState_phX(
                          p = port_a.p,
                          h = inStream(port_a.h_outflow),
                          X = inStream(port_a.Xi_outflow))),
                      Medium.density(
                           Medium.setState_phX(
                             p = port_b.p,
                             h = inStream(port_b.h_outflow),
                             X = inStream(port_b.Xi_outflow))),
                      m_flow_small)
        "Volume flow rate at inflowing port (positive when flow from port_a to port_b)";

      Medium.Temperature port_a_T=
          Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                      Medium.temperature(
                        Medium.setState_phX(
                          p = port_a.p,
                          h = inStream(port_a.h_outflow),
                          X = inStream(port_a.Xi_outflow))),
                      Medium.temperature(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow)),
                      m_flow_small) if show_T
        "Temperature close to port_a, if show_T = true";
      Medium.Temperature port_b_T=
          Modelica.Fluid.Utilities.regStep(port_b.m_flow,
                      Medium.temperature(
                        Medium.setState_phX(
                          p = port_b.p,
                          h = inStream(port_b.h_outflow),
                          X = inStream(port_b.Xi_outflow))),
                      Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow)),
                      m_flow_small) if show_T
        "Temperature close to port_b, if show_T = true";

    protected
      parameter Modelica.SIunits.SpecificEnthalpy h_default=Medium.specificEnthalpy(sta_default)
        "Specific enthalpy";
      parameter Medium.ThermodynamicState sta_default=
         Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
    equation
      // Pressure drop in design flow direction
      dp = port_a.p - port_b.p;
      dp = 0;

      // Design direction of mass flow rate
      m_flow = port_a.m_flow;
      assert(m_flow > -m_flow_small or allowFlowReversal,
          "Reverting flow occurs even though allowFlowReversal is false");

      // Mass balance (no storage)
      port_a.m_flow + port_b.m_flow = 0;

      der(x) = v;
      v = V_flow / A;

      // fixme: this also need to be applied on Xi_outflow and C_outflow.
      // Otherwise, for air, it can give wrong temperatures at the outlet.
      // To assign Xi_outflow and C_outflow, you will need to use IBPSA.Fluid.Interfaces.PartialTwoPort
      (port_a.h_outflow,
       port_b.h_outflow) = spatialDistribution(inStream(port_a.h_outflow),
                                               inStream(port_b.h_outflow),
                                               x/L,
                                               v>=0,
                                               initialPoints,
                                               initialValuesH);

      // Transport of substances
      port_a.Xi_outflow = if allowFlowReversal then inStream(port_b.Xi_outflow) else Medium.X_default[1:Medium.nXi];
      port_b.Xi_outflow = inStream(port_a.Xi_outflow);

      port_a.C_outflow = if allowFlowReversal then inStream(port_b.C_outflow) else zeros(Medium.nC);
      port_b.C_outflow = inStream(port_a.C_outflow);

      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), Icon(coordinateSystem(
              preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
            Line(
              points={{-72,-28}},
              color={0,0,0},
              pattern=LinePattern.Dash,
              thickness=0.5,
              smooth=Smooth.None),
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
              fillColor={175,175,175})}),
        Documentation(revisions="<html>
<ul>
<li>
May 19, 2016 by Marcus Fuchs:<br/>
Remove condition on <code>show_V_flow</code> for calculation of <code>V_flow</code> to conform with pedantic checking.
</li>
<li>
October 10, 2015 by Marcus Fuchs:<br/>
Copy Icon from KUL implementation and rename model.
</li>
<li>
June 23, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>",     info="<html>
<p>A simple model to account for the effect of the temperature delay for a fluid flow through a pipe. It uses the spatialDistribution operator to delay changes in input enthalpy depending on the flow velocity.</p>
</html>"));
    end PipeLosslessPlugFlow;

    model PipeAdiabaticPlugFlow
      "Pipe model using spatialDistribution for temperature delay without heat losses"
      extends IBPSA.Fluid.Interfaces.PartialTwoPort;

      parameter Modelica.SIunits.Length thickness=0.002 "Pipe wall thickness";
      parameter Modelica.SIunits.Length dh=0.05 "Hydraulic diameter";
      parameter Modelica.SIunits.Length length "Pipe length";

      /*parameter Modelica.SIunits.ThermalConductivity k = 0.005
    "Heat conductivity of pipe's surroundings";*/

      parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1
        "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

      parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
        m_flow_nominal) "Small mass flow rate for regularization of zero flow"
        annotation (Dialog(tab="Advanced"));

      //parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=
      // dpStraightPipe_nominal "Pressure drop at nominal mass flow rate"
      // annotation (Dialog(group="Nominal condition"));

      parameter Modelica.SIunits.Height roughness=2.5e-5
        "Average height of surface asperities (default: smooth steel pipe)"
        annotation (Dialog(group="Geometry"));

      final parameter Modelica.SIunits.Pressure dpStraightPipe_nominal=
          Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
          m_flow=m_flow_nominal,
          rho_a=rho_default,
          rho_b=rho_default,
          mu_a=mu_default,
          mu_b=mu_default,
          length=length,
          diameter=dh,
          roughness=roughness,
          m_flow_small=m_flow_small)
        "Pressure loss of a straight pipe at m_flow_nominal";

      // TODO: Calculate dpStraightPipe_nominal inside HydraulicDiameter res
      Fluid.FixedResistances.HydraulicDiameter          res(
        redeclare final package Medium = Medium,
        final dh=dh,
        final m_flow_nominal=m_flow_nominal,
        from_dp=from_dp,
        length=length,
        fac=1,
        dp(nominal=2))           "Pressure drop calculation for this pipe"
        annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
        //final dp_nominal=dp_nominal,

    protected
      parameter Modelica.SIunits.SpecificEnthalpy h_ini_in=Medium.specificEnthalpy(
          Medium.setState_pTX(
          T=T_ini_in,
          p=Medium.p_default,
          X=Medium.X_default)) "For initialization of spatialDistribution inlet";

          parameter Modelica.SIunits.SpecificEnthalpy h_ini_out=Medium.specificEnthalpy(
          Medium.setState_pTX(
          T=T_ini_out,
          p=Medium.p_default,
          X=Medium.X_default)) "For initialization of spatialDistribution outlet";

      parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
          T=Medium.T_default,
          p=Medium.p_default,
          X=Medium.X_default) "Default medium state";

      parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
          p=Medium.p_default,
          T=Medium.T_default,
          X=Medium.X_default)
        "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
        annotation (Dialog(group="Advanced"));

      parameter Modelica.SIunits.DynamicViscosity mu_default=
          Medium.dynamicViscosity(Medium.setState_pTX(
          p=Medium.p_default,
          T=Medium.T_default,
          X=Medium.X_default))
        "Default dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
        annotation (Dialog(group="Advanced"));

      parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
          Medium.specificHeatCapacityCp(Medium.setState_pTX(
          p=Medium.p_default,
          T=Medium.T_default,
          X=Medium.X_default)) "Default specific heat of water";

      IBPSA.Fluid.PlugFlowPipes.BaseClasses.PipeLosslessPlugFlow
        temperatureDelay(
        redeclare final package Medium = Medium,
        final m_flow_small=m_flow_small,
        final D=dh,
        final L=length,
        final allowFlowReversal=allowFlowReversal,
        initialValuesH={h_ini_in,h_ini_out})
        "Model for temperature wave propagation with spatialDistribution operator"
        annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    public
      parameter Boolean from_dp=false
        "= true, use m_flow = f(dp) else dp = f(m_flow)"
        annotation (Evaluate=true, Dialog(tab="Advanced"));
      parameter Modelica.SIunits.Temperature T_ini_in=Medium.T_default
        "Initial temperature in pipe at inlet" annotation (Dialog(group="Initialization"));
      parameter Modelica.SIunits.Temperature T_ini_out=Medium.T_default
        "Initial temperature in pipe at outlet" annotation (Dialog(group="Initialization"));

      Fluid.Sensors.TemperatureTwoPort senTem_delay(
        m_flow_nominal=m_flow_nominal,
        tau=0,
        redeclare package Medium = Medium)
        annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    equation
      connect(port_a, res.port_a)
        annotation (Line(points={{-100,0},{-70,0},{-40,0}}, color={0,127,255}));
      connect(res.port_b, temperatureDelay.port_a)
        annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
      connect(temperatureDelay.port_b, senTem_delay.port_a)
        annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
      connect(senTem_delay.port_b, port_b)
        annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                100,100}})),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics={
            Rectangle(
              extent={{-100,40},{100,-42}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={192,192,192}),
            Rectangle(
              extent={{-100,30},{100,-28}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={0,127,255}),
            Rectangle(
              extent={{-26,30},{30,-28}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={215,202,187})}),
        Documentation(revisions="<html>
<ul>
<li>July 4, 2016 by Bram van der Heijde:<br>Introduce <code><span style=\"font-family: Courier New,courier;\">pipVol</span></code>.</li>
<li>May 27, 2016 by Marcus Fuchs:<br>Introduce <code><span style=\"font-family: Courier New,courier;\">use_dh</span></code> and adjust <code><span style=\"font-family: Courier New,courier;\">dp_nominal</span></code>. </li>
<li>May 19, 2016 by Marcus Fuchs:<br>Add current issue and link to example in documentation.</li>
<li>April 2, 2016 by Bram van der Heijde:<br>Add volumes and pipe capacity at inlet and outlet of the pipe.</li>
<li>October 10, 2015 by Marcus Fuchs:<br>Copy Icon from KUL implementation and rename model. </li>
<li>June 23, 2015 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>",     info="<html>
<p>First implementation of an adiabatic pipe using the fixed resistance from IBPSA and the spatialDistribution operator for the temperature wave propagation through the length of the pipe. The temperature propagation is handled by the PipeLosslessPlugFlow component.</p>
<p>This component includes water volumes at the in- and outlet to account for the thermal capacity of the pipe walls. Logically, each volume should contain half of the pipe&apos;s real water volume. However, this leads to an overestimation, probably because only part of the pipe is affected by temperature changes (see Benonysson, 1991). The ratio of the pipe to be included in the thermal capacity is to be investigated further. </p>
</html>"));
    end PipeAdiabaticPlugFlow;

    model PipeCore
      "Pipe model using spatialDistribution for temperature delay with modified delay tracker"
      extends IBPSA.Fluid.Interfaces.PartialTwoPort;

      parameter Modelica.SIunits.Diameter diameter "Pipe diameter";
      parameter Modelica.SIunits.Length length "Pipe length";
      parameter Modelica.SIunits.Length thicknessIns "Thickness of pipe insulation";

      /*parameter Modelica.SIunits.ThermalConductivity k = 0.005 
    "Heat conductivity of pipe's surroundings";*/

      parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1
        "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

      parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
        m_flow_nominal) "Small mass flow rate for regularization of zero flow"
        annotation (Dialog(tab="Advanced"));

      parameter Modelica.SIunits.Height roughness=2.5e-5
        "Average height of surface asperities (default: smooth steel pipe)"
        annotation (Dialog(group="Geometry"));

      parameter IBPSA.Fluid.PlugFlowPipes.Types.ThermalResistanceLength R=1/(
          lambdaI*2*Modelica.Constants.pi/Modelica.Math.log((diameter/2 +
          thicknessIns)/(diameter/2)));
      parameter IBPSA.Fluid.PlugFlowPipes.Types.ThermalCapacityPerLength C=
          rho_default*Modelica.Constants.pi*(diameter/2)^2*cp_default;
      parameter Modelica.SIunits.ThermalConductivity lambdaI=0.026
        "Heat conductivity";

      parameter Modelica.SIunits.HeatCapacity walCap=length*((diameter + 2*
          thickness)^2 - diameter^2)*Modelica.Constants.pi/4*cpipe*rho_wall
        "Heat capacity of pipe wall";
      parameter Modelica.SIunits.SpecificHeatCapacity cpipe=500 "For steel";
      parameter Modelica.SIunits.Density rho_wall=8000 "For steel";

      // fixme: shouldn't dp(nominal) be around 100 Pa/m?
      // fixme: propagate use_dh and set default to false

      IBPSA.Fluid.PlugFlowPipes.BaseClasses.PipeAdiabaticPlugFlow
        pipeAdiabaticPlugFlow(
        redeclare final package Medium = Medium,
        final m_flow_small=m_flow_small,
        final allowFlowReversal=allowFlowReversal,
        dh=diameter,
        length=length,
        m_flow_nominal=m_flow_nominal,
        from_dp=from_dp,
        thickness=thickness,
        T_ini_in=T_ini_in,
        T_ini_out=T_ini_out)
        "Model for temperature wave propagation with spatialDistribution operator and hydraulic resistance"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

    protected
      parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
          T=Medium.T_default,
          p=Medium.p_default,
          X=Medium.X_default) "Default medium state";

      parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
          p=Medium.p_default,
          T=Medium.T_default,
          X=Medium.X_default)
        "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
        annotation (Dialog(group="Advanced"));

      parameter Modelica.SIunits.DynamicViscosity mu_default=
          Medium.dynamicViscosity(Medium.setState_pTX(
          p=Medium.p_default,
          T=Medium.T_default,
          X=Medium.X_default))
        "Default dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
        annotation (Dialog(group="Advanced"));

      parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
          Medium.specificHeatCapacityCp(state=sta_default)
        "Heat capacity of medium";

    public
      IBPSA.Fluid.PlugFlowPipes.BaseClasses.HeatLossPipeDelay reverseHeatLoss(
        redeclare package Medium = Medium,
        diameter=diameter,
        length=length,
        C=C,
        R=R,
        m_flow_small=m_flow_small,
        T_ini=T_ini_in)
        annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));

      IBPSA.Fluid.PlugFlowPipes.BaseClasses.HeatLossPipeDelay heatLoss(
        redeclare package Medium = Medium,
        diameter=diameter,
        length=length,
        C=C,
        R=R,
        m_flow_small=m_flow_small,
        T_ini=T_ini_out)
        annotation (Placement(transformation(extent={{40,-10},{60,10}})));
      IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
        annotation (Placement(transformation(extent={{-44,10},{-24,-10}})));
      IBPSA.Fluid.PlugFlowPipes.BaseClasses.TimeDelay timeDelay(
        length=length,
        diameter=diameter,
        rho=rho_default,
        initDelay=initDelay,
        m_flowInit=m_flowInit)
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
        annotation (Placement(transformation(extent={{-10,90},{10,110}})));

      parameter Boolean from_dp=false
        "= true, use m_flow = f(dp) else dp = f(m_flow)"
        annotation (Evaluate=true, Dialog(tab="Advanced"));
      parameter Modelica.SIunits.Length thickness=0.002 "Pipe wall thickness";

      parameter Modelica.SIunits.Temperature T_ini_in=Medium.T_default
        "Initialization temperature at pipe inlet"
        annotation (Dialog(tab="Initialization"));
      parameter Modelica.SIunits.Temperature T_ini_out=Medium.T_default
        "Initialization temperature at pipe outlet"
        annotation (Dialog(tab="Initialization"));
      parameter Boolean initDelay=false
        "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
        annotation (Dialog(tab="Initialization"));
      parameter Modelica.SIunits.MassFlowRate m_flowInit=0
        annotation (Dialog(tab="Initialization", enable=initDelay));

    equation

      connect(senMasFlo.m_flow, timeDelay.m_flow) annotation (Line(
          points={{-34,-11},{-34,-40},{-12,-40}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(reverseHeatLoss.heatPort, heatPort) annotation (Line(points={{-70,10},
              {-70,40},{0,40},{0,100}}, color={191,0,0}));
      connect(heatLoss.heatPort, heatPort) annotation (Line(points={{50,10},{50,40},
              {0,40},{0,100}}, color={191,0,0}));

      connect(timeDelay.tauRev, reverseHeatLoss.tau) annotation (Line(points={{11,-36},
              {26,-36},{26,28},{-64,28},{-64,10}}, color={0,0,127}));
      connect(timeDelay.tau, heatLoss.tau) annotation (Line(points={{11,-44},{32,-44},
              {32,28},{44,28},{44,10}}, color={0,0,127}));

      connect(port_a, reverseHeatLoss.port_b)
        annotation (Line(points={{-100,0},{-80,0},{-80,0}}, color={0,127,255}));
      connect(reverseHeatLoss.port_a, senMasFlo.port_a)
        annotation (Line(points={{-60,0},{-52,0},{-44,0}}, color={0,127,255}));
      connect(senMasFlo.port_b, pipeAdiabaticPlugFlow.port_a)
        annotation (Line(points={{-24,0},{-17,0},{-10,0}}, color={0,127,255}));
      connect(heatLoss.port_b, port_b)
        annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
      connect(pipeAdiabaticPlugFlow.port_b, heatLoss.port_a)
        annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
      annotation (
        Line(points={{70,20},{72,20},{72,0},{100,0}}, color={0,127,255}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}})),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics={
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
              extent={{-100,50},{100,40}},
              lineColor={175,175,175},
              fillColor={255,255,255},
              fillPattern=FillPattern.Backward),
            Rectangle(
              extent={{-100,-40},{100,-50}},
              lineColor={175,175,175},
              fillColor={255,255,255},
              fillPattern=FillPattern.Backward),
            Polygon(
              points={{0,100},{40,62},{20,62},{20,38},{-20,38},{-20,62},{-40,62},{0,
                  100}},
              lineColor={0,0,0},
              fillColor={238,46,47},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-30,30},{28,-30}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={215,202,187})}),
        Documentation(revisions="<html>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">July 4, 2016 by Bram van der Heijde:<br>Introduce <code></span><span style=\"font-family: Courier New,courier;\">pipVol</code></span><span style=\"font-family: MS Shell Dlg 2;\">.</span></li>
<li>October 10, 2015 by Marcus Fuchs:<br>Copy Icon from KUL implementation and rename model; Replace resistance and temperature delay by an adiabatic pipe; </li>
<li>September, 2015 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>",     info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Implementation of a pipe with heat loss using the time delay based heat losses and the spatialDistribution operator for the temperature wave propagation through the length of the pipe. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The heat loss component adds a heat loss in design direction, and leaves the enthalpy unchanged in opposite flow direction. Therefore it is used in front of and behind the time delay. The delay time is calculated once on the pipe level and supplied to both heat loss operators. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This component uses a modified delay operator.</span></p>
</html>"));
    end PipeCore;
  end BaseClasses;

  package Validation
  extends Modelica.Icons.ExamplesPackage;

    model ValidationPipeULg "Validation against data from Université de Liège"
      extends Modelica.Icons.Example;
      // R=((1/(2*pipe.lambdaI)*log((0.0603/2+pipe.thicknessIns)/(0.0603/2)))+1/(5*(0.0603+2*pipe.thicknessIns)))/Modelica.Constants.pi
      package Medium = IBPSA.Media.Water;
      Fluid.Sources.MassFlowSource_T WaterCityNetwork(
        redeclare package Medium = Medium,
        m_flow=1.245,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={70,0})));
      Fluid.HeatExchangers.Heater_T Boiler(
        redeclare package Medium = Medium,
        m_flow_nominal=1,
        dp_nominal=0) annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={44,0})));
      Fluid.Sources.Boundary_pT Sewer1(redeclare package Medium = Medium, nPorts=1)
        annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=180,
            origin={-110,0})));
      Fluid.Sensors.TemperatureTwoPort senTem_out(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        tau=0,
        T_start=T_ini_out)
        annotation (Placement(transformation(extent={{-74,-10},{-94,10}})));
      Fluid.Sensors.TemperatureTwoPort senTem_in(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        tau=0,
        T_start=T_ini_in)
        annotation (Placement(transformation(extent={{30,-10},{10,10}})));
      Modelica.Blocks.Sources.CombiTimeTable DataReader(table=pipeDataULg.data,
          extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
        annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
      Modelica.Blocks.Sources.Constant Tamb(k=273 + 18)
        "Ambient temperature in Kelvin";
      Modelica.Blocks.Math.UnitConversions.From_degC Tout
        "Ambient temperature in degrees"
        annotation (Placement(transformation(extent={{40,-88},{60,-68}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
            295.15) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-30,70})));
      Modelica.Blocks.Math.UnitConversions.From_degC Tin
        "Input temperature into pipe"
        annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
        "Nominal mass flow rate, used for regularization near zero flow";
      parameter Modelica.SIunits.Temperature T_ini_in=pipeDataULg.T_ini_in + 273.15
        "Initial temperature at pipe inlet";
      parameter Modelica.SIunits.Temperature T_ini_out=pipeDataULg.T_ini_out +
          273.15 "Initial temperature at pipe outlet";
      parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
          Medium.specificHeatCapacityCp(state=sta_default)
        "Heat capacity of medium";
      parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
          T=Medium.T_default,
          p=Medium.p_default,
          X=Medium.X_default) "Default medium state";
      replaceable Data.PipeDataULg151202 pipeDataULg constrainedby
        Data.BaseClasses.PipeDataULg
        annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
      Modelica.Blocks.Math.Gain gain(k=1)
        annotation (Placement(transformation(extent={{52,-30},{72,-10}})));
      PlugFlowPipe pipe(
        redeclare package Medium = Medium,
        diameter=0.05248,
        length=39,
        thicknessIns(displayUnit="mm") = 0.013,
        lambdaI=0.04,
        m_flow_nominal=m_flow_nominal,
        thickness=3.9e-3,
        T_ini_out=T_ini_out,
        T_ini_in=T_ini_in,
        R=((1/(2*pipe.lambdaI)*log((0.0603/2 + pipe.thicknessIns)/(0.0603/2)))
             + 1/(5*(0.0603 + 2*pipe.thicknessIns)))/Modelica.Constants.pi,
        nPorts=1,
        initDelay=true,
        m_flowInit=pipeDataULg.m_flowIni)
        annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
      Fluid.Sensors.EnthalpyFlowRate senEntOut(redeclare package Medium = Medium,
          m_flow_nominal=m_flow_nominal)
        annotation (Placement(transformation(extent={{-46,-10},{-66,10}})));
      Modelica.Blocks.Math.Gain gain2(k=-1)
        annotation (Placement(transformation(extent={{20,40},{40,60}})));
      Modelica.Blocks.Math.MultiSum heatLossSim(nu=2)
        annotation (Placement(transformation(extent={{60,54},{72,66}})));
      Modelica.Blocks.Continuous.Integrator eneLosInt
        annotation (Placement(transformation(extent={{160,50},{180,70}})));
      Fluid.Sensors.EnthalpyFlowRate senEntIn(redeclare package Medium = Medium,
          m_flow_nominal=m_flow_nominal)
        annotation (Placement(transformation(extent={{4,-10},{-16,10}})));
      Modelica.Blocks.Math.Gain gain1(k=-1)
        annotation (Placement(transformation(extent={{74,-88},{94,-68}})));
      Modelica.Blocks.Math.MultiSum deltaT(nu=2)
        annotation (Placement(transformation(extent={{112,-76},{124,-64}})));
      Modelica.Blocks.Math.MultiProduct heatLossMeas(nu=2)
        annotation (Placement(transformation(extent={{140,-66},{152,-54}})));
      Modelica.Blocks.Math.Gain gain3(k=cp_default)
        annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
      Modelica.Blocks.Math.Feedback heaLosDiff
        annotation (Placement(transformation(extent={{86,50},{106,70}})));
    equation
      connect(DataReader.y[3], Tout.u) annotation (Line(
          points={{21,-50},{32,-50},{32,-78},{38,-78}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(DataReader.y[5], Tin.u)
        annotation (Line(points={{21,-50},{29.5,-50},{38,-50}}, color={0,0,127}));
      connect(DataReader.y[1], gain.u) annotation (Line(points={{21,-50},{32,-50},{
              32,-20},{50,-20}}, color={0,0,127}));
      connect(senTem_in.port_a, Boiler.port_b)
        annotation (Line(points={{30,0},{30,0},{34,0}}, color={0,127,255}));
      connect(Boiler.port_a, WaterCityNetwork.ports[1])
        annotation (Line(points={{54,0},{54,0},{60,0}}, color={0,127,255}));
      connect(gain.y, WaterCityNetwork.m_flow_in) annotation (Line(points={{73,-20},
              {90,-20},{90,8},{80,8}}, color={0,0,127}));
      connect(Tin.y, Boiler.TSet) annotation (Line(points={{61,-50},{61,-50},{104,-50},
              {104,18},{62,18},{62,8},{56,8}}, color={0,0,127}));
      connect(Sewer1.ports[1], senTem_out.port_b)
        annotation (Line(points={{-100,0},{-94,0}}, color={0,127,255}));
      connect(senEntOut.H_flow, gain2.u) annotation (Line(points={{-56,11},{-56,26},
              {6,26},{6,50},{18,50}}, color={0,0,127}));
      connect(gain2.y, heatLossSim.u[1]) annotation (Line(points={{41,50},{50,50},{
              50,62.1},{60,62.1}}, color={0,0,127}));
      connect(senTem_out.port_a, senEntOut.port_b)
        annotation (Line(points={{-74,0},{-70,0},{-66,0}}, color={0,127,255}));
      connect(senEntOut.port_a, pipe.ports_b[1])
        annotation (Line(points={{-46,0},{-43,0},{-40,0}}, color={0,127,255}));
      connect(pipe.port_a, senEntIn.port_b)
        annotation (Line(points={{-20,0},{-16,0}}, color={0,127,255}));
      connect(senTem_in.port_b, senEntIn.port_a)
        annotation (Line(points={{10,0},{4,0}}, color={0,127,255}));
      connect(senEntIn.H_flow, heatLossSim.u[2]) annotation (Line(points={{-6,11},{
              -6,20},{52,20},{52,57.9},{60,57.9}}, color={0,0,127}));
      connect(fixedTemperature.port, pipe.heatPort)
        annotation (Line(points={{-30,60},{-30,10}}, color={191,0,0}));
      connect(Tout.y, gain1.u)
        annotation (Line(points={{61,-78},{72,-78}}, color={0,0,127}));
      connect(Tin.y, deltaT.u[1]) annotation (Line(points={{61,-50},{82,-50},{104,-50},
              {104,-67.9},{112,-67.9}}, color={0,0,127}));
      connect(gain1.y, deltaT.u[2]) annotation (Line(points={{95,-78},{104,-78},{
              104,-72.1},{112,-72.1}}, color={0,0,127}));
      connect(deltaT.y, heatLossMeas.u[1]) annotation (Line(points={{125.02,-70},{
              130,-70},{130,-68},{130,-57.9},{140,-57.9}}, color={0,0,127}));
      connect(gain.y, gain3.u)
        annotation (Line(points={{73,-20},{98,-20}}, color={0,0,127}));
      connect(gain3.y, heatLossMeas.u[2]) annotation (Line(points={{121,-20},{130,-20},
              {130,-62.1},{140,-62.1}}, color={0,0,127}));
      connect(heatLossMeas.y, heaLosDiff.u2) annotation (Line(points={{153.02,-60},
              {162,-60},{162,4},{96,4},{96,52}}, color={0,0,127}));
      connect(heatLossSim.y, heaLosDiff.u1)
        annotation (Line(points={{73.02,60},{88,60}}, color={0,0,127}));
      connect(heaLosDiff.y, eneLosInt.u)
        annotation (Line(points={{105,60},{105,60},{158,60}}, color={0,0,127}));
      annotation (
        Documentation(info="<html>
<p>The example contains <a href=\"modelica://IBPSA.Experimental.Pipe.Data.PipeDataULg150801\">experimental data</a> from a real district heating network. This data is used to validate pipe models.</p>
<p>Pipe&apos;s temperature is not initialized, thus the first 70 seconds should be disregarded. </p>
<p>The insulation used is Tubolit 60/13. For this material, a thermal conductivity of about 0.04 W/m<sup>2</sup>K can be found (<a href=\"http://www.armacell.com/WWW/armacell/ACwwwAttach.nsf/ansFiles/PDS_Range_Tubolit_CHf.pdf/$File/PDS_Range_Tubolit_CHf.pdf\">source</a>).</p>
<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/ULgTestBench.png\"/> </p>
<p><b><span style=\"color: #008000;\">Calibration</span></b> </p>
<p>There are some incertainties about the heat loss coefficient between pipe and surrounding air as well as regarding the heat conductivity of the insulation material. With the <a href=\"modelica://IBPSA.Experimental.Pipe.Data.PipeDataULg150801\">given data</a>, the length specific thermal resistance <code>R = 2.164 </code>(mK/W). <code>R</code> calculated as follows: </p>
<p><code>R=((1/(2*pipe.lambdaI)*log((0.0603+2*pipe.thicknessIns)/(0.0603)))+1/(5*(0.0603+2*pipe.thicknessIns)))/Modelica.Constants.pi</code> </p>
<p><code>U = 1/R = 0.462 W/mK </code> </p>
<p><b><span style=\"color: #008000;\">Validation</span></b> </p>
<p>The figure below shows the validation results of the pipe model versus the ULg measurements. </p>
<p>The dynamic discrepancy (during the rise and drop in temperature) could be caused by the following:</p>
<ul>
<li>Inaccuracy of the pipe wall thickness and hence of the pipe wall capacity,</li>
<li>Inaccuracy of the mass flow measurement (applying 95&percnt; of the mass flow of 1.245 kg/s shows an even better fit) or </li>
<li>Negligence of another phenomenon, e.g. turbulent mixing at a temperature front.</li>
</ul>
<p><br>Given the accuracy of the temperature measurements of +/- 0.3K, the validation results are satisfying even though the dynamics are not completely represented by the model.</p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/ValidationPipeULg.png\"/></p>
</html>",     revisions="<html>
<ul>
<li>November 24, 2016 by Bram van der Heijde:<br>Add pipe thickness for wall capacity calculation and expand documentation section.</li>
<li>April 2, 2016 by Bram van der Heijde:<br>Change thermal conductivity and put boundary condition in K.</li>
<li>Januar 26, 2016 by Carles Ribas:<br>First implementation. </li>
</ul>
</html>"),
        experiment(StopTime=875),
        __Dymola_Commands(file=
              "Resources/Scripts/Dymola/Fluid/PlugFlowPipes/Validation/ValidationPipeULg.mos"
            "Simulate and plot"),
        __Dymola_experimentSetupOutput(events=false),
        __Dymola_experimentFlags(
          Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
          Evaluate=true,
          OutputCPUtime=true,
          OutputFlatModelica=false));
    end ValidationPipeULg;

    model ValidationPipeAIT
      "Validation pipe against data from Austrian Institute of Technology"
      extends Modelica.Icons.Example;

      Fluid.Sources.MassFlowSource_T Point1(
        redeclare package Medium = Medium,
        use_T_in=true,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={82,-42})));
      package Medium = IBPSA.Media.Water;
      Fluid.Sources.MassFlowSource_T Point4(
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={8,88})));
      Fluid.Sources.MassFlowSource_T Point3(
        nPorts=1,
        redeclare package Medium = Medium,
        use_m_flow_in=true) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-46,-58})));
      Fluid.Sources.MassFlowSource_T Point2(
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={-88,82})));
      PlugFlowPipe pip1(
        redeclare package Medium = Medium,
        diameter=0.0825,
        thicknessIns=0.045,
        lambdaI=0.024,
        length=115,
        allowFlowReversal=allowFlowReversal,
        nPorts=2,
        m_flow_nominal=0.3,
        R=1/(2*0.024*Modelica.Constants.pi)*log(0.18/0.0899) + 1/(2*2.4*
            Modelica.Constants.pi)*log(2/0.18),
        thickness=thickness)
        annotation (Placement(transformation(extent={{50,0},{30,20}})));
      PlugFlowPipe pip4(
        redeclare package Medium = Medium,
        length=29,
        thicknessIns=0.045,
        lambdaI=0.024,
        allowFlowReversal=allowFlowReversal,
        m_flow_nominal=0.3,
        diameter(displayUnit="mm") = 0.0337 - 2*0.0032,
        thickness=thickness,
        nPorts=2,
        R=R80) annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=90,
            origin={10,40})));
        //R=1/0.208 + 1/(2*2.4*Modelica.Constants.pi)*log(1/0.18),
        //thicknessIns=0.045,
      PlugFlowPipe pip5(
        redeclare package Medium = Medium,
        length=20,
        diameter=0.0825,
        lambdaI=0.024,
        thicknessIns=0.045,
        allowFlowReversal=allowFlowReversal,
        nPorts=2,
        m_flow_nominal=0.3,
        R=1/(2*0.024*Modelica.Constants.pi)*log(0.18/0.0899) + 1/(2*2.4*
            Modelica.Constants.pi)*log(2/0.18),
        thickness=thickness)
        annotation (Placement(transformation(extent={{0,0},{-20,20}})));
        //R=1/0.208 + 1/(2*2.4*Modelica.Constants.pi)*log(1/0.18),
      PlugFlowPipe pip2(
        redeclare package Medium = Medium,
        length=76,
        thicknessIns=0.045,
        lambdaI=0.024,
        allowFlowReversal=allowFlowReversal,
        nPorts=1,
        m_flow_nominal=0.3,
        thickness=thickness,
        diameter=0.0337 - 2*0.0032,
        R=R80) annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=-90,
            origin={-88,30})));
        //R=1/0.208 + 1/(2*2.4*Modelica.Constants.pi)*log(1/0.18),
      PlugFlowPipe pip3(
        redeclare package Medium = Medium,
        length=38,
        thicknessIns=0.045,
        lambdaI=0.024,
        allowFlowReversal=allowFlowReversal,
        nPorts=1,
        m_flow_nominal=0.3,
        thickness=thickness,
        diameter=0.0337 - 2*0.0032,
        R=R80) annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=90,
            origin={-46,-4})));
      Modelica.Blocks.Sources.CombiTimeTable DataReader(table=pipeDataAIT151218.data)
        annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
      Data.PipeDataAIT151218 pipeDataAIT151218
        annotation (Placement(transformation(extent={{-30,-100},{-10,-80}})));
      Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-DataReader.y[7])
        annotation (Placement(transformation(extent={{-100,-80},{-60,-60}})));
      Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-DataReader.y[8])
        annotation (Placement(transformation(extent={{128,110},{88,130}})));
      Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-DataReader.y[6])
        annotation (Placement(transformation(extent={{-14,90},{-54,110}})));
      Modelica.Blocks.Sources.RealExpression T_p1(y=DataReader.y[1])
        annotation (Placement(transformation(extent={{18,-74},{58,-54}})));
      Fluid.Sensors.TemperatureTwoPort senTem_p3(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra) annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={-46,-34})));
      Fluid.Sensors.TemperatureTwoPort senTem_p2(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-88,56})));
      Fluid.Sensors.TemperatureTwoPort senTem_p4(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={8,62})));
      Fluid.Sensors.TemperatureTwoPort senTem_p1(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra) annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={34,-22})));
      PlugFlowPipe pip0(
        redeclare package Medium = Medium,
        diameter=0.0825,
        thicknessIns=0.045,
        lambdaI=0.024,
        length=20,
        allowFlowReversal=allowFlowReversal,
        nPorts=2,
        m_flow_nominal=0.3,
        R=1/(2*0.024*Modelica.Constants.pi)*log(0.18/0.0899) + 1/(2*2.4*
            Modelica.Constants.pi)*log(2/0.18),
        thickness=thickness) annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=90,
            origin={80,-2})));
      Fluid.Sources.FixedBoundary ExcludedBranch(redeclare package Medium = Medium,
          nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={80,70})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
        prescribedTemperature
        annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
      Fluid.Sensors.TemperatureTwoPort senTemIn_p2(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra)
        annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
      parameter Modelica.SIunits.Length Lcap=1
        "Length over which transient effects typically take place";
      parameter Types.ThermalResistanceLength R80=1/(2*0.024*Modelica.Constants.pi)
          *log(0.07/0.0337) + 1/(2*2.4*Modelica.Constants.pi)*log(2/0.07);

      parameter Boolean pipVol=true
        "Flag to decide whether volumes are included at the end points of the pipe";
      parameter Boolean allowFlowReversal=true
        "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)";
      Experimental.Pipe.BaseClasses.SinglePipeConfig.IsoPlusSingleRigidStandard.IsoPlusKRE80S
        pipeData(
        Di=825e-3,
        lambdaI=0.024,
        Do=825e-3 + 2*pipeData.s + 2*45e-3)
        annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
        "Nominal mass flow rate, used for regularization near zero flow";
      parameter Modelica.SIunits.Time tauHeaTra=6500
        "Time constant for heat transfer, default 20 minutes";
      Modelica.Blocks.Logical.Switch switch
        annotation (Placement(transformation(extent={{54,96},{34,116}})));
      Modelica.Blocks.Sources.RealExpression m_flow_zero(y=0)
        annotation (Placement(transformation(extent={{134,88},{94,108}})));
      Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=-0.001)
        annotation (Placement(transformation(extent={{78,104},{72,110}})));
      Modelica.Blocks.Logical.Switch switch1
        annotation (Placement(transformation(extent={{130,40},{110,60}})));
      Fluid.Sources.MassFlowSource_T Point5(
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={46,56})));
      parameter Modelica.SIunits.Length thickness=0.0032 "Pipe wall thickness";
    equation
      connect(m_flow_p3.y, Point3.m_flow_in) annotation (Line(
          points={{-58,-70},{-54,-70},{-54,-68}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Point2.m_flow_in, m_flow_p2.y) annotation (Line(
          points={{-80,92},{-80,100},{-56,100}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_p1.y, Point1.T_in) annotation (Line(
          points={{60,-64},{78,-64},{78,-54}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(DataReader.y[5], Point1.m_flow_in) annotation (Line(
          points={{21,-90},{26,-90},{26,-72},{74,-72},{74,-52}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(DataReader.y[9], prescribedTemperature.T)
        annotation (Line(points={{21,-90},{30,-90},{38,-90}}, color={0,0,127}));
      connect(pip4.heatPort, pip1.heatPort) annotation (Line(points={{20,40},{20,40},
              {40,40},{40,20}}, color={191,0,0}));
      connect(pip1.heatPort, pip0.heatPort) annotation (Line(points={{40,20},{40,26},
              {100,26},{100,-2},{90,-2}}, color={191,0,0}));
      connect(pip1.heatPort, pip2.heatPort) annotation (Line(points={{40,20},{40,26},
              {-54,26},{-54,30},{-78,30}}, color={191,0,0}));
      connect(pip5.heatPort, pip2.heatPort) annotation (Line(points={{-10,20},{-10,26},
              {-54,26},{-54,30},{-78,30}}, color={191,0,0}));
      connect(pip3.heatPort, pip2.heatPort) annotation (Line(points={{-36,-4},{-28,-4},
              {-28,26},{-54,26},{-54,30},{-78,30}}, color={191,0,0}));
      connect(prescribedTemperature.port, pip0.heatPort) annotation (Line(points={{60,
              -90},{100,-90},{100,-2},{90,-2}}, color={191,0,0}));
      connect(senTem_p2.port_b, Point2.ports[1]) annotation (Line(points={{-88,66},{
              -88,66},{-88,70},{-88,72}}, color={0,127,255}));
      connect(Point3.ports[1], senTem_p3.port_b)
        annotation (Line(points={{-46,-48},{-46,-44}}, color={0,127,255}));
      connect(senTem_p4.port_b, Point4.ports[1])
        annotation (Line(points={{8,72},{8,68},{8,78}}, color={0,127,255}));
      connect(Point1.ports[1], senTem_p1.port_b)
        annotation (Line(points={{82,-32},{82,-32},{34,-32}}, color={0,127,255}));
      connect(senTem_p1.port_a, pip0.port_a)
        annotation (Line(points={{34,-12},{70,-12},{80,-12}}, color={0,127,255}));
      connect(switch.u1, m_flow_p4.y) annotation (Line(points={{56,114},{72,114},{72,
              120},{86,120}}, color={0,0,127}));
      connect(m_flow_zero.y, switch.u3)
        annotation (Line(points={{92,98},{92,98},{56,98}}, color={0,0,127}));
      connect(switch.y, Point4.m_flow_in)
        annotation (Line(points={{33,106},{16,106},{16,98}}, color={0,0,127}));
      connect(switch.u2, lessThreshold.y) annotation (Line(points={{56,106},{71.7,106},
              {71.7,107}}, color={255,0,255}));
      connect(lessThreshold.u, m_flow_p4.y) annotation (Line(points={{78.6,107},{78.6,
              120},{86,120}}, color={0,0,127}));
      connect(pip1.port_a, pip0.ports_b[1])
        annotation (Line(points={{50,10},{78,10},{78,8}}, color={0,127,255}));
      connect(pip1.ports_b[1], pip4.port_a)
        annotation (Line(points={{30,8},{10,8},{10,30}},
                                                       color={0,127,255}));
      connect(pip5.port_a, pip1.ports_b[2])
        annotation (Line(points={{0,10},{30,10},{30,12}}, color={0,127,255}));
      connect(pip4.ports_b[1], senTem_p4.port_a)
        annotation (Line(points={{8,50},{8,52},{8,52}}, color={0,127,255}));
      connect(Point5.ports[1], pip4.ports_b[2]) annotation (Line(points={{36,56},{
              36,56},{12,56},{12,50}},
                                    color={0,127,255}));
      connect(pip5.ports_b[1], senTemIn_p2.port_b)
        annotation (Line(points={{-20,8},{-60,8},{-60,10}}, color={0,127,255}));
      connect(pip3.port_a, pip5.ports_b[2])
        annotation (Line(points={{-46,6},{-46,12},{-20,12}}, color={0,127,255}));
      connect(senTemIn_p2.port_a, pip2.port_a)
        annotation (Line(points={{-80,10},{-88,10},{-88,20}}, color={0,127,255}));
      connect(pip2.ports_b[1], senTem_p2.port_a)
        annotation (Line(points={{-88,40},{-88,43},{-88,46}}, color={0,127,255}));
      connect(pip3.ports_b[1], senTem_p3.port_a) annotation (Line(points={{-46,-14},
              {-46,-14},{-46,-24}}, color={0,127,255}));
      connect(ExcludedBranch.ports[1], pip0.ports_b[2]) annotation (Line(points={{80,
              60},{82,60},{82,8},{82,8}}, color={0,127,255}));
      connect(switch1.y, Point5.m_flow_in) annotation (Line(points={{109,50},{84,50},
              {84,64},{56,64}}, color={0,0,127}));
      connect(m_flow_p4.y, switch1.u3) annotation (Line(points={{86,120},{86,120},{86,
              112},{86,88},{106,88},{144,88},{144,42},{132,42}}, color={0,0,127}));
      connect(m_flow_zero.y, switch1.u1) annotation (Line(points={{92,98},{94,98},{94,
              84},{94,80},{136,80},{136,58},{132,58}}, color={0,0,127}));
      connect(lessThreshold.y, switch1.u2) annotation (Line(points={{71.7,107},{66,107},
              {66,84},{140,84},{140,50},{132,50}}, color={255,0,255}));
      annotation (
        experiment(StopTime=603900, Interval=900),
        __Dymola_experimentSetupOutput(events=false),
        Documentation(info="<html>
<p>The example contains <a href=\"modelica://IBPSA.Experimental.Pipe.Data.PipeDataAIT151218\">experimental data</a> from a real district heating network. This data is used to validate a pipe model.</p>
<p>Pipes&apos; temperatures are not initialized, thus results of outflow temperature before apprixmately the first 10000 seconds should no be considered. </p>
<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/AITTestBench.png\"/> </p>
<p><b><span style=\"color: #008000;\">Calibration</span></b> </p>
<p>To calculate the length specific thermal resistance <code><span style=\"font-family: Courier New,courier;\">R</span></code> of the pipe, the thermal resistance of the surrounding ground is added. </p>
<p><code><span style=\"font-family: Courier New,courier;\">R=1/(0.208)+1/(2*lambda_g*Modelica.Constants.pi)*log(1/0.18)</span></code> </p>
<p>Where the thermal conductivity of the ground <code><span style=\"font-family: Courier New,courier;\">lambda_g = 2.4 </span></code>W/mK. </p>
<p><br><h4><span style=\"color: #008000\">Testing spatialDistribution influence on non-linear systems</span></h4></p>
<p>The model contains two parameters on the top level:</p>
<p><code><span style=\"font-family: Courier New,courier; color: #0000ff;\">parameter&nbsp;</span><span style=\"color: #ff0000;\">Boolean</span>&nbsp;pipVol=false&nbsp;</p><p><span style=\"font-family: Courier New,courier; color: #006400;\">&nbsp;&nbsp;&nbsp;&nbsp;&QUOT;Flag&nbsp;to&nbsp;decide&nbsp;whether&nbsp;volumes&nbsp;are&nbsp;included&nbsp;at&nbsp;the&nbsp;end&nbsp;points&nbsp;of&nbsp;the&nbsp;pipe&QUOT;</span>;</code></p>
<p><code><span style=\"font-family: Courier New,courier; color: #0000ff;\">parameter&nbsp;</span><span style=\"color: #ff0000;\">Boolean</span>&nbsp;allowFlowReversal=true&nbsp;</code></p>
<p><code><span style=\"font-family: Courier New,courier; color: #006400;\">&nbsp;&nbsp;&nbsp;&nbsp;&QUOT;=&nbsp;true&nbsp;to&nbsp;allow&nbsp;flow&nbsp;reversal,&nbsp;false&nbsp;restricts&nbsp;to&nbsp;design&nbsp;direction&nbsp;(port_a&nbsp;-&GT;&nbsp;port_b)&QUOT;</span>;</code></p>
<p><br><code><span style=\"font-family: Courier New,courier;\">pipVol </span></code>controls the presence of two additional mixing volumes at the in/outlets of <code><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow.</span></code> <code><span style=\"font-family: Courier New,courier;\">allowFlowReversal</span></code> controls whether flow reversal is allowed in the same component.</p>
<p><br>Below, the model translation statistics for different combinations of these parameters are presented:</p>
<p style=\"margin-left: 30px;\"><br><h4>pipVol=true, allowFlowReversal=true</h4></p>
<p style=\"margin-left: 30px;\">Translated Model</p>
<p style=\"margin-left: 30px;\">Constants: 1090 scalars</p>
<p style=\"margin-left: 30px;\">Free parameters: 6981 scalars</p>
<p style=\"margin-left: 30px;\">Parameter depending: 6928 scalars</p>
<p style=\"margin-left: 30px;\">Continuous time states: 30 scalars</p>
<p style=\"margin-left: 30px;\">Time-varying variables: 524 scalars</p>
<p style=\"margin-left: 30px;\">Alias variables: 616 scalars</p>
<p style=\"margin-left: 30px;\">Assumed default initial conditions: 66</p>
<p style=\"margin-left: 30px;\">Number of mixed real/discrete systems of equations: 0</p>
<p style=\"margin-left: 30px;\">Sizes of linear systems of equations: { }</p>
<p style=\"margin-left: 30px;\">Sizes after manipulation of the linear systems: { }</p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes of nonlinear systems of equations: { }</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes after manipulation of the nonlinear systems: { }</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Number of numerical Jacobians: 0</span></h4></p>
<p style=\"margin-left: 30px;\"><br><h4>pipVol=false, allowFlowReversal=true</h4></p>
<p style=\"margin-left: 30px;\">Translated Model</p>
<p style=\"margin-left: 30px;\">Constants: 500 scalars</p>
<p style=\"margin-left: 30px;\">Free parameters: 6946 scalars</p>
<p style=\"margin-left: 30px;\">Parameter depending: 6863 scalars</p>
<p style=\"margin-left: 30px;\">Continuous time states: 18 scalars</p>
<p style=\"margin-left: 30px;\">Time-varying variables: 409 scalars</p>
<p style=\"margin-left: 30px;\">Alias variables: 364 scalars</p>
<p style=\"margin-left: 30px;\">Assumed default initial conditions: 54</p>
<p style=\"margin-left: 30px;\">Number of mixed real/discrete systems of equations: 0</p>
<p style=\"margin-left: 30px;\">Sizes of linear systems of equations: { }</p>
<p style=\"margin-left: 30px;\">Sizes after manipulation of the linear systems: { }</p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes of nonlinear systems of equations: {44}</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes after manipulation of the nonlinear systems: {5}</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Number of numerical Jacobians: 1</span></h4></p>
<p style=\"margin-left: 30px;\"><br><h4>pipVol=false, allowFlowReversal=false</h4></p>
<p style=\"margin-left: 30px;\">Translated Model</p>
<p style=\"margin-left: 30px;\">Constants: 500 scalars</p>
<p style=\"margin-left: 30px;\">Free parameters: 6946 scalars</p>
<p style=\"margin-left: 30px;\">Parameter depending: 6866 scalars</p>
<p style=\"margin-left: 30px;\">Continuous time states: 18 scalars</p>
<p style=\"margin-left: 30px;\">Time-varying variables: 399 scalars</p>
<p style=\"margin-left: 30px;\">Alias variables: 371 scalars</p>
<p style=\"margin-left: 30px;\">Assumed default initial conditions: 54</p>
<p style=\"margin-left: 30px;\">Number of mixed real/discrete systems of equations: 0</p>
<p style=\"margin-left: 30px;\">Sizes of linear systems of equations: { }</p>
<p style=\"margin-left: 30px;\">Sizes after manipulation of the linear systems: { }</p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes of nonlinear systems of equations: {5, 5}</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes after manipulation of the nonlinear systems: {1, 1}</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Number of numerical Jacobians: 2</span></h4></p>
<p style=\"margin-left: 30px;\"><br><h4>pipVol=true, allowFlowReversal=false</h4></p>
<p style=\"margin-left: 30px;\">Translated Model</p>
<p style=\"margin-left: 30px;\">Constants: 1090 scalars</p>
<p style=\"margin-left: 30px;\">Free parameters: 6981 scalars</p>
<p style=\"margin-left: 30px;\">Parameter depending: 6932 scalars</p>
<p style=\"margin-left: 30px;\">Continuous time states: 30 scalars</p>
<p style=\"margin-left: 30px;\">Time-varying variables: 513 scalars</p>
<p style=\"margin-left: 30px;\">Alias variables: 623 scalars</p>
<p style=\"margin-left: 30px;\">Assumed default initial conditions: 66</p>
<p style=\"margin-left: 30px;\">Number of mixed real/discrete systems of equations: 0</p>
<p style=\"margin-left: 30px;\">Sizes of linear systems of equations: { }</p>
<p style=\"margin-left: 30px;\">Sizes after manipulation of the linear systems: { }</p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes of nonlinear systems of equations: { }</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes after manipulation of the nonlinear systems: { }</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Number of numerical Jacobians: 0</span></h4></p>
<p><br>It seems that when the solver has to account for the possibility of flow reversal (aFV=true) and the model includes no additional state for the water in the pipe (pipVol = false), very large nonlinear systems appear when translating. However, the advection equation, implemented by the <code><span style=\"font-family: Courier New,courier;\">spatialDistribution</span></code> function should inherently introduce a state. This state is clearly not recognized by the model translator. We see that if additional volumes are introduced, or if flow reversal is disabled the non-linear system is smaller or entirely eliminated. </p>
</html>",     revisions="<html>
<ul>
<li>July 4, 2016 by Bram van der Heijde:<br>Added parameters to test the influence of allowFlowReversal and the presence of explicit volumes in the pipe.</li>
<li>January 26, 2016 by Carles Ribas:<br>First implementation. </li>
</ul>
</html>"),
        __Dymola_Commands(file=
              "Resources/Scripts/Dymola/Fluid/PlugFlowPipes/Validation/ValidationPipeAIT.mos"
            "Simulate and plot"),
        __Dymola_experimentFlags(
          Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
          Evaluate=false,
          OutputCPUtime=true,
          OutputFlatModelica=false));
    end ValidationPipeAIT;

    model ValidationMSLAIT
      "Validation pipe against data from Austrian Institute of Technology with standard library components"
      extends Modelica.Icons.Example;

      /*TODO: change nNodes for pipes. For fair comparison, n should be adapted to 
  make the Courant number close to 1, but this is only possible for a narrow 
  range of mass flow rates, which is a sstrength of the new pipe model.*/
      Fluid.Sources.MassFlowSource_T Point1(
        redeclare package Medium = Medium,
        use_T_in=true,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={82,-42})));
      package Medium = IBPSA.Media.Water;
      Fluid.Sources.MassFlowSource_T Point4(
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={40,88})));
      Fluid.Sources.MassFlowSource_T Point3(
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-46,-70})));
      Fluid.Sources.MassFlowSource_T Point2(
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={-60,104})));
      Modelica.Blocks.Sources.CombiTimeTable DataReader(table=pipeDataAIT151218.data)
        annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
      Data.PipeDataAIT151218 pipeDataAIT151218
        annotation (Placement(transformation(extent={{-30,-100},{-10,-80}})));
      Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-DataReader.y[7])
        annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
      Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-DataReader.y[8])
        annotation (Placement(transformation(extent={{174,120},{134,140}})));
      Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-DataReader.y[6])
        annotation (Placement(transformation(extent={{-100,120},{-60,140}})));
      Modelica.Blocks.Sources.RealExpression T_p1(y=DataReader.y[1])
        annotation (Placement(transformation(extent={{18,-74},{58,-54}})));
      Fluid.Sources.FixedBoundary ExcludedBranch(redeclare package Medium = Medium,
          nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={78,26})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
        prescribedTemperature
        annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

      parameter Boolean allowFlowReversal=false
        "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)";
      Modelica.Fluid.Pipes.DynamicPipe pip0(
        nParallel=1,
        diameter=0.0825,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        length=20,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        nNodes=20,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( dp_nominal(displayUnit="Pa") = 10*pip0.length, m_flow_nominal=0.3))
                           annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=90,
            origin={80,-8})));
      inner Modelica.Fluid.System system
        annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
      parameter Modelica.SIunits.ThermalResistance R=1/(2*lambdaI*Modelica.Constants.pi)*log(0.18/0.0899) + 1/(2*2.4*Modelica.Constants.pi)*log(2/0.18);
      parameter Modelica.SIunits.ThermalResistance R80 = 1/(2*0.024*Modelica.Constants.pi)*log(0.07/0.0337) + 1/(2*2.4*Modelica.Constants.pi)*log(2/0.07);

      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res0[pip0.nNodes](each R=
            R) annotation (Placement(transformation(extent={{98,-18},{118,2}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col0(m=pip0.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={138,-8})));
      Modelica.Fluid.Pipes.DynamicPipe pip1(
        nParallel=1,
        diameter=0.0825,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        length=115,
        nNodes=115,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( m_flow_nominal=0.3, dp_nominal=10*pip1.length))
                           annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={38,10})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col1(m=pip1.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={58,46})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res1[pip1.nNodes](each R=
            R) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={38,30})));
      Modelica.Fluid.Pipes.DynamicPipe pip2(
        nParallel=1,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        length=76,
        nNodes=76,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( dp_nominal=10*pip2.length, m_flow_nominal=0.3),
        diameter=0.0337 - 2*0.0032)
                           annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=90,
            origin={-80,40})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col2(m=pip2.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-42,96})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res2[pip2.nNodes](each R=
            R80) annotation (Placement(transformation(extent={{-68,30},{-48,50}})));
      Modelica.Fluid.Pipes.DynamicPipe pip3(
        nParallel=1,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        length=38,
        nNodes=38,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( dp_nominal=10*pip3.length, m_flow_nominal=0.3),
        diameter=0.0337 - 2*0.0032)
                           annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=90,
            origin={-46,-12})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col3(m=pip3.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={16,-52})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res3[pip3.nNodes](each R=
            R80) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-10,-30})));
      Modelica.Fluid.Pipes.DynamicPipe pip4(
        nParallel=1,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        length=29,
        nNodes=29,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( dp_nominal=10*pip4.length, m_flow_nominal=0.3),
        diameter=0.0337 - 2*0.0032)
                           annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=270,
            origin={10,40})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col4(m=pip4.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-4,96})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res4[pip4.nNodes](each R=
            R80) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-4,62})));
      Modelica.Fluid.Pipes.DynamicPipe pip5(
        nParallel=1,
        diameter=0.0825,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        length=20,
        nNodes=20,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( dp_nominal=10*pip5.length, m_flow_nominal=0.3))
                           annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={-10,10})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col5(m=pip5.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-28,96})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res5[pip5.nNodes](each R=
            R) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-28,48})));
      parameter Modelica.SIunits.ThermalConductivity lambdaI=0.024
        "Heat conductivity";
      parameter Modelica.SIunits.Length thicknessIns=0.045
        "Thickness of pipe insulation";
      parameter Modelica.SIunits.Diameter diameter=0.089
        "Outer diameter of pipe";
      Fluid.Sensors.TemperatureTwoPort
                                senTem_p2(redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra)
        annotation (Placement(transformation(extent={{-78,60},{-58,80}})));
      Fluid.Sensors.TemperatureTwoPort
                                senTem_p3(redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra)
        annotation (Placement(transformation(extent={{10,-10},{-10,10}},
            rotation=90,
            origin={-46,-38})));
      Fluid.Sensors.TemperatureTwoPort senTemIn_p2(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra)
        annotation (Placement(transformation(extent={{-60,0},{-80,20}})));
      Fluid.Sensors.TemperatureTwoPort
                                senTem_p1(redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra)
        annotation (Placement(transformation(extent={{52,-42},{32,-22}})));
      Fluid.Sensors.TemperatureTwoPort
                                senTem_p4(redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra)
        annotation (Placement(transformation(extent={{12,62},{32,82}})));

      parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
        "Nominal mass flow rate, used for regularization near zero flow";
      parameter Modelica.SIunits.Time tauHeaTra=6500
        "Time constant for heat transfer, default 20 minutes";

      Modelica.Blocks.Logical.Switch switch
        annotation (Placement(transformation(extent={{88,94},{68,114}})));
      Modelica.Blocks.Sources.RealExpression m_flow_zero(y=0)
        annotation (Placement(transformation(extent={{138,70},{98,90}})));
      Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=-0.001)
        annotation (Placement(transformation(extent={{114,104},{108,110}})));
      Fluid.Sources.MassFlowSource_T Point5(
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        nPorts=1)           annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={64,70})));
      Modelica.Blocks.Logical.Switch switch1
        annotation (Placement(transformation(extent={{108,52},{88,72}})));
    equation
      connect(m_flow_p3.y, Point3.m_flow_in) annotation (Line(
          points={{-58,-90},{-54,-90},{-54,-80}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Point2.m_flow_in, m_flow_p2.y) annotation (Line(
          points={{-52,114},{-52,130},{-58,130}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_p1.y, Point1.T_in) annotation (Line(
          points={{60,-64},{78,-64},{78,-54}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(DataReader.y[5], Point1.m_flow_in) annotation (Line(
          points={{21,-90},{26,-90},{26,-72},{74,-72},{74,-52}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(DataReader.y[9], prescribedTemperature.T)
        annotation (Line(points={{21,-90},{30,-90},{38,-90}}, color={0,0,127}));
      connect(pip0.port_b, ExcludedBranch.ports[1])
        annotation (Line(points={{80,2},{80,16},{78,16}},
                                                  color={0,127,255}));
      connect(pip4.port_a, pip1.port_b)
        annotation (Line(points={{10,30},{10,10},{28,10}}, color={0,127,255}));
      connect(pip5.port_a, pip1.port_b)
        annotation (Line(points={{0,10},{28,10}}, color={0,127,255}));
      connect(pip1.port_a, pip0.port_b) annotation (Line(points={{48,10},{62,10},{80,
              10},{80,2}}, color={0,127,255}));
      connect(pip2.port_b, senTem_p2.port_a)
        annotation (Line(points={{-80,50},{-80,70},{-78,70}}, color={0,127,255}));
      connect(senTem_p2.port_b, Point2.ports[1]) annotation (Line(points={{-58,70},{
              -58,82},{-58,94},{-60,94}}, color={0,127,255}));
      connect(senTem_p3.port_a, pip3.port_b) annotation (Line(points={{-46,-28},{-46,
              -28},{-46,-22}}, color={0,127,255}));
      connect(senTem_p3.port_b, Point3.ports[1]) annotation (Line(points={{-46,-48},
              {-46,-48},{-46,-58},{-46,-60}}, color={0,127,255}));
      connect(pip3.port_a, pip5.port_b) annotation (Line(points={{-46,-2},{-48,-2},{
              -48,8},{-48,10},{-20,10}}, color={0,127,255}));
      connect(senTemIn_p2.port_a, pip5.port_b)
        annotation (Line(points={{-60,10},{-20,10}}, color={0,127,255}));
      connect(senTemIn_p2.port_b, pip2.port_a)
        annotation (Line(points={{-80,10},{-80,24},{-80,30}}, color={0,127,255}));
      connect(pip4.port_b, senTem_p4.port_a) annotation (Line(points={{10,50},{10,50},
              {10,72},{12,72}}, color={0,127,255}));
      connect(senTem_p4.port_b, Point4.ports[1])
        annotation (Line(points={{32,72},{32,74},{40,74},{40,78}},
                                                   color={0,127,255}));
      connect(senTem_p1.port_a, Point1.ports[1])
        annotation (Line(points={{52,-32},{82,-32}}, color={0,127,255}));
      connect(senTem_p1.port_b, pip0.port_a) annotation (Line(points={{32,-32},{32,-32},
              {32,-18},{80,-18}}, color={0,127,255}));
      connect(m_flow_zero.y,switch. u3)
        annotation (Line(points={{96,80},{96,96},{90,96}}, color={0,0,127}));
      connect(switch.u1, m_flow_p4.y) annotation (Line(points={{90,112},{114,112},{
              114,130},{132,130}}, color={0,0,127}));
      connect(Point4.m_flow_in, switch.y) annotation (Line(points={{48,98},{48,98},
              {48,104},{67,104}}, color={0,0,127}));
      connect(switch.u2, lessThreshold.y) annotation (Line(points={{90,104},{107.7,
              104},{107.7,107}}, color={255,0,255}));
      connect(lessThreshold.u, m_flow_p4.y) annotation (Line(points={{114.6,107},{
              130,107},{130,130},{132,130}}, color={0,0,127}));
      connect(Point5.m_flow_in,switch1. y)
        annotation (Line(points={{74,62},{80,62},{87,62}}, color={0,0,127}));
      connect(lessThreshold.y, switch1.u2) annotation (Line(points={{107.7,107},{
              110,107},{110,62}}, color={255,0,255}));
      connect(m_flow_p4.y, switch1.u3) annotation (Line(points={{132,130},{122,130},
              {122,54},{110,54}}, color={0,0,127}));
      connect(m_flow_zero.y, switch1.u1) annotation (Line(points={{96,80},{104,80},
              {104,70},{110,70}}, color={0,0,127}));
      connect(Point5.ports[1], senTem_p4.port_a) annotation (Line(points={{54,70},{40,
              70},{40,54},{12,54},{12,72}},            color={0,127,255}));
      connect(pip2.heatPorts, res2.port_a) annotation (Line(points={{-75.6,40.1},{-71.8,
              40.1},{-71.8,40},{-68,40}}, color={127,0,0}));
      connect(res2.port_b, col2.port_a)
        annotation (Line(points={{-48,40},{-42,40},{-42,86}}, color={191,0,0}));
      connect(pip5.heatPorts, res5.port_a) annotation (Line(points={{-10.1,14.4},{-10.1,
              30},{-28,30},{-28,38}}, color={127,0,0}));
      connect(res5.port_b, col5.port_a)
        annotation (Line(points={{-28,58},{-28,58},{-28,86}}, color={191,0,0}));
      connect(res4.port_a, pip4.heatPorts) annotation (Line(points={{-4,52},{-4,52},
              {-4,40.1},{5.6,40.1}}, color={191,0,0}));
      connect(res4.port_b, col4.port_a)
        annotation (Line(points={{-4,72},{-4,86}}, color={191,0,0}));
      connect(pip3.heatPorts, res3.port_a) annotation (Line(points={{-41.6,-12.1},{-10,
              -12.1},{-10,-20}}, color={127,0,0}));
      connect(res3.port_b, col3.port_a) annotation (Line(points={{-10,-40},{-10,-40},
              {-10,-50},{-10,-52},{6,-52}}, color={191,0,0}));
      connect(res1.port_a, pip1.heatPorts)
        annotation (Line(points={{38,20},{38,14.4},{37.9,14.4}}, color={191,0,0}));
      connect(res1.port_b, col1.port_a)
        annotation (Line(points={{38,40},{38,46},{48,46}}, color={191,0,0}));
      connect(pip0.heatPorts, res0.port_a) annotation (Line(points={{84.4,-7.9},{91.2,
              -7.9},{91.2,-8},{98,-8}}, color={127,0,0}));
      connect(res0.port_b, col0.port_a)
        annotation (Line(points={{118,-8},{128,-8}}, color={191,0,0}));
      connect(col2.port_b, col5.port_b) annotation (Line(points={{-42,106},{-42,132},
              {-28,132},{-28,106}}, color={191,0,0}));
      connect(col5.port_b, col4.port_b) annotation (Line(points={{-28,106},{-28,132},
              {-4,132},{-4,106}}, color={191,0,0}));
      connect(col4.port_b, col1.port_b) annotation (Line(points={{-4,106},{-4,132},{
              126,132},{126,46},{68,46}}, color={191,0,0}));
      connect(col1.port_b, prescribedTemperature.port) annotation (Line(points={{68,
              46},{164,46},{164,-90},{60,-90}}, color={191,0,0}));
      connect(col0.port_b, prescribedTemperature.port) annotation (Line(points={{148,
              -8},{164,-8},{164,-90},{60,-90}}, color={191,0,0}));
      connect(col3.port_b, prescribedTemperature.port) annotation (Line(points={{26,
              -52},{164,-52},{164,-90},{60,-90}}, color={191,0,0}));
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                100,100}})),
        experiment(StopTime=603900, Tolerance=1e-005),
        __Dymola_experimentSetupOutput(events=false),
        Documentation(info="<html>
<p>The example contains <a href=\"modelica://IBPSA.Experimental.Pipe.Data.PipeDataAIT151218\">experimental data</a> from a real district heating network. This data is used to validate a pipe model in <a href=\"modelica://IBPSA.Experimental.Pipe.Validation.ValidationPipeAIT\">ValidationPipeAIT</a>. This model compares its performance with the original Modelica Standard Library pipes.</p>
<p>Pipes&apos; temperatures are not initialized, thus results of outflow temperature before apprixmately the first 10000 seconds should no be considered. </p>
<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/AITTestBench.png\"/> </p>
<p><b><span style=\"color: #008000;\">Calibration</span></b> </p>
<p>To calculate the length specific thermal resistance <code><span style=\"font-family: Courier New,courier;\">R</span></code> of the pipe, the thermal resistance of the surrounding ground is added. </p>
<p><code><span style=\"font-family: Courier New,courier;\">R=1/(0.208)+1/(2*lambda_g*Modelica.Constants.pi)*log(1/0.18)</span></code> </p>
<p>Where the thermal conductivity of the ground <code><span style=\"font-family: Courier New,courier;\">lambda_g = 2.4 </span></code>W/mK. </p>
</html>",     revisions="<html>
<ul>
<li>November 28, 2016 by Bram van der Heijde:<br>Remove <code>pipVol.</code></li>
<li>August 24, 2016 by Bram van der Heijde:<br>
Implement validation with MSL pipes for comparison, based on AIT validation.</li>
<li>July 4, 2016 by Bram van der Heijde:<br>Added parameters to test the influence of allowFlowReversal and the presence of explicit volumes in the pipe.</li>
<li>January 26, 2016 by Carles Ribas:<br>First implementation. </li>
</ul>
</html>"),
        __Dymola_Commands(file=
              "Resources/Scripts/Dymola/Fluid/PlugFlowPipes/Validation/ValidationMSLAIT.mos"
            "Simulate and plot"),
        Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
        __Dymola_experimentFlags(
          Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
          Evaluate=true,
          OutputCPUtime=true,
          OutputFlatModelica=false));
    end ValidationMSLAIT;

    model ValidationMSLAIT2elements
      "Smaller discretisation. Validation pipe against data from Austrian Institute of Technology with standard library components"
      extends Modelica.Icons.Example;

      /*TODO: change nNodes for pipes. For fair comparison, n should be adapted to 
  make the Courant number close to 1, but this is only possible for a narrow 
  range of mass flow rates, which is a sstrength of the new pipe model.*/
      Fluid.Sources.MassFlowSource_T Point1(
        redeclare package Medium = Medium,
        use_T_in=true,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={82,-42})));
      package Medium = IBPSA.Media.Water;
      Fluid.Sources.MassFlowSource_T Point4(
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={40,88})));
      Fluid.Sources.MassFlowSource_T Point3(
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-46,-70})));
      Fluid.Sources.MassFlowSource_T Point2(
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={-60,104})));
      Modelica.Blocks.Sources.CombiTimeTable DataReader(table=pipeDataAIT151218.data)
        annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
      Data.PipeDataAIT151218 pipeDataAIT151218
        annotation (Placement(transformation(extent={{-30,-100},{-10,-80}})));
      Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-DataReader.y[7])
        annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
      Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-DataReader.y[8])
        annotation (Placement(transformation(extent={{174,120},{134,140}})));
      Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-DataReader.y[6])
        annotation (Placement(transformation(extent={{-100,120},{-60,140}})));
      Modelica.Blocks.Sources.RealExpression T_p1(y=DataReader.y[1])
        annotation (Placement(transformation(extent={{18,-74},{58,-54}})));
      Fluid.Sources.FixedBoundary ExcludedBranch(redeclare package Medium = Medium,
          nPorts=1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={78,26})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
        prescribedTemperature
        annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

      parameter Boolean allowFlowReversal=false
        "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)";
      Modelica.Fluid.Pipes.DynamicPipe pip0(
        nParallel=1,
        diameter=0.0825,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        length=20,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( dp_nominal(displayUnit="Pa") = 10*pip0.length, m_flow_nominal=0.3),
        nNodes=2)          annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=90,
            origin={80,-8})));
      inner Modelica.Fluid.System system
        annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
      parameter Types.ThermalResistanceLength R=1/(2*lambdaI*Modelica.Constants.pi)
          *log(0.18/0.0899) + 1/(2*2.4*Modelica.Constants.pi)*log(2/0.18);
      parameter Types.ThermalResistanceLength R80=1/(2*0.024*Modelica.Constants.pi)
          *log(0.07/0.0337) + 1/(2*2.4*Modelica.Constants.pi)*log(2/0.07);
      parameter Types.ThermalResistanceLength R_old=1/(lambdaI*2*Modelica.Constants.pi
          /Modelica.Math.log((diameter/2 + thicknessIns)/(diameter/2)));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res0[pip0.nNodes](each R=
            2*R/pip0.length)
        annotation (Placement(transformation(extent={{94,-18},{114,2}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col0(m=pip0.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={132,-8})));
      Modelica.Fluid.Pipes.DynamicPipe pip1(
        nParallel=1,
        diameter=0.0825,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        length=115,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( m_flow_nominal=0.3, dp_nominal=10*pip1.length),
        nNodes=2)          annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={38,10})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col1(m=pip1.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={104,42})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res1[pip1.nNodes](each R=
            2*R/pip1.length)
        annotation (Placement(transformation(extent={{52,32},{72,52}})));
      Modelica.Fluid.Pipes.DynamicPipe pip2(
        nParallel=1,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        length=76,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( dp_nominal=10*pip2.length, m_flow_nominal=0.3),
        diameter=0.0337 - 2*0.0032,
        nNodes=2)          annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=90,
            origin={-80,40})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col2(m=pip2.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-26,40})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res2[pip2.nNodes](each R=
            2*R80/pip2.length)
        annotation (Placement(transformation(extent={{-66,30},{-46,50}})));
      Modelica.Fluid.Pipes.DynamicPipe pip3(
        nParallel=1,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        length=38,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( dp_nominal=10*pip3.length, m_flow_nominal=0.3),
        diameter=0.0337 - 2*0.0032,
        nNodes=2)          annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=90,
            origin={-46,-12})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col3(m=pip3.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={12,-12})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res3[pip3.nNodes](each R=
            2*R80/pip3.length) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-20,-12})));
      Modelica.Fluid.Pipes.DynamicPipe pip4(
        nParallel=1,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        length=29,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( dp_nominal=10*pip4.length, m_flow_nominal=0.3),
        diameter=0.0337 - 2*0.0032,
        nNodes=2)          annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=270,
            origin={10,40})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col4(m=pip4.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-4,108})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res4[pip4.nNodes](each R=
            2*R80/pip4.length) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-4,72})));
      Modelica.Fluid.Pipes.DynamicPipe pip5(
        nParallel=1,
        diameter=0.0825,
        redeclare package Medium = Medium,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
        length=20,
        redeclare model FlowModel =
            Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow
            ( dp_nominal=10*pip5.length, m_flow_nominal=0.3),
        nNodes=2)          annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={-10,10})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector col5(m=pip5.nNodes)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-28,108})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor res5[pip5.nNodes](each R=
            2*R/pip5.length) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-28,72})));
      parameter Modelica.SIunits.ThermalConductivity lambdaI=0.024
        "Heat conductivity";
      parameter Modelica.SIunits.Length thicknessIns=0.045
        "Thickness of pipe insulation";
      parameter Modelica.SIunits.Diameter diameter=0.089
        "Outer diameter of pipe";
      Fluid.Sensors.TemperatureTwoPort
                                senTem_p2(redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra)
        annotation (Placement(transformation(extent={{-78,60},{-58,80}})));
      Fluid.Sensors.TemperatureTwoPort
                                senTem_p3(redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra)
        annotation (Placement(transformation(extent={{10,-10},{-10,10}},
            rotation=90,
            origin={-46,-38})));
      Fluid.Sensors.TemperatureTwoPort senTemIn_p2(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra)
        annotation (Placement(transformation(extent={{-60,0},{-80,20}})));
      Fluid.Sensors.TemperatureTwoPort
                                senTem_p1(redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra)
        annotation (Placement(transformation(extent={{52,-42},{32,-22}})));
      Fluid.Sensors.TemperatureTwoPort
                                senTem_p4(redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        transferHeat=true,
        tauHeaTra=tauHeaTra)
        annotation (Placement(transformation(extent={{18,54},{38,74}})));

      parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
        "Nominal mass flow rate, used for regularization near zero flow";
      parameter Modelica.SIunits.Time tauHeaTra=6500
        "Time constant for heat transfer, default 20 minutes";

      Modelica.Blocks.Logical.Switch switch
        annotation (Placement(transformation(extent={{88,94},{68,114}})));
      Modelica.Blocks.Sources.RealExpression m_flow_zero(y=0)
        annotation (Placement(transformation(extent={{138,70},{98,90}})));
      Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=-0.001)
        annotation (Placement(transformation(extent={{114,104},{108,110}})));
      Fluid.Sources.MassFlowSource_T Point5(
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        nPorts=1)           annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={64,70})));
      Modelica.Blocks.Logical.Switch switch1
        annotation (Placement(transformation(extent={{108,52},{88,72}})));
    equation
      connect(m_flow_p3.y, Point3.m_flow_in) annotation (Line(
          points={{-58,-90},{-54,-90},{-54,-80}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Point2.m_flow_in, m_flow_p2.y) annotation (Line(
          points={{-52,114},{-52,130},{-58,130}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_p1.y, Point1.T_in) annotation (Line(
          points={{60,-64},{78,-64},{78,-54}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(DataReader.y[5], Point1.m_flow_in) annotation (Line(
          points={{21,-90},{26,-90},{26,-72},{74,-72},{74,-52}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(DataReader.y[9], prescribedTemperature.T)
        annotation (Line(points={{21,-90},{30,-90},{38,-90}}, color={0,0,127}));
      connect(pip0.port_b, ExcludedBranch.ports[1])
        annotation (Line(points={{80,2},{80,16},{78,16}},
                                                  color={0,127,255}));
      connect(pip4.port_a, pip1.port_b)
        annotation (Line(points={{10,30},{10,10},{28,10}}, color={0,127,255}));
      connect(pip5.port_a, pip1.port_b)
        annotation (Line(points={{0,10},{28,10}}, color={0,127,255}));
      connect(pip1.port_a, pip0.port_b) annotation (Line(points={{48,10},{62,10},{80,
              10},{80,2}}, color={0,127,255}));
      connect(pip2.port_b, senTem_p2.port_a)
        annotation (Line(points={{-80,50},{-80,70},{-78,70}}, color={0,127,255}));
      connect(senTem_p2.port_b, Point2.ports[1]) annotation (Line(points={{-58,70},{
              -58,82},{-58,94},{-60,94}}, color={0,127,255}));
      connect(senTem_p3.port_a, pip3.port_b) annotation (Line(points={{-46,-28},{-46,
              -28},{-46,-22}}, color={0,127,255}));
      connect(senTem_p3.port_b, Point3.ports[1]) annotation (Line(points={{-46,-48},
              {-46,-48},{-46,-58},{-46,-60}}, color={0,127,255}));
      connect(pip3.port_a, pip5.port_b) annotation (Line(points={{-46,-2},{-48,-2},{
              -48,8},{-48,10},{-20,10}}, color={0,127,255}));
      connect(senTemIn_p2.port_a, pip5.port_b)
        annotation (Line(points={{-60,10},{-20,10}}, color={0,127,255}));
      connect(senTemIn_p2.port_b, pip2.port_a)
        annotation (Line(points={{-80,10},{-80,24},{-80,30}}, color={0,127,255}));
      connect(pip4.port_b, senTem_p4.port_a) annotation (Line(points={{10,50},{10,50},
              {10,64},{18,64}}, color={0,127,255}));
      connect(senTem_p4.port_b, Point4.ports[1])
        annotation (Line(points={{38,64},{38,74},{38,78},{40,78}},
                                                   color={0,127,255}));
      connect(senTem_p1.port_a, Point1.ports[1])
        annotation (Line(points={{52,-32},{82,-32}}, color={0,127,255}));
      connect(senTem_p1.port_b, pip0.port_a) annotation (Line(points={{32,-32},{32,-32},
              {32,-18},{80,-18}}, color={0,127,255}));
      connect(m_flow_zero.y,switch. u3)
        annotation (Line(points={{96,80},{96,96},{90,96}}, color={0,0,127}));
      connect(switch.u1, m_flow_p4.y) annotation (Line(points={{90,112},{114,112},{
              114,130},{132,130}}, color={0,0,127}));
      connect(Point4.m_flow_in, switch.y) annotation (Line(points={{48,98},{48,98},
              {48,104},{67,104}}, color={0,0,127}));
      connect(switch.u2, lessThreshold.y) annotation (Line(points={{90,104},{107.7,
              104},{107.7,107}}, color={255,0,255}));
      connect(lessThreshold.u, m_flow_p4.y) annotation (Line(points={{114.6,107},{
              130,107},{130,130},{132,130}}, color={0,0,127}));
      connect(Point5.m_flow_in,switch1. y)
        annotation (Line(points={{74,62},{80,62},{87,62}}, color={0,0,127}));
      connect(lessThreshold.y, switch1.u2) annotation (Line(points={{107.7,107},{
              110,107},{110,62}}, color={255,0,255}));
      connect(m_flow_p4.y, switch1.u3) annotation (Line(points={{132,130},{122,130},
              {122,54},{110,54}}, color={0,0,127}));
      connect(m_flow_zero.y, switch1.u1) annotation (Line(points={{96,80},{104,80},
              {104,70},{110,70}}, color={0,0,127}));
      connect(Point5.ports[1], senTem_p4.port_a) annotation (Line(points={{54,70},{
              40,70},{40,54},{12,54},{12,64},{18,64}}, color={0,127,255}));
      connect(pip2.heatPorts, res2.port_a) annotation (Line(points={{-75.6,40.1},{
              -71.8,40.1},{-71.8,40},{-66,40}}, color={127,0,0}));
      connect(res2.port_b, col2.port_a)
        annotation (Line(points={{-46,40},{-36,40}}, color={191,0,0}));
      connect(col5.port_a, res5.port_b)
        annotation (Line(points={{-28,98},{-28,90},{-28,82}}, color={191,0,0}));
      connect(res5.port_a, pip5.heatPorts) annotation (Line(points={{-28,62},{-28,
              54},{-10.1,54},{-10.1,14.4}}, color={191,0,0}));
      connect(res4.port_a, pip4.heatPorts)
        annotation (Line(points={{-4,62},{-4,40.1},{5.6,40.1}}, color={191,0,0}));
      connect(res4.port_b, col4.port_a)
        annotation (Line(points={{-4,82},{-4,98},{-4,98}}, color={191,0,0}));
      connect(col2.port_b, col5.port_b) annotation (Line(points={{-16,40},{-16,52},
              {-36,52},{-36,136},{-28,136},{-28,118}}, color={191,0,0}));
      connect(col5.port_b, col4.port_b) annotation (Line(points={{-28,118},{-28,118},
              {-28,134},{-28,136},{-4,136},{-4,118}}, color={191,0,0}));
      connect(pip1.heatPorts, res1.port_a)
        annotation (Line(points={{37.9,14.4},{37.9,42},{52,42}}, color={127,0,0}));
      connect(res1.port_b, col1.port_a)
        annotation (Line(points={{72,42},{84,42},{94,42}}, color={191,0,0}));
      connect(col4.port_b, col1.port_b) annotation (Line(points={{-4,118},{-4,136},
              {128,136},{128,42},{114,42}}, color={191,0,0}));
      connect(pip0.heatPorts, res0.port_a) annotation (Line(points={{84.4,-7.9},{
              89.2,-7.9},{89.2,-8},{94,-8}}, color={127,0,0}));
      connect(res0.port_b, col0.port_a)
        annotation (Line(points={{114,-8},{118,-8},{122,-8}}, color={191,0,0}));
      connect(col1.port_b, col0.port_b) annotation (Line(points={{114,42},{156,42},
              {156,-8},{142,-8}}, color={191,0,0}));
      connect(col0.port_b, prescribedTemperature.port) annotation (Line(points={{
              142,-8},{156,-8},{156,-90},{60,-90}}, color={191,0,0}));
      connect(pip3.heatPorts, res3.port_a) annotation (Line(points={{-41.6,-12.1},{
              -35.8,-12.1},{-35.8,-12},{-30,-12}}, color={127,0,0}));
      connect(res3.port_b, col3.port_a)
        annotation (Line(points={{-10,-12},{-4,-12},{2,-12}}, color={191,0,0}));
      connect(col3.port_b, prescribedTemperature.port) annotation (Line(points={{22,
              -12},{68,-12},{68,-90},{60,-90}}, color={191,0,0}));
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                100,100}})),
        experiment(StopTime=603900, Tolerance=1e-005),
        __Dymola_experimentSetupOutput(events=false),
        Documentation(info="<html>
<p>The example contains <a href=\"modelica://IBPSA.Experimental.Pipe.Data.PipeDataAIT151218\">experimental data</a> from a real district heating network. This data is used to validate a pipe model in <a href=\"modelica://IBPSA.Experimental.Pipe.Validation.ValidationPipeAIT\">ValidationPipeAIT</a>. This model compares its performance with the original Modelica Standard Library pipes.</p>
<p>Pipes&apos; temperatures are not initialized, thus results of outflow temperature before apprixmately the first 10000 seconds should no be considered. </p>
<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/AITTestBench.png\"/> </p>
<p><b><span style=\"color: #008000;\">Calibration</span></b> </p>
<p>To calculate the length specific thermal resistance <code><span style=\"font-family: Courier New,courier;\">R</span></code> of the pipe, the thermal resistance of the surrounding ground is added. </p>
<p><code><span style=\"font-family: Courier New,courier;\">R=1/(0.208)+1/(2*lambda_g*Modelica.Constants.pi)*log(1/0.18)</span></code> </p>
<p>Where the thermal conductivity of the ground <code><span style=\"font-family: Courier New,courier;\">lambda_g = 2.4 </span></code>W/mK. </p>
</html>",     revisions="<html>
<ul>
<li>November 28, 2016 by Bram van der Heijde:<br>Remove <code>pipVol.</code></li>
<li>August 24, 2016 by Bram van der Heijde:<br>
Implement validation with MSL pipes for comparison, based on AIT validation.</li>
<li>July 4, 2016 by Bram van der Heijde:<br>Added parameters to test the influence of allowFlowReversal and the presence of explicit volumes in the pipe.</li>
<li>January 26, 2016 by Carles Ribas:<br>First implementation. </li>
</ul>
</html>"),
        __Dymola_Commands(file=
              "Resources/Scripts/Dymola/Fluid/PlugFlowPipes/Validation/ValidationMSLAIT2elements.mos"
            "Simulate and plot"),
        Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
        __Dymola_experimentFlags(
          Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
          Evaluate=true,
          OutputCPUtime=true,
          OutputFlatModelica=false));
    end ValidationMSLAIT2elements;
    annotation (Documentation(info="<html>
<p>
This package contains models that validate the pipe models against measured data from real disitrct heating networks.

</p>
</html>"));
  end Validation;

  package Data "Experimental data for verification of pipe models"

    package BaseClasses "BaseClasses for data records"
    extends Modelica.Icons.BasesPackage;
      partial record PipeDataBaseDefinition
        "BaseClass for experimental data from the pipe test bench"
            extends Modelica.Icons.Record;
            parameter Integer n "Number of measurement data point";
            parameter Real[:, 1+n] data
          "Time in s | measure 1 | measure 2 | ... | measure n |";
            annotation(Documentation(info="<html>
<p>
Defines basic record of experimental data with <code>n</code> measured points. The first column corresponds to \"time\", further columns to measured data. </p>


</html>",            revisions="<html>
<ul>
<li>
Januar 19, 2016 by Carles Ribas:<br/>
Move experiment documentation to the <a href=\"modelica://IBPSA.Experimental.Pipe.Data.PipeDatauLg150801\">
specific model</a>. Add parameter <code>n</code> to facilitate use of extends clause.
</li>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add documentation about the test bench and how is conducted the experiment
</li>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>"));
      end PipeDataBaseDefinition;

      partial record PipeDataULg "Base class for ULg experimental data"
        extends PipeDataBaseDefinition;
        parameter Modelica.SIunits.Temp_C T_ini_in = 20
          "Initial temperature at inlet";
        parameter Modelica.SIunits.Temp_C T_ini_out = 20
          "Initial temperature at outlet";
        parameter Modelica.SIunits.MassFlowRate m_flowIni = 0
          "Mass flow initialization";
        annotation (Documentation(info="<html>
<p><b><span style=\"color: #008000;\">Overview</span></b> </p>
<p>This record contains information of an aproximately 15 minutes long test bench carried out at the University of Liège.</p>


<p><b><span style=\"color: #008000;\">Data structure</span></b> </p>
<p><br>Column 1: Time in s </p>
<p>Column 2: Mass flow rate in kg/s</p>
<p>Column 3: Outlet pipe temperature in °C  </p>
<p>Column 4: Outlet water temperature in °C </p>
<p>Column 5: Inlet pipe temperature in °C  </p>
<p>Column 6: Inlet water temperature in °C  </p>

<p><b><span style=\"color: #008000;\">Test procedure</span></b> </p>
<p>Before to perform a test, the water city network is pushed inside the approximately 39 meter long studied pipe during about 10 minutes to be sure that it is at the same temperature. During this time period, valves V3 and V1 are opened, the boiler is off and the valve V2 is closed.</p>
<p>
Then, the valve V1 is closed and the valve V2 and V3 are opened. The boiler is started to reach the setpoint hot water temperature. When the temperature setpoint is achieved, data starts to be recorded, the valve V1 is opened and the valve V2 is closed at the same time to supply the studied pipe in hot water. After the outlet pipe temperature is stabilized, the boiler is shut off.</p>
<p>During the test, the ambient temperature is equal to 18 °C and the mass flow rate is set to 1.245 kg/s.</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>
<p>Notice: length are approximate</p>

<p><b><span style=\"color: #008000;\">Pipe characteristics</span></b> </p>

<ul>
<li>Metal density about 7800 kg/m³</li>
<li>Specific heat capacity about 480 J/kg/K</li>
<li>Thickness 3.91 mm (Outer diameter 0.0603 m)</li>
<li>Inner diameter: 0.05248 m</li>
<li>Roughness is currently neglected</li>
<li>Initial temperature of the pipe is considered equal to the initial temperature of the water (cooliing before test)</li>
<li>Heat transfer coefficient between the pipe and the ambient is assumed at 5 W/m²/K (from internal model) due to insulation.  The pipe is insulated by Tubollt 60/13 (13mm of thickness) whose the nominal thermal coefficient is inferior 0.04. Notice the insulation is quite aged therefore the nominal thermal coefficient could be higher</li>
<li>Heat transfer coefficient between water and pipe is a function of the fluid temperature (determined by EES software)</li>
</ul>



</html>"));
      end PipeDataULg;
    end BaseClasses;

    model TestData "Example to check pipe data records"
    extends Modelica.Icons.Example;
    replaceable PipeDataAIT151218 pipeDataToBeRead constrainedby
        BaseClasses.PipeDataBaseDefinition
        annotation (Placement(transformation(extent={{-20,-8},{0,12}})));
        Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=
            pipeDataToBeRead.data)
          annotation (Placement(transformation(extent={{10,-10},{30,10}})));
    equation

          annotation (experiment(StopTime=603900, Interval=900),
          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-40,-40},{60,40}})),
          Documentation(info="<html>
    <p>Model used to visualize and check data of district heating networks</p>
</html>",       revisions="<html>
<ul>
<li>
Januar 19, 2016 by Carles Ribas:<br/>
Use replaceable data and addition of .mos file.
</li>
<li>
December 18, 2015 by Daniele Basciotti:<br/>
First implementation.
</li>
</ul>
</html>"),    __Dymola_Commands(file=
              "Resources/Scripts/Dymola/Fluid/PlugFlowPipes/Data/TestData.mos"
            "Simulate and plot"),
        __Dymola_experimentSetupOutput(events=false));
    end TestData;

    record PipeDataULg150801
      "Experimental data from ULg's pipe test bench from August 1"
      //   Column 1: Time in s
      //   Column 2: Mass flow rate in kg/s
      //   Column 3: Outlet pipe temperature in °C
      //   Column 4: Outlet water temperature in °C
      //   Column 5: Inlet pipe temperature in °C
      //   Column 6: Inlet water temperature in °C
      extends IBPSA.Fluid.PlugFlowPipes.Data.BaseClasses.PipeDataULg(
        final n=5,
        T_ini_in=16.6,
        T_ini_out=16.8,
        m_flowIni=1.245,
        data=[0,1.245,16.9,16.8,16.6,16.6; 2.87,1.245,16.9,16.8,16.6,19.7; 5.66,
            1.245,16.9,16.8,19.1,29.1; 8.78,1.245,16.9,16.8,24.1,34.9; 11.62,
            1.245,16.9,16.8,28.4,38.5; 16.06,1.245,16.9,16.8,33.7,42.4; 18.89,
            1.245,16.9,16.8,36.3,44.1; 23.02,1.245,16.8,16.8,39.2,46.2; 25.76,
            1.245,16.8,16.8,40.7,47.3; 28.58,1.245,16.8,16.8,42,48.1; 31.35,
            1.245,16.8,16.8,43,48.7; 35.12,1.245,16.8,16.8,44.2,49.3; 37.94,
            1.245,16.8,16.8,44.8,49.7; 41.47,1.245,16.8,16.8,45.5,50; 44.32,
            1.245,16.8,16.8,46,50.3; 48.91,1.245,16.8,16.7,46.6,50.6; 51.79,
            1.245,16.8,16.7,47,50.7; 55.26,1.245,16.8,16.7,47.3,50.9; 58.06,
            1.245,16.8,16.7,47.6,51; 60.9,1.245,16.8,16.7,47.8,51; 63.69,1.245,
            16.8,16.7,47.9,51.1; 66.51,1.245,16.8,16.9,48.1,51.1; 69.32,1.245,
            16.9,17.6,48.2,51.2; 72.18,1.245,17.3,18.7,48.4,51.2; 75.08,1.245,
            18,20.2,48.5,51.2; 79.48,1.245,19.7,22.8,48.6,51.2; 82.28,1.245,
            21.1,24.7,48.7,51.3; 85.11,1.245,22.7,26.6,48.8,51.3; 87.91,1.245,
            24.4,28.6,48.9,51.3; 91.75,1.245,26.7,31.2,49,51.3; 94.62,1.245,
            28.5,33,49,51.3; 97.42,1.245,30.2,34.7,49.1,51.3; 100.24,1.245,31.9,
            36.4,49.2,51.3; 103.89,1.245,33.9,38.4,49.2,51.4; 106.65,1.245,35.3,
            39.7,49.3,51.4; 109.47,1.245,36.6,41,49.4,51.4; 112.29,1.245,37.9,
            42.2,49.4,51.5; 115.73,1.245,39.2,43.5,49.5,51.4; 118.64,1.245,40.2,
            44.5,49.5,51.4; 122.07,1.245,41.3,45.5,49.6,51.4; 124.86,1.245,42.1,
            46.2,49.6,51.4; 129.45,1.245,43.2,47.2,49.6,51.4; 132.26,1.245,43.7,
            47.7,49.6,51.4; 135.81,1.245,44.3,48.3,49.6,51.4; 138.69,1.245,44.8,
            48.7,49.7,51.4; 143.32,1.245,45.4,49.3,49.7,51.4; 146.11,1.245,45.7,
            49.6,49.7,51.4; 148.98,1.245,45.9,49.8,49.8,51.4; 151.83,1.245,46.2,
            50,49.8,51.3; 154.66,1.245,46.4,50.2,49.8,51.3; 157.46,1.245,46.6,
            50.4,49.8,51.4; 160.29,1.245,46.8,50.5,49.8,51.4; 163.14,1.245,46.9,
            50.6,49.8,51.4; 165.99,1.245,47.1,50.7,49.8,51.4; 168.82,1.245,47.2,
            50.8,49.9,51.4; 172,1.245,47.3,50.9,49.9,51.3; 174.86,1.245,47.5,51,
            49.9,51.3; 179.69,1.245,47.6,51.1,49.9,51.3; 182.52,1.245,47.7,51.1,
            49.9,51.3; 187.39,1.245,47.9,51.2,49.9,51.3; 190.37,1.245,47.9,51.2,
            49.9,51.3; 195.18,1.245,48,51.3,49.9,51.2; 198.01,1.245,48.1,51.3,
            49.9,51.2; 202.82,1.245,48.2,51.3,49.9,51.2; 205.65,1.245,48.2,51.3,
            49.9,51.2; 208.48,1.245,48.3,51.4,49.9,51.2; 211.35,1.245,48.3,51.4,
            49.9,51.1; 214.23,1.245,48.3,51.4,49.9,51.1; 217.04,1.245,48.4,51.4,
            49.9,51; 219.96,1.245,48.4,51.4,49.8,51; 222.85,1.245,48.5,51.4,
            49.8,51; 225.66,1.245,48.5,51.4,49.8,51; 229.04,1.245,48.5,51.4,
            49.8,51; 231.9,1.245,48.5,51.4,49.8,51; 236.81,1.245,48.6,51.4,49.8,
            51; 240.09,1.245,48.6,51.4,49.8,51; 242.94,1.245,48.6,51.4,49.8,51;
            245.98,1.245,48.6,51.3,49.8,51; 248.95,1.245,48.6,51.4,49.8,51;
            251.79,1.245,48.6,51.3,49.8,51; 254.62,1.245,48.6,51.3,49.9,51;
            257.43,1.245,48.7,51.3,49.9,51; 260.26,1.245,48.7,51.3,49.9,51;
            263.19,1.245,48.7,51.3,49.9,51; 266.02,1.245,48.7,51.3,49.9,51;
            268.92,1.245,48.8,51.3,49.9,51; 271.79,1.245,48.8,51.3,49.9,51;
            274.72,1.245,48.8,51.3,49.9,50.9; 277.59,1.245,48.8,51.2,49.9,50.9;
            280.48,1.245,48.8,51.2,49.8,50.9; 283.38,1.245,48.8,51.2,49.8,50.9;
            286.28,1.245,48.8,51.2,49.8,50.9; 289.21,1.245,48.7,51.2,49.9,50.9;
            292.09,1.245,48.4,51.2,49.9,50.9; 295.03,1.245,48.2,51.1,49.9,50.9;
            297.93,1.245,48.2,51.1,49.9,50.9; 301.43,1.245,48.2,51.1,49.9,50.9;
            304.28,1.245,48.2,51.1,49.9,50.8; 307.77,1.245,48.3,51.1,49.9,50.8;
            310.64,1.245,48.3,51.1,49.9,50.8; 314.22,1.245,48.3,51,49.8,50.8;
            317.26,1.245,48.3,51.1,49.9,50.8; 320.19,1.245,48.3,51,49.9,50.8;
            323.13,1.245,48.2,51,49.8,50.8; 326.02,1.245,48.2,51,49.8,50.8;
            328.89,1.245,48.2,51,49.8,50.8; 331.82,1.245,48.1,51,49.8,50.7;
            334.69,1.245,48.1,51,49.8,50.7; 337.6,1.245,48,51,49.8,50.7; 340.48,
            1.245,48,51,49.8,50.7; 344.41,1.245,48,51,49.7,50.7; 347.39,1.245,
            48,51,49.7,50.6; 350.96,1.245,48.1,51,49.7,50.6; 353.86,1.245,48.1,
            50.9,49.7,50.5; 356.81,1.245,48.2,50.9,49.7,50.5; 359.71,1.245,48.3,
            50.9,49.6,50.4; 362.65,1.245,48.3,50.9,49.6,50.3; 365.57,1.245,48.4,
            50.9,49.5,50.2; 368.5,1.245,48.4,50.9,49.4,50.1; 371.47,1.245,48.4,
            50.9,49.4,50.1; 374.92,1.245,48.5,50.9,49.3,49.9; 377.85,1.245,48.5,
            50.9,49.2,49.8; 380.74,1.245,48.5,50.9,49.1,49.7; 383.68,1.245,48.5,
            50.9,49,49.6; 388.62,1.245,48.5,50.9,48.8,49.4; 392.17,1.245,48.3,
            50.9,48.7,49.2; 397.05,1.245,48.1,50.8,48.5,49; 400.45,1.245,48,
            50.8,48.4,48.9; 403.46,1.245,48,50.8,48.3,48.7; 407.07,1.245,48,
            50.8,48.2,48.6; 409.97,1.245,48,50.8,48.1,48.4; 414.48,1.245,48,
            50.8,47.9,48.2; 417.35,1.245,48,50.8,47.7,48.1; 420.94,1.245,48.1,
            50.7,47.6,47.9; 424.03,1.245,48.1,50.7,47.4,47.7; 428.41,1.245,48.2,
            50.7,47.2,47.5; 431.32,1.245,48.2,50.6,47.1,47.4; 434.74,1.245,48.2,
            50.6,47,47.2; 437.65,1.245,48.2,50.5,46.8,47; 441.25,1.245,48.2,
            50.5,46.7,46.9; 444.21,1.245,48.2,50.4,46.5,46.7; 448.77,1.245,48.2,
            50.3,46.3,46.5; 451.8,1.245,48.1,50.2,46.2,46.4; 455.31,1.245,48.1,
            50.1,46,46.2; 458.22,1.245,48,50,45.9,46; 461.69,1.245,47.9,49.9,
            45.8,45.9; 464.62,1.245,47.9,49.8,45.6,45.8; 467.58,1.245,47.7,49.7,
            45.4,44.1; 470.54,1.245,47.5,49.6,44.5,42.1; 473.5,1.245,47.2,49.5,
            43.4,40.4; 477.12,1.245,47.1,49.4,41.8,38.6; 480.24,1.245,46.9,49.3,
            40.5,37.3; 484.71,1.245,46.7,49.1,38.8,36; 487.77,1.245,46.7,48.9,
            37.9,35.2; 491.23,1.245,46.6,48.8,37,34.5; 494.22,1.245,46.5,48.7,
            36.3,34.1; 497.8,1.245,46.4,48.5,35.6,33.6; 500.82,1.245,46.4,48.4,
            35.2,33.3; 503.8,1.245,46.3,48.2,34.8,33.1; 506.8,1.245,46.2,48.1,
            34.4,32.9; 509.8,1.245,46.1,47.9,34.2,32.8; 512.77,1.245,46.1,47.8,
            33.9,32.7; 517.77,1.245,45.9,47.6,33.6,32.4; 520.73,1.245,45.8,47.4,
            33.4,32.3; 524.11,1.245,45.7,47.2,33.2,32.3; 527.04,1.245,45.5,47.1,
            33.1,32.2; 530.65,1.245,45.4,46.9,33,32.2; 533.68,1.245,45.3,46.7,
            32.9,32.3; 538.23,1.245,45,46.2,32.8,32.3; 541.3,1.245,44.8,45.7,
            32.8,32.3; 544.78,1.245,44.3,45,32.7,32.2; 547.74,1.245,43.8,44.3,
            32.7,32.1; 550.73,1.245,43.3,43.5,32.6,32.1; 553.72,1.245,42.6,42.7,
            32.6,32.1; 556.74,1.245,41.9,41.9,32.5,32.1; 559.68,1.245,41.2,41,
            32.4,32.1; 562.69,1.245,40.5,40.2,32.4,32; 565.63,1.245,39.8,39.5,
            32.4,32.1; 569.3,1.245,39,38.6,32.3,32; 572.36,1.245,38.3,37.9,32.3,
            32; 575.33,1.245,37.7,37.2,32.2,32; 578.32,1.245,37.1,36.7,32.2,32;
            583.29,1.245,36.3,35.8,32.2,31.9; 586.72,1.245,35.7,35.3,32.1,31.9;
            589.72,1.245,35.3,34.9,32.1,31.9; 592.72,1.245,35,34.5,32.1,31.9;
            595.73,1.245,34.6,34.2,32.1,31.9; 598.69,1.245,34.3,33.9,32,31.9;
            601.68,1.245,34,33.7,32,31.8; 604.67,1.245,33.7,33.5,32,31.9;
            607.66,1.245,33.5,33.3,32,31.8; 610.69,1.245,33.3,33.1,31.9,31.8;
            613.68,1.245,33.1,33,31.9,31.9; 616.59,1.245,33,32.8,31.9,31.8;
            619.55,1.245,32.9,32.7,31.9,31.8; 622.51,1.245,32.8,32.6,31.9,31.8;
            625.52,1.245,32.7,32.5,31.9,31.8; 628.55,1.245,32.6,32.5,31.8,31.8;
            631.56,1.245,32.5,32.4,31.8,31.8; 634.57,1.245,32.4,32.3,31.8,31.7;
            637.56,1.245,32.4,32.3,31.8,31.7; 640.57,1.245,32.3,32.2,31.8,31.7;
            643.58,1.245,32.2,32.2,31.8,31.8; 646.65,1.245,32.2,32.2,31.8,31.8;
            649.68,1.245,32.1,32.1,31.7,31.7; 652.63,1.245,32.1,32.1,31.7,31.7;
            655.61,1.245,32,32.1,31.7,31.7; 658.64,1.245,32,32.1,31.7,31.7;
            661.59,1.245,32,32,31.7,31.7; 664.6,1.245,31.9,32,31.6,31.6; 669.59,
            1.245,31.9,32,31.6,31.5; 672.71,1.245,31.8,31.9,31.6,31.6; 676.16,
            1.245,31.8,31.9,31.5,31.6; 679.15,1.245,31.8,31.9,31.5,31.6; 682.64,
            1.245,31.7,31.9,31.5,31.5; 685.63,1.245,31.7,31.9,31.5,31.5; 689.1,
            1.245,31.7,31.9,31.5,31.6; 692.12,1.245,31.7,31.9,31.5,31.6; 695.58,
            1.245,31.6,31.8,31.5,31.6; 698.51,1.245,31.6,31.8,31.5,31.7; 701.49,
            1.245,31.6,31.8,31.5,31.6; 704.57,1.245,31.6,31.8,31.5,31.7; 707.62,
            1.245,31.5,31.8,31.5,31.6; 710.64,1.245,31.5,31.8,31.5,31.6; 713.66,
            1.245,31.5,31.8,31.5,31.6; 716.79,1.245,31.5,31.8,31.5,31.5; 719.8,
            1.245,31.5,31.8,31.5,31.6; 723.24,1.245,31.4,31.8,31.5,31.5; 726.27,
            1.245,31.4,31.7,31.4,31.6; 729.29,1.245,31.4,31.7,31.4,31.5; 732.37,
            1.245,31.3,31.7,31.4,31.5; 735.38,1.245,31.3,31.7,31.4,31.5; 740.46,
            1.245,31.3,31.7,31.4,31.4; 743.49,1.245,31.3,31.7,31.3,31.4; 746.57,
            1.245,31.3,31.7,31.3,31.4; 749.61,1.245,31.3,31.6,31.3,31.4; 752.7,
            1.245,31.2,31.6,31.3,31.4; 755.79,1.245,31.2,31.6,31.3,31.3; 758.85,
            1.245,31.2,31.6,31.2,31.3; 761.85,1.245,31.2,31.6,31.3,31.4; 764.89,
            1.245,31.2,31.6,31.3,31.4; 767.92,1.245,31.2,31.6,31.2,31.4; 771.02,
            1.245,31.2,31.6,31.2,31.3; 774.1,1.245,31.1,31.6,31.2,31.2; 777.69,
            1.245,31.1,31.6,31.2,31.3; 780.74,1.245,31.1,31.6,31.1,31.2; 783.8,
            1.245,31,31.6,31.1,31.2; 787.46,1.245,30.9,31.6,31.1,31.1; 790.57,
            1.245,30.9,31.6,31.1,31.1; 793.69,1.245,30.9,31.6,31,31.1; 796.65,
            1.245,30.9,31.6,31,31; 801.69,1.245,31,31.5,30.9,30.9; 804.73,1.245,
            31,31.5,30.9,31; 807.75,1.245,30.9,31.5,30.9,30.9; 810.77,1.245,
            30.9,31.5,30.8,30.9; 813.81,1.245,30.9,31.5,30.8,30.9; 816.89,1.245,
            30.9,31.5,30.8,30.8; 819.98,1.245,30.9,31.5,30.8,30.8; 823.08,1.245,
            30.9,31.5,30.7,30.8; 826.12,1.245,30.9,31.4,30.7,30.8; 829.19,1.245,
            30.9,31.4,30.7,30.8; 832.28,1.245,30.9,31.4,30.6,30.7; 835.76,1.245,
            30.8,31.4,30.6,30.7; 838.85,1.245,30.8,31.4,30.6,30.6; 842.51,1.245,
            30.8,31.4,30.6,30.6; 845.73,1.245,30.8,31.4,30.5,30.5; 849.26,1.245,
            30.8,31.3,30.5,30.5; 854.41,1.245,30.8,31.3,30.4,30.5; 857.49,1.245,
            30.7,31.3,30.4,30.4; 860.56,1.245,30.7,31.3,30.3,30.3; 865.68,1.245,
            30.7,31.2,30.3,30.2; 868.77,1.245,30.7,31.2,30.2,30.2; 871.8,1.245,
            30.6,31.2,30.1,30.1; 874.88,1.245,30.6,31.1,30.1,30.1]);
      annotation (Documentation(revisions="<html>
  <ul>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add some information about the test.
</li>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>",     info="<html>
<p><b><span style=\"color: #008000;\">Overview</span></b> </p>
<p>This record contains information of an aproximately 15 minutes long test bench carried out at the University of Liège.</p>


<p><b><span style=\"color: #008000;\">Data structure</span></b> </p>
<p><br>Column 1: Time in s </p>
<p>Column 2: Mass flow rate in kg/s</p>
<p>Column 3: Outlet pipe temperature in °C  </p>
<p>Column 4: Outlet water temperature in °C </p>
<p>Column 5: Inlet pipe temperature in °C  </p>
<p>Column 6: Inlet water temperature in °C  </p>

<p><b><span style=\"color: #008000;\">Test procedure</span></b> </p>
<p>Before to perform a test, the water city network is pushed inside the approximately 39 meter long studied pipe during about 10 minutes to be sure that it is at the same temperature. During this time period, valves V3 and V1 are opened, the boiler is off and the valve V2 is closed.</p>
<p>
Then, the valve V1 is closed and the valve V2 and V3 are opened. The boiler is started to reach the setpoint hot water temperature. When the temperature setpoint is achieved, data starts to be recorded, the valve V1 is opened and the valve V2 is closed at the same time to supply the studied pipe in hot water. After the outlet pipe temperature is stabilized, the boiler is shut off.</p>
<p>During the test, the ambient temperature is equal to 18 °C and the mass flow rate is set to 1.245 kg/s.</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>
<p>Notice: length are approximate</p>

<p><b><span style=\"color: #008000;\">Pipe characteristics</span></b> </p>

<ul>
<li>Metal density about 7800 kg/m³</li>
<li>Specific heat capacity about 480 J/kg/K</li>
<li>Thickness 3.91 mm (Outer diameter 0.0603 m)</li>
<li>Inner diameter: 0.05248 m</li>
<li>Roughness is currently neglected</li>
<li>Initial temperature of the pipe is considered equal to the initial temperature of the water (cooliing before test)</li>
<li>Heat transfer coefficient between the pipe and the ambient is assumed at 5 W/m²/K (from internal model) due to insulation.  The pipe is insulated by Tubollt 60/13 (13mm of thickness) whose the nominal thermal coefficient is inferior 0.04. Notice the insulation is quite aged therefore the nominal thermal coefficient could be higher</li>
<li>Heat transfer coefficient between water and pipe is a function of the fluid temperature (determined by EES software)</li>
</ul>



</html>"));
    end PipeDataULg150801;

    record PipeDataULg151202
      "Experimental data from ULg's pipe test bench from December 2, 2015"
      extends IBPSA.Fluid.PlugFlowPipes.Data.BaseClasses.PipeDataULg(
        final n=5,
        T_ini_out=18.2,
        T_ini_in=18.8,
        m_flowIni=0.589,
        data=[0,0.589,0,18.2,18.7,18.8; 3.1,0.589,0,18.2,19.2,28; 6.4,0.589,0,
            18.2,21.6,34.7; 11.5,0.589,0,18.2,26.7,41.4; 14.6,0.589,0,18.2,29.6,
            43.9; 17.9,0.589,0,18.2,32.3,45.8; 21,0.589,0,18.3,34.6,47.2; 24.1,
            0.589,0,18.3,36.6,48.2; 27.3,0.589,0,18.3,38.3,49; 30.4,0.589,0,
            18.3,39.8,49.6; 33.6,0.589,0,18.3,41.1,50.1; 36.7,0.589,0,18.3,42.2,
            50.4; 39.9,0.589,0,18.2,43.2,50.7; 43.1,0.589,0,18.2,44,50.9; 46.2,
            0.589,0,18.2,44.8,51.1; 49.3,0.589,0,18.2,45.4,51.3; 52.6,0.589,0,
            18.2,46,51.4; 55.7,0.589,0,18.2,46.5,51.5; 59.9,0.589,0,18.3,47.1,
            51.7; 63,0.589,0,18.3,47.5,51.8; 66,0.589,0,18.3,47.8,51.8; 69.2,
            0.589,0,18.3,48.1,51.8; 72.3,0.589,0,18.3,48.3,51.9; 77.4,0.589,0,
            18.3,48.7,51.9; 80.6,0.589,0,18.3,48.8,51.9; 83.7,0.589,0,18.3,49,
            51.9; 86.8,0.589,0,18.3,49.2,52; 90.1,0.589,0,18.2,49.3,52; 93.3,
            0.589,0,18.3,49.5,52; 96.5,0.589,0,18.3,49.6,52.1; 99.5,0.589,0,
            18.3,49.8,52.1; 102.8,0.589,0,18.2,49.9,52.1; 106,0.589,0,18.3,50,
            52.2; 109.2,0.589,0,18.3,50.1,52.2; 114.3,0.589,0,18.3,50.3,52.3;
            117.4,0.589,0,18.3,50.3,52.3; 120.5,0.589,0,18.2,50.4,52.3; 125.7,
            0.589,0,18.2,50.4,52.2; 128.8,0.589,0,18.2,50.5,52.3; 131.9,0.589,0,
            18.3,50.5,52.3; 135,0.589,0,18.3,50.6,52.2; 138.1,0.589,0,18.6,50.6,
            52.2; 141.4,0.589,0,19,50.6,52.2; 144.5,0.589,0,19.6,50.6,52.2;
            147.9,0.589,0,20.3,50.7,52.2; 151,0.589,0,21.2,50.7,52.2; 154.4,
            0.589,0,22.2,50.8,52.2; 157.5,0.589,0,23.2,50.8,52.3; 161,0.589,0,
            24.5,50.9,52.3; 164.1,0.589,0,25.6,50.9,52.3; 167.4,0.589,0,26.9,51,
            52.3; 170.5,0.589,0,28.1,51,52.3; 173.8,0.589,0,29.4,51,52.3; 177,
            0.589,0,30.6,51,52.3; 180,0.589,0,31.8,51,52.3; 183.4,0.589,0,33,
            51.1,52.3; 186.5,0.589,0,34.2,51,52.3; 189.5,0.589,0,35.4,51.1,52.3;
            192.7,0.589,0,36.5,51.1,52.3; 195.9,0.589,0,37.6,51.1,52.4; 199,
            0.589,0,38.7,51.2,52.4; 202.2,0.589,0,39.7,51.2,52.4; 205.3,0.589,0,
            40.6,51.2,52.4; 208.4,0.589,0,41.5,51.2,52.4; 211.6,0.589,0,42.4,
            51.2,52.4; 214.8,0.589,0,43.1,51.2,52.4; 218,0.589,0,43.9,51.2,52.4;
            221.2,0.589,0,44.6,51.2,52.4; 224.3,0.589,0,45.3,51.3,52.4; 227.5,
            0.589,0,45.9,51.3,52.4; 230.6,0.589,0,46.4,51.3,52.4; 233.8,0.589,0,
            47,51.3,52.4; 237,0.589,0,47.5,51.3,52.4; 240.1,0.589,0,47.9,51.4,
            52.4; 243.2,0.589,0,48.3,51.4,52.5; 246.4,0.589,0,48.7,51.4,52.5;
            249.6,0.589,0,49,51.4,52.5; 252.8,0.589,0,49.4,51.4,52.5; 256,0.589,
            0,49.6,51.4,52.5; 259.1,0.589,0,49.9,51.5,52.5; 262.5,0.589,0,50.1,
            51.5,52.5; 265.7,0.589,0,50.3,51.5,52.5; 268.9,0.589,0,50.5,51.5,
            52.5; 273.2,0.589,0,50.8,51.5,52.5; 276.4,0.589,0,50.9,51.5,52.5;
            279.5,0.589,0,51,51.5,52.5; 282.9,0.589,0,51.2,51.5,52.4; 286.1,
            0.589,0,51.3,51.5,52.5; 290.4,0.589,0,51.4,51.5,52.5; 293.6,0.589,0,
            51.5,51.5,52.4; 296.9,0.589,0,51.5,51.5,52.4; 300.1,0.589,0,51.6,
            51.5,52.4; 303.3,0.589,0,51.7,51.5,52.4; 306.5,0.589,0,51.7,51.5,
            52.4; 309.7,0.589,0,51.7,51.5,52.4; 312.9,0.589,0,51.7,51.5,52.4;
            316.1,0.589,0,51.8,51.5,52.4; 319.3,0.589,0,51.8,51.5,52.4; 322.4,
            0.589,0,51.9,51.5,52.4; 327.6,0.589,0,51.9,51.5,52.3; 330.7,0.589,0,
            51.9,51.5,52.3; 333.9,0.589,0,51.9,51.5,52.3; 337.2,0.589,0,51.9,
            51.5,52.3; 340.4,0.589,0,51.9,51.5,52.4; 343.6,0.589,0,52,51.5,52.4;
            346.8,0.589,0,52,51.5,52.4; 350,0.589,0,52.1,51.6,52.4; 353.2,0.589,
            0,52.1,51.6,52.5; 356.4,0.589,0,52.1,51.6,52.5; 359.6,0.589,0,52.1,
            51.6,52.5; 363.1,0.589,0,52.1,51.6,52.4; 366.3,0.589,0,52.1,51.6,
            52.4; 369.5,0.589,0,52.1,51.6,52.4; 372.6,0.589,0,52.1,51.6,52.4;
            375.8,0.589,0,52.1,51.6,52.4; 379,0.589,0,52.1,51.6,52.4; 382.2,
            0.589,0,52.1,51.6,52.4; 385.4,0.589,0,52.1,51.6,52.4; 388.8,0.589,0,
            52.1,51.6,52.4; 392,0.589,0,52.1,51.6,52.4; 395.2,0.589,0,52.1,51.6,
            52.4; 398.4,0.589,0,52.1,51.6,52.4; 401.7,0.589,0,52.2,51.6,52.4;
            404.9,0.589,0,52.1,51.6,52.4; 408.2,0.589,0,52.1,51.6,52.4; 411.5,
            0.589,0,52.1,51.6,52.4; 414.7,0.589,0,52.1,51.6,52.4; 418,0.589,0,
            52.1,51.6,52.4; 421.5,0.589,0,52.1,51.6,52.4; 424.6,0.589,0,52.1,
            51.6,52.4; 428,0.589,0,52.1,51.6,52.4; 431.1,0.589,0,52.1,51.6,52.4;
            434.6,0.589,0,52.1,51.6,52.4; 437.9,0.589,0,52.1,51.6,52.4; 441,
            0.589,0,52.2,51.6,52.4; 444.2,0.589,0,52.1,51.6,52.4; 447.5,0.589,0,
            52.1,51.6,52.4; 450.7,0.589,0,52.1,51.6,52.4; 454.1,0.589,0,52.1,
            51.6,52.4; 457.2,0.589,0,52.1,51.6,52.4; 460.5,0.589,0,52.1,51.6,
            52.4; 463.8,0.589,0,52.1,51.6,52.4; 467.1,0.589,0,52.1,51.6,52.4;
            470.5,0.589,0,52.1,51.6,52.4; 473.9,0.589,0,52.2,51.7,52.5; 477.2,
            0.589,0,52.2,51.8,52.5; 480.5,0.589,0,52.3,51.8,52.6; 484,0.589,0,
            52.3,51.8,52.6; 487.2,0.589,0,52.3,51.9,52.6; 492.2,0.589,0,52.3,
            51.9,52.6; 495.4,0.589,0,52.3,51.9,52.6; 500.8,0.589,0,52.3,51.9,
            52.6; 504.1,0.589,0,52.3,51.9,52.6; 507.3,0.589,0,52.3,51.9,52.5;
            510.7,0.589,0,52.3,51.8,52.5; 513.9,0.589,0,52.3,51.8,52.5; 517.2,
            0.589,0,52.3,51.8,52.5; 520.4,0.589,0,52.3,51.8,52.5; 523.8,0.589,0,
            52.3,51.8,52.5; 527.1,0.589,0,52.3,51.8,52.6; 530.5,0.589,0,52.3,
            51.8,52.6; 533.8,0.589,0,52.3,51.9,52.6; 537,0.589,0,52.3,51.9,52.6;
            540.2,0.589,0,52.3,51.9,52.6; 543.6,0.589,0,52.4,51.9,52.6; 546.8,
            0.589,0,52.4,51.9,52.6; 551.2,0.589,0,52.4,51.9,52.6; 554.4,0.589,0,
            52.4,51.9,52.6; 557.7,0.589,0,52.4,51.9,52.6; 561.1,0.589,0,52.3,
            51.9,52.6; 564.3,0.589,0,52.3,51.9,52.5; 567.8,0.589,0,52.3,51.8,
            52.4; 571.1,0.589,0,52.3,51.8,52.4; 574.5,0.589,0,52.2,51.7,52.4;
            577.7,0.589,0,52.2,51.7,52.3; 581,0.589,0,52.3,51.7,52.3; 584.3,
            0.589,0,52.2,51.7,52.3; 587.7,0.589,0,52.2,51.7,52.2; 590.9,0.589,0,
            52.3,51.7,52.2]);
      annotation (Documentation(revisions="<html>
  <ul>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add some information about the test.
</li>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>",     info="<html>
<p><b><span style=\"color: #008000;\">Overview</span></b> </p>
<p>This record contains information of an aproximately 15 minutes long test bench carried out at the University of Liège.</p>


<p><b><span style=\"color: #008000;\">Data structure</span></b> </p>
<p><br>Column 1: Time in s </p>
<p>Column 2: Mass flow rate in kg/s</p>
<p>Column 3: Outlet pipe temperature in °C  </p>
<p>Column 4: Outlet water temperature in °C </p>
<p>Column 5: Inlet pipe temperature in °C  </p>
<p>Column 6: Inlet water temperature in °C  </p>

<p><b><span style=\"color: #008000;\">Test procedure</span></b> </p>
<p>Before to perform a test, the water city network is pushed inside the approximately 39 meter long studied pipe during about 10 minutes to be sure that it is at the same temperature. During this time period, valves V3 and V1 are opened, the boiler is off and the valve V2 is closed.</p>
<p>
Then, the valve V1 is closed and the valve V2 and V3 are opened. The boiler is started to reach the setpoint hot water temperature. When the temperature setpoint is achieved, data starts to be recorded, the valve V1 is opened and the valve V2 is closed at the same time to supply the studied pipe in hot water. After the outlet pipe temperature is stabilized, the boiler is shut off.</p>
<p>During the test, the ambient temperature is equal to 18 °C and the mass flow rate is set to 1.245 kg/s.</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>
<p>Notice: length are approximate</p>

<p><b><span style=\"color: #008000;\">Pipe characteristics</span></b> </p>

<ul>
<li>Metal density about 7800 kg/m³</li>
<li>Specific heat capacity about 480 J/kg/K</li>
<li>Thickness 3.91 mm (Outer diameter 0.0603 m)</li>
<li>Inner diameter: 0.05248 m</li>
<li>Roughness is currently neglected</li>
<li>Initial temperature of the pipe is considered equal to the initial temperature of the water (cooliing before test)</li>
<li>Heat transfer coefficient between the pipe and the ambient is assumed at 5 W/m²/K (from internal model) due to insulation.  The pipe is insulated by Tubollt 60/13 (13mm of thickness) whose the nominal thermal coefficient is inferior 0.04. Notice the insulation is quite aged therefore the nominal thermal coefficient could be higher</li>
<li>Heat transfer coefficient between water and pipe is a function of the fluid temperature (determined by EES software)</li>
</ul>



</html>"));
    end PipeDataULg151202;

    record PipeDataULg151204_1
      "Experimental data from ULg's pipe test bench from December 4, 2015 (1); 
  increase followed by a decrease in temperature"
      extends IBPSA.Fluid.PlugFlowPipes.Data.BaseClasses.PipeDataULg(
        final n=5,
        T_ini_out=14.0,
        T_ini_in=14.0,
        m_flowIni=1.618,
        data=[0,1.618,14.4,14,14.2,14; 2.9,1.618,14.4,14,14.3,16.8; 5.8,1.618,
            14.4,14,15.5,20.5; 8.7,1.618,14.4,14.1,17.3,22.9; 11.6,1.618,14.4,
            14.1,19,24.6; 14.5,1.618,14.4,14.1,20.5,25.8; 17.3,1.618,14.4,14.1,
            21.8,26.7; 20.2,1.618,14.4,14.1,22.9,27.4; 23.2,1.618,14.4,14.2,
            23.8,27.9; 26.2,1.618,14.4,14.2,24.6,28.3; 29.2,1.618,14.5,14.3,
            25.3,28.6; 32.3,1.618,14.5,14.3,25.8,28.9; 35.2,1.618,14.5,14.3,
            26.3,29.1; 38.1,1.618,14.5,14.2,26.7,29.3; 41,1.618,14.5,14.2,27,
            29.4; 43.9,1.618,14.4,14.2,27.3,29.5; 47,1.618,14.4,14.2,27.6,29.6;
            50.5,1.618,14.4,14.2,27.9,29.7; 53.5,1.618,14.4,14.3,28,29.8; 56.4,
            1.618,14.5,14.8,28.2,29.9; 59.2,1.618,14.8,15.7,28.3,29.9; 63.6,
            1.618,15.8,17.2,28.5,29.9; 66.6,1.618,16.6,18.2,28.6,29.9; 69.5,
            1.618,17.5,19.3,28.7,29.9; 72.4,1.618,18.5,20.4,28.8,29.9; 76.4,
            1.618,19.8,21.8,28.9,30; 79.3,1.618,20.7,22.7,28.9,30; 82.2,1.618,
            21.6,23.6,29,30; 85.1,1.618,22.4,24.4,29,30; 88,1.618,23.2,25.1,
            29.1,30; 92.7,1.618,24.2,26.1,29.2,30.1; 95.7,1.618,24.8,26.7,29.2,
            30.1; 98.6,1.618,25.3,27.1,29.3,30.1; 101.5,1.618,25.8,27.5,29.3,
            30.2; 105.5,1.618,26.3,28,29.4,30.2; 108.5,1.618,26.6,28.4,29.4,
            30.2; 111.4,1.618,26.9,28.6,29.4,30.2; 114.3,1.618,27.2,28.8,29.5,
            30.2; 117.3,1.618,27.4,29,29.5,30.2; 120.2,1.618,27.6,29.2,29.5,
            30.1; 123.1,1.618,27.7,29.3,29.5,30.1; 126,1.618,27.9,29.4,29.5,
            30.1; 129,1.618,28,29.5,29.5,30.1; 131.9,1.618,28.1,29.6,29.5,30.1;
            134.9,1.618,28.2,29.7,29.5,30.1; 137.8,1.618,28.3,29.7,29.5,30.1;
            141,1.618,28.4,29.8,29.6,30.2; 143.8,1.618,28.5,29.9,29.6,30.2;
            146.8,1.618,28.5,29.9,29.6,30.2; 149.8,1.618,28.6,30,29.6,30.2;
            152.7,1.618,28.6,30,29.6,30.3; 155.7,1.618,28.7,30,29.7,30.3; 158.6,
            1.618,28.7,30,29.7,30.3; 161.5,1.618,28.8,30.1,29.7,30.3; 164.6,
            1.618,28.8,30.1,29.7,30.3; 167.5,1.618,28.8,30.1,29.7,30.3; 170.5,
            1.618,28.9,30.1,29.8,30.3; 173.4,1.618,28.9,30.1,29.8,30.3; 176.3,
            1.618,28.9,30.2,29.8,30.3; 179.3,1.618,29,30.2,29.8,30.3; 182.2,
            1.618,29,30.2,29.8,30.3; 185.1,1.618,29,30.2,29.8,30.3; 188.1,1.618,
            29,30.2,29.8,30.3; 191,1.618,29,30.2,29.8,30.3; 194,1.618,29,30.2,
            29.8,30.3; 196.9,1.618,29,30.2,29.8,30.3; 199.8,1.618,29.1,30.2,
            29.8,30.3; 202.8,1.618,29.1,30.2,29.8,30.3; 205.7,1.618,29.1,30.2,
            29.8,30.3; 208.7,1.618,29.1,30.2,29.8,30.3; 211.6,1.618,29.1,30.2,
            29.8,30.3; 214.6,1.618,29.1,30.2,29.8,30.3; 218.7,1.618,29.2,30.3,
            29.8,30.3; 221.7,1.618,29.2,30.3,29.9,30.3; 225.6,1.618,29.2,30.3,
            29.9,30.3; 228.6,1.618,29.2,30.3,29.8,30.3; 233.6,1.618,29.3,30.3,
            29.9,30.3; 236.5,1.618,29.3,30.3,29.9,30.3; 239.4,1.618,29.3,30.3,
            29.9,30.3; 242.4,1.618,29.3,30.3,29.9,30.3; 245.7,1.618,29.3,30.3,
            29.9,30.3; 248.7,1.618,29.3,30.3,29.9,30.3; 251.6,1.618,29.3,30.3,
            29.9,30.4; 254.5,1.618,29.3,30.3,30,30.4; 257.4,1.618,29.3,30.3,30,
            30.4; 260.4,1.618,29.3,30.3,30,30.4; 265.5,1.618,29.4,30.3,30,30.3;
            268.4,1.618,29.4,30.3,30,30.3; 271.6,1.618,29.4,30.3,30,30.3; 274.6,
            1.618,29.4,30.3,30,30.3; 277.7,1.618,29.4,30.3,30,30.4; 281.4,1.618,
            29.4,30.3,30,30.4; 284.4,1.618,29.4,30.3,30,30.4; 289.3,1.618,29.4,
            30.3,30,30.4; 292.3,1.618,29.4,30.3,30,30.4; 295.2,1.618,29.4,30.3,
            30,30.3; 298.1,1.618,29.4,30.3,30,30.4; 301.1,1.618,29.4,30.3,30,
            30.3; 304,1.618,29.4,30.3,30,30.3; 307,1.618,29.5,30.3,30,30.3;
            310.1,1.618,29.5,30.3,30,30.3; 313,1.618,29.5,30.4,30,30.3; 317.1,
            1.618,29.5,30.4,30,30.3; 320.1,1.618,29.5,30.4,30,30.3; 323,1.618,
            29.5,30.3,30,30.3; 325.9,1.618,29.5,30.4,30,30.4; 330.1,1.618,29.5,
            30.4,30,30.3; 333.1,1.618,29.5,30.4,30,30.3; 336,1.618,29.5,30.4,30,
            30.4]);
      annotation (Documentation(revisions="<html>
  <ul>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add some information about the test.
</li>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>",     info="<html>
<p><b><span style=\"color: #008000;\">Overview</span></b> </p>
<p>This record contains information of an aproximately 15 minutes long test bench carried out at the University of Liège.</p>


<p><b><span style=\"color: #008000;\">Data structure</span></b> </p>
<p><br>Column 1: Time in s </p>
<p>Column 2: Mass flow rate in kg/s</p>
<p>Column 3: Outlet pipe temperature in °C  </p>
<p>Column 4: Outlet water temperature in °C </p>
<p>Column 5: Inlet pipe temperature in °C  </p>
<p>Column 6: Inlet water temperature in °C  </p>

<p><b><span style=\"color: #008000;\">Test procedure</span></b> </p>
<p>Before to perform a test, the water city network is pushed inside the approximately 39 meter long studied pipe during about 10 minutes to be sure that it is at the same temperature. During this time period, valves V3 and V1 are opened, the boiler is off and the valve V2 is closed.</p>
<p>
Then, the valve V1 is closed and the valve V2 and V3 are opened. The boiler is started to reach the setpoint hot water temperature. When the temperature setpoint is achieved, data starts to be recorded, the valve V1 is opened and the valve V2 is closed at the same time to supply the studied pipe in hot water. After the outlet pipe temperature is stabilized, the boiler is shut off.</p>
<p>During the test, the ambient temperature is equal to 18 °C and the mass flow rate is set to 1.245 kg/s.</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>
<p>Notice: length are approximate</p>

<p><b><span style=\"color: #008000;\">Pipe characteristics</span></b> </p>

<ul>
<li>Metal density about 7800 kg/m³</li>
<li>Specific heat capacity about 480 J/kg/K</li>
<li>Thickness 3.91 mm (Outer diameter 0.0603 m)</li>
<li>Inner diameter: 0.05248 m</li>
<li>Roughness is currently neglected</li>
<li>Initial temperature of the pipe is considered equal to the initial temperature of the water (cooliing before test)</li>
<li>Heat transfer coefficient between the pipe and the ambient is assumed at 5 W/m²/K (from internal model) due to insulation.  The pipe is insulated by Tubollt 60/13 (13mm of thickness) whose the nominal thermal coefficient is inferior 0.04. Notice the insulation is quite aged therefore the nominal thermal coefficient could be higher</li>
<li>Heat transfer coefficient between water and pipe is a function of the fluid temperature (determined by EES software)</li>
</ul>



</html>"));
    end PipeDataULg151204_1;

    record PipeDataULg151204_2
      "Experimental data from ULg's pipe test bench from December 4, 2015 (2)"
      extends IBPSA.Fluid.PlugFlowPipes.Data.BaseClasses.PipeDataULg(
        final n=5,
        T_ini_out=14.3,
        T_ini_in=14.7,
        m_flowIni=1.251,
        data=[0,1.251,14.7,14.3,14.4,14.7; 4.7,1.251,14.7,14.3,15.4,20.7; 9.6,
            1.251,14.6,14.3,17.8,24.1; 14.3,1.251,14.7,14.4,19.9,25.9; 19.2,
            1.251,14.6,14.3,21.8,27; 23.9,1.251,14.6,14.3,23.2,27.8; 28.6,1.251,
            14.6,14.3,24.3,28.3; 33.5,1.251,14.6,14.3,25.2,28.6; 38.2,1.251,
            14.6,14.3,25.9,28.9; 42.9,1.251,14.6,14.3,26.4,29; 47.4,1.251,14.6,
            14.2,26.8,29.1; 52.4,1.251,14.5,14.2,27.2,29.2; 57,1.251,14.4,14.1,
            27.5,29.3; 61.7,1.251,14.4,14,27.7,29.3; 66.5,1.251,14.3,14,27.9,
            29.3; 71.3,1.251,14.4,14.7,28.1,29.4; 76.3,1.251,15,15.9,28.2,29.4;
            80.8,1.251,15.9,17.2,28.3,29.4; 85.4,1.251,17,18.6,28.4,29.4; 90.2,
            1.251,18.2,20.1,28.4,29.4; 94.8,1.251,19.5,21.4,28.5,29.4; 99.5,
            1.251,20.7,22.7,28.6,29.4; 104.3,1.251,21.9,23.9,28.6,29.4; 108.9,
            1.251,22.9,24.8,28.7,29.4; 113.7,1.251,23.8,25.7,28.7,29.4; 118.4,
            1.251,24.5,26.4,28.8,29.5; 123.2,1.251,25.2,27,28.8,29.5; 127.9,
            1.251,25.7,27.5,28.8,29.5; 132.6,1.251,26.2,27.9,28.9,29.5; 137.4,
            1.251,26.6,28.2,28.9,29.5; 142.1,1.251,26.9,28.5,28.9,29.5; 147.1,
            1.251,27.2,28.7,28.9,29.5; 151.7,1.251,27.4,28.9,28.9,29.5; 156.8,
            1.251,27.5,29,29,29.5; 161.4,1.251,27.7,29.1,29,29.5; 166.3,1.251,
            27.8,29.2,29,29.5; 171.2,1.251,27.9,29.2,29,29.4; 176,1.251,28,29.3,
            29,29.4; 180.8,1.251,28.1,29.3,29,29.5; 185.5,1.251,28.1,29.4,29,
            29.5; 190.1,1.251,28.2,29.4,29,29.5; 195,1.251,28.2,29.4,29,29.5;
            200,1.251,28.3,29.4,29.1,29.5; 204.7,1.251,28.3,29.5,29.1,29.5;
            209.5,1.251,28.4,29.5,29.1,29.5; 214.3,1.251,28.4,29.5,29.1,29.5;
            219.1,1.251,28.4,29.5,29.1,29.5; 223.8,1.251,28.5,29.5,29.1,29.5;
            228.5,1.251,28.5,29.5,29.1,29.6; 233.3,1.251,28.5,29.5,29.1,29.6;
            237.8,1.251,28.5,29.5,29.2,29.5; 242.5,1.251,28.5,29.5,29.1,29.5;
            247.2,1.251,28.5,29.5,29.2,29.6; 251.9,1.251,28.5,29.5,29.2,29.5;
            256.6,1.251,28.5,29.5,29.2,29.5; 261.2,1.251,28.6,29.5,29.2,29.5;
            266,1.251,28.6,29.5,29.2,29.5; 270.8,1.251,28.6,29.5,29.2,29.5;
            275.5,1.251,28.6,29.5,29.2,29.5; 280.3,1.251,28.6,29.5,29.2,29.6;
            284.8,1.251,28.6,29.5,29.2,29.6; 289.5,1.251,28.6,29.5,29.2,29.6;
            294.2,1.251,28.6,29.5,29.2,29.6; 298.9,1.251,28.7,29.5,29.2,29.6;
            303.6,1.251,28.7,29.5,29.2,29.6; 308.3,1.251,28.7,29.5,29.2,29.6;
            313.1,1.251,28.7,29.5,29.3,29.6; 317.9,1.251,28.7,29.5,29.2,29.6;
            322.7,1.251,28.7,29.5,29.2,29.5; 327.4,1.251,28.7,29.5,29.3,29.5;
            332.3,1.251,28.7,29.5,29.2,29.5; 337.3,1.251,28.8,29.5,29.2,29.5;
            342.1,1.251,28.8,29.5,29.2,29.5; 347.1,1.251,28.8,29.5,29.2,29.5;
            352,1.251,28.8,29.6,29.2,29.5; 356.8,1.251,28.8,29.6,29.2,29.5;
            361.8,1.251,28.8,29.6,29.2,29.5; 366.6,1.251,28.8,29.6,29.2,29.5;
            371.4,1.251,28.8,29.6,29.2,29.5; 376,1.251,28.8,29.6,29.2,29.5;
            380.8,1.251,28.8,29.6,29.2,29.5; 385.6,1.251,28.8,29.6,29.2,29.5;
            390.7,1.251,28.8,29.6,29.2,29.5; 395.5,1.251,28.8,29.6,29.2,29.5;
            400.2,1.251,28.8,29.6,29.2,29.5; 405.1,1.251,28.8,29.6,29.2,29.5;
            409.9,1.251,28.8,29.5,29.2,29.5; 414.9,1.251,28.8,29.5,29.3,29.6;
            419.8,1.251,28.8,29.5,29.3,29.5; 424.6,1.251,28.8,29.5,29.3,29.5;
            429.4,1.251,28.8,29.5,29.3,29.5; 434.2,1.251,28.8,29.5,29.2,29.5;
            439.1,1.251,28.8,29.5,29.2,29.5; 443.8,1.251,28.8,29.5,29.2,29.5;
            448.7,1.251,28.8,29.5,29.2,29.5; 453.4,1.251,28.8,29.5,29.2,29.5;
            458.2,1.251,28.8,29.5,29.2,29.5; 463,1.251,28.8,29.5,29.2,29.4;
            467.8,1.251,28.8,29.5,29.2,29.5; 472.6,1.251,28.8,29.5,29.2,29.5;
            477.6,1.251,28.8,29.5,29.2,29.5; 482.3,1.251,28.8,29.5,29.2,29.4;
            487.3,1.251,28.8,29.5,29.2,29.4; 492.1,1.251,28.9,29.5,29.2,29.4;
            497,1.251,28.8,29.5,29.2,29.4; 501.8,1.251,28.8,29.5,29.2,29.4;
            506.6,1.251,28.8,29.5,29.2,29.4; 511.5,1.251,28.8,29.5,29.2,29.4;
            516.3,1.251,28.8,29.5,29.2,29.4; 521.4,1.251,28.8,29.5,29.2,29.4;
            526.3,1.251,28.9,29.5,29.2,29.4; 531.2,1.251,28.8,29.5,29.2,29.4]);
      annotation (Documentation(revisions="<html>
  <ul>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add some information about the test.
</li>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>",     info="<html>
<p><b><span style=\"color: #008000;\">Overview</span></b> </p>
<p>This record contains information of an aproximately 15 minutes long test bench carried out at the University of Liège.</p>


<p><b><span style=\"color: #008000;\">Data structure</span></b> </p>
<p><br>Column 1: Time in s </p>
<p>Column 2: Mass flow rate in kg/s</p>
<p>Column 3: Outlet pipe temperature in °C  </p>
<p>Column 4: Outlet water temperature in °C </p>
<p>Column 5: Inlet pipe temperature in °C  </p>
<p>Column 6: Inlet water temperature in °C  </p>

<p><b><span style=\"color: #008000;\">Test procedure</span></b> </p>
<p>Before to perform a test, the water city network is pushed inside the approximately 39 meter long studied pipe during about 10 minutes to be sure that it is at the same temperature. During this time period, valves V3 and V1 are opened, the boiler is off and the valve V2 is closed.</p>
<p>
Then, the valve V1 is closed and the valve V2 and V3 are opened. The boiler is started to reach the setpoint hot water temperature. When the temperature setpoint is achieved, data starts to be recorded, the valve V1 is opened and the valve V2 is closed at the same time to supply the studied pipe in hot water. After the outlet pipe temperature is stabilized, the boiler is shut off.</p>
<p>During the test, the ambient temperature is equal to 18 °C and the mass flow rate is set to 1.245 kg/s.</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>
<p>Notice: length are approximate</p>

<p><b><span style=\"color: #008000;\">Pipe characteristics</span></b> </p>

<ul>
<li>Metal density about 7800 kg/m³</li>
<li>Specific heat capacity about 480 J/kg/K</li>
<li>Thickness 3.91 mm (Outer diameter 0.0603 m)</li>
<li>Inner diameter: 0.05248 m</li>
<li>Roughness is currently neglected</li>
<li>Initial temperature of the pipe is considered equal to the initial temperature of the water (cooliing before test)</li>
<li>Heat transfer coefficient between the pipe and the ambient is assumed at 5 W/m²/K (from internal model) due to insulation.  The pipe is insulated by Tubollt 60/13 (13mm of thickness) whose the nominal thermal coefficient is inferior 0.04. Notice the insulation is quite aged therefore the nominal thermal coefficient could be higher</li>
<li>Heat transfer coefficient between water and pipe is a function of the fluid temperature (determined by EES software)</li>
</ul>



</html>"));
    end PipeDataULg151204_2;

    record PipeDataULg151204_4
      "Experimental data from ULg's pipe test bench from December 4, 2015 (4); an increase followed by a decrease temperature"
      extends IBPSA.Fluid.PlugFlowPipes.Data.BaseClasses.PipeDataULg(
        final n=5,
        T_ini_out=27.7,
        T_ini_in=31.2,
        m_flowIni=1.257,
        data=[0,1.257,27.1,27.7,30.5,31.2; 6.1,1.257,27.1,27.8,31.7,40.2; 12.5,
            1.257,27.3,28.1,38.2,49.7; 18.5,1.257,27.5,28.2,43.6,54.2; 24.8,
            1.257,27.6,28.3,47.8,56.8; 31.2,1.257,27.7,28.4,50.8,58.2; 37.3,
            1.257,27.9,28.6,52.8,59.1; 43.6,1.257,28,28.6,54.2,59.5; 49.6,1.257,
            28,28.6,55.3,59.9; 55.9,1.257,28,28.6,56.1,60.1; 62.1,1.257,28,28.6,
            56.7,60.3; 68.2,1.257,28,28.9,57.1,60.4; 74.6,1.257,28.8,31.1,57.5,
            60.5; 80.3,1.257,30.8,34.3,57.8,60.6; 86.4,1.257,34,38.2,58.1,60.7;
            92.6,1.257,37.6,42.2,58.3,60.8; 98.6,1.257,41.1,45.8,58.5,60.9;
            104.8,1.257,44.4,49.1,58.7,60.9; 111.3,1.257,47.3,51.9,58.8,60.9;
            118.7,1.257,49.9,54.4,58.9,60.9; 125.4,1.257,51.7,56.1,59,61; 132.2,
            1.257,53.1,57.4,59.1,61; 139,1.257,54.2,58.3,59.2,61; 147.4,1.257,
            55.1,59.1,59.3,61; 154.1,1.257,55.7,59.5,59.3,61; 160.9,1.257,56.1,
            59.9,59.4,61.1; 168.8,1.257,56.5,60.2,59.5,61.2; 175.2,1.257,56.8,
            60.4,59.6,61.2; 181.8,1.257,57,60.6,59.7,61.3; 189.1,1.257,57.2,
            60.7,59.7,61.2; 196.2,1.257,57.3,60.7,59.7,61.3; 203,1.257,57.4,
            60.8,59.8,61.2; 209.7,1.257,57.5,60.9,59.8,61.2; 216.4,1.257,57.6,
            60.9,59.8,61.3; 222.6,1.257,57.7,60.9,59.9,61.3; 229,1.257,57.8,61,
            59.9,61.4; 235.3,1.257,57.8,61,60,61.4; 241.7,1.257,57.9,61.1,60,
            61.4; 248.3,1.257,58,61.1,60.1,61.4; 254.9,1.257,58,61.1,60.1,61.4;
            261.7,1.257,58.1,61.2,60.1,61.5; 268.1,1.257,58.2,61.2,60.2,61.5;
            274.6,1.257,58.2,61.2,60.2,61.5; 281.4,1.257,58.2,61.2,60.2,61.5;
            288.1,1.257,58.2,61.2,60.3,61.5; 294.8,1.257,58.3,61.2,60.3,61.5;
            301.2,1.257,58.3,61.3,60.3,61.5; 307.7,1.257,58.3,61.3,60.3,61.6;
            314.1,1.257,58.4,61.3,60.4,61.7; 320.3,1.257,58.4,61.4,60.4,61.7;
            326.7,1.257,58.5,61.4,60.5,61.7; 333.2,1.257,58.5,61.4,60.5,61.7;
            339.7,1.257,58.6,61.4,60.5,61.8; 346,1.257,58.6,61.4,60.5,61.8;
            352.4,1.257,58.6,61.5,60.6,61.8; 358.9,1.257,58.6,61.5,60.6,61.8;
            365.3,1.257,58.6,61.5,60.6,61.8; 371.7,1.257,58.6,61.5,60.6,61.8;
            378.2,1.257,58.7,61.5,60.6,61.8; 384.2,1.257,58.7,61.5,60.6,61.8;
            391.2,1.257,58.8,61.6,60.6,61.8; 397.9,1.257,58.8,61.6,60.7,61.9;
            404.6,1.257,58.8,61.6,60.7,61.9; 411.5,1.257,58.8,61.7,60.8,61.9;
            417.8,1.257,58.9,61.7,60.8,61.9; 424.7,1.257,58.9,61.7,60.8,61.9;
            431,1.257,58.9,61.7,60.8,61.9; 437.2,1.257,58.9,61.7,60.8,62; 443.6,
            1.257,58.9,61.7,60.9,62; 450.4,1.257,58.9,61.7,60.9,62; 456.9,1.257,
            59,61.8,60.9,62; 463.4,1.257,59,61.8,60.9,62.1; 470.2,1.257,59,61.8,
            60.9,62.1; 476.7,1.257,59,61.8,61,62; 483.4,1.257,59.1,61.8,61,62.1;
            490.4,1.257,59.1,61.9,61,62; 497,1.257,59.1,61.9,61,62; 503.4,1.257,
            59.1,61.9,61,62.1; 510,1.257,59.2,61.9,61,62.2; 516.5,1.257,59.2,
            61.9,61.1,62.2; 522.8,1.257,59.2,61.9,61.1,62.3; 529.6,1.257,59.2,
            62,61.1,62.2; 536.4,1.257,59.2,62,61.1,62.2; 543.2,1.257,59.2,62,
            61.1,62.2; 550.1,1.257,59.3,62,61.2,62.3; 556.3,1.257,59.3,62,61.2,
            62.3; 562.9,1.257,59.3,62,61.2,62.3; 569.5,1.257,59.3,62,61.2,62.2;
            576.2,1.257,59.3,62,61.2,62.3; 582.8,1.257,59.3,62,61.2,62.3; 589.3,
            1.257,59.3,62.1,61.2,62.3; 595.6,1.257,59.3,62.1,61.2,62.3; 601.9,
            1.257,59.4,62.1,61.3,62.3; 608.4,1.257,59.4,62.1,61.2,62.2; 614.9,
            1.257,59.4,62.1,61.2,62.1; 621.5,1.257,59.4,62.2,61.1,61.9; 628.3,
            1.257,59.4,62.2,60.9,61.6; 634.9,1.257,59.4,62.2,60.7,61.3; 641.4,
            1.257,59.4,62.2,60.5,60.9; 648.1,1.257,59.4,62.2,60.2,60.5; 654.7,
            1.257,59.5,62.2,59.9,60.1; 661.3,1.257,59.5,62.2,59.5,59.7; 667.6,
            1.257,59.5,62.2,59.2,59.2; 674,1.257,59.5,62.2,58,53.9; 680.3,1.257,
            59.5,62.2,54.7,48.5; 687,1.257,59.5,62.2,51,44.4; 693.4,1.257,59.5,
            62.1,47.9,41.9; 699.6,1.257,59.4,62,45.6,40.4; 706,1.257,59.3,61.8,
            43.7,39.2; 712.4,1.257,59.1,61.6,42.2,38.6; 718.9,1.257,58.9,61.4,
            41.2,38.3; 725.5,1.257,58.7,61.1,40.5,38.1; 732.5,1.257,58.4,60.7,
            39.8,37.9; 739.4,1.257,58,60.1,39.3,37.8; 746.1,1.257,57.2,58.5,39,
            37.7; 753.2,1.257,55.4,56,38.8,37.8; 759.8,1.257,53.2,53.2,38.5,
            37.7; 766.5,1.257,50.6,50.4,38.4,37.7; 772.9,1.257,48.2,47.8,38.3,
            37.6; 779.4,1.257,45.9,45.5,38.2,37.6; 785.7,1.257,44.1,43.7,38.1,
            37.6; 792.1,1.257,42.5,42.2,38,37.6; 798.5,1.257,41.3,41,37.9,37.5;
            805.3,1.257,40.3,40.1,37.8,37.5; 811.9,1.257,39.5,39.4,37.7,37.5;
            818.3,1.257,39,38.9,37.7,37.4; 824.7,1.257,38.5,38.5,37.7,37.4;
            831.1,1.257,38.2,38.3,37.6,37.3; 838.1,1.257,37.9,38,37.5,37.3;
            845.1,1.257,37.6,37.9,37.4,37.3; 851.7,1.257,37.5,37.8,37.4,37.3;
            858.2,1.257,37.3,37.7,37.4,37.2; 864.5,1.257,37.2,37.7,37.3,37.3;
            871.3,1.257,37.1,37.6,37.3,37.2; 878,1.257,37,37.6,37.2,37.2; 884.5,
            1.257,36.9,37.5,37.2,37.3; 891.8,1.257,36.9,37.5,37.2,37.1; 899.7,
            1.257,36.8,37.4,37.1,36.9]);
      annotation (Documentation(revisions="<html>
  <ul>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add some information about the test.
</li>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>",     info="<html>
<p><b><span style=\"color: #008000;\">Overview</span></b> </p>
<p>This record contains information of an aproximately 15 minutes long test bench carried out at the University of Liège.</p>


<p><b><span style=\"color: #008000;\">Data structure</span></b> </p>
<p><br>Column 1: Time in s </p>
<p>Column 2: Mass flow rate in kg/s</p>
<p>Column 3: Outlet pipe temperature in °C  </p>
<p>Column 4: Outlet water temperature in °C </p>
<p>Column 5: Inlet pipe temperature in °C  </p>
<p>Column 6: Inlet water temperature in °C  </p>

<p><b><span style=\"color: #008000;\">Test procedure</span></b> </p>
<p>Before to perform a test, the water city network is pushed inside the approximately 39 meter long studied pipe during about 10 minutes to be sure that it is at the same temperature. During this time period, valves V3 and V1 are opened, the boiler is off and the valve V2 is closed.</p>
<p>
Then, the valve V1 is closed and the valve V2 and V3 are opened. The boiler is started to reach the setpoint hot water temperature. When the temperature setpoint is achieved, data starts to be recorded, the valve V1 is opened and the valve V2 is closed at the same time to supply the studied pipe in hot water. After the outlet pipe temperature is stabilized, the boiler is shut off.</p>
<p>During the test, the ambient temperature is equal to 18 °C and the mass flow rate is set to 1.245 kg/s.</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>
<p>Notice: length are approximate</p>

<p><b><span style=\"color: #008000;\">Pipe characteristics</span></b> </p>

<ul>
<li>Metal density about 7800 kg/m³</li>
<li>Specific heat capacity about 480 J/kg/K</li>
<li>Thickness 3.91 mm (Outer diameter 0.0603 m)</li>
<li>Inner diameter: 0.05248 m</li>
<li>Roughness is currently neglected</li>
<li>Initial temperature of the pipe is considered equal to the initial temperature of the water (cooliing before test)</li>
<li>Heat transfer coefficient between the pipe and the ambient is assumed at 5 W/m²/K (from internal model) due to insulation.  The pipe is insulated by Tubollt 60/13 (13mm of thickness) whose the nominal thermal coefficient is inferior 0.04. Notice the insulation is quite aged therefore the nominal thermal coefficient could be higher</li>
<li>Heat transfer coefficient between water and pipe is a function of the fluid temperature (determined by EES software)</li>
</ul>



</html>"));
    end PipeDataULg151204_4;

    record PipeDataULg160104_2 "Experimental data from ULg's pipe test bench from 4 January 2016. Low mass flow"
      extends IBPSA.Fluid.PlugFlowPipes.Data.BaseClasses.PipeDataULg(
        final n=5,
        T_ini_out=15.0,
        T_ini_in=17.9,
        m_flowIni=0.2494,
        data=[0,0.2494,15.3,15,17.8,17.9; 3,0.2494,15.3,15,17.8,18; 8.1,0.2494,
            15.3,15,17.8,18; 11.2,0.2494,15.3,15,17.9,18; 16.3,0.2494,15.3,15,
            17.9,18.1; 19.4,0.2494,15.3,15,17.9,18.1; 22.5,0.2494,15.3,15,17.9,
            18.1; 25.6,0.2494,15.3,15,18,18.1; 30.2,0.2494,15.3,15,18,18.1;
            33.1,0.2494,15.3,15,18,18.2; 38,0.2494,15.3,15.1,18,18.2; 41,0.2494,
            15.3,15.1,18.1,18.2; 45.7,0.2494,15.4,15.1,18.1,18.3; 48.7,0.2494,
            15.4,15.1,18.1,18.3; 53.6,0.2494,15.4,15.2,18.1,18.3; 56.6,0.2494,
            15.4,15.2,18.2,18.3; 61.4,0.2494,15.4,15.3,18.2,18.4; 64.4,0.2494,
            15.4,15.3,18.2,18.4; 69.5,0.2494,15.5,15.3,18.2,18.4; 72.5,0.2494,
            15.5,15.3,18.2,18.4; 77.6,0.2494,15.5,15.4,18.3,18.5; 80.6,0.2494,
            15.5,15.4,18.3,18.5; 83.7,0.2494,15.6,15.4,18.3,18.5; 86.8,0.2494,
            15.6,15.5,18.4,18.5; 89.8,0.2494,15.6,15.5,18.4,18.6; 92.9,0.2494,
            15.6,15.5,18.4,18.6; 96,0.2494,15.6,15.5,18.4,18.6; 99.1,0.2494,
            15.7,15.6,18.4,18.6; 102.2,0.2494,15.7,15.6,18.5,18.6; 105.3,0.2494,
            15.7,15.6,18.5,18.7; 108.6,0.2494,15.7,15.7,18.5,18.7; 113.8,0.2494,
            15.8,15.7,18.5,18.7; 116.8,0.2494,15.8,15.8,18.6,18.7; 122,0.2494,
            15.9,15.8,18.6,18.8; 125,0.2494,15.9,15.8,18.6,18.8; 130.1,0.2494,
            15.9,15.9,18.7,18.9; 133.5,0.2494,15.9,15.9,18.7,18.9; 138.6,0.2494,
            16,15.9,18.7,18.9; 141.7,0.2494,16,16,18.7,18.9; 144.8,0.2494,16,16,
            18.7,18.9; 149.1,0.2494,16.1,16.1,18.8,19; 152.1,0.2494,16.1,16.1,
            18.8,19; 155.3,0.2494,16.1,16.1,18.8,19; 160.4,0.2494,16.2,16.1,
            18.8,19; 163.7,0.2494,16.2,16.2,18.9,19.1; 167,0.2494,16.2,16.2,
            18.9,19.1; 171.6,0.2494,16.3,16.3,18.9,19.1; 174.6,0.2494,16.3,16.3,
            19,19.1; 177.8,0.2494,16.3,16.3,19,19.2; 183.1,0.2494,16.4,16.4,19,
            19.2; 186.2,0.2494,16.4,16.4,19,19.2; 191.5,0.2494,16.4,16.4,19.1,
            19.2; 194.9,0.2494,16.4,16.5,19.1,19.2; 199.1,0.2494,16.5,16.5,19.1,
            19.3; 202.2,0.2494,16.5,16.5,19.1,19.3; 206.9,0.2494,16.5,16.5,19.1,
            19.3; 210.1,0.2494,16.6,16.6,19.2,19.3; 213.3,0.2494,16.6,16.6,19.2,
            19.4; 216.5,0.2494,16.6,16.6,19.2,19.4; 220.1,0.2494,16.6,16.7,19.2,
            19.4; 223.6,0.2494,16.7,16.7,19.3,19.4; 227,0.2494,16.7,16.7,19.3,
            19.4; 230.1,0.2494,16.7,16.7,19.3,19.5; 233.2,0.2494,16.7,16.8,19.3,
            19.5; 236.4,0.2494,16.8,16.8,19.3,19.5; 241.7,0.2494,16.8,16.8,19.4,
            19.5; 245,0.2494,16.8,16.9,19.4,19.5; 248.1,0.2494,16.8,16.9,19.4,
            19.6; 251.3,0.2494,16.9,16.9,19.4,19.6; 254.5,0.2494,16.9,16.9,19.4,
            19.6; 257.9,0.2494,16.9,16.9,19.4,19.6; 263.2,0.2494,17,17,19.5,
            19.7; 266.3,0.2494,17,17,19.5,19.7; 270.8,0.2494,17,17,19.5,19.7;
            273.8,0.2494,17,17.1,19.6,19.7; 277,0.2494,17,17.1,19.6,19.7; 282.2,
            0.2494,17.1,17.1,19.6,19.8; 285.7,0.2494,17.1,17.2,19.6,19.8; 290.9,
            0.2494,17.1,17.2,19.7,19.8; 294.3,0.2494,17.2,17.2,19.7,19.9; 297.8,
            0.2494,17.2,17.2,19.7,19.9; 303,0.2494,17.2,17.3,19.7,19.9; 306.2,
            0.2494,17.3,17.3,19.8,19.9; 309.6,0.2494,17.3,17.3,19.8,20; 312.6,
            0.2494,17.3,17.3,19.8,20; 315.9,0.2494,17.3,17.4,19.8,20; 319,
            0.2494,17.3,17.4,19.8,20; 323.1,0.2494,17.4,17.4,19.8,20; 326.3,
            0.2494,17.4,17.5,19.9,20.1; 329.6,0.2494,17.4,17.5,19.9,20.1; 332.8,
            0.2494,17.4,17.5,19.9,20.1; 336.7,0.2494,17.5,17.5,19.9,20.1; 339.9,
            0.2494,17.5,17.5,19.9,20.1; 345,0.2494,17.5,17.6,20,20.2; 348.2,
            0.2494,17.5,17.6,20,20.2; 351.5,0.2494,17.6,17.6,20,20.2; 354.7,
            0.2494,17.6,17.6,20,20.2; 359.3,0.2494,17.6,17.7,20.1,20.3; 362.5,
            0.2494,17.6,17.7,20.1,20.3; 367.2,0.2494,17.7,17.7,20.1,20.3; 370.4,
            0.2494,17.7,17.8,20.1,20.3; 375.1,0.2494,17.7,17.8,20.1,20.3; 378.2,
            0.2494,17.7,17.8,20.2,20.4; 383,0.2494,17.8,17.8,20.2,20.4; 386.1,
            0.2494,17.8,17.8,20.2,20.4; 389.3,0.2494,17.8,17.9,20.2,20.4; 392.5,
            0.2494,17.8,17.9,20.3,20.4; 396.8,0.2494,17.8,17.9,20.3,20.5; 400,
            0.2494,17.9,17.9,20.3,20.5; 403.1,0.2494,17.9,18,20.3,20.5; 406.3,
            0.2494,17.9,18,20.3,20.5; 409.4,0.2494,17.9,18,20.4,20.5; 412.5,
            0.2494,17.9,18,20.4,20.6; 415.7,0.2494,18,18.1,20.4,20.6; 418.9,
            0.2494,18,18.1,20.4,20.6; 422.1,0.2494,18,18.1,20.4,20.6; 425.3,
            0.2494,18,18.1,20.4,20.7; 428.4,0.2494,18,18.1,20.5,20.7; 431.5,
            0.2494,18.1,18.2,20.5,20.7; 434.7,0.2494,18.1,18.2,20.5,20.7; 437.8,
            0.2494,18.1,18.2,20.5,20.7; 443,0.2494,18.1,18.2,20.6,20.8; 446.2,
            0.2494,18.1,18.2,20.6,20.8; 449.2,0.2494,18.2,18.3,20.6,20.8; 452.4,
            0.2494,18.2,18.3,20.6,20.8; 455.5,0.2494,18.2,18.3,20.6,20.8; 458.7,
            0.2494,18.2,18.3,20.7,20.8; 462.9,0.2494,18.2,18.4,20.7,20.9; 466.1,
            0.2494,18.3,18.4,20.7,20.9; 469.3,0.2494,18.3,18.4,20.7,20.9; 472.4,
            0.2494,18.3,18.4,20.7,20.9; 475.5,0.2494,18.3,18.4,20.7,21; 478.6,
            0.2494,18.3,18.5,20.8,21; 481.8,0.2494,18.4,18.5,20.8,21; 485,
            0.2494,18.4,18.5,20.8,21; 488.1,0.2494,18.4,18.5,20.8,21; 491.3,
            0.2494,18.4,18.5,20.8,21; 494.4,0.2494,18.4,18.5,20.9,21.1; 499.7,
            0.2494,18.5,18.6,20.9,21.1; 502.9,0.2494,18.5,18.6,20.9,21.1; 506,
            0.2494,18.5,18.6,20.9,21.1; 509.2,0.2494,18.5,18.6,21,21.1; 512.4,
            0.2494,18.5,18.7,21,21.2; 515.6,0.2494,18.6,18.7,21,21.2; 518.8,
            0.2494,18.6,18.7,21,21.2; 522,0.2494,18.6,18.7,21,21.2; 525.1,
            0.2494,18.6,18.7,21,21.2; 528.4,0.2494,18.6,18.8,21.1,21.3; 531.6,
            0.2494,18.7,18.8,21.1,21.3; 534.8,0.2494,18.7,18.8,21.1,21.3; 537.9,
            0.2494,18.7,18.8,21.1,21.3; 541,0.2494,18.7,18.8,21.1,21.3; 545,
            0.2494,18.7,18.9,21.1,21.3; 548.3,0.2494,18.8,18.9,21.2,21.4; 551.5,
            0.2494,18.8,18.9,21.2,21.4; 554.6,0.2494,18.8,18.9,21.2,21.4; 557.7,
            0.2494,18.8,18.9,21.2,21.4; 560.9,0.2494,18.8,19,21.2,21.5; 564.8,
            0.2494,18.8,19,21.3,21.5; 568.1,0.2494,18.9,19,21.3,21.5; 572.7,
            0.2494,18.9,19,21.3,21.5; 575.9,0.2494,18.9,19.1,21.3,21.6; 579.1,
            0.2494,18.9,19.1,21.4,21.6; 582.3,0.2494,19,19.1,21.4,21.6; 585.5,
            0.2494,19,19.1,21.4,21.6; 588.6,0.2494,19,19.1,21.4,21.6; 591.8,
            0.2494,19,19.1,21.4,21.6; 595,0.2494,19,19.2,21.4,21.6; 598.2,
            0.2494,19,19.2,21.5,21.7; 602.4,0.2494,19.1,19.2,21.5,21.7; 605.6,
            0.2494,19.1,19.2,21.5,21.7; 608.8,0.2494,19.1,19.2,21.5,21.7; 612,
            0.2494,19.1,19.3,21.6,21.8; 615.1,0.2494,19.1,19.3,21.6,21.8; 618.3,
            0.2494,19.2,19.3,21.6,21.8; 621.6,0.2494,19.2,19.3,21.6,21.8; 624.8,
            0.2494,19.2,19.3,21.6,21.8; 628.2,0.2494,19.2,19.4,21.6,21.8; 631.4,
            0.2494,19.2,19.4,21.7,21.9; 634.6,0.2494,19.2,19.4,21.7,21.9; 637.8,
            0.2494,19.3,19.4,21.7,21.9; 640.9,0.2494,19.3,19.4,21.7,21.9; 644.2,
            0.2494,19.3,19.5,21.7,21.9; 647.4,0.2494,19.3,19.5,21.7,21.9; 650.6,
            0.2494,19.3,19.5,21.8,22; 654.9,0.2494,19.4,19.5,21.8,22; 658,
            0.2494,19.4,19.5,21.8,22; 661.2,0.2494,19.4,19.5,21.8,22; 664.5,
            0.2494,19.4,19.6,21.8,22.1; 667.7,0.2494,19.4,19.6,21.9,22.1; 670.9,
            0.2494,19.4,19.6,21.9,22.1; 674.3,0.2494,19.5,19.6,21.9,22.1; 678.7,
            0.2494,19.5,19.7,21.9,22.1; 681.9,0.2494,19.5,19.7,21.9,22.1; 685.2,
            0.2494,19.5,19.7,22,22.2; 688.4,0.2494,19.5,19.7,22,22.2; 692.9,
            0.2494,19.6,19.7,22,22.2; 696.1,0.2494,19.6,19.8,22,22.2; 699.4,
            0.2494,19.6,19.8,22,22.2; 702.6,0.2494,19.6,19.8,22.1,22.2; 706.8,
            0.2494,19.6,19.8,22.1,22.3; 710.1,0.2494,19.7,19.8,22.1,22.3; 713.3,
            0.2494,19.7,19.9,22.1,22.3; 718.5,0.2494,19.7,19.9,22.1,22.3; 721.7,
            0.2494,19.7,19.9,22.1,22.4; 725.1,0.2494,19.7,19.9,22.2,22.4; 728.3,
            0.2494,19.8,19.9,22.2,22.4; 733.6,0.2494,19.8,20,22.2,22.4; 736.9,
            0.2494,19.8,20,22.2,22.4; 740.1,0.2494,19.8,20,22.2,22.5; 744.9,
            0.2494,19.9,20,22.3,22.5; 748.1,0.2494,19.9,20.1,22.3,22.5; 751.3,
            0.2494,19.9,20.1,22.3,22.5; 754.6,0.2494,19.9,20.1,22.3,22.5; 758.5,
            0.2494,19.9,20.1,22.3,22.5; 761.7,0.2494,19.9,20.1,22.4,22.6; 765,
            0.2494,20,20.2,22.4,22.6; 768.5,0.2494,20,20.2,22.4,22.6; 772.2,
            0.2494,20,20.2,22.4,22.6; 775.5,0.2494,20,20.2,22.4,22.6; 779.8,
            0.2494,20,20.3,22.5,22.7; 783.5,0.2494,20.1,20.3,22.5,22.7; 787,
            0.2494,20.1,20.3,22.5,22.7; 796.9,0.2494,20.1,20.3,22.5,22.8; 800.6,
            0.2494,20.2,20.4,22.6,22.8; 804.5,0.2494,20.2,20.4,22.6,22.8; 807.9,
            0.2494,20.2,20.4,22.6,22.8; 811.1,0.2494,20.2,20.4,22.6,22.8; 814.5,
            0.2494,20.2,20.5,22.6,22.8; 817.8,0.2494,20.2,20.5,22.6,22.9; 821.1,
            0.2494,20.3,20.5,22.7,22.9; 826.5,0.2494,20.3,20.5,22.7,22.9; 829.7,
            0.2494,20.3,20.5,22.7,22.9; 832.9,0.2494,20.3,20.6,22.7,22.9; 837.2,
            0.2494,20.4,20.6,22.7,22.9; 840.4,0.2494,20.4,20.6,22.8,23; 843.7,
            0.2494,20.4,20.6,22.8,23; 846.9,0.2494,20.4,20.6,22.8,23; 850.1,
            0.2494,20.4,20.7,22.8,23; 853.3,0.2494,20.4,20.7,22.8,23; 856.6,
            0.2494,20.4,20.7,22.8,23; 860.1,0.2494,20.5,20.7,22.9,23.1; 863.5,
            0.2494,20.5,20.7,22.9,23.1; 866.7,0.2494,20.5,20.8,22.9,23.1; 870,
            0.2494,20.5,20.8,22.9,23.1; 873.2,0.2494,20.6,20.8,22.9,23.2; 877.1,
            0.2494,20.6,20.8,22.9,23.2; 880.3,0.2494,20.6,20.8,23,23.2; 883.6,
            0.2494,20.6,20.9,23,23.2; 886.9,0.2494,20.6,20.9,23,23.2; 890.1,
            0.2494,20.6,20.9,23,23.2; 893.4,0.2494,20.6,20.9,23,23.2; 896.7,
            0.2494,20.7,20.9,23,23.2; 899.8,0.2494,20.7,21,23.1,23.3; 903.1,
            0.2494,20.7,21,23.1,23.3; 906.3,0.2494,20.7,21,23.1,23.3; 909.6,
            0.2494,20.7,21,23.1,23.3; 912.9,0.2494,20.8,21,23.1,23.3; 916.2,
            0.2494,20.8,21,23.1,23.3; 919.4,0.2494,20.8,21.1,23.2,23.4; 923.7,
            0.2494,20.8,21.1,23.2,23.4; 926.9,0.2494,20.8,21.1,23.2,23.4; 930.2,
            0.2494,20.8,21.1,23.2,23.4; 933.4,0.2494,20.9,21.2,23.2,23.5; 936.7,
            0.2494,20.9,21.2,23.3,23.5; 940,0.2494,20.9,21.2,23.3,23.5; 943.3,
            0.2494,20.9,21.2,23.3,23.5; 946.6,0.2494,20.9,21.2,23.3,23.5; 950,
            0.2494,21,21.2,23.3,23.5; 953.3,0.2494,21,21.2,23.3,23.5; 956.6,
            0.2494,21,21.3,23.3,23.6; 959.8,0.2494,21,21.3,23.4,23.6; 963.1,
            0.2494,21,21.3,23.4,23.6; 966.4,0.2494,21.1,21.3,23.4,23.6; 969.7,
            0.2494,21.1,21.4,23.4,23.6; 973.1,0.2494,21.1,21.4,23.4,23.6; 976.3,
            0.2494,21.1,21.4,23.4,23.6; 979.6,0.2494,21.1,21.4,23.5,23.7; 982.9,
            0.2494,21.1,21.4,23.5,23.7; 986.2,0.2494,21.2,21.4,23.5,23.7; 989.5,
            0.2494,21.2,21.5,23.5,23.7; 992.8,0.2494,21.2,21.5,23.5,23.7; 998.2,
            0.2494,21.2,21.5,23.5,23.7; 1001.5,0.2494,21.2,21.5,23.5,23.8; 1005,
            0.2494,21.3,21.6,23.6,23.8; 1008.3,0.2494,21.3,21.6,23.6,23.8;
            1011.8,0.2494,21.3,21.6,23.6,23.8; 1015,0.2494,21.3,21.6,23.6,23.8;
            1020.5,0.2494,21.3,21.6,23.6,23.9; 1023.7,0.2494,21.4,21.7,23.6,
            23.9; 1027.1,0.2494,21.4,21.7,23.7,23.9; 1030.5,0.2494,21.4,21.7,
            23.7,23.9; 1035.8,0.2494,21.4,21.7,23.7,23.9; 1039.3,0.2494,21.4,
            21.7,23.7,23.9; 1042.6,0.2494,21.4,21.8,23.7,24; 1045.9,0.2494,21.5,
            21.8,23.8,24; 1049.2,0.2494,21.5,21.8,23.8,24; 1052.5,0.2494,21.5,
            21.8,23.8,24; 1055.8,0.2494,21.5,21.8,23.8,24; 1059.1,0.2494,21.6,
            21.9,23.8,24; 1062.5,0.2494,21.5,21.9,23.8,24; 1065.8,0.2494,21.6,
            21.9,23.8,24.1; 1069.3,0.2494,21.6,21.9,23.9,24.1; 1072.9,0.2494,
            21.6,21.9,23.9,24.1; 1076.2,0.2494,21.6,22,23.9,24.1; 1079.5,0.2494,
            21.6,22,23.9,24.1; 1082.9,0.2494,21.7,22,23.9,24.1; 1086.3,0.2494,
            21.7,22,23.9,24.2; 1089.6,0.2494,21.7,22,24,24.2; 1095,0.2494,21.7,
            22,24,24.2; 1098.4,0.2494,21.7,22.1,24,24.2; 1101.7,0.2494,21.8,
            22.1,24,24.2; 1105.1,0.2494,21.8,22.1,24,24.2; 1108.5,0.2494,21.8,
            22.1,24,24.3; 1111.9,0.2494,21.8,22.1,24.1,24.3; 1116.2,0.2494,21.8,
            22.2,24.1,24.3; 1119.5,0.2494,21.8,22.2,24.1,24.3; 1122.8,0.2494,
            21.9,22.2,24.1,24.3; 1126.1,0.2494,21.9,22.2,24.1,24.3; 1129.4,
            0.2494,21.9,22.2,24.1,24.3; 1132.8,0.2494,21.9,22.3,24.1,24.4;
            1136.2,0.2494,21.9,22.3,24.2,24.4; 1139.5,0.2494,21.9,22.3,24.2,
            24.4; 1143.1,0.2494,22,22.3,24.2,24.4; 1146.4,0.2494,22,22.3,24.2,
            24.4; 1149.9,0.2494,22,22.3,24.2,24.5; 1153.3,0.2494,22,22.4,24.2,
            24.5; 1156.7,0.2494,22,22.4,24.3,24.5; 1160.1,0.2494,22.1,22.4,24.3,
            24.5; 1163.4,0.2494,22.1,22.4,24.3,24.5; 1168.9,0.2494,22.1,22.4,
            24.3,24.5; 1172.2,0.2494,22.1,22.5,24.3,24.5; 1175.5,0.2494,22.1,
            22.5,24.3,24.5; 1179,0.2494,22.2,22.5,24.4,24.6; 1182.4,0.2494,22.2,
            22.5,24.4,24.6; 1185.8,0.2494,22.2,22.5,24.4,24.6; 1189.2,0.2494,
            22.2,22.5,24.4,24.6; 1194.7,0.2494,22.2,22.6,24.4,24.6; 1198.1,
            0.2494,22.2,22.6,24.4,24.7; 1201.5,0.2494,22.3,22.6,24.5,24.7;
            1204.9,0.2494,22.3,22.6,24.5,24.7; 1208.2,0.2494,22.3,22.6,24.5,
            24.7; 1211.6,0.2494,22.3,22.7,24.5,24.7; 1215,0.2494,22.3,22.7,24.5,
            24.7; 1218.4,0.2494,22.3,22.7,24.5,24.8; 1222.8,0.2494,22.4,22.7,
            24.6,24.8; 1226.2,0.2494,22.4,22.7,24.6,24.8; 1229.6,0.2494,22.4,
            22.7,24.6,24.8; 1232.9,0.2494,22.4,22.8,24.6,24.8; 1236.3,0.2494,
            22.4,22.8,24.6,24.8; 1239.9,0.2494,22.4,22.8,24.6,24.8; 1243.3,
            0.2494,22.5,22.8,24.6,24.8; 1247.2,0.2494,22.5,22.8,24.6,24.9;
            1250.6,0.2494,22.5,22.9,24.7,24.9; 1254,0.2494,22.5,22.9,24.7,24.9;
            1257.4,0.2494,22.5,22.9,24.7,24.9; 1260.8,0.2494,22.5,22.9,24.7,
            24.9; 1265.5,0.2494,22.6,22.9,24.7,24.9; 1268.9,0.2494,22.6,22.9,
            24.7,25; 1272.3,0.2494,22.6,23,24.8,25; 1275.6,0.2494,22.6,23,24.8,
            25; 1279,0.2494,22.6,23,24.8,25; 1282.3,0.2494,22.6,23,24.8,25;
            1285.7,0.2494,22.6,23,24.8,25; 1289.1,0.2494,22.7,23,24.8,25;
            1293.6,0.2494,22.7,23.1,24.8,25.1; 1297,0.2494,22.7,23.1,24.9,25.1;
            1300.5,0.2494,22.7,23.1,24.9,25.1; 1303.8,0.2494,22.7,23.1,24.9,
            25.1; 1307.2,0.2494,22.8,23.2,24.9,25.1; 1310.6,0.2494,22.8,23.2,
            24.9,25.1; 1314,0.2494,22.8,23.2,24.9,25.1; 1317.4,0.2494,22.8,23.2,
            24.9,25.2; 1320.8,0.2494,22.8,23.2,24.9,25.2; 1324.2,0.2494,22.8,
            23.2,25,25.2; 1327.6,0.2494,22.9,23.2,25,25.2; 1331,0.2494,22.9,
            23.3,25,25.2; 1336.5,0.2494,22.9,23.3,25,25.3; 1340,0.2494,22.9,
            23.3,25,25.3; 1343.3,0.2494,22.9,23.3,25,25.3; 1346.7,0.2494,22.9,
            23.3,25.1,25.3; 1350,0.2494,22.9,23.3,25.1,25.3; 1353.5,0.2494,23,
            23.4,25.1,25.3; 1356.9,0.2494,23,23.4,25.1,25.3; 1360.3,0.2494,23,
            23.4,25.1,25.3; 1363.8,0.2494,23,23.4,25.1,25.4; 1367.1,0.2494,23,
            23.4,25.1,25.4; 1370.7,0.2494,23.1,23.5,25.2,25.4; 1376,0.2494,23.1,
            23.5,25.2,25.4; 1379.3,0.2494,23.1,23.5,25.2,25.4; 1382.8,0.2494,
            23.1,23.5,25.2,25.4; 1386.2,0.2494,23.1,23.5,25.2,25.5; 1389.7,
            0.2494,23.1,23.5,25.2,25.5; 1393.1,0.2494,23.1,23.6,25.3,25.5;
            1396.4,0.2494,23.2,23.6,25.3,25.5; 1399.7,0.2494,23.2,23.6,25.3,
            25.5; 1403,0.2494,23.2,23.6,25.3,25.5; 1406.3,0.2494,23.2,23.6,25.3,
            25.5; 1409.8,0.2494,23.2,23.6,25.3,25.5; 1413.2,0.2494,23.2,23.6,
            25.3,25.6; 1416.6,0.2494,23.2,23.7,25.3,25.6; 1420.2,0.2494,23.3,
            23.7,25.4,25.6; 1423.6,0.2494,23.3,23.7,25.4,25.6; 1427,0.2494,23.3,
            23.7,25.4,25.6; 1430.6,0.2494,23.3,23.7,25.4,25.6; 1436,0.2494,23.3,
            23.7,25.4,25.6; 1439.3,0.2494,23.4,23.8,25.4,25.7; 1442.8,0.2494,
            23.4,23.8,25.5,25.7; 1446.2,0.2494,23.4,23.8,25.5,25.7; 1449.8,
            0.2494,23.4,23.8,25.5,25.7; 1453.4,0.2494,23.4,23.8,25.5,25.7;
            1456.9,0.2494,23.4,23.8,25.5,25.7; 1460.2,0.2494,23.4,23.9,25.5,
            25.7; 1465.7,0.2494,23.5,23.9,25.5,25.8; 1469.2,0.2494,23.5,23.9,
            25.6,25.8; 1472.6,0.2494,23.5,23.9,25.6,25.8; 1476.1,0.2494,23.5,24,
            25.6,25.8; 1479.5,0.2494,23.5,24,25.6,25.8; 1483.2,0.2494,23.5,24,
            25.6,25.8; 1488.6,0.2494,23.6,24,25.6,25.9; 1492.1,0.2494,23.6,24,
            25.6,25.9; 1495.6,0.2494,23.6,24,25.7,25.9; 1499.2,0.2494,23.6,24.1,
            25.7,25.9; 1502.6,0.2494,23.6,24,25.7,25.9; 1506.1,0.2494,23.6,24.1,
            25.7,25.9; 1509.5,0.2494,23.7,24.1,25.7,25.9; 1513,0.2494,23.7,24.1,
            25.7,26; 1516.4,0.2494,23.7,24.1,25.7,26; 1519.8,0.2494,23.7,24.1,
            25.8,26; 1523.2,0.2494,23.7,24.2,25.8,26; 1526.7,0.2494,23.7,24.2,
            25.8,26; 1532.2,0.2494,23.7,24.2,25.8,26; 1535.7,0.2494,23.8,24.2,
            25.8,26; 1539.6,0.2494,23.8,24.2,25.8,26.1; 1543.1,0.2494,23.8,24.2,
            25.8,26.1; 1546.6,0.2494,23.8,24.2,25.9,26.1; 1550.1,0.2494,23.8,
            24.3,25.9,26.1; 1553.6,0.2494,23.8,24.3,25.9,26.1; 1559,0.2494,23.9,
            24.3,25.9,26.1; 1562.6,0.2494,23.9,24.3,25.9,26.1; 1566,0.2494,23.9,
            24.3,25.9,26.2; 1569.6,0.2494,23.9,24.4,25.9,26.2; 1573.5,0.2494,
            23.9,24.4,26,26.2; 1577,0.2494,23.9,24.4,26,26.2; 1580.5,0.2494,24,
            24.4,26,26.2; 1584,0.2494,24,24.4,26,26.2; 1587.4,0.2494,24,24.4,26,
            26.2; 1593,0.2494,24,24.5,26,26.3; 1596.5,0.2494,24,24.5,26.1,26.3;
            1600.1,0.2494,24,24.5,26.1,26.3; 1603.7,0.2494,24.1,24.5,26.1,26.3;
            1607.2,0.2494,24.1,24.5,26.1,26.3; 1610.8,0.2494,24.1,24.5,26.1,
            26.3; 1614.3,0.2494,24.1,24.6,26.1,26.4; 1617.8,0.2494,24.1,24.6,
            26.1,26.4; 1621.6,0.2494,24.1,24.6,26.2,26.4; 1625.1,0.2494,24.1,
            24.6,26.2,26.4; 1628.5,0.2494,24.2,24.6,26.2,26.4; 1632.3,0.2494,
            24.2,24.6,26.2,26.4; 1635.8,0.2494,24.2,24.6,26.2,26.4; 1639.3,
            0.2494,24.2,24.7,26.2,26.4; 1642.9,0.2494,24.2,24.7,26.2,26.4;
            1646.3,0.2494,24.2,24.7,26.2,26.5; 1649.8,0.2494,24.2,24.7,26.2,
            26.5; 1653.5,0.2494,24.2,24.7,26.3,26.5; 1657,0.2494,24.3,24.7,26.3,
            26.5; 1660.6,0.2494,24.3,24.7,26.3,26.5; 1664.3,0.2494,24.3,24.8,
            26.3,26.5; 1667.8,0.2494,24.3,24.8,26.3,26.5; 1671.4,0.2494,24.3,
            24.8,26.3,26.6; 1675.1,0.2494,24.3,24.8,26.3,26.6; 1680.6,0.2494,
            24.4,24.8,26.4,26.6; 1684.1,0.2494,24.4,24.8,26.4,26.6; 1687.7,
            0.2494,24.4,24.9,26.4,26.6; 1691.4,0.2494,24.4,24.9,26.4,26.6; 1697,
            0.2494,24.4,24.9,26.4,26.6; 1700.5,0.2494,24.4,24.9,26.4,26.7;
            1704.8,0.2494,24.5,24.9,26.4,26.7; 1708.3,0.2494,24.5,25,26.4,26.7;
            1711.8,0.2494,24.5,25,26.5,26.7; 1715.4,0.2494,24.5,25,26.5,26.7;
            1718.9,0.2494,24.5,25,26.5,26.7; 1722.4,0.2494,24.5,25,26.5,26.7;
            1726.1,0.2494,24.5,25,26.5,26.7; 1729.8,0.2494,24.6,25,26.5,26.8;
            1733.3,0.2494,24.6,25,26.5,26.8; 1736.9,0.2494,24.6,25.1,26.5,26.8;
            1740.8,0.2494,24.6,25.1,26.6,26.8; 1744.3,0.2494,24.6,25.1,26.6,
            26.8; 1748,0.2494,24.6,25.1,26.6,26.8; 1751.8,0.2494,24.6,25.1,26.6,
            26.8; 1755.3,0.2494,24.6,25.1,26.6,26.8; 1758.8,0.2494,24.7,25.1,
            26.6,26.9; 1762.4,0.2494,24.7,25.2,26.6,26.9; 1768,0.2494,24.7,25.2,
            26.7,26.9; 1771.5,0.2494,24.7,25.2,26.7,26.9; 1775.1,0.2494,24.7,
            25.2,26.7,26.9; 1778.6,0.2494,24.7,25.2,26.7,26.9; 1782.2,0.2494,
            24.8,25.2,26.7,26.9; 1785.8,0.2494,24.8,25.3,26.7,26.9; 1789.3,
            0.2494,24.8,25.3,26.7,27; 1793,0.2494,24.8,25.3,26.7,27; 1796.5,
            0.2494,24.8,25.3,26.8,27; 1800.1,0.2494,24.8,25.3,26.8,27; 1803.7,
            0.2494,24.8,25.3,26.8,27; 1807.2,0.2494,24.9,25.4,26.8,27; 1810.9,
            0.2494,24.9,25.4,26.8,27; 1814.5,0.2494,24.9,25.4,26.8,27.1; 1819.1,
            0.2494,24.9,25.4,26.8,27.1; 1822.6,0.2494,24.9,25.4,26.8,27.1;
            1826.2,0.2494,24.9,25.4,26.9,27.1; 1829.8,0.2494,24.9,25.4,26.9,
            27.1; 1833.4,0.2494,24.9,25.4,26.9,27.1; 1838.1,0.2494,25,25.5,26.9,
            27.1; 1841.6,0.2494,25,25.5,26.9,27.1; 1845.3,0.2494,25,25.5,26.9,
            27.2; 1848.8,0.2494,25,25.5,27,27.2; 1852.5,0.2494,25,25.5,27,27.2;
            1856.2,0.2494,25,25.5,27,27.2; 1859.7,0.2494,25,25.6,27,27.2;
            1863.5,0.2494,25.1,25.6,27,27.2; 1867.2,0.2494,25.1,25.6,27,27.2;
            1870.7,0.2494,25.1,25.6,27,27.3; 1874.3,0.2494,25.1,25.6,27,27.3;
            1878,0.2494,25.1,25.6,27,27.3; 1881.5,0.2494,25.1,25.6,27,27.3;
            1885.1,0.2494,25.1,25.7,27.1,27.3; 1888.6,0.2494,25.1,25.7,27.1,
            27.3; 1892.3,0.2494,25.2,25.7,27.1,27.3; 1895.8,0.2494,25.2,25.7,
            27.1,27.3; 1899.4,0.2494,25.2,25.7,27.1,27.3; 1903,0.2494,25.2,25.7,
            27.1,27.4; 1906.5,0.2494,25.2,25.7,27.1,27.4; 1910.2,0.2494,25.2,
            25.8,27.1,27.4; 1914.2,0.2494,25.2,25.8,27.2,27.4; 1917.8,0.2494,
            25.3,25.8,27.2,27.4; 1921.4,0.2494,25.3,25.8,27.2,27.4; 1925.3,
            0.2494,25.3,25.8,27.2,27.4; 1928.8,0.2494,25.3,25.8,27.2,27.4;
            1932.3,0.2494,25.3,25.8,27.2,27.5; 1936.1,0.2494,25.3,25.9,27.2,
            27.5; 1939.7,0.2494,25.3,25.9,27.2,27.5; 1943.4,0.2494,25.3,25.9,
            27.3,27.5; 1947.1,0.2494,25.4,25.9,27.3,27.5; 1950.8,0.2494,25.4,
            25.9,27.3,27.5; 1954.4,0.2494,25.4,25.9,27.3,27.5; 1958,0.2494,25.4,
            25.9,27.3,27.5; 1961.6,0.2494,25.4,26,27.3,27.6; 1965.3,0.2494,25.4,
            26,27.3,27.6; 1968.9,0.2494,25.4,26,27.3,27.6; 1974.6,0.2494,25.5,
            26,27.3,27.6; 1978.2,0.2494,25.5,26,27.4,27.6; 1981.7,0.2494,25.5,
            26,27.4,27.6; 1985.3,0.2494,25.5,26,27.4,27.6; 1988.9,0.2494,25.5,
            26.1,27.4,27.6; 1992.7,0.2494,25.5,26.1,27.4,27.6; 1996.4,0.2494,
            25.5,26.1,27.4,27.7; 2000.2,0.2494,25.5,26.1,27.4,27.7; 2003.7,
            0.2494,25.6,26.1,27.4,27.7; 2007.3,0.2494,25.6,26.1,27.5,27.7; 2011,
            0.2494,25.6,26.1,27.5,27.7; 2014.6,0.2494,25.6,26.2,27.5,27.7;
            2018.2,0.2494,25.6,26.2,27.5,27.7; 2021.9,0.2494,25.6,26.2,27.5,
            27.8; 2025.6,0.2494,25.6,26.2,27.5,27.8; 2029.2,0.2494,25.7,26.2,
            27.5,27.8; 2032.8,0.2494,25.7,26.2,27.5,27.8; 2036.6,0.2494,25.7,
            26.2,27.6,27.8; 2040.4,0.2494,25.7,26.3,27.6,27.8; 2044,0.2494,25.7,
            26.3,27.6,27.8; 2047.9,0.2494,25.7,26.3,27.6,27.8; 2051.6,0.2494,
            25.7,26.3,27.6,27.8; 2055.3,0.2494,25.7,26.3,27.6,27.8; 2058.8,
            0.2494,25.8,26.3,27.6,27.9; 2062.6,0.2494,25.8,26.3,27.6,27.9;
            2066.2,0.2494,25.8,26.4,27.6,27.9; 2069.9,0.2494,25.8,26.3,27.7,
            27.9; 2073.6,0.2494,25.8,26.4,27.7,27.9; 2077.2,0.2494,25.8,26.4,
            27.7,27.9; 2080.8,0.2494,25.8,26.4,27.7,27.9; 2084.5,0.2494,25.8,
            26.4,27.7,27.9; 2088.2,0.2494,25.8,26.4,27.7,27.9; 2091.9,0.2494,
            25.9,26.4,27.7,28; 2095.8,0.2494,25.9,26.5,27.7,28; 2099.6,0.2494,
            25.9,26.5,27.7,28; 2103.4,0.2494,25.9,26.5,27.8,28; 2107.1,0.2494,
            25.9,26.5,27.8,28; 2110.8,0.2494,25.9,26.5,27.8,28; 2114.5,0.2494,
            25.9,26.5,27.8,28; 2118.1,0.2494,26,26.5,27.8,28.1; 2121.9,0.2494,
            26,26.5,27.8,28.1; 2125.5,0.2494,26,26.5,27.8,28.1; 2129.1,0.2494,
            26,26.6,27.8,28.1; 2132.8,0.2494,26,26.6,27.8,28.1; 2136.5,0.2494,
            26,26.6,27.9,28.1; 2140.3,0.2494,26,26.6,27.9,28.1; 2146.1,0.2494,
            26,26.6,27.9,28.1; 2149.8,0.2494,26.1,26.6,27.9,28.1; 2154.6,0.2494,
            26.1,26.6,27.9,28.2; 2158.2,0.2494,26.1,26.7,27.9,28.2; 2161.9,
            0.2494,26.1,26.7,27.9,28.2; 2165.5,0.2494,26.1,26.7,27.9,28.2;
            2169.2,0.2494,26.1,26.7,28,28.2; 2175.1,0.2494,26.1,26.7,28,28.2;
            2178.8,0.2494,26.1,26.7,28,28.2; 2182.5,0.2494,26.2,26.7,28,28.2;
            2186.2,0.2494,26.2,26.8,28,28.2; 2190.1,0.2494,26.2,26.8,28,28.3;
            2193.8,0.2494,26.2,26.8,28,28.3; 2197.4,0.2494,26.2,26.8,28,28.3;
            2201.3,0.2494,26.2,26.8,28.1,28.3; 2205,0.2494,26.2,26.8,28.1,28.3;
            2208.6,0.2494,26.3,26.8,28.1,28.3; 2212.3,0.2494,26.3,26.9,28.1,
            28.3; 2216.1,0.2494,26.3,26.9,28.1,28.3; 2219.7,0.2494,26.3,26.9,
            28.1,28.3; 2223.4,0.2494,26.3,26.9,28.1,28.3; 2229.2,0.2494,26.3,
            26.9,28.1,28.4; 2233,0.2494,26.3,26.9,28.1,28.4; 2237.9,0.2494,26.4,
            26.9,28.1,28.4; 2241.5,0.2494,26.4,27,28.2,28.4; 2245.3,0.2494,26.4,
            27,28.2,28.4; 2249,0.2494,26.4,27,28.2,28.4; 2252.9,0.2494,26.4,27,
            28.2,28.4; 2256.9,0.2494,26.4,27,28.2,28.5; 2260.7,0.2494,26.4,27,
            28.2,28.5; 2264.4,0.2494,26.4,27,28.2,28.5; 2268.4,0.2494,26.4,27,
            28.3,28.5; 2272.5,0.2494,26.5,27.1,28.3,28.5; 2276.4,0.2494,26.5,
            27.1,28.3,28.5; 2280.2,0.2494,26.5,27.1,28.3,28.5; 2285.1,0.2494,
            26.5,27.1,28.3,28.5; 2288.9,0.2494,26.5,27.1,28.3,28.5; 2292.6,
            0.2494,26.5,27.1,28.3,28.5; 2296.4,0.2494,26.5,27.1,28.3,28.5;
            2300.1,0.2494,26.5,27.1,28.3,28.6; 2304,0.2494,26.5,27.2,28.3,28.6;
            2309.7,0.2494,26.6,27.2,28.4,28.6; 2313.5,0.2494,26.6,27.2,28.4,
            28.6; 2317.2,0.2494,26.6,27.2,28.4,28.6; 2320.9,0.2494,26.6,27.2,
            28.4,28.6; 2324.6,0.2494,26.6,27.2,28.4,28.6; 2328.4,0.2494,26.6,
            27.2,28.4,28.7; 2332.2,0.2494,26.6,27.2,28.4,28.7; 2335.9,0.2494,
            26.6,27.3,28.4,28.7; 2339.8,0.2494,26.7,27.3,28.4,28.7; 2343.6,
            0.2494,26.7,27.3,28.4,28.7; 2347.3,0.2494,26.7,27.3,28.5,28.7;
            2350.9,0.2494,26.7,27.3,28.5,28.7; 2355.6,0.2494,26.7,27.3,28.5,
            28.8; 2359.4,0.2494,26.7,27.3,28.5,28.8; 2363.3,0.2494,26.7,27.3,
            28.5,28.8; 2367.1,0.2494,26.7,27.4,28.5,28.8; 2370.8,0.2494,26.8,
            27.4,28.5,28.8; 2374.7,0.2494,26.8,27.4,28.5,28.8; 2379,0.2494,26.8,
            27.4,28.6,28.8; 2382.8,0.2494,26.8,27.4,28.6,28.8; 2386.7,0.2494,
            26.8,27.4,28.6,28.8; 2390.5,0.2494,26.8,27.4,28.6,28.8; 2394.2,
            0.2494,26.8,27.4,28.6,28.8; 2398.2,0.2494,26.8,27.4,28.6,28.9;
            2404.1,0.2494,26.8,27.5,28.6,28.9; 2407.8,0.2494,26.8,27.5,28.6,
            28.9; 2411.8,0.2494,26.9,27.5,28.7,28.9; 2415.5,0.2494,26.9,27.5,
            28.7,28.9; 2419.3,0.2494,26.9,27.5,28.7,28.9; 2423.1,0.2494,26.9,
            27.5,28.7,28.9; 2427,0.2494,26.9,27.5,28.7,28.9; 2430.7,0.2494,26.9,
            27.6,28.7,28.9; 2434.6,0.2494,26.9,27.6,28.7,28.9; 2438.5,0.2494,27,
            27.6,28.7,29; 2442.4,0.2494,27,27.6,28.7,29; 2446.3,0.2494,27,27.6,
            28.7,29; 2450,0.2494,27,27.6,28.7,29; 2454,0.2494,27,27.6,28.8,29;
            2458.1,0.2494,27,27.6,28.8,29; 2462.1,0.2494,27,27.6,28.8,29; 2466,
            0.2494,27,27.7,28.8,29; 2470.1,0.2494,27,27.7,28.8,29; 2474.2,
            0.2494,27,27.7,28.8,29.1; 2478.2,0.2494,27.1,27.7,28.8,29.1; 2482.2,
            0.2494,27.1,27.7,28.8,29.1; 2486.2,0.2494,27.1,27.7,28.8,29.1; 2490,
            0.2494,27.1,27.7,28.9,29.1; 2493.9,0.2494,27.1,27.7,28.9,29.1;
            2497.9,0.2494,27.1,27.8,28.9,29.1; 2502.1,0.2494,27.1,27.8,28.9,
            29.2; 2508,0.2494,27.1,27.8,28.9,29.2; 2511.9,0.2494,27.2,27.8,28.9,
            29.2; 2515.9,0.2494,27.2,27.8,28.9,29.2; 2519.7,0.2494,27.2,27.8,
            28.9,29.2; 2523.5,0.2494,27.2,27.8,29,29.2; 2527.5,0.2494,27.2,27.8,
            29,29.2; 2531.3,0.2494,27.2,27.9,29,29.2; 2535.3,0.2494,27.2,27.9,
            29,29.2; 2539.3,0.2494,27.2,27.9,29,29.2; 2543.1,0.2494,27.2,27.9,
            29,29.2; 2547,0.2494,27.2,27.9,29,29.3; 2550.8,0.2494,27.3,27.9,29,
            29.3; 2554.8,0.2494,27.3,27.9,29,29.3; 2558.8,0.2494,27.3,27.9,29,
            29.3; 2562.8,0.2494,27.3,28,29.1,29.3; 2566.7,0.2494,27.3,28,29.1,
            29.3; 2570.7,0.2494,27.3,28,29.1,29.3; 2574.9,0.2494,27.3,28,29.1,
            29.3; 2578.7,0.2494,27.3,28,29.1,29.3; 2582.7,0.2494,27.3,28,29.1,
            29.4; 2586.6,0.2494,27.4,28,29.1,29.4; 2590.5,0.2494,27.4,28,29.1,
            29.4; 2594.5,0.2494,27.4,28.1,29.1,29.4; 2598.5,0.2494,27.4,28.1,
            29.1,29.4; 2602.5,0.2494,27.4,28.1,29.1,29.4; 2606.5,0.2494,27.4,
            28.1,29.2,29.4; 2610.5,0.2494,27.4,28.1,29.2,29.4; 2614.4,0.2494,
            27.4,28.1,29.2,29.4; 2618.4,0.2494,27.4,28.1,29.2,29.4; 2622.6,
            0.2494,27.5,28.1,29.2,29.4; 2626.4,0.2494,27.5,28.1,29.2,29.5;
            2630.4,0.2494,27.5,28.2,29.2,29.5; 2634.3,0.2494,27.5,28.2,29.2,
            29.5; 2638.5,0.2494,27.5,28.2,29.2,29.5; 2642.4,0.2494,27.5,28.2,
            29.3,29.5; 2646.3,0.2494,27.5,28.2,29.3,29.5; 2650.2,0.2494,27.5,
            28.2,29.3,29.5; 2654.2,0.2494,27.5,28.2,29.3,29.5; 2658.4,0.2494,
            27.6,28.2,29.3,29.6; 2662.3,0.2494,27.6,28.2,29.3,29.6; 2666.4,
            0.2494,27.6,28.3,29.3,29.6; 2670.3,0.2494,27.6,28.3,29.3,29.6;
            2674.3,0.2494,27.6,28.3,29.3,29.6; 2678.4,0.2494,27.6,28.3,29.3,
            29.6; 2682.3,0.2494,27.6,28.3,29.4,29.6; 2686.2,0.2494,27.6,28.3,
            29.4,29.6; 2690.3,0.2494,27.6,28.3,29.4,29.6; 2694.3,0.2494,27.6,
            28.3,29.4,29.6; 2698.4,0.2494,27.7,28.4,29.4,29.6; 2702.5,0.2494,
            27.7,28.4,29.4,29.7; 2706.5,0.2494,27.7,28.4,29.4,29.7; 2710.4,
            0.2494,27.7,28.4,29.4,29.7; 2714.3,0.2494,27.7,28.4,29.4,29.7;
            2718.4,0.2494,27.7,28.4,29.5,29.7; 2722.4,0.2494,27.7,28.4,29.5,
            29.7; 2726.5,0.2494,27.7,28.4,29.5,29.7; 2730.6,0.2494,27.7,28.4,
            29.5,29.7; 2734.6,0.2494,27.8,28.5,29.5,29.8; 2738.5,0.2494,27.8,
            28.5,29.5,29.7; 2742.5,0.2494,27.8,28.5,29.5,29.8; 2746.6,0.2494,
            27.8,28.5,29.5,29.8; 2750.8,0.2494,27.8,28.5,29.5,29.8; 2754.8,
            0.2494,27.8,28.5,29.5,29.8; 2758.8,0.2494,27.8,28.5,29.6,29.8;
            2762.7,0.2494,27.8,28.5,29.6,29.8; 2766.6,0.2494,27.8,28.5,29.6,
            29.8; 2770.5,0.2494,27.9,28.6,29.6,29.8; 2774.4,0.2494,27.9,28.6,
            29.6,29.8; 2778.6,0.2494,27.9,28.6,29.6,29.9; 2782.8,0.2494,27.9,
            28.6,29.6,29.9; 2786.9,0.2494,27.9,28.6,29.6,29.9; 2790.8,0.2494,
            27.9,28.6,29.6,29.9; 2794.7,0.2494,27.9,28.6,29.6,29.9; 2798.6,
            0.2494,27.9,28.6,29.6,29.9; 2802.6,0.2494,27.9,28.6,29.7,29.9;
            2806.7,0.2494,28,28.7,29.7,29.9; 2810.7,0.2494,28,28.7,29.7,29.9;
            2814.8,0.2494,28,28.7,29.7,29.9; 2818.7,0.2494,28,28.7,29.7,30;
            2822.5,0.2494,28,28.7,29.7,30; 2826.6,0.2494,28,28.7,29.7,30;
            2830.5,0.2494,28,28.7,29.7,30; 2834.7,0.2494,28,28.7,29.7,30;
            2838.6,0.2494,28,28.7,29.7,30; 2842.4,0.2494,28,28.7,29.7,30;
            2846.4,0.2494,28.1,28.8,29.8,30; 2850.5,0.2494,28.1,28.8,29.8,30;
            2854.4,0.2494,28.1,28.8,29.8,30; 2858.5,0.2494,28.1,28.8,29.8,30.1;
            2862.5,0.2494,28.1,28.8,29.8,30.1; 2866.4,0.2494,28.1,28.8,29.8,
            30.1; 2870.7,0.2494,28.1,28.8,29.8,30.1; 2874.6,0.2494,28.1,28.8,
            29.8,30.1; 2878.4,0.2494,28.1,28.8,29.8,30.1; 2882.5,0.2494,28.1,
            28.9,29.8,30.1; 2886.6,0.2494,28.1,28.9,29.9,30.1; 2890.4,0.2494,
            28.2,28.9,29.9,30.1; 2894.7,0.2494,28.2,28.9,29.9,30.1; 2898.7,
            0.2494,28.2,28.9,29.9,30.1; 2902.5,0.2494,28.2,28.9,29.9,30.2;
            2906.6,0.2494,28.2,28.9,29.9,30.2; 2914.7,0.2494,28.2,28.9,29.9,
            30.2; 2918.6,0.2494,28.2,29,29.9,30.2; 2922.5,0.2494,28.2,29,30,
            30.2; 2926.4,0.2494,28.2,29,30,30.2; 2930.5,0.2494,28.2,29,30,30.2;
            2934.5,0.2494,28.3,29,30,30.2; 2938.6,0.2494,28.3,29,30,30.3;
            2942.4,0.2494,28.3,29,30,30.3; 2946.7,0.2494,28.3,29,30,30.3;
            2950.8,0.2494,28.3,29,30,30.3; 2954.8,0.2494,28.3,29,30,30.3;
            2958.9,0.2494,28.3,29.1,30,30.3; 2962.9,0.2494,28.3,29.1,30.1,30.3;
            2967.1,0.2494,28.3,29.1,30.1,30.3; 2971.1,0.2494,28.4,29.1,30.1,
            30.3; 2975.1,0.2494,28.4,29.1,30.1,30.3; 2979.3,0.2494,28.4,29.1,
            30.1,30.3; 2983.4,0.2494,28.4,29.1,30.1,30.3; 2987.3,0.2494,28.4,
            29.1,30.1,30.4; 2991.4,0.2494,28.4,29.1,30.1,30.4; 2995.4,0.2494,
            28.4,29.2,30.1,30.4; 2999.4,0.2494,28.4,29.2,30.1,30.4; 3003.6,
            0.2494,28.4,29.2,30.1,30.4; 3007.6,0.2494,28.4,29.2,30.1,30.4;
            3011.6,0.2494,28.4,29.2,30.2,30.4; 3015.7,0.2494,28.5,29.2,30.2,
            30.4; 3019.6,0.2494,28.5,29.2,30.2,30.4; 3023.6,0.2494,28.5,29.2,
            30.2,30.5; 3027.5,0.2494,28.5,29.2,30.2,30.5; 3031.6,0.2494,28.5,
            29.2,30.2,30.5; 3035.6,0.2494,28.5,29.3,30.2,30.5; 3039.7,0.2494,
            28.5,29.3,30.2,30.5; 3043.6,0.2494,28.5,29.3,30.2,30.5; 3047.6,
            0.2494,28.5,29.3,30.3,30.5; 3051.5,0.2494,28.6,29.3,30.3,30.5;
            3055.6,0.2494,28.5,29.3,30.3,30.5; 3059.7,0.2494,28.6,29.3,30.3,
            30.5; 3063.7,0.2494,28.6,29.3,30.3,30.6; 3067.8,0.2494,28.6,29.4,
            30.3,30.6; 3071.8,0.2494,28.6,29.4,30.3,30.6; 3075.8,0.2494,28.6,
            29.4,30.3,30.6; 3079.9,0.2494,28.6,29.4,30.3,30.6; 3083.9,0.2494,
            28.6,29.4,30.3,30.6; 3088,0.2494,28.6,29.4,30.3,30.6; 3092.1,0.2494,
            28.6,29.4,30.4,30.6; 3097,0.2494,28.7,29.4,30.4,30.6; 3101.6,0.2494,
            28.7,29.4,30.4,30.6; 3105.7,0.2494,28.7,29.4,30.4,30.6; 3109.8,
            0.2494,28.7,29.5,30.4,30.6; 3114,0.2494,28.7,29.5,30.4,30.6; 3118.2,
            0.2494,28.7,29.5,30.4,30.7; 3122.5,0.2494,28.7,29.5,30.4,30.7;
            3126.5,0.2494,28.7,29.5,30.4,30.7; 3130.8,0.2494,28.7,29.5,30.4,
            30.7; 3135.4,0.2494,28.7,29.5,30.4,30.7; 3139.5,0.2494,28.8,29.5,
            30.4,30.7; 3143.6,0.2494,28.7,29.5,30.4,30.7; 3147.7,0.2494,28.8,
            29.5,30.4,30.7; 3151.7,0.2494,28.8,29.6,30.5,30.7; 3156,0.2494,28.8,
            29.6,30.5,30.7; 3160.1,0.2494,28.8,29.6,30.5,30.8; 3164.1,0.2494,
            28.8,29.6,30.5,30.8; 3168.1,0.2494,28.8,29.6,30.5,30.8; 3172.2,
            0.2494,28.8,29.6,30.5,30.8; 3176.7,0.2494,28.8,29.6,30.5,30.8;
            3180.6,0.2494,28.8,29.6,30.5,30.8; 3184.6,0.2494,28.9,29.6,30.6,
            30.8; 3188.8,0.2494,28.9,29.7,30.6,30.8; 3193,0.2494,28.9,29.7,30.6,
            30.9; 3197,0.2494,28.9,29.7,30.6,30.9; 3201.1,0.2494,28.9,29.7,30.6,
            30.9; 3205.2,0.2494,28.9,29.7,30.6,30.9; 3209.6,0.2494,28.9,29.7,
            30.6,30.9; 3213.8,0.2494,28.9,29.7,30.6,30.9; 3218.1,0.2494,28.9,
            29.7,30.6,30.9; 3222.3,0.2494,28.9,29.7,30.6,30.9; 3226.4,0.2494,29,
            29.7,30.6,30.9; 3230.6,0.2494,29,29.7,30.6,30.9; 3234.6,0.2494,29,
            29.8,30.7,30.9; 3238.7,0.2494,29,29.8,30.7,30.9; 3242.7,0.2494,29,
            29.8,30.7,30.9; 3246.7,0.2494,29,29.8,30.7,31; 3250.9,0.2494,29,
            29.8,30.7,30.9; 3255,0.2494,29,29.8,30.7,31; 3259.1,0.2494,29,29.8,
            30.7,31; 3263.2,0.2494,29,29.8,30.7,31; 3267.3,0.2494,29,29.8,30.7,
            31; 3271.4,0.2494,29.1,29.8,30.7,31; 3275.4,0.2494,29.1,29.9,30.7,
            31; 3279.6,0.2494,29.1,29.9,30.8,31; 3283.7,0.2494,29.1,29.9,30.8,
            31; 3287.8,0.2494,29.1,29.9,30.8,31; 3292.1,0.2494,29.1,29.9,30.8,
            31.1; 3296.5,0.2494,29.1,29.9,30.8,31; 3300.6,0.2494,29.1,29.9,30.8,
            31.1; 3305,0.2494,29.1,29.9,30.8,31.1; 3309.2,0.2494,29.2,29.9,30.8,
            31.1; 3313.4,0.2494,29.2,30,30.8,31.1; 3317.7,0.2494,29.2,30,30.8,
            31.1; 3322.9,0.2494,29.2,30,30.9,31.1; 3327,0.2494,29.2,30,30.9,
            31.1; 3331.3,0.2494,29.2,30,30.9,31.1; 3335.4,0.2494,29.2,30,30.9,
            31.1; 3339.7,0.2494,29.2,30,30.9,31.2; 3343.7,0.2494,29.2,30,30.9,
            31.2; 3347.8,0.2494,29.2,30,30.9,31.2; 3351.9,0.2494,29.3,30,30.9,
            31.2; 3356.1,0.2494,29.3,30.1,30.9,31.2; 3360.5,0.2494,29.3,30.1,
            30.9,31.2; 3364.7,0.2494,29.3,30.1,30.9,31.2; 3368.9,0.2494,29.3,
            30.1,30.9,31.2; 3373,0.2494,29.3,30.1,30.9,31.2; 3377.1,0.2494,29.3,
            30.1,31,31.2; 3381.6,0.2494,29.3,30.1,31,31.2; 3385.8,0.2494,29.3,
            30.1,31,31.3; 3391,0.2494,29.3,30.1,31,31.3; 3395.2,0.2494,29.3,
            30.2,31,31.3; 3399.2,0.2494,29.4,30.2,31,31.3; 3403.4,0.2494,29.4,
            30.2,31,31.3; 3407.7,0.2494,29.4,30.2,31,31.3; 3411.8,0.2494,29.4,
            30.2,31,31.3; 3416.1,0.2494,29.4,30.2,31,31.3; 3420.3,0.2494,29.4,
            30.2,31,31.3; 3424.5,0.2494,29.4,30.2,31.1,31.3; 3428.7,0.2494,29.4,
            30.2,31.1,31.3; 3432.8,0.2494,29.4,30.2,31.1,31.3; 3437,0.2494,29.4,
            30.3,31.1,31.3; 3441.5,0.2494,29.5,30.3,31.1,31.4; 3445.6,0.2494,
            29.5,30.3,31.1,31.4; 3449.9,0.2494,29.5,30.3,31.1,31.4; 3454,0.2494,
            29.5,30.3,31.1,31.3; 3458.1,0.2494,29.5,30.3,31.1,31.4; 3462.2,
            0.2494,29.5,30.3,31.1,31.4; 3466.3,0.2494,29.5,30.3,31.1,31.4;
            3470.5,0.2494,29.5,30.3,31.1,31.4; 3474.7,0.2494,29.5,30.3,31.1,
            31.4; 3478.9,0.2494,29.5,30.3,31.2,31.4; 3483.2,0.2494,29.5,30.4,
            31.2,31.4; 3489.4,0.2494,29.5,30.4,31.2,31.4; 3493.7,0.2494,29.6,
            30.4,31.2,31.4; 3498,0.2494,29.6,30.4,31.2,31.5; 3502.4,0.2494,29.6,
            30.4,31.2,31.5; 3506.5,0.2494,29.6,30.4,31.2,31.5; 3510.8,0.2494,
            29.6,30.4,31.2,31.5; 3514.9,0.2494,29.6,30.4,31.2,31.5; 3519.1,
            0.2494,29.6,30.4,31.2,31.5; 3523.4,0.2494,29.6,30.4,31.2,31.5;
            3527.8,0.2494,29.6,30.4,31.2,31.5; 3532.5,0.2494,29.6,30.4,31.2,
            31.5; 3536.6,0.2494,29.6,30.5,31.3,31.6; 3541.1,0.2494,29.6,30.5,
            31.3,31.5; 3545.2,0.2494,29.7,30.5,31.3,31.6; 3549.8,0.2494,29.7,
            30.5,31.3,31.6; 3554.3,0.2494,29.7,30.5,31.3,31.5; 3558.7,0.2494,
            29.7,30.5,31.3,31.6; 3563,0.2494,29.7,30.5,31.3,31.6; 3567.3,0.2494,
            29.7,30.5,31.3,31.6; 3571.6,0.2494,29.7,30.6,31.3,31.6; 3578,0.2494,
            29.7,30.6,31.3,31.6; 3582.2,0.2494,29.7,30.6,31.3,31.6; 3586.7,
            0.2494,29.7,30.6,31.4,31.6; 3591.2,0.2494,29.8,30.6,31.4,31.6; 3596,
            0.2494,29.8,30.6,31.4,31.6; 3600.3,0.2494,29.8,30.6,31.4,31.6;
            3604.7,0.2494,29.8,30.6,31.4,31.6; 3609.5,0.2494,29.8,30.6,31.4,
            31.7; 3614,0.2494,29.8,30.7,31.4,31.7; 3618.2,0.2494,29.8,30.7,31.4,
            31.7; 3624.5,0.2494,29.8,30.7,31.4,31.7; 3628.7,0.2494,29.8,30.7,
            31.4,31.7; 3632.9,0.2494,29.8,30.7,31.5,31.7; 3637.3,0.2494,29.8,
            30.7,31.4,31.7; 3643.8,0.2494,29.9,30.7,31.5,31.7; 3648.3,0.2494,
            29.9,30.7,31.5,31.7; 3652.7,0.2494,29.9,30.7,31.5,31.7; 3657,0.2494,
            29.9,30.7,31.5,31.8; 3661.7,0.2494,29.9,30.7,31.5,31.8; 3665.9,
            0.2494,29.9,30.7,31.5,31.8; 3670.6,0.2494,29.9,30.8,31.5,31.8;
            3674.8,0.2494,29.9,30.8,31.5,31.8; 3679,0.2494,29.9,30.8,31.5,31.8;
            3683.6,0.2494,29.9,30.8,31.5,31.8; 3688,0.2494,29.9,30.8,31.5,31.8;
            3692.5,0.2494,30,30.8,31.5,31.8; 3696.8,0.2494,30,30.8,31.6,31.8;
            3701.7,0.2494,30,30.8,31.5,31.8; 3706,0.2494,30,30.8,31.6,31.8;
            3710.5,0.2494,30,30.9,31.6,31.9; 3714.8,0.2494,30,30.9,31.6,31.9;
            3719.2,0.2494,30,30.9,31.6,31.9; 3723.6,0.2494,30,30.9,31.6,31.9;
            3728.1,0.2494,30,30.9,31.6,31.9; 3733.2,0.2494,30.1,30.9,31.6,31.9;
            3737.6,0.2494,30.1,30.9,31.6,31.9; 3741.9,0.2494,30.1,30.9,31.6,
            31.9; 3746.2,0.2494,30.1,30.9,31.7,31.9; 3750.5,0.2494,30.1,30.9,
            31.7,31.9; 3754.7,0.2494,30.1,30.9,31.7,31.9; 3758.9,0.2494,30.1,31,
            31.7,31.9; 3765.2,0.2494,30.1,31,31.7,31.9; 3769.5,0.2494,30.1,31,
            31.7,32; 3773.8,0.2494,30.1,31,31.7,32; 3778.9,0.2494,30.1,31,31.7,
            32; 3783.1,0.2494,30.1,31,31.7,32; 3787.5,0.2494,30.1,31,31.7,32;
            3791.8,0.2494,30.1,31,31.7,32; 3796.4,0.2494,30.2,31,31.7,32;
            3800.8,0.2494,30.2,31,31.8,32; 3805.3,0.2494,30.2,31,31.7,32;
            3809.8,0.2494,30.2,31.1,31.8,32; 3814.3,0.2494,30.2,31.1,31.8,32;
            3818.5,0.2494,30.2,31.1,31.8,32; 3822.9,0.2494,30.2,31.1,31.8,32.1;
            3827.4,0.2494,30.2,31.1,31.8,32.1; 3833.8,0.2494,30.2,31.1,31.8,
            32.1; 3838,0.2494,30.2,31.1,31.8,32.1; 3842.3,0.2494,30.3,31.1,31.8,
            32.1; 3846.7,0.2494,30.3,31.1,31.8,32.1; 3851.3,0.2494,30.3,31.1,
            31.8,32.1; 3857.9,0.2494,30.3,31.2,31.8,32.1; 3862.3,0.2494,30.3,
            31.2,31.8,32.1; 3866.7,0.2494,30.3,31.2,31.8,32.1; 3871.6,0.2494,
            30.3,31.2,31.9,32.1; 3876,0.2494,30.3,31.2,31.9,32.1; 3880.5,0.2494,
            30.3,31.2,31.9,32.1; 3885.1,0.2494,30.3,31.2,31.9,32.2; 3889.5,
            0.2494,30.3,31.2,31.9,32.2; 3893.9,0.2494,30.3,31.2,31.9,32.2;
            3898.3,0.2494,30.3,31.2,31.9,32.2; 3902.8,0.2494,30.4,31.2,31.9,
            32.2; 3907.4,0.2494,30.4,31.2,31.9,32.2; 3911.8,0.2494,30.4,31.2,
            31.9,32.2; 3916.3,0.2494,30.4,31.3,31.9,32.2; 3921.1,0.2494,30.4,
            31.3,31.9,32.2; 3925.4,0.2494,30.4,31.3,31.9,32.2; 3930,0.2494,30.4,
            31.3,31.9,32.2; 3934.3,0.2494,30.4,31.3,32,32.2; 3938.9,0.2494,30.4,
            31.3,32,32.2; 3943.4,0.2494,30.4,31.3,32,32.3; 3947.8,0.2494,30.4,
            31.3,32,32.3; 3952.1,0.2494,30.5,31.3,32,32.3; 3956.9,0.2494,30.5,
            31.3,32,32.3; 3961.9,0.2494,30.5,31.3,32,32.3; 3966.8,0.2494,30.5,
            31.4,32,32.3; 3971.9,0.2494,30.5,31.4,32,32.3; 3976.7,0.2494,30.5,
            31.4,32,32.3; 3981.2,0.2494,30.5,31.4,32,32.3; 3985.9,0.2494,30.5,
            31.4,32,32.3; 3990.8,0.2494,30.5,31.4,32.1,32.3; 3995.9,0.2494,30.5,
            31.4,32.1,32.3; 4000.8,0.2494,30.5,31.4,32.1,32.3; 4006.1,0.2494,
            30.5,31.4,32.1,32.4; 4010.3,0.2494,30.6,31.4,32.1,32.4; 4014.9,
            0.2494,30.6,31.4,32.1,32.4; 4019.4,0.2494,30.6,31.5,32.1,32.4;
            4023.9,0.2494,30.6,31.4,32.1,32.4; 4028.6,0.2494,30.6,31.5,32.1,
            32.4; 4033,0.2494,30.6,31.5,32.1,32.4; 4037.5,0.2494,30.6,31.5,32.1,
            32.4; 4041.9,0.2494,30.6,31.5,32.1,32.4; 4046.5,0.2494,30.6,31.5,
            32.1,32.4; 4050.9,0.2494,30.6,31.5,32.1,32.4; 4056.2,0.2494,30.6,
            31.5,32.1,32.4; 4060.8,0.2494,30.6,31.5,32.1,32.4; 4065.6,0.2494,
            30.6,31.5,32.2,32.4; 4070.3,0.2494,30.6,31.5,32.2,32.4; 4074.8,
            0.2494,30.6,31.6,32.2,32.4; 4079.8,0.2494,30.6,31.6,32.2,32.4;
            4084.8,0.2494,30.7,31.6,32.2,32.4; 4090.1,0.2494,30.7,31.6,32.2,
            32.5; 4094.7,0.2494,30.7,31.6,32.2,32.4; 4099.7,0.2494,30.7,31.6,
            32.2,32.4; 4104.6,0.2494,30.7,31.6,32.2,32.4; 4109.7,0.2494,30.7,
            31.6,32.2,32.5; 4114.8,0.2494,30.7,31.6,32.2,32.5; 4119.7,0.2494,
            30.7,31.6,32.2,32.5; 4124.6,0.2494,30.7,31.7,32.2,32.5; 4129.9,
            0.2494,30.7,31.7,32.2,32.5; 4134.6,0.2494,30.8,31.7,32.2,32.5;
            4139.5,0.2494,30.8,31.7,32.2,32.5; 4144.4,0.2494,30.8,31.7,32.2,
            32.5; 4149.4,0.2494,30.8,31.7,32.2,32.5; 4154.3,0.2494,30.8,31.7,
            32.3,32.5; 4158.9,0.2494,30.8,31.7,32.3,32.5; 4163.9,0.2494,30.8,
            31.7,32.2,32.5; 4168.7,0.2494,30.8,31.7,32.3,32.5; 4173.8,0.2494,
            30.8,31.7,32.3,32.5; 4178.3,0.2494,30.8,31.7,32.3,32.5; 4183.1,
            0.2494,30.8,31.7,32.3,32.6; 4187.9,0.2494,30.8,31.8,32.3,32.6;
            4192.7,0.2494,30.8,31.8,32.3,32.6; 4197.9,0.2494,30.8,31.8,32.3,
            32.6; 4202.9,0.2494,30.9,31.8,32.3,32.6; 4207.9,0.2494,30.9,31.8,
            32.3,32.6; 4212.9,0.2494,30.9,31.8,32.3,32.6; 4217.8,0.2494,30.9,
            31.8,32.3,32.6; 4222.8,0.2494,30.9,31.8,32.4,32.6; 4227.9,0.2494,
            30.9,31.8,32.4,32.6; 4232.6,0.2494,30.9,31.8,32.3,32.6; 4237.6,
            0.2494,30.9,31.8,32.3,32.6; 4242.5,0.2494,30.9,31.8,32.4,32.6;
            4247.1,0.2494,30.9,31.9,32.4,32.6; 4251.9,0.2494,30.9,31.9,32.4,
            32.6; 4256.5,0.2494,30.9,31.9,32.4,32.6; 4261.1,0.2494,31,31.9,32.4,
            32.7; 4265.8,0.2494,31,31.9,32.4,32.7; 4270.8,0.2494,31,31.9,32.4,
            32.7; 4275.6,0.2494,31,31.9,32.4,32.7; 4280.3,0.2494,31,31.9,32.4,
            32.7; 4285.1,0.2494,31,31.9,32.4,32.7; 4290,0.2494,31,31.9,32.4,
            32.7; 4294.7,0.2494,31,31.9,32.4,32.7; 4299.5,0.2494,31,31.9,32.4,
            32.7; 4304.5,0.2494,31,31.9,32.4,32.7; 4309.1,0.2494,31,32,32.4,
            32.7; 4314.1,0.2494,31,32,32.5,32.7; 4318.8,0.2494,31,32,32.5,32.8;
            4323.9,0.2494,31,32,32.5,32.8; 4329.1,0.2494,31.1,32,32.5,32.8;
            4333.8,0.2494,31.1,32,32.5,32.8; 4338.7,0.2494,31.1,32,32.5,32.8;
            4343.7,0.2494,31.1,32,32.5,32.8; 4348.6,0.2494,31.1,32,32.5,32.8;
            4353.8,0.2494,31.1,32,32.5,32.8; 4358.8,0.2494,31.1,32,32.5,32.8;
            4363.7,0.2494,31.1,32,32.5,32.8; 4368.3,0.2494,31.1,32,32.5,32.8;
            4373,0.2494,31.1,32.1,32.6,32.8; 4378,0.2494,31.1,32,32.5,32.8;
            4383.1,0.2494,31.1,32.1,32.6,32.9; 4387.9,0.2494,31.2,32.1,32.6,
            32.9; 4392.8,0.2494,31.2,32.1,32.6,32.9; 4398.1,0.2494,31.2,32.1,
            32.6,32.9; 4402.8,0.2494,31.2,32.1,32.6,32.9; 4408.1,0.2494,31.2,
            32.1,32.6,32.9; 4413.1,0.2494,31.2,32.1,32.6,32.9; 4417.8,0.2494,
            31.2,32.1,32.6,32.9; 4422.7,0.2494,31.2,32.1,32.6,32.9; 4427.6,
            0.2494,31.2,32.1,32.7,32.9; 4432.4,0.2494,31.2,32.1,32.6,32.9;
            4437.3,0.2494,31.2,32.1,32.6,32.9; 4442.3,0.2494,31.2,32.2,32.6,
            32.9; 4447,0.2494,31.2,32.2,32.7,32.9; 4451.7,0.2494,31.2,32.2,32.7,
            32.9; 4456.6,0.2494,31.2,32.2,32.7,32.9; 4461.2,0.2494,31.2,32.2,
            32.7,32.9; 4466.5,0.2494,31.2,32.2,32.7,32.9; 4471.2,0.2494,31.2,
            32.2,32.7,32.9; 4476.2,0.2494,31.2,32.2,32.7,33; 4481,0.2494,31.3,
            32.2,32.7,33; 4486.1,0.2494,31.3,32.2,32.7,33; 4491.3,0.2494,31.3,
            32.2,32.7,33; 4496.1,0.2494,31.3,32.2,32.7,33; 4501.2,0.2494,31.3,
            32.2,32.7,33; 4506.3,0.2494,31.3,32.2,32.7,33; 4511.5,0.2494,31.3,
            32.2,32.7,33; 4516.2,0.2494,31.3,32.3,32.7,33; 4521,0.2494,31.3,
            32.3,32.7,33; 4525.6,0.2494,31.3,32.3,32.7,33; 4530.1,0.2494,31.3,
            32.3,32.7,33; 4534.7,0.2494,31.3,32.3,32.7,33; 4539.3,0.2494,31.3,
            32.3,32.8,33; 4544.4,0.2494,31.3,32.3,32.8,33; 4549.3,0.2494,31.3,
            32.3,32.8,33; 4554.3,0.2494,31.3,32.3,32.8,33.1; 4559.4,0.2494,31.3,
            32.3,32.8,33.1; 4564.4,0.2494,31.3,32.3,32.8,33.1; 4569.7,0.2494,
            31.4,32.3,32.8,33.1; 4574.3,0.2494,31.4,32.3,32.8,33.1; 4579.1,
            0.2494,31.4,32.3,32.8,33.1; 4584.4,0.2494,31.4,32.3,32.8,33.1;
            4589.4,0.2494,31.4,32.3,32.8,33.1; 4594.2,0.2494,31.4,32.3,32.8,
            33.1; 4599.5,0.2494,31.4,32.3,32.8,33.1; 4604.3,0.2494,31.4,32.3,
            32.8,33.1; 4609.4,0.2494,31.4,32.4,32.9,33.1; 4614.3,0.2494,31.4,
            32.4,32.9,33.1; 4619.1,0.2494,31.4,32.4,32.8,33.1; 4624.2,0.2494,
            31.4,32.4,32.9,33.1; 4629,0.2494,31.4,32.4,32.9,33.1; 4633.7,0.2494,
            31.4,32.4,32.9,33.1; 4638.4,0.2494,31.4,32.4,32.9,33.2; 4643.2,
            0.2494,31.4,32.4,32.9,33.2; 4648.4,0.2494,31.4,32.4,32.9,33.2;
            4653.4,0.2494,31.4,32.4,32.9,33.2; 4658.1,0.2494,31.5,32.4,32.9,
            33.2; 4663,0.2494,31.5,32.4,32.9,33.2; 4668,0.2494,31.5,32.4,32.9,
            33.2; 4673.3,0.2494,31.5,32.4,32.9,33.2; 4678.2,0.2494,31.5,32.5,
            32.9,33.2; 4683.1,0.2494,31.5,32.5,32.9,33.2; 4687.8,0.2494,31.5,
            32.5,32.9,33.2; 4692.7,0.2494,31.5,32.5,32.9,33.2; 4697.7,0.2494,
            31.5,32.5,32.9,33.2; 4702.4,0.2494,31.5,32.5,33,33.2; 4707.2,0.2494,
            31.5,32.5,33,33.2; 4712.1,0.2494,31.5,32.5,33,33.2; 4717.1,0.2494,
            31.5,32.5,33,33.2; 4722.2,0.2494,31.5,32.5,33,33.2; 4727.2,0.2494,
            31.5,32.5,33,33.2; 4732.3,0.2494,31.5,32.5,33,33.2; 4737.2,0.2494,
            31.5,32.5,33,33.3; 4742.2,0.2494,31.6,32.5,33,33.2; 4747.4,0.2494,
            31.6,32.5,33,33.3; 4752.6,0.2494,31.6,32.5,33,33.3; 4757.3,0.2494,
            31.6,32.6,33,33.3; 4762.4,0.2494,31.6,32.6,33,33.3; 4767.6,0.2494,
            31.6,32.6,33,33.3; 4773,0.2494,31.6,32.6,33,33.3; 4778,0.2494,31.6,
            32.6,33,33.3; 4782.8,0.2494,31.6,32.6,33,33.3; 4787.6,0.2494,31.6,
            32.6,33,33.3; 4792.8,0.2494,31.6,32.6,33,33.3; 4797.5,0.2494,31.6,
            32.6,33,33.3; 4802.7,0.2494,31.6,32.6,33,33.3; 4807.6,0.2494,31.7,
            32.6,33.1,33.3; 4812.9,0.2494,31.6,32.6,33.1,33.3; 4817.8,0.2494,
            31.7,32.6,33.1,33.4; 4822.7,0.2494,31.7,32.7,33.1,33.4; 4827.5,
            0.2494,31.7,32.7,33.1,33.4; 4832.6,0.2494,31.7,32.7,33.1,33.4;
            4837.6,0.2494,31.7,32.7,33.1,33.4; 4843,0.2494,31.7,32.7,33.1,33.4;
            4847.7,0.2494,31.7,32.7,33.1,33.4; 4853.2,0.2494,31.7,32.7,33.1,
            33.4; 4858,0.2494,31.7,32.7,33.1,33.4; 4863.1,0.2494,31.7,32.7,33.1,
            33.4; 4868.2,0.2494,31.7,32.7,33.1,33.4; 4873.2,0.2494,31.7,32.7,
            33.1,33.4; 4878.6,0.2494,31.7,32.7,33.1,33.4; 4883.6,0.2494,31.7,
            32.7,33.1,33.4; 4888.6,0.2494,31.7,32.7,33.1,33.4; 4893.8,0.2494,
            31.7,32.7,33.2,33.4; 4898.3,0.2494,31.8,32.7,33.2,33.4; 4903.5,
            0.2494,31.8,32.8,33.2,33.4; 4908.5,0.2494,31.8,32.7,33.2,33.4;
            4913.8,0.2494,31.8,32.8,33.2,33.4; 4918.5,0.2494,31.8,32.8,33.2,
            33.4; 4923.6,0.2494,31.8,32.8,33.2,33.4; 4928.5,0.2494,31.8,32.8,
            33.2,33.5; 4933.4,0.2494,31.8,32.8,33.2,33.5; 4938.6,0.2494,31.8,
            32.8,33.2,33.5; 4943.6,0.2494,31.8,32.8,33.2,33.5; 4948.6,0.2494,
            31.8,32.8,33.2,33.5; 4953.5,0.2494,31.8,32.8,33.2,33.5; 4958.7,
            0.2494,31.8,32.8,33.2,33.5; 4963.9,0.2494,31.8,32.8,33.2,33.5;
            4969.1,0.2494,31.8,32.8,33.2,33.5; 4974.5,0.2494,31.8,32.8,33.2,
            33.5; 4979.7,0.2494,31.8,32.8,33.2,33.5; 4984.7,0.2494,31.9,32.9,
            33.2,33.5; 4989.7,0.2494,31.9,32.9,33.2,33.5; 4994.7,0.2494,31.9,
            32.9,33.2,33.5; 4999.4,0.2494,31.9,32.9,33.2,33.5; 5004.5,0.2494,
            31.9,32.9,33.2,33.5; 5009.7,0.2494,31.9,32.9,33.3,33.5; 5014.9,
            0.2494,31.9,32.9,33.3,33.5; 5019.9,0.2494,31.9,32.9,33.3,33.6;
            5024.9,0.2494,31.9,32.9,33.3,33.6; 5029.9,0.2494,31.9,32.9,33.3,
            33.6; 5035,0.2494,31.9,32.9,33.3,33.6; 5039.8,0.2494,31.9,32.9,33.3,
            33.6; 5044.9,0.2494,31.9,32.9,33.3,33.6; 5049.5,0.2494,31.9,32.9,
            33.3,33.6; 5054.9,0.2494,31.9,32.9,33.3,33.6; 5059.9,0.2494,31.9,
            32.9,33.3,33.6; 5065,0.2494,31.9,32.9,33.3,33.6; 5070,0.2494,31.9,
            33,33.3,33.6; 5074.9,0.2494,31.9,33,33.3,33.6; 5079.8,0.2494,31.9,
            33,33.3,33.6; 5084.8,0.2494,31.9,33,33.3,33.6; 5089.8,0.2494,31.9,
            33,33.3,33.6; 5094.9,0.2494,32,33,33.3,33.6; 5099.7,0.2494,32,33,
            33.3,33.6; 5104.6,0.2494,32,33,33.4,33.6; 5109.6,0.2494,32,33,33.3,
            33.6; 5114.7,0.2494,32,33,33.4,33.6; 5119.8,0.2494,32,33,33.4,33.6;
            5124.8,0.2494,32,33,33.4,33.7; 5129.6,0.2494,32,33,33.4,33.6;
            5134.5,0.2494,32,33,33.4,33.6; 5139.8,0.2494,32,33,33.4,33.7;
            5144.8,0.2494,32,33,33.4,33.7; 5149.8,0.2494,32,33,33.4,33.7;
            5154.8,0.2494,32,33,33.4,33.7; 5159.6,0.2494,32,33,33.4,33.7;
            5164.7,0.2494,32,33,33.4,33.7; 5169.8,0.2494,32,33.1,33.4,33.7;
            5174.9,0.2494,32,33.1,33.4,33.7; 5179.9,0.2494,32,33.1,33.4,33.7;
            5184.8,0.2494,32.1,33.1,33.4,33.7; 5189.9,0.2494,32.1,33.1,33.4,
            33.7; 5195.3,0.2494,32.1,33.1,33.4,33.7; 5200.7,0.2494,32.1,33.1,
            33.4,33.7; 5205.9,0.2494,32.1,33.1,33.4,33.7; 5211.1,0.2494,32.1,
            33.1,33.4,33.7; 5216.5,0.2494,32.1,33.1,33.5,33.7; 5221.4,0.2494,
            32.1,33.1,33.4,33.7; 5226.6,0.2494,32.1,33.1,33.5,33.7; 5231.7,
            0.2494,32.1,33.1,33.5,33.7; 5236.8,0.2494,32.1,33.1,33.5,33.7;
            5241.9,0.2494,32.1,33.1,33.5,33.7; 5247.2,0.2494,32.1,33.1,33.4,
            33.7; 5252.2,0.2494,32.1,33.1,33.5,33.8; 5257.7,0.2494,32.1,33.2,
            33.5,33.7; 5263,0.2494,32.1,33.2,33.5,33.8; 5268.7,0.2494,32.1,33.2,
            33.5,33.7; 5274.1,0.2494,32.1,33.2,33.5,33.8; 5279.4,0.2494,32.1,
            33.2,33.5,33.8; 5284.5,0.2494,32.2,33.2,33.5,33.8; 5289.5,0.2494,
            32.2,33.2,33.5,33.8; 5294.4,0.2494,32.2,33.2,33.5,33.8; 5299.5,
            0.2494,32.2,33.2,33.5,33.8; 5304.4,0.2494,32.2,33.2,33.5,33.8;
            5309.2,0.2494,32.2,33.2,33.5,33.8; 5314.5,0.2494,32.2,33.2,33.5,
            33.8; 5319.4,0.2494,32.2,33.2,33.5,33.8; 5324.4,0.2494,32.2,33.2,
            33.5,33.8; 5329.4,0.2494,32.2,33.2,33.5,33.8; 5334.5,0.2494,32.2,
            33.2,33.5,33.8; 5339.7,0.2494,32.2,33.2,33.5,33.8; 5345.3,0.2494,
            32.2,33.3,33.5,33.8; 5350.4,0.2494,32.2,33.2,33.5,33.8; 5355.8,
            0.2494,32.2,33.2,33.6,33.9; 5361.2,0.2494,32.2,33.3,33.6,33.8;
            5366.1,0.2494,32.2,33.3,33.6,33.8; 5371.3,0.2494,32.2,33.3,33.6,
            33.8; 5376.7,0.2494,32.2,33.2,33.6,33.8; 5382.4,0.2494,32.2,33.3,
            33.6,33.8; 5387.4,0.2494,32.2,33.3,33.6,33.9; 5392.4,0.2494,32.2,
            33.3,33.6,33.9; 5397.9,0.2494,32.3,33.3,33.6,33.9; 5403.2,0.2494,
            32.3,33.3,33.6,33.8; 5408.3,0.2494,32.3,33.3,33.6,33.9; 5413.2,
            0.2494,32.3,33.3,33.6,33.9; 5418.2,0.2494,32.3,33.3,33.6,33.9;
            5423.3,0.2494,32.3,33.3,33.6,33.9; 5428.2,0.2494,32.3,33.3,33.6,
            33.9; 5433.4,0.2494,32.3,33.3,33.6,33.9; 5438.2,0.2494,32.3,33.3,
            33.6,33.9; 5443.7,0.2494,32.3,33.3,33.6,33.9; 5449.4,0.2494,32.3,
            33.3,33.6,33.9; 5454.5,0.2494,32.3,33.3,33.6,33.9; 5459.9,0.2494,
            32.3,33.3,33.6,33.9; 5465.2,0.2494,32.3,33.3,33.7,33.9; 5470.6,
            0.2494,32.3,33.4,33.7,33.9; 5476,0.2494,32.3,33.4,33.7,33.9; 5481.5,
            0.2494,32.3,33.4,33.7,33.9; 5486.5,0.2494,32.3,33.4,33.7,33.9;
            5491.9,0.2494,32.3,33.4,33.7,34; 5497.4,0.2494,32.3,33.4,33.7,34;
            5502.6,0.2494,32.3,33.4,33.7,33.9; 5507.8,0.2494,32.3,33.4,33.7,34;
            5513,0.2494,32.3,33.4,33.7,34; 5518.4,0.2494,32.4,33.4,33.7,34;
            5523.5,0.2494,32.4,33.4,33.7,34; 5528.7,0.2494,32.4,33.4,33.7,33.9;
            5534,0.2494,32.4,33.4,33.7,34; 5539.5,0.2494,32.4,33.4,33.7,34;
            5544.7,0.2494,32.4,33.4,33.7,34; 5549.9,0.2494,32.4,33.4,33.7,34;
            5555.3,0.2494,32.4,33.4,33.7,34; 5560.6,0.2494,32.4,33.4,33.7,34;
            5565.7,0.2494,32.4,33.4,33.7,34; 5570.9,0.2494,32.4,33.4,33.7,34;
            5576.4,0.2494,32.4,33.4,33.7,34; 5581.8,0.2494,32.4,33.4,33.7,34;
            5586.9,0.2494,32.4,33.5,33.8,34; 5592.9,0.2494,32.4,33.5,33.7,34;
            5598.6,0.2494,32.4,33.5,33.7,34; 5603.7,0.2494,32.4,33.5,33.8,34.1;
            5608.9,0.2494,32.4,33.5,33.7,34; 5614.6,0.2494,32.4,33.5,33.8,34;
            5619.7,0.2494,32.4,33.5,33.8,34.1; 5625.2,0.2494,32.4,33.5,33.8,
            34.1; 5630.6,0.2494,32.4,33.5,33.8,34.1; 5635.8,0.2494,32.5,33.5,
            33.8,34; 5641,0.2494,32.5,33.5,33.8,34.1; 5646.1,0.2494,32.5,33.5,
            33.8,34.1; 5651.6,0.2494,32.5,33.5,33.8,34.1; 5656.8,0.2494,32.5,
            33.5,33.8,34.1; 5661.8,0.2494,32.5,33.5,33.8,34.1; 5666.9,0.2494,
            32.5,33.5,33.8,34.1; 5672.4,0.2494,32.5,33.5,33.8,34.1; 5678,0.2494,
            32.5,33.5,33.8,34.1; 5683.5,0.2494,32.5,33.5,33.8,34.1; 5689.1,
            0.2494,32.5,33.5,33.8,34.1; 5694.3,0.2494,32.5,33.6,33.8,34.1;
            5700.2,0.2494,32.5,33.6,33.8,34.1; 5705.5,0.2494,32.5,33.6,33.8,
            34.1; 5711,0.2494,32.5,33.6,33.8,34.1; 5716.2,0.2494,32.5,33.6,33.8,
            34.1; 5721.2,0.2494,32.5,33.6,33.8,34.1; 5726.5,0.2494,32.5,33.6,
            33.8,34.1; 5732.1,0.2494,32.5,33.6,33.8,34.1; 5736.9,0.2494,32.5,
            33.6,33.9,34.1; 5742.1,0.2494,32.5,33.6,33.9,34.1; 5747,0.2494,32.5,
            33.6,33.8,34.1; 5752.2,0.2494,32.5,33.6,33.9,34.1; 5757.6,0.2494,
            32.5,33.6,33.9,34.1; 5763.2,0.2494,32.6,33.6,33.9,34.2; 5768.5,
            0.2494,32.5,33.6,33.9,34.2; 5774,0.2494,32.6,33.6,33.9,34.2; 5779.5,
            0.2494,32.6,33.6,33.9,34.2; 5785.3,0.2494,32.6,33.6,33.9,34.2;
            5790.8,0.2494,32.6,33.6,33.9,34.2; 5796.1,0.2494,32.6,33.6,33.9,
            34.2; 5801.5,0.2494,32.6,33.6,33.9,34.2; 5806.9,0.2494,32.6,33.6,
            33.9,34.2; 5812.3,0.2494,32.6,33.6,33.9,34.2; 5817.6,0.2494,32.6,
            33.6,33.9,34.2; 5823.3,0.2494,32.6,33.7,33.9,34.2; 5828.6,0.2494,
            32.6,33.7,33.9,34.2; 5834.2,0.2494,32.6,33.7,33.9,34.2; 5839.5,
            0.2494,32.6,33.7,33.9,34.2; 5845.1,0.2494,32.6,33.7,33.9,34.2;
            5850.5,0.2494,32.6,33.7,33.9,34.2; 5856.2,0.2494,32.6,33.7,33.9,
            34.2; 5861.4,0.2494,32.6,33.7,33.9,34.2; 5866.6,0.2494,32.6,33.7,
            33.9,34.2; 5872.1,0.2494,32.6,33.7,34,34.2; 5877.4,0.2494,32.6,33.7,
            34,34.2; 5882.7,0.2494,32.6,33.7,34,34.2; 5888.3,0.2494,32.6,33.7,
            34,34.2; 5893.6,0.2494,32.6,33.7,34,34.3; 5899.2,0.2494,32.7,33.7,
            34,34.2; 5904.4,0.2494,32.6,33.7,34,34.3; 5910.5,0.2494,32.7,33.7,
            34,34.2; 5916.3,0.2494,32.7,33.7,34,34.3; 5921.9,0.2494,32.7,33.7,
            34,34.3; 5927.5,0.2494,32.7,33.7,34,34.3; 5933.4,0.2494,32.7,33.7,
            34,34.3; 5938.8,0.2494,32.7,33.7,34,34.3; 5944.6,0.2494,32.7,33.7,
            34,34.3; 5950.5,0.2494,32.7,33.8,34,34.3; 5956,0.2494,32.7,33.8,34,
            34.3; 5961.6,0.2494,32.7,33.8,34,34.3; 5966.9,0.2494,32.7,33.8,34,
            34.3; 5972.1,0.2494,32.7,33.8,34,34.3; 5977.9,0.2494,32.7,33.8,34,
            34.3; 5983.2,0.2494,32.7,33.8,34,34.3; 5989.3,0.2494,32.7,33.8,34,
            34.3; 5995.2,0.2494,32.7,33.8,34,34.3; 6000.5,0.2494,32.7,33.8,34,
            34.3; 6006.4,0.2494,32.7,33.8,34,34.3; 6012.2,0.2494,32.7,33.8,34,
            34.3; 6017.8,0.2494,32.7,33.8,34.1,34.3; 6023.7,0.2494,32.7,33.8,
            34.1,34.3; 6029.4,0.2494,32.7,33.8,34.1,34.3; 6035.3,0.2494,32.7,
            33.8,34,34.3; 6041.1,0.2494,32.8,33.8,34.1,34.3; 6046.6,0.2494,32.8,
            33.8,34.1,34.3; 6054.4,0.2494,32.8,33.8,34.1,34.3; 6060,0.2494,32.8,
            33.8,34.1,34.3; 6065.5,0.2494,32.8,33.8,34.1,34.3; 6071.5,0.2494,
            32.8,33.8,34.1,34.4; 6077.2,0.2494,32.8,33.9,34.1,34.4; 6083.7,
            0.2494,32.8,33.9,34.1,34.4; 6089.4,0.2494,32.8,33.9,34.1,34.4;
            6095.5,0.2494,32.8,33.9,34.1,34.4; 6101.2,0.2494,32.8,33.9,34.1,
            34.4; 6107.5,0.2494,32.8,33.9,34.1,34.4; 6113.2,0.2494,32.8,33.9,
            34.1,34.4; 6119.1,0.2494,32.8,33.9,34.1,34.4; 6125.4,0.2494,32.8,
            33.9,34.1,34.4; 6131,0.2494,32.8,33.9,34.1,34.4; 6136.1,0.2494,32.8,
            33.9,34.1,34.4; 6142.6,0.2494,32.8,33.9,34.1,34.4; 6148.3,0.2494,
            32.8,33.9,34.1,34.4; 6154.2,0.2494,32.8,33.9,34.1,34.4; 6160.2,
            0.2494,32.8,33.9,34.1,34.4; 6166,0.2494,32.8,33.9,34.1,34.4; 6171.7,
            0.2494,32.8,33.9,34.1,34.4; 6177.5,0.2494,32.8,33.9,34.1,34.4;
            6183.3,0.2494,32.9,33.9,34.2,34.4; 6189.4,0.2494,32.8,33.9,34.1,
            34.4; 6195.4,0.2494,32.9,33.9,34.1,34.4; 6200.9,0.2494,32.9,34,34.2,
            34.4; 6206.4,0.2494,32.9,34,34.2,34.4; 6212.3,0.2494,32.9,33.9,34.2,
            34.4; 6218.5,0.2494,32.9,34,34.2,34.4; 6224,0.2494,32.9,34,34.2,
            34.5; 6230.1,0.2494,32.9,34,34.2,34.5; 6235.9,0.2494,32.9,34,34.2,
            34.5; 6242.7,0.2494,32.9,34,34.2,34.5; 6248.1,0.2494,32.9,34,34.2,
            34.5; 6254.2,0.2494,32.9,34,34.2,34.5; 6260.2,0.2494,32.9,34,34.2,
            34.5; 6266.4,0.2494,32.9,34,34.2,34.5; 6274.3,0.2494,32.9,34,34.2,
            34.5; 6280,0.2494,32.9,34,34.2,34.5; 6285.4,0.2494,32.9,34,34.2,
            34.5; 6291.4,0.2494,32.9,34,34.2,34.5; 6297.5,0.2494,32.9,34,34.2,
            34.5; 6303.5,0.2494,32.9,34,34.2,34.5; 6309.5,0.2494,32.9,34,34.2,
            34.5; 6315.6,0.2494,32.9,34,34.2,34.5; 6321.6,0.2494,33,34,34.2,
            34.5; 6327.7,0.2494,33,34,34.2,34.5; 6333.6,0.2494,33,34,34.2,34.5;
            6339.8,0.2494,33,34,34.2,34.5; 6345.8,0.2494,33,34,34.2,34.5;
            6351.5,0.2494,33,34,34.2,34.5; 6357.3,0.2494,33,34,34.2,34.5; 6363,
            0.2494,33,34.1,34.2,34.5; 6368.8,0.2494,33,34.1,34.2,34.5; 6374.5,
            0.2494,33,34.1,34.2,34.5; 6380.8,0.2494,33,34.1,34.2,34.5; 6386.6,
            0.2494,33,34.1,34.2,34.5; 6392.7,0.2494,33,34.1,34.2,34.5; 6398.6,
            0.2494,33,34.1,34.2,34.5; 6404.7,0.2494,33,34.1,34.2,34.5; 6410.6,
            0.2494,33,34.1,34.3,34.5; 6416.7,0.2494,33,34.1,34.2,34.5; 6422.6,
            0.2494,33,34.1,34.3,34.6; 6428.7,0.2494,33,34.1,34.3,34.6; 6434.6,
            0.2494,33,34.1,34.3,34.5; 6440.8,0.2494,33,34.1,34.3,34.5; 6447.3,
            0.2494,33,34.1,34.3,34.6; 6453,0.2494,33,34.1,34.3,34.6; 6458.9,
            0.2494,33.1,34.1,34.3,34.6; 6464.8,0.2494,33,34.1,34.3,34.6; 6470.8,
            0.2494,33,34.1,34.3,34.6; 6477,0.2494,33.1,34.1,34.3,34.5; 6483.3,
            0.2494,33.1,34.1,34.3,34.5; 6488.7,0.2494,33.1,34.1,34.3,34.6;
            6494.5,0.2494,33,34.1,34.3,34.6; 6500.1,0.2494,33.1,34.1,34.3,34.6;
            6506.4,0.2494,33.1,34.1,34.3,34.6; 6512.2,0.2494,33.1,34.2,34.3,
            34.6; 6518.2,0.2494,33.1,34.1,34.3,34.6; 6524.2,0.2494,33.1,34.1,
            34.3,34.6; 6530.4,0.2494,33.1,34.2,34.3,34.6; 6536.2,0.2494,33.1,
            34.2,34.3,34.6; 6542.3,0.2494,33.1,34.2,34.3,34.6; 6548.2,0.2494,
            33.1,34.2,34.3,34.6; 6554.4,0.2494,33.1,34.2,34.3,34.6; 6560.4,
            0.2494,33.1,34.2,34.3,34.6; 6566.1,0.2494,33.1,34.2,34.3,34.6;
            6572.2,0.2494,33.1,34.2,34.3,34.6; 6578.3,0.2494,33.1,34.2,34.3,
            34.6; 6584.1,0.2494,33.1,34.2,34.3,34.6; 6590.2,0.2494,33.1,34.2,
            34.3,34.6; 6596.2,0.2494,33.1,34.2,34.3,34.6; 6602.2,0.2494,33.1,
            34.2,34.3,34.6; 6608.3,0.2494,33.1,34.2,34.3,34.6; 6614.3,0.2494,
            33.1,34.2,34.3,34.6; 6620.4,0.2494,33.1,34.2,34.3,34.6; 6626.4,
            0.2494,33.1,34.2,34.4,34.7; 6632.4,0.2494,33.1,34.2,34.4,34.7;
            6638.6,0.2494,33.1,34.2,34.4,34.7; 6644.9,0.2494,33.1,34.2,34.4,
            34.6; 6651.4,0.2494,33.1,34.2,34.4,34.7; 6657.1,0.2494,33.1,34.2,
            34.4,34.7; 6663.3,0.2494,33.1,34.2,34.4,34.7; 6669.3,0.2494,33.2,
            34.2,34.4,34.6; 6675.6,0.2494,33.1,34.2,34.4,34.6; 6681.6,0.2494,
            33.1,34.2,34.4,34.6; 6687.6,0.2494,33.1,34.2,34.4,34.7; 6693.3,
            0.2494,33.1,34.2,34.4,34.7; 6699.6,0.2494,33.1,34.3,34.4,34.7;
            6705.4,0.2494,33.1,34.2,34.4,34.7; 6711.3,0.2494,33.2,34.3,34.4,
            34.7; 6717.7,0.2494,33.2,34.3,34.4,34.7; 6725.5,0.2494,33.2,34.3,
            34.4,34.7; 6731.1,0.2494,33.2,34.3,34.4,34.7; 6737.5,0.2494,33.2,
            34.3,34.4,34.7; 6743.1,0.2494,33.2,34.3,34.4,34.7; 6749.6,0.2494,
            33.2,34.3,34.4,34.7; 6755.5,0.2494,33.2,34.3,34.4,34.7; 6761.4,
            0.2494,33.2,34.3,34.4,34.6; 6767.5,0.2494,33.2,34.3,34.4,34.6;
            6773.9,0.2494,33.2,34.3,34.4,34.6; 6780.1,0.2494,33.2,34.3,34.4,
            34.6; 6786.3,0.2494,33.2,34.3,34.3,34.5; 6792.3,0.2494,33.2,34.3,
            34.3,34.6; 6798.8,0.2494,33.2,34.3,34.3,34.5; 6804.6,0.2494,33.2,
            34.3,34.3,34.5; 6810.8,0.2494,33.2,34.3,34.3,34.5; 6816.7,0.2494,
            33.2,34.3,34.3,34.4; 6822.7,0.2494,33.2,34.3,34.2,34.4; 6828.5,
            0.2494,33.2,34.3,34.2,34.4; 6834.8,0.2494,33.2,34.3,34.2,34.4;
            6840.8,0.2494,33.2,34.3,34.2,34.3; 6846.5,0.2494,33.2,34.3,34.2,
            34.3; 6852.8,0.2494,33.2,34.3,34.1,34.3; 6858.6,0.2494,33.2,34.3,
            34.1,34.2; 6864.4,0.2494,33.2,34.3,34.1,34.2; 6870.8,0.2494,33.2,
            34.3,34,34.2; 6876.6,0.2494,33.2,34.3,34,34.1; 6882.9,0.2494,33.2,
            34.3,34,34.1; 6888.7,0.2494,33.2,34.3,34,34.1; 6894.7,0.2494,33.2,
            34.3,34,34; 6901.1,0.2494,33.2,34.3,33.9,34; 6908,0.2494,33.2,34.3,
            33.9,34; 6913.7,0.2494,33.2,34.3,33.8,33.9; 6919.9,0.2494,33.2,34.3,
            33.8,33.9; 6926.3,0.2494,33.2,34.3,33.8,33.9; 6932.6,0.2494,33.3,
            34.3,33.7,33.8; 6938.6,0.2494,33.3,34.3,33.7,33.8; 6944.5,0.2494,
            33.3,34.4,33.7,33.8; 6950.8,0.2494,33.3,34.3,33.6,33.7; 6957.1,
            0.2494,33.3,34.4,33.6,33.7; 6963.9,0.2494,33.3,34.4,33.6,33.6;
            6970.7,0.2494,33.3,34.4,33.5,33.6; 6976.7,0.2494,33.3,34.4,33.5,
            33.6; 6982.4,0.2494,33.3,34.4,33.5,33.5; 6988.8,0.2494,33.3,34.4,
            33.4,33.5; 6995.7,0.2494,33.3,34.4,33.4,33.4; 7002.2,0.2494,33.3,
            34.4,33.3,33.4; 7008.3,0.2494,33.3,34.4,33.3,33.4; 7014.2,0.2494,
            33.3,34.4,33.3,33.3; 7020.4,0.2494,33.3,34.4,33.2,33.3; 7026.7,
            0.2494,33.3,34.4,33.2,33.3; 7033.4,0.2494,33.3,34.4,33.2,33.2;
            7039.3,0.2494,33.3,34.4,33.1,33.2; 7044.9,0.2494,33.3,34.4,33.1,
            33.1; 7051.1,0.2494,33.3,34.4,33.1,33.1; 7057.3,0.2494,33.3,34.4,33,
            33.1; 7063.2,0.2494,33.3,34.4,33,33; 7069.3,0.2494,33.3,34.4,33,33;
            7077.1,0.2494,33.3,34.4,32.9,33; 7083.2,0.2494,33.3,34.4,32.9,32.9;
            7089.4,0.2494,33.3,34.4,32.9,32.9; 7096.2,0.2494,33.3,34.4,32.8,
            32.9; 7102.5,0.2494,33.3,34.4,32.8,32.8; 7109.2,0.2494,33.3,34.4,
            32.7,32.8; 7115.1,0.2494,33.3,34.4,32.7,32.7; 7121.4,0.2494,33.3,
            34.4,32.7,32.7; 7128.1,0.2494,33.3,34.4,32.6,32.7; 7134.6,0.2494,
            33.3,34.4,32.6,32.6; 7141.5,0.2494,33.3,34.4,32.6,32.6; 7148.1,
            0.2494,33.3,34.4,32.5,32.5; 7154.4,0.2494,33.3,34.4,32.5,32.5; 7161,
            0.2494,33.3,34.4,32.4,32.5; 7167.3,0.2494,33.3,34.4,32.4,32.4;
            7174.2,0.2494,33.3,34.4,32.4,32.4; 7180.9,0.2494,33.3,34.3,32.3,
            32.4; 7187.1,0.2494,33.3,34.3,32.3,32.3; 7193.3,0.2494,33.3,34.3,
            32.2,32.3; 7200,0.2494,33.3,34.3,32.2,32.2; 7206.4,0.2494,33.3,34.3,
            32.2,32.2; 7213,0.2494,33.2,34.3,32.1,32.2; 7219.9,0.2494,33.2,34.3,
            32.1,32.1; 7226.1,0.2494,33.2,34.2,32.1,32.1; 7232.8,0.2494,33.2,
            34.2,32,32; 7239.3,0.2494,33.2,34.2,32,31.9; 7245.8,0.2494,33.1,
            34.2,31.9,31.3; 7252.3,0.2494,33.1,34.2,31.7,31.6; 7258.6,0.2494,
            33.1,34.1,31.7,31.7; 7264.5,0.2494,33.1,34.1,31.7,31.8; 7271.1,
            0.2494,33.1,34.1,31.7,31.8; 7277.9,0.2494,33.1,34,31.6,31.7; 7284.5,
            0.2494,33,34,31.6,31.7; 7290.6,0.2494,33,34,31.6,31.7; 7296.7,
            0.2494,33,34,31.6,31.7; 7303.1,0.2494,33,33.9,31.6,31.6; 7310.1,
            0.2494,32.9,33.9,31.5,31.6; 7316.6,0.2494,32.9,33.9,31.5,31.5;
            7323.2,0.2494,32.9,33.8,31.5,31.5; 7329.7,0.2494,32.9,33.8,31.4,
            31.5; 7336,0.2494,32.8,33.8,31.4,31.4; 7342.9,0.2494,32.8,33.7,31.4,
            31.4; 7350,0.2494,32.8,33.7,31.3,31.4; 7357.1,0.2494,32.7,33.7,31.3,
            31.3; 7363.8,0.2494,32.7,33.6,31.3,31.3; 7370,0.2494,32.7,33.6,31.2,
            31.3; 7377.3,0.2494,32.6,33.6,31.2,31.2; 7383.7,0.2494,32.6,33.5,
            31.2,31.2; 7390.5,0.2494,32.6,33.5,31.1,31.2; 7396.6,0.2494,32.5,
            33.4,31.1,31.1; 7403.2,0.2494,32.5,33.4,31.1,31.1; 7409.8,0.2494,
            32.5,33.4,31,31.1; 7416.7,0.2494,32.5,33.3,31,31; 7424,0.2494,32.4,
            33.3,31,31; 7430.6,0.2494,32.4,33.3,30.9,31; 7437.5,0.2494,32.3,
            33.2,30.9,30.9; 7444.5,0.2494,32.3,33.2,30.9,30.9; 7450.9,0.2494,
            32.3,33.2,30.8,30.8; 7457.7,0.2494,32.2,33.1,30.8,30.8; 7464.5,
            0.2494,32.2,33.1,30.8,30.8; 7471.5,0.2494,32.2,33,30.7,30.7; 7478.6,
            0.2494,32.1,33,30.7,30.7; 7485.6,0.2494,32.1,33,30.6,30.7; 7492.7,
            0.2494,32,32.9,30.6,30.6; 7499.8,0.2494,32,32.9,30.6,30.6; 7506.3,
            0.2494,32,32.8,30.5,30.6; 7513.5,0.2494,32,32.8,30.5,30.5; 7520.3,
            0.2494,31.9,32.7,30.5,30.5; 7526.6,0.2494,31.9,32.7,30.4,30.4;
            7533.8,0.2494,31.8,32.7,30.4,30.4; 7540.6,0.2494,31.8,32.6,30.4,
            30.4; 7547.7,0.2494,31.8,32.6,30.3,30.3; 7554.2,0.2494,31.7,32.6,
            30.3,30.3; 7560.8,0.2494,31.7,32.5,30.3,30.3; 7567.5,0.2494,31.7,
            32.5,30.2,30.2; 7574.3,0.2494,31.6,32.4,30.2,30.2; 7581.6,0.2494,
            31.6,32.4,30.2,30.2; 7588,0.2494,31.5,32.3,30.1,30.1; 7594.5,0.2494,
            31.5,32.3,30.1,30.1; 7601.5,0.2494,31.5,32.2,30,30.1; 7608.1,0.2494,
            31.4,32.2,30,30; 7614.7,0.2494,31.4,32.2,30,30; 7621.1,0.2494,31.3,
            32.1,30,30; 7627.4,0.2494,31.3,32.1,29.9,29.9; 7634.4,0.2494,31.3,
            32,29.9,29.9; 7641.1,0.2494,31.2,32,29.9,29.9; 7648.1,0.2494,31.2,
            31.9,29.8,29.8; 7655.1,0.2494,31.2,31.9,29.8,29.8; 7661.9,0.2494,
            31.1,31.9,29.8,29.8; 7669,0.2494,31.1,31.8,29.7,29.7; 7676.2,0.2494,
            31.1,31.8,29.7,29.7; 7683.2,0.2494,31,31.8,29.6,29.6; 7690,0.2494,
            31,31.7,29.6,29.6; 7697,0.2494,30.9,31.7,29.6,29.6; 7703.7,0.2494,
            30.9,31.6,29.6,29.6; 7710.5,0.2494,30.8,31.6,29.5,29.5; 7717.3,
            0.2494,30.8,31.6,29.5,29.5; 7723.7,0.2494,30.8,31.5,29.4,29.4;
            7731.2,0.2494,30.7,31.5,29.4,29.4; 7738,0.2494,30.7,31.5,29.4,29.4;
            7745.2,0.2494,30.7,31.4,29.3,29.3; 7752,0.2494,30.6,31.4,29.3,29.3;
            7758.5,0.2494,30.6,31.4,29.3,29.3; 7766.4,0.2494,30.6,31.3,29.3,
            29.2; 7772.7,0.2494,30.5,31.3,29.2,29.2; 7779.6,0.2494,30.5,31.2,
            29.2,29.2; 7787.7,0.2494,30.5,31.2,29.1,29.1; 7794.6,0.2494,30.4,
            31.2,29.1,29.1; 7801.8,0.2494,30.4,31.1,29.1,29.1; 7808.5,0.2494,
            30.4,31.1,29,29; 7815.7,0.2494,30.3,31.1,29,29; 7823.2,0.2494,30.3,
            31,29,29; 7830.4,0.2494,30.3,31,28.9,28.9; 7837.9,0.2494,30.2,30.9,
            28.9,28.9; 7845.1,0.2494,30.2,30.9,28.9,28.9; 7851.7,0.2494,30.2,
            30.9,28.8,28.8; 7858.6,0.2494,30.1,30.8,28.8,28.8; 7865.9,0.2494,
            30.1,30.8,28.8,28.8; 7873,0.2494,30.1,30.8,28.7,28.7; 7880.1,0.2494,
            30,30.7,28.7,28.7; 7888,0.2494,30,30.7,28.7,28.7; 7894.9,0.2494,
            29.9,30.6,28.6,28.6; 7901.7,0.2494,29.9,30.6,28.6,28.6; 7908.2,
            0.2494,29.9,30.6,28.6,28.6; 7916,0.2494,29.9,30.5,28.6,28.5; 7922.9,
            0.2494,29.8,30.5,28.5,28.5; 7929.5,0.2494,29.8,30.5,28.5,28.5; 7937,
            0.2494,29.8,30.4,28.4,28.4; 7943.8,0.2494,29.7,30.4,28.4,28.4;
            7950.4,0.2494,29.7,30.4,28.4,28.4; 7957,0.2494,29.6,30.3,28.4,28.3;
            7965.1,0.2494,29.6,30.3,28.3,28.3; 7972.1,0.2494,29.6,30.2,28.3,
            28.3; 7979.3,0.2494,29.6,30.2,28.3,28.2; 7987,0.2494,29.5,30.2,28.2,
            28.2; 7994.3,0.2494,29.5,30.1,28.2,28.2; 8001.3,0.2494,29.4,30.1,
            28.1,28.1; 8008.2,0.2494,29.4,30.1,28.1,28.1; 8015.1,0.2494,29.4,30,
            28.1,28.1; 8022.2,0.2494,29.3,30,28.1,28.1; 8028.8,0.2494,29.3,29.9,
            28,28; 8035.3,0.2494,29.3,29.9,28,28; 8041.9,0.2494,29.2,29.9,28,
            27.9; 8049.3,0.2494,29.2,29.9,28,27.9; 8056.6,0.2494,29.2,29.8,27.9,
            27.9; 8063.1,0.2494,29.2,29.8,27.9,27.9; 8070.1,0.2494,29.1,29.7,
            27.9,27.8; 8076.5,0.2494,29.1,29.7,27.8,27.8; 8082.9,0.2494,29.1,
            29.7,27.8,27.8; 8089.6,0.2494,29,29.7,27.8,27.8; 8096.7,0.2494,29,
            29.6,27.8,27.7; 8103.3,0.2494,29,29.6,27.7,27.7; 8110.5,0.2494,28.9,
            29.6,27.7,27.6; 8116.8,0.2494,28.9,29.5,27.7,27.6; 8123.3,0.2494,
            28.9,29.5,27.6,27.6; 8131.3,0.2494,28.8,29.5,27.6,27.6; 8137.7,
            0.2494,28.8,29.4,27.6,27.5; 8144.6,0.2494,28.8,29.4,27.5,27.5;
            8151.6,0.2494,28.8,29.4,27.5,27.5; 8158.3,0.2494,28.7,29.3,27.5,
            27.5; 8165.4,0.2494,28.7,29.3,27.5,27.4; 8172.6,0.2494,28.7,29.3,
            27.4,27.4; 8179,0.2494,28.7,29.2,27.4,27.4; 8185.6,0.2494,28.6,29.2,
            27.4,27.4; 8192.9,0.2494,28.6,29.2,27.4,27.3; 8200.7,0.2494,28.6,
            29.1,27.3,27.3; 8207,0.2494,28.5,29.1,27.3,27.3; 8214.3,0.2494,28.5,
            29.1,27.3,27.2; 8221.4,0.2494,28.5,29,27.2,27.2; 8228.8,0.2494,28.4,
            29,27.2,27.2; 8235.8,0.2494,28.4,29,27.2,27.2; 8242.6,0.2494,28.4,
            29,27.2,27.1; 8249.8,0.2494,28.3,28.9,27.1,27.1; 8256.9,0.2494,28.3,
            28.9,27.1,27.1; 8263.6,0.2494,28.3,28.9,27.1,27; 8270.9,0.2494,28.3,
            28.8,27,27; 8277.8,0.2494,28.3,28.8,27,27; 8284.2,0.2494,28.2,28.8,
            27,27; 8290.5,0.2494,28.2,28.7,27,26.9; 8298.1,0.2494,28.2,28.7,
            26.9,26.9; 8305.1,0.2494,28.1,28.7,26.9,26.9; 8312,0.2494,28.1,28.6,
            26.9,26.8; 8318.5,0.2494,28.1,28.6,26.9,26.8; 8325.3,0.2494,28,28.6,
            26.8,26.8; 8332.5,0.2494,28,28.6,26.8,26.8; 8340,0.2494,28,28.5,
            26.8,26.8; 8347.3,0.2494,27.9,28.5,26.8,26.7; 8354.7,0.2494,27.9,
            28.5,26.7,26.7; 8362.2,0.2494,27.9,28.4,26.7,26.7; 8369.5,0.2494,
            27.8,28.4,26.7,26.6; 8376.8,0.2494,27.8,28.4,26.6,26.6; 8383.9,
            0.2494,27.8,28.3,26.6,26.6; 8390.9,0.2494,27.8,28.3,26.6,26.5;
            8397.7,0.2494,27.8,28.3,26.6,26.5; 8404.1,0.2494,27.7,28.3,26.5,
            26.5; 8410.9,0.2494,27.7,28.2,26.5,26.5; 8417.9,0.2494,27.7,28.2,
            26.5,26.5; 8425.3,0.2494,27.6,28.2,26.5,26.4; 8432.8,0.2494,27.6,
            28.1,26.4,26.4; 8440.1,0.2494,27.6,28.1,26.4,26.4; 8447.4,0.2494,
            27.5,28.1,26.4,26.3; 8454.8,0.2494,27.5,28,26.4,26.3; 8462.5,0.2494,
            27.5,28,26.3,26.3; 8469.1,0.2494,27.5,28,26.3,26.3; 8476,0.2494,
            27.4,27.9,26.3,26.2; 8482.3,0.2494,27.4,27.9,26.3,26.2; 8489.6,
            0.2494,27.4,27.9,26.2,26.2; 8496.9,0.2494,27.3,27.8,26.2,26.2; 8504,
            0.2494,27.3,27.8,26.2,26.1; 8511.5,0.2494,27.3,27.8,26.2,26.1;
            8518.8,0.2494,27.3,27.8,26.1,26.1; 8526.2,0.2494,27.2,27.7,26.1,
            26.1; 8533.6,0.2494,27.2,27.7,26.1,26.1; 8541.1,0.2494,27.2,27.7,
            26.1,26; 8548.6,0.2494,27.1,27.6,26,26; 8555.2,0.2494,27.1,27.6,26,
            25.9; 8561.9,0.2494,27.1,27.6,26,25.9; 8569.5,0.2494,27.1,27.5,25.9,
            25.9; 8576.4,0.2494,27,27.5,25.9,25.9; 8584.2,0.2494,27,27.5,25.9,
            25.9; 8591.1,0.2494,27,27.5,25.9,25.8; 8598.9,0.2494,27,27.4,25.8,
            25.8; 8605.9,0.2494,26.9,27.4,25.8,25.8; 8613.6,0.2494,26.9,27.4,
            25.8,25.8; 8620.7,0.2494,26.8,27.3,25.8,25.7; 8628.3,0.2494,26.8,
            27.3,25.7,25.7; 8635.8,0.2494,26.8,27.3,25.7,25.7; 8643.9,0.2494,
            26.8,27.3,25.7,25.7; 8651.4,0.2494,26.7,27.2,25.7,25.6; 8658,0.2494,
            26.7,27.2,25.6,25.6; 8665.8,0.2494,26.7,27.2,25.6,25.6; 8672.7,
            0.2494,26.7,27.1,25.6,25.5; 8680.6,0.2494,26.7,27.1,25.6,25.5;
            8687.8,0.2494,26.6,27.1,25.5,25.5; 8694.6,0.2494,26.6,27,25.5,25.5;
            8701.5,0.2494,26.6,27,25.5,25.4; 8708.6,0.2494,26.6,27,25.5,25.4;
            8716.2,0.2494,26.5,27,25.4,25.4; 8723.3,0.2494,26.5,26.9,25.4,25.4;
            8730.2,0.2494,26.5,26.9,25.4,25.4; 8737.3,0.2494,26.4,26.9,25.4,
            25.3; 8744.3,0.2494,26.4,26.9,25.3,25.3; 8751.1,0.2494,26.4,26.8,
            25.3,25.3; 8758.3,0.2494,26.4,26.8,25.3,25.2; 8765.5,0.2494,26.3,
            26.8,25.3,25.2; 8773.6,0.2494,26.3,26.7,25.2,25.2; 8780.7,0.2494,
            26.3,26.7,25.2,25.2; 8788.5,0.2494,26.3,26.7,25.2,25.1; 8795.6,
            0.2494,26.2,26.7,25.2,25.1; 8802.6,0.2494,26.2,26.6,25.1,25.1;
            8809.8,0.2494,26.2,26.6,25.1,25.1; 8817.5,0.2494,26.2,26.6,25.1,
            25.1; 8824.9,0.2494,26.1,26.6,25.1,25; 8832.1,0.2494,26.1,26.5,25.1,
            25; 8839.3,0.2494,26.1,26.5,25,25; 8846.5,0.2494,26.1,26.5,25,25;
            8854.9,0.2494,26,26.4,25,24.9; 8862.4,0.2494,26,26.4,24.9,24.9;
            8870.1,0.2494,26,26.4,24.9,24.9; 8877,0.2494,25.9,26.4,24.9,24.9;
            8884.9,0.2494,25.9,26.3,24.9,24.8; 8892.9,0.2494,25.9,26.3,24.9,
            24.8; 8901.2,0.2494,25.9,26.3,24.8,24.8; 8909.2,0.2494,25.8,26.2,
            24.8,24.7; 8917.2,0.2494,25.8,26.2,24.8,24.7; 8925,0.2494,25.8,26.2,
            24.7,24.7; 8932.4,0.2494,25.7,26.1,24.7,24.6; 8940.2,0.2494,25.7,
            26.1,24.7,24.6; 8947.2,0.2494,25.7,26.1,24.7,24.6; 8954.4,0.2494,
            25.7,26.1,24.6,24.6; 8961.7,0.2494,25.7,26,24.6,24.6; 8969.7,0.2494,
            25.6,26,24.6,24.5; 8977.5,0.2494,25.6,26,24.6,24.5; 8984.8,0.2494,
            25.6,26,24.6,24.5; 8992.5,0.2494,25.5,25.9,24.5,24.5; 8999.7,0.2494,
            25.5,25.9,24.5,24.5; 9006.9,0.2494,25.5,25.9,24.5,24.4; 9014.1,
            0.2494,25.5,25.8,24.5,24.4; 9021.1,0.2494,25.5,25.8,24.4,24.4;
            9028.5,0.2494,25.4,25.8,24.4,24.3; 9036.1,0.2494,25.4,25.8,24.4,
            24.3; 9043,0.2494,25.4,25.7,24.4,24.3; 9050.1,0.2494,25.3,25.7,24.3,
            24.3; 9057.1,0.2494,25.3,25.7,24.3,24.3; 9064.3,0.2494,25.3,25.7,
            24.3,24.2; 9071.6,0.2494,25.3,25.6,24.3,24.2; 9079,0.2494,25.2,25.6,
            24.2,24.2; 9087.1,0.2494,25.2,25.6,24.2,24.2; 9095.2,0.2494,25.2,
            25.6,24.2,24.1; 9103.1,0.2494,25.2,25.5,24.2,24.1; 9111,0.2494,25.2,
            25.5,24.1,24.1; 9118.2,0.2494,25.1,25.5,24.1,24.1; 9126.2,0.2494,
            25.1,25.5,24.1,24; 9133.1,0.2494,25.1,25.4,24.1,24; 9140.3,0.2494,
            25,25.4,24.1,24; 9148.8,0.2494,25,25.4,24,24; 9156.3,0.2494,25,25.3,
            24,23.9; 9163.4,0.2494,25,25.3,24,23.9; 9171,0.2494,24.9,25.3,23.9,
            23.9; 9178.4,0.2494,24.9,25.3,23.9,23.9; 9185.7,0.2494,24.9,25.2,
            23.9,23.8; 9193.1,0.2494,24.9,25.2,23.9,23.8; 9201.7,0.2494,24.9,
            25.2,23.9,23.8; 9208.6,0.2494,24.8,25.2,23.8,23.8; 9215.7,0.2494,
            24.8,25.1,23.8,23.8; 9223.9,0.2494,24.8,25.1,23.8,23.7; 9231.7,
            0.2494,24.8,25.1,23.8,23.7; 9240.2,0.2494,24.7,25.1,23.7,23.7;
            9247.6,0.2494,24.7,25,23.7,23.7; 9254.7,0.2494,24.7,25,23.7,23.6;
            9262,0.2494,24.7,25,23.7,23.6; 9270,0.2494,24.6,25,23.7,23.6;
            9278.2,0.2494,24.6,24.9,23.6,23.6; 9286.2,0.2494,24.6,24.9,23.6,
            23.5; 9294,0.2494,24.6,24.9,23.6,23.5; 9301.1,0.2494,24.5,24.9,23.6,
            23.5; 9307.9,0.2494,24.5,24.8,23.5,23.5; 9314.9,0.2494,24.5,24.8,
            23.5,23.4; 9322.4,0.2494,24.5,24.8,23.5,23.4; 9330.5,0.2494,24.4,
            24.8,23.5,23.4; 9338.4,0.2494,24.4,24.7,23.4,23.4; 9345.1,0.2494,
            24.4,24.7,23.4,23.4; 9352.3,0.2494,24.4,24.7,23.4,23.3; 9359.7,
            0.2494,24.4,24.7,23.4,23.3; 9367.8,0.2494,24.3,24.6,23.4,23.3;
            9375.9,0.2494,24.3,24.6,23.3,23.3; 9383.5,0.2494,24.3,24.6,23.3,
            23.2; 9390.2,0.2494,24.3,24.6,23.3,23.2; 9398.3,0.2494,24.2,24.5,
            23.3,23.2; 9406.3,0.2494,24.2,24.5,23.2,23.2; 9414.5,0.2494,24.2,
            24.5,23.2,23.1; 9422.6,0.2494,24.2,24.5,23.2,23.1; 9430.6,0.2494,
            24.1,24.4,23.2,23.1; 9438.9,0.2494,24.1,24.4,23.2,23.1; 9446.7,
            0.2494,24.1,24.4,23.1,23; 9454.8,0.2494,24.1,24.4,23.1,23; 9462.9,
            0.2494,24.1,24.3,23.1,23; 9471.1,0.2494,24,24.3,23.1,23; 9478.9,
            0.2494,24,24.3,23,22.9; 9487.2,0.2494,24,24.2,23,22.9; 9495.3,
            0.2494,24,24.2,23,22.9; 9503.1,0.2494,23.9,24.2,23,22.9; 9510.3,
            0.2494,23.9,24.2,22.9,22.9; 9518.1,0.2494,23.9,24.1,22.9,22.8;
            9525.4,0.2494,23.9,24.1,22.9,22.8; 9532.8,0.2494,23.9,24.1,22.9,
            22.8; 9540.8,0.2494,23.8,24.1,22.9,22.8; 9549,0.2494,23.8,24.1,22.8,
            22.7; 9557.1,0.2494,23.8,24,22.8,22.7; 9565.2,0.2494,23.7,24,22.8,
            22.7; 9572.9,0.2494,23.7,24,22.8,22.7; 9580.2,0.2494,23.7,24,22.7,
            22.6; 9587.2,0.2494,23.7,23.9,22.7,22.6; 9594.4,0.2494,23.7,23.9,
            22.7,22.6; 9601.7,0.2494,23.6,23.9,22.7,22.6; 9609.5,0.2494,23.6,
            23.9,22.7,22.6; 9616.9,0.2494,23.6,23.8,22.6,22.6; 9625.4,0.2494,
            23.6,23.8,22.6,22.5; 9632.6,0.2494,23.6,23.8,22.6,22.5; 9639.7,
            0.2494,23.5,23.8,22.6,22.5; 9647.2,0.2494,23.5,23.7,22.5,22.5;
            9655.2,0.2494,23.5,23.7,22.5,22.4; 9663.2,0.2494,23.5,23.7,22.5,
            22.4; 9671.4,0.2494,23.4,23.7,22.5,22.4; 9679.2,0.2494,23.4,23.7,
            22.5,22.4; 9686.5,0.2494,23.4,23.6,22.4,22.4; 9694.6,0.2494,23.4,
            23.6,22.4,22.3; 9702.6,0.2494,23.4,23.6,22.4,22.3; 9710.4,0.2494,
            23.3,23.6,22.4,22.3; 9717.5,0.2494,23.3,23.5,22.4,22.3; 9724.8,
            0.2494,23.3,23.5,22.3,22.3; 9733.2,0.2494,23.3,23.5,22.3,22.2;
            9740.7,0.2494,23.3,23.5,22.3,22.2; 9747.9,0.2494,23.2,23.4,22.3,
            22.2; 9755.3,0.2494,23.2,23.4,22.3,22.2; 9762.7,0.2494,23.2,23.4,
            22.2,22.2; 9770.8,0.2494,23.2,23.4,22.2,22.1; 9779.3,0.2494,23.1,
            23.3,22.2,22.1; 9786.7,0.2494,23.1,23.3,22.2,22.1; 9794.4,0.2494,
            23.1,23.3,22.2,22.1; 9802.6,0.2494,23.1,23.3,22.1,22; 9810.2,0.2494,
            23.1,23.3,22.1,22; 9818.7,0.2494,23,23.2,22.1,22; 9826.4,0.2494,23,
            23.2,22.1,22; 9833.8,0.2494,23,23.2,22.1,22; 9841,0.2494,23,23.2,22,
            22; 9848.3,0.2494,22.9,23.1,22,21.9; 9855.8,0.2494,22.9,23.1,22,
            21.9; 9864.1,0.2494,22.9,23.1,22,21.9; 9872.3,0.2494,22.9,23.1,22,
            21.9; 9880.5,0.2494,22.9,23,21.9,21.8; 9888.2,0.2494,22.8,23,21.9,
            21.8; 9896.3,0.2494,22.8,23,21.9,21.8; 9903.8,0.2494,22.8,23,21.9,
            21.8; 9911.2,0.2494,22.8,23,21.9,21.8; 9919.7,0.2494,22.8,22.9,21.8,
            21.7; 9927,0.2494,22.7,22.9,21.8,21.7; 9934.8,0.2494,22.7,22.9,21.8,
            21.7; 9942.5,0.2494,22.7,22.9,21.8,21.7; 9949.7,0.2494,22.7,22.9,
            21.8,21.7; 9956.9,0.2494,22.7,22.8,21.7,21.6; 9964.6,0.2494,22.6,
            22.8,21.7,21.6; 9971.8,0.2494,22.6,22.8,21.7,21.6; 9979,0.2494,22.6,
            22.8,21.7,21.6; 9986.4,0.2494,22.6,22.7,21.7,21.6; 9994.5,0.2494,
            22.6,22.7,21.6,21.5; 10002.6,0.2494,22.5,22.7,21.6,21.5; 10011.1,
            0.2494,22.5,22.7,21.6,21.5; 10018.7,0.2494,22.5,22.7,21.6,21.5;
            10027.2,0.2494,22.5,22.6,21.6,21.5; 10034.8,0.2494,22.4,22.6,21.5,
            21.5; 10043,0.2494,22.4,22.6,21.5,21.4; 10050.9,0.2494,22.4,22.6,
            21.5,21.4; 10059.2,0.2494,22.4,22.5,21.5,21.4; 10067.5,0.2494,22.4,
            22.5,21.5,21.4; 10075.4,0.2494,22.4,22.5,21.5,21.3; 10082.4,0.2494,
            22.3,22.5,21.4,21.3; 10091,0.2494,22.3,22.4,21.4,21.3; 10098.8,
            0.2494,22.3,22.4,21.4,21.3; 10106.2,0.2494,22.3,22.4,21.4,21.3;
            10113.5,0.2494,22.3,22.4,21.4,21.3; 10121.8,0.2494,22.2,22.4,21.3,
            21.2; 10128.8,0.2494,22.2,22.4,21.3,21.2; 10136.3,0.2494,22.2,22.3,
            21.3,21.2; 10145.1,0.2494,22.2,22.3,21.3,21.2; 10152.7,0.2494,22.1,
            22.3,21.2,21.2; 10161.2,0.2494,22.1,22.3,21.2,21.1; 10169,0.2494,
            22.1,22.2,21.2,21.1; 10176.5,0.2494,22.1,22.2,21.2,21.1]);
                             // TODO adapt this value
      annotation (Documentation(revisions="<html>
  <ul>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add some information about the test.
</li>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>",     info="<html>
<p><b><span style=\"color: #008000;\">Overview</span></b> </p>
<p>This record contains information of an aproximately 15 minutes long test bench carried out at the University of Liège.</p>


<p><b><span style=\"color: #008000;\">Data structure</span></b> </p>
<p><br>Column 1: Time in s </p>
<p>Column 2: Mass flow rate in kg/s</p>
<p>Column 3: Outlet pipe temperature in °C  </p>
<p>Column 4: Outlet water temperature in °C </p>
<p>Column 5: Inlet pipe temperature in °C  </p>
<p>Column 6: Inlet water temperature in °C  </p>

<p><b><span style=\"color: #008000;\">Test procedure</span></b> </p>
<p>Before to perform a test, the water city network is pushed inside the approximately 39 meter long studied pipe during about 10 minutes to be sure that it is at the same temperature. During this time period, valves V3 and V1 are opened, the boiler is off and the valve V2 is closed.</p>
<p>
Then, the valve V1 is closed and the valve V2 and V3 are opened. The boiler is started to reach the setpoint hot water temperature. When the temperature setpoint is achieved, data starts to be recorded, the valve V1 is opened and the valve V2 is closed at the same time to supply the studied pipe in hot water. After the outlet pipe temperature is stabilized, the boiler is shut off.</p>
<p>During the test, the ambient temperature is equal to 18 °C and the mass flow rate is set to 1.245 kg/s.</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>
<p>Notice: length are approximate</p>

<p><b><span style=\"color: #008000;\">Pipe characteristics</span></b> </p>

<ul>
<li>Metal density about 7800 kg/m³</li>
<li>Specific heat capacity about 480 J/kg/K</li>
<li>Thickness 3.91 mm (Outer diameter 0.0603 m)</li>
<li>Inner diameter: 0.05248 m</li>
<li>Roughness is currently neglected</li>
<li>Initial temperature of the pipe is considered equal to the initial temperature of the water (cooliing before test)</li>
<li>Heat transfer coefficient between the pipe and the ambient is assumed at 5 W/m²/K (from internal model) due to insulation.  The pipe is insulated by Tubollt 60/13 (13mm of thickness) whose the nominal thermal coefficient is inferior 0.04. Notice the insulation is quite aged therefore the nominal thermal coefficient could be higher</li>
<li>Heat transfer coefficient between water and pipe is a function of the fluid temperature (determined by EES software)</li>
</ul>



</html>"));
    end PipeDataULg160104_2;

    record PipeDataULg160118_1
      "Experimental data from ULg's pipe test bench from January 18, 2016"
      extends IBPSA.Fluid.PlugFlowPipes.Data.BaseClasses.PipeDataULg(
        final n=5,
        T_ini_out=18.2,
        T_ini_in=17.9,
        m_flowIni=2.269,
        data=[0,2.269,18.6,18.2,17.8,17.9; 3.1,2.269,18.6,18.2,17.8,17.9; 6.1,
            2.269,18.6,18.2,17.8,20.5; 9.1,2.269,18.6,18.2,19.1,25.7; 13.8,
            2.269,18.6,18.2,22.8,30.6; 16.8,2.269,18.6,18.2,25.3,32.7; 19.8,
            2.269,18.5,18.1,27.3,34.2; 22.9,2.269,18.5,18.2,29.1,35.2; 25.9,
            2.269,18.4,18.1,30.5,36; 28.8,2.269,18.4,18.1,31.6,36.6; 31.7,2.269,
            18.4,18.1,32.6,37; 36.2,2.269,18.3,18,33.6,37.5; 39,2.269,18.3,17.9,
            34.2,37.8; 42,2.269,18.2,17.9,34.8,38; 45,2.269,18.2,18.3,35.2,38.1;
            47.9,2.269,18.5,19.5,35.5,38.3; 51,2.269,19.4,21.1,35.9,38.4; 53.9,
            2.269,20.7,22.9,36.1,38.5; 56.9,2.269,22.2,24.6,36.4,38.5; 59.8,
            2.269,23.7,26.3,36.5,38.6; 62.8,2.269,25.4,28,36.7,38.6; 65.8,2.269,
            26.9,29.5,36.9,38.7; 68.7,2.269,28.3,30.8,37,38.7; 71.6,2.269,29.6,
            32,37.1,38.7; 74.5,2.269,30.7,33,37.2,38.7; 77.5,2.269,31.7,33.9,
            37.3,38.7; 80.6,2.269,32.6,34.7,37.3,38.7; 83.8,2.269,33.4,35.4,
            37.4,38.7; 86.7,2.269,33.9,36,37.5,38.8; 89.7,2.269,34.4,36.5,37.5,
            38.9; 92.6,2.269,34.9,36.9,37.6,38.9; 97.5,2.269,35.4,37.4,37.7,
            38.8; 100.4,2.269,35.6,37.6,37.7,38.9; 103.3,2.269,35.8,37.9,37.8,
            38.9; 106.2,2.269,36,38,37.8,38.8; 109.2,2.269,36.2,38.2,37.8,38.8;
            112.1,2.269,36.3,38.3,37.9,38.8; 115,2.269,36.4,38.4,37.9,38.8;
            118.1,2.269,36.5,38.5,37.9,38.8; 121.1,2.269,36.6,38.5,37.9,38.8;
            123.9,2.269,36.7,38.6,37.9,38.8; 126.9,2.269,36.7,38.7,37.9,38.8;
            129.8,2.269,36.8,38.7,38,38.8; 132.8,2.269,36.9,38.8,38,38.8; 135.7,
            2.269,36.9,38.8,38,38.8; 138.7,2.269,36.9,38.8,38,38.8; 141.6,2.269,
            37,38.8,38,38.9; 146.7,2.269,37.1,38.9,38.1,38.9; 149.7,2.269,37.1,
            38.9,38.1,38.9; 153.5,2.269,37.1,38.9,38.1,38.9; 156.5,2.269,37.1,
            38.9,38.2,38.9; 159.7,2.269,37.1,38.9,38.2,38.9; 162.8,2.269,37.2,
            38.9,38.2,39; 165.8,2.269,37.2,38.9,38.2,39; 168.7,2.269,37.2,38.9,
            38.3,39; 171.7,2.269,37.2,38.9,38.3,39; 174.6,2.269,37.3,38.9,38.3,
            39.1; 177.6,2.269,37.3,38.9,38.3,39.1; 180.5,2.269,37.3,38.9,38.4,
            39.1; 185.3,2.269,37.3,38.9,38.4,39.2; 188.3,2.269,37.4,38.9,38.5,
            39.2; 191.2,2.269,37.4,38.9,38.5,39.2; 194.2,2.269,37.4,38.9,38.5,
            39.2; 197.1,2.269,37.4,39,38.5,39.1; 200.1,2.269,37.4,39,38.5,39.1;
            203.1,2.269,37.4,39,38.5,39.2; 206.4,2.269,37.4,39,38.5,39.1; 209.3,
            2.269,37.4,39,38.5,39.2; 213.4,2.269,37.5,39,38.5,39.2; 217.3,2.269,
            37.5,39.1,38.5,39.2; 220.7,2.269,37.5,39.1,38.6,39.2; 223.6,2.269,
            37.6,39.1,38.6,39.2; 226.5,2.269,37.6,39.1,38.6,39.2; 229.5,2.269,
            37.6,39.1,38.6,39.2; 233.2,2.269,37.6,39.2,38.6,39.3; 236.1,2.269,
            37.6,39.2,38.7,39.3; 239,2.269,37.6,39.2,38.7,39.3; 242,2.269,37.6,
            39.2,38.7,39.3; 245.1,2.269,37.7,39.2,38.7,39.2; 248,2.269,37.7,
            39.2,38.7,39.2; 251,2.269,37.7,39.2,38.7,39.3; 255.1,2.269,37.7,
            39.2,38.7,39.3; 259.5,2.269,37.7,39.2,38.7,39.3; 262.8,2.269,37.8,
            39.2,38.7,39.3; 265.8,2.269,37.8,39.2,38.8,39.4; 268.8,2.269,37.8,
            39.2,38.8,39.3; 273.7,2.269,37.8,39.2,38.8,39.4; 276.6,2.269,37.8,
            39.3,38.8,39.4; 279.6,2.269,37.8,39.3,38.8,39.4; 282.6,2.269,37.8,
            39.3,38.8,39.4; 285.5,2.269,37.8,39.3,38.9,39.4; 288.5,2.269,37.8,
            39.3,38.9,39.4; 293.2,2.269,37.9,39.3,38.9,39.5; 296.2,2.269,37.9,
            39.3,38.9,39.4; 299.2,2.269,37.9,39.3,38.9,39.4; 302.1,2.269,37.9,
            39.3,38.9,39.4; 307.1,2.269,37.9,39.3,39,39.5; 310.1,2.269,38,39.4,
            39,39.5; 313.1,2.269,37.9,39.4,39,39.5; 316,2.269,38,39.4,39,39.5;
            319,2.269,38,39.4,39,39.4; 322,2.269,38,39.4,39,39.4; 327,2.269,38,
            39.4,39,39.5; 330.4,2.269,38,39.4,39,39.6; 333.4,2.269,38,39.4,39,
            39.6; 338.4,2.269,38,39.4,39.1,39.6; 341.9,2.269,38.1,39.5,39.1,
            39.6; 344.8,2.269,38.1,39.5,39.1,39.6; 347.7,2.269,38.1,39.5,39.1,
            39.6; 352.8,2.269,38.1,39.5,39.1,39.5; 355.7,2.269,38.1,39.5,39,
            39.4; 360.9,2.269,38.2,39.5,39,39.4; 363.8,2.269,38.2,39.5,39,39.5;
            368.9,2.269,38.2,39.5,39,39.5; 372.3,2.269,38.2,39.5,39.1,39.5;
            375.3,2.269,38.2,39.6,39.1,39.6]);
      annotation (Documentation(revisions="<html>
  <ul>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add some information about the test.
</li>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>",     info="<html>
<p><b><span style=\"color: #008000;\">Overview</span></b> </p>
<p>This record contains information of an aproximately 15 minutes long test bench carried out at the University of Liège.</p>


<p><b><span style=\"color: #008000;\">Data structure</span></b> </p>
<p><br>Column 1: Time in s </p>
<p>Column 2: Mass flow rate in kg/s</p>
<p>Column 3: Outlet pipe temperature in °C  </p>
<p>Column 4: Outlet water temperature in °C </p>
<p>Column 5: Inlet pipe temperature in °C  </p>
<p>Column 6: Inlet water temperature in °C  </p>

<p><b><span style=\"color: #008000;\">Test procedure</span></b> </p>
<p>Before to perform a test, the water city network is pushed inside the approximately 39 meter long studied pipe during about 10 minutes to be sure that it is at the same temperature. During this time period, valves V3 and V1 are opened, the boiler is off and the valve V2 is closed.</p>
<p>
Then, the valve V1 is closed and the valve V2 and V3 are opened. The boiler is started to reach the setpoint hot water temperature. When the temperature setpoint is achieved, data starts to be recorded, the valve V1 is opened and the valve V2 is closed at the same time to supply the studied pipe in hot water. After the outlet pipe temperature is stabilized, the boiler is shut off.</p>
<p>During the test, the ambient temperature is equal to 18 °C and the mass flow rate is set to 1.245 kg/s.</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>
<p>Notice: length are approximate</p>

<p><b><span style=\"color: #008000;\">Pipe characteristics</span></b> </p>

<ul>
<li>Metal density about 7800 kg/m³</li>
<li>Specific heat capacity about 480 J/kg/K</li>
<li>Thickness 3.91 mm (Outer diameter 0.0603 m)</li>
<li>Inner diameter: 0.05248 m</li>
<li>Roughness is currently neglected</li>
<li>Initial temperature of the pipe is considered equal to the initial temperature of the water (cooliing before test)</li>
<li>Heat transfer coefficient between the pipe and the ambient is assumed at 5 W/m²/K (from internal model) due to insulation.  The pipe is insulated by Tubollt 60/13 (13mm of thickness) whose the nominal thermal coefficient is inferior 0.04. Notice the insulation is quite aged therefore the nominal thermal coefficient could be higher</li>
<li>Heat transfer coefficient between water and pipe is a function of the fluid temperature (determined by EES software)</li>
</ul>



</html>"));
    end PipeDataULg160118_1;

    record PipeDataAIT151218
      "Experimental data from AIT monitoring data December 18, 2015"
        extends Data.BaseClasses.PipeDataBaseDefinition(final n=9, data=[0,
            372.3,362.9,360.2,356.2,26.667,0.168,0.029,0.013,276.8; 900,371.8,
            362.7,359.2,357.2,27.333,0.099,0.028,0.012,276.8; 1800,371.1,364.2,
            362.2,357.2,23.5,0.089,0.031,0.012,277; 2700,371.6,362.6,361.2,
            357.2,26.167,0.095,0.029,0.011,277; 3600,370.7,363.4,361.2,357.2,
            25.667,0.158,0.035,0.011,277; 4500,371.3,363.8,361.2,357.2,28.167,
            0.101,0.035,0.012,277.1; 5400,372.6,363.8,361.2,357.2,27.5,0.101,
            0.029,0.012,277.2; 6300,372.4,363.8,362.2,358.2,26.833,0.088,0.033,
            0.013,277.4; 7200,372.1,364.4,362.2,358.2,23.833,0.088,0.031,0.013,
            277.2; 8100,372,363.1,361.2,357.2,25.333,0.097,0.033,0.012,277.2;
            9000,371.5,363.8,361.2,357.2,25.833,0.161,0.031,0.012,277.2; 9900,
            371.4,362.7,361.2,356.2,26.167,0.095,0.031,0.011,277.2; 10800,371.4,
            362.7,361.2,356.2,25.833,0.095,0.033,0.012,277.3; 11700,370.9,362.2,
            361.2,356.2,26.333,0.097,0.032,0.012,277.3; 12600,372.4,362.7,361.2,
            357.2,26,0.091,0.031,0.012,276.9; 13500,373.8,364.6,362.2,358.2,
            26.5,0.16,0.031,0.01,276.7; 14400,373.3,364,362.2,357.2,26.667,
            0.091,0.029,0.011,276.7; 15300,370.8,363.3,362.2,357.2,26.333,0.094,
            0.034,0.011,276.8; 16200,372.7,362.7,362.2,357.2,26.667,0.092,0.034,
            0.011,276.8; 17100,371,362.7,361.2,357.2,25.167,0.092,0.031,0.011,
            276.9; 18000,370.2,363.2,361.2,356.2,25,0.165,0.033,0.011,276.9;
            18900,369.7,363.8,364.2,356.2,25.5,0.088,0.083,0.012,276.7; 19800,
            370.3,363.7,367.2,364.2,28.833,0.098,0.066,0.021,276.7; 20700,368.8,
            364.4,365.2,364.2,28.667,0.089,0.064,0.021,276.7; 21600,370.1,363.3,
            365.2,362.2,26.833,0.095,0.064,0.022,276.7; 22500,369.3,363.3,366.2,
            361.2,24.333,0.095,0.106,0.02,276.6; 23400,371,364.6,364.2,361.2,26,
            0.163,0.015,0.02,276.6; 24300,370.3,362.9,364.2,363.2,25.833,0.099,
            0.062,0.035,276.7; 25200,370.7,362.1,364.2,363.2,28,0.094,0.059,
            0.028,276.7; 26100,370.1,362.5,363.2,363.2,27.333,0.094,0.059,0.028,
            276.7; 27000,370.6,363.5,363.2,363.2,25,0.168,0.059,0.032,276.6;
            27900,371.3,362.1,362.2,363.2,26,0.096,0.056,0.032,277; 28800,370.9,
            362.4,364.2,364.2,27.333,0.098,0.059,0.028,276.8; 29700,372.2,363.2,
            364.2,366.2,28.333,0.089,0.049,0.068,276.8; 30600,371.2,362.6,364.2,
            348.2,26.5,0.095,0.059,0,276.7; 31500,371.7,363.1,364.2,348.2,
            27.667,0.167,0.046,0,276.7; 32400,372.6,363.7,364.2,365.2,25.5,
            0.103,0.046,0.054,276.7; 33300,372.6,363.7,364.2,365.2,26,0.103,
            0.052,0.044,276.8; 34200,369.3,363.3,364.2,366.2,25.667,0.096,0.044,
            0.043,276.7; 35100,371.8,363.2,365.2,365.2,27.167,0.094,0.043,0.021,
            276.8; 36000,371.5,364.1,364.2,363.2,27.5,0.089,0.042,0.011,276.8;
            36900,370.8,364.7,363.2,363.2,30,0.162,0.036,0.011,276.8; 37800,372,
            363.9,363.2,361.2,29.333,0.094,0.036,0.009,276.8; 38700,371.2,363.9,
            363.2,359.2,26.5,0.094,0.035,0.014,276.9; 39600,372.3,364,363.2,
            359.2,27.667,0.096,0.038,0.014,277.1; 40500,373,363.8,362.2,359.2,
            28.667,0.087,0.041,0.013,277; 41400,373.9,361.7,362.2,356.2,26,
            0.094,0.037,0.025,277; 42300,372.1,362.4,362.2,356.2,26.5,0.083,
            0.036,0.025,276.7; 43200,372.4,361.1,362.2,361.2,26.833,0.083,0.036,
            0.02,276.7; 44100,373.7,361.1,361.2,360.2,29.5,0.083,0.037,0.018,
            276.7; 45000,370.9,362.5,361.2,360.2,32.833,0.095,0.032,0.017,276.9;
            45900,372.8,361.4,362.2,360.2,29.333,0.06,0.035,0.013,276.8; 46800,
            372.7,362.4,362.2,360.2,29,0.068,0.032,0.015,276.7; 47700,372.1,
            362.1,363.2,360.2,27,0.088,0.038,0.015,276.7; 48600,372.6,362.5,
            363.2,360.2,25.833,0.147,0.031,0.015,276.5; 49500,372.8,363.8,363.2,
            360.2,27.333,0.088,0.031,0.014,276.5; 50400,372.3,363.8,362.2,358.2,
            27.833,0.088,0.032,0.013,276.7; 51300,373.1,362.3,365.2,359.2,
            27.833,0.062,0.061,0.013,276.8; 52200,373.6,363.3,363.2,358.2,
            29.667,0.061,0.029,0.014,276.7; 53100,371.8,362.2,362.2,359.2,
            29.833,0.086,0.033,0.014,276.7; 54000,373.8,364.6,362.2,359.2,31,
            0.153,0.029,0.014,276.9; 54900,373.2,363,362.2,359.2,31.167,0.08,
            0.029,0.014,276.9; 55800,373.6,363,362.2,359.2,34.5,0.08,0.034,
            0.014,276.7; 56700,372.9,363,362.2,359.2,33.167,0.078,0.029,0.013,
            276.6; 57600,373.8,363,362.2,359.2,33.833,0.08,0.03,0.016,276.7;
            58500,373.4,364.6,362.2,359.2,34,0.159,0.028,0.015,276.7; 59400,
            373.8,364,362.2,359.2,32.333,0.084,0.029,0.015,276.7; 60300,371,363,
            362.2,359.2,32.667,0.077,0.029,0.013,276.7; 61200,371,363,362.2,
            360.2,38.333,0.077,0.03,0.017,276.5; 62100,372.3,363.1,362.2,360.2,
            34.667,0.083,0.03,0.014,276.3; 63000,372.4,363.2,363.2,360.2,33.167,
            0.09,0.031,0.014,276.3; 63900,372.1,364.7,362.2,360.2,30.833,0.086,
            0.031,0.02,276.4; 64800,372.5,363.8,363.2,360.2,32.833,0.079,0.031,
            0.02,276.5; 65700,374.2,364,363.2,360.2,37.833,0.079,0.031,0.011,
            276.6; 66600,373.1,364,363.2,354.2,36,0.079,0.03,0,276.6; 67500,
            372.1,363.8,362.2,342.2,39.333,0.083,0.031,0,276.5; 68400,372.8,
            363.3,361.2,336.2,37.5,0.164,0.032,0,276.6; 69300,373.2,362.8,361.2,
            330.2,39.333,0.084,0.035,0,276.6; 70200,372.6,362.5,362.2,330.2,
            38.333,0.083,0.031,0,276.5; 71100,372.7,362.5,362.2,330.2,37.667,
            0.082,0.031,0,276.6; 72000,373.6,362.5,361.2,324.2,39,0.082,0.033,
            0.001,276.6; 72900,373.3,363.3,361.2,319.2,39.5,0.156,0.001,0,276.6;
            73800,374.1,364.4,356.2,316.2,39,0.086,0.013,0,276.8; 74700,373.3,
            363.3,358.2,313.2,35.5,0.085,0.019,0,276.9; 75600,373.5,362.6,357.2,
            313.2,34,0.083,0.016,0,277; 76500,372.7,362.9,357.2,310.2,37.667,
            0.159,0.016,0,277.2; 77400,375,362.9,357.2,308.2,39,0.159,0.02,0,
            277.2; 78300,374.2,364.1,357.2,306.2,40.667,0.088,0.016,0,277.8;
            79200,373.9,363,358.2,306.2,41,0.087,0.021,0,278.5; 80100,375.6,
            362.8,357.2,305.2,38.833,0.079,0.021,0.001,278.4; 81000,377.7,362.8,
            358.2,303.2,38.667,0.086,0.021,0,278.3; 81900,376.3,364.6,357.2,
            303.2,35.5,0.153,0.016,0,278.5; 82800,378,363.2,357.2,302.2,39.833,
            0.09,0.016,0,278.5; 83700,376.7,363.2,359.2,301.2,43.333,0.09,0.021,
            0,278.6; 84600,376.7,362.9,358.2,300.2,40,0.082,0.02,0,278.7; 85500,
            375.5,362.3,358.2,299.2,37.5,0.086,0.021,0,278.5; 86400,376.3,364.6,
            358.2,299.2,34.667,0.161,0.02,0,278.9; 87300,375.7,363.6,358.2,
            299.2,34.833,0.088,0.02,0,279.4; 88200,375.5,363.6,359.2,298.2,
            35.167,0.088,0.02,0,279.4; 89100,376.6,364,358.2,297.2,35,0.08,0.02,
            0.001,280.1; 90000,375.9,365,360.2,297.2,41.5,0.079,0.022,0,280.3;
            90900,373.8,366.5,361.2,296.2,42.167,0.15,0.019,0.001,280.3; 91800,
            375.1,366.2,361.2,296.2,38.833,0.08,0.021,0,280; 92700,375.3,365.4,
            361.2,296.2,35.833,0.077,0.02,0,279.9; 93600,374.8,364.7,361.2,
            296.2,36.833,0.079,0.02,0,279.8; 94500,374.2,364.7,361.2,295.2,
            37.667,0.079,0.022,0.001,279.6; 95400,375.9,365.3,360.2,295.2,
            35.167,0.143,0.02,0.001,279.5; 96300,375.2,365.5,361.2,294.2,36.833,
            0.091,0.023,0,279.4; 97200,375.2,364.5,360.2,294.2,37.5,0.077,0.021,
            0.001,279.2; 98100,375.5,364.7,361.2,294.2,36.833,0.085,0.023,0.001,
            279.2; 99000,375.2,364.5,361.2,294.2,34.167,0.159,0.023,0.001,279.2;
            99900,375.3,364.5,361.2,294.2,30.667,0.159,0.022,0.001,278.8;
            100800,375.8,365,360.2,293.2,32.167,0.089,0.025,0.001,278.8; 101700,
            372.6,364.3,361.2,293.2,33.5,0.08,0.023,0.001,278.5; 102600,374.4,
            363.8,361.2,293.2,33.667,0.085,0.026,0.001,278.1; 103500,375.5,
            364.4,361.2,293.2,36.167,0.155,0.025,0.001,277.7; 104400,375.2,
            365.6,361.2,293.2,35.667,0.084,0.025,0,277.4; 105300,371.6,365.6,
            361.2,293.2,34.167,0.084,0.029,0.021,277.1; 106200,374.4,364.3,
            366.2,293.2,31.167,0.079,0.053,0.021,277.1; 107100,372.7,364.5,
            367.2,366.2,33,0.082,0.055,0.024,276.9; 108000,371.5,365.2,365.2,
            364.2,31.5,0.161,0.052,0.024,276.7; 108900,371,365.5,369.2,364.2,
            31.667,0.08,0.101,0.024,276.3; 109800,371.8,365.8,369.2,366.2,
            31.167,0.076,0.101,0.059,276.2; 110700,371,365.8,367.2,366.2,34.5,
            0.076,0.053,0.037,276; 111600,371.5,365.9,366.2,367.2,33.667,0.079,
            0.059,0.067,276; 112500,371,365.4,366.2,367.2,33.833,0.154,0.053,
            0.067,275.9; 113400,372.4,365.7,365.2,365.2,30.333,0.088,0.057,
            0.037,275.7; 114300,369.9,363.4,365.2,365.2,35.333,0.085,0.055,
            0.037,275.6; 115200,372.2,362.9,365.2,366.2,36.833,0.086,0.055,
            0.037,275.3; 116100,370.9,362.9,365.2,366.2,33.167,0.086,0.059,
            0.064,275.1; 117000,371.2,364.3,365.2,366.2,30,0.153,0.063,0.035,
            275.1; 117900,371.7,364,365.2,365.2,29.5,0.082,0.056,0.046,275.1;
            118800,371.9,363.5,365.2,365.2,30.333,0.087,0.05,0.046,274.7;
            119700,370.5,363.5,364.2,365.2,32.167,0.083,0.046,0.046,274.5;
            120600,370.8,364.3,364.2,366.2,30.5,0.164,0.046,0.033,274.3; 121500,
            371.4,364.3,364.2,363.2,28.833,0.164,0.039,0.026,274.2; 122400,
            371.4,363.5,363.2,362.2,29.667,0.089,0.036,0.017,274.2; 123300,
            371.8,362.8,362.2,360.2,28.167,0.081,0.033,0.015,274.2; 124200,
            372.6,362.7,362.2,360.2,29.167,0.079,0.038,0.021,274.1; 125100,
            372.9,362.6,363.2,360.2,25.5,0.081,0.042,0.021,273.8; 126000,373.6,
            363.9,363.2,359.2,26.833,0.155,0.042,0.013,273.6; 126900,372.2,
            363.9,362.2,359.2,28,0.155,0.036,0.013,273.5; 127800,373.3,362,
            362.2,358.2,30.333,0.088,0.039,0.016,273.7; 128700,374.3,361.5,
            362.2,361.2,33.333,0.094,0.036,0.023,273.7; 129600,374.6,361.6,
            362.2,348.2,27.667,0.053,0.038,0,273.4; 130500,372.5,361.8,362.2,
            348.2,28.333,0.075,0.036,0,273.3; 131400,374.3,362,362.2,338.2,
            28.167,0.089,0.036,0,273.2; 132300,375,362,362.2,338.2,28.333,0.089,
            0.036,0,273.2; 133200,374.8,361.7,362.2,331.2,30.333,0.098,0.033,
            0.001,273.1; 134100,373.7,363.6,362.2,325.2,29,0.146,0.031,0.001,
            273.1; 135000,372.4,362.7,362.2,321.2,29.833,0.042,0.033,0.001,
            272.8; 135900,372,361.6,362.2,317.2,29.333,0.09,0.031,0,272.9;
            136800,374.9,361.5,362.2,317.2,29.833,0.099,0.033,0,272.8; 137700,
            373.5,361.8,362.2,314.2,28.833,0.1,0.033,0,272.8; 138600,374.5,
            361.8,362.2,314.2,29.667,0.1,0.027,0,272.7; 139500,375.2,362.1,
            361.2,311.2,29.667,0.053,0.03,0,272.7; 140400,374.9,362.2,362.2,
            308.2,28.5,0.063,0.029,0,272.8; 141300,374.4,364,362.2,306.2,26.167,
            0.056,0.03,0,272.5; 142200,374.3,362.5,362.2,306.2,29.667,0.091,
            0.03,0,272.4; 143100,375.2,360.2,362.2,305.2,32.167,0.009,0.03,0,
            272.5; 144000,373.6,360.2,361.2,303.2,32,0.009,0.03,0,272.8; 144900,
            374.5,361.2,363.2,303.2,29.333,0.089,0.049,0,272.5; 145800,373.8,
            360.6,363.2,301.2,29.5,0.098,0.038,0,272.5; 146700,373.5,362.9,
            362.2,301.2,28.833,0.157,0.033,0,272.3; 147600,373.2,363.4,363.2,
            301.2,29.167,0.071,0.034,0,272.2; 148500,373.7,363.3,363.2,300.2,
            27.667,0.087,0.034,0,272.3; 149400,372.9,363.3,363.2,299.2,29.833,
            0.087,0.035,0,272.3; 150300,371.1,363,364.2,298.2,32.667,0.098,
            0.041,0,272.4; 151200,372.5,362.8,364.2,298.2,32,0.057,0.039,0.001,
            272.4; 152100,373.9,364.7,362.2,297.2,26.833,0.09,0.027,0.001,272.5;
            153000,372.8,363.8,362.2,297.2,28.833,0.08,0.034,0.001,272.7;
            153900,371.9,363.1,362.2,297.2,29.833,0.099,0.034,0.001,272.5;
            154800,371.6,363.1,362.2,297.2,29.5,0.099,0.034,0,272.8; 155700,
            372.5,363,363.2,296.2,28.333,0.071,0.039,0.001,272.6; 156600,372.9,
            364.6,363.2,295.2,27.833,0.156,0.032,0,272.6; 157500,372.8,363.5,
            362.2,295.2,26.333,0.086,0.039,0,272.8; 158400,373,362.4,362.2,
            295.2,30.5,0.084,0.034,0,272.9; 159300,372.4,362.9,362.2,295.2,31,
            0.079,0.034,0,273.1; 160200,372.3,362.9,360.2,295.2,29.667,0.079,
            0.02,0,272.9; 161100,373.4,363.8,360.2,294.2,29.833,0.159,0.017,0,
            273; 162000,372.5,363.2,358.2,294.2,27.167,0.095,0.017,0.001,273;
            162900,374.2,362.3,357.2,294.2,30,0.083,0.018,0,273.2; 163800,372.9,
            362.4,357.2,294.2,29.667,0.083,0.019,0,273.5; 164700,373.8,362.6,
            357.2,293.2,29.333,0.115,0.019,0,273.9; 165600,373.6,362.6,357.2,
            293.2,27.667,0.115,0.018,0.001,274.5; 166500,374.2,364.3,357.2,
            293.2,29.167,0.109,0.018,0.001,275; 167400,375,362.5,358.2,293.2,30,
            0.086,0.022,0,275; 168300,377,362.3,357.2,293.2,27.667,0.08,0.021,0,
            275.5; 169200,374.9,362.5,358.2,293.2,28.833,0.084,0.022,0,275.9;
            170100,376.2,364,358.2,293.2,29.667,0.153,0.022,0.001,276.1; 171000,
            375.8,364,358.2,292.2,30.333,0.153,0.021,0,275.9; 171900,376.3,
            363.3,358.2,292.2,28.5,0.084,0.021,0,275.6; 172800,376.2,363.2,
            359.2,292.2,28.333,0.088,0.021,0,275.6; 173700,377.8,362.9,359.2,
            292.2,28.333,0.085,0.023,0,275.8; 174600,376.8,364.6,359.2,292.2,
            29.167,0.156,0.021,0,275.8; 175500,375.5,364.4,359.2,292.2,28.167,
            0.084,0.021,0,275.9; 176400,375,364.4,359.2,292.2,29.333,0.084,
            0.023,0.001,275.9; 177300,374.5,364.7,361.2,291.2,26.167,0.082,
            0.023,0.001,276.1; 178200,374,364.5,361.2,291.2,26.333,0.084,0.021,
            0.001,276.2; 179100,374.5,366.1,361.2,291.2,29.167,0.153,0.021,
            0.001,276.2; 180000,375.8,365.3,361.2,291.2,29.333,0.09,0.021,0,
            276.2; 180900,375.7,364.8,360.2,291.2,30.667,0.083,0.021,0,276.1;
            181800,374.9,365.4,360.2,291.2,30.667,0.08,0.021,0.001,276.3;
            182700,373.5,365.4,361.2,291.2,31.167,0.08,0.022,0.001,276.4;
            183600,375.3,366.8,362.2,291.2,30.167,0.147,0.021,0.001,276.5;
            184500,375.8,365.2,361.2,291.2,30.5,0.079,0.022,0,276.5; 185400,
            375.1,364,360.2,291.2,28.167,0.081,0.02,0,276.5; 186300,375.8,363.4,
            360.2,291.2,29.5,0.084,0.023,0,276.5; 187200,375.9,364.7,360.2,
            291.2,30.667,0.151,0.023,0.001,276.6; 188100,373.2,364.7,359.2,
            291.2,29.833,0.151,0.021,0,276.7; 189000,374.8,364.7,360.2,290.2,
            29.833,0.085,0.023,0,276.7; 189900,375.9,364.5,360.2,291.2,28.833,
            0.086,0.021,0,276.7; 190800,373.8,363.7,360.2,290.2,29.833,0.078,
            0.023,0,276.6; 191700,372.1,364.6,362.2,290.2,32.5,0.157,0.035,0,
            276.6; 192600,373.8,365.1,362.2,290.2,32.833,0.088,0.035,0,276.6;
            193500,371.9,365.1,364.2,290.2,33.167,0.088,0.037,0.001,276.7;
            194400,373.7,364.6,365.2,290.2,28.667,0.076,0.032,0.001,276.8;
            195300,372.3,365.3,365.2,283.2,28.667,0.083,0.07,0.081,276.8;
            196200,371.7,364.9,364.2,364.2,30.333,0.158,0.043,0.02,277; 197100,
            373.1,365.5,365.2,364.2,30.333,0.085,0.039,0.02,276.9; 198000,372.3,
            364.5,365.2,364.2,29.167,0.082,0.039,0.02,277.1; 198900,371,364.5,
            364.2,362.2,28.833,0.082,0.039,0.023,277.1; 199800,371,363.1,364.2,
            363.2,27.667,0.079,0.037,0.024,277; 200700,371.3,364.7,364.2,364.2,
            29.5,0.158,0.041,0.022,277; 201600,371.6,364.8,364.2,363.2,30.5,
            0.082,0.041,0.022,276.9; 202500,372.7,363.7,363.2,363.2,30.333,
            0.083,0.039,0.022,276.9; 203400,372.1,362.7,363.2,363.2,28.333,
            0.086,0.039,0.021,276.7; 204300,370.9,362.7,364.2,363.2,27.667,
            0.086,0.038,0.021,276.9; 205200,371.6,364.9,363.2,362.2,28.833,
            0.154,0.035,0.021,276.8; 206100,371.5,363.3,364.2,361.2,29,0.083,
            0.061,0.018,276.8; 207000,372.3,362.5,364.2,360.2,28.667,0.086,
            0.045,0.019,276.8; 207900,373.4,362.6,364.2,360.2,26.5,0.085,0.041,
            0.019,276.9; 208800,372.8,364.9,364.2,361.2,26.667,0.154,0.041,
            0.018,277; 209700,373.8,364.9,364.2,361.2,28.5,0.154,0.042,0.018,
            277; 210600,373.9,363.8,363.2,358.2,28.5,0.082,0.031,0.009,277.1;
            211500,373.7,362.5,361.2,355.2,26.167,0.083,0.03,0.012,277.1;
            212400,374.6,362.3,362.2,355.2,28.333,0.084,0.031,0.012,277.1;
            213300,376,362.3,361.2,355.2,28.833,0.081,0.031,0.012,277; 214200,
            373.7,364.1,361.2,355.2,30.167,0.096,0.031,0.009,277; 215100,372.7,
            364.1,361.2,356.2,27.5,0.096,0.028,0.011,277; 216000,372.9,362.8,
            362.2,348.2,27.333,0.063,0.028,0,276.9; 216900,373.9,362.9,361.2,
            337.2,28.833,0.061,0.031,0.001,276.9; 217800,373.2,362.9,362.2,
            330.2,27.5,0.087,0.028,0,277.1; 218700,375.8,361.7,362.2,330.2,
            28.833,0.09,0.029,0,276.9; 219600,375.4,361.3,362.2,330.2,25.667,
            0.023,0.029,0,276.9; 220500,375.9,361.3,362.2,324.2,25,0.023,0.028,
            0,276.9; 221400,374.3,362.5,362.2,320.2,25.667,0.085,0.028,0.001,
            276.9; 222300,375.2,363.9,363.2,316.2,26,0.137,0.032,0.001,276.9;
            223200,374.7,362,362.2,312.2,27,0.018,0.028,0.001,276.8; 224100,
            374.8,362.3,361.2,310.2,26.833,0.067,0.033,0,276.5; 225000,375.5,
            359.6,361.2,310.2,26.333,0.106,0.028,0,276.4; 225900,374.6,359.5,
            361.2,310.2,25.833,0.024,0.028,0,276.3; 226800,374.3,359.5,361.2,
            307.2,24.667,0.024,0.035,0,276.2; 227700,372.4,360.7,362.2,305.2,
            26.667,0.048,0.032,0,276; 228600,376.5,361,363.2,304.2,28.167,0.091,
            0.036,0.001,276; 229500,375.4,363.6,363.2,302.2,27,0.157,0.031,
            0.001,275.9; 230400,373.4,363,363.2,302.2,25.5,0.043,0.035,0.001,
            275.5; 231300,371.6,362.7,363.2,301.2,24.333,0.074,0.035,0,275.3;
            232200,374.4,362.7,363.2,301.2,24.5,0.074,0.036,0,275.1; 233100,
            374.5,362.6,363.2,300.2,25,0.09,0.034,0.001,275.1; 234000,373.7,
            362.2,364.2,299.2,25.667,0.097,0.063,0.001,275.1; 234900,372.4,
            362.8,364.2,298.2,25.5,0.053,0.044,0,274.9; 235800,371.6,364.3,
            364.2,298.2,23.5,0.096,0.042,0,274.8; 236700,373.2,363.6,364.2,
            297.2,24.667,0.045,0.042,0,274.2; 237600,374,363.6,365.2,297.2,
            24.167,0.045,0.041,0.001,274.3; 238500,371.8,364.5,363.2,297.2,
            22.833,0.08,0.018,0.001,273.9; 239400,371.8,362.9,362.2,296.2,21.5,
            0.087,0.032,0,273.9; 240300,371.6,362.7,363.2,295.2,21.167,0.141,
            0.039,0,274; 241200,371.5,364.7,364.2,295.2,20.167,0.089,0.039,0,
            273.6; 242100,371.9,363.4,364.2,295.2,19.833,0.079,0.039,0,273.5;
            243000,372.1,363.4,363.2,294.2,19.5,0.079,0.044,0.001,273.6; 243900,
            372.6,362.1,363.2,299.2,19,0.078,0.041,0.154,273.5; 244800,372.5,
            362.5,364.2,299.2,22,0.085,0.045,0.154,273.5; 245700,373.8,364.5,
            361.2,359.2,22.5,0.153,0.014,0.012,273.4; 246600,373.1,362.6,360.2,
            359.2,21.5,0.085,0.019,0.012,273.5; 247500,372.1,362.5,360.2,358.2,
            18,0.079,0.019,0.012,273.7; 248400,371.9,362.5,359.2,358.2,18.333,
            0.079,0.026,0.013,273.8; 249300,372.5,362.2,359.2,358.2,18.5,0.086,
            0.023,0.013,273.5; 250200,372.3,364.1,359.2,358.2,20,0.159,0.022,
            0.013,273.5; 251100,373.3,363.2,360.2,358.2,20.667,0.087,0.024,
            0.013,274.3; 252000,372.5,362.7,360.2,358.2,18.333,0.085,0.025,
            0.013,274.5; 252900,374.2,363.1,360.2,358.2,16.5,0.085,0.025,0.014,
            275.1; 253800,375.2,363.1,361.2,359.2,17.667,0.085,0.027,0.014,
            276.1; 254700,375.2,364.7,361.2,358.2,19,0.155,0.027,0.013,276.7;
            255600,374,363.6,361.2,358.2,20.667,0.083,0.028,0.013,276.7; 256500,
            375.5,362.9,361.2,359.2,18.167,0.084,0.029,0.013,277.4; 257400,
            374.2,362.7,361.2,359.2,19.5,0.091,0.028,0.013,277.7; 258300,375.3,
            364.3,361.2,359.2,17.833,0.157,0.028,0.013,277.8; 259200,373.6,
            364.3,362.2,359.2,18.667,0.157,0.032,0.013,278.3; 260100,374.4,364,
            362.2,359.2,19.167,0.092,0.033,0.014,278.5; 261000,373.4,364,363.2,
            360.2,19.167,0.086,0.032,0.014,278.5; 261900,372.2,364.8,364.2,
            361.2,18.333,0.083,0.033,0.014,278.2; 262800,372.6,365.9,364.2,
            360.2,18.333,0.146,0.033,0.014,278.7; 263700,375.2,365.8,364.2,
            360.2,20.333,0.094,0.033,0.014,278.5; 264600,374.7,364.7,364.2,
            361.2,20.167,0.082,0.033,0.015,278.6; 265500,373.2,364.7,364.2,
            361.2,18.333,0.082,0.036,0.015,278.7; 266400,374.4,364.9,364.2,
            361.2,19,0.079,0.035,0.015,278.7; 267300,373.9,365,363.2,361.2,
            17.667,0.155,0.034,0.015,278.6; 268200,373.8,365.2,363.2,360.2,19,
            0.087,0.034,0.014,278.4; 269100,374.2,363.4,363.2,360.2,17.5,0.081,
            0.039,0.014,278.2; 270000,371.9,363.1,363.2,359.2,18,0.086,0.039,
            0.015,278.4; 270900,371.8,363.1,364.2,361.2,19.167,0.086,0.037,
            0.014,278.2; 271800,373.4,365.4,364.2,361.2,19.833,0.144,0.039,
            0.014,278.3; 272700,371.9,365.6,364.2,361.2,21.667,0.081,0.035,
            0.015,278.3; 273600,370.8,364.6,364.2,366.2,20.5,0.085,0.036,0.034,
            278.4; 274500,372.6,364.2,364.2,366.2,18.667,0.082,0.034,0.034,278;
            275400,372.5,365.6,364.2,365.2,17.833,0.156,0.034,0.029,277.6;
            276300,371.1,365.6,364.2,363.2,18.333,0.156,0.038,0.022,277.4;
            277200,369.9,364.9,363.2,364.2,20.333,0.106,0.039,0.033,277; 278100,
            371.4,363.2,365.2,364.2,19,0.083,0.061,0.033,277; 279000,372.1,
            363.9,365.2,363.2,19.167,0.083,0.062,0.026,276.5; 279900,371.6,
            363.8,366.2,363.2,18.667,0.157,0.062,0.026,276.5; 280800,371.5,
            365.2,366.2,366.2,20,0.086,0.062,0.032,276.3; 281700,371.2,365.2,
            366.2,361.2,20.333,0.086,0.059,0.044,276.1; 282600,371.7,363.9,
            366.2,368.2,22.667,0.085,0.111,0.088,276; 283500,370.6,362.4,367.2,
            363.2,19.833,0.088,0.093,0,276; 284400,371.5,364.9,366.2,367.2,21.5,
            0.158,0.001,0.08,275.5; 285300,370.4,365.1,365.2,367.2,19.667,0.096,
            0.061,0.08,275.4; 286200,370.9,363.8,365.2,363.2,19.167,0.085,0.061,
            0,275.2; 287100,371.1,363.7,365.2,367.2,20.333,0.084,0.061,0.081,
            275.2; 288000,371.2,363.4,365.2,353.2,20.5,0.086,0.057,0,275.2;
            288900,370,363.4,365.2,353.2,20.5,0.086,0.057,0,275.2; 289800,371.2,
            364.3,365.2,353.2,21.333,0.089,0.057,0,275; 290700,371.8,363.9,
            365.2,366.2,20.167,0.082,0.055,0.065,275; 291600,371.4,363.4,364.2,
            366.2,20.333,0.084,0.047,0.065,275; 292500,371.6,363,365.2,365.2,
            19.5,0.086,0.049,0.033,275; 293400,370.7,364.3,364.2,365.2,21.167,
            0.088,0.041,0.033,275.1; 294300,372.8,363,364.2,364.2,22.5,0.088,
            0.041,0.033,275.1; 295200,370.1,363,362.2,363.2,20.167,0.088,0.033,
            0.027,275.1; 296100,369.3,362.7,362.2,364.2,21.667,0.088,0.033,
            0.025,275; 297000,369.5,362.9,362.2,364.2,21.833,0.089,0.036,0.026,
            275.3; 297900,369.2,363.1,363.2,364.2,22,0.085,0.04,0.028,275.1;
            298800,372.4,362.9,363.2,364.2,22.333,0.085,0.042,0.028,275; 299700,
            373,363.6,363.2,364.2,21,0.091,0.042,0.028,275; 300600,372.4,362.9,
            363.2,363.2,18.5,0.084,0.039,0.023,275.1; 301500,373,363.1,363.2,
            363.2,20,0.089,0.04,0.039,275.1; 302400,372.8,361.2,361.2,362.2,20,
            0.07,0.039,0.036,275.1; 303300,373.8,360.4,360.2,363.2,27,0.097,
            0.044,0.039,274.9; 304200,374.5,358.6,362.2,363.2,27,0.054,0.041,
            0.039,274.7; 305100,373.2,360.7,362.2,365.2,25.5,0.089,0.041,0.03,
            274.7; 306000,372.4,361.4,363.2,365.2,22,0.086,0.039,0.03,274.8;
            306900,374.2,364,363.2,364.2,24.667,0.088,0.034,0.024,274.9; 307800,
            374,360.2,363.2,364.2,23,0.014,0.034,0.032,274.7; 308700,374,362.5,
            363.2,364.2,21.5,0.092,0.034,0.031,274.4; 309600,373.9,361.8,363.2,
            363.2,23.333,0.033,0.038,0.013,274.9; 310500,374.2,360,363.2,363.2,
            24.5,0.01,0.038,0.013,275.2; 311400,374.8,361.8,363.2,364.2,23.333,
            0.093,0.033,0.03,275.2; 312300,374.3,362.2,364.2,360.2,25.333,0.03,
            0.032,0.008,275.1; 313200,373.2,362.6,363.2,357.2,24,0.098,0.038,
            0.011,275.1; 314100,371.4,363,362.2,357.2,23.167,0.085,0.033,0.011,
            275.2; 315000,373.2,362.6,363.2,359.2,29.333,0.086,0.04,0.017,275.3;
            315900,372.7,364,363.2,359.2,28.5,0.09,0.036,0.017,275.5; 316800,
            374.9,362.7,363.2,359.2,27,0.046,0.036,0.01,275.5; 317700,374.2,
            362.7,363.2,357.2,25.833,0.046,0.036,0.011,275.3; 318600,370.9,
            363.5,364.2,357.2,24.167,0.078,0.038,0.013,275.3; 319500,372,362.7,
            364.2,357.2,26.167,0.09,0.037,0.013,275.4; 320400,373.2,364.1,363.2,
            360.2,29.167,0.08,0.043,0.015,275.5; 321300,371.1,363.4,363.2,360.2,
            29,0.083,0.044,0.015,275.4; 322200,372.2,362.3,363.2,361.2,27.667,
            0.085,0.044,0.016,275.4; 323100,371.4,362.3,363.2,360.2,29,0.085,
            0.05,0.015,275.5; 324000,370.9,364.4,365.2,360.2,30.5,0.087,0.044,
            0.012,275.5; 324900,373.3,364.5,364.2,356.2,28.333,0.081,0.043,0,
            275.5; 325800,373.4,363.7,364.2,356.2,35.5,0.089,0.051,0,275.3;
            326700,371.5,362.7,364.2,356.2,33.5,0.086,0.045,0,275.1; 327600,
            372.8,363.4,364.2,338.2,32.667,0.085,0.045,0,275.1; 328500,372.8,
            363.4,363.2,338.2,33.167,0.085,0.046,0,274.9; 329400,374,364,364.2,
            331.2,33.5,0.089,0.047,0.001,274.9; 330300,372.1,362.9,363.2,325.2,
            30.5,0.088,0.048,0,274.8; 331200,372.4,362.3,364.2,321.2,33.167,
            0.087,0.054,0.001,274.7; 332100,373.2,362.9,359.2,321.2,32.333,0.09,
            0.003,0.001,274.5; 333000,372.5,364.6,359.2,360.2,31,0.159,0.003,
            0.014,274.5; 333900,373.3,364.6,360.2,359.2,32.667,0.159,0.025,
            0.013,274.6; 334800,372.3,364.3,360.2,359.2,33,0.084,0.023,0.013,
            274.9; 335700,372,363.6,358.2,358.2,35.667,0.085,0.025,0.012,274.8;
            336600,371.3,363.9,360.2,357.2,35.5,0.086,0.024,0.01,275.1; 337500,
            372,363.6,361.2,357.2,36.333,0.097,0.024,0.01,275.1; 338400,373,
            364.9,361.2,357.2,34.333,0.136,0.024,0.013,275.1; 339300,374.3,
            364.9,360.2,357.2,31.5,0.136,0.027,0.013,276; 340200,374,364.2,
            361.2,358.2,32.833,0.091,0.025,0.011,276.6; 341100,373.4,363.3,
            360.2,357.2,32,0.092,0.025,0.011,277.1; 342000,373.7,363.4,361.2,
            357.2,34.167,0.091,0.024,0.011,277.8; 342900,372.7,364,360.2,357.2,
            36.333,0.164,0.025,0.011,278.3; 343800,373.9,362.8,360.2,357.2,45.5,
            0.09,0.025,0.013,278.3; 344700,374.4,362.8,360.2,357.2,38.5,0.09,
            0.029,0.013,278.5; 345600,373.9,362.6,360.2,357.2,36.333,0.092,
            0.028,0.012,278.7; 346500,375.3,363.5,362.2,358.2,21.333,0.091,
            0.027,0.011,278.9; 347400,373.6,365,362.2,357.2,34.833,0.146,0.024,
            0.011,279.5; 348300,371.3,365,361.2,357.2,35,0.099,0.024,0.011,
            279.8; 349200,371.7,364.3,361.2,357.2,22.333,0.089,0.024,0.01,279.8;
            350100,373.9,364.3,361.2,357.2,45.333,0.089,0.025,0.01,279.7;
            351000,374.9,363.6,361.2,357.2,41.5,0.089,0.024,0.012,279.5; 351900,
            373.9,363.8,361.2,357.2,38,0.145,0.026,0.011,279.2; 352800,375.4,
            365.5,362.2,358.2,35.5,0.09,0.027,0.01,279; 353700,373.1,364.7,
            362.2,358.2,37.5,0.089,0.028,0.011,278.4; 354600,372.6,364.9,362.2,
            358.2,38.167,0.091,0.027,0.011,278.4; 355500,371.5,363.4,362.2,
            357.2,37,0.151,0.027,0.012,278; 356400,374.2,363.4,361.2,357.2,37,
            0.151,0.029,0.012,277.8; 357300,371.4,364.2,361.2,356.2,33.167,
            0.114,0.03,0.011,277.9; 358200,373.8,364.2,362.2,357.2,34.167,0.087,
            0.03,0.011,277.9; 359100,373.3,364.9,363.2,358.2,33.167,0.091,0.029,
            0.012,277.6; 360000,372.6,364.4,362.2,358.2,33,0.096,0.028,0.012,
            277.6; 360900,372.9,365.2,362.2,358.2,35.5,0.159,0.028,0.011,277.6;
            361800,374.6,365.2,362.2,362.2,37.167,0.159,0.027,0.02,277.1;
            362700,372.9,363.6,361.2,362.2,38.5,0.088,0.028,0.02,277.1; 363600,
            372.3,363.1,360.2,363.2,35.667,0.091,0.026,0.018,276.7; 364500,
            371.7,363.7,364.2,362.2,34.333,0.089,0.064,0.016,276.5; 365400,372,
            365.4,365.2,362.2,30.5,0.154,0.061,0.016,276.1; 366300,371.4,364.3,
            365.2,361.2,33.167,0.09,0.061,0.02,276.1; 367200,370.4,364.3,365.2,
            361.2,31,0.09,0.058,0.022,275.9; 368100,371.2,363.9,366.2,363.2,
            30.333,0.089,0.055,0.061,275.7; 369000,370.7,364.9,366.2,363.2,
            30.833,0.087,0.053,0.061,275.5; 369900,371.2,365.5,364.2,364.2,29.5,
            0.157,0.052,0.034,275.2; 370800,371.7,364.1,364.2,364.2,29.333,
            0.091,0.051,0.034,275.1; 371700,370.3,363.7,364.2,365.2,28.167,
            0.085,0.051,0.055,275.1; 372600,371,363.3,365.2,364.2,31.5,0.088,
            0.064,0.04,274.9; 373500,371.5,362.3,363.2,366.2,31.333,0.09,0.05,
            0.051,274.5; 374400,371,364.6,364.2,366.2,29.5,0.153,0.045,0.047,
            274.4; 375300,370.8,364.1,364.2,366.2,27,0.092,0.041,0.051,274.2;
            376200,370,363.1,364.2,366.2,27.333,0.091,0.041,0.051,274.1; 377100,
            372.9,363.2,364.2,366.2,28.167,0.087,0.047,0.051,274.1; 378000,
            371.9,363.1,364.2,365.2,28.167,0.088,0.041,0.048,273.8; 378900,
            370.4,363.9,364.2,364.2,27,0.161,0.045,0.04,273.7; 379800,371.9,364,
            363.2,366.2,27.167,0.16,0.041,0.051,273.6; 380700,371.7,363.2,363.2,
            366.2,28.167,0.094,0.047,0.051,273.3; 381600,372,362.7,363.2,365.2,
            30.333,0.089,0.047,0.033,273.4; 382500,370.3,362.7,363.2,366.2,
            30.667,0.089,0.041,0.034,273.4; 383400,371.3,362.6,364.2,364.2,
            28.167,0.088,0.041,0.04,273.3; 384300,370.7,364.7,363.2,364.2,25.5,
            0.159,0.039,0.04,273; 385200,372.5,362.9,362.2,364.2,24.167,0.093,
            0.039,0.02,272.8; 386100,371.2,363,363.2,364.2,24.5,0.089,0.035,
            0.02,272.8; 387000,372.9,363.3,363.2,364.2,25,0.092,0.035,0.036,
            272.6; 387900,372.6,363.3,363.2,364.2,26,0.092,0.04,0.021,272.6;
            388800,371.6,363.7,363.2,362.2,26.167,0.165,0.036,0.028,272.4;
            389700,372.5,364,362.2,363.2,25.167,0.095,0.037,0.019,272.3; 390600,
            373.2,363,362.2,363.2,25.667,0.091,0.037,0.019,272.3; 391500,371.6,
            362.3,362.2,363.2,26.5,0.091,0.036,0.019,272.2; 392400,372.8,363.1,
            362.2,362.2,25.167,0.092,0.036,0.014,272.1; 393300,372.7,363.1,
            362.2,362.2,25.333,0.092,0.036,0.038,271.9; 394200,373.3,364.3,
            363.2,363.2,24.167,0.159,0.032,0.012,271.9; 395100,372,364.1,363.2,
            361.2,22.5,0.088,0.037,0.024,271.5; 396000,371.6,363.2,363.2,364.2,
            24.5,0.088,0.033,0.014,271.5; 396900,371.5,363.3,363.2,364.2,25.667,
            0.089,0.035,0.014,271.6; 397800,371.9,364.1,363.2,364.2,25.5,0.159,
            0.038,0.014,271.3; 398700,371.9,364.3,363.2,362.2,26.833,0.094,
            0.038,0.013,271.3; 399600,374.4,364.3,363.2,363.2,26.167,0.094,
            0.034,0.041,271.3; 400500,371.1,364.2,363.2,361.2,23.833,0.086,
            0.037,0.015,271.1; 401400,371,363.8,363.2,360.2,21.5,0.084,0.036,
            0.013,271.1; 402300,371.8,363.2,363.2,361.2,23.167,0.088,0.038,0.02,
            271; 403200,372.2,364,362.2,361.2,23.333,0.124,0.037,0.02,271.1;
            404100,370.9,363.2,362.2,361.2,23.667,0.087,0.037,0.02,271.1;
            405000,370.9,363.2,363.2,360.2,22.833,0.087,0.037,0.013,271.1;
            405900,371.2,362.8,364.2,363.2,22.667,0.09,0.038,0.025,270.7;
            406800,371.1,364.3,363.2,360.2,22.833,0.089,0.04,0.015,270.7;
            407700,372.2,363.8,363.2,360.2,23.5,0.163,0.041,0.013,270.5; 408600,
            371.2,363.3,363.2,360.2,26.333,0.09,0.043,0.013,270.5; 409500,372.2,
            363.7,363.2,362.2,23.667,0.088,0.043,0.031,270.5; 410400,372.4,
            363.7,363.2,362.2,22.167,0.088,0.04,0.031,270.5; 411300,372.2,362.7,
            363.2,361.2,23.667,0.089,0.042,0.015,270.6; 412200,371.7,362.6,
            363.2,352.2,25.833,0.109,0.041,0.001,270.2; 413100,371.4,363.8,
            363.2,341.2,22.667,0.088,0.046,0,270.1; 414000,371.5,363.1,363.2,
            341.2,23.333,0.089,0.039,0,270.3; 414900,372.5,363.4,363.2,333.2,
            24.5,0.091,0.039,0.001,270.1; 415800,371.9,363.4,363.2,327.2,22.667,
            0.091,0.041,0.001,270.1; 416700,371.9,362.5,363.2,327.2,23.167,0.09,
            0.042,0.001,269.7; 417600,372.2,364.6,363.2,322.2,25.5,0.156,0.044,
            0.001,269.7; 418500,373,363.5,356.2,318.2,21.5,0.089,0.012,0,269.7;
            419400,373.7,362.7,357.2,318.2,22.833,0.09,0.014,0,269.8; 420300,
            373.7,362.3,357.2,315.2,22.5,0.088,0.014,0,270.2; 421200,372.3,
            362.3,358.2,312.2,22.5,0.088,0.017,0.001,270.5; 422100,373.4,364.2,
            356.2,309.2,22.833,0.159,0.02,0,271.3; 423000,372.9,363.3,357.2,
            309.2,23.167,0.092,0.018,0,271.7; 423900,372.5,362.9,358.2,307.2,
            22.833,0.092,0.022,0,271.7; 424800,372.4,362.4,358.2,307.2,23.833,
            0.091,0.018,0,272.2; 425700,376.8,364.2,358.2,305.2,24.833,0.16,
            0.018,0,273; 426600,374.5,364.2,358.2,304.2,23,0.16,0.022,0,273.5;
            427500,373.3,364.4,358.2,302.2,23,0.09,0.021,0,274.3; 428400,372.1,
            364,359.2,301.2,21.667,0.095,0.02,0.001,274.8; 429300,376.6,363.1,
            359.2,301.2,21.667,0.088,0.021,0.001,274.8; 430200,374.5,363.9,
            358.2,301.2,22.667,0.158,0.021,0.001,275.3; 431100,372.5,363.8,
            358.2,300.2,26.667,0.101,0.021,0,275.7; 432000,372.7,363.8,359.2,
            299.2,23.167,0.101,0.022,0.001,276.1; 432900,375.3,362.9,358.2,
            298.2,22.833,0.091,0.022,0.001,276.6; 433800,374.9,364.6,359.2,
            298.2,24.667,0.089,0.023,0,277.1; 434700,376.3,365.1,361.2,297.2,
            24.167,0.148,0.021,0.001,277.1; 435600,375,364.4,360.2,297.2,24.5,
            0.088,0.023,0.001,277.3; 436500,374.8,363.9,360.2,297.2,24.333,
            0.088,0.023,0,277.4; 437400,373.1,363.9,359.2,297.2,24.667,0.088,
            0.021,0,277.4; 438300,374.7,364.8,360.2,296.2,24.333,0.085,0.024,0,
            277.4; 439200,375.2,364.1,360.2,296.2,25,0.096,0.021,0,277; 440100,
            372.7,364.1,359.2,295.2,25.667,0.158,0.023,0.001,277; 441000,374.3,
            363.9,359.2,295.2,27.667,0.091,0.021,0.001,276.8; 441900,374.4,
            364.7,359.2,295.2,26,0.085,0.021,0,276.7; 442800,372.9,364.7,360.2,
            295.2,27.5,0.085,0.025,0,276.7; 443700,371.4,365,361.2,294.2,28,
            0.086,0.021,0,276.7; 444600,375,366,361.2,294.2,26.167,0.154,0.023,
            0.001,276.9; 445500,374.3,364,361.2,294.2,25.667,0.092,0.022,0.001,
            276.7; 446400,372.8,364.2,360.2,294.2,26,0.087,0.024,0.001,276.7;
            447300,374.6,364.3,360.2,293.2,28.833,0.088,0.024,0.001,276.3;
            448200,375.4,364.3,361.2,293.2,28,0.088,0.023,0.001,275.9; 449100,
            374.7,365,360.2,293.2,27.667,0.159,0.024,0.001,275.6; 450000,372.1,
            364.5,360.2,293.2,27.833,0.091,0.023,0.001,275.4; 450900,371.5,
            363.4,362.2,293.2,31,0.092,0.058,0.006,275.2; 451800,373.2,362.5,
            365.2,293.2,31.333,0.088,0.047,0.006,275.2; 452700,371.5,364.7,
            365.2,364.2,29.833,0.156,0.047,0.021,274.9; 453600,370.8,364.7,
            365.2,364.2,26.5,0.156,0.053,0.023,274.6; 454500,371.7,365.4,368.2,
            363.2,29,0.099,0.107,0.05,274.3; 455400,372.2,365.9,367.2,367.2,
            29.167,0.085,0.062,0.043,274.3; 456300,372,365.1,365.2,365.2,29.5,
            0.083,0.048,0.029,274.2; 457200,370.4,364.1,365.2,365.2,28,0.155,
            0.048,0.029,274.2; 458100,371.2,365.1,365.2,367.2,25.667,0.087,
            0.048,0.044,274.1; 459000,372.3,365.1,364.2,365.2,30,0.087,0.044,
            0.034,273.8; 459900,371.6,363.5,363.2,365.2,31.333,0.092,0.051,
            0.034,273.6; 460800,371.5,363.1,364.2,367.2,30,0.086,0.047,0.048,
            273.6; 461700,372.4,365.4,365.2,366.2,29.167,0.086,0.047,0.048,
            273.3; 462600,371,363.9,363.2,366.2,29,0.086,0.047,0.048,273.3;
            463500,371.3,362.7,363.2,366.2,27.667,0.152,0.048,0.033,273.2;
            464400,371.7,363.3,364.2,365.2,29.833,0.088,0.043,0.033,273.2;
            465300,372.6,363.1,364.2,365.2,29.833,0.09,0.043,0.046,273.2;
            466200,371.8,364.4,364.2,365.2,29.833,0.089,0.047,0.039,272.8;
            467100,371.9,364.1,364.2,365.2,31.333,0.089,0.044,0.035,272.7;
            468000,370.6,363.9,364.2,365.2,30.5,0.149,0.045,0.035,272.7; 468900,
            370.8,363.2,364.2,365.2,30.333,0.093,0.037,0.033,272.7; 469800,
            371.1,363,363.2,365.2,28.833,0.084,0.043,0.033,272.8; 470700,372.1,
            364.6,363.2,366.2,27.667,0.089,0.043,0.032,272.3; 471600,370.6,
            364.1,363.2,366.2,30.167,0.091,0.041,0.034,272.3; 472500,371.3,
            363.2,363.2,364.2,28.667,0.091,0.041,0.034,272.1; 473400,371.8,
            363.2,363.2,364.2,27.167,0.091,0.041,0.034,272.1; 474300,372.4,
            362.7,363.2,364.2,26.833,0.161,0.041,0.049,272.3; 475200,372.6,
            363.6,362.2,364.2,27.167,0.091,0.041,0.049,272.3; 476100,373.3,
            363.8,363.2,364.2,31.833,0.089,0.037,0.03,272.3; 477000,372.6,363.5,
            363.2,363.2,32.5,0.089,0.037,0.03,272.6; 477900,373.6,362.7,362.2,
            363.2,31,0.091,0.037,0.03,272.5; 478800,374.3,362.5,361.2,363.2,
            27.5,0.168,0.036,0.028,272.5; 479700,371.3,362.6,361.2,361.2,29.167,
            0.092,0.036,0.036,272.5; 480600,371.2,364.5,362.2,361.2,29.333,
            0.086,0.034,0.033,272.5; 481500,371,363.8,362.2,363.2,29.5,0.095,
            0.033,0.024,272.5; 482400,370.9,363.6,363.2,365.2,27.833,0.089,
            0.033,0.024,272.4; 483300,371,363.9,363.2,360.2,27.167,0.094,0.033,
            0.013,272.2; 484200,372,363.5,363.2,364.2,28.833,0.15,0.034,0.013,
            272.3; 485100,372,364.9,363.2,364.2,27.333,0.087,0.036,0.029,272.3;
            486000,372.5,364.6,363.2,363.2,30,0.087,0.034,0.014,272.3; 486900,
            372.1,362.4,363.2,362.2,29.5,0.083,0.034,0.023,272.2; 487800,371.7,
            362.5,361.2,362.2,27.833,0.087,0.031,0.029,272.3; 488700,372.6,
            362.2,362.2,362.2,26.5,0.161,0.033,0.029,272.3; 489600,372.3,362.1,
            361.2,360.2,27.5,0.087,0.033,0.014,272.5; 490500,371.3,364,362.2,
            360.2,27.333,0.093,0.033,0.034,272.5; 491400,370.4,363.5,362.2,
            364.2,28.167,0.088,0.031,0.034,272.5; 492300,370.9,363,365.2,362.2,
            25.333,0.091,0.039,0.016,272.6; 493200,370,363.3,364.2,362.2,24.333,
            0.097,0.033,0.011,272.8; 494100,370.6,363,363.2,362.2,27.167,0.116,
            0.037,0.011,272.9; 495000,370.6,364.3,363.2,364.2,28.5,0.091,0.037,
            0.031,273; 495900,369.4,364.3,363.2,364.2,28.167,0.088,0.053,0.019,
            273; 496800,370.4,362.5,363.2,361.2,27.833,0.084,0.037,0.019,273;
            497700,370.6,362.9,362.2,361.2,21.667,0.087,0.037,0.043,273; 498600,
            371,362.1,362.2,348.2,22.667,0.16,0.038,0.02,273.1; 499500,370.1,
            363.1,362.2,348.2,21.833,0.091,0.038,0.02,273.2; 500400,370.6,362.8,
            362.2,339.2,20,0.089,0.038,0.013,273.2; 501300,370.1,362.4,362.2,
            339.2,23.667,0.087,0.038,0.018,273.2; 502200,370.8,361.8,362.2,
            332.2,24.167,0.091,0.041,0,273.2; 503100,371.2,361.6,362.2,326.2,
            24.667,0.166,0.038,0,273.3; 504000,370.9,363,362.2,321.2,20.333,
            0.099,0.042,0,273.4; 504900,370.2,363.2,358.2,317.2,22.333,0.093,
            0.039,0,273.5; 505800,370.7,361.8,355.2,317.2,21.833,0.093,0.039,
            0.001,273.5; 506700,370.4,361.9,358.2,317.2,19.5,0.091,0.041,0,
            273.6; 507600,369.9,361.7,358.2,314.2,21.5,0.17,0.039,0,273.7;
            508500,370.7,362.7,356.2,311.2,21.167,0.103,0.001,0,273.7; 509400,
            370.6,362.9,356.2,309.2,20.5,0.092,0.012,0,273.9; 510300,370,362.1,
            357.2,307.2,22.333,0.091,0.021,0,273.9; 511200,370.6,361.8,357.2,
            305.2,22.5,0.092,0.021,0,273.9; 512100,371.6,361.5,357.2,305.2,23,
            0.168,0.019,0.001,274.1; 513000,373.6,362.5,357.2,304.2,20.167,
            0.091,0.021,0.001,274.3; 513900,372.9,362.7,357.2,304.2,19.333,
            0.089,0.019,0,274.6; 514800,373.2,361.8,357.2,302.2,19.167,0.093,
            0.021,0,274.8; 515700,374.4,361.7,357.2,301.2,21.833,0.095,0.019,0,
            274.8; 516600,375.3,361.3,358.2,300.2,22.167,0.166,0.019,0,274.8;
            517500,375,362.2,358.2,300.2,21.667,0.096,0.022,0,274.7; 518400,
            375.2,362.4,358.2,299.2,19.667,0.094,0.021,0.001,274.8; 519300,
            375.5,362.1,358.2,298.2,18.833,0.095,0.023,0,274.8; 520200,375.9,
            362.9,358.2,298.2,21.667,0.092,0.022,0.001,274.7; 521100,372.7,
            363.5,359.2,298.2,21.5,0.165,0.023,0.001,274.5; 522000,373.6,363.7,
            360.2,297.2,20.167,0.09,0.023,0,274.5; 522900,373.1,364.8,359.2,
            297.2,18.5,0.094,0.022,0.001,274.5; 523800,375,364.5,359.2,297.2,
            19.167,0.091,0.024,0.001,274.6; 524700,374.7,365.2,360.2,296.2,
            18.667,0.091,0.022,0,274.7; 525600,374.9,364.4,361.2,296.2,19.333,
            0.162,0.023,0,274.9; 526500,375,365.4,361.2,296.2,19.333,0.084,
            0.023,0,274.8; 527400,373.9,366,361.2,295.2,19.167,0.088,0.023,0,
            274.8; 528300,372.3,364.8,361.2,295.2,18.5,0.085,0.024,0,275;
            529200,374,363.5,361.2,295.2,19.5,0.088,0.021,0.001,274.8; 530100,
            373.1,363.3,361.2,294.2,20.333,0.151,0.024,0.001,275.1; 531000,
            375.7,364.2,360.2,294.2,19.333,0.078,0.021,0.001,274.7; 531900,
            375.6,365,360.2,294.2,20.833,0.082,0.024,0.001,274.7; 532800,374.6,
            364.5,361.2,294.2,21.333,0.093,0.024,0.001,274.7; 533700,371.4,
            364.6,361.2,293.2,19,0.091,0.024,0,274.7; 534600,372.7,364.4,361.2,
            293.2,20,0.155,0.023,0,274.5; 535500,371.9,364.5,361.2,293.2,20.167,
            0.082,0.024,0.001,274.2; 536400,373.7,364.4,361.2,293.2,22,0.089,
            0.024,0.001,274.1; 537300,371.7,363.7,363.2,291.2,20.833,0.09,0.024,
            0.001,273.9; 538200,373.2,364.1,366.2,365.2,20.833,0.086,0.024,
            0.001,273.7; 539100,371.5,364.9,366.2,365.2,20.833,0.156,0.024,
            0.001,273.7; 540000,371.8,365.4,364.2,365.2,19.167,0.096,0.025,0,
            273.9; 540900,372,364.5,364.2,362.2,18.333,0.096,0.083,0.068,273.9;
            541800,369.7,363.6,365.2,364.2,20.167,0.095,0.053,0.024,273.7;
            542700,370.5,364.6,365.2,365.2,21.333,0.086,0.046,0.024,274; 543600,
            368.8,364,365.2,365.2,20,0.16,0.049,0.024,273.9; 544500,367.5,365,
            364.2,365.2,18,0.1,0.049,0.022,273.9; 545400,367.1,364.5,364.2,
            365.2,19,0.097,0.001,0.052,274; 546300,368.2,362.8,364.2,364.2,
            21.667,0.095,0.05,0.03,274; 547200,365.2,363.2,364.2,364.2,22.167,
            0.089,0.043,0.033,274; 548100,366.1,362.1,363.2,363.2,21.5,0.151,
            0.051,0.03,273.9; 549000,368.4,362.3,362.2,363.2,20.667,0.087,0.043,
            0.03,274; 549900,369.5,361.4,362.2,363.2,19.833,0.091,0.043,0.04,
            274; 550800,367.1,360.3,362.2,363.2,20.667,0.088,0.049,0.04,274;
            551700,369.8,360,361.2,363.2,20,0.09,0.047,0.044,274.1; 552600,
            369.3,360.4,358.2,363.2,21.5,0.103,0.046,0.044,274; 553500,371.4,
            358.1,358.2,362.2,18.5,0.174,0.046,0.063,274; 554400,372.6,360.2,
            360.2,363.2,19.5,0.094,0.046,0.063,273.9; 555300,371.8,362.3,362.2,
            363.2,19.5,0.096,0.043,0.053,273.9; 556200,371.2,361.8,361.2,362.2,
            20.833,0.096,0.048,0.053,273.9; 557100,372.2,360.2,360.2,361.2,20.5,
            0.103,0.048,0.042,274; 558000,370.4,360.2,361.2,361.2,21.667,0.181,
            0.04,0.049,274; 558900,370,360.2,361.2,361.2,19.667,0.127,0.04,
            0.047,274.3; 559800,371.8,363.3,362.2,365.2,18.833,0.091,0.04,0.035,
            274.1; 560700,373.2,363.3,362.2,365.2,20,0.094,0.04,0.036,274.1;
            561600,371.7,363.3,363.2,363.2,20,0.094,0.038,0.036,274.1; 562500,
            373.1,362.9,363.2,364.2,21,0.094,0.038,0.036,274; 563400,371.6,
            362.9,363.2,362.2,25,0.167,0.036,0.036,274; 564300,371.7,363.2,
            362.2,359.2,24.167,0.096,0.036,0.036,274; 565200,372.1,362.8,361.2,
            359.2,21.167,0.096,0.039,0.016,273.9; 566100,371.9,361.8,361.2,
            359.2,21.167,0.089,0.036,0.028,273.9; 567000,372.4,363.3,361.2,
            363.2,21.333,0.092,0.039,0.012,274; 567900,373.4,363.7,363.2,363.2,
            21.333,0.087,0.037,0.027,273.9; 568800,372.9,363.3,362.2,363.2,
            21.333,0.09,0.038,0.027,273.9; 569700,372.5,363.9,363.2,363.2,
            21.833,0.092,0.033,0.027,273.8; 570600,372.3,363.4,362.2,361.2,
            21.667,0.086,0.033,0.027,273.9; 571500,372.9,363,362.2,361.2,22,
            0.091,0.035,0.018,273.9; 572400,372.7,363,362.2,361.2,24.667,0.087,
            0.034,0.032,273.7; 573300,372,362.9,362.2,363.2,25.167,0.156,0.032,
            0.019,273.6; 574200,371.7,362.8,362.2,361.2,25.5,0.087,0.034,0.014,
            273.7; 575100,372.1,365.2,363.2,362.2,23.833,0.09,0.034,0.014,273.7;
            576000,372.1,363.7,363.2,361.2,25.833,0.09,0.029,0.014,273.5;
            576900,372.3,363.4,362.2,361.2,26.333,0.088,0.035,0.016,273.5;
            577800,371.5,363.4,362.2,362.2,26.5,0.087,0.031,0.011,273.6; 578700,
            370.7,363.4,363.2,362.2,25.833,0.12,0.036,0.04,273.6; 579600,370.6,
            363.7,363.2,366.2,31.167,0.088,0.034,0.012,273.7; 580500,369,364.1,
            363.2,362.2,30.833,0.09,0.038,0.012,273.7; 581400,367.7,363.2,363.2,
            363.2,25.333,0.089,0.038,0.015,273.8; 582300,370.5,363.1,363.2,
            363.2,25,0.089,0.032,0.015,273.8; 583200,369.9,363.6,363.2,364.2,
            26.167,0.124,0.001,0.015,273.8; 584100,367.1,363.6,363.2,364.2,
            29.167,0.103,0.034,0.038,273.8; 585000,369.7,364,362.2,356.2,32.167,
            0.088,0.037,0.013,273.8; 585900,370.6,362.2,362.2,347.2,30,0.089,
            0.036,0.013,273.9; 586800,367.4,362,361.2,338.2,28,0.085,0.036,
            0.024,273.8; 587700,368.8,360.7,360.2,338.2,30,0.085,0.039,0.024,
            273.8; 588600,369,362.3,360.2,331.2,31,0.16,0.037,0.001,273.8;
            589500,365.9,362.3,361.2,325.2,27.833,0.092,0.039,0,273.8; 590400,
            367.5,361.8,361.2,321.2,29.5,0.09,0.038,0.001,273.8; 591300,367.8,
            359.8,355.2,321.2,27.333,0.096,0.039,0.001,273.8; 592200,368,360.8,
            355.2,317.2,26.5,0.163,0.039,0.001,273.9; 593100,365.2,362.1,357.2,
            317.2,27.5,0.163,0.04,0,273.9; 594000,366.5,360.7,357.2,314.2,28,
            0.093,0.039,0.001,274; 594900,366.2,360.7,356.2,311.2,31.667,0.098,
            0.002,0.001,274; 595800,367.4,360.6,356.2,308.2,32.5,0.097,0.016,0,
            274; 596700,364.8,359.9,356.2,306.2,29.167,0.175,0.02,0,273.9;
            597600,369.5,358.4,355.2,305.2,29.167,0.111,0.02,0,274; 598500,
            371.8,360.7,355.2,305.2,30,0.111,0.02,0,273.9; 599400,371.1,359.2,
            355.2,305.2,30.5,0.098,0.021,0.001,274.1; 600300,370.9,359.2,356.2,
            303.2,33.667,0.096,0.021,0.001,274.2; 601200,371.7,358,355.2,302.2,
            37.167,0.125,0.022,0,274.2; 602100,371.6,358.2,355.2,301.2,33.333,
            0.172,0.026,0,274.2; 603000,373,360,355.2,300.2,30.5,0.095,0.026,0,
            274.2; 603900,373,358.5,355.2,300.2,30.833,0.095,0.024,0,274.2]);
         annotation (Documentation(revisions="<html>
<ul>
<li>
December 18, 2015 by Daniele Basciotti:<br/>
First implementation.
</li>
</ul>
</html>",     info="<html>
<p><b><span style=\"color: #008000;\">Overview</span></b> </p>
<p>This record contains data of a real disitrict heating network for week-long period (23-29 Januar 2009) monitored by the Austrian Institut for Technology.</p>
<p> Pipes are layed underground 

<p><b><span style=\"color: #008000;\">Data structure</span></b> </p>
<p>Column 1: Time in s </p>
<p>Column 2: Temperature in point 1 in K</p>
<p>Column 3: Temperature in point 2 in K</p>
<p>Column 4: Temperature in point 3 in K</p>
<p>Column 5: Temperature in point 4 in K</p>
<p>Column 6: Mass flow rate in point 1 in kg/s</p>
<p>Column 7: Mass flow rate in point 2 in kg/s</p>
<p>Column 8: Mass flow rate in point 3 in kg/s</p>
<p>Column 9: Mass flow rate in point 4 in kg/s</p>
<p>Column 10: Outdoor temperature in K</p>

<p><b><span style=\"color: #008000;\">Test procedure</span></b> </p>
Information at several points of the district heating network is recorded during a week.
 
<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://IBPSA/Resources/Images/Experimental/AITTestBench.png\", border=\"1\"/>
</p>

<p>
Notice that length are approximated
</p>

<p><b><span style=\"color: #008000;\">Pipe characteristics</span></b> </p>
<ul>
<li>Inner diameter: 0.0825 m (DN080)</li>
<li>Outer diameter: 0.0889 m (stell wall thickness 3.2 mm)</li>
<li>Casing diameter: 0.18 m </li>
<li>Insulation material: Polyurethane </li>
<li>Heat conductivity of insulation material: 0.024 W/mK (average value at 50 °C) </li>
<li>Length specific pipe's heat loss coefficient: 0.208 W/mK </li>
<li>Wall roughness coefficient: 0.1 mm </li>
</ul>

</html>"));
    end PipeDataAIT151218;

    record FlowRateGeneric
      "Mass flow rate for example building's demand based on building simulation using TEASER and AixLib"
       extends
        IBPSA.Fluid.PlugFlowPipes.Data.BaseClasses.PipeDataBaseDefinition(
          final n=1, data=[0,0.445; 3600,0.478; 7200,0.482; 10800,0.465; 14400,
            0.458; 18000,0.464; 21600,0.45; 25200,0.371; 28800,0.344; 32400,
            0.306; 36000,0.292; 39600,0.287; 43200,0.296; 46800,0.315; 50400,
            0.292; 54000,0.268; 57600,0.274; 61200,0.315; 64800,0.383; 68400,
            0.451; 72000,0.46; 75600,0.47; 79200,0.518; 82800,0.52; 86400,0.538;
            90000,0.566; 93600,0.564; 97200,0.569; 100800,0.563; 104400,0.578;
            108000,0.574; 111600,0.483; 115200,0.444; 118800,0.386; 122400,
            0.358; 126000,0.345; 129600,0.356; 133200,0.365; 136800,0.305;
            140400,0.262; 144000,0.316; 147600,0.366; 151200,0.412; 154800,0.47;
            158400,0.459; 162000,0.462; 165600,0.485; 169200,0.473; 172800,
            0.465; 176400,0.479; 180000,0.456; 183600,0.461; 187200,0.455;
            190800,0.45; 194400,0.453; 198000,0.386; 201600,0.35; 205200,0.315;
            208800,0.311; 212400,0.302; 216000,0.316; 219600,0.343; 223200,
            0.316; 226800,0.291; 230400,0.291; 234000,0.319; 237600,0.346;
            241200,0.392; 244800,0.397; 248400,0.401; 252000,0.428; 255600,
            0.441; 259200,0.443; 262800,0.455; 266400,0.452; 270000,0.457;
            273600,0.458; 277200,0.456; 280800,0.454; 284400,0.382; 288000,
            0.355; 291600,0.329; 295200,0.316; 298800,0.281; 302400,0.304;
            306000,0.321; 309600,0.295; 313200,0.274; 316800,0.288; 320400,
            0.337; 324000,0.376; 327600,0.43; 331200,0.432; 334800,0.435;
            338400,0.465; 342000,0.464; 345600,0.463; 349200,0.467; 352800,0.47;
            356400,0.475; 360000,0.478; 363600,0.479; 367200,0.479; 370800,
            0.404; 374400,0.371; 378000,0.338; 381600,0.336; 385200,0.329;
            388800,0.35; 392400,0.371; 396000,0.339; 399600,0.313; 403200,0.323;
            406800,0.352; 410400,0.379; 414000,0.431; 417600,0.44; 421200,0.439;
            424800,0.467; 428400,0.483; 432000,0.476; 435600,0.482; 439200,
            0.485; 442800,0.492; 446400,0.515; 450000,0.531; 453600,0.538;
            457200,0.441; 460800,0.396; 464400,0.355; 468000,0.342; 471600,
            0.331; 475200,0.34; 478800,0.348; 482400,0.329; 486000,0.303;
            489600,0.303; 493200,0.332; 496800,0.358; 500400,0.414; 504000,
            0.414; 507600,0.42; 511200,0.479; 514800,0.471; 518400,0.474;
            522000,0.477; 525600,0.469; 529200,0.469; 532800,0.466; 536400,
            0.461; 540000,0.462; 543600,0.393; 547200,0.368; 550800,0.334;
            554400,0.326; 558000,0.293; 561600,0.296; 565200,0.279; 568800,
            0.243; 572400,0.218; 576000,0.259; 579600,0.292; 583200,0.32;
            586800,0.377; 590400,0.372; 594000,0.38; 597600,0.405; 601200,0.422]);
      annotation (Documentation(info="<html>
<p>This file contains 1 week of hourly mass flow rates for a building substation. </p>
<p>The values were calculated based on a large residential building simulated with TEASER and AixLib. Based on the simulated heat demand, the mass flow rate was calculated assuming a network supply temperature of 60 degC and a return temperature of 40 degC.</p>
</html>",     revisions="<html>
<ul>
<li>
December 8, 2016 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"));
    end FlowRateGeneric;
  end Data;

  package Types "Contains supporting types for pipes"
  extends Modelica.Icons.Package;
    type ThermalResistanceLength = Real (final quantity="ThermalResistanceLength", final unit=
               "(m.K)/W") annotation (Documentation(info="<html>
<p>Unit for thermal capacity per length of pipe [J/Km].</p>
</html>"));
    type ThermalCapacityPerLength =Real (final quantity="ThermalCapacityPerLength", final unit=
               "J/(K.m)") annotation (Documentation(info="<html>
<p>Unit for thermal resistance per length of pipe [Km/W].</p>
</html>"));
  end Types;
end PlugFlowPipes;
