within IBPSA.Experimental.Pipe.Examples.UseCases;
package Components
  "Wrappers for supply, pipe and demand elements in Aachen Use Case"

  model SupplySource "A simple supply model with source"

    replaceable package Medium =
        Modelica.Media.Interfaces.PartialMedium "Medium in the component"
        annotation (choicesAllMatching = true);

    parameter Modelica.SIunits.Pressure p_supply
      "Supply pressure for the network";

    IBPSA.Fluid.Sources.Boundary_pT source(          redeclare package Medium =
          Medium,
      p=p_supply,
      use_T_in=true,
      nPorts=1) "Flow source with fixed supply pressure for the network"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=270,
          origin={6,30})));
    IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
          Medium)
      annotation (Placement(transformation(extent={{64,-10},{84,10}})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort T_supply(redeclare package Medium =
          Medium, m_flow_nominal=1,
      T_start=333.15) "Supply flow temperature"
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
          Medium) "Supply port for the network (named port_b for consistency)"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 60)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
    Modelica.Blocks.Sources.Step step(height=10, startTime=7200)
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  equation

    connect(senMasFlo.port_a, T_supply.port_b)
      annotation (Line(points={{64,0},{52,0},{40,0}}, color={0,127,255}));
    connect(source.ports[1], T_supply.port_a)
      annotation (Line(points={{6,20},{6,0},{20,0}}, color={0,127,255}));
    connect(senMasFlo.port_b, port_b)
      annotation (Line(points={{84,0},{100,0}}, color={0,127,255}));
    connect(const.y, add.u1) annotation (Line(points={{-59,70},{-50,70},{-50,56},
            {-42,56}}, color={0,0,127}));
    connect(step.y, add.u2) annotation (Line(points={{-59,30},{-52,30},{-52,44},
            {-42,44}}, color={0,0,127}));
    connect(add.y, source.T_in) annotation (Line(points={{-19,50},{-4,50},{10,
            50},{10,42}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid), Polygon(
            points={{-80,80},{-80,-80},{76,0},{-80,80}},
            lineColor={28,108,200},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid)}),                      Diagram(
          coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>December 12, 2016 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"));
  end SupplySource;

  model PipeA60 "Wrapper around A60 pipe model"
    extends IBPSA.Fluid.Interfaces.PartialTwoPort;

    replaceable package Medium =
        Modelica.Media.Interfaces.PartialMedium "Medium in the component"
        annotation (choicesAllMatching = true);

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
      "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

    parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
      m_flow_nominal) "Small mass flow rate for regularization of zero flow"
      annotation (Dialog(tab="Advanced"));

    parameter Modelica.SIunits.Height roughness=2.5e-5
      "Average height of surface asperities (default: smooth steel pipe)"
      annotation (Dialog(group="Geometry"));

    parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=
      dpStraightPipe_nominal "Pressure drop at nominal mass flow rate"
      annotation (Dialog(group="Nominal condition"));

    final parameter Modelica.SIunits.Pressure dpStraightPipe_nominal=
        Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
        m_flow=m_flow_nominal,
        rho_a=rho_default,
        rho_b=rho_default,
        mu_a=mu_default,
        mu_b=mu_default,
        length=length,
        diameter=diameter,
        roughness=roughness,
        m_flow_small=m_flow_small)
      "Pressure loss of a straight pipe at m_flow_nominal";

    parameter Modelica.SIunits.Length length "Length of the pipe";

    parameter Modelica.SIunits.Diameter diameter "Diameter of the pipe";

    parameter Modelica.SIunits.Length thicknessIns
      "Thickness of pipe insulation";

    parameter Modelica.SIunits.ThermalConductivity lambdaIns
      "Thermal conductivity of pipe insulation";

    parameter Modelica.SIunits.Temperature T_amb = 283.15
      "Ambient temperature around pipe";

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
      annotation (Dialog(group="Advanced", enable=use_rho_nominal));

    parameter Modelica.SIunits.DynamicViscosity mu_default=
        Medium.dynamicViscosity(Medium.setState_pTX(
        p=Medium.p_default,
        T=Medium.T_default,
        X=Medium.X_default))
      "Default dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
      annotation (Dialog(group="Advanced", enable=use_mu_default));

  public
    IBPSA.Fluid.Sensors.TemperatureTwoPort senTem_a(redeclare package Medium =
          Medium, m_flow_nominal=m_flow_nominal,
      T_start=333.15) "Temperature at pipe's port a"
      annotation (Placement(transformation(extent={{-86,-10},{-66,10}})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort senTem_b(redeclare package Medium =
          Medium, m_flow_nominal=m_flow_nominal,
      T_start=333.15) "Temperature at pipe's port b"
      annotation (Placement(transformation(extent={{68,-10},{88,10}})));
    IBPSA.Experimental.Pipe.PipeHeatLossMod pipe(
      redeclare package Medium = Medium,
      diameter=diameter,
      length=length,
      thicknessIns=thicknessIns,
      m_flow_nominal=m_flow_nominal,
      m_flow_small=m_flow_small,
      roughness=roughness,
      lambdaI=lambdaIns,
      from_dp=true,
      dp_nominal=dpStraightPipe_nominal)
      "Pipe model for district heating connection"
      annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15)
      annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  equation

    connect(port_a, senTem_a.port_a)
      annotation (Line(points={{-100,0},{-94,0},{-86,0}}, color={0,127,255}));
    connect(port_b, senTem_b.port_b)
      annotation (Line(points={{100,0},{94,0},{88,0}}, color={0,127,255}));
  connect(senTem_a.port_b, pipe.port_a)
    annotation (Line(points={{-66,0},{-40,0},{-12,0}}, color={0,127,255}));
  connect(senTem_b.port_a, pipe.port_b)
    annotation (Line(points={{68,0},{38,0},{8,0}}, color={0,127,255}));
  connect(fixedTemperature.port, pipe.heatPort)
    annotation (Line(points={{-20,50},{-2,50},{-2,10}}, color={191,0,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}), graphics={Rectangle(
            extent={{-90,24},{90,-26}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>December 12, 2016 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"));
  end PipeA60;

  model DemandSink "Simple demand model"

    replaceable package Medium =
        Modelica.Media.Interfaces.PartialMedium "Medium in the component"
        annotation (choicesAllMatching = true);

    parameter Boolean useTempDesign = true
      "Use static dT for true, dynamic dT for false";

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
      "Nominal mass flow rate, used for regularization near zero flow"
      annotation(Dialog(group = "Nominal condition"));

    IBPSA.Fluid.Sources.MassFlowSource_T sink(
      redeclare package Medium = Medium,
      use_m_flow_in=true,
      nPorts=1) "Flow demand of the substation" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-18,20})));
    Modelica.Blocks.Sources.CombiTimeTable InputTable(
      tableName="Demand",
      tableOnFile=false,
      table=flowRateGeneric.data) "Table input for prescribed flow"
                                                      annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={50,90})));
    Modelica.Blocks.Math.Gain gain(k=-1)
      "Switch to negative m_flow value for inflow" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-10,62})));
    IBPSA.Fluid.Sensors.TemperatureTwoPort senT_supply(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      tau=1,
      T_start=333.15) "Incoming supply temperature from DH network"
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
          Medium)
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
    IBPSA.Experimental.Pipe.Data.FlowRateGeneric flowRateGeneric
      annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  equation

    connect(gain.y, sink.m_flow_in)
      annotation (Line(points={{-10,51},{-10,30}}, color={0,0,127}));
    connect(senT_supply.port_a, port_a)
      annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
    connect(senT_supply.port_b, sink.ports[1])
      annotation (Line(points={{-60,0},{-18,0},{-18,10}}, color={0,127,255}));
    connect(InputTable.y[1], gain.u)
      annotation (Line(points={{39,90},{-10,90},{-10,74}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}})),
      Documentation(info="<html>
<p>The simplest demand model for hydraulic calculations (no thermal modeling included).</p>
<p>Uses only a mass flow source as ideal sink. Specify a negative mass flow rate <code>m_flow &lt; 0</code> to prescribe a flow into the demand sink.</p>
</html>", revisions="<html>
<ul>
<li>December 12, 2016 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"),
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={Rectangle(
            extent={{-90,92},{90,-92}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid), Polygon(
            points={{-60,80},{-60,-78},{82,0},{-60,80}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid)}));
  end DemandSink;
  annotation ();
end Components;
