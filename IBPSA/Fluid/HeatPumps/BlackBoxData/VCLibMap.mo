within IBPSA.Fluid.HeatPumps.BlackBoxData;
model VCLibMap
  "Multi-dimensional performance map encompasing choices of fluid and 
  flowsheet based on steady state calculations"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialHeatPumpBlackBox(
      final datSou="VCLib", QUseBlaBox_flow_nominal=evaluate(
        externalTable,
        {y_nominal,TCon_nominal,TEva_nominal},
        tabQCon.interpMethod,
        tabQCon.extrapMethod));
  parameter String refrigerant="R410A"
    "Identifier for the refrigerant"
    annotation(Dialog(group="Heat pump specification"));
  parameter String flowsheet="StandardFlowsheet"
    "Identifier for the flowsheet"
    annotation(Dialog(group="Heat pump specification"));
  parameter SDF.Types.InterpolationMethod intMet=
    SDF.Types.InterpolationMethod.Linear
    "Interpolation method"
    annotation (Dialog(tab="SDF File", group="Parameters"));
  parameter SDF.Types.ExtrapolationMethod extMet=
  SDF.Types.ExtrapolationMethod.Hold
    "Extrapolation method"
    annotation (Dialog(tab="SDF File", group="Parameters"));

  parameter String filename="modelica://IBPSA/Resources/Data/Fluid/BaseClasses/PerformanceData/VCLibMap/VCLibMap.sdf"
    "Path to the sdf file"
    annotation(Dialog(tab="SDF File", group="File"));
  parameter String tabNamCOP="COP" "String identifier in sdf table for COP"
    annotation (Dialog(tab="SDF File", group="Variable names"));
  parameter String tabNamQCon="Q_con" "String identifier in sdf table for QCon"
    annotation (Dialog(tab="SDF File", group="Variable names"));
  parameter String tabNamQCon_nominal="Q_flow_con_nominal"
    "String identifier in sdf table for QConNominal"
    annotation (Dialog(tab="SDF File", group="Variable names"));
  parameter String tabNamMEva_flow_nominal="m_flow_eva"
    "String identifier in sdf table for mEva_flow_nominalinal"
    annotation (Dialog(tab="SDF File", group="Variable names"));
  parameter String tabNamMCon_flow_nominal="m_flow_con"
    "String identifier in sdf table for mCon_flow_nominalinal"
    annotation (Dialog(tab="SDF File", group="Variable names"));
  parameter Modelica.Units.SI.Power QTabNom_flow=
      SDF.Functions.readDatasetDouble(
      fileref,
      dataset_QflowNom,
      "W") "Nominal heat flow in map. Doesn't need to be changed."
      annotation(Dialog(tab="SDF File", group=
          "Variable names"));
  parameter Real minCOP=0.1
    "Minimal possible COP value. Used to avoid division by zero error. 
    Should never occur anyways if performance map is correctly created"
    annotation (Dialog(tab="Advanced"));
  Modelica.Blocks.Logical.Switch switchPel
    "If HP is off, no heat will be exchanged" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-10})));
  Modelica.Blocks.Logical.Switch switchQCon
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
        origin={-12,30})));
  Modelica.Blocks.Sources.Constant QScaling(k=scaFac)
    "Scaling for heat pump power " annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,70})));
  Modelica.Blocks.Math.Product proSca
    "Multiply nominal output power with scaling factor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
    rotation=270,
        origin={10,-12})));
  SDF.NDTable tabQCon(
    final readFromFile=true,
    final dataUnit="W",
    final scaleUnits={"-","K","K"},
    final nin=3,
    final interpMethod=intMet,
    final extrapMethod=extMet,
    final filename=fileref,
    final dataset=dataset_QCon) "nD table with performance map of heat pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
    rotation=270,
        origin={-50,30})));
  SDF.NDTable tabCOP(
    final readFromFile=true,
    final dataUnit="-",
    final scaleUnits={"-","K","K"},
    final nin=3,
    final interpMethod=intMet,
    final extrapMethod=extMet,
    final filename=fileref,
    final dataset=dataset_COP) "nD table with performance map of heat pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
    rotation=270,
        origin={48,32})));
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
  Modelica.Blocks.Sources.Constant constMinCOP(k=minCOP)
    "Minimal possible COP. Used to avoid division by zero error. 
    Should never occur anyways if performance map is correctly created"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
    rotation=90,
        origin={-90,70})));

protected
  parameter String fileref = Modelica.Utilities.Files.loadResource(filename);
  parameter Modelica.Units.SI.MassFlowRate mEvaTab_flow_nominal=
      SDF.Functions.readDatasetDouble(
      fileref,
      dataset_mFlowEvaNominal,
      "kg/s") "Nominal mass flow rate in table";

  parameter Modelica.Units.SI.MassFlowRate mConTab_flow_nominal=
      SDF.Functions.readDatasetDouble(
      fileref,
      dataset_mFlowConNominal,
      "kg/s") "Nominal mass flow rate in table";
  parameter String dataset_COP="/" + flowsheet + "/" + refrigerant + "/" +
      tabNamCOP
      "Path within sdf file to COP dataset";
  parameter String dataset_QCon="/" + flowsheet + "/" + refrigerant + "/" +
      tabNamQCon
      "Path within sdf file to QCon dataset";
  parameter String dataset_QflowNom="/" + flowsheet + "/" + refrigerant + "/" +
      tabNamQCon_nominal
      "Path within sdf file to QCon_flow_nominal dataset";
  parameter String dataset_mFlowConNominal="/" + flowsheet + "/"
       + refrigerant + "/" + tabNamMCon_flow_nominal
       "Path within sdf file to mCon_flow_nominal dataset";
  parameter String dataset_mFlowEvaNominal="/" + flowsheet + "/"
      + refrigerant + "/" + tabNamMEva_flow_nominal
      "Path within sdf file to mEva_flow_nominal dataset";
  function evaluate
    input SDF.Types.ExternalNDTable table;
    input Real[:] params;
    input SDF.Types.InterpolationMethod interpMethod;
    input SDF.Types.ExtrapolationMethod extrapMethod;
    output Real value;
    external "C" value = ModelicaNDTable_evaluate(
      table,
      size(params, 1),
      params,
      interpMethod,
      extrapMethod) annotation (
        Include="#include <ModelicaNDTable.c>",
        IncludeDirectory="modelica://SDF/Resources/C-Sources");
  end evaluate;

  parameter SDF.Types.ExternalNDTable externalTable=SDF.Types.ExternalNDTable(
      tabQCon.nin, SDF.Functions.readTableData(
      Modelica.Utilities.Files.loadResource(tabQCon.filename),
      tabQCon.dataset,
      tabQCon.dataUnit,
      tabQCon.scaleUnits));
  final parameter Real perDevMasFloCon=
    (mCon_flow_nominal - mConTab_flow_nominal*scaFac)/mCon_flow_nominal*100
    "Deviation of nominal mass flow rate at condenser in percent";
  final parameter Real perDevMasFloEva=
    (mEva_flow_nominal - mEvaTab_flow_nominal*scaFac)/mEva_flow_nominal*100
    "Deviation of nominal mass flow rate at evaporator in percent";

initial equation
  assert(perDevMasFloCon < 1,
      "The deviation of the given mCon_flow_nominal to the table data is " +
      String(perDevMasFloCon) + " %. Carefully check results, 
      you are extrapolating the table data!",
    AssertionLevel.warning);
  assert(perDevMasFloEva < 1,
    "The deviation of the given mEva_flow_nominal to the table data is " +
      String(perDevMasFloEva) + " %. Carefully check results, 
      you are extrapolating the table data!",
    AssertionLevel.warning);
equation
  connect(constZero.y,switchPel. u3)
   annotation (Line(points={{-12,19},{-12,6},{62,6},{62,2}},
                        color={0,0,127}));
  connect(switchPel.y, redQCon.u2) annotation (Line(points={{70,-21},{70,-46},
          {64,-46},{64,-58}}, color={0,0,127}));
  connect(switchPel.y, PEle) annotation (Line(points={{70,-21},{70,-48},{0,-48},
          {0,-110}}, color={0,0,127}));
  connect(switchQCon.y, feeHeaFloEva.u1) annotation (Line(points={{-110,-21},{
          -110,-10},{-78,-10}}, color={0,0,127}));
  connect(switchPel.y, feeHeaFloEva.u2) annotation (Line(points={{70,-21},{70,
          -46},{-70,-46},{-70,-18}}, color={0,0,127}));
  connect(constZero.y, switchQCon.u3)
  annotation (Line(points={{-12,19},{-12,6},{-118,6},{-118,2}},
                                    color={0,0,127}));
  connect(multiplex3_1.y, tabQCon.u)
   annotation (Line(points={{-1.9984e-15,59},{-1.9984e-15,50},{-56,50},{-56,42},
          {-50,42}},                                        color={0,0,127}));
  connect(multiplex3_1.y,tabCOP.u)
  annotation (Line(points={{-1.9984e-15,59},{-1.9984e-15,58},{24,58},{24,50},{
          48,50},{48,44}},                        color={0,0,127}));
  connect(QScaling.y, proSca.u1)
  annotation (Line(points={{-50,59},{-50,48},{12,48},{12,8},{16,8},{16,
          -8.88178e-16}},
                   color={0,0,127}));
  connect(tabQCon.y, proSca.u2)
   annotation (Line(points={{-50,19},{-50,8.88178e-16},{4,8.88178e-16}},
                    color={0,0,127}));
  connect(proSca.y, switchQCon.u1)
    annotation (Line(points={{10,-23},{10,-28},{-42,-28},{-42,-2},{-56,-2},{-56,
          4},{-94,4},{-94,2},{-102,2}},               color={0,0,127}));
  connect(proSca.y, divisionPel.u1)
  annotation (Line(points={{10,-23},{10,-28},{124,-28},{124,2},{116,2}},
                        color={0,0,127}));
  connect(divisionPel.y, switchPel.u1)
  annotation (Line(points={{110,-21},{110,
          -26},{88,-26},{88,8},{78,8},{78,2}},
                                  color={0,0,127}));
  connect(divisionPel.u2, max.y)
  annotation (Line(points={{104,2},{104,14},{110,
          14},{110,19}},
                      color={0,0,127}));
  connect(max.u1,tabCOP.y)
  annotation (Line(points={{116,42},{116,48},{80,48},{80,16},{48,16},{48,21}},
                     color={0,0,127}));
  connect(constMinCOP.y, max.u2)
  annotation (Line(points={{-90,59},{-90,52},{104,52},{104,42}},
                     color={0,0,127}));
  connect(multiplex3_1.u1[1], sigBus.ySet)
    annotation (Line(points={{7,82},{12,
          82},{12,88},{1,88},{1,104}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(multiplex3_1.u2[1],sigBus.TConInMea)
    annotation (Line(points={{2.22045e-15,82},{1,82},{1,104}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(multiplex3_1.u3[1],sigBus.TEvaInMea)
   annotation (Line(points={{-7,82},
          {-12,82},{-12,88},{1,88},{1,104}},  color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchPel.u2, sigBus.onOffMea)
   annotation (Line(points={{70,2},{70,18},
          {22,18},{22,96},{1,96},{1,104}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchQCon.u2, sigBus.onOffMea)
    annotation (Line(points={{-110,2},{-110,42},{-134,42},
      {-134,96},{2,96},{2,100},{1,100},{1,104}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html>
  <p>This model uses tables generated by the Vapour Compression Library to 
  calculate the relevant outputs of the inner refrigeration cycle. </p>
  <p>If of interest, contact Fabian Wuellhorst or Christian Vering for more 
  information on how the maps are generated. </p>
  <p>The approach is presented and used in this publication: 
  <a href=\"https://linkinghub.elsevier.com/retrieve/pii/S0196890421010645\">
  https://linkinghub.elsevier.com/retrieve/pii/S0196890421010645</a></p>
  <p>The models are based on the open-source vapour compression library: 
  <a href=\"https://onlinelibrary.wiley.com/doi/abs/10.1002/cae.22540\">
  https://onlinelibrary.wiley.com/doi/abs/10.1002/cae.22540</a></p>
</html>", revisions="<html>
<ul>
  <li>
    <i>May 05, 2021</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/1092\">AixLib #1092</a>)
  </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})));
end VCLibMap;
