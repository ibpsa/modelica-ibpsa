within IBPSA.Fluid.PlugFlowPipes;
model PlugFlowPipe
  "Pipe model using spatialDistribution for temperature delay with modified delay tracker"
  extends IBPSA.Fluid.Interfaces.PartialTwoPort_vector;
  parameter Modelica.SIunits.Diameter diameter(start=0.100, min=0)
    "Pipe diameter";
  parameter Modelica.SIunits.Length length(min=0) "Pipe length";
  parameter Modelica.SIunits.Length thicknessIns(min=0, start=0.0032)
    "Thickness of pipe insulation";

  /*parameter Modelica.SIunits.ThermalConductivity k = 0.005 
    "Heat conductivity of pipe's surroundings";*/

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0, start=0.2)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  parameter Modelica.SIunits.ThermalConductivity lambdaI(min=0.0001, start=0.026)
    "Heat conductivity";

  parameter Modelica.SIunits.SpecificHeatCapacity cpipe(start=500) "For steel";
  parameter Modelica.SIunits.Density rho_wall(start=8000) "For steel";
  final parameter Modelica.SIunits.Volume V=walCap/(rho_default*cp_default)
    "Equivalent water volume to represent pipe wall thermal inertia";

  parameter Modelica.SIunits.Length thickness(start=0.002, min=0)
    "Pipe wall thickness";

  parameter Modelica.SIunits.Temperature T_ini_in(start=Medium.T_default)=
    Medium.T_default "Initialization temperature at pipe inlet"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_ini_out(start=Medium.T_default)=
    Medium.T_default "Initialization temperature at pipe outlet"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean initDelay(start=false) = false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.MassFlowRate m_flowInit(start=0)
    annotation (Dialog(tab="Initialization", enable=initDelay));

  parameter Types.ThermalResistanceLength R=1/(lambdaI*2*Modelica.Constants.pi/
      Modelica.Math.log((diameter/2 + thicknessIns)/(diameter/2)));
  parameter Types.ThermalCapacityPerLength C=rho_default*Modelica.Constants.pi*(
      diameter/2)^2*cp_default;

public
  BaseClasses.PipeCore pipeCore(
    redeclare package Medium = Medium,
    diameter=diameter,
    length=length,
    thicknessIns=thicknessIns,
    C=C,
    R=R,
    m_flow_small=m_flow_small,
    m_flow_nominal=m_flow_nominal,
    T_ini_in=T_ini_in,
    T_ini_out=T_ini_out,
    m_flowInit=m_flowInit,
    initDelay=initDelay) "Describing the pipe behavior"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=V,
    nPorts=nPorts + 1,
    T_start=T_ini_out,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

protected
  parameter Modelica.SIunits.HeatCapacity walCap=length*((diameter + 2*
      thickness)^2 - diameter^2)*Modelica.Constants.pi/4*cpipe*rho_wall
    "Heat capacity of pipe wall";

  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";

  parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation (Dialog(group="Advanced"));

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";

equation
  for i in 1:nPorts loop
    connect(vol.ports[i + 1], ports_b[i]);
  end for annotation (Line(points={{70,20},{72,20},{72,6},{72,0},{100,0}},
        color={0,127,255}));
  connect(pipeCore.heatPort, heatPort)
    annotation (Line(points={{0,10},{0,10},{0,100}}, color={191,0,0}));

  connect(pipeCore.port_b, vol.ports[1])
    annotation (Line(points={{10,0},{70,0},{70,20}}, color={0,127,255}));

  connect(pipeCore.port_a, port_a)
    annotation (Line(points={{-10,0},{-56,0},{-100,0}}, color={0,127,255}));
  annotation (
    Line(points={{70,20},{72,20},{72,0},{100,0}}, color={0,127,255}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,30},{100,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,50},{100,40}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,-40},{100,-50}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{0,100},{40,62},{20,62},{20,38},{-20,38},{-20,62},{-40,62},{0,
              100}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,30},{28,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187}),
        Text(
          extent={{-100,-72},{100,-88}},
          lineColor={0,0,0},
          textString="L = %length
d = %diameter")}),
    Documentation(revisions="<html>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">July 4, 2016 by Bram van der Heijde:<br>Introduce <code></span><span style=\"font-family: Courier New,courier;\">pipVol</code></span><span style=\"font-family: MS Shell Dlg 2;\">.</span></li>
<li>October 10, 2015 by Marcus Fuchs:<br>Copy Icon from KUL implementation and rename model; Replace resistance and temperature delay by an adiabatic pipe; </li>
<li>September, 2015 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>", info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Implementation of a pipe with heat loss using the time delay based heat losses and the spatialDistribution operator for the temperature wave propagation through the length of the pipe. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The heat loss component adds a heat loss in design direction, and leaves the enthalpy unchanged in opposite flow direction. Therefore it is used in front of and behind the time delay. The delay time is calculated once on the pipe level and supplied to both heat loss operators. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This component uses a modified delay operator.</span></p>
</html>"));
end PlugFlowPipe;
