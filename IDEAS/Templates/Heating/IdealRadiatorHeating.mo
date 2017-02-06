within IDEAS.Templates.Heating;
model IdealRadiatorHeating "Ideal heating, no DHW, with radiators"
  extends IDEAS.Templates.Heating.Interfaces.Partial_IdealHeating;
  extends IDEAS.Templates.Interfaces.BaseClasses.HeatingSystem(
    final isHea = true,
    final isCoo = false,
      nConvPorts = nZones,
      nRadPorts = nZones,
      nTemSen = nZones,
      nEmbPorts=0,
    nLoads=1);

equation
   for i in 1:nZones loop
     if noEvent((TSet[i] - TSensor[i]) > 0) then
       QHeatZone[i] = IDEAS.Utilities.Math.Functions.smoothMin(x1=C[i]*(TSet[i] - TSensor[i])/t, x2=QNom[i],deltaX=1);
     else
       QHeatZone[i] = 0;
     end if;
     heatPortRad[i].Q_flow = -fractionRad[i]*QHeatZone[i];
     heatPortCon[i].Q_flow = -(1 - fractionRad[i])*QHeatZone[i];
   end for;
  QHeaSys = sum(QHeatZone);

  P[1] = QHeaSys/COP;
  Q[1] = 0;
  annotation (Documentation(info="<html>
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
<li>2013 June, Roel De Coninck: reworking interface and documentation</li>
<li>2011, Roel De Coninck: first version</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}}),
                         graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,100}}),
        graphics));
end IdealRadiatorHeating;
