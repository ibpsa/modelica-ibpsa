within IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses;
model NoCooling
  "No Cooling. Used to avoid warnings about partial model must be replaced"
  extends PartialChillerBlackBox(
    redeclare final IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.NoFrosting
      iceFacCalc,
    datasource="",
    QUseBlackBox_flow_nominal=0,
    scalingFactor=0,
    y_nominal=0,
    mEva_flow_nominal=0,
    mCon_flow_nominal=0,
    dTEva_nominal=0,
    dTCon_nominal=0,
    TEva_nominal=273.15,
    TCon_nominal=273.15,
    QUse_flow_nominal=0);
  Modelica.Blocks.Sources.Constant const(final k=0)
    annotation (Placement(transformation(extent={{-88,16},{-68,36}})));
equation
  connect(const.y, feedbackHeatFlowEvaporator.u1) annotation (Line(points={{-67,
          26},{-62,26},{-62,4},{-94,4},{-94,-10},{-78,-10}}, color={0,0,127}));
  connect(const.y, feedbackHeatFlowEvaporator.u2) annotation (Line(points={{-67,
          26},{-62,26},{-62,4},{-94,4},{-94,-10},{-84,-10},{-84,-24},{-70,-24},{
          -70,-18}}, color={0,0,127}));
  connect(const.y, calcRedQCon.u2) annotation (Line(points={{-67,26},{-62,26},{-62,
          4},{64,4},{64,-58}}, color={0,0,127}));
  connect(const.y, Pel)
    annotation (Line(points={{-67,26},{0,26},{0,-110}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Model to use to avoid warnings about partial model must be replaced. Using this model, the chiller will always be off.</p>
</html>"));
end NoCooling;
