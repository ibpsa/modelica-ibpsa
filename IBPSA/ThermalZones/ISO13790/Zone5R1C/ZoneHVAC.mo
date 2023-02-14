within IBPSA.ThermalZones.ISO13790.Zone5R1C;
model ZoneHVAC "Thermal zone for HVAC based on 5R1C network"
  extends Zone(capMas(C=buiMas.heaC*AFlo - VRoo*1.2*1014));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  parameter Integer nPorts=0 "Number of fluid ports" annotation (Evaluate=true,
      Dialog(
      connectorSizing=true,
      tab="General",
      group="Ports"));
  Modelica.Blocks.Interfaces.RealInput intLatGai(final unit="W") "Internal latent heat gains"
    annotation (Placement(transformation(extent={{-180,30},{-140,70}}),
        iconTransformation(extent={{-180,20},{-140,60}})));
  Modelica.Blocks.Math.Gain mWat_flow(k=1/h_fg) "Water flow rate due to latent heat gain"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Fluid.MixingVolumes.MixingVolumeMoistAir vol(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1,
    V=VRoo,
    nPorts=nPorts) "Air volume"
    annotation (Placement(transformation(extent={{-50,32},{-30,52}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports_b[nPorts](
    redeclare each final package Medium = Medium)
     "fluid port for adding HVAC system"
    annotation (
      Placement(transformation(
        extent={{-39,-10},{39,10}},
        rotation=90,
        origin={-140,-79}),iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=-90,
        origin={-130,-80})));
protected
  constant Modelica.Units.SI.SpecificEnergy h_fg=
      IBPSA.Media.Air.enthalpyOfCondensingGas(273.15 + 37) "Latent heat of water vapor";

equation
  connect(mWat_flow.y, vol.mWat_flow) annotation (Line(points={{-79,50},{-52,50}},
                              color={0,0,127}));
  connect(heaPorAir, vol.heatPort) annotation (Line(points={{40,80},{26,80},{26,
          26},{-54,26},{-54,42},{-50,42}}, color={191,0,0}));
  connect(vol.ports, ports_b) annotation (Line(points={{-40,32},{-40,20},{-128,
          20},{-128,-80},{-140,-80},{-140,-79}},
                               color={0,127,255}));
  connect(intLatGai, mWat_flow.u) annotation (Line(points={{-160,50},{-102,50}},
                                                     color={0,0,127}));
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
</html>"),
    Icon(graphics={Text(
          extent={{-180,94},{-116,48}},
          textColor={0,0,88},
          textString="intLatGai")}));
end ZoneHVAC;
