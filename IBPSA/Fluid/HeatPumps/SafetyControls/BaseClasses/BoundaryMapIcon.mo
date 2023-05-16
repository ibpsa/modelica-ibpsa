within IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses;
partial model BoundaryMapIcon "Model for the icon of a boundary map"

  parameter Boolean use_opeEnvFroRec=true
    "Use a the operational envelope given in the datasheet"
    annotation (
      Dialog(tab="Safety Control", group="Operational Envelope"),
      choices(checkBox=true));
  parameter
    RefrigerantCycleModels.EuropeanNorm2DData.HeatPumpBaseDataDefinition datTab
    "Data Table of HP" annotation (choicesAllMatching=true, Dialog(
      tab="Safety Control",
      group="Operational Envelope",
      enable=use_opeEnvFroRec));
  parameter Real tabUpp[:,2]
    "Table matrix (grid = first column; e.g., table=[0,2])"
    annotation (
      Dialog(
        tab="Safety Control", group="Operational Envelope",
        enable=not use_opeEnvFroRec));
  parameter Real icoMin=-70
    "Used to set the frame where the icon should appear"
    annotation (Dialog(tab="Dynamic Icon"));
  parameter Real icoMax=70 "Used to set the frame where the icon should appear"
    annotation (Dialog(tab="Dynamic Icon"));
protected
  parameter Real tabUpp_internal[:,2](each unit="degC")=if use_opeEnvFroRec then datTab.tableUppBou
       else tabUpp;
  parameter Real TEvaMax(unit="degC")=tabUpp_internal[end, 1]
    "Maximal value of evaporator side";
  parameter Real TEvaMin(unit="degC")=tabUpp_internal[1, 1]
    "Minimal temperature at evaporator side";
  parameter Real TConMax(unit="degC")=max(tabUpp_internal[
      :, 2]) "Maximal temperature of condenser side";
  parameter Real TConMin(unit="degC")=0
    "Minimal value of condenser side";
  final Real[size(scaTEva, 1),2] points=transpose({unScaTEva,unScaTCon})
    annotation (Hide=false);
  Real scaTEva[:](each unit="degC")=tabUpp_internal[:, 1]
    "Helper array with only evaporator values";
  Real scaTCon[:](each unit="degC")=tabUpp_internal[:, 2]
    "Helper array with only condenser values";
  Real unScaTEva[size(scaTEva, 1)](
    each min=-100,
    each max=100) = (scaTEva - fill(TEvaMin, size(scaTEva, 1)))*(icoMax -
    icoMin)/(TEvaMax - TEvaMin) + fill(icoMin, size(scaTEva, 1));
  Real unScaTCon[size(scaTEva, 1)](
    each min=-100,
    each max=100) = (scaTCon - fill(TConMin, size(scaTCon, 1)))*(icoMax -
    icoMin)/(TConMax - TConMin) + fill(icoMin, size(scaTCon, 1));

  annotation (Icon(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}), graphics={
                                    Line(points=DynamicSelect(
      {{-66,-66},{-66,50},{-44,66}, {68,66},{68,-66},{-66,-66}},points),
      color={238,46,47},
      thickness=0.5),
  Polygon(
    points={{icoMin-20,icoMax},{icoMin-20,icoMax},
            {icoMin-10,icoMax},{icoMin-15,icoMax+20}},
    lineColor={95,95,95},
    fillColor={95,95,95},
    fillPattern=FillPattern.Solid),
  Polygon(
    points={{icoMax+20,icoMin-10},{icoMax,icoMin-4},
            {icoMax,icoMin-16},{icoMax+20,icoMin-10}},
    lineColor={95,95,95},
    fillColor={95,95,95},
    fillPattern=FillPattern.Solid),
  Line(points={{icoMin-15,icoMax},
              {icoMin-15,icoMin-15}}, color={95,95,95}),
  Line(points={{icoMin-20,icoMin-10},
              {icoMax+10,icoMin-10}}, color={95,95,95})}),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>Icon model used for the dynamic icon of the model <a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses.BoundaryMap\">IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses.BoundaryMap</a>. Extending this model will display the used operational envelope in the top-layer of the used models. </p>
</html>"));
end BoundaryMapIcon;
