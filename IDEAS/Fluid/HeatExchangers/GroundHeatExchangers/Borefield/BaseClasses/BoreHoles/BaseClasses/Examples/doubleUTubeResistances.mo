within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.Examples;
model doubleUTubeResistances "Validation of singleUTubeResistance by comparing the obtained Rb and Ra values to the values obtained by EED. The values should be close to parameters _ref. 
  The differences are due to numerical noise, as the same formula's give better results in Python."
  extends Modelica.Icons.Example;

  parameter Boolean use_Rb = false
    "True if the value Rb should be used instead of calculated";
  parameter Real Rb(unit="(m.K)/W") = 0.082 "Borehole thermal resistance";
  parameter Modelica.SIunits.Height hSeg = 110 "Height of the element";
  parameter Modelica.SIunits.Radius rBor = 0.11/2 "Radius of the borehole";
  // Geometry of the pipe
  parameter Modelica.SIunits.Radius rTub = 0.032/2 "Radius of the tube";
  parameter Modelica.SIunits.Length eTub = 0.003 "Thickness of the tubes";
  parameter Modelica.SIunits.Length sha = 0.07/2
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole";

  // Thermal properties
  parameter Modelica.SIunits.ThermalConductivity kFil = 0.6
    "Thermal conductivity of the grout";
  parameter Modelica.SIunits.ThermalConductivity kSoi = 3.5
    "Thermal conductivity of the soi";
  parameter Modelica.SIunits.ThermalConductivity kTub = 0.42
    "Thermal conductivity of the tube";

  // thermal properties
  parameter Modelica.SIunits.ThermalConductivity kMed = 0.48
    "Thermal conductivity of the fluid";
  parameter Modelica.SIunits.DynamicViscosity mueMed = 0.0052
    "Dynamic viscosity of the fluid";
  parameter Modelica.SIunits.SpecificHeatCapacity cpMed = 3795
    "Specific heat capacity of the fluid";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 2
    "Nominal mass flow rate";

  Real Rgb_val(fixed=false);
  Real Rgg_val(fixed=false);
  Real RCondGro_val(fixed=false);
  Real x(fixed=false);

  parameter Real Rb_ref =  0.08328;
  parameter Real Ra_ref =  0.3;
  parameter Real RConv_ref =  0.00531;
  parameter Real RCondPipe_ref =  0.07868;
equation
    (x, Rgb_val, Rgg_val, RCondGro_val) =
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.doubleUTubeResistances(hSeg=hSeg,
    rBor=rBor,
    rTub=rTub,
    eTub=eTub,
    sha=sha,
    kFil=kFil,
    kSoi=kSoi,
    kTub=kTub,
    use_Rb=use_Rb,
    Rb = Rb,
    kMed=kMed,
    mueMed=mueMed,
    cpMed=cpMed,
    m_flow_nominal=m_flow_nominal,
    printDebug=true);

  annotation (experiment, __Dymola_experimentSetupOutput);
end doubleUTubeResistances;
