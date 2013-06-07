within IDEAS.Thermal.Components.Storage;
package BaseClasses "Submodels for thermal energy storage."

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
    parameter Integer nbrNodes(min=1) = 10 "Number of nodes in the tank";
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
<p><b>Description</b> </p>
<p>This partial model computes a heat flow rate that can be added to fluid volumes in order to model buoyancy during a temperature inversion in a storage tank. For simplicity, this model does not compute a buoyancy induced mass flow rate, but rather a heat flow that has the same magnitude as the enthalpy flow associated with the buoyancy induced mass flow rate. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Heat flux computation instead of mass flow rates</li>
<li>Connected to a storage tank through an array of heatPorts of size=nbrNodes</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>This model has been instantiated as replaceable in a storage tank model, and the appropriate subclass can be chosen directly in the parameter interface of the storage tank. </li>
<li>Together with the modification of the buoyancy model, one or more parameters of the chosen buoyancy model will have to be set</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>See extensions of this model</p>
</html>",   revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: documentation.</li>
<li>2012 October, Roel De Coninck, modifications</li>
<li>2008, Michael Wetter, first implementation.</li>
</ul></p>
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
<p><b>Description</b> </p>
<p>Buoyancy model that computes the buoyancy heat flux as an<u> equivalent additional thermal conductivity</u>.</p>
<p>This model computes a heat flow rate that can be added to fluid volumes in order to model buoyancy during a temperature inversion in a storage tank. For simplicity, this model does not compute a buoyancy induced mass flow rate, but rather a heat flow that has the same magnitude as the enthalpy flow associated with the buoyancy induced mass flow rate. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Heat flux computation instead of mass flow rates</li>
<li>The buoyancy heat flux Q_flow[i] between node i+1 and node i equals </li>
<p><br/><i>Q_flow[i]&nbsp;=&nbsp;lamBuo&nbsp;*&nbsp;surCroSec&nbsp;*&nbsp;dT[i]&nbsp;/&nbsp;(h/nbrNodes)</i></p>
<p><br/>where:</p>
<p>        <i>lamBuo</i> = equivalent thermal conductivity for buoancy</p>
<p>        <i>surCroSec</i> = surface of the cross-section of the tank</p>
<p>        <i>dT[i]</i> = <i>max(T[i+1]-T[i],&nbsp;0)</i>, so this is the temperature&nbsp;difference&nbsp;between&nbsp;layer&nbsp;i+1&nbsp;and&nbsp;i in case of temperature inversion</p>
<p>        <i>h/nbrNodes</i> = node height</p>
<li>Connected to a storage tank through an array of heatPorts of size=nbrNodes</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>This model has been instantiated as replaceable in a storage tank model, and the appropriate subclass can be chosen directly in the parameter interface of the storage tank. </li>
<li>lamBuo, the only parameter of this model has to be specified together with the modification of the buoyancy model</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>This model is not validated, and is merely as an example of how a buoyancy model can be created starting from the <a href=\"modelica://IDEAS.Thermal.Components.Storage.BaseClasses.Partial_Buoyancy\">Partial_Buoyancy</a> model.</p>
<p>The only validated buoyancy model is <a href=\"modelica://IDEAS.Thermal.Components.Storage.BaseClasses.Buoyancy_powexp\">Buoyancy_powexp</a>.</p>
</html>",   revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: documentation.</li>
<li>2012 October, Roel De Coninck, modifications</li>
<li>2008, Michael Wetter, first implementation.</li>
</ul></p>
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
<p><b>Description</b> </p>
<p>Buoyancy model that computes the buoyancy heat flux as <u>a function of the power of the number of nodes</u>.</p>
<p>This model computes a heat flow rate that can be added to fluid volumes in order to model buoyancy during a temperature inversion in a storage tank. For simplicity, this model does not compute a buoyancy induced mass flow rate, but rather a heat flow that has the same magnitude as the enthalpy flow associated with the buoyancy induced mass flow rate. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Heat flux computation instead of mass flow rates</li>
<li>The buoyancy heat flux Q_flow[i] between node i+1 and node i equals </li>
<p><br/><i>Q_flow[i]&nbsp;=&nbsp;powBuo&nbsp;*&nbsp;dT[i]&nbsp;* nbrNodes^expNodes</i></p>
<p><br/>where:</p>
<p><i>powBuo</i> = equivalent thermal conductivity for buoancy</p>
<p><i>dT[i]</i> = <i>max(T[i+1]-T[i],&nbsp;0)</i>, so this is the temperature&nbsp;difference&nbsp;between&nbsp;layer&nbsp;i+1&nbsp;and&nbsp;i in case of temperature inversion</p>
<p><i>nbrNodes</i> = number of nodes</p>
<p><i>expNodes</i> = parameter, exponent of the number of nodes</p>
<li>Connected to a storage tank through an array of heatPorts of size=nbrNodes</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>This model has been instantiated as replaceable in a storage tank model, and the appropriate subclass can be chosen directly in the parameter interface of the storage tank. </li>
<li>Set the two parameters <i>powBuo</i> and <i>expNodes</i> of this model together with the modification of the buoyancy model. The default values are 24 and 1.5 respectively, they ware identified according to De Coninck et al. (2013).</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>This model has been validated to some extent by fitting powBuo and expNodes on catalogue data of a Viesmann Vitocell100V 390 liter storage tank with internal heat exchanger (Viessmann, 2011). See De Coninck et al. (2013) for more information.</p>
<p>Based on this validation exercise, it was concluded that the thermal behaviour of the storage tank was following the manufacturer data for different number of nodes for the following parameters:</p>
<p><ul>
<li>powBuo ~ 24 (for 10 nodes). For different number of nodes,the optimal value of powBuo varies slightly, as shown in the picture below (powBuo = kBuo in the picture).</li>
<li>expNodes = 1.5 </li>
</ul></p>
<p>For different manufacturer data, different parameter values can be found, so use these values with care. </p>
<p><img src=\"modelica://IDEAS/../Specifications/Thermal/images/Validation_Vitocell100V390l_powBuo_nbrNodespower1.5.png\"/></p>
<p><h4>Examples</h4></p>
<p>See the documentation of the <a href=\"modelica://IDEAS.Thermal.Components.Storage.StorageTank\">StorageTank</a> and <a href=\"modelica://IDEAS.Thermal.Components.Storage.StorageTank_OneIntHX\">StorageTank_ONeINtHX</a>.  </p>
<p>Different example models use a storage tank. A basic setup with a thermostatic valve and only discharging can be found in<a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageWithThermostaticMixing\"> IDEAS.Thermal.Components.Examples.StorageWithThermostaticMixing</a>. </p>
<p><h4>References</h4></p>
<p>De Coninck et al. (2013) - De Coninck, R., Baetens, R., Saelens, D., Woyte, A., &AMP; Helsen, L. (2013). Rule-based demand side management of domestic hot water production with heat pumps in zero energy neighbourhoods. Journal of Building Performance Simulation (accepted). </p>
<p>Viessmann. 2011. Vitocell- 100-V, 390 liter, Datenblatt. Accessed April 21, 2013. <a href=\"http://tinyurl.com/cdpv8rr\">http://tinyurl.com/cdpv8rr</a>.</p>
</html>",   revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: documentation.</li>
<li>2012 October, Roel De Coninck: new buoyancy model. </li>
<li>2008, Michael Wetter, first implementation.</li>
</ul></p>
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

function areaCalculation "Calculate the heat loss area for each tank node"
  input Modelica.SIunits.Volume volumeTank;
  input Modelica.SIunits.Length heightTank;
  input Integer nbrNodes;
  input Boolean pnd
      "Prevent Natural Destratification: if true, automatically increase insulation of top layer";
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
    annotation (Documentation(info="<html>
<p>Function to calculate the heat loss area of each node based on the following inputs:</p>
<p><ul>
<li>volume of the tank</li>
<li>height of the tank</li>
<li>number of nodes</li>
<li>&QUOT;pnd&QUOT; = boolean (Prevent&nbsp;Natural&nbsp;Destratification:&nbsp;if&nbsp;true,&nbsp;automatically&nbsp;increase&nbsp;insulation&nbsp;of&nbsp;top&nbsp;layer  See below for more details.</li>
</ul></p>
<p><br/>The output of the function is an array of size=number of nodes with the (fictive) heat loss area for each node.  Together with the UAIns of the tank, the heat loss per node can then be calculated.</p>
<p><br/><u>Prevent natural destratification</u></p>
<p><br/>if pnd=true, we&nbsp;DECREASE&nbsp;the&nbsp;area&nbsp;of&nbsp;the&nbsp;top&nbsp;node&nbsp;in&nbsp;order&nbsp;NOT&nbsp;to&nbsp;let&nbsp;it&nbsp;cool&nbsp;down&nbsp;faster&nbsp;than&nbsp;the&nbsp;node&nbsp;just&nbsp;below.&nbsp;&nbsp;This is&nbsp;equivalent&nbsp;to&nbsp;increasing&nbsp;the&nbsp;insulation&nbsp;of&nbsp;the&nbsp;top&nbsp;node&nbsp;so&nbsp;the&nbsp;total&nbsp;losses&nbsp;in&nbsp;W/K&nbsp;are&nbsp;equal&nbsp;to&nbsp;the&nbsp;2nd&nbsp;node.</p>
</html>", revisions="<html>
<p><ul>
<li>2013, Roel De Coninck: documentation</li>
<li>2011, Roel De Coninck: first version</li>
</ul></p>
</html>"));
end areaCalculation;
end BaseClasses;
