within IDEAS.Thermal.Components.Storage;
model StorageTank_OneIntHX
  "Simplified stratified storage tank with one internal heat exchanger (HX)"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Medium in the tank";
  parameter Thermal.Data.Interfaces.Medium mediumHX=Data.Interfaces.Medium()
    "Medium in the HX";

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
  parameter Modelica.SIunits.Time tauBuo(min=0)
    "Time constant for mixing in case of temperature inversion";
  parameter Boolean preventNaturalDestratification = true
    "if true, this automatically increases the insulation of the top layer";

  // HX configuration
  parameter Integer nodeHXUpper(min=1, max=nodeHXLower) = 1
    "Upper entry/exit tank node for the HX";
  parameter Integer nodeHXLower(min=nodeHXUpper, max=nbrNodes) = nbrNodes
    "Lower entry/exit tank node for the HX";
  final parameter Integer nbrNodesHX = nodeHXLower - nodeHXUpper + 1
    "number of HX nodes";
  parameter SI.CoefficientOfHeatTransfer hOut = 867
    "Coefficient of heat transfer between outside of the HX and tank medium";
  parameter SI.CoefficientOfHeatTransfer hPip = 3300
    "Coefficient of heat transfer of the HX pipe (conduction)";
  parameter SI.CoefficientOfHeatTransfer hIn = 4000
    "Coefficient of heat transfer between inside of the HX pipe and HX medium";
  final parameter SI.CoefficientOfHeatTransfer hHX = 1/(1/hOut + 1/hPip + 1/hIn)
    "Total coefficient of heat transfer of the HX";
  parameter SI.Area AHX "Total HX area (outside pipe area)";
  parameter SI.Mass mHX "HX water content";

  Thermal.Components.BaseClasses.HeatedPipe[nbrNodes] nodes(
    each medium=medium,
    each m=mNode,
    TInitial=TInitial) "Array of nodes";
  Thermal.Components.Interfaces.FlowPort_a flowPort_a(final medium=medium, h(
        min=1140947, max=1558647)) "Upper flowPort, connected to node[1]"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(final medium=medium, h(
        min=1140947, max=1558647))
    "Lower flowPort, connected to node[nbrNodes]"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Thermal.Components.Interfaces.FlowPort_a[nbrNodes + 1] flowPorts(each medium=
        medium, each h(min=1140947, max=1558647))
    "Array of nbrNodes+1 flowPorts. flowPorts[i] is connected to the upper flowPort of node i"
    annotation (Placement(transformation(extent={{-110,88},{-90,108}}),
        iconTransformation(extent={{-110,88},{-90,108}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatExchEnv
    "HeatPort for conduction between tank and environment"         annotation (
      Placement(transformation(extent={{52,-10},{72,10}}), iconTransformation(
          extent={{52,-10},{72,10}})));

  BaseClasses.HeatedPipe HX[nbrNodesHX](
     each m = mHX/nbrNodesHX,
     each medium = mediumHX,
     TInitial = TInitial[nodeHXUpper:nodeHXLower])
   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-20})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nbrNodes-1] conductionWater(each G = (volumeTank/heightTank) / (heightTank / nbrNodes) * medium.lamda)
    "Conduction heat transfer between the layers"
    annotation (Placement(transformation(extent={{-20,-4},{0,16}})));

  Thermal.Components.Storage.Buoyancy buoancy(
    nbrNodes=nbrNodes,
    medium=medium,
    tau=tauBuo,
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

public
  Interfaces.FlowPort_b flowPortHXLower(medium=mediumHX)
    "Lower connection to the HX"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Interfaces.FlowPort_a flowPortHXUpper(medium=mediumHX)
    "Upper connection to the internal HX"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor heaTraHX[nbrNodesHX](
    each G = hHX * AHX/nbrNodesHX) "Heat transfer between HX and tank layers"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
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

  // Connection of buoancy model
  connect(buoancy.heatPort, nodes.heatPort);

  // Connections of the internal HX
  for i in 1:nbrNodesHX -1 loop
    connect(HX[i].flowPort_b, HX[i+1].flowPort_a);
  end for;
  connect(flowPortHXUpper, HX[1].flowPort_a) annotation (Line(
      points={{-100,20},{1.83697e-015,20},{1.83697e-015,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flowPortHXLower, HX[nbrNodesHX].flowPort_b) annotation (Line(
      points={{-100,-60},{-1.83697e-015,-60},{-1.83697e-015,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heaTraHX.port_b, HX.heatPort) annotation (Line(
      points={{-30,-20},{-20,-20},{-20,-20},{-10,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaTraHX.port_a, nodes[nodeHXUpper:nodeHXLower].heatPort);
  annotation (Icon(graphics={
        Ellipse(extent={{-62,76},{60,52}}, lineColor={0,0,255}),
        Ellipse(extent={{-62,-46},{60,-70}}, lineColor={0,0,255}),
        Rectangle(extent={{-62,64},{60,-58}}, lineColor={0,0,255})}), Diagram(
        graphics));

end StorageTank_OneIntHX;
