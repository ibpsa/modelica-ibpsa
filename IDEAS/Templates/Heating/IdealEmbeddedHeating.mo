within IDEAS.Templates.Heating;
model IdealEmbeddedHeating
  "Ideal heating, no DHW, with embedded system (eg. floor heating) "
  extends IDEAS.Templates.Heating.Interfaces.Partial_IdealHeating;
  extends IDEAS.Templates.Interfaces.BaseClasses.HeatingSystem(
    final isHea = true,
    final isCoo = false,
    nConvPorts = nZones,
    nRadPorts = nZones,
    nTemSen = nZones,
    nEmbPorts=nZones,
    nLoads=1);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow prescribedHeatFlow1[
    nRadPorts](each Q_flow=0)
    annotation (Placement(transformation(extent={{-142,-30},{-162,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow prescribedHeatFlow[
    nConvPorts](each Q_flow=0)
    annotation (Placement(transformation(extent={{-144,10},{-164,30}})));
equation
  for i in 1:nZones loop
    if noEvent((TSet[i] - TSensor[i]) > 0) then
      QHeatZone[i] = IDEAS.Utilities.Math.Functions.smoothMin(x1=C[i]*(TSet[i] - TSensor[i])/t, x2=QNom[i],deltaX=1);
    else
      QHeatZone[i] = 0;
    end if;
    heatPortEmb[i].Q_flow = -QHeatZone[i];
  end for;
  QHeaSys = sum(QHeatZone);
  P[1] = QHeaSys/COP;
  Q[1] = 0;
  connect(prescribedHeatFlow1.port, heatPortRad) annotation (Line(
      points={{-162,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, heatPortCon) annotation (Line(
      points={{-164,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Documentation(revisions="<html>
<ul>
<li>
January 23, 2017 by Filip Jorissen and Glenn Reynders:<br/>
Revised implementation and documentation.
</li>
<li>2013 June, Roel De Coninck: reworking interface and documentation</li>
<li>2011, Roel De Coninck: first version</li>
</ul>
</html>", info="<html>
<p>
This example model illustrates how heating systems may be used.
Its implementation may not reflect best modelling practices.
</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},
            {200,100}}),       graphics),
    Icon(coordinateSystem(extent={{-200,-100},{200,100}})));
end IdealEmbeddedHeating;
