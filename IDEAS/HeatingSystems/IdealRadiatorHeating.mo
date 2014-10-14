within IDEAS.HeatingSystems;
model IdealRadiatorHeating "Ideal heating, no DHW, with radiators"
  extends IDEAS.HeatingSystems.Interfaces.Partial_IdealHeating;
  extends IDEAS.Interfaces.BaseClasses.HeatingSystem(
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
<p><b>Description</b> </p>
<p>Ideal heating (no hydraulics) but with limited power <i>QNom</i> per zone. There are no radiators. This model assumes a thermal inertia of each zone and computes the heat flux that would be required to heat up the zone to the set point within a time <i>t</i>. This heat flux is limited to <i>QNom</i> and splitted in a radiative and a convective part which are imposed on the heatPorts <i>heatPortRad</i> and <i>heatPortCon</i> respectively. A COP can be passed in order to compute the electricity consumption of the heating.</p>
<p><u>Note</u>: the responsiveness of the system is influenced by the time constant <i>t</i>.  For small values of<i> t</i>, this system is close to ideal, but for larger values, there may still be deviations between the zone temperature and it&apos;s set point. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>No inertia; responsiveness modelled by time constant <i>t</i> for reaching the temperature set point. </li>
<li>Limited output power according to <i>QNom[nZones]</i></li>
<li>Heat emitted through <i>heatPortRad</i> and <i>heatPortCon</i> </li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Connect the heating system to the corresponding heatPorts of a <a href=\"modelica://IDEAS.Interfaces.BaseClasses.Structure\">structure</a>. </li>
<li>Connect <i>TSet</i> and <i>TSensor</i> </li>
<li>Connect <i>plugLoad </i>to an inhome grid. A<a href=\"modelica://IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder\"> dummy inhome grid like this</a> has to be used if no inhome grid is to be modelled. </li>
<li>Set all parameters that are required. </li>
</ol></p>
<p><h4>Validation </h4></p>
<p>No validation performed.</p>
<p><h4>Example </h4></p>
<p>An example of the use of this model can be found in<a href=\"modelica://IDEAS.Thermal.HeatingSystems.Examples.IdealRadiatorHeating\"> IDEAS.Thermal.HeatingSystems.Examples.IdealRadiatorHeating</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: reworking interface and documentation</li>
<li>2011, Roel De Coninck: first version</li>
</ul></p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}}),
                         graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,100}}),
        graphics));
end IdealRadiatorHeating;
