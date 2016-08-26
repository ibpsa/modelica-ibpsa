within IDEAS.Buildings.Components.ZoneAirModels;
partial model PartialAirModel "Partial for air models"
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare replaceable package Medium = IDEAS.Media.Air);

  parameter Integer nSurf "Number of connected surfaces";
  parameter Integer nSeg(min=1)=1 "Number of air segments";
  parameter Modelica.SIunits.Volume Vtot "Total zone air volume";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal in medium, false restricts to design direction (ports[1] -> ports[2]). Used only if model has two ports.";
  parameter Real n50=0.4 "n50-value of airtightness";
  parameter Real n50toAch = 20 "Conversion fractor from n50 to Air Change Rate";
  parameter Boolean useFluPor = true "Set to false to remove fluid ports";
  constant Boolean computeTSensorAsFunctionOfZoneAir = true "Set to false if TSensor in zone model should not take into account the value of the zone air temperature";
  Modelica.Blocks.Interfaces.RealOutput E(unit="J") "Model internal energy";
  Modelica.Blocks.Interfaces.RealOutput QGai(unit="J/s") "Model internal energy";
  Modelica.Blocks.Interfaces.RealOutput TAir "Zone air temperature"
    annotation (Placement(transformation(extent={{98,-70},{118,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSurf] ports_surf
    "Heat convection ports for surfaces"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] inc
    "Inclination angle of surface"
    annotation (Placement(transformation(extent={{-128,60},{-88,100}})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] A
    annotation (Placement(transformation(extent={{-126,-80},{-86,-40}})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] azi "Azimuth of surface"
    annotation (Placement(transformation(extent={{-128,20},{-88,60}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) if useFluPor
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) if useFluPor
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  outer BoundaryConditions.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSeg] ports_air
    "Heat convection ports for air volumes"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow
    "Moisture mass flow rate being added to the zone air"
    annotation (Placement(transformation(extent={{128,60},{88,100}})));
  Modelica.Blocks.Interfaces.RealInput C_flow[max(Medium.nC,1)]
    "Trace substance mass flow rate being added to the zone air"
    annotation (Placement(transformation(extent={{128,20},{88,60}})));
  Modelica.Blocks.Interfaces.RealOutput phi "Zone air relative humidity"
    annotation (Placement(transformation(extent={{98,-50},{118,-30}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(revisions="<html>
<ul>
<li>
August 26, 2016 by Filip Jorissen:<br/>
Added support for conservation of energy.
</li>
<li>
April 30, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialAirModel;
