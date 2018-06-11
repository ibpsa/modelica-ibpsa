within IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses;
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
  Modelica.Blocks.Sources.RealExpression Qgai(y=-actualStream(bou.ports.h_outflow)
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
    use_Xi_in=Medium.nX == 2)
                             annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,10})));
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
  connect(reaPasThr.u,weaBus. X_wEnv)
    annotation (Line(points={{30,82},{30,92.05},{-39.95,92.05}},
                                                        color={0,0,127}));

  connect(Te.y, bou.T_in)
    annotation (Line(points={{6,59},{6,22},{-4,22}}, color={0,0,127}));
  if Medium.nX == 2 then
    connect(reaPasThr.y, bou.Xi_in[1])
      annotation (Line(points={{30,59},{14,59},{14,22},{4,22}},color={0,0,127}));
  end if;
  if Medium.nC == 1 then
    connect(bou.C_in[1], weaBus.CEnv) annotation (Line(points={{8,22},{8,92.05},
          {-39.95,92.05}},                            color={0,0,127}));
  end if;

  annotation (Documentation(revisions="<html>
<ul>
<li>
June 11, 2018 by Filip Jorissen:<br/>
Using <code>Xi_in</code> instead of <code>X_in</code> since this
requires fewer inputs and it avoids an input variable consistency check.
</li>
<li>
April 27, 2018 by Filip Jorissen:<br/>
First version.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/796\">#796</a>.
</li>
</ul>
</html>"));
end PartialInterzonalAirFlowBoundary;
