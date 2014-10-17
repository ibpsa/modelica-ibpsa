within IDEAS.Interfaces.BaseClasses;
partial model VentilationSystem

  outer IDEAS.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  outer Modelica.Fluid.System system
  annotation (Placement(transformation(extent={{-180,80},{-160,100}})));

  replaceable package Medium = IDEAS.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true);

  // Building characteristics  //////////////////////////////////////////////////////////////////////////

  parameter Integer nZones(min=1)
    "Number of conditioned thermal building zones";
  parameter Integer nLoads(min=0) = 1 "Number of electric loads";
  parameter Real[nZones] VZones "Conditioned volumes of the zones";

  // Interfaces  ///////////////////////////////////////////////////////////////////////////////////////

  Modelica.Blocks.Interfaces.RealInput[nZones] TSensor(final quantity="ThermodynamicTemperature",unit="K",displayUnit="degC", min=0)
    "Sensor temperature of the zones" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-204,-60})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug
    plugLoad(m=1) if nLoads >= 1 "Electricity connection to the Inhome feeder"
    annotation (Placement(transformation(extent={{190,-10},{210,10}})));
  Electric.BaseClasses.WattsLawPlug wattsLawPlug(each numPha=1, final nLoads=
        nLoads) if nLoads >= 1
    annotation (Placement(transformation(extent={{178,-10},{188,10}})));
  Fluid.Interfaces.FlowPort_b[nZones] flowPort_Out(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-210,-30},{-190,-10}})));
  Fluid.Interfaces.FlowPort_a[nZones] flowPort_In(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-210,10},{-190,30}})));

protected
  final parameter Integer nLoads_min = max(1,nLoads);
   Modelica.SIunits.Power[nLoads_min] P "Active power for each of the loads";
   Modelica.SIunits.Power[nLoads_min] Q "Passive power for each of the loads";
public
  Modelica.Blocks.Sources.RealExpression[nLoads_min] P_val(y=P)
    annotation (Placement(transformation(extent={{156,0},{170,16}})));
  Modelica.Blocks.Sources.RealExpression[nLoads_min] Q_val(y=Q)
    annotation (Placement(transformation(extent={{156,-12},{170,6}})));
equation
    if nLoads >= 1 then
     connect(wattsLawPlug.vi, plugLoad) annotation (Line(
      points={{188,0},{200,0}},
      color={85,170,255},
      smooth=Smooth.None));
     connect(P_val.y, wattsLawPlug.P) annotation (Line(
      points={{170.7,8},{174,8},{174,6},{178,6}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(Q_val.y, wattsLawPlug.Q) annotation (Line(
      points={{170.7,-3},{174,-3},{174,2},{178,2}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}}), graphics={
        Rectangle(
          extent={{-200,100},{202,-100}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={191,0,0}),
        Polygon(
          points={{6,62},{32,48},{32,18},{34,18},{44,26},{44,-26},{10,-24},{42,
              -42},{42,-74},{76,-40},{76,56},{48,76},{46,76},{6,62}},
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
          smooth=Smooth.None),
        Line(
          points={{202,100},{202,-100}},
          color={85,170,255},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-100},{200,100}}),
                                         graphics));
end VentilationSystem;
