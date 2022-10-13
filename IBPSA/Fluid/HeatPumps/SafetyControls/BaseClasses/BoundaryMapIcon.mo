within IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses;
partial block BoundaryMapIcon "PartialModel for the icon of a boundary map"

  parameter Boolean use_opeEnvFroRec=true
    "Use a the operational envelope given in the datasheet"
    annotation (
      Dialog(tab="Safety Control", group="Operational Envelope"),
      choices(checkBox=true));
  parameter BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition datTab
    "Data Table of HP"
      annotation (
        choicesAllMatching=true,
        Dialog(
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
  parameter Real tabUpp_internal[:,2]=if use_opeEnvFroRec then datTab.tableUppBou
       else tabUpp;
  parameter Real xMax=tabUpp_internal[end, 1]
    "Maximal value of lower and upper table data";
  parameter Real xMin=tabUpp_internal[1, 1]
    "Minimal value of lower and upper table data";
  parameter Real yMax=max(tabUpp_internal[:, 2])
    "Maximal value of lower and upper table data";
  parameter Real yMin=0
    "Minimal value of lower and upper table data";
  final Real[size(scaX, 1),2] points=transpose({unScaX,unScaY})
    annotation (Hide=false);
  Real tabMer[:,2]=tabUpp_internal;
  input Real scaX[:]=tabMer[:, 1];
  input Real scaY[:]=tabMer[:, 2];
  Real unScaX[size(scaX, 1)](
    each min=-100,
    each max=100) = (scaX - fill(xMin, size(scaX, 1)))*(icoMax - icoMin)/
    (xMax - xMin) + fill(icoMin, size(scaX, 1));
  Real unScaY[size(scaX, 1)](
    each min=-100,
    each max=100) = (scaY - fill(yMin, size(scaY, 1)))*(icoMax - icoMin)/
    (yMax - yMin) + fill(icoMin, size(scaY, 1));

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
<p>
  Icon block used for the icon of the dynamic icon of the model
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses.BoundaryMap\">
  IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses.BoundaryMap</a>. 
  Extending this model will display the used
  operational envelope in the top-layer of the used models.
</p>
</html>"));
end BoundaryMapIcon;
