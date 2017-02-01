within IDEAS.Airflow.AHU.BaseClasses;
model AdsolairControllerHeaCoi
  "Adsolair controller with additional functionality for heating coil"
  extends AdsolairController;
  LimPidAdsolair                                                    PIDHeater(
    Td=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0,
    yMax=1,
    Ti=120,
    k=0.2)
    annotation (Placement(transformation(extent={{6,-86},{18,-74}})));
  Modelica.Blocks.Sources.BooleanExpression piHeaOn(y=on and not onAdiaExp.y
         and not onChiExp.y and (damPid.y > 0.97 or damPid.y < 0.03))
    "On/off status of PI controller of heating coil valve"
    annotation (Placement(transformation(extent={{-18,-78},{2,-62}})));
  Modelica.Blocks.Interfaces.RealInput THeaOut
    "Heating coil air outlet temperature" annotation (Placement(transformation(
        extent={{20,20},{-20,-20}},
        rotation=180,
        origin={-106,-128})));
  Modelica.Blocks.Interfaces.RealOutput yHea "Control signal for heating coil"
    annotation (Placement(transformation(extent={{100,-114},{120,-94}})));
  Modelica.Blocks.Continuous.Filter fil(f_cut=1/60)
    "Filter for avoiding algebraic loops between controller and valve"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
equation
  connect(piHeaOn.y, PIDHeater.on)
    annotation (Line(points={{3,-70},{9.6,-70},{9.6,-74}}, color={255,0,255}));
  connect(PIDHeater.u_s, TSet) annotation (Line(points={{4.8,-80},{-44,-80},{
          -44,20},{-106,20}}, color={0,0,127}));
  connect(PIDHeater.y, yHea) annotation (Line(points={{18.6,-80},{70,-80},{70,
          -104},{110,-104}}, color={0,0,127}));
  connect(fil.y, PIDHeater.u_m)
    annotation (Line(points={{1,-130},{12,-130},{12,-87.2}}, color={0,0,127}));
  connect(fil.u, THeaOut) annotation (Line(points={{-22,-130},{-106,-130},{-106,
          -128}}, color={0,0,127}));
end AdsolairControllerHeaCoi;
