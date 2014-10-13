within IDEAS.Interfaces.BaseClasses;
partial model VentilationSystem

  outer IDEAS.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  outer Modelica.Fluid.System system
  annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

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
        origin={-104,-60})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug
    plugLoad(m=1) if nLoads >= 1 "Electricity connection to the Inhome feeder"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Electric.BaseClasses.WattsLawPlug wattsLawPlug(each numPha=1, final nLoads=
        nLoads) if nLoads >= 1
    annotation (Placement(transformation(extent={{68,-10},{88,10}})));
  Fluid.Interfaces.FlowPort_b[nZones] flowPort_Out(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Fluid.Interfaces.FlowPort_a[nZones] flowPort_In(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));

protected
  final parameter Integer nLoads_min = max(1,nLoads);
   Modelica.SIunits.Power[nLoads_min] P "Active power for each of the loads";
   Modelica.SIunits.Power[nLoads_min] Q "Passive power for each of the loads";
public
  Modelica.Blocks.Sources.RealExpression[nLoads_min] P_val(y=P)
    annotation (Placement(transformation(extent={{42,0},{56,16}})));
  Modelica.Blocks.Sources.RealExpression[nLoads_min] Q_val(y=Q)
    annotation (Placement(transformation(extent={{42,-12},{56,6}})));
equation
    if nLoads >= 1 then
     connect(wattsLawPlug.vi, plugLoad) annotation (Line(
      points={{88,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
     connect(P_val.y, wattsLawPlug.P) annotation (Line(
      points={{56.7,8},{60,8},{60,6},{68,6}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(Q_val.y, wattsLawPlug.Q) annotation (Line(
      points={{56.7,-3},{60,-3},{60,2},{68,2}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
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
          points={{100,100},{100,-100}},
          color={85,170,255},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                         graphics));
end VentilationSystem;
