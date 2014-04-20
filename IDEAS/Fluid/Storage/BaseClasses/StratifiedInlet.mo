within IDEAS.Fluid.Storage.BaseClasses;
model StratifiedInlet "Stratified inlet for a storage tank"

  /*
  Idea: the entering fluid flow is ENTIRELY injected between the nodes that have
  adjacent temperatures.
  In other words: the fluid seeks it's way to the nodes with most close temperature 
  in order to prevent destratification
  
  First version 20110629 by RDC
  
  */

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);

  parameter Integer nbrNodes(min=1) = 10 "Number of nodes in the tank";
//  input Modelica.SIunits.Temperature[nbrNodes] TNodes
 //   "Temperature of the nodes in the tank";
  // it seems not possible to work with the enthalpies provided by port_b because they depend
  // on the flow direction in the tank...
//  Modelica.SIunits.Temperature T(start=293.15) = port_a.h/medium.cp
  //    "Inlet temperature";

  Modelica.SIunits.SpecificEnthalpy h_in = inStream(port_a.h_outflow)
    "Enthalpy at the inlet";

  Integer inlet(start=0) "Number of the active inlet node";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)
    "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_b[nbrNodes+1] port_b(redeclare package
      Medium = Medium) "Outlet ports"
    annotation (Placement(transformation(extent={{88,-40},{108,40}})));

protected
  Integer testNode(start=0) "Node counter";
  Modelica.SIunits.SpecificEnthalpy hIn = inStream(port_a.h_outflow)
    "Instream not supported in algorithms";
  Modelica.SIunits.SpecificEnthalpy[nbrNodes+1] hPorts = inStream(port_b.h_outflow)
    "Instream not supported in algorithms";

algorithm
  inlet := 0;
  testNode := 1;
  while inlet == 0 loop
    //determine inlet
    if hIn > hPorts[testNode] then
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
  port_a.p = port_b[inlet].p;
  //using ´inlet´ for the following three equations would be more correct,
  //however this results in errors. This shortcut only results in errors for reversed
  //flows, for which a stratified inlet is not accurate anyway.
  port_a.h_outflow  = inStream(port_b[1].h_outflow);
  port_a.Xi_outflow = inStream(port_b[1].Xi_outflow);
  port_a.C_outflow  = inStream(port_b[1].C_outflow);
  for i in 1:nbrNodes + 1 loop
    port_b[i].h_outflow  = inStream(port_a.h_outflow);
    port_b[i].Xi_outflow = inStream(port_a.Xi_outflow);
    port_b[i].C_outflow  = inStream(port_a.C_outflow);
    if i == inlet then
      port_a.m_flow + port_b[i].m_flow = 0;
    else
      port_b[i].m_flow = 0;
    end if;
  end for;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics),
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
<p>Perfectly stratified inlet for a thermal energy storage tank. This model has an &apos;inlet&apos; flowPort, and an array of &apos;outlet&apos; port_b of the same size as the number of nodes in a storage tank. This array of port_b is connected to the array of port_b of the tank, and the complete mass flow rate will enter in the tank exactly in between the nodes of corresponding temperature. In&nbsp;other&nbsp;words:&nbsp;the&nbsp;fluid&nbsp;seeks&nbsp;it&apos;s&nbsp;way&nbsp;to&nbsp;the&nbsp;nodes&nbsp;with&nbsp;most&nbsp;close&nbsp;temperature&nbsp;&nbsp;in&nbsp;order&nbsp;to&nbsp;prevent&nbsp;destratification.</p>
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
