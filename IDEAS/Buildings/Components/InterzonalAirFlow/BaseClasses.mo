within IDEAS.Buildings.Components.InterzonalAirFlow;
package BaseClasses "Base classes"
  extends Modelica.Icons.BasesPackage;
  partial model PartialInterzonalAirFlow "Partial for interzonal air flow"
    replaceable package Medium = IDEAS.Media.Air "Air medium";
    parameter Integer nPorts "Number of ports for connection to zone air volume";
    parameter Modelica.SIunits.Volume V "Zone air volume for n50 computation";
    parameter Real n50 = sim.n50 "n50 value";
    parameter Real n50toAch = 20
      "Conversion fractor from n50 to Air Change Rate"
      annotation(Dialog(tab="Advanced"));
    Modelica.Fluid.Interfaces.FluidPort_b port_b_interior(
      redeclare package Medium = Medium)
      "Port a connection to zone air model ports"
      annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a_interior(
      redeclare package Medium = Medium)
      "Port b connection to zone air model ports"
      annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a_exterior(
      redeclare package Medium = Medium)
      "Port a connection to model exterior ports"
      annotation (Placement(transformation(extent={{10,90},{30,110}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b_exterior(
      redeclare package Medium = Medium)
      "Port b connection to model exterior ports"
      annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
    Modelica.Fluid.Interfaces.FluidPorts_a[nPorts] ports(
      redeclare each package Medium = Medium) "Ports connector for multiple ports" annotation (Placement(
          transformation(
          extent={{-10,40},{10,-40}},
          rotation=90,
          origin={2,-100})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialInterzonalAirFlow;

  partial model PartialInterzonalAirFlowBoundary
    "Partial interzonal air flow model that includes a boundary"
    extends
      IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses.PartialInterzonalAirFlow;
    outer BoundaryConditions.SimInfoManager       sim
      "Simulation information manager"
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow_sim if
                                                                                    sim.computeConservationOfEnergy
      annotation (Placement(transformation(extent={{-60,60},{-80,80}})));
    Modelica.Blocks.Sources.RealExpression Qgai(y=actualStream(bou.ports.h_outflow)
          *bou.ports.m_flow)
      annotation (Placement(transformation(extent={{-100,42},{-40,62}})));
    Modelica.Blocks.Routing.RealPassThrough Te annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=270,
      origin={6,70})));
    Fluid.Sources.Boundary_pT bou(
      redeclare package Medium = Medium,
      use_T_in=true,
      use_p_in=false,
      use_C_in=Medium.nC == 1,
      use_X_in=Medium.nX == 2) annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={0,10})));
    Modelica.Blocks.Sources.RealExpression reaExpX_air(y=1 - reaPasThr.y)
      annotation (Placement(transformation(extent={{58,42},{38,62}})));
    Modelica.Blocks.Routing.RealPassThrough reaPasThr annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={30,70})));
  protected
    Interfaces.WeaBus weaBus(numSolBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles)
      annotation (Placement(transformation(extent={{-50,82},{-30,102}})));
  equation
    connect(port_a_interior, port_b_exterior) annotation (Line(points={{-60,-100},
            {-60,0},{-20,0},{-20,100}}, color={0,127,255}));
    connect(port_a_exterior, port_b_interior) annotation (Line(points={{20,100},{20,
            0},{60,0},{60,-100}}, color={0,127,255}));
    connect(prescribedHeatFlow_sim.port,sim. Qgai)
      annotation (Line(points={{-80,70},{-90,70},{-90,80}}, color={191,0,0}));
    connect(Qgai.y,prescribedHeatFlow_sim. Q_flow) annotation (Line(points={{-37,52},
            {-37,70},{-60,70}},       color={0,0,127}));
    connect(sim.weaBus,weaBus)  annotation (Line(
        points={{-84,92.8},{-40,92.8},{-40,92}},
        color={255,204,51},
        thickness=0.5));
    connect(Te.u,weaBus. Te) annotation (Line(points={{6,82},{6,92.05},{-39.95,92.05}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(reaExpX_air.y, bou.X_in[2])
      annotation (Line(points={{37,52},{4,52},{4,22}}, color={0,0,127}));
    connect(bou.C_in[1], weaBus.CEnv) annotation (Line(points={{8,22},{8,92.05},
            {-39.95,92.05}},                            color={0,0,127}));
    connect(reaPasThr.u,weaBus. X_wEnv)
      annotation (Line(points={{30,82},{30,92.05},{-39.95,92.05}},
                                                          color={0,0,127}));
    connect(reaPasThr.y, bou.X_in[1]) annotation (Line(points={{30,59},{14,59},
            {14,22},{4,22}},
                         color={0,0,127}));
    connect(Te.y, bou.T_in)
      annotation (Line(points={{6,59},{6,22},{-4,22}}, color={0,0,127}));
  end PartialInterzonalAirFlowBoundary;

  partial model PartialInterzonalAirFlown50
    "Model representing idealised n50 air leakage"
    extends IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses.PartialInterzonalAirFlowBoundary(nPorts=2, bou(nPorts=2));

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal_airLea=
      V*rho_default/3600*n50/n50toAch
      "Nominal mass flow of air leakage"
      annotation(Dialog(tab="Advanced"));

    Modelica.Blocks.Sources.RealExpression reaExpMflo(y=m_flow_nominal_airLea)
      annotation (Placement(transformation(extent={{-52,-54},{-30,-34}})));
    Fluid.Interfaces.IdealSource airInfiltration(
      redeclare package Medium = Medium,
      control_m_flow=true,
      allowFlowReversal=false,
      control_dp=false) "Fixed air infiltration rate" annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-10,-50})));

  protected
    final parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
        T=Medium.T_default,
        p=Medium.p_default,
        X=Medium.X_default[1:Medium.nXi]) "Medium state at default values";
    final parameter Modelica.SIunits.Density rho_default = Medium.density(
      state=state_default) "Medium default density";

  equation
    connect(reaExpMflo.y, airInfiltration.m_flow_in) annotation (Line(points={{-28.9,
            -44},{-18,-44}},                 color={0,0,127}));
    connect(airInfiltration.port_a, bou.ports[1]) annotation (Line(points={{-10,-40},
            {-10,0},{-2,0}},                                          color={0,127,
            255}));
    connect(airInfiltration.port_b, ports[1]) annotation (Line(points={{-10,-60},{
            -10,-100},{-18,-100}},          color={0,127,255}));
  end PartialInterzonalAirFlown50;
end BaseClasses;
