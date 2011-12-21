within IDEAS.Thermal.Components.BaseClasses;
model Ambient "Ambient with constant properties"

  extends Thermal.Components.Interfaces.Partials.Ambient;
  parameter Boolean usePressureInput=false "Enable / disable pressure input"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Pressure constantAmbientPressure(start=0)
    "Ambient pressure"
    annotation(Dialog(enable=not usePressureInput));
  parameter Boolean useTemperatureInput=false
    "Enable / disable temperature input"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Temperature constantAmbientTemperature(start=293.15, displayUnit="degC")
    "Ambient temperature"
    annotation(Dialog(enable=not useTemperatureInput));
  Modelica.Blocks.Interfaces.RealInput ambientPressure=pAmbient if usePressureInput
    annotation (Placement(transformation(extent={{110,60},{90,80}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput ambientTemperature=TAmbient if useTemperatureInput
    annotation (Placement(transformation(extent={{110,-60},{90,-80}},
          rotation=0)));
protected
  Modelica.SIunits.Pressure pAmbient;
  Modelica.SIunits.Temperature TAmbient;
equation
  if not usePressureInput then
    pAmbient = constantAmbientPressure;
  end if;
  if not useTemperatureInput then
    TAmbient = constantAmbientTemperature;
  end if;
  flowPort.p = pAmbient;
  T = TAmbient;
annotation (Documentation(info="<HTML>
(Infinite) ambient with constant pressure and temperature.<br>
Thermodynamic equations are defined by Partials.Ambient.
</HTML>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{20,80},{80,20}},
          lineColor={0,0,0},
          textString="p"), Text(
          extent={{20,-20},{80,-80}},
          lineColor={0,0,0},
          textString="T")}));
end Ambient;
