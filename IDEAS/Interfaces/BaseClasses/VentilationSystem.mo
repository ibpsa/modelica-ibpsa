within IDEAS.Interfaces.BaseClasses;
partial model VentilationSystem

  outer IDEAS.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  // Building characteristics  //////////////////////////////////////////////////////////////////////////

  parameter Integer nZones(min=1)
    "Number of conditioned thermal building zones";
  parameter Integer nLoads(min=1) = 1 "Number of electric system loads";
  parameter Real[nZones] VZones "Conditioned volumes of the zones";

  // Interfaces  ///////////////////////////////////////////////////////////////////////////////////////

  Modelica.Blocks.Interfaces.RealInput[nZones] TSensor(final quantity="ThermodynamicTemperature",unit="K",displayUnit="degC", min=0)
    "Sensor temperature of the zones" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-104,-60})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon
    "Nodes for convective heat gains"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug
    plugLoad(each m=1) "Electricity connection to the Inhome feeder"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Electric.BaseClasses.WattsLawPlug wattsLawPlug(each numPha=1,final nLoads=
        nLoads)
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
equation
  connect(wattsLawPlug.vi, plugLoad) annotation (Line(
      points={{90,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));

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
          smooth=Smooth.None)}), Diagram(graphics));
end VentilationSystem;
