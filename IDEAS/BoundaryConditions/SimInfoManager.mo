within IDEAS.BoundaryConditions;
model SimInfoManager
  "Simulation information manager for handling time and climate data required in each for simulation."
  extends BoundaryConditions.Interfaces.PartialSimInfoManager;

protected
  Modelica.Blocks.Routing.RealPassThrough HDirNorData;
  Modelica.Blocks.Routing.RealPassThrough HGloHorData;
  Modelica.Blocks.Routing.RealPassThrough HDiffHorData;
  Modelica.Blocks.Routing.RealPassThrough TDryBulData;
  Modelica.Blocks.Routing.RealPassThrough relHumData;
  Modelica.Blocks.Routing.RealPassThrough TDewPoiData;
  Modelica.Blocks.Routing.RealPassThrough nOpaData;
  Modelica.Blocks.Routing.RealPassThrough winSpeData;
  Modelica.Blocks.Routing.RealPassThrough TBlaSkyData;
equation
  Te = TDryBul.y;
  TeAv = Te;
  Tground=TdesGround;
  relHum = phiEnv.y;
  TDewPoi = TDewPoiData.y;
  Tsky = TBlaSkyData.y;
  Va = winSpeData.y;

  connect(HDirNorData.u, weaDatBus.HDirNor);
  connect(HGloHorData.u, weaDatBus.HGloHor);
  connect(HDiffHorData.u, weaDatBus.HDifHor);
  connect(TDryBulData.u, weaDatBus.TDryBul);
  connect(relHumData.u, weaDatBus.relHum);
  connect(TDewPoiData.u, weaDatBus.TDewPoi);
  connect(nOpaData.u, weaDatBus.nOpa);
  connect(winSpeData.u, weaDatBus.winSpe);
  connect(TBlaSkyData.u, weaDatBus.TBlaSky);
  annotation (
    defaultComponentName="sim",
    defaultComponentPrefixes="inner",
    missingInnerMessage=
        "Your model is using an outer \"sim\" component. An inner \"sim\" component is not defined. For simulation drag IDEAS.BoundaryConditions.SimInfoManager into your model.",
    Icon(graphics={
        Bitmap(extent={{22,-8},{20,-8}}, fileName="")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>
The SimInfoManager manages all simulation information. 
It loads TMY3 weather data files and applies transformations 
for computing the solar irradiance on the zone surfaces. 
</p>
<h4>Typical use and important parameters</h4>
<ul>
<li>
Parameters <code>filNam</code> and <code>filDir</code> can be used to set the path to the TMY3 weather file.
This file should include the latitude, longitude and time zone corresponding to the weather file.
See the included weather files for the correct format.
</li>
</ul>
<h4>Options</h4>
<ul>
<li>
IDEAS contains an efficient implementation for computing the solar 
incidence angles on surfaces that are part of large building models.
When a model has many parallel surfaces the default implementation computes
the solar irradiance separately for each of these surfaces, 
while the result for all of them should be the same.
The SimInfoManager computes five default orientations (azimuth angels): 
south, west, east, north and horizontal.
Whenever a surface needs the solar incidence angels for one of these orientations
these precomputed values will be used.
The default orientations can be changed using parameters 
<code>incAndAziInBus</code>.
<code>incAndAziInBus</code> determines for which inclination and azimuth the solar radiation is pre-computed.
</li>
<li>Conservation of energy within the building can be checked by setting <code>computeConservationOfEnergy=true</code>.
Conservation of energy is checked by computing the internal energy for 
all components that are within \"the system\" and by adding to this the 
integral of all heat flows entering/leaving the system.
There are two options for choosing the extent of the system based 
on parameter <code>openSystemConservationOfEnergy</code>. 
Either conservation of energy for a closed system is computed, 
or it is computed for an open system. <br/>
When choosing the closed system the conservation of energy 
check should always work when using IDEAS as intended. 
In this case conservation of energy is only checked for all components in the <code>Buildings</code> package. 
I.e. all heat flows at embedded ports <code>port_emb</code> of walls, 
fluid ports of the zones, <code>zone.gainCon</code> and <code>zone.gainRad</code> are 
considered to be a heat gain to the system and every other component 
is considered to be outside of the system for which conservation of energy is checked. <br/>
When computing an open system by setting <code>openSystemConservationOfEnergy=true</code> 
these heat flow rates are not taken into account because they are assumed 
to flow between components that are both within the bounds of the system.
The user then needs to choose how large the system is and he should make sure that
all heat flow rates entering the system are added to <code>sim.Qgai.Q_flow</code> and 
that all internal energy of the system is added to <code>sim.E.E</code>.
</li>
<li>
The default latitude and longitude, which are read by the TMY3 reader, can be overwritten. 
This should only be done if a custom weather data reader instead 
of the TMY3 weather data reader is used.
</li>
</ul>
<h4>TMY3 weather data files</h4>
IDEAS uses TMY3 input files. For detailed documentation see 
<a href=\"modelica://IDEAS.BoundaryConditions.WeatherData.ReaderTMY3\">IDEAS.BoundaryConditions.WeatherData.ReaderTMY3</a>.
</html>", revisions="<html>
<ul>
<li>
January 21, 2019 by Filip Jorissen:<br/>
Improved documentation by adding weather data reader
reference and more TMY3 file examples.
This is for
<a href=\"https://github.com/open-ideas/IDEAS/issues/956\">#956</a>.
</li>
<li>
June 7, 2018 by Filip Jorissen:<br/>
Overwriting TSky, Va and Fc from the extends clause
such that they can be overwriten again in BESTEST SimInfoManager.
This is for
<a href=\"https://github.com/open-ideas/IDEAS/issues/838\">#838</a>.
</li>
<li>
June 14, 2015, Filip Jorissen:<br/>
Added documentation
</li>
</ul>
</html>"));
end SimInfoManager;
