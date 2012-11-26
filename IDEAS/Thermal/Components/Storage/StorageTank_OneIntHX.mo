within IDEAS.Thermal.Components.Storage;
model StorageTank_OneIntHX
  "Simplified stratified storage tank with one internal heat exchanger (HX)"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water()
    "Medium in the tank";
  parameter Thermal.Data.Interfaces.Medium mediumHX=Data.Media.Water()
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
    "Average heat loss coefficient for insulation per m2 tank surface";
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
    annotation (Placement(transformation(extent={{64,66},{84,86}}),
        iconTransformation(extent={{74,74},{86,86}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(final medium=medium, h(
        min=1140947, max=1558647))
    "Lower flowPort, connected to node[nbrNodes]"
    annotation (Placement(transformation(extent={{64,-154},{84,-134}}),
        iconTransformation(extent={{74,-146},{86,-134}})));
  Thermal.Components.Interfaces.FlowPort_a[nbrNodes + 1] flowPorts(each medium=
        medium, each h(min=1140947, max=1558647))
    "Array of nbrNodes+1 flowPorts. flowPorts[i] is connected to the upper flowPort of node i"
    annotation (Placement(transformation(extent={{68,28},{88,48}}),
        iconTransformation(extent={{74,34},{86,46}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatExchEnv
    "HeatPort for conduction between tank and environment"         annotation (
      Placement(transformation(extent={{48,-16},{68,4}}),  iconTransformation(
          extent={{44,-46},{56,-34}})));

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
    G = UACon/nbrNodes * ones(nbrNodes) + UIns * IDEAS.Thermal.Components.Storage.BaseClasses.areaCalculation(
                                                                 volumeTank, heightTank, nbrNodes, preventNaturalDestratification))
    "Array of conduction loss components to the environment";

public
  Interfaces.FlowPort_b flowPortHXLower(medium=mediumHX)
    "Lower connection to the HX"
    annotation (Placement(transformation(extent={{-116,-134},{-96,-114}}),
        iconTransformation(extent={{-106,-126},{-94,-114}})));
  Interfaces.FlowPort_a flowPortHXUpper(medium=mediumHX)
    "Upper connection to the internal HX"
    annotation (Placement(transformation(extent={{-116,-54},{-96,-34}}),
        iconTransformation(extent={{-106,-86},{-94,-74}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor heaTraHX[nbrNodesHX](
    each G = hHX * AHX/nbrNodesHX) "Heat transfer between HX and tank layers"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
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

  // Connections of the internal HX
  for i in 1:nbrNodesHX -1 loop
    connect(HX[i].flowPort_b, HX[i+1].flowPort_a);
  end for;
  connect(flowPortHXUpper, HX[1].flowPort_a) annotation (Line(
      points={{-106,-44},{1.83697e-015,-44},{1.83697e-015,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flowPortHXLower, HX[nbrNodesHX].flowPort_b) annotation (Line(
      points={{-106,-124},{-1.83697e-015,-124},{-1.83697e-015,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heaTraHX.port_b, HX.heatPort) annotation (Line(
      points={{-30,-20},{-20,-20},{-20,-20},{-10,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaTraHX.port_a, nodes[nodeHXUpper:nodeHXLower].heatPort);
  annotation (Icon(coordinateSystem(extent={{-100,-160},{80,100}},
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
          points={{-100,-80},{-84,-80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-80,-80},{-50,-80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-84,-90},{-84,-70}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-80,-90},{-80,-70}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-100,-120},{-84,-120}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-80,-120},{-38,-120}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-84,-130},{-84,-110}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-80,-130},{-80,-110}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{80,-140},{64,-140}},
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
          points={{80,80},{64,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,80},{50,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,70},{60,90}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{64,70},{64,90}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(extent={{-50,-40},{30,-120}}, lineColor={100,100,100}),
        Line(
          points={{-50,-80},{-30,-80},{0,-60},{-20,-100},{10,-80},{30,-80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{30,-80},{40,-80},{40,-120},{16,-120}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-10,-140},{-10,-126}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-10,-36},{-10,80},{50,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{80,40},{64,40}},
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
        Text(
          extent={{18,10},{38,-10}},
          lineColor={100,100,100},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Rectangle(extent={{18,10},{38,-10}}, lineColor={100,100,100}),
        Line(
          points={{38,0},{80,0}},
          color={100,100,100},
          smooth=Smooth.None),
        Ellipse(
          extent={{26,46},{38,34}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{60,40},{32,40}},
          color={0,0,127},
          smooth=Smooth.None)}),                                      Diagram(
        coordinateSystem(extent={{-100,-160},{80,100}}),
        graphics));
end StorageTank_OneIntHX;
