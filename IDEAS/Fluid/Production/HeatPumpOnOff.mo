within IDEAS.Fluid.Production;
model HeatPumpOnOff "A heat pump that can only be switch on or off"
  extends IDEAS.Fluid.Production.BaseClasses.PartialHeatPump(redeclare replaceable parameter
      IDEAS.Fluid.Production.BaseClasses.OnOffHeatPumpData heatPumpData constrainedby
      IDEAS.Fluid.Production.BaseClasses.OnOffHeatPumpData);
  extends IDEAS.Fluid.Interfaces.OnOffInterface(use_onOffSignal=true);

  parameter Boolean use_scaling = false
    "scale the performance data based on the nominal power";
  parameter Modelica.SIunits.Power P_the_nominal
    "nominal thermal power of the heat pump";
  final parameter Real sca = if use_scaling then P_the_nominal / heatPumpData.P_the_nominal else 1
    "scaling factor for the nominal power of the heat pump";

  // check https://github.com/open-ideas/IDEAS/issues/17 for a discussion on why CombiTable2D is used
  Modelica.Blocks.Tables.CombiTable2D powerTable(              table=
        heatPumpData.powerData, smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Interpolation table for finding the electrical power"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Tables.CombiTable2D copTable(                table=
        heatPumpData.copData, smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-60,54},{-40,74}})));
    Real cop "COP of the heat pump";

equation
  cop = if on_internal then  copTable.y else 1;
  P_el = if on_internal then  powerTable.y * sca else 0;
  P_evap=P_el*(cop-1);
  P_cond=P_el*cop;
  connect(copTable.u2, powerTable.u2) annotation (Line(
      points={{-62,58},{-82,58},{-82,84},{-62,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(powerTable.u1, T_in_cond.T) annotation (Line(
      points={{-62,96},{-94,96},{-94,80},{16,80},{16,56},{78,56},{78,-29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(copTable.u1, T_in_cond.T) annotation (Line(
      points={{-62,70},{-94,70},{-94,80},{16,80},{16,56},{78,56},{78,-29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_in_evap.T, powerTable.u2) annotation (Line(
      points={{-82,51},{-82,84},{-62,84}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(
          points={{-100,40},{-20,40},{-40,20},{-20,0},{-40,-20},{-20,-40},{-100,
              -40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{100,40},{20,40},{40,20},{20,0},{40,-20},{20,-40},{100,-40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-20,20},{20,20}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{10,30},{20,20},{10,10}},
          color={255,0,0},
          smooth=Smooth.None)}),
    Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end HeatPumpOnOff;
