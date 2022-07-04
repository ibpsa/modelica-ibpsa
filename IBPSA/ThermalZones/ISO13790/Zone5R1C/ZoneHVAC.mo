within IBPSA.ThermalZones.ISO13790.Zone5R1C;
model ZoneHVAC "Thermal zone for HVAC based on 5R1C network"
  extends Zone(capMas(C=buiMas.heaC*Af - Vroo*1.2*1014)) annotation (Icon(
        coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  parameter Integer nPorts=0 "Number of fluid ports" annotation (Evaluate=true,
      Dialog(
      connectorSizing=true,
      tab="General",
      group="Ports"));
  Modelica.Blocks.Interfaces.RealInput latGains "latent gains"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}})));
  Modelica.Blocks.Math.Gain mWat_flow(k=1/h_fg)
    "Water flow rate due to latent heat gain"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Fluid.MixingVolumes.MixingVolumeMoistAir       vol(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1,
    V=Vroo,
    nPorts=nPorts)       "Air volume"
              annotation (Placement(transformation(extent={{50,110},{70,130}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports_b[nPorts](redeclare
      each final package
                    Medium = Medium)
    "fluid port for adding HVAC system"                         annotation (
      Placement(transformation(
        extent={{-34,-9},{34,9}},
        rotation=-90,
        origin={140,119}), iconTransformation(
        extent={{-38.5,-10.5},{38.5,10.5}},
        rotation=-90,
        origin={129.5,100.5})));

protected
  constant Modelica.Units.SI.SpecificEnergy h_fg=
      IBPSA.Media.Air.enthalpyOfCondensingGas(273.15 + 37)
    "Latent heat of water vapor";

equation
  connect(latGains, mWat_flow.u) annotation (Line(points={{-160,-80},{-130,-80},
          {-130,50},{-70,50},{-70,120},{-42,120}}, color={0,0,127}));
  connect(mWat_flow.y, vol.mWat_flow) annotation (Line(points={{-19,120},{28,120},
          {28,128},{48,128}}, color={0,0,127}));
  connect(TAir, vol.heatPort)
    annotation (Line(points={{40,80},{40,120},{50,120}}, color={191,0,0}));
  connect(vol.ports, ports_b) annotation (Line(points={{60,110},{60,100},{94,100},
          {94,119},{140,119}}, color={0,127,255}));
    annotation (defaultComponentName="zonHVAC",Documentation(info="<html>
<p>
This models is identical to <a href=\"modelica://IBPSA.ThermalZones.ISO13790.Zone5R1C.Zone\">
IBPSA.ThermalZones.ISO13790.Zone5R1C.Zone</a>, except that a mixing volume is added
for integration of HVAC systems based on fluid models. Latent heat gains are 
also considered. 
</p>
</html>",
revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>
Mass data for heavy building
</p>
</html>"));
end ZoneHVAC;
