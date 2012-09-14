within IDEAS.Interfaces;
partial model HeatingSystem "Partial heating system inclusif control"

  import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
  outer IDEAS.Climate.SimInfoManager sim
    "Simulation information manager for climate data" annotation (Placement(transformation(extent={{-200,80},
            {-180,100}})));

// Building characteristics  //////////////////////////////////////////////////////////////////////////
  parameter EmissionType emissionType = EmissionType.RadiatorsAndFloorHeating
    "Type of the heat emission system";
  parameter Integer nZones(min=1) "Number of conditioned thermal zones";
  parameter Modelica.SIunits.Power[nZones] QNom(each min=0)
    "Nominal power, can be seen as the max power of the emission system";
  parameter Real[nZones] VZones "Conditioned volumes of the zones";
  final parameter Modelica.SIunits.HeatCapacity[nZones] C = 1012*1.204*VZones*5
    "Heat capacity of the conditioned zones";

// Electricity consumption or production  //////////////////////////////////////////////////////////////
  parameter Integer nLoads(min=1) "Number of electric loads";
  SI.Power[nLoads] P "Active power for each of the loads";
  SI.Power[nLoads] Q "Reactive power for each of the loads";

// Parameters DHW ///////////////////////////////////////////////////////////////////////////////////////
  parameter Integer nOcc = 2
    "number of occupants for determination of DHW consumption";

// Interfaces  ///////////////////////////////////////////////////////////////////////////////////////
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon if
      (emissionType == EmissionType.Radiators or emissionType == EmissionType.RadiatorsAndFloorHeating)
    "Nodes for convective heat gains" annotation (Placement(transformation(extent={{-210,10},
            {-190,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nZones] heatPortRad if
      (emissionType == EmissionType.Radiators or emissionType == EmissionType.RadiatorsAndFloorHeating)
    "Nodes for radiative heat gains" annotation (Placement(transformation(extent={{-210,
            -30},{-190,-10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortEmb if
      (emissionType == EmissionType.FloorHeating or emissionType == EmissionType.RadiatorsAndFloorHeating)
    "Construction nodes for heat gains by embedded layers" annotation (Placement(transformation(extent={{-210,50},
            {-190,70}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[nLoads] plugLoad( each m=1)
    "Electricity connection to the Inhome feeder" annotation (Placement(transformation(extent={{190,-10},
            {210,10}})));
  Modelica.Blocks.Interfaces.RealInput[nZones] TSensor
    "Sensor temperature of the zones" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-196,-60})));
  Modelica.Blocks.Interfaces.RealInput[nZones] TSet
    "Setpoint temperature for the zones" annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-90})));
  Electric.BaseClasses.WattsLawPlug[nLoads] wattsLawPlug(each numPha=1)
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  Modelica.Blocks.Interfaces.RealInput mDHW60C
    "mFlow for domestic hot water, at 60 degC"  annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={120,-90})));

// Total heat use ///////////////////////////////////////////////////////////////////////////////////////
  SI.Power QHeatTotal "Total net heat use (space heating + DHW, if present)";

equation
  connect(wattsLawPlug.vi, plugLoad) annotation (Line(
      points={{190,0},{200,0}},
        color={85,170,255},
        smooth=Smooth.None));
P = wattsLawPlug.P;
Q = wattsLawPlug.Q;
  annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},
            {200,100}}),
                  graphics={
        Polygon(
          points={{-46,-8},{-46,-20},{-44,-22},{-24,-10},{-24,2},{-26,4},{-46,-8}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-32},{-46,-44},{-44,-46},{-24,-34},{-24,-22},{-26,-20},{-46,
              -32}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-44,-18},{-50,-22},{-50,-46},{-46,-50},{28,-50},{42,-40}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-50,-46},{-44,-42}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,0},{-20,2},{-20,-32},{-16,-36},{-16,-36},{40,-36}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,-24},{-20,-22}},
          color={127,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{40,-26},{40,-46},{50,-52},{58,-46},{58,-30},{54,-24},{48,-20},
              {40,-26}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid)}),                         Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,100}}),
        graphics),
    DymolaStoredErrors);
end HeatingSystem;
