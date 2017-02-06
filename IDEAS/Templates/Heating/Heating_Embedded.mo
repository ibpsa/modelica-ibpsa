within IDEAS.Templates.Heating;
model Heating_Embedded
  replaceable parameter
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar[nEmbPorts] RadSlaCha constrainedby
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar
    "Properties of the floor heating or TABS, if present";
  parameter Modelica.SIunits.Area AEmb[nEmbPorts]
    "surface of each embedded circuit";
  extends IDEAS.Templates.Heating.Interfaces.Partial_HydraulicHeating(
    final isHea=true,
    final isCoo=false,
    nConvPorts=nZones,
    nRadPorts=nZones,
    nTemSen=nZones,
    nEmbPorts=nZones,
    nLoads=1,
    nZones=1,
    minSup=true,
    TSupMin=273.15 + 25,
    redeclare IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe emission[
      nEmbPorts](
      redeclare each package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      m_flowMin=m_flow_nominal/3,
      RadSlaCha=RadSlaCha,
      A_floor=AEmb,
      each nParCir=1));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow prescribedHeatFlow[
    nConvPorts](each Q_flow=0)
    annotation (Placement(transformation(extent={{-164,10},{-184,30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow prescribedHeatFlow1[
    nRadPorts](each Q_flow=0)
    annotation (Placement(transformation(extent={{-162,-30},{-182,-10}})));
equation
  QHeaSys = -sum(emission.heatPortEmb.Q_flow);
  P[1] = heater.PEl + sum(pumpRad.P);
  Q[1] = 0;
  connect(emission[:].heatPortEmb[1], heatPortEmb[:]) annotation (Line(
      points={{135,44},{136,44},{136,98},{-176,98},{-176,60},{-200,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, heatPortCon) annotation (Line(
      points={{-184,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow1.port, heatPortRad) annotation (Line(
      points={{-182,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{
            200,100}}),
                    graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,100}})),
    Documentation(info="<html>
<p>
This example model illustrates how heating systems may be used.
Its implementation may not reflect best modelling practices.
</p>
</html>", revisions="<html>
<ul>
<li>
January 23, 2017 by Filip Jorissen and Glenn Reynders:<br/>
Revised implementation and documentation.
</li>
<li>2013 June, Roel De Coninck: first version</li>
</ul>
</html>"));
end Heating_Embedded;
