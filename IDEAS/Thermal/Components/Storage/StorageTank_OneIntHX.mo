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
    parameter Modelica.SIunits.CoefficientOfHeatTransfer UIns(min=0)=0.4
    "Average heat loss coefficient for insulation per m² of tank surface";
  parameter Modelica.SIunits.ThermalConductance UACon(min=0)=0.5
    "Additional thermal conductance for connection losses and imperfect insulation";
  parameter Modelica.SIunits.Temperature[nbrNodes] TInitial={293.15 for i in
        1:nbrNodes} "Initial temperature of all Temperature states";

    /* 
    A validation excercise has shown that TO BE COMPLETED.
    */
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
  parameter SI.Area AHX = 4.1 "Total HX area (outside pipe area)";
  parameter SI.Mass mHX = 27 "HX water content";

  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort[
                                            nbrNodes] nodes(
    each medium=medium,
    each m=mNode,
    TInitial=TInitial) "Array of nodes";
  Thermal.Components.Interfaces.FlowPort_a flowPort_a(final medium=medium, h(
        min=1140947, max=1558647)) "Upper flowPort, connected to node[1]"
    annotation (Placement(transformation(extent={{-16,84},{4,104}}),
        iconTransformation(extent={{-6,94},{4,104}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(final medium=medium, h(
        min=1140947, max=1558647))
    "Lower flowPort, connected to node[nbrNodes]"
    annotation (Placement(transformation(extent={{-16,-114},{4,-94}}),
        iconTransformation(extent={{-6,-104},{4,-94}})));
  Thermal.Components.Interfaces.FlowPort_a[nbrNodes + 1] flowPorts(each medium=
        medium, each h(min=1140947, max=1558647))
    "Array of nbrNodes+1 flowPorts. flowPorts[i] is connected to the upper flowPort of node i"
    annotation (Placement(transformation(extent={{84,86},{104,106}}),
        iconTransformation(extent={{90,92},{104,106}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatExchEnv
    "HeatPort for conduction between tank and environment"         annotation (
      Placement(transformation(extent={{48,-16},{68,4}}),  iconTransformation(
          extent={{60,-4},{68,4}})));

  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                         HX[nbrNodesHX](
     each m = mHX/nbrNodesHX,
     each medium = mediumHX,
     TInitial = TInitial[nodeHXUpper:nodeHXLower])
   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-20})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nbrNodes-1] conductionWater(each G = (volumeTank/heightTank) / (heightTank / nbrNodes) * medium.lamda)
    "Conduction heat transfer between the layers"
    annotation (Placement(transformation(extent={{18,-10},{38,10}})));

   replaceable Thermal.Components.Storage.Buoyancy_gradpower buoyancy(
    nbrNodes=nbrNodes,
    medium=medium,
    surCroSec=volumeTank/heightTank,
    h=heightTank)
    constrainedby IDEAS.Thermal.Components.Storage.Partial_Buoyancy(
      nbrNodes=nbrNodes,
      medium=medium,
      surCroSec=volumeTank/heightTank,
      h=heightTank)
    "buoyancy model to mix nodes in case of inversed temperature stratification"
                                                                                annotation(choicesAllMatching=true);

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
    G = UACon/nbrNodes * ones(nbrNodes) + UIns * areaCalculation(volumeTank, heightTank, nbrNodes, preventNaturalDestratification))
    "Array of conduction loss components to the environment";

public
  Interfaces.FlowPort_b flowPortHXLower(medium=mediumHX)
    "Lower connection to the HX"
    annotation (Placement(transformation(extent={{-116,-74},{-96,-54}}),
        iconTransformation(extent={{-106,-64},{-96,-54}})));
  Interfaces.FlowPort_a flowPortHXUpper(medium=mediumHX)
    "Upper connection to the internal HX"
    annotation (Placement(transformation(extent={{-116,6},{-96,26}}),
        iconTransformation(extent={{-106,16},{-96,26}})));
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

  // Connection of buoyancy model
  connect(buoyancy.heatPort, nodes.heatPort);

  // Connections of the internal HX
  for i in 1:nbrNodesHX -1 loop
    connect(HX[i].flowPort_b, HX[i+1].flowPort_a);
  end for;
  connect(flowPortHXUpper, HX[1].flowPort_a) annotation (Line(
      points={{-106,16},{1.83697e-015,16},{1.83697e-015,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flowPortHXLower, HX[nbrNodesHX].flowPort_b) annotation (Line(
      points={{-106,-64},{-1.83697e-015,-64},{-1.83697e-015,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heaTraHX.port_b, HX.heatPort) annotation (Line(
      points={{-30,-20},{-20,-20},{-20,-20},{-10,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaTraHX.port_a, nodes[nodeHXUpper:nodeHXLower].heatPort);
  annotation (Icon(graphics={
        Rectangle(extent={{-60,88},{60,-88}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(extent={{-60,-76},{60,-100}},
          fillPattern=FillPattern.Solid,
          fillColor={135,135,135},
          pattern=LinePattern.None),
        Ellipse(extent={{-60,100},{60,76}},lineColor={0,128,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,20},{44,20},{-44,-20},{42,-60},{-98,-60}},
          smooth=Smooth.None,
          color={127,0,0},
          thickness=0.5)}),                                           Diagram(
        graphics));
end StorageTank_OneIntHX;
