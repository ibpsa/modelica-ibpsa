within IBPSA.Utilities.IO.SDF.Examples;
model InterpolationMethods "Interpolate a sampled signal using different interpolation methods"
  extends Modelica.Icons.Example;

  parameter Real x[:] = linspace(0,2,6) * Modelica.Constants.pi;
  parameter Real y[size(x, 1)] = Modelica.Math.sin(x);
  parameter Real data[:] = cat(1, {1}, {size(x, 1)}, x, y);

  parameter String filename = Modelica.Utilities.Files.loadResource("modelica://IBPSA/Utilities/IO/SDF/Resources/Data/Examples/sine.sdf");
  parameter String dataset = "/y";

  NDTable linear(
    nin=1,
    readFromFile=false,
    data=data,
    interpMethod=SDF.Types.InterpolationMethod.Linear,
    extrapMethod=SDF.Types.ExtrapolationMethod.Linear,
    filename=filename,
    dataset=dataset)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    offset=-1,
    height=8.3)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

  NDTable hold(
    nin=1,
    readFromFile=false,
    data=data,
    interpMethod=SDF.Types.InterpolationMethod.Hold,
    extrapMethod=SDF.Types.ExtrapolationMethod.Hold,
    filename=filename,
    dataset=dataset)
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  NDTable akima(
    nin=1,
    readFromFile=false,
    data=data,
    interpMethod=SDF.Types.InterpolationMethod.Akima,
    extrapMethod=SDF.Types.ExtrapolationMethod.Linear,
    filename=filename,
    dataset=dataset)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  NDTable nearest(
    nin=1,
    readFromFile=false,
    data=data,
    interpMethod=SDF.Types.InterpolationMethod.Nearest,
    extrapMethod=SDF.Types.ExtrapolationMethod.Hold,
    filename=filename,
    dataset=dataset)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  NDTable fritsch_butland(
    nin=1,
    readFromFile=false,
    data=data,
    extrapMethod=SDF.Types.ExtrapolationMethod.Linear,
    interpMethod=SDF.Types.InterpolationMethod.FritschButland,
    filename=filename,
    dataset=dataset)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  NDTable steffen(
    nin=1,
    readFromFile=false,
    data=data,
    extrapMethod=SDF.Types.ExtrapolationMethod.Linear,
    interpMethod=SDF.Types.InterpolationMethod.Steffen,
    filename=filename,
    dataset=dataset)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

equation
  connect(ramp.y, hold.u[1]) annotation (Line(points={{-49,0},{-30,0},{-30,100},
          {-12,100}},
                    color={0,0,127}));
  connect(ramp.y, akima.u[1]) annotation (Line(points={{-49,0},{-30,0},{-30,-20},
          {-12,-20}}, color={0,0,127}));
  connect(ramp.y, linear.u[1]) annotation (Line(points={{-49,0},{-30,0},{-30,20},
          {-12,20}},                  color={0,0,127}));
  connect(ramp.y, nearest.u[1]) annotation (Line(points={{-49,0},{-30,0},{-30,
          60},{-12,60}},
                     color={0,0,127}));
  connect(ramp.y, fritsch_butland.u[1]) annotation (Line(points={{-49,0},{-30,0},
          {-30,-60},{-12,-60}}, color={0,0,127}));
  connect(ramp.y, steffen.u[1]) annotation (Line(points={{-49,0},{-30,0},{-30,
          -100},{-12,-100}},
                      color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{
            100,120}})),
    Icon(coordinateSystem(extent={{-100,-80},{100,100}})));
end InterpolationMethods;
