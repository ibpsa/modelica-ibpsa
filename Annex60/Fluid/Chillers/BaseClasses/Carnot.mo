within Annex60.Fluid.Chillers.BaseClasses;
partial model Carnot

  parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal(max=0)
    "Nominal cooling heat flow rate (QEva_flow_nominal < 0)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate QCon_flow_nominal(min=0)
    "Nominal heating flow rate";

  parameter Annex60.Fluid.Types.EfficiencyInput effInpEva=
    Annex60.Fluid.Types.EfficiencyInput.volume
    "Temperatures of evaporator fluid used to compute Carnot efficiency"
    annotation (Dialog(tab="Advanced", group="Temperature dependence"));
  parameter Annex60.Fluid.Types.EfficiencyInput effInpCon=
    Annex60.Fluid.Types.EfficiencyInput.port_a
    "Temperatures of condenser fluid used to compute Carnot efficiency"
    annotation (Dialog(tab="Advanced", group="Temperature dependence"));

  // fixme: the change in sign convention for dTEva_nominal need to be added
  //        to the revision notes if this parameter is not removed
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal(max=0) = -10
    "Temperature difference evaporator outlet-inlet"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal(min=0) = 10
    "Temperature difference condenser outlet-inlet"
    annotation (Dialog(group="Nominal condition"));

  // Efficiency
  parameter Boolean use_eta_Carnot = true
    "Set to true to use Carnot effectiveness etaCar rather than COP_nominal"
    annotation(Dialog(group="Efficiency"));
  parameter Real etaCar(unit="1", fixed=use_eta_Carnot)
    "Carnot effectiveness (=COP/COP_Carnot) used if use_eta_Carnot = true"
    annotation (Dialog(group="Efficiency", enable=use_eta_Carnot));

  parameter Real COP_nominal(unit="1", fixed=not use_eta_Carnot)
    "Coefficient of performance at TEva_nominal and TCon_nominal, used if use_eta_Carnot = false"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));

  parameter Modelica.SIunits.Temperature TCon_nominal = 303.15
    "Condenser temperature used to compute COP_nominal if use_eta_Carnot=false"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));
  parameter Modelica.SIunits.Temperature TEva_nominal = 278.15
    "Evaporator temperature used to compute COP_nominal if use_eta_Carnot=false"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));

  parameter Real a[:] = {1}
    "Coefficients for efficiency curve (need p(a=a, yPL=1)=1)"
    annotation (Dialog(group="Efficiency"));

  Modelica.SIunits.Temperature TCon(start=TCon_nominal)
    "Condenser temperature used to compute efficiency";
  Modelica.SIunits.Temperature TEva(start=TEva_nominal)
    "Evaporator temperature used to compute efficiency";

  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Actual heating heat flow rate added to fluid 1"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W") "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput QEva_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Actual cooling heat flow rate removed from fluid 2"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

  input Real etaPL(final unit = "1")
    "Efficiency due to part load of compressor (etaPL(yPL=1)=1)";

  Real COPCar(min=0) = TUse / Annex60.Utilities.Math.Functions.smoothMax(
    x1=1,
    x2=TCon-TEva,
    deltaX=0.25) "Carnot efficiency";

protected
  constant Boolean COP_is_for_cooling
    "Set to true if the specified COP is for cooling";
  final parameter Modelica.SIunits.Temperature TUse_nominal=
   if COP_is_for_cooling then TEva_nominal else TCon_nominal
    "Nominal evaporator temperature for chiller or condenser temperature for heat pump";
  Modelica.SIunits.Temperature TUse = if COP_is_for_cooling then TEva else TCon
    "Temperature of useful heat (evaporator for chiller, condenser for heat pump";

initial equation
  // Because in Annex60 2.1, dTEve_nominal was positive, we just
  // write a warning for now.
  assert(dTEva_nominal < 0,
        "Parameter dTEva_nominal must be negative. In the future, this will trigger  an error.",
        level=AssertionLevel.warning);
  assert(dTCon_nominal > 0, "Parameter dTCon_nominal must be positive.");

  assert(abs(Annex60.Utilities.Math.Functions.polynomial(
         a=a, x=1)-1) < 0.01, "Efficiency curve is wrong. Need etaPL(y=1)=1.");
  assert(etaCar > 0.1, "Parameters lead to etaCar < 0.1. Check parameters.");
  assert(etaCar < 1,   "Parameters lead to etaCar > 1. Check parameters.");

  COP_nominal = etaCar * TUse_nominal/(TCon_nominal-TEva_nominal);

  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,64},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-56},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{0,68},{0,90},{90,90},{100,90}},
                                                 color={0,0,255}),
        Line(points={{0,-70},{0,-90},{100,-90}}, color={0,0,255}),
        Line(points={{62,0},{100,0}},                 color={0,0,255})}));
end Carnot;
