within IDEAS.Buildings.Components.ZoneAirModels;
model AirLeakage "air leakage due to limied air tightness"

extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface(
    final allowFlowReversal=false,
    final m_flow_nominal=m_flow_nominal_airLea);
extends IDEAS.Buildings.Components.ZoneAirModels.BaseClasses.PartialAirLeakage;
  Fluid.Interfaces.IdealSource idealSourceOut(
    redeclare package Medium = Medium,
    control_m_flow=true,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2,
    use_p_in=false,
    use_C_in=Medium.nC == 1,
    use_X_in=Medium.nX == 2)
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,30})));
  Fluid.Interfaces.IdealSource idealSourceIn(
    redeclare package Medium = Medium,
    control_m_flow=true,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

public
  Modelica.Blocks.Sources.RealExpression reaExpX_air(y=1 - reaPasThr.y)
    annotation (Placement(transformation(extent={{58,42},{38,62}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThr annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,70})));


equation
  hDiff = inStream(port_a.h_outflow) - port_b.h_outflow;
  connect(reaExpMflo.y, idealSourceOut.m_flow_in) annotation (Line(
      points={{-37.7,30},{-36,30},{-36,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a, idealSourceOut.port_a) annotation (Line(
      points={{-100,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(reaExpMflo.y, idealSourceIn.m_flow_in) annotation (Line(points={{-37.7,
          30},{-37.7,30},{44,30},{44,8}},
                                  color={0,0,127}));
  connect(idealSourceOut.port_b, bou.ports[1])
    annotation (Line(points={{-20,0},{8,0},{8,20}}, color={0,127,255}));
  connect(idealSourceIn.port_a, bou.ports[2])
    annotation (Line(points={{40,0},{12,0},{12,20}}, color={0,127,255}));
  connect(idealSourceIn.port_b, port_b)
    annotation (Line(points={{60,0},{80,0},{100,0}}, color={0,127,255}));

  connect(reaExpX_air.y, bou.X_in[2])
    annotation (Line(points={{37,52},{14,52},{14,42}},  color={0,0,127}));
  if Medium.nC>0 then
  connect(bou.C_in[1], weaBus.CEnv)
    annotation (Line(points={{18,42},{18,46},{62,46},{62,86},{10,86},{10,86.05},
            {-39.95,86.05}},                            color={0,0,127}));
  end if;
  connect(reaPasThr.u, weaBus.X_wEnv)
    annotation (Line(points={{30,82},{30,86.05},{-39.95,86.05}},
                                                        color={0,0,127}));
  connect(reaPasThr.y, bou.X_in[1]) annotation (Line(points={{30,59},{14,59},{14,
          52},{14,42}}, color={0,0,127}));
  connect(Te.y, bou.T_in)
    annotation (Line(points={{6,59},{6,56},{6,42}},        color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
May 10, 2017 by Filip Jorissen:<br/>
Fixed bug due to which the outdoor absolute humidity
was not used for the air infiltration model.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/726\">#726</a>.
</li>
<li>
November 15, 2016 by Filip Jorissen:<br/>
Revised documentation.
</li>
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
</html>", info="<html>
<p>
Model for simulating air leakage with the environment.
</p>
</html>"));
end AirLeakage;
