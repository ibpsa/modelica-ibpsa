within IBPSA.Fluid.HeatPumps.BlackBoxData;
model VCLibMap
  "Multi-dimensional performance map encompasing choices of fluid and flowsheet based on steady state calculations using the Vapour Compression Library"
  extends IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialBlackBox(
  QConBlackBox_flow_nominal=evaluate(
    externalTable,
    {y_nominal, TCon_nominal, TEva_nominal},
    Table_QCon.interpMethod,
    Table_QCon.extrapMethod));
  // Parameters Heat pump operation
  parameter String refrigerant="R410A" "Identifier for the refrigerant" annotation(Dialog(group=
          "Heat pump specification"));
  parameter String flowsheet="StandardFlowsheet" "Identifier for the flowsheet" annotation(Dialog(group=
          "Heat pump specification"));
  parameter SDF.Types.InterpolationMethod interpMethod=SDF.Types.InterpolationMethod.Linear
    "Interpolation method" annotation (Dialog(tab="SDF File", group="Parameters"));
  parameter SDF.Types.ExtrapolationMethod extrapMethod=SDF.Types.ExtrapolationMethod.Hold
    "Extrapolation method" annotation (Dialog(tab="SDF File", group="Parameters"));
    // Strings
  parameter String filename="modelica://IBPSA/Resources/Data/Fluid/BaseClasses/PerformanceData/VCLibMap/VCLibMap.sdf"
    "Path to the sdf file"                                                                                        annotation(Dialog(tab="SDF File", group="File"));
  parameter String tableName_COP="COP" "String identifier in sdf table for COP"
    annotation (Dialog(tab="SDF File", group="Variable names"));
  parameter String tableName_QCon="Q_con" "String identifier in sdf table for QCon" annotation (Dialog(tab="SDF File", group="Variable names"));
  parameter String tableName_QConNominal="Q_flow_con_nominal" "String identifier in sdf table for QConNominal" annotation (Dialog(tab="SDF File", group="Variable names"));
  parameter String tableName_mFlowEvaNominal="m_flow_eva" "String identifier in sdf table for mEva_flow_nominalinal" annotation (Dialog(tab="SDF File", group="Variable names"));
  parameter String tableName_mFlowConNominal="m_flow_con" "String identifier in sdf table for mCon_flow_nominalinal" annotation (Dialog(tab="SDF File", group="Variable names"));
  parameter Modelica.Units.SI.Power Q_flowTableNom = SDF.Functions.readDatasetDouble(fileref, dataset_QflowNom, "W")
  "Nominal heat flow in map. Doesn't need to be changed."  annotation(Dialog(tab="SDF File", group="Variable names"));
  parameter Real minCOP=0.1
    "Minimal possible COP value. Used to avoid division by zero error. Should never occur anyways if performance map is correctly created"
    annotation (Dialog(tab="Advanced"));
  Modelica.Blocks.Logical.Switch       switchPel
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-10})));
  Modelica.Blocks.Logical.Switch       switchQCon
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-110,-10})));
  Modelica.Blocks.Sources.Constant constZero(final k=0)
                                             annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,30})));
  Modelica.Blocks.Sources.Constant       QScaling(k=scalingFactor)
    "Scaling for heat pump power " annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,70})));
  Modelica.Blocks.Math.Product product_scaling
    "Multiply nominal output power with scaling factor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,30})));
  SDF.NDTable Table_QCon(
    final readFromFile=true,
    final dataUnit="W",
    final scaleUnits={"-","K","K"},
    final nin=3,
    final interpMethod=interpMethod,
    final extrapMethod=extrapMethod,
    final filename=fileref,
    final dataset=dataset_QCon) "nD table with performance map of heat pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-110,70})));
  SDF.NDTable Table_COP(
    final readFromFile=true,
    final dataUnit="-",
    final scaleUnits={"-","K","K"},
    final nin=3,
    final interpMethod=interpMethod,
    final extrapMethod=extrapMethod,
    final filename=fileref,
    final dataset=dataset_COP) "nD table with performance map of heat pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={110,70})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,70})));
  Modelica.Blocks.Math.Division divisionPel "Divide QCon by COP to obtain Pel"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={110,-10})));
  Modelica.Blocks.Math.Max max
    "Use max of lower COP value to avoid division by zero error" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={110,30})));
  Modelica.Blocks.Sources.Constant const_minCOP(k=minCOP)
    "Minimal possible COP. Used to avoid division by zero error. Should never occur anyways if performance map is correctly created"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={70,70})));

protected
  parameter String fileref = Modelica.Utilities.Files.loadResource(filename);
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominalinal=
      SDF.Functions.readDatasetDouble(
      fileref,
      dataset_mFlowEvaNominal,
      "kg/s") "Nominal mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominalinal=
      SDF.Functions.readDatasetDouble(
      fileref,
      dataset_mFlowConNominal,
      "kg/s") "Nominal mass flow rate";
  parameter String dataset_COP="/" + flowsheet + "/" + refrigerant + "/" +
      tableName_COP "Path within sdf file to COP dataset"
    annotation (Dialog(group="Map"));
  parameter String dataset_QCon="/" + flowsheet + "/" + refrigerant + "/" +
      tableName_QCon "Path within sdf file to QCon dataset"
    annotation (Dialog(group="Map"));
  parameter String dataset_QflowNom="/" + flowsheet + "/" + refrigerant + "/" +
      tableName_QConNominal;
  parameter String dataset_mFlowConNominal="/" + flowsheet + "/" + refrigerant + "/"
       + tableName_mFlowConNominal;
  parameter String dataset_mFlowEvaNominal="/" + flowsheet + "/" + refrigerant + "/"
       + tableName_mFlowEvaNominal;
  function evaluate
    input SDF.Types.ExternalNDTable table;
    input Real[:] params;
    input SDF.Types.InterpolationMethod interpMethod;
    input SDF.Types.ExtrapolationMethod extrapMethod;
    output Real value;
    external "C" value = ModelicaNDTable_evaluate(table, size(params, 1), params, interpMethod, extrapMethod) annotation (
      Include="#include <ModelicaNDTable.c>",
      IncludeDirectory="modelica://SDF/Resources/C-Sources");
  end evaluate;

  parameter SDF.Types.ExternalNDTable externalTable=SDF.Types.ExternalNDTable(Table_QCon.nin, SDF.Functions.readTableData(
        Modelica.Utilities.Files.loadResource(Table_QCon.filename),
        Table_QCon.dataset,
        Table_QCon.dataUnit,
        Table_QCon.scaleUnits));
equation
  connect(constZero.y,switchPel. u3) annotation (Line(points={{-10,19},{-10,6},
          {62,6},{62,2}},
                        color={0,0,127}));
  connect(switchPel.y, calcRedQCon.u2) annotation (Line(points={{70,-21},{70,
          -46},{64,-46},{64,-58}},           color={0,0,127}));
  connect(switchPel.y, Pel) annotation (Line(points={{70,-21},{70,-48},{0,-48},
          {0,-110}}, color={0,0,127}));
  connect(switchQCon.y, feedbackHeatFlowEvaporator.u1) annotation (Line(points={{-110,
          -21},{-110,-10},{-78,-10}},                   color={0,0,127}));
  connect(switchPel.y, feedbackHeatFlowEvaporator.u2) annotation (Line(points={{70,-21},
          {70,-46},{-70,-46},{-70,-18}},
        color={0,0,127}));
  connect(constZero.y, switchQCon.u3) annotation (Line(points={{-10,19},{-10,6},
          {-118,6},{-118,2}},       color={0,0,127}));
  connect(multiplex3_1.y, Table_QCon.u) annotation (Line(points={{-1.9984e-15,
          59},{-1.9984e-15,54},{-30,54},{-30,88},{-110,88},{-110,82}},
                                                color={0,0,127}));
  connect(multiplex3_1.y, Table_COP.u) annotation (Line(points={{-1.9984e-15,59},
          {-1.9984e-15,54},{92,54},{92,88},{110,88},{110,82}},
                                            color={0,0,127}));
  connect(QScaling.y, product_scaling.u1) annotation (Line(points={{-50,59},{
          -50,48},{-44,48},{-44,42}},
                                  color={0,0,127}));
  connect(Table_QCon.y, product_scaling.u2) annotation (Line(points={{-110,59},
          {-110,48},{-56,48},{-56,42}},
                                  color={0,0,127}));
  connect(product_scaling.y, switchQCon.u1) annotation (Line(points={{-50,19},{
          -50,2},{-102,2}},                color={0,0,127}));
  connect(product_scaling.y, divisionPel.u1) annotation (Line(points={{-50,19},
          {-50,10},{116,10},{116,2}},                      color={0,0,127}));
  connect(divisionPel.y, switchPel.u1) annotation (Line(points={{110,-21},{110,
          -26},{88,-26},{88,8},{78,8},{78,2}},
                                  color={0,0,127}));
  connect(divisionPel.u2, max.y) annotation (Line(points={{104,2},{104,14},{110,
          14},{110,19}},
                      color={0,0,127}));
  connect(max.u1, Table_COP.y) annotation (Line(points={{116,42},{116,48},{110,
          48},{110,59}},color={0,0,127}));
  connect(const_minCOP.y, max.u2) annotation (Line(points={{70,59},{70,48},{104,
          48},{104,42}},    color={0,0,127}));
  connect(multiplex3_1.u1[1], sigBus.ySet) annotation (Line(points={{7,82},{12,
          82},{12,88},{1,88},{1,104}},                  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(multiplex3_1.u2[1],sigBus.TConInMea)  annotation (Line(points={{
          2.22045e-15,82},{1,82},{1,104}},   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(multiplex3_1.u3[1],sigBus.TEvaInMea)  annotation (Line(points={{-7,82},
          {-12,82},{-12,88},{1,88},{1,104}},               color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchPel.u2, sigBus.onOffMea) annotation (Line(points={{70,2},{70,18},
          {22,18},{22,96},{1,96},{1,104}},              color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchQCon.u2, sigBus.onOffMea) annotation (Line(points={{-110,2},{
          -110,42},{-134,42},{-134,96},{2,96},{2,100},{1,100},{1,104}},
                                                                   color={255,0,
          255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(extent={{-140,-100},{140,100}})),
                                             Documentation(info="<html><p>
  This model uses tables generated by the Vapour Compression Library to
  calculate the relevant outputs of the inner refrigeration cycle.
</p>
<p>
  If of interest, contact Fabian Wüllhorst or Christian Vering for more
  information on how the maps are generated.
</p>
<p>
  The publications regarding this model are currenlty in review.
</p>
</html>", revisions="<html>
<ul>
  <li>
    <i>May 05, 2021</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/1092\">#1092</a>)
  </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})));
end VCLibMap;
