within IDEAS.Interfaces.BaseClasses;
partial model Occupant

  parameter Integer nZones(min=1) "number of conditioned thermal zones";
  parameter Integer nLoads(min=0) = 1 "number of electric loads";

  parameter Integer id=1 "id-number on extern data references";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon
    "Nodes for convective heat gains" annotation (Placement(transformation(
          extent={{-210,10},{-190,30}}),iconTransformation(extent={{-210,10},{
            -190,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortRad
    "Nodes for radiative heat gains" annotation (Placement(transformation(
          extent={{-210,-30},{-190,-10}}),iconTransformation(extent={{-210,-30},
            {-190,-10}})));
  Modelica.Blocks.Interfaces.RealOutput[nZones] TSet(
    final quantity="ThermodynamicTemperature",
    unit="K",
    displayUnit="degC",
    min=0) "Setpoint temperature for the zones" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,100})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug
    plugLoad(m=1) if nLoads >= 1 "Electricity connection to the Inhome feeder"
    annotation (Placement(transformation(extent={{190,-10},{210,10}})));
  Electric.BaseClasses.WattsLawPlug wattsLawPlug(each numPha=1, final nLoads=
        nLoads) if nLoads >= 1
    annotation (Placement(transformation(extent={{184,-8},{192,6}})));

  Modelica.Blocks.Interfaces.RealOutput mDHW60C
    "mFlow for domestic hot water, at 60 degC" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,100})));

protected
  final parameter Integer nLoads_min=max(1, nLoads);
  Modelica.SIunits.Power[nLoads_min] P "Active power for each of the loads";
  Modelica.SIunits.Power[nLoads_min] Q "Passive power for each of the loads";
public
  Modelica.Blocks.Sources.RealExpression[nLoads_min] P_val(y=P)
    annotation (Placement(transformation(extent={{170,0},{180,14}})));
  Modelica.Blocks.Sources.RealExpression[nLoads_min] Q_val(y=Q)
    annotation (Placement(transformation(extent={{172,-8},{180,4}})));
  outer SimInfoManager       sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
equation
  if nLoads >= 1 then
    connect(wattsLawPlug.vi, plugLoad) annotation (Line(
        points={{192,-1},{194,-1},{194,0},{200,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(P_val.y, wattsLawPlug.P) annotation (Line(
        points={{180.5,7},{184,7},{184,3.2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(Q_val.y, wattsLawPlug.Q) annotation (Line(
        points={{180.4,-2},{182,-2},{182,0.4},{184,0.4}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}}),
                         graphics={
        Rectangle(
          extent={{-200,100},{200,-100}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={191,0,0}),
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
          smooth=Smooth.None),
        Line(
          points={{200,100},{200,-100}},
          color={85,170,255},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-100},{200,100}}), graphics));
end Occupant;
