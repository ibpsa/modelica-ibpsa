within IDEAS.BoundaryConditions;
model SimInfoManager
  "Simulation information manager for handling time and climate data required in each for simulation."
  extends BoundaryConditions.Interfaces.PartialSimInfoManager(
                                final useTmy3Reader = true);

protected
  BoundaryConditions.WeatherData.Bus weaBus1 "Weather data bus";
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
  solDirPer=HDirNorData.y;
  solDirHor = HGloHorData.y - solDifHor;
  solDifHor = HDiffHorData.y;
  solGloHor = solDirHor + solDifHor;
  Te = TDryBulData.y;
  TeAv = Te;
  Tground=TdesGround;
  irr = HGloHorData.y;
  summer = timMan.summer;
  relHum = relHumData.y;
  TDewPoi = TDewPoiData.y;
  timLoc = timMan.timLoc;
  timSol = timMan.timSol;
  timCal = timMan.timCal;

  if BesTest then
    Tsky = Te - (23.8 - 0.2025*(Te - 273.15)*(1 - 0.87*Fc));
    Fc = 0.2;
    Va = 2.5;
  else
    Tsky = TBlaSkyData.y;
    Fc = nOpaData.y*0.87;
    Va = winSpeData.y;
  end if;

  connect(weaDat.weaBus, weaBus1);
  connect(HDirNorData.u, weaBus1.HDirNor);
  connect(HGloHorData.u, weaBus1.HGloHor);
  connect(HDiffHorData.u, weaBus1.HDifHor);
  connect(TDryBulData.u, weaBus1.TDryBul);
  connect(relHumData.u, weaBus1.relHum);
  connect(TDewPoiData.u, weaBus1.TDewPoi);
  connect(nOpaData.u, weaBus1.nOpa);
  connect(winSpeData.u, weaBus1.winSpe);
  connect(TBlaSkyData.u, weaBus1.TBlaSky);
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
<p>
<ul>
<li>Parameters <code>filNam</code> and <code>filDir</code> can be used to set the path to the TMY3 weather file.</li>
<li>Parameters <code>lat</code> and <code>lon</code> can be used to set the location of the building
using latitude and longitude coordiantes.
These coordinates are used for calculating the solar position, not for choosing the correct weather data!</li>
</ul>
</p>
<h4>Options</h4>
<p>
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
</ul>
</p>
</html>", revisions="<html>
<ul>
<li>
June 14, 2015, Filip Jorissen:<br/>
Added documentation
</li>
</ul>
</html>"));
end SimInfoManager;
