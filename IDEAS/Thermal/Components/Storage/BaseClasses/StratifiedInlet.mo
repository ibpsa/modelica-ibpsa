within IDEAS.Thermal.Components.Storage.BaseClasses;
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
  parameter Integer nbrNodes(min=1) = 10 "Number of nodes in the tank";
  input Modelica.SIunits.Temperature[nbrNodes] TNodes
    "Temperature of the nodes in the tank";
  // it seems not possible to work with the enthalpies provided by flowPorts because they depend
  // on the flow direction in the tank...
  Modelica.SIunits.Temperature T(start=293.15) = flowPort_a.h/medium.cp
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

    testNode := testNode + 1;

    if testNode == nbrNodes + 1 then
      // T is colder than the coldest (lowest) layer, inject between last and one-but-last
      inlet := nbrNodes;
    else
      inlet := inlet;
    end if;

  end while;

equation
  flowPort_a.p = flowPorts[inlet].p;
  flowPort_a.H_flow = semiLinear(
    flowPort_a.m_flow,
    flowPort_a.h,
    flowPorts[inlet].h);

  for i in 1:nbrNodes + 1 loop
    if i == inlet then
      flowPort_a.m_flow + flowPorts[i].m_flow = 0;
      flowPorts[i].H_flow = semiLinear(
        flowPorts[i].m_flow,
        flowPorts[i].h,
        flowPort_a.h);
    else
      flowPorts[i].m_flow = 0;
      flowPorts[i].H_flow = 0;
    end if;
  end for;

  annotation (
    Diagram(graphics),
    Icon(graphics={Line(
          points={{0,80},{0,-80}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),Line(
          points={{0,-40},{42,-40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),Line(
          points={{0,0},{42,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),Line(
          points={{0,40},{42,40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),Line(
          points={{0,80},{42,80}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Perfectly stratified inlet for a thermal energy storage tank. This model has an &apos;inlet&apos; flowPort, and an array of &apos;outlet&apos; flowPorts of the same size as the number of nodes in a storage tank. This array of flowPorts is connected to the array of flowPorts of the tank, and the complete mass flow rate will enter in the tank exactly in between the nodes of corresponding temperature. In&nbsp;other&nbsp;words:&nbsp;the&nbsp;fluid&nbsp;seeks&nbsp;it&apos;s&nbsp;way&nbsp;to&nbsp;the&nbsp;nodes&nbsp;with&nbsp;most&nbsp;close&nbsp;temperature&nbsp;&nbsp;in&nbsp;order&nbsp;to&nbsp;prevent&nbsp;destratification.</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Complete flowrate exits through the same flowPort</li>
<li>No storage nor inertia</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Set the number of nodes equal to the number of nodes in the tank</li>
<li>Connect the temperatures of the tank (array) to the inlet array <i>TNodes</i></li>
</ol></p>
<p><h4>Validation </h4></p>
<p>The model is verified to work properly by simulation of the different operating conditions.</p>
<p><h4>Examples</h4></p>
<p>An example of this model is given in <a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageTank_StratifiedInlet\">IDEAS.Thermal.Components.Examples.StorageTank_StratifiedInlet</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: documentation.</li>
<li>2011 June, Roel De Coninck, first implementation.</li>
</ul></p>
</html>"));
end StratifiedInlet;
