within IDEAS.Building.Model;
model TiTeThTsAe
  "Selected linear low-order building model by P.Bacher, H.Madsen (2011) Procedure for identifying models for the heat dynamics of buildings "

  extends IDEAS.Building.Elements.StateBuilding;

  replaceable parameter IDEAS.Building.Elements.Glazing glazing "glazing type"  annotation(AllMatching=true);
  parameter Modelica.SIunits.Area windowArea;
  parameter Modelica.SIunits.Angle windowInc "inclination of the window";
  parameter Modelica.SIunits.Angle windowAzi "azimuth of teh window";

  parameter Modelica.SIunits.HeatCapacity Cs
    "total thermal capacity for the temperature sensor";
  parameter Modelica.SIunits.HeatCapacity Ci
    "total thermal capacity for teh indoor air";
  parameter Modelica.SIunits.HeatCapacity Ch
    "total thermal capacity for the heating system";
  parameter Modelica.SIunits.HeatCapacity Ce
    "total thermal capacity for the building envelope";

  parameter Modelica.SIunits.ThermalResistance Ris
    "thermal resistance between the indoor air and the sensor";
  parameter Modelica.SIunits.ThermalResistance Rih
    "thermal resistance between the indoor air and the heating system";
  parameter Modelica.SIunits.ThermalResistance Rie
    "thermal resistance between the indoor air and the building envelope";
  parameter Modelica.SIunits.ThermalResistance Rea
    "thermal resistance between the building envelope and the ambient environment";

protected
  Component.Elements.HeatResistor resS(R=Ris)
    annotation (Placement(transformation(extent={{20,-10},{0,10}})));
  Component.Elements.HeatResistor resIE(R=Rie)  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,10})));
  Component.Elements.HeatResistor resAE(R=Rea)  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,30})));
  Component.Elements.HeatResistor resH(R=Rih)       annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-10})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TiSensor
    annotation (Placement(transformation(extent={{40,-6},{52,6}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TaSource(T=sim.Te)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,66})));
  IDEAS.Building.Model.Elements.Window
                                window(glazing=glazing, A=windowArea, inc=windowInc, azi=windowAzi) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-14,66})));
  Component.Elements.HeatCapacity capS(C=Cs)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-10})));
  Component.Elements.HeatCapacity capH(C=Ch)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-30})));
  Component.Elements.HeatCapacity capE(C=Ce)
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Component.Elements.HeatCapacity capI(C=Ci)
    annotation (Placement(transformation(extent={{0,10},{-20,-10}})));
equation
  connect(TaSource.port, resAE.port_b)         annotation (Line(
      points={{-1.10218e-015,60},{0,60},{0,40},{6.12323e-016,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(window.solGain, resS.port_b)          annotation (Line(
      points={{-14,60},{-14,4},{0,4},{0,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resS.port_b, capI.port_a)                   annotation (Line(
      points={{0,0},{0,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capS.port_a, resS.port_a)                  annotation (Line(
      points={{20,0},{20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resIE.port_b, capE.port_a)                  annotation (Line(
      points={{6.12323e-016,20},{0,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resH.port_a, capH.port_a)                   annotation (Line(
      points={{-6.12323e-016,-20},{1.83697e-015,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resS.port_a, TiSensor.port)      annotation (Line(
      points={{20,0},{40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
                                          Text(
          extent={{-48,-6},{30,-58}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fontName="Calibri",
          textString="4C4R")}));
end TiTeThTsAe;
