within Annex60.Experimental.Pipe.BaseClasses;
model HeatLossDouble "Heat loss model for pipe when second pipe is present"
  extends Fluid.Interfaces.PartialTwoPortTransport;

  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.Diameter diameter "Pipe diameter";

  Boolean vBoolean;
  Real epsilon;
  Real flat_v;

  parameter Types.ThermalCapacityPerLength C
    "Capacitance of the water volume in J/(K.m)";
  parameter Types.ThermalResistanceLength Ra
    "Resistance for asymmetric problem, in Km/W";
  parameter Types.ThermalResistanceLength Rs
    "Resistance for symmetric problem, in Km/W";
  final parameter Modelica.SIunits.Time tau_char=sqrt(Ra*Rs)*C;

  parameter Modelica.SIunits.Area A_cross = Modelica.Constants.pi * diameter * diameter / 4
    "Cross sectional area";

  Modelica.SIunits.Time time_out_b "Virtual time after delay at port b";
  Modelica.SIunits.Time tau "Time delay for input time";

  Modelica.SIunits.Length x(start=0)
    "Spatial coordiante for spatialDistribution operator";
  Modelica.SIunits.Velocity v "Flow velocity of medium in pipe";

  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Tin_a
    "Temperature at port_a for in-flowing fluid";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Tout_b
    "Temperature at port_b for out-flowing fluid";

  Real lambda;

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";

public
  Modelica.Blocks.Interfaces.RealInput T_amb
    "Ambient temperature of pipe's surroundings" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealInput T_2in
    "Inlet temperature of other pipe if present" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-100})));
  Modelica.Blocks.Interfaces.RealOutput T_2out
    "Ambient temperature of pipe's surroundings" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,-100})));

equation
  dp = 0;

  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = Tout_b*cp_default;

  // Time delay
  epsilon = 1000000*Modelica.Constants.eps;
  if v  >= -epsilon then
    vBoolean = true;
  else
    vBoolean = false;
  end if;

  if abs(v) >= epsilon then
    flat_v = v;
  else
    flat_v = 0;
  end if;

  der(x) = flat_v;
  v = (V_flow / A_cross);
  (, time_out_b) = spatialDistribution(time,
                                       time,
                                       x/length,
                                       vBoolean,
                                       {0.0, 1.0},
                                       {0.0, 0.0});
  tau = max(0,time - time_out_b);

  // Heat losses
  lambda = Modelica.Math.exp(tau/tau_char);

  Tin_a = inStream(port_a.h_outflow)/cp_default;
  Tout_b = T_amb + (4*lambda*sqrt(Ra*Rs)*(Tin_a-T_amb) + (lambda^2-1)*(Rs-Ra)*(T_2in-T_amb))/(lambda^2*(Rs+Ra+2*sqrt(Rs*Ra))-(Rs+Ra-2*sqrt(Rs*Ra)));

  T_2out = Tin_a;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
          extent={{-80,80},{80,-68}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Polygon(
          points={{0,60},{38,2},{20,2},{20,-46},{-18,-46},{-18,2},{-36,2},{0,60}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>Heat losses are only considered in design direction. For heat loss consideration in both directions use one of these models at both ends of a <code><span style=\"font-family: Courier New,courier;\">TempDelaySD</span></code> model.</p>
<p>This is a simple reference model for more sophisticated implementations and does not work correctly with zero-mass flow.</p>
</html>", revisions="<html>
<ul>
<li>
September, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end HeatLossDouble;
