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
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U(min=0)=0.4
    "Average heat loss coefficient per m² of tank surface";
  parameter Modelica.SIunits.Temperature[nbrNodes] TInitial={293.15 for i in
        1:nbrNodes} "Initial temperature of all Temperature states";
  parameter Boolean preventNaturalDestratification = true
    "if true, this automatically increases the insulation of the top layer";

  Thermal.Components.BaseClasses.HeatedPipe[nbrNodes] nodes(
    each medium=medium,
    each m=mNode,
    TInitial=TInitial) "Array of nodes";
  Thermal.Components.Interfaces.FlowPort_a flowPort_a(final medium=medium, h(
        min=1140947, max=1558647)) "Upper flowPort, connected to node[1]"
    annotation (Placement(transformation(extent={{-12,90},{8,110}}),
        iconTransformation(extent={{-12,90},{8,110}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(final medium=medium, h(
        min=1140947, max=1558647))
    "Lower flowPort, connected to node[nbrNodes]"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  Thermal.Components.Interfaces.FlowPort_a[nbrNodes + 1] flowPorts(each medium=
        medium, each h(min=1140947, max=1558647))
    "Array of nbrNodes+1 flowPorts. flowPorts[i] is connected to the upper flowPort of node i"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}}),
        iconTransformation(extent={{-70,-10},{-50,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatExchEnv
    "HeatPort for conduction between tank and environment"         annotation (
      Placement(transformation(extent={{52,-10},{72,10}}), iconTransformation(
          extent={{52,-10},{72,10}})));

  Thermal.Components.Storage.Buoyancy buoancy(
    nbrNodes=nbrNodes,
    medium=medium,
    tau=100,
    V=volumeTank)
    "Buoancy model to mix nodes in case of inversed temperature stratification";

function areaCalculation
  input Modelica.SIunits.Volume volumeTank;
  input Modelica.SIunits.Length heightTank;
  input Integer nbrNodes;
  input Boolean pnd;
  output Modelica.SIunits.Area[nbrNodes] A
      "Array with (fictive) heat loss area for each node";
  protected
  final parameter Modelica.SIunits.Length dia=sqrt((4*volumeTank)/Modelica.Constants.pi
          /heightTank) "Tank diameter";
  final parameter Modelica.SIunits.Area areaLossSideNode=Modelica.Constants.pi
          *dia*heightTank/nbrNodes "Side area per node";
  final parameter Modelica.SIunits.Area areaLossBotTop=Modelica.Constants.pi*
          dia^2/4 "Top (and bottom) area";

algorithm
  if nbrNodes == 1 then
    A[nbrNodes] := 2*areaLossBotTop + areaLossSideNode;
  elseif nbrNodes == 2 then
    A[1] := areaLossBotTop + areaLossSideNode;
    A[2] := areaLossBotTop + areaLossSideNode;
  else
    A := cat(1,{areaLossSideNode + areaLossBotTop}, {areaLossSideNode for i in 1:nbrNodes-2}, {areaLossSideNode + areaLossBotTop});
    if pnd then
      // we DECREASE the area of the top node in order NOT to let it cool down faster than the node just below.  This
      // is equivalent to increasing the insulation of the top node so the total losses in W/K are equal to the 2nd node.
      A[1] := 0.99*areaLossSideNode;
    end if;
  end if;
end areaCalculation;

protected
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nbrNodes] lossNodes(
    G = U * areaCalculation(volumeTank, heightTank, nbrNodes, preventNaturalDestratification))
    "Array of conduction loss components to the environment";

equation
  // Connection of upper and lower node to external flowPorts
  connect(flowPort_a, nodes[1].flowPort_a);
  connect(flowPort_b,nodes[nbrNodes].flowPort_b);

  // Interconnection of nodes
  if nbrNodes > 1 then
    for i in 2:nbrNodes loop
      connect(nodes[i-1].flowPort_b, nodes[i].flowPort_a);
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

  // Connection of buoancy model
  connect(buoancy.heatPort, nodes.heatPort);
  annotation (Icon(graphics={
        Ellipse(extent={{-60,-76},{60,-100}},
          fillPattern=FillPattern.Solid,
          fillColor={135,135,135},
          lineColor={0,128,255}),
        Rectangle(extent={{-60,88},{60,-88}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(extent={{-60,100},{60,76}},lineColor={0,128,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,88},{-60,-88}},
          smooth=Smooth.None,
          color={0,128,255}),
        Line(
          points={{60,88},{60,-88}},
          smooth=Smooth.None,
          color={0,128,255})}),                                       Diagram(
        graphics));
end StorageTank;
