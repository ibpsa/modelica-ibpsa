within IBPSA.Fluid.HeatPumps.ModularReversible;
model ModularReversible
  "Grey-box model for reversible heat pumps"
  extends
    IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine(
    final PEle_nominal=refCyc.refCycHeaPumHea.PEle_nominal,
    mCon_flow_nominal=QUse_flow_nominal/(dTCon_nominal*cpCon),
    mEva_flow_nominal=(QUse_flow_nominal - PEle_nominal)/(dTEva_nominal*cpEva),
    final scaFac=refCyc.refCycHeaPumHea.scaFac,
    use_rev=true,
    redeclare IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle refCyc(
      redeclare model RefrigerantCycleHeatPumpHeating =
          RefrigerantCycleHeatPumpHeating,
      redeclare model RefrigerantCycleHeatPumpCooling =
          RefrigerantCycleHeatPumpCooling));

  replaceable model RefrigerantCycleHeatPumpHeating =
    IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle
       constrainedby
    IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
       final useInHeaPum=true,
       final QUse_flow_nominal=QUse_flow_nominal,
       final TCon_nominal=TCon_nominal,
       final TEva_nominal=TEva_nominal,
       final dTCon_nominal=dTCon_nominal,
       final dTEva_nominal=dTEva_nominal,
       final mCon_flow_nominal=mCon_flow_nominal,
       final mEva_flow_nominal=mEva_flow_nominal,
       final y_nominal=y_nominal)
  "Refrigerant cycle module for the heating mode"
    annotation (choicesAllMatching=true);

  replaceable model RefrigerantCycleHeatPumpCooling =
      IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling
      constrainedby
    IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle(
       final useInChi=false,
       final QUse_flow_nominal=refCyc.refCycHeaPumCoo.QUseNoSca_flow_nominal,
       final scaFac=scaFac,
       final PEle_nominal=refCyc.refCycHeaPumHea.PEle_nominal,
       final TCon_nominal=TCon_nominal,
       final TEva_nominal=TEva_nominal,
       final dTCon_nominal=dTCon_nominal,
       final dTEva_nominal=dTEva_nominal,
       final mCon_flow_nominal=mCon_flow_nominal,
       final mEva_flow_nominal=mEva_flow_nominal,
       final y_nominal=y_nominal)
  "Refrigerant cycle module for the cooling mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);

  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=
    refCyc.refCycHeaPumCoo.QUseNoSca_flow_nominal*scaFac
    "Nominal heat flow rate for cooling"
      annotation(Dialog(group="Nominal condition", enable=use_rev));

  Modelica.Blocks.Sources.BooleanConstant conHea(final k=true)
    if not use_busConOnl and not use_rev
    "Locks the device in heating mode if designated to be not reversible" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-130})));
  Modelica.Blocks.Interfaces.BooleanInput hea if not use_busConOnl and use_rev
    "=true for heating, =false for cooling"
    annotation (Placement(transformation(extent={{-172,-86},{-140,-54}}),
        iconTransformation(extent={{-120,-28},{-102,-10}})));
equation
  connect(conHea.y, sigBus.hea)
    annotation (Line(points={{-99,-130},{-80,-130},{-80,-40},{-140,-40},{-140,
          -41},{-141,-41}},     color={255,0,255}));
  connect(hea, sigBus.hea)
    annotation (Line(points={{-156,-70},{-128,-70},{-128,-40},{-134,-40},{-134,
          -41},{-141,-41}},
                       color={255,0,255}));
  annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(extent={{-140,-160},{140,160}})),
    Documentation(revisions="
<html>
<ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 22, 2019</i> by Julian Matthes:<br/>
    Rebuild due to the introducion of the thermal machine partial model
    (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
  <li>
    <i>November 26, 2018,</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Model of a reversible, modular heat pump.
  This models allows combining any of the available modules
  for refrigerant heating or cooling cycles, inertias,
  heat losses, and safety controls.
  All features are optional.
</p>
<p>
  Adding to the partial model (
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine\">
  IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine</a>),
  this model has the <code>hea</code> signal to choose
  the operation mode of the heat pump.
</p>
<p>
  For more information on the approach, see
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.UsersGuide\">
  IBPSA.Fluid.HeatPumps.ModularReversible.UsersGuide</a>.
</p>
</html>"));
end ModularReversible;
