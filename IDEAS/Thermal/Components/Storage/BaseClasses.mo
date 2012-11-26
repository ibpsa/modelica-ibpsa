within IDEAS.Thermal.Components.Storage;
package BaseClasses

  extends Modelica.Icons.BasesPackage;

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

    annotation (Diagram(graphics), Icon(graphics={
          Line(
            points={{0,80},{0,-80}},
            color={0,0,0},
            thickness=0.5,
            smooth=Smooth.None),
          Line(
            points={{0,-40},{42,-40}},
            color={0,0,0},
            thickness=0.5,
            smooth=Smooth.None),
          Line(
            points={{0,0},{42,0}},
            color={0,0,0},
            thickness=0.5,
            smooth=Smooth.None),
          Line(
            points={{0,40},{42,40}},
            color={0,0,0},
            thickness=0.5,
            smooth=Smooth.None),
          Line(
            points={{0,80},{42,80}},
            color={0,0,0},
            thickness=0.5,
            smooth=Smooth.None)}));
  end StratifiedInlet;

  partial model Partial_Buoyancy
    "Partial model to add buoyancy if there is a temperature inversion in the tank"
    parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
      "Medium in the tank";
    parameter SI.Length h "Total tank height";
    parameter Integer nbrNodes(min=2) = 2 "Number of tank nodes";
    parameter SI.Area surCroSec "Cross section surface of the tank";
    SI.HeatFlowRate[nbrNodes-1] Q_flow "Heat flow rate from segment i+1 to i";
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nbrNodes] heatPort
      "Heat input into the volumes"
      annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));

  protected
    SI.TemperatureDifference[nbrNodes-1] dT
      "Temperature difference between layer i+1 and i, only if >0, else 0";
    parameter SI.Length hi = h/nbrNodes;

  equation
    for i in 1:nbrNodes-1 loop
      dT[i] = max(heatPort[i+1].T-heatPort[i].T, 0);
    end for;

  // the heat flows for each of the layers
    heatPort[1].Q_flow = -Q_flow[1];
    for i in 2:nbrNodes-1 loop
         heatPort[i].Q_flow = -Q_flow[i]+Q_flow[i-1];
    end for;
    heatPort[nbrNodes].Q_flow = Q_flow[nbrNodes-1];
    annotation (Documentation(info="<html>
<p>
This model outputs a heat flow rate that can be added to fluid volumes
in order to emulate buoyancy during a temperature inversion.
For simplicity, this model does not compute a buoyancy induced mass flow rate,
but rather a heat flow that has the same magnitude as the enthalpy flow
associated with the buoyancy induced mass flow rate.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 28, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Rectangle(
            extent={{-44,68},{36,28}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-44,-26},{36,-66}},
            lineColor={127,0,0},
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{24,10},{30,-22}},
            lineColor={127,0,0},
            pattern=LinePattern.None,
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{26,22},{20,10},{34,10},{34,10},{26,22}},
            lineColor={127,0,0},
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-32,22},{-26,-10}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-28,-18},{-36,-6},{-22,-6},{-22,-6},{-28,-18}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}),
              graphics));
  end Partial_Buoyancy;

  model Buoyancy_eqcon "Buoyancy modelled as additional thermal conductivity"

    extends IDEAS.Thermal.Components.Storage.BaseClasses.Partial_Buoyancy;

    parameter SI.ThermalConductivity lamBuo=1
      "Equivalent thermal conductivity ";

  initial equation
    assert(lamBuo <> 1, "Error: lamBuo has to be set to a realistic value");

  equation
    for i in 1:nbrNodes-1 loop
      Q_flow[i] = lamBuo * surCroSec * dT[i] / (h/nbrNodes);
    end for;

    annotation (Documentation(info="<html>
<p>
This model outputs a heat flow rate that can be added to fluid volumes
in order to emulate buoyancy during a temperature inversion.
For simplicity, this model does not compute a buoyancy induced mass flow rate,
but rather a heat flow that has the same magnitude as the enthalpy flow
associated with the buoyancy induced mass flow rate.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 28, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Rectangle(
            extent={{-44,68},{36,28}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-44,-26},{36,-66}},
            lineColor={127,0,0},
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{24,10},{30,-22}},
            lineColor={127,0,0},
            pattern=LinePattern.None,
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{26,22},{20,10},{34,10},{34,10},{26,22}},
            lineColor={127,0,0},
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-32,22},{-26,-10}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-28,-18},{-36,-6},{-22,-6},{-22,-6},{-28,-18}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}),
              graphics));
  end Buoyancy_eqcon;

  model Buoyancy_fix "Buoyancy power depending only on temperature difference"

    extends IDEAS.Thermal.Components.Storage.BaseClasses.Partial_Buoyancy;

    parameter SI.ThermalConductance powBuo=1 "Equivalent thermal conductivity ";

  initial equation
    assert(powBuo <> 1, "Error: powBuo has to be set to a realistic value");

  equation
    for i in 1:nbrNodes-1 loop
      Q_flow[i] = powBuo * dT[i];
    end for;

    annotation (Documentation(info="<html>
<p>
This model outputs a heat flow rate that can be added to fluid volumes
in order to emulate buoyancy during a temperature inversion.
For simplicity, this model does not compute a buoyancy induced mass flow rate,
but rather a heat flow that has the same magnitude as the enthalpy flow
associated with the buoyancy induced mass flow rate.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 28, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Rectangle(
            extent={{-44,68},{36,28}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-44,-26},{36,-66}},
            lineColor={127,0,0},
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{24,10},{30,-22}},
            lineColor={127,0,0},
            pattern=LinePattern.None,
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{26,22},{20,10},{34,10},{34,10},{26,22}},
            lineColor={127,0,0},
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-32,22},{-26,-10}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-28,-18},{-36,-6},{-22,-6},{-22,-6},{-28,-18}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}),
              graphics));
  end Buoyancy_fix;

  model Buoyancy_powexp
    "Buoyancy power depends on a power of the number of nodes "

    extends IDEAS.Thermal.Components.Storage.BaseClasses.Partial_Buoyancy;

    parameter SI.ThermalConductance powBuo=1 "Equivalent thermal conductivity "
                                                                                annotation(Evaluate=false);
    parameter Real expNodes=1.5 "Exponent for the number of nodes" annotation(Evaluate=false);

  initial equation
    assert(powBuo <> 1, "Error: powBuo has to be set to a realistic value");

  equation
    for i in 1:nbrNodes-1 loop
      Q_flow[i] = powBuo * dT[i] * nbrNodes^expNodes;
    end for;

    annotation (Documentation(info="<html>
<p>
This model outputs a heat flow rate that can be added to fluid volumes
in order to emulate buoyancy during a temperature inversion.
For simplicity, this model does not compute a buoyancy induced mass flow rate,
but rather a heat flow that has the same magnitude as the enthalpy flow
associated with the buoyancy induced mass flow rate.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 28, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Rectangle(
            extent={{-44,68},{36,28}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-44,-26},{36,-66}},
            lineColor={127,0,0},
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{24,10},{30,-22}},
            lineColor={127,0,0},
            pattern=LinePattern.None,
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{26,22},{20,10},{34,10},{34,10},{26,22}},
            lineColor={127,0,0},
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-32,22},{-26,-10}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-28,-18},{-36,-6},{-22,-6},{-22,-6},{-28,-18}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}),
              graphics));
  end Buoyancy_powexp;

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
end BaseClasses;
