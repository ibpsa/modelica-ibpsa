within IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety;
model OperationalEnvelope
  "Block that determines if the operational condition is within a defined envelope"
  extends BaseClasses.PartialSafetyWithCounter;
  parameter Real tabUppHea[:,2]
    "Upper boundary for heating with second column as useful temperature side";
  parameter Real tabLowCoo[:,2]
    "Lower boundary for cooling with second column as useful temperature side";
  parameter Boolean forHeaPum
    "=true if model is for heat pump, false for chillers";
  parameter Boolean use_TUseOut=false
    "=true to use useful side outlet temperature for envelope, false for inlet";
  parameter Boolean use_TNotUseOut=true
    "=true to use not useful sides outlet temperature for envelope, false for inlet";

  parameter Modelica.Units.SI.TemperatureDifference dTHys=5
    "Temperature deadband in the operational envelope";

  IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.BoundaryMap bouMapHea(
    final tab=tabUppHea,
    final dT=dTHys,
    final isUppBou=true) "Operational boundary map for heating operation"
    annotation (Placement(transformation(extent={{-80,60},{-20,120}})));

  IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.BoundaryMap bouMapCoo(
    final tab=tabLowCoo,
    final dT=dTHys,
    final isUppBou=false) "Operational boundary map for cooling operation"
    annotation (Placement(transformation(extent={{-80,-120},{-20,-60}})));
  Modelica.Blocks.Logical.LogicalSwitch swiHeaCoo
    "Switch between heating and cooling envelope"
    annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
  Modelica.Blocks.Routing.BooleanPassThrough booPasThrHea if forHeaPum
    "Used to connect to hea signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Routing.BooleanPassThrough booPasThrCoo if not forHeaPum
    "Used to connect to coo signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Logical.Not notCoo if not forHeaPum
                                     "Reverse coo to enble cooling" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-36,-40})));
equation
  connect(ySet,swiErr.u1)  annotation (Line(points={{-136,20},{66,20},{66,8},{
          78,8}}, color={0,0,127}));
  connect(swiHeaCoo.y, booPasThr.u)
    annotation (Line(points={{17,0},{38,0}}, color={255,0,255}));
  connect(bouMapCoo.noErr, swiHeaCoo.u3)
    annotation (Line(points={{-17,-90},{-10,-90},{-10,-8},{-6,-8}},
                                                          color={255,0,255}));
  connect(bouMapHea.noErr, swiHeaCoo.u1)
    annotation (Line(points={{-17,90},{-10,90},{-10,8},{-6,8}},
                                                       color={255,0,255}));
  connect(booPasThrHea.y, swiHeaCoo.u2) annotation (Line(
      points={{-59,40},{-22,40},{-22,0},{-6,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(notCoo.y, swiHeaCoo.u2) annotation (Line(
      points={{-25,-40},{-16,-40},{-16,0},{-6,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(notCoo.u, booPasThrCoo.y) annotation (Line(
      points={{-48,-40},{-59,-40}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(booPasThrCoo.u, sigBus.coo) annotation (Line(
      points={{-82,-40},{-100,-40},{-100,-73},{-119,-73}},
      color={255,0,255},
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(booPasThrHea.u, sigBus.hea) annotation (Line(
      points={{-82,40},{-108,40},{-108,-10},{-119,-10},{-119,-73}},
      color={255,0,255},
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
 if forHeaPum then
    if use_TUseOut then
      connect(bouMapCoo.TUse, sigBus.TConOutMea) annotation (Line(points={{-84.2,-78},
              {-104,-78},{-104,-73},{-119,-73}},color={0,0,127}));
      connect(bouMapHea.TUse, sigBus.TConOutMea) annotation (Line(points={{-84.2,102},
              {-94,102},{-94,-72},{-104,-72},{-104,-73},{-119,-73}},
                                                                  color={0,0,127}));
    else
      connect(bouMapCoo.TUse, sigBus.TConInMea) annotation (Line(points={{-84.2,-78},
              {-104,-78},{-104,-73},{-119,-73}},color={0,0,127}));
      connect(bouMapHea.TUse, sigBus.TConInMea) annotation (Line(points={{-84.2,102},
              {-94,102},{-94,-72},{-104,-72},{-104,-73},{-119,-73}},
                                                                  color={0,0,127}));
    end if;
    if use_TNotUseOut then
      connect(bouMapHea.TNotUse, sigBus.TEvaOutMea) annotation (Line(points={{-84.8,
              78},{-94,78},{-94,-73},{-119,-73}}, color={0,0,127}));
      connect(bouMapCoo.TNotUse, sigBus.TEvaOutMea) annotation (Line(points={{-84.8,
              -102},{-104,-102},{-104,-73},{-119,-73}}, color={0,0,127}));
    else
      connect(bouMapHea.TNotUse, sigBus.TEvaInMea) annotation (Line(points={{-84.8,
              78},{-94,78},{-94,-73},{-119,-73}}, color={0,0,127}));
      connect(bouMapCoo.TNotUse, sigBus.TEvaInMea) annotation (Line(points={{-84.8,
              -102},{-104,-102},{-104,-73},{-119,-73}}, color={0,0,127}));
    end if;
  else
    if use_TNotUseOut then
      connect(bouMapCoo.TNotUse, sigBus.TConOutMea) annotation (Line(points={{-84.8,
              -102},{-104,-102},{-104,-73},{-119,-73}},
                                                color={0,0,127}));
      connect(bouMapHea.TNotUse, sigBus.TConOutMea) annotation (Line(points={{-84.8,
              78},{-94,78},{-94,-72},{-104,-72},{-104,-73},{-119,-73}},
                                                                  color={0,0,127}));
    else
      connect(bouMapCoo.TNotUse, sigBus.TConInMea) annotation (Line(points={{-84.8,
              -102},{-104,-102},{-104,-73},{-119,-73}},
                                                color={0,0,127}));
      connect(bouMapHea.TNotUse, sigBus.TConInMea) annotation (Line(points={{-84.8,
              78},{-94,78},{-94,-72},{-104,-72},{-104,-73},{-119,-73}},
                                                                  color={0,0,127}));
    end if;
    if use_TUseOut then
      connect(bouMapHea.TUse, sigBus.TEvaOutMea) annotation (Line(points={{-84.2,102},
              {-94,102},{-94,-73},{-119,-73}},    color={0,0,127}));
      connect(bouMapCoo.TUse, sigBus.TEvaOutMea) annotation (Line(points={{-84.2,-78},
              {-104,-78},{-104,-73},{-119,-73}},        color={0,0,127}));
    else
      connect(bouMapHea.TUse, sigBus.TEvaInMea) annotation (Line(points={{-84.2,102},
              {-94,102},{-94,-73},{-119,-73}},    color={0,0,127}));
      connect(bouMapCoo.TUse, sigBus.TEvaInMea) annotation (Line(points={{-84.2,-78},
              {-104,-78},{-104,-73},{-119,-73}},        color={0,0,127}));
    end if;
 end if;
  annotation (Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Model to check if the operating conditions are inside
  the given boundaries. If not, the heat pump or chiller will switch off.
</p>
<p>
  This safety control is mainly based on the operational
  envelope of the compressor.
  Refrigerant flowsheet and type will influence these values.
</p>
<h4>Limitations</h4>

<ul>
<li>
  Only three sides of the real envelope are implemented (Figures 2 and 3).
  The real operational envelope implies continuous operation.
  This means start-up from e.g. a cold heat pump supply temperature
  is possible in reality. To avoid additional equations for startup and
  continuous operation, we neither implement the
  lower boundary for heating nor the upper boundary for cooling devices.
  This would lead to devices never being able to turn on.
</li>
<li>
  From all the influences on the real envelope, the compressor frequency
  impacts the possible range of operation. However, the compressor
  speed-dependent envelopes are typcially not provided in datasheets.
  Further, including a third dimension requires 3D-table data. This is
  currently not supported by IBPSA or Modelica Standard Library.
</li>
</ul>

<h4>Existing envelopes</h4>

  Technical datasheets often contain
  information about the operational envelope.
  The device records for heat pumps
  (<a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2DData</a>)
  and chillers
  (<a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.Data.TableData2D\">
  IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2DData</a>)
  contain typical values. Older devices typically have lower limits
  while new refrigerant machines based on propane or advanced flowsheets
  are able to achieve temperature over 70 °C for heating.

<h4>Parameterization from datasheets</h4>
<p>
  Depending on the underlying datasheet in use, you have to think
  thoroughly if you need inlet or outlet conditions, and if
  you are modelling a heat pump or chiller.
  Figure 1 depicts possible upper and lower boundaries as well as
  names for the x- and y-axis.
  Depending on your setup, you even have to transpose existing boundaries.
  For instance, when using an envelope designed for a
  heat pump in a chiller model, the useful side (column 2 of the data)
  is not the condenser but the evaporator. Thus, you have to
  switch column 1 and 2.
  The following examples aim to explain how to obtain the envelopes:
</p>
<p>
  If the model in use is a heat pump,
  the useful side is always the side of
  <code>TConOutMea</code> and <code>TConInMea</code>.
  In the chiller, the useful side is always the side of
  <code>TEvaOutMea</code> or <code>TEvaInMea</code>.
</p>
<ol>
<li>
  The envelopes for air-to-water heat pumps
  often contain water supply temperature (<code>TConOutMea</code>)
  on the y-axis and ambient temperatures (<code>TEvaInMea</code>)
  on the x axis. In these cases, <code>tabUppHea</code> is based
  on the y-axis maximal values and <code>tabLowCoo</code>
  based on the y-axis minimal values.
  Figure 2 depicts this setup.
</li>
<li>
  The envelopes for air-to-air devices often
  contain ambient inlet (<code>TConInMea</code>) as y and
  room (<code>TEvaInMea</code>) inlet temperatures as x variables.
  In these cases, <code>tabUppHea</code> is based on the x-axis maximal
  values and tabLowCoo based on the x-axis minimal values.
  Figure 3 depicts this setup.
</li>
<li>
  Compressor datasheets often provide evaporating and condensing
  temperatures or pressure levels. Those are not avaiable in the
  simpified model approach. Thus, you have to assume pinch
  temperatures to convert it to either in- or outflow temperature
  levels of the secondary side temperatures
  (i.e. <code>TConOutMea</code>, <code>TConInMea</code>,
  <code>TEvaInMea</code>, <code>TEvaOutMea</code>).
</li>
</ol>

<p align=\"center\">
<img  alt=\"image\" src=\"modelica://IBPSA/Resources/Images/Fluid/HeatPumps/SafetyControls/OperationalEnvelope_1.png\" border=\"1\"/>
</p>
<p align=\"center\">
  Figure 1: Possible upper and lower boundaries
  as well as temperature specifications in datasheets
</p>

<p align=\"center\">
<img  alt=\"image\" src=\"modelica://IBPSA/Resources/Images/Fluid/HeatPumps/SafetyControls/OperationalEnvelope_2.png\" border=\"1\"/>
</p>
<p align=\"center\">
  Figure 2: Example for an air-to-water heat pump or chiller.
  The supply temperature is the temperature leaving the device
  into the hydraulic circuit of the building.
  Red crosses indicate the point to write into the 2D table in Modelica.
</p>

<p align=\"center\">
<img  alt=\"image\" src=\"modelica://IBPSA/Resources/Images/Fluid/HeatPumps/SafetyControls/OperationalEnvelope_3.png\" border=\"1\"/>
</p>
<p align=\"center\">
  Figure 3: Example for an air-to-air heat pump or chiller.
  The room temperature acts as an inflow to the device.
  Red crosses indicate the point to write into the 2D table in Modelica.
</p>

</html>"));
end OperationalEnvelope;
