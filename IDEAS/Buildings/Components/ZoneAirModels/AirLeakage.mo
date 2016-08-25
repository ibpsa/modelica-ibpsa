within IDEAS.Buildings.Components.ZoneAirModels;
model AirLeakage "air leakage due to limied air tightness"

extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface(
    final allowFlowReversal=false,
    final m_flow_nominal=V*rho_default/3600*n50/n50toAch);

  parameter Modelica.SIunits.Volume V "zone air volume";
  parameter Real n50(min=0)=0.4 "n50-value of airtightness";
  parameter Real n50toAch = 20 "Conversion factor from n50 to Air Change Rate";

  outer IDEAS.BoundaryConditions.SimInfoManager sim
    "Simulation information manager"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Fluid.Interfaces.IdealSource idealSourceOut(
    redeclare package Medium = Medium,
    control_m_flow=true,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.RealExpression reaExpMflo(y=V*rho_default/3600*n50/n50toAch)
    annotation (Placement(transformation(extent={{-86,20},{-40,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow if  sim.computeConservationOfEnergy
    annotation (Placement(transformation(extent={{-60,50},{-80,70}})));
  Modelica.Blocks.Sources.RealExpression Qgai(y=-reaExpMflo.y*(inStream(port_a.h_outflow)
         - port_b.h_outflow)) if                                                       sim.computeConservationOfEnergy
    annotation (Placement(transformation(extent={{-100,34},{-22,54}})));
  Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2,
    use_p_in=false,
    use_X_in=Medium.nXi == 2,
    use_C_in=Medium.nC == 1)
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,30})));
  Fluid.Interfaces.IdealSource idealSourceIn(
    redeclare package Medium = Medium,
    control_m_flow=true,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
protected
  Interfaces.WeaBus weaBus(numSolBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles)
    annotation (Placement(transformation(extent={{-50,76},{-30,96}})));
public
  Modelica.Blocks.Sources.RealExpression reaExpX_air(y=1 - reaPasThr.y)
    annotation (Placement(transformation(extent={{-40,56},{-20,76}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThr annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={14,68})));
protected
  final parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Medium state at default values";
  // Density at medium default values, used to compute the size of control volumes
  final parameter Modelica.SIunits.Density rho_default=Medium.density(
    state=state_default) "Density, used to compute fluid mass";

equation
  connect(reaExpMflo.y, idealSourceOut.m_flow_in) annotation (Line(
      points={{-37.7,30},{-36,30},{-36,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a, idealSourceOut.port_a) annotation (Line(
      points={{-100,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, sim.Qgai)
    annotation (Line(points={{-80,60},{-90,60},{-90,80}}, color={191,0,0}));
  connect(Qgai.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-18.1,44},{-18.1,60},{-60,60}},
                                                 color={0,0,127}));
  connect(reaExpMflo.y, idealSourceIn.m_flow_in) annotation (Line(points={{-37.7,
          30},{-37.7,30},{44,30},{44,8}},
                                  color={0,0,127}));
  connect(idealSourceOut.port_b, bou.ports[1])
    annotation (Line(points={{-20,0},{8,0},{8,20}}, color={0,127,255}));
  connect(idealSourceIn.port_a, bou.ports[2])
    annotation (Line(points={{40,0},{12,0},{12,20}}, color={0,127,255}));
  connect(idealSourceIn.port_b, port_b)
    annotation (Line(points={{60,0},{80,0},{100,0}}, color={0,127,255}));
  connect(sim.weaBus, weaBus) annotation (Line(
      points={{-84,92.8},{-40,92.8},{-40,86}},
      color={255,204,51},
      thickness=0.5));
  connect(bou.T_in, weaBus.Te) annotation (Line(points={{6,42},{6,86.05},{-39.95,
          86.05}}, color={0,0,127}));

  connect(reaExpX_air.y, bou.X_in[2])
    annotation (Line(points={{-19,66},{14,66},{14,42}}, color={0,0,127}));
  if Medium.nC>0 then
  connect(bou.C_in[1], weaBus.CEnv)
    annotation (Line(points={{18,42},{18,86.05},{-39.95,86.05}},
                                                        color={0,0,127}));
  end if;
  connect(reaPasThr.u, weaBus.X_wEnv)
    annotation (Line(points={{14,80},{14,86.05},{-39.95,86.05}},
                                                        color={0,0,127}));
  connect(reaPasThr.y, bou.X_in[1]) annotation (Line(points={{14,57},{14,57},{14,
          52},{14,42}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Text(
          extent={{-60,60},{60,-60}},
          lineColor={0,128,255},
          textString="ACH")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
April 20, 2016, Filip Jorissen:<br/>
Added missing density factor.
</li>
<li>
January 29, 2016, Filip Jorissen:<br/>
Implementation now also uses the outdoor humidity and up to one trace substance concentration.
</li>
<li>
June 14, 2015, Filip Jorissen:<br/>
Adjusted implementation for computing conservation of energy.
</li>
</ul>
</html>"));
end AirLeakage;
