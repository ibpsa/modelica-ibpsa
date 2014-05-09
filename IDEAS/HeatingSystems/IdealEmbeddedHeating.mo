within IDEAS.HeatingSystems;
model IdealEmbeddedHeating
  "Ideal heating, no DHW, with embedded system (eg. floor heating) "

  extends IDEAS.Interfaces.BaseClasses.HeatingSystem(
    final isHea = true,
    final isCoo = false,
    final nConvPorts = 0,
    final nRadPorts = 0,
    final nTemSen = nZones,
    final nEmbPorts=nZones,
    final nLoads=1);

  Modelica.Blocks.Interfaces.RealInput[nZones] TSet(unit="K",displayUnit="degC")=293.15*ones(nZones)
    "Set point temperature for each zones" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={4,-110}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={-2,-104})));
  parameter Real COP=3 "virtual COP to get a PEl as output";
  SI.Power[nZones] QHeatZone(each start=0);
  parameter SI.Time t=10 "Time needed to reach temperature setpoint";

  parameter Modelica.SIunits.Power[nZones] QNom(each min=0) = ones(nZones)*5000
    "Nominal power, can be seen as the max power of the emission system per zone";
  parameter Real[nZones] VZones = 50*ones(nZones)
    "Conditioned volumes of the zones";
  final parameter Modelica.SIunits.HeatCapacity[nZones] C=1012*1.204*VZones*5
    "Heat capacity of the conditioned zones (air capacity with a correction factor of 5";

equation
  for i in 1:nZones loop
    if noEvent((TSet[i] - TSensor[i]) > 0) then
      QHeatZone[i] = min(C[i]*(TSet[i] - TSensor[i])/t, QNom[i]);
    else
      QHeatZone[i] = 0;
    end if;
    heatPortEmb[i].Q_flow = -QHeatZone[i];
  end for;

  QHeaSys = sum(QHeatZone);
  // useful output, QHeatTotal defined in partial
  P[1] = QHeaSys/COP;
  Q[1] = 0;

  annotation (Documentation(revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: reworking interface and documentation</li>
<li>2011, Roel De Coninck: first version</li>
</ul></p>
</html>", info="<html>
<p><b>Description</b> </p>
<p>Ideal heating (no hydraulics) based on embedded heat emission, but with limited power <i>QNom</i> per zone. This model assumes a thermal inertia of each zone and computes the heat flux that would be required to heat up the zone to the set point within a time <i>t</i>. This heat flux is limited to <i>QNom</i> and imposed on the heatPort <i>heatPortEmb</i>. A COP can be passed in order to compute the electricity consumption of the heating.</p>
<p><u>Note</u>: the responsiveness of the system is influenced by the time constant <i>t </i>and of course by the inertia of the embedded system in which the heat is injected. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>No inertia in this model (but inertia supposed in the embedded system to which this model will be linked); responsiveness modelled by time constant <i>t</i> for reaching the temperature set point. </li>
<li>Limited output power according to <i>QNom[nZones]</i></li>
<li>Heat emitted through <i>heatPortEmb</i> </li>
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
<p>An example of the use of this model can be found in<a href=\"modelica://IDEAS.Thermal.HeatingSystems.Examples.IdealEmbeddedHeating\"> IDEAS.Thermal.HeatingSystems.Examples.IdealEmbeddedHeating</a>.</p>
</html>"));
end IdealEmbeddedHeating;
