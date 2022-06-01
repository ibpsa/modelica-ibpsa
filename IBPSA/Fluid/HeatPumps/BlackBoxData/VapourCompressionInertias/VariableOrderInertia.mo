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
    final x_start=x_start)
    annotation (Placement(transformation(extent={{-16,-16},{16,16}})));
equation
  connect(u, criticalDamping.u)
    annotation (Line(points={{-120,0},{-19.2,0}}, color={0,0,127}));
  connect(criticalDamping.y, y)
    annotation (Line(points={{17.6,0},{110,0}}, color={0,0,127}));
end VariableOrderInertia;
