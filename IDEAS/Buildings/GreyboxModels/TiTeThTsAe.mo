within IDEAS.Buildings.GreyboxModels;
model TiTeThTsAe
  "Selected linear low-order building model by P.Bacher, H.Madsen (2011) Procedure for identifying models for the heat dynamics of buildings "

  extends IDEAS.Templates.Interfaces.BaseClasses.Structure(
                                                 nZones=1);

  //Window data
  replaceable parameter IDEAS.Buildings.Data.Interfaces.Glazing glazing
    constrainedby IDEAS.Buildings.Data.Interfaces.Glazing "Glazing type";
  parameter Modelica.SIunits.Area windowArea "Total window area";
  parameter Modelica.SIunits.Angle windowInc "IInclination of the window";
  parameter Modelica.SIunits.Angle windowAzi "Azimuth of teh window";
  //Resistor data
  parameter Modelica.SIunits.HeatCapacity Cs
    "Total thermal capacity for the temperature sensor";
  parameter Modelica.SIunits.HeatCapacity Ci
    "Total thermal capacity for the indoor air";
  parameter Modelica.SIunits.HeatCapacity Ch
    "Total thermal capacity for the heating system";
  parameter Modelica.SIunits.HeatCapacity Ce
    "Total thermal capacity for the building envelope";
  //Capacitor data
  parameter Modelica.SIunits.ThermalResistance Ris
    "Thermal resistance between the indoor air and the sensor";
  parameter Modelica.SIunits.ThermalResistance Rih
    "Thermal resistance between the indoor air and the heating system";
  parameter Modelica.SIunits.ThermalResistance Rie
    "Thermal resistance between the indoor air and the building envelope";
  parameter Modelica.SIunits.ThermalResistance Rea
    "Thermal resistance between the building envelope and the ambient environment";
  //Model elements
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resS(G=1/Ris)
    annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resIE(G=1/Rie)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resAE(G=1/Rea)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resH(G=1/Rih)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TiSensor
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TaSource
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-20,78})));
  IDEAS.Buildings.GreyboxModels.BaseClasses.Window window(
    glazing=glazing,
    A=windowArea,
    inc=windowInc,
    azi=windowAzi) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-22,-30})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capS(C=Cs) annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-30})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capH(C=Ch) annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-56})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capE(C=Ce) annotation (
     Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-42,30})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capI(C=Ci) annotation (
     Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-40,-10})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{-66,68},{-46,88}})));
equation
  connect(TaSource.port, resAE.port_b) annotation (Line(
      points={{-10,78},{0,78},{0,60},{6.12323e-016,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resIE.port_a, resS.port_b) annotation (Line(
      points={{-6.12323e-016,0},{0,0},{0,-10},{40,-10}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(resH.port_b, resS.port_b) annotation (Line(
      points={{6.12323e-016,-20},{0,-20},{0,-10},{40,-10}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(resIE.port_b, capE.port) annotation (Line(
      points={{6.12323e-016,20},{0,20},{0,30},{-32,30}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(capE.port, resAE.port_a) annotation (Line(
      points={{-32,30},{-6.12323e-016,30},{-6.12323e-016,40}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(resH.port_a, capH.port) annotation (Line(
      points={{-6.12323e-016,-40},{1.22465e-015,-40},{1.22465e-015,-46}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(resS.port_a, capS.port) annotation (Line(
      points={{60,-10},{70,-10},{70,-20}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(capS.port, TiSensor.port) annotation (Line(
      points={{70,-20},{70,-10},{80,-10}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(TiSensor.T, TSensor[1]) annotation (Line(
      points={{100,-10},{128,-10},{128,-60},{156,-60}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(window.solGain, capI.port) annotation (Line(
      points={{-22,-20},{-22,-10},{-30,-10}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(capI.port, resS.port_b) annotation (Line(
      points={{-30,-10},{5,-10},{5,-10},{40,-10}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(capI.port, heatPortCon[1]) annotation (Line(
      points={{-30,-10},{20,-10},{20,20},{150,20}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(capI.port, heatPortRad[1]) annotation (Line(
      points={{-30,-10},{22,-10},{22,18},{130,18},{130,-20},{150,-20}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(capE.port, heatPortEmb[1]) annotation (Line(
      points={{-32,30},{130,30},{130,60},{150,60}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(realExpression.y, TaSource.T) annotation (Line(
      points={{-45,78},{-32,78}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-150,
            -100},{150,100}}), graphics), Icon(graphics={Text(
          extent={{-48,-6},{30,-58}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fontName="Calibri",
          textString="4C4R")}));
end TiTeThTsAe;
