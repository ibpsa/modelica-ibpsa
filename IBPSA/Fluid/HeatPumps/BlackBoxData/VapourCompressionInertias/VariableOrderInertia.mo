within IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias;
model VariableOrderInertia
  "Inertia using a critical damper with variable order"
  extends BaseClasses.PartialInertia;

  parameter Modelica.Units.SI.Frequency refIneFre_constant
    "Cut off frequency for inertia of refrigerant cycle" annotation (Dialog(
        enable=use_refIne, group="Refrigerant inertia"), Evaluate=true);
  parameter Integer nthOrder=3 "Order of refrigerant cycle interia" annotation (Dialog(enable=
          use_refIne, group="Refrigerant inertia"));
  parameter Real x_start[nthOrder]=zeros(nthOrder)
    "Initial or guess values of states"
    annotation (Dialog(tab="Initialization", group="Refrigerant inertia", enable=use_refIne));
  parameter Real yRefIne_start=0 "Initial or guess value of output (= state)"
    annotation (Dialog(tab="Initialization", group="Refrigerant inertia",enable=initType ==
          Init.InitialOutput and use_refIne));
  Modelica.Blocks.Continuous.CriticalDamping criticalDamping(
    final n=nthOrder,
    final f=refIneFre_constant,
    initType=initType,
    final x_start=x_start)
    annotation (Placement(transformation(extent={{-16,-16},{16,16}})));
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)";
equation
  connect(u, criticalDamping.u)
    annotation (Line(points={{-120,0},{-19.2,0}}, color={0,0,127}));
  connect(criticalDamping.y, y)
    annotation (Line(points={{17.6,0},{110,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Model that uses a variable order delay to account for inertia.</p>
<p>Following the associated publication by W&uuml;llhorst et. al., this model was used to calibrate the heat pump model.</p>
<p>In usage, be careful with the order of the delay. While a second or third order delay may result in a better fit in calibration, simulation speed is impacted. </p>
<p>See the discussion in the paper for more information.</p>
</html>"));
end VariableOrderInertia;
