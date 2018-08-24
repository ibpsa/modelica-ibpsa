within IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses;
partial model PartialInterzonalAirFlown50
  "Model representing idealised n50 air leakage"
  extends
    IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses.PartialInterzonalAirFlowBoundary(
      nPorts=2, bou(nPorts=2));

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
  annotation (Documentation(revisions="<html>
<ul>
<li>
April 27, 2018 by Filip Jorissen:<br/>
First version.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/796\">#796</a>.
</li>
</ul>
</html>"), Icon(graphics={Text(
          extent={{18,-38},{66,-60}},
          lineColor={28,108,200},
          textString="n50")}));
end PartialInterzonalAirFlown50;
