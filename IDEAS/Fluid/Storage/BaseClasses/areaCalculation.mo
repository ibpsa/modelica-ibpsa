within IDEAS.Fluid.Storage.BaseClasses;
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
  final parameter Modelica.SIunits.Area areaLossSideNode=Modelica.Constants.pi*
      dia*heightTank/nbrNodes "Side area per node";
  final parameter Modelica.SIunits.Area areaLossBotTop=Modelica.Constants.pi*
      dia^2/4 "Top (and bottom) area";

algorithm
  if nbrNodes == 1 then
    A[nbrNodes] := 2*areaLossBotTop + areaLossSideNode;
  elseif nbrNodes == 2 then
    A[1] := areaLossBotTop + areaLossSideNode;
    A[2] := areaLossBotTop + areaLossSideNode;
  else
    A := cat(
      1,
      {areaLossSideNode + areaLossBotTop},
      {areaLossSideNode for i in 1:nbrNodes - 2},
      {areaLossSideNode + areaLossBotTop});
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
