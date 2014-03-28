within IDEAS.Fluid.Valves.Examples;
model ThreeWayValveMotor
  extends Modelica.Icons.Example;

  parameter IDEAS.Thermal.Data.Interfaces.Medium  medium= IDEAS.Thermal.Data.Media.Water();

protected
  IDEAS.Fluid.Movers.Pump pumpFlow1(
    useInput=true,
    medium=medium,
    m=0,
    m_flowNom=5,
    dpFix=0) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-72,0})));
public
  Modelica.Blocks.Sources.Constant flow_pump(k=1)
        annotation (Placement(transformation(extent={{-98,60},{-78,80}})));
  Modelica.Blocks.Sources.Constant ctrl(k=0.4)
        annotation (Placement(transformation(extent={{-32,58},{-12,78}})));
  IDEAS.Thermal.Components.BaseClasses.Ambient1 ambient1(
    medium=medium,
    constantAmbientPressure=100000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  IDEAS.Thermal.Components.BaseClasses.Ambient1 ambient(
    medium=medium,
    constantAmbientPressure=100000,
    constantAmbientTemperature=303.15)
    annotation (Placement(transformation(extent={{64,-80},{84,-60}})));
  IDEAS.Thermal.Components.BaseClasses.Ambient1 ambient2(
    medium=medium,
    constantAmbientPressure=100000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{-76,-76},{-56,-56}})));
  DaPModels.Hydraulic.ThreeWayValveMotor threeWayValveMotor
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
equation
  connect(flow_pump.y, pumpFlow1.m_flowSet)
                                         annotation (Line(
      points={{-77,70},{-72,70},{-72,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ctrl.y, threeWayValveMotor.ctrl)
                                      annotation (Line(
      points={{-11,68},{1,68},{1,9.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumpFlow1.flowPort_b, ambient2.flowPort) annotation (Line(
      points={{-82,0},{-86,0},{-86,-66},{-76,-66}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pumpFlow1.flowPort_a, threeWayValveMotor.flowPort_b) annotation (Line(
      points={{-62,0},{-10,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(threeWayValveMotor.flowPort_a1, ambient1.flowPort) annotation (Line(
      points={{10,0},{60,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(threeWayValveMotor.flowPort_a2, ambient.flowPort) annotation (Line(
      points={{0,-10},{0,-70},{64,-70}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end ThreeWayValveMotor;
