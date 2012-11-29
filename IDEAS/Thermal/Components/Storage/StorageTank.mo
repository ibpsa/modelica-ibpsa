within IDEAS.Thermal.Components.Storage;
model StorageTank "Simplified stratified storage tank"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Medium in the tank";
  //Tank geometry and composition
  parameter Integer nbrNodes(min=1) = 5 "Number of nodes";
  parameter Modelica.SIunits.Volume volumeTank(min=0)
    "Total volume of the tank";
  parameter Modelica.SIunits.Length heightTank(min=0)
    "Total height of the tank";
  final parameter Modelica.SIunits.Mass mNode=volumeTank*medium.rho/nbrNodes
    "Mass of each node";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer UIns(min=0)=0.4
    "Average heat loss coefficient for insulation per m2 of tank surface";
  parameter Modelica.SIunits.ThermalConductance UACon(min=0)=0.5
    "Additional thermal conductance for connection losses and imperfect insulation";
  parameter Modelica.SIunits.Temperature[nbrNodes] TInitial={293.15 for i in
        1:nbrNodes} "Initial temperature of all Temperature states";

    /* 
    A validation excercise has shown that TO BE COMPLETED.
    */

  parameter Boolean preventNaturalDestratification = true
    "if true, this automatically increases the insulation of the top layer";

  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort[
                                            nbrNodes] nodes(
    each medium=medium,
    each m=mNode,
    TInitial=TInitial) "Array of nodes";
  Thermal.Components.Interfaces.FlowPort_a flowPort_a(final medium=medium, h(
        min=1140947, max=1558647)) "Upper flowPort, connected to node[1]"
    annotation (Placement(transformation(extent={{60,80},{80,100}}),
        iconTransformation(extent={{74,74},{86,86}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(final medium=medium, h(
        min=1140947, max=1558647))
    "Lower flowPort, connected to node[nbrNodes]"
    annotation (Placement(transformation(extent={{74,50},{94,70}}),
        iconTransformation(extent={{74,-146},{86,-134}})));
  Thermal.Components.Interfaces.FlowPort_a[nbrNodes + 1] flowPorts(each medium=
        medium, each h(min=1140947, max=1558647))
    "Array of nbrNodes+1 flowPorts. flowPorts[i] is connected to the upper flowPort of node i"
    annotation (Placement(transformation(extent={{92,74},{112,94}}),
        iconTransformation(extent={{74,34},{86,46}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatExchEnv
    "HeatPort for conduction between tank and environment"         annotation (
      Placement(transformation(extent={{92,34},{112,54}}), iconTransformation(
          extent={{44,-46},{56,-34}})));

   replaceable IDEAS.Thermal.Components.Storage.BaseClasses.Buoyancy_powexp
                                                          buoyancy(
    powBuo=24,
    nbrNodes=nbrNodes,
    medium=medium,
    surCroSec=volumeTank/heightTank,
    h=heightTank)
    constrainedby IDEAS.Thermal.Components.Storage.BaseClasses.Partial_Buoyancy(
      nbrNodes=nbrNodes,
      medium=medium,
      surCroSec=volumeTank/heightTank,
      h=heightTank)
    "buoyancy model to mix nodes in case of inversed temperature stratification"
                                                                                annotation(choicesAllMatching=true);

protected
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nbrNodes] lossNodes(
    G = UACon/nbrNodes * ones(nbrNodes) + UIns * IDEAS.Thermal.Components.Storage.BaseClasses.areaCalculation(volumeTank, heightTank, nbrNodes, preventNaturalDestratification))
    "Array of conduction loss components to the environment";

public
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nbrNodes-1] conductionWater(each G = (volumeTank/heightTank) / (heightTank / nbrNodes) * medium.lamda)
    "Conduction heat transfer between the layers";
  Modelica.Blocks.Interfaces.RealOutput[nbrNodes] T = nodes.heatPort.T annotation (Placement(transformation(
          extent={{70,-10},{90,10}}), iconTransformation(extent={{70,-10},{90,10}})));
equation
  // Connection of upper and lower node to external flowPorts
  connect(flowPort_a, nodes[1].flowPort_a);
  connect(flowPort_b,nodes[nbrNodes].flowPort_b);

  // Interconnection of nodes
  if nbrNodes > 1 then
    for i in 2:nbrNodes loop
      connect(nodes[i-1].flowPort_b, nodes[i].flowPort_a);
      connect(nodes[i-1].heatPort, conductionWater[i-1].port_a);
      connect(nodes[i].heatPort, conductionWater[i-1].port_b);
    end for;
  end if;

  // Connection of environmental heat losses to the nodes
  connect(lossNodes.port_a, nodes.heatPort);
  for i in 1:nbrNodes loop
    connect(heatExchEnv, lossNodes[i].port_b);
  end for;

  // Connection of flowPorts to the nodes
  connect(flowPorts[1:end-1], nodes.flowPort_a);
  connect(flowPorts[end], nodes[end].flowPort_b);

  // Connection of buoyancy model
  connect(buoyancy.heatPort, nodes.heatPort);
    annotation (Placement(transformation(extent={{-20,-4},{0,16}})),
              Icon(coordinateSystem(extent={{-100,-160},{80,100}},
          preserveAspectRatio=true),
                   graphics={
        Polygon(
          points={{-70,74},{-68,82},{-62,88},{-52,94},{-38,98},{-22,100},{4,100},
              {18,98},{34,94},{42,88},{48,82},{50,74},{50,-134},{48,-142},{42,-148},
              {32,-154},{18,-158},{4,-160},{-24,-160},{-38,-158},{-52,-154},{-62,
              -148},{-68,-142},{-70,-134},{-70,74}},
          lineColor={100,100,100},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          lineThickness=0.5),
        Line(
          points={{80,80},{64,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{64,70},{64,90}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,70},{60,90}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-10,-36},{-10,80},{60,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{26,46},{38,34}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{60,40},{32,40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,30},{60,50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{64,30},{64,50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{80,40},{64,40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{38,0},{80,0}},
          color={100,100,100},
          smooth=Smooth.None),
        Rectangle(extent={{18,10},{38,-10}}, lineColor={100,100,100}),
        Text(
          extent={{18,10},{38,-10}},
          lineColor={100,100,100},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(
          points={{-10,-140},{-10,-126}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,-140},{-10,-140}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,-150},{60,-130}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{64,-150},{64,-130}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{80,-140},{64,-140}},
          color={0,0,127},
          smooth=Smooth.None)}),                                      Diagram(
        coordinateSystem(extent={{-100,-160},{80,100}}),
        graphics));
end StorageTank;
