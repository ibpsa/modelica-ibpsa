within IBPSA.Fluid.Chillers.RefrigerantCycleModels.BaseClasses;
model NoCooling
  "No Cooling. Used to avoid warnings about partial model must be replaced"
  extends PartialChillerRefrigerantCycle(
    redeclare final
      IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Frosting.NoFrosting
      iceFacCal,
    datSou="",
    QUseNoSca_flow_nominal=0,
    scaFac=0,
    y_nominal=0,
    mEva_flow_nominal=1,
    mCon_flow_nominal=1,
    dTEva_nominal=0,
    dTCon_nominal=0,
    TEva_nominal=273.15,
    TCon_nominal=273.15,
    QUse_flow_nominal=0);
  Modelica.Blocks.Sources.Constant const(final k=0) "Zero energy flows"
    annotation (Placement(transformation(extent={{-88,16},{-68,36}})));
equation
  connect(const.y, redQCon.u2) annotation (Line(points={{-67,26},{64,26},{64,
          -58}},               color={0,0,127}));
  connect(const.y, PEle)
    annotation (Line(points={{-67,26},{0,26},{0,-110}}, color={0,0,127}));
  connect(const.y, proRedQEva.u2)
    annotation (Line(points={{-67,26},{-44,26},{-44,-58}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
  Using this model, the chiller will always be off. 
  This option is mainly used to avoid warnings about 
  partial model which must be replaced.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end NoCooling;
