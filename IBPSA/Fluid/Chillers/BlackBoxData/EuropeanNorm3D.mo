within IBPSA.Fluid.Chillers.BlackBoxData;
model EuropeanNorm3D
  "3-dimensional table with data for chiller based on european norm"
  extends IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.PartialChillerBlackBox(
      datSou="EuropeanNorm3D");
  parameter Real nConv=100
    "Gain value multiplied with relative compressor speed n to calculate matching value based on sdf tables";
  parameter SDF.Types.InterpolationMethod interpMethod=SDF.Types.InterpolationMethod.Linear
    "Interpolation method";
  parameter SDF.Types.ExtrapolationMethod extrapMethod=SDF.Types.ExtrapolationMethod.None
    "Extrapolation method";
  parameter String filename_Pel=
      "modelica://Resources/Data/Fluid/BaseClasses/PerformanceData/LookUpTableND/VZH088AG.sdf"
                                   "File name of sdf table data"
    annotation (Dialog(group="Electrical Power",loadSelector(filter="SDF Files (*.sdf);;All Files (*.*)", caption="Select SDF file")));
  parameter String dataset_Pel="/Pel"
                                  "Dataset name"
    annotation (Dialog(group="Electrical Power"));
  parameter String dataUnit_Pel="W"
                                   "Data unit"
    annotation (Dialog(group="Electrical Power"));
  parameter String scaleUnits_Pel[3]={"K","K",""}
                                                 "Scale units"
    annotation (Dialog(group="Electrical Power"));
  parameter String filename_QCon=
      "modelica://Resources/Data/Fluid/BaseClasses/PerformanceData/LookUpTableND/VZH088AG.sdf"
                                    "File name of sdf table data"
    annotation (Dialog(group="Condenser heat flow",loadSelector(filter="SDF Files (*.sdf);;All Files (*.*)", caption="Select SDF file")));
  parameter String dataset_QCon="/QCon"
                                   "Dataset name"
    annotation (Dialog(group="Condenser heat flow"));
  parameter String dataUnit_QCon="W"
                                    "Data unit"
    annotation (Dialog(group="Condenser heat flow"));
  parameter String scaleUnits_QCon[3]={"K","K",""}
                                                  "Scale units"
    annotation (Dialog(group="Condenser heat flow"));

  Modelica.Blocks.Math.Gain nConGain(final k=nConv)
    "Convert relative speed n to an absolute value for interpolation in sdf tables"
    annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=-90,
        origin={11,89})));
 Modelica.Blocks.Math.UnitConversions.To_degC t_Co_in
    annotation (extent=[-88,38; -76,50], Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=-90,
        origin={50,70})));
  Modelica.Blocks.Math.UnitConversions.To_degC t_Ev_ou annotation (extent=[-88,38;
        -76,50], Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,70})));
  Modelica.Blocks.Sources.Constant constZero(final k=0)
    "Power if HP is turned off"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,10})));
  SDF.NDTable QEvaTab_flow(
    final nin=3,
    final readFromFile=true,
    final filename=filename_QCon,
    final dataset=dataset_QCon,
    final dataUnit=dataUnit_QCon,
    final scaleUnits=scaleUnits_QCon,
    final interpMethod=interpMethod,
    final extrapMethod=extrapMethod) "SDF-Table data for evaporator heat flow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,30})));
  SDF.NDTable PelTab(
    final nin=3,
    final readFromFile=true,
    final filename=filename_Pel,
    final dataset=dataset_Pel,
    final dataUnit=dataUnit_Pel,
    final scaleUnits=scaleUnits_Pel,
    final interpMethod=interpMethod,
    final extrapMethod=extrapMethod) "SDF table data for electrical power"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,30})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1(
    final n1=1,
    final n2=1,
    final n3=1) "Concat all inputs into an array"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,50})));

  Modelica.Blocks.Math.Product scalingFacTimesQEva annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,-10})));
  Modelica.Blocks.Math.Product scalingFacTimesPel annotation (Placement(
        transformation(
        extent={{-9,-9},{9,9}},
        rotation=-90,
        origin={49,-9})));
protected
  Modelica.Blocks.Sources.Constant realCorr(final k=scalingFactor)
    "Calculates correction of table output based on scaling factor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,10})));
equation

  connect(multiplex3_1.y, QEvaTab_flow.u) annotation (Line(points={{10,39},{10,
          36},{-30,36},{-30,48},{-50,48},{-50,42}}, color={0,0,127}));
  connect(multiplex3_1.y, PelTab.u)
    annotation (Line(points={{10,39},{10,42},{50,42}}, color={0,0,127}));
  connect(sigBus.TConInMea,t_Co_in. u) annotation (Line(
      points={{1,104},{0,104},{0,72},{34,72},{34,88},{50,88},{50,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sigBus.TEvaOutMea, t_Ev_ou.u) annotation (Line(
      points={{1,104},{0,104},{0,72},{-34,72},{-34,88},{-50,88},{-50,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sigBus.ySet, nConGain.u) annotation (Line(
      points={{1,104},{6,104},{6,99.8},{11,99.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(nConGain.y, multiplex3_1.u3[1]) annotation (Line(points={{11,79.1},{
          10,79.1},{10,66},{3,66},{3,62}},                     color={0,0,127}));
  connect(t_Ev_ou.y, multiplex3_1.u1[1]) annotation (Line(points={{-50,59},{-50,
          54},{-10,54},{-10,64},{-4,64},{-4,68},{17,68},{17,62}},
                                        color={0,0,127}));
  connect(t_Co_in.y, multiplex3_1.u2[1]) annotation (Line(points={{50,59},{50,
          54},{26,54},{26,68},{18,68},{18,70},{10,70},{10,62}},
                                color={0,0,127}));
  connect(realCorr.y, scalingFacTimesPel.u2)
    annotation (Line(points={{10,-1},{10,-6},{34,-6},{34,1.8},{43.6,1.8}},
                                                             color={0,0,127}));
  connect(realCorr.y, scalingFacTimesQEva.u1) annotation (Line(points={{10,-1},
          {10,-6},{-14,-6},{-14,2},{-24,2}},
                                   color={0,0,127}));
  connect(PelTab.y, scalingFacTimesPel.u1)
    annotation (Line(points={{50,19},{50,1.8},{54.4,1.8}}, color={0,0,127}));
  connect(QEvaTab_flow.y, scalingFacTimesQEva.u2) annotation (Line(points={{-50,
          19},{-50,6},{-42,6},{-42,8},{-36,8},{-36,2}}, color={0,0,127}));
  connect(scalingFacTimesQEva.y, feedbackHeatFlowEvaporator.u1) annotation (
      Line(points={{-30,-21},{-30,-26},{-72,-26},{-72,-24},{-84,-24},{-84,-10},
          {-78,-10}}, color={0,0,127}));
  connect(scalingFacTimesPel.y, calcRedQCon.u2) annotation (Line(points={{49,
          -18.9},{58,-18.9},{58,-58},{64,-58}}, color={0,0,127}));
  connect(scalingFacTimesPel.y, Pel) annotation (Line(points={{49,-18.9},{58,
          -18.9},{58,-58},{2,-58},{2,-94},{0,-94},{0,-110}}, color={0,0,127}));
  connect(constZero.y, feedbackHeatFlowEvaporator.u2) annotation (Line(points={
          {-79,10},{-58,10},{-58,2},{-56,2},{-56,-24},{-70,-24},{-70,-18}},
        color={0,0,127}));
  annotation (Icon(graphics={
    Line(points={{-60.0,40.0},{-60.0,-40.0},{60.0,-40.0},{60.0,40.0},{30.0,40.0},{30.0,-40.0},{-30.0,-40.0},{-30.0,40.0},{-60.0,40.0},{-60.0,20.0},{60.0,20.0},{60.0,0.0},{-60.0,0.0},{-60.0,-20.0},{60.0,-20.0},{60.0,-40.0},{-60.0,-40.0},{-60.0,40.0},{60.0,40.0},{60.0,-40.0}}),
    Line(points={{0.0,40.0},{0.0,-40.0}}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,0.0},{-30.0,20.0}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,-40.0},{-30.0,-20.0}}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-60,-20},{-30,0}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-60,-40},{-30,-20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-30,-40},{0,-20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{0,-40},{30,-20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{30,-40},{60,-20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{30,-20},{60,0}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{0,-20},{30,0}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{0,0},{30,20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{30,0},{60,20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{0,20},{30,40}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{30,20},{60,40}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-60,20},{-30,40}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-30,20},{0,40}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-30,0},{0,20}},
          lineColor={0,0,0}),
    Rectangle(fillColor={255,255,0},
      fillPattern=FillPattern.Solid,
      extent={{-30,-20},{0,0}},
          lineColor={0,0,0})}),                Documentation(info="<html><p>
  Basic models showing the concept of using n-dimensional table data
  for the innerCycle of the heat pump model. This model assumes one
  provides data for inverter controlled heat pumps or chillers.
  However, this basis structure can be used to create own models, where
  electrical power and condenser depend on other inputs, such as
  ambient temperature.
</p>
<ul>
  <li>
    <i>May 22, 2019&#160;</i> by Julian Matthes:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
</ul>
</html>"));
end EuropeanNorm3D;
