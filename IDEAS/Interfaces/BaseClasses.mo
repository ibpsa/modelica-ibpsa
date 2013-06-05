within IDEAS.Interfaces;
package BaseClasses

  extends Modelica.Icons.BasesPackage;

  partial model InhomeFeeder

  extends Modelica.Icons.ObsoleteModel;

    parameter Integer nHeatingLoads(min=1)
      "number of electric loads for the heating system";
    parameter Integer nVentilationLoads(min=1)
      "number of electric loads for the ventilation system";
    parameter Integer nOccupantLoads(min=1)
      "number of electric loads for the occupants";
    parameter Integer numberOfPhazes=1
      "The number of phazes connected in the home"
        annotation(choices(
    choice=1 "Single phaze grid connection",
    choice=4 "threephaze (4 line) grid connection"));

    outer IDEAS.SimInfoManager sim
      "Simulation information manager for climate data" annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin plugFeeder[
      numberOfPhazes]
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[
      nVentilationLoads] plugVentilationLoad
      "Electricity connection for the ventilaiton system" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
    Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[
      nHeatingLoads] plugHeatingLoad
      "Electricity connection for the heating system" annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
    Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[
      nOccupantLoads] plugOccupantLoad
      "Electricity connection for the occupants" annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
    annotation(Icon(graphics),                                        Diagram(
          graphics));

  end InhomeFeeder;

  partial model Occupant

  parameter Integer nZones(min=1) "number of conditioned thermal zones";
  parameter Integer nLoads(min=1) = 1 "number of electric loads";

  parameter Integer id = 1 "id-number on extern data references";

    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon
      "Nodes for convective heat gains" annotation (Placement(transformation(extent={{-110,10},{-90,30}}),
          iconTransformation(extent={{-110,10},{-90,30}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortRad
      "Nodes for radiative heat gains" annotation (Placement(transformation(extent={{-110,-30},{-90,-10}}),
          iconTransformation(extent={{-110,-30},{-90,-10}})));
    Modelica.Blocks.Interfaces.RealOutput[nZones] TSet
      "Setpoint temperature for the zones" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,100}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,100})));
    Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug plugLoad( each m=1)
      "Electricity connection to the Inhome feeder" annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Electric.BaseClasses.WattsLawPlug wattsLawPlug(each numPha=1,nLoads=nLoads)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));

    Modelica.Blocks.Interfaces.RealOutput mDHW60C
      "mFlow for domestic hot water, at 60 degC" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=90,
          origin={60,100}),iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={60,100})));
  equation
    connect(wattsLawPlug.vi, plugLoad) annotation (Line(
        points={{60,0},{100,0}},
          color={85,170,255},
          smooth=Smooth.None));

    annotation(Icon(graphics={
          Ellipse(extent={{-12,74},{12,48}}, lineColor={127,0,0}),
          Polygon(
            points={{4,48},{-4,48},{-8,44},{-14,32},{-18,16},{-20,-6},{-14,-20},{14,
                -20},{-14,-20},{-10,-46},{-8,-56},{-8,-64},{-8,-72},{-10,-76},{4,-76},
                {4,-64},{2,-56},{2,-46},{4,-38},{8,-40},{12,-42},{12,-54},{12,-64},
                {14,-70},{18,-76},{24,-76},{22,-64},{22,-56},{22,-48},{24,-40},{24,
                -30},{22,-24},{20,-18},{18,-8},{18,4},{18,12},{18,14},{18,26},{14,
                38},{10,44},{8,46},{4,48}},
            lineColor={127,0,0},
            smooth=Smooth.None),
          Line(
            points={{-58,-76},{60,-76}},
            color={127,0,0},
            smooth=Smooth.None)}),                                    Diagram(
          graphics));
  end Occupant;

  model CausalInhomeFeeder
    "Causal inhome feeder model for a single phase grid connection"

  // Building characteristics  //////////////////////////////////////////////////////////////////////////

    parameter Modelica.SIunits.Length len = 10
      "Cable length to district feeder";

  // Interfaces  ///////////////////////////////////////////////////////////////////////////////////////

    Modelica.Blocks.Interfaces.RealOutput VGrid annotation (Placement(transformation(extent={{96,30},{116,50}})));
    Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug nodeSingle(m=1) annotation (Placement(transformation(extent={{-110,
              -10},{-90,10}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin pinSingle annotation (Placement(transformation(extent={{90,-10},
              {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  // Components  ///////////////////////////////////////////////////////////////////////////////////////

    Electric.BaseClasses.WattsLaw wattsLaw(numPha=1) annotation (Placement(transformation(extent={{20,-10},{40,10}})));

    Electric.DistributionGrid.Components.BranchLenTyp branch(len=len)
      "Cable to district feeder"                                                                 annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    IDEAS.Electric.BaseClasses.PotentialSensor voltageSensor
      "District feeder voltagesensor"                                                        annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={50,20})));

  protected
    Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource voltageSource(
      f=50, V=230, phi=0) "Steady building-side 230 V voltage source"  annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=270,
          origin={-80,-42})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
      "Grounding for the building-side voltage source"                                                                   annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
    Modelica.Electrical.QuasiStationary.MultiPhase.Basic.PlugToPin_p plugToPin_p(
        m=1) "Plug-to-pin conversion" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-80,-22})));

  algorithm
    wattsLaw.P := - Modelica.ComplexMath.real(plugToPin_p.plug_p.pin[1].v*Modelica.ComplexMath.conj(plugToPin_p.plug_p.pin[1].i));
    wattsLaw.Q := - Modelica.ComplexMath.imag(plugToPin_p.plug_p.pin[1].v*Modelica.ComplexMath.conj(plugToPin_p.plug_p.pin[1].i));

  equation
    connect(nodeSingle, plugToPin_p.plug_p) annotation (Line(
        points={{-100,0},{-80,0},{-80,-20},{-80,-20}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(voltageSource.pin_p, plugToPin_p.pin_p) annotation (Line(
        points={{-80,-34},{-80,-24}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(ground.pin, voltageSource.pin_n) annotation (Line(
        points={{-80,-60},{-80,-50}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(wattsLaw.vi[1], voltageSensor.vi) annotation (Line(
        points={{40,0},{50,0},{50,10}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(voltageSensor.VGrid, VGrid) annotation (Line(
        points={{50,30.4},{50,40},{106,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(wattsLaw.vi[1], branch.pin_p) annotation (Line(
        points={{40,0},{60,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(branch.pin_n, pinSingle) annotation (Line(
        points={{80,0},{100,0}},
        color={85,170,255},
        smooth=Smooth.None));
    annotation(Icon(graphics={
          Rectangle(
            extent={{28,60},{70,20}},
            lineColor={85,170,255},
            fillColor={85,170,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-26,54},{-26,20},{-6,20},{-6,28},{4,28},{4,32},{-6,32},{-6,44},
                {8,44},{8,50},{-6,50},{-6,54},{-26,54}},
            lineColor={85,170,255},
            smooth=Smooth.None,
            fillColor={85,170,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-14,20},{-14,0},{-94,0}},
            color={85,170,255},
            smooth=Smooth.None),
          Rectangle(
            extent={{46,50},{50,42}},
            lineColor={85,170,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{56,34},{60,26}},
            lineColor={85,170,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{38,34},{42,26}},
            lineColor={85,170,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{48,20},{48,0},{96,0}},
            color={85,170,255},
            smooth=Smooth.None)}),                                    Diagram(
          graphics),
      Documentation(info="<html>
<p>This gives an in home grid with single phase plugs and single phase grid connection</p>
</html>"));
  end CausalInhomeFeeder;

  partial model VentilationSystem

    outer IDEAS.SimInfoManager sim
      "Simulation information manager for climate data" annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  // Building characteristics  //////////////////////////////////////////////////////////////////////////

    parameter Integer nZones(min=1)
      "Number of conditioned thermal building zones";
    parameter Integer nLoads(min=1) = 1 "Number of electric system loads";
    parameter Real[nZones] VZones "Conditioned volumes of the zones";

  // Interfaces  ///////////////////////////////////////////////////////////////////////////////////////

    Modelica.Blocks.Interfaces.RealInput[nZones] TSensor
      "Sensor temperature of the zones" annotation (Placement(transformation(extent={{10,-10},
              {-10,10}},
          rotation=180,
          origin={-104,-60})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon
      "Nodes for convective heat gains" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
    Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug plugLoad(each m=1)
      "Electricity connection to the Inhome feeder" annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Electric.BaseClasses.WattsLawPlug wattsLawPlug(each numPha=1,nLoads=nLoads)
      annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  equation
    connect(wattsLawPlug.vi, plugLoad) annotation (Line(
        points={{90,0},{100,0}},
          color={85,170,255},
          smooth=Smooth.None));

    annotation(Icon(graphics={
          Polygon(
            points={{6,62},{32,48},{32,18},{34,18},{44,26},{44,-26},{10,-24},{42,-42},
                {42,-74},{76,-40},{76,56},{48,76},{46,76},{6,62}},
            lineColor={127,0,0},
            smooth=Smooth.None,
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Line(
            points={{6,62},{6,30},{32,18}},
            color={127,0,0},
            smooth=Smooth.None),
          Line(
            points={{10,-24},{10,-56},{42,-74}},
            color={127,0,0},
            smooth=Smooth.None)}),                                    Diagram(
          graphics));
  end VentilationSystem;

  partial model HeatingSystem "Partial heating system inclusif control"

    import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;
    outer IDEAS.SimInfoManager         sim
      "Simulation information manager for climate data" annotation (Placement(transformation(extent={{-200,80},
              {-180,100}})));

  // Building characteristics  //////////////////////////////////////////////////////////////////////////
    parameter IDEAS.Thermal.Components.Emission.Interfaces.EmissionType
                           emissionType = EmissionType.RadiatorsAndFloorHeating
      "Type of the heat emission system";
    parameter Integer nZones(min=1)
      "Number of conditioned thermal zones in the building";
    parameter Integer nEmb(min=1) = nZones
      "Number of embedded systems in the building";
    parameter Modelica.SIunits.Power[nZones] QNom(each min=0) = ones(nZones)*5000
      "Nominal power, can be seen as the max power of the emission system";
    parameter Real[nZones] VZones "Conditioned volumes of the zones";
    final parameter Modelica.SIunits.HeatCapacity[nZones] C = 1012*1.204*VZones*5
      "Heat capacity of the conditioned zones";

  // Electricity consumption or production  //////////////////////////////////////////////////////////////
    parameter Integer nLoads(min=1) = 1 "Number of electric loads";
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
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortRad if
        (emissionType == EmissionType.Radiators or emissionType == EmissionType.RadiatorsAndFloorHeating)
      "Nodes for radiative heat gains" annotation (Placement(transformation(extent={{-210,
              -30},{-190,-10}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nZones] heatPortEmb if
        (emissionType == EmissionType.FloorHeating or emissionType == EmissionType.RadiatorsAndFloorHeating)
      "Construction nodes for heat gains by embedded layers" annotation (Placement(transformation(extent={{-210,50},
              {-190,70}})));
    Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug plugLoad( each m=1)
      "Electricity connection to the Inhome feeder" annotation (Placement(transformation(extent={{190,-10},
              {210,10}})));
    Modelica.Blocks.Interfaces.RealInput[nZones] TSensor
      "Sensor temperature of the zones" annotation (Placement(transformation(extent={{10,-10},
              {-10,10}},
          rotation=180,
          origin={-204,-60})));
    Modelica.Blocks.Interfaces.RealInput[nZones] TSet
      "Setpoint temperature for the zones" annotation (Placement(transformation(extent={{-10,-10},
              {10,10}},
          rotation=90,
          origin={0,-104})));
    Electric.BaseClasses.WattsLawPlug wattsLawPlug(each numPha=1,nLoads=nLoads)
      annotation (Placement(transformation(extent={{170,-10},{190,10}})));
    Modelica.Blocks.Interfaces.RealInput mDHW60C
      "mFlow for domestic hot water, at 60 degC"  annotation (Placement(transformation(extent={{-10,-10},
              {10,10}},
          rotation=90,
          origin={60,-104})));

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
          coordinateSystem(preserveAspectRatio=false,extent={{-200,-100},{200,100}}),
          graphics),
      DymolaStoredErrors);
  end HeatingSystem;

  partial model Structure "Partial model for building structure models"

    outer IDEAS.SimInfoManager sim
      "Simulation information manager for climate data" annotation (Placement(transformation(extent={{130,-100},{150,-80}})));

  // Building characteristics  //////////////////////////////////////////////////////////////////////////

    parameter Integer nZones(min=1)
      "Number of conditioned thermal zones in the building";
    parameter Integer nEmb(min=1) = nZones
      "Number of embedded systems in the building";
    parameter Modelica.SIunits.Area ATrans = 100
      "Transmission heat loss area of the residential unit";
    parameter Modelica.SIunits.Area[nZones] AZones = ones(nZones)*100
      "Conditioned floor area of the zones";
    parameter Modelica.SIunits.Volume[nZones] VZones =  ones(nZones)*300
      "Conditioned volume of the zones based on external dimensions";
    final parameter Modelica.SIunits.Length C = sum(VZones)/ATrans
      "Building compactness";

  // Interfaces  ///////////////////////////////////////////////////////////////////////////////////////

    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon
      "Internal zone nodes for convective heat gains" annotation (Placement(transformation(extent={{140,10},{160,30}}),
          iconTransformation(extent={{140,10},{160,30}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortRad
      "Internal zones node for radiative heat gains" annotation (Placement(transformation(extent={{140,-30},{160,-10}}),
          iconTransformation(extent={{140,-30},{160,-10}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nEmb] heatPortEmb
      "Construction nodes for heat gains by embedded layers" annotation (Placement(transformation(extent={{140,50},{160,70}}),
          iconTransformation(extent={{140,50},{160,70}})));
    Modelica.Blocks.Interfaces.RealOutput[nZones] TSensor
      "Sensor temperature of the zones" annotation (Placement(transformation(extent={{146,-70},{166,-50}})));
    annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-150,-100},
              {150,100}}),
                    graphics={Line(
            points={{60,8},{0,60},{-60,10},{-60,-60},{60,-60}},
            color={127,0,0},
            smooth=Smooth.None), Polygon(
            points={{60,8},{56,4},{0,50},{-52,8},{-52,-52},{60,-52},{60,-60},{-60,
                -60},{-60,10},{0,60},{60,8}},
            lineColor={95,95,95},
            smooth=Smooth.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid)}),                         Diagram(
          coordinateSystem(preserveAspectRatio=false,extent={{-150,-100},{150,
              100}}),
          graphics));

  end Structure;
end BaseClasses;
