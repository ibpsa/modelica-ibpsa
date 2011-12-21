within IDEAS.Thermal.Components.Storage;
model StratifiedInlet "Stratified inlet for a storage tank"

  /*
  Idea: the entering fluid flow is ENTIRELY injected between the nodes that have
  adjacent temperatures.
  In other words: the fluid seeks it's way to the nodes with most close temperature 
  in order to prevent destratification
  
  First version 20110629 by RDC
  
  */

  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Medium in the component";
  parameter Integer nbrNodes(min=1) = 5 "Number of nodes in the tank";
  input Modelica.SIunits.Temperature[nbrNodes] TNodes
    "Temperature of the nodes in the tank";
    // it seems not possible to work with the enthalpies provided by flowPorts because they depend
    // on the flow direction in the tank...
  Modelica.SIunits.Temperature T(start=293.15)=flowPort_a.h/medium.cp
    "Inlet temperature";
  Integer inlet(start=0) "Number of the inlet node";

  Thermal.Components.Interfaces.FlowPort_a flowPort_a(medium=medium)
    "Inlet flowport"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Thermal.Components.Interfaces.FlowPort_b[nbrNodes + 1] flowPorts(each medium=
        medium) "Array of outlet flowPorts"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  Integer testNode(start=0) "Node counter";

algorithm
  inlet := 0;
  testNode := 1;
  while inlet == 0 loop
    if T > TNodes[testNode] then
      inlet := testNode;
    else
      inlet := 0;
    end if;

    testNode :=testNode + 1;

    if testNode == nbrNodes + 1 then
      // T is colder than the coldest (lowest) layer, inject between last and one-but-last
      inlet := nbrNodes;
    else
      inlet := inlet;
    end if;

  end while;

equation
  flowPort_a.p = flowPorts[inlet].p;
  flowPort_a.H_flow = semiLinear(flowPort_a.m_flow, flowPort_a.h, flowPorts[inlet].h);

for i in 1:nbrNodes+1 loop
  if i==inlet then
    flowPort_a.m_flow + flowPorts[i].m_flow = 0;
    flowPorts[i].H_flow = semiLinear(flowPorts[i].m_flow, flowPorts[i].h, flowPort_a.h);
  else
    flowPorts[i].m_flow = 0;
    flowPorts[i].H_flow = 0;
  end if;
end for;

  annotation (Diagram(graphics));
end StratifiedInlet;
