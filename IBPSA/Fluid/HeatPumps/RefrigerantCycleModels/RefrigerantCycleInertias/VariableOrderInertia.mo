within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.RefrigerantCycleInertias;
model VariableOrderInertia
  "Inertia using a critical damper with variable order"
  extends BaseClasses.PartialInertia;

  parameter Modelica.Units.SI.Frequency refIneFreConst
    "Cut off frequency for inertia of refrigerant cycle" annotation (
      Dialog(enable=use_refIne, group="Refrigerant inertia"),
            Evaluate=true);
  parameter Integer nthOrd=3 "Order of refrigerant cycle interia"
    annotation (Dialog(enable=use_refIne, group="Refrigerant inertia"));
  parameter Real x_start[nthOrd]=zeros(nthOrd)
    "Initial or guess values of states" annotation (Dialog(
      tab="Initialization",
      group="Refrigerant inertia",
      enable=use_refIne));
  parameter Real yRefIne_start=0 "Initial or guess value of output (= state)"
    annotation (Dialog(tab="Initialization", group="Refrigerant inertia",
      enable=initType == Init.InitialOutput and use_refIne));
  Modelica.Blocks.Continuous.CriticalDamping criDam(
    final n=nthOrd,
    final f=refIneFreConst,
    initType=initType,
    final x_start=x_start) "Variable order damping model"
    annotation (Placement(transformation(extent={{-16,-16},{16,16}})));
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
    "Type of initialization (1: no init, 2: 
    steady state, 3: initial state, 4: initial output)";
equation
  connect(u, criDam.u)
    annotation (Line(points={{-120,0},{-19.2,0}}, color={0,0,127}));
  connect(criDam.y, y)
    annotation (Line(points={{17.6,0},{110,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Model that uses a variable order delay to account for inertia.</p>
<p>Following the associated publication by W&uuml;llhorst et. al., 
this model was used to calibrate the heat pump model.</p>
<p>In usage, be careful with the order of the delay. 
While a second or third order delay may result in a better fit
in calibration, simulation speed is impacted. </p>
<p>See the discussion in the paper for more information: 
<a href=\"https://doi.org/10.3384/ecp21181561\">
https://doi.org/10.3384/ecp21181561 </a></p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"), Icon(graphics={
        Line(origin={-15.976,-8.521},
          points = {{96.962,55.158},{16.42,50.489},{-18.988,18.583},
          {-32.024,-53.479},{-62.024,-73.479}},
          color = {0,0,127},
          smooth = Smooth.Bezier),
        Polygon(lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{-77.704,88.6305},{-85.704,66.6305},{-69.704,66.6305},
          {-77.704,88.6305}}),
        Line(points={{-78.69,75.6256},{-78.69,-92.374}},
          color={192,192,192}),
        Line(points={{-88,-82},{84,-82}},
          color={192,192,192}),
        Polygon(lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{92,-82},{70,-74},{70,-90},{92,-82}})}));
end VariableOrderInertia;
