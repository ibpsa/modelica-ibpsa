within IDEAS.Buildings.Components;
model Zone "Building zone model"
  extends IDEAS.Buildings.Components.Interfaces.PartialZone(
    Qgai(y=(if sim.openSystemConservationOfEnergy
            then airModel.QGai
            else gainCon.Q_flow + gainRad.Q_flow + airModel.QGai)),
    Eexpr(y=E),
    useFluPor = airModel.useFluPor);
    replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);


  parameter Modelica.SIunits.Volume V "Total zone air volume"
    annotation(Dialog(group="Building physics"));
  parameter Modelica.SIunits.Length hZone = 2.8
    "Zone height: distance between floor and ceiling"
    annotation(Dialog(group="Building physics"));
  parameter Modelica.SIunits.Area A = V/hZone "Total conditioned floor area"
    annotation(Dialog(group="Building physics"));
  parameter Real n50(min=0.01)=0.4
    "n50 value cfr airtightness, i.e. the ACH at a pressure diffence of 50 Pa"
    annotation(Dialog(group="Building physics"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal in zone, false restricts to design direction (port_a -> port_b)."
    annotation(Dialog(tab="Advanced", group="Air model"));
  parameter Real n50toAch=20 "Conversion fractor from n50 to Air Change Rate"
    annotation(Dialog(tab="Advanced", group="Air model"));
  parameter Boolean linIntRad=sim.linIntRad
    "Linearized computation of long wave radiation"
    annotation(Dialog(tab="Advanced", group="Radiative heat exchange"));
  parameter Boolean calculateViewFactor = false
    "Explicit calculation of view factors: works well only for rectangular zones!"
    annotation(Dialog(tab="Advanced", group="Radiative heat exchange"));
  final parameter Modelica.SIunits.Power QInf_design=1012*1.204*V/3600*n50/n50toAch*(273.15
       + 21 - sim.Tdes)
    "Design heat losses from infiltration at reference outdoor temperature";
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.1*1.224*V/3600;
  final parameter Modelica.SIunits.Power QRH_design=A*fRH
    "Additional power required to compensate for the effects of intermittent heating";
  final parameter Modelica.SIunits.Power Q_design(fixed=false)
    "Total design heat losses for the zone";
  parameter Medium.Temperature T_start=Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Real fRH=11
    "Reheat factor for calculation of design heat load, (EN 12831, table D.10 Annex D)" annotation(Dialog(tab="Advanced",group="Design heat load"));

  replaceable ZoneAirModels.WellMixedAir airModel(
    redeclare package Medium = Medium,
    nSurf=nSurf,
    Vtot=V,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    n50=n50,
    n50toAch=n50toAch,
    mSenFac=mSenFac,
    energyDynamics=energyDynamicsAir)
                    constrainedby ZoneAirModels.BaseClasses.PartialAirModel(
    redeclare package Medium = Medium,
    nSurf=nSurf,
    Vtot=V,
    final T_start=T_start,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    n50=n50,
    n50toAch=n50toAch,
    mSenFac=mSenFac,
    energyDynamics=energyDynamicsAir) "Zone air model" annotation (
    Placement(transformation(extent={{-40,20},{-20,40}})),
    choicesAllMatching=true,
    Dialog(group="Building physics"));

  replaceable parameter OccupancyType.PartialOccupancyType occTyp
    constrainedby OccupancyType.PartialOccupancyType
    "Occupancy type, only used for evaluating occupancy model and comfort model"
    annotation (
    choicesAllMatching=true,
    Dialog(group="Occupants"),
    Placement(transformation(extent={{80,82},{100,102}})));
  replaceable InternalGains.None intGai(occupancyType=occTyp) constrainedby
    InternalGains.BaseClasses.PartialOccupancyGains(redeclare final package
      Medium = Medium) "Internal gains model" annotation (
    choicesAllMatching=true,
    Dialog(group="Occupants"),
    Placement(transformation(extent={{60,22},{40,42}})));
  replaceable Comfort.None comfort(occupancyType=occTyp) constrainedby
    Comfort.BaseClasses.PartialComfort "Comfort model" annotation (
    choicesAllMatching=true,
    Dialog(group="Occupants"),
    Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.SIunits.Power QTra_design=sum(propsBus.QTra_design)
    "Total design transmission heat losses for the zone";
  Modelica.Blocks.Interfaces.RealOutput TAir(unit="K") = airModel.TAir;
  Modelica.Blocks.Interfaces.RealOutput TStar(unit="K") = radDistr.TRad;
  Modelica.SIunits.Energy E = airModel.E;

protected
  IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.ZoneLwGainDistribution
    radDistr(nSurf=nSurf) "distribution of radiative internal gains"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-50,-50})));
  IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.ZoneLwDistribution
    radDistrLw(nSurf=nSurf, final linearise=linIntRad or sim.linearise) if
                                                 not calculateViewFactor
    "internal longwave radiative heat exchange" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,-10})));
  Modelica.Blocks.Math.Sum add(nin=2, k=if airModel.computeTSensorAsFunctionOfZoneAir
         then {0.5,0.5} else {1,0})                "Operative temperature"
    annotation (Placement(transformation(extent={{24,4},{36,16}})));

public
  IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.ZoneLwDistributionViewFactor
    zoneLwDistributionViewFactor(
      nSurf=nSurf,
      final hZone=hZone) if calculateViewFactor annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-30,-10})));
  Modelica.Blocks.Interfaces.RealInput nOcc if intGai.requireInput
    "Number of occupants"
    annotation (Placement(transformation(extent={{128,12},{88,52}})));

initial equation
  Q_design=QInf_design+QRH_design+QTra_design; //Total design load for zone (additional ventilation losses are calculated in the ventilation system)







equation
  connect(radDistr.radGain, gainRad) annotation (Line(
      points={{-46.2,-60},{100,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radDistr.TRad, add.u[1]) annotation (Line(
      points={{-40,-50},{-6,-50},{-6,9.4},{22.8,9.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(propsBus[1:nSurf].area, radDistr.area[1:nSurf]) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-50},{-60,-50}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus[1:nSurf].area, radDistrLw.A[1:nSurf]) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-14},{-60,-14}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus[1:nSurf].epsLw, radDistrLw.epsLw[1:nSurf]) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-10},{-60,-10}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus[1:nSurf].epsLw, zoneLwDistributionViewFactor.epsLw[1:nSurf]) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-10},{-40,-10}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus[1:nSurf].area, zoneLwDistributionViewFactor.A[1:nSurf]) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-14},{-40,-14}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus[1:nSurf].epsLw, radDistr.epsLw[1:nSurf]) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-50},{-60,-50}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus[1:nSurf].epsSw, radDistr.epsSw[1:nSurf]) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-54},{-60,-54}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  for i in 1:nSurf loop
    connect(radDistr.iSolDir, propsBus[i].iSolDir) annotation (Line(
      points={{-54,-60},{-100.1,-60},{-100.1,39.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(radDistr.iSolDif, propsBus[i].iSolDif) annotation (Line(
      points={{-50,-60},{-50,-64},{-100.1,-64},{-100.1,39.9}},
      color={191,0,0},
      smooth=Smooth.None));
  end for;
  connect(radDistr.radSurfTot, radDistrLw.port_a) annotation (Line(
      points={{-50,-40},{-50,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(zoneLwDistributionViewFactor.inc[1:nSurf], propsBus[1:nSurf].inc) annotation (Line(
      points={{-34,-1.77636e-15},{-34,4},{-80,4},{-80,39.9},{-100.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneLwDistributionViewFactor.azi[1:nSurf], propsBus[1:nSurf].azi) annotation (Line(
      points={{-26,-1.77636e-15},{-26,8},{-80,8},{-80,39.9},{-100.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneLwDistributionViewFactor.port_a, radDistr.radSurfTot) annotation (
     Line(
      points={{-30,-20},{-30,-30},{-50,-30},{-50,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(add.y, TSensor) annotation (Line(points={{36.6,10},{36.6,10},{54,10},{
          80,10},{80,0},{106,0}},
                   color={0,0,127}));
  connect(radDistr.radSurfTot[1:nSurf], propsBus[1:nSurf].surfRad) annotation (Line(points={{-50,-40},
          {-50,-30},{-80,-30},{-80,39.9},{-100.1,39.9}},      color={191,0,0}));
  connect(airModel.ports_surf[1:nSurf], propsBus[1:nSurf].surfCon) annotation (Line(points={{-40,30},
          {-80,30},{-80,40},{-98,40},{-100.1,40},{-100.1,39.9}},  color={191,0,0}));
  connect(airModel.inc[1:nSurf], propsBus[1:nSurf].inc) annotation (Line(points={{-40.8,38},{-80,
          38},{-80,40},{-82,40},{-100.1,40},{-100.1,39.9}},
                                                        color={0,0,127}));
  connect(airModel.azi[1:nSurf], propsBus[1:nSurf].azi) annotation (Line(points={{-40.8,34},{-80,
          34},{-80,40},{-98,40},{-100.1,40},{-100.1,39.9}},
                                                         color={0,0,127}));
  connect(airModel.A[1:nSurf], propsBus[1:nSurf].area) annotation (Line(points={{-40.6,24},{-80,
          24},{-80,40},{-96,40},{-100.1,40},{-100.1,39.9}},
                                                        color={0,0,127}));
  connect(airModel.port_b, flowPort_Out) annotation (Line(points={{-34,40},{-34,
          100},{-20,100}}, color={0,127,255}));
  connect(airModel.port_a, flowPort_In) annotation (Line(points={{-26,40},{-26,40},
          {-26,74},{-26,88},{20,88},{20,100}}, color={0,127,255}));
  connect(airModel.ports_air[1], gainCon) annotation (Line(points={{-20,30},{2,30},
          {2,-30},{100,-30}}, color={191,0,0}));
  connect(airModel.TAir, add.u[2]) annotation (Line(points={{-19.2,24},{-6,24},{
          -6,10.6},{22.8,10.6}},
                               color={0,0,127}));
  connect(radDistr.azi[1:nSurf], propsBus[1:nSurf].azi) annotation (Line(points={{-60,-42},{
          -70,-42},{-80,-42},{-80,39.9},{-100.1,39.9}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(radDistr.inc[1:nSurf], propsBus[1:nSurf].inc) annotation (Line(points={{-60,-46},{
          -80,-46},{-80,39.9},{-100.1,39.9}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(intGai.portCon, airModel.ports_air[1]) annotation (Line(points={{40,30},
          {40,30},{30,30},{-20,30}}, color={191,0,0}));
  connect(intGai.portRad, radDistr.radGain) annotation (Line(points={{40,26},{4,
          26},{4,-60},{-46.2,-60}}, color={191,0,0}));
  connect(intGai.nOcc, nOcc)
    annotation (Line(points={{61,32},{61,32},{108,32}}, color={0,0,127}));
  connect(intGai.mWat_flow, airModel.mWat_flow) annotation (Line(points={{39.4,38},
          {39.4,38},{-19.2,38}}, color={0,0,127}));
  connect(intGai.C_flow, airModel.C_flow)
    annotation (Line(points={{39.4,34},{-19.2,34}}, color={0,0,127}));
  connect(comfort.TAir, airModel.TAir) annotation (Line(points={{39,0},{-10,0},{
          -10,24},{-19.2,24}}, color={0,0,127}));
  connect(comfort.TRad, radDistr.TRad) annotation (Line(points={{39,-4},{-6,-4},
          {-6,-50},{-40,-50}}, color={0,0,127}));
  connect(comfort.phi, airModel.phi) annotation (Line(points={{39,-8},{-12,-8},{
          -12,26},{-19.2,26}}, color={0,0,127}));
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
