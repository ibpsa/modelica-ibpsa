within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses;
partial model partialInternalHEX
  "Partial model to implement the internal heat exchanger of a borehole segment"

  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.Template
    borFieDat "Borefield parameters"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium"
    annotation (choicesAllMatching = true);

  parameter Real mSenFac=1
    "Factor for scaling the sensible thermal mass of the volume"
    annotation (Dialog(group="Advanced"));
  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material"
    annotation (Dialog(tab="Dynamics"));
  parameter Modelica.SIunits.Length hSeg
    "Length of the internal heat exchanger";
  parameter Modelica.SIunits.Volume VTubSeg = hSeg*Modelica.Constants.pi*(borFieDat.conDat.rTub-borFieDat.conDat.eTub)^2
    "Fluid volume in each tube";
  parameter Modelica.SIunits.Temperature T_start
    "Start value of fluid temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature TGro_start
    "Start value of grout temperature"
    annotation (Dialog(tab="Initialization"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

protected
  parameter Modelica.SIunits.SpecificHeatCapacity cpMed=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Specific heat capacity of the fluid";
  parameter Modelica.SIunits.ThermalConductivity kMed=
      Medium.thermalConductivity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Thermal conductivity of the fluid";
  parameter Modelica.SIunits.DynamicViscosity muMed=Medium.dynamicViscosity(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Dynamic viscosity of the fluid";

  parameter Real Rgb_val(fixed=false)
    "Thermal resistance between grout zone and borehole wall";
  parameter Real RCondGro_val(fixed=false)
    "Thermal resistance between: pipe wall to capacity in grout";
  parameter Real x(fixed=false) "Capacity location";

initial equation
  assert(borFieDat.conDat.rBor > borFieDat.conDat.xC + borFieDat.conDat.rTub and
         0 < borFieDat.conDat.xC - borFieDat.conDat.rTub,
         "The borehole geometry is not physical. Check the borefield data record
         to ensure that the shank spacing is larger than the outer tube radius
         and that the borehole radius is sufficiently large.");

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Partial model to implement models simulating the thermal and fluid behaviour of a borehole segment.
</p>
<p>
The thermodynamic properties of the fluid circulating in the borehole are calculated
as protected parameters in this partial model: <i>c<sub>p</sub></i> (<code>cpMed</code>),
<i>k</i> (<code>kMed</code>) and <i>&mu;</i> (<code>muMed</code>). Additionally, the
following parameters are already declared as protected parameters and thus do not
need to be declared in models which extend this partial model:
</p>
<ul>
<li>
<code>Rgb_val</code> (Thermal resistance between grout zone and borehole wall)
</li>
<li>
<code>RCondGro_val</code> (Thermal resistance between pipe wall and capacity in grout)
</li>
<li>
<code>x</code> (Grout capacity location)
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialInternalHEX;
