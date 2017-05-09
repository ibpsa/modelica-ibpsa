within IDEAS.Buildings.Components;
model Zone "Building zone model"
  extends IDEAS.Buildings.Components.Interfaces.PartialZone;

  //this propsbus exposes all ports to the outside of the model
  IDEAS.Buildings.Components.Interfaces.ZoneBus[nSurf] propsBus(
    each final numIncAndAziInBus=sim.numIncAndAziInBus,
    each final outputAngles=sim.outputAngles)
                          annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-100,40}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-100,40})));
equation
  connect(propsBus, propsBusInt) annotation (Line(
      points={{-100,40},{-90,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics),
    Documentation(info="<html>
<p>
This model is the zone model to which surfaces and HVAC may be connected.
It contains equations for radiative heat exchange and
a zone air model.
</p>
<h4>Typical use and important parameters</h4>
<p>
Any number of surfaces may be connected to the 
<code>propsbus</code> of a zone.
The number of connected surfaces must be specified
using the parameter <code>nSurf</code> and 
each of the nSurf <code>propsbus</code> components 
needs to be connected to exactly one surface.
</p>
<p>
Parameter <code>V</code> must be used to define the total
zone air volume.
</p>
<p>
Parameter <code>hZone</code> is the zone height,
which may be used to define the zone geometry.
</p>
<p>
Parameter <code>A</code> is the total
surface area of the zone.
</p>
<p>
Replaceable parameter <code>airModel</code> determines
the type of air model that is used.
</p>
<p>
Parameter <code>occTyp</code> determines
occupants properties.
These properties may be used to evaluate internal comfort,
or to determine internal gains.
</p>
<p>
Parameter <code>intGai</code> determines
internal gains model type. 
By default the internal gains model considers
a fixed sensible and latent heat load and CO2 production per person.
</p>
<p>
Parameter <code>comfort</code> determines
how occupant comfort may be computed.
</p>
<p>
Parameter <code>simVieFac</code> may be set to false to simplify the 
view factor calculation. This leads to a less accurate computation
of view factors, but this approach is more robust.
It may be used when the initial equation that computes the view factors does not converge.
</p>
</html>", revisions="<html>
<ul>
<li>
October 22, 2016, by Filip Jorissen:<br/>
Revised documentation for IDEAS 1.0.
</li>
<li>
August 26, 2016 by Filip Jorissen:<br/>
Added support for conservation of energy of air model.
</li>
<li>
April 30, 2016, by Filip Jorissen:<br/>
Added replaceable air model implementation.
</li>
<li>
March, 2015, by Filip Jorissen:<br/>
Added view factor implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end Zone;
