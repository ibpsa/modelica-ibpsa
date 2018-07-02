within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses;
partial model partialInternalHEX

  parameter Data.BorefieldData.Template borFieDat "Borefield parameters"
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
  parameter Modelica.SIunits.Volume VTubSeg = hSeg*Modelica.Constants.pi*borFieDat.conDat.rTub^2
    "Fluid volume in each tube";
  parameter Modelica.SIunits.Temperature T_start
    "Initial temperature of the filling material and fluid"
    annotation (Dialog(group="Filling material"));

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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end partialInternalHEX;
