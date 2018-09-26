within IDEAS.Buildings.Components.Interfaces;
model PartialZone "Building zone model"
  extends IDEAS.Buildings.Components.Interfaces.ZoneInterface(
    Qgai(y=(if not sim.computeConservationOfEnergy then 0 elseif sim.openSystemConservationOfEnergy
           then airModel.QGai else gainCon.Q_flow + gainRad.Q_flow + airModel.QGai)),
    Eexpr(y=if sim.computeConservationOfEnergy then E else 0),
    useOccNumInput=occNum.useInput,
    useLigCtrInput=ligCtr.useCtrInput);

    replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.Length hZone = 2.8
    "Zone height: distance between floor and ceiling"
    annotation(Dialog(group="Building physics"));
  parameter Modelica.SIunits.Area A = V/hZone "Total conditioned floor area"
    annotation(Dialog(group="Building physics"));
  parameter Real n50(min=0.01)= 0.4
    "n50 value cfr airtightness, i.e. the ACH at a pressure diffence of 50 Pa"
    annotation(Dialog(group="Building physics"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal in zone, false restricts to design direction (port_a -> port_b)."
    annotation(Dialog(tab="Advanced", group="Air model"));
  parameter Real n50toAch=20 "Conversion fractor from n50 to Air Change Rate"
   annotation(Dialog(tab="Advanced", group="Air model"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamicsAir=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance for air model: dynamic (3 initialization options) or steady state";
  parameter Real mSenFac = 5 "Correction factor for thermal capacity of zone air."
    annotation(Dialog(tab="Advanced",group="Air model"));

  parameter Boolean linIntRad=sim.linIntRad
    "Linearized computation of long wave radiation"
    annotation(Dialog(tab="Advanced", group="Radiative heat exchange"));
  parameter Boolean calculateViewFactor = false
    "Explicit calculation of view factors: works well only for rectangular zones!"
    annotation(Dialog(tab="Advanced", group="Radiative heat exchange"));
  final parameter Modelica.SIunits.Power QInf_design=1012*1.204*V/3600*n50/n50toAch*(273.15
       + 21 - sim.Tdes)
    "Design heat losses from infiltration at reference outdoor temperature";
  final parameter Modelica.SIunits.Power QRH_design=A*fRH
    "Additional power required to compensate for the effects of intermittent heating";
  final parameter Modelica.SIunits.Power Q_design(fixed=false)
    "Total design heat losses for the zone";
  parameter Medium.Temperature T_start=Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Real fRH=11
    "Reheat factor for calculation of design heat load, (EN 12831, table D.10 Annex D)" annotation(Dialog(tab="Advanced",group="Design heat load"));
  parameter Modelica.SIunits.Temperature Tzone_nom = 295.15
    "Nominal zone temperature, used for linearising radiative heat exchange"
    annotation(Dialog(tab="Advanced", group="Radiative heat exchange", enable=linIntRad));
  parameter Modelica.SIunits.TemperatureDifference dT_nom = -2
    "Nominal temperature difference between zone walls, used for linearising radiative heat exchange"
    annotation(Dialog(tab="Advanced", group="Radiative heat exchange", enable=linIntRad));
  parameter Boolean simVieFac=false "Simplify view factor computation"
    annotation(Dialog(tab="Advanced", group="Radiative heat exchange"));

  replaceable ZoneAirModels.WellMixedAir airModel(
    redeclare package Medium = Medium,
    nSurf=nSurf,
    Vtot=V,
    energyDynamics=energyDynamicsAir,
    allowFlowReversal=allowFlowReversal)
  constrainedby
    IDEAS.Buildings.Components.ZoneAirModels.BaseClasses.PartialAirModel(
    redeclare package Medium = Medium,
    mSenFac=mSenFac,
    nSurf=nSurf,
    Vtot=V,
    final T_start=T_start,
    allowFlowReversal=allowFlowReversal,
    energyDynamics=energyDynamicsAir,
    nPorts=interzonalAirFlow.nPorts,
    m_flow_nominal=m_flow_nominal)
    "Zone air model"
    annotation (choicesAllMatching=true,
    Placement(transformation(extent={{-40,20},{-20,40}})),
    Dialog(tab="Advanced",group="Air model"));
  replaceable IDEAS.Buildings.Components.InterzonalAirFlow.n50Tight interzonalAirFlow
  constrainedby
    IDEAS.Buildings.Components.InterzonalAirFlow.BaseClasses.PartialInterzonalAirFlow(
      redeclare package Medium = Medium,
      V=V,
      n50=n50,
      n50toAch=n50toAch,
      m_flow_nominal_vent=m_flow_nominal)
      "Interzonal air flow model"
    annotation (choicesAllMatching = true,Dialog(tab="Advanced", group="Air model"),
      Placement(transformation(extent={{-40,60},{-20,80}})),
    choicesAllMatching=true,
    Dialog(group="Building physics"));
  replaceable IDEAS.Buildings.Components.Occupants.Fixed occNum
    constrainedby Occupants.BaseClasses.PartialOccupants(
      final linearise = sim.lineariseDymola)
    "Number of occupants that are present" annotation (
    choicesAllMatching=true,
    Dialog(group="Occupants (optional)"),
    Placement(transformation(extent={{80,22},{60,42}})));

  replaceable parameter IDEAS.Buildings.Components.OccupancyType.OfficeWork occTyp
    constrainedby
    IDEAS.Buildings.Components.OccupancyType.BaseClasses.PartialOccupancyType
    "Occupancy type, only used for evaluating occupancy model and comfort model"
    annotation (
    choicesAllMatching=true,
    Dialog(group="Occupants (optional)"),
    Placement(transformation(extent={{80,82},{100,102}})));
  replaceable parameter IDEAS.Buildings.Components.RoomType.Generic rooTyp
    constrainedby
    IDEAS.Buildings.Components.RoomType.BaseClasses.PartialRoomType
    "Room type or function, currently only determines the desired lighting intensity"
    annotation (choicesAllMatching=true,
    Dialog(group="Lighting (optional)"),
    Placement(transformation(extent={{32,82},{52,102}})));
  replaceable parameter IDEAS.Buildings.Components.LightingType.None ligTyp
    constrainedby
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLighting
    "Lighting type, determines the lighting efficacy/efficiency" annotation (
    choicesAllMatching=true,
    Dialog(group="Lighting (optional)"),
    Placement(transformation(extent={{56,82},{76,102}})));
  replaceable Comfort.None comfort
    constrainedby Comfort.BaseClasses.PartialComfort(occupancyType=occTyp) "Comfort model" annotation (
    choicesAllMatching=true,
    Dialog(group="Occupants (optional)"),
    Placement(transformation(extent={{20,-20},{40,0}})));
  replaceable IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.ZoneLwGainDistribution
    radDistr(nSurf=nSurf, lineariseJModelica=sim.lineariseJModelica)
    "Distribution of radiative internal gains"
    annotation (choicesAllMatching=true,Dialog(tab="Advanced",group="Building physics"),Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-50,-50})));
  replaceable IDEAS.Buildings.Components.InternalGains.Occupants intGaiOcc
    constrainedby
    IDEAS.Buildings.Components.InternalGains.BaseClasses.PartialOccupancyGains(
      occupancyType=occTyp,
      redeclare final package Medium = Medium)
    "Internal gains model" annotation (
    choicesAllMatching=true,
    Dialog(tab="Advanced", group="Occupants"),
    Placement(transformation(extent={{40,22},{20,42}})));

  replaceable IDEAS.Buildings.Components.InternalGains.Lighting intGaiLig
    constrainedby
    IDEAS.Buildings.Components.InternalGains.BaseClasses.PartialLightingGains(
      A=A,
      ligTyp=ligTyp,
      rooTyp=rooTyp) "Lighting model" annotation (
    choicesAllMatching=true,
    Dialog(tab="Advanced", group="Lighting"),
    Placement(transformation(extent={{40,52},{20,72}})));

  Modelica.SIunits.Power QTra_design=sum(propsBusInt.QTra_design)
    "Total design transmission heat losses for the zone";
  Modelica.Blocks.Interfaces.RealOutput TAir(unit="K") = airModel.TAir;
  Modelica.Blocks.Interfaces.RealOutput TRad(unit="K") = radDistr.TRad;
  Modelica.SIunits.Energy E = airModel.E;

  replaceable IDEAS.Buildings.Components.LightingControl.Fixed ligCtr
    constrainedby
    IDEAS.Buildings.Components.LightingControl.BaseClasses.PartialLightingControl(
      final linearise = sim.lineariseDymola)
    "Lighting control type" annotation (
    choicesAllMatching=true,
    Dialog(group="Lighting (optional)"),
    Placement(transformation(extent={{80,52},{60,72}})));



protected
  IDEAS.Buildings.Components.Interfaces.ZoneBus[nSurf] propsBusInt(
    each final numIncAndAziInBus=sim.numIncAndAziInBus,
    each final outputAngles=sim.outputAngles)
    "Dummy propsbus for partial" annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-80,40}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-80,40})));

  IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.ZoneLwDistribution
    radDistrLw(nSurf=nSurf, final linearise=linIntRad or sim.linearise,
    Tzone_nom=Tzone_nom,
    dT_nom=dT_nom,
    final simVieFac=simVieFac) if                not calculateViewFactor
    "internal longwave radiative heat exchange" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,-10})));
  Modelica.Blocks.Math.Sum add(nin=2, k={0.5,0.5}) "Operative temperature"
    annotation (Placement(transformation(extent={{84,14},{96,26}})));

  IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.ZoneLwDistributionViewFactor
    zoneLwDistributionViewFactor(
      nSurf=nSurf,
      final hZone=hZone,
    linearise=linIntRad or sim.linearise,
    Tzone_nom=Tzone_nom,
    dT_nom=dT_nom) if       calculateViewFactor annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-30,-10})));



initial equation
  Q_design=QInf_design+QRH_design+QTra_design; //Total design load for zone (additional ventilation losses are calculated in the ventilation system)

equation
  if interzonalAirFlow.verifyBothPortsConnected then
    assert(cardinality(port_a)>1 and cardinality(port_b)>1 or cardinality(port_a) == 1 and cardinality(port_b) == 1,
      "WARNING: Only one of the FluidPorts of " + getInstanceName() + " is 
      connected and an 'open' interzonalAirFlow model is used, 
      which means that all injected/extracted air will flow
      through the zone to/from the surroundings, at ambient temperature. 
      This may be unintended.", AssertionLevel.warning);
  end if;
  for i in 1:nSurf loop
    connect(sim.weaBus, propsBusInt[i].weaBus) annotation (Line(
        points={{-81,93},{-81,92},{-80,92},{-80,66},{-80.1,66},{-80.1,39.9}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(dummy1, propsBusInt[i].Qgai);
    connect(dummy2, propsBusInt[i].E);
end for;
  connect(radDistr.radGain, gainRad) annotation (Line(
      points={{-46.2,-60},{100,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radDistr.TRad, add.u[1]) annotation (Line(
      points={{-40,-50},{-6,-50},{-6,19.4},{82.8,19.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(propsBusInt[1:nSurf].area, radDistr.area[1:nSurf]) annotation (Line(
      points={{-80.1,39.9},{-80,39.9},{-80,-58},{-60,-58}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBusInt[1:nSurf].area, radDistrLw.A[1:nSurf]) annotation (Line(
      points={{-80.1,39.9},{-80,39.9},{-80,-14},{-60,-14}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBusInt[1:nSurf].epsLw, radDistrLw.epsLw[1:nSurf]) annotation (
      Line(
      points={{-80.1,39.9},{-80,39.9},{-80,-10},{-60,-10}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBusInt[1:nSurf].epsLw, zoneLwDistributionViewFactor.epsLw[1:
    nSurf]) annotation (Line(
      points={{-80.1,39.9},{-80,39.9},{-80,-10},{-40,-10}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBusInt[1:nSurf].area, zoneLwDistributionViewFactor.A[1:nSurf])
    annotation (Line(
      points={{-80.1,39.9},{-80,39.9},{-80,-14},{-40,-14}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBusInt[1:nSurf].epsLw, radDistr.epsLw[1:nSurf]) annotation (Line(
      points={{-80.1,39.9},{-80,39.9},{-80,-50},{-60,-50}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBusInt[1:nSurf].epsSw, radDistr.epsSw[1:nSurf]) annotation (Line(
      points={{-80.1,39.9},{-80,39.9},{-80,-54},{-60,-54}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  for i in 1:nSurf loop
    connect(radDistr.iSolDir, propsBusInt[i].iSolDir) annotation (Line(
        points={{-54,-60},{-80.1,-60},{-80.1,39.9}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(radDistr.iSolDif, propsBusInt[i].iSolDif) annotation (Line(
        points={{-50,-60},{-50,-64},{-80.1,-64},{-80.1,39.9}},
        color={191,0,0},
        smooth=Smooth.None));
  end for;
  connect(radDistr.radSurfTot, radDistrLw.port_a) annotation (Line(
      points={{-50,-40},{-50,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(zoneLwDistributionViewFactor.inc[1:nSurf], propsBusInt[1:nSurf].inc)
    annotation (Line(
      points={{-34,-1.77636e-15},{-34,4},{-80,4},{-80,39.9},{-80.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneLwDistributionViewFactor.azi[1:nSurf], propsBusInt[1:nSurf].azi)
    annotation (Line(
      points={{-26,-1.77636e-15},{-26,8},{-80,8},{-80,39.9},{-80.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneLwDistributionViewFactor.port_a, radDistr.radSurfTot) annotation (
     Line(
      points={{-30,-20},{-30,-30},{-50,-30},{-50,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(add.y, TSensor) annotation (Line(points={{96.6,20},{110,20}},
                   color={0,0,127}));
  connect(radDistr.radSurfTot[1:nSurf], propsBusInt[1:nSurf].surfRad)
    annotation (Line(points={{-50,-40},{-50,-30},{-80,-30},{-80,39.9},{-80.1,
          39.9}}, color={191,0,0}));
  connect(airModel.ports_surf[1:nSurf], propsBusInt[1:nSurf].surfCon)
    annotation (Line(points={{-40,30},{-80,30},{-80,40},{-80.1,40},{-80.1,39.9}},
        color={191,0,0}));
  connect(airModel.inc[1:nSurf], propsBusInt[1:nSurf].inc) annotation (Line(
        points={{-40.8,38},{-80,38},{-80,40},{-82,40},{-80.1,40},{-80.1,39.9}},
        color={0,0,127}));
  connect(airModel.azi[1:nSurf], propsBusInt[1:nSurf].azi) annotation (Line(
        points={{-40.8,34},{-80,34},{-80,40},{-80.1,40},{-80.1,39.9}}, color={0,
          0,127}));
  connect(airModel.A[1:nSurf], propsBusInt[1:nSurf].area) annotation (Line(
        points={{-40.6,24},{-80,24},{-80,40},{-80.1,40},{-80.1,39.9}}, color={0,
          0,127}));
  connect(airModel.ports_air[1], gainCon) annotation (Line(points={{-20,30},{2,30},
          {2,-30},{100,-30}}, color={191,0,0}));
  connect(airModel.TAir, add.u[2]) annotation (Line(points={{-19,24},{-10,24},{-10,
          20.6},{82.8,20.6}},  color={0,0,127}));
  connect(radDistr.azi[1:nSurf], propsBusInt[1:nSurf].azi) annotation (Line(
        points={{-60,-42},{-70,-42},{-80,-42},{-80,39.9},{-80.1,39.9}}, color={
          0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(radDistr.inc[1:nSurf], propsBusInt[1:nSurf].inc) annotation (Line(
        points={{-60,-46},{-80,-46},{-80,39.9},{-80.1,39.9}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(intGaiOcc.portCon, airModel.ports_air[1])
    annotation (Line(points={{20,30},{-20,30}}, color={191,0,0}));
  connect(intGaiOcc.portRad, radDistr.radGain) annotation (Line(points={{20,26},
          {4,26},{4,-60},{-46.2,-60}}, color={191,0,0}));
  connect(intGaiOcc.mWat_flow, airModel.mWat_flow)
    annotation (Line(points={{19.4,38},{-19.2,38}}, color={0,0,127}));
  connect(intGaiOcc.C_flow, airModel.C_flow)
    annotation (Line(points={{19.4,34},{-19.2,34}}, color={0,0,127}));
  connect(comfort.TAir, airModel.TAir) annotation (Line(points={{19,0},{-10,0},{
          -10,24},{-19,24}},   color={0,0,127}));
  connect(comfort.TRad, radDistr.TRad) annotation (Line(points={{19,-4},{-6,-4},
          {-6,-50},{-40,-50}}, color={0,0,127}));
  connect(comfort.phi, airModel.phi) annotation (Line(points={{19,-8},{-12,-8},{
          -12,26},{-19,26}},   color={0,0,127}));
  connect(occNum.nOcc, intGaiOcc.nOcc)
    annotation (Line(points={{58,32},{41,32}}, color={0,0,127}));
  connect(nOcc, occNum.nOccIn)
    annotation (Line(points={{120,40},{96,40},{96,32},{82,32}},
                                                color={0,0,127}));
  connect(uLig, ligCtr.ligCtr) annotation (Line(points={{120,70},{96,70},{96,60},
          {82,60}},color={0,0,127}));
  connect(occNum.nOcc, ligCtr.nOcc) annotation (Line(points={{58,32},{96,32},{96,
          64},{82,64}},
                   color={0,0,127}));
  connect(airModel.port_b, interzonalAirFlow.port_a_interior)
    annotation (Line(points={{-36,40},{-36,60}}, color={0,127,255}));
  connect(airModel.port_a, interzonalAirFlow.port_b_interior)
    annotation (Line(points={{-24,40},{-24,60}}, color={0,127,255}));
  connect(interzonalAirFlow.ports, airModel.ports) annotation (Line(points={{
          -29.8,60},{-30,60},{-30,40}}, color={0,127,255}));
  connect(interzonalAirFlow.port_b_exterior, port_b) annotation (Line(points={{
          -32,80},{-32,92},{-20,92},{-20,100}}, color={0,127,255}));
  connect(interzonalAirFlow.port_a_exterior, port_a) annotation (Line(points={{
          -28,80},{-28,84},{20,84},{20,100}}, color={0,127,255}));
  connect(ppm, airModel.ppm) annotation (Line(points={{110,0},{52,0},{52,16},{-8,
          16},{-8,28},{-19,28}}, color={0,0,127}));
  connect(intGaiLig.portRad, gainRad) annotation (Line(points={{20,60},{4,60},{4,
          -60},{100,-60}}, color={191,0,0}));
  connect(intGaiLig.portCon, gainCon) annotation (Line(points={{20,64},{2,64},{2,
          -30},{100,-30}}, color={191,0,0}));
  connect(ligCtr.ctrl, intGaiLig.ctrl)
    annotation (Line(points={{58,62},{41,62}}, color={0,0,127}));
 annotation (Placement(transformation(extent={{
            140,48},{100,88}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics),
    Documentation(info="<html>
<p>See extending models.</p>
</html>", revisions="<html>
<ul>
<li>
September 26, 2018 by Iago Cupeiro:<br/>
Implementation of the lighting model
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
<li>
September 24, 2018 by Filip Jorissen:<br/>
Fixed duplicate declaration of <code>V</code>.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/917\">#917</a>.
</li>
<li>
July 27, 2018 by Filip Jorissen:<br/>
Added output for the CO2 concentration.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/868\">#868</a>.
</li>
<li>
July 11, 2018, Filip Jorissen:<br/>
Propagated <code>m_flow_nominal</code> for setting nominal values 
of <code>h_outflow</code> and <code>m_flow</code>
in <code>FluidPorts</code>.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/859\">#859</a>.
</li>
<li>
May 29, 2018, Filip Jorissen:<br/>
Removed conditional fluid ports for JModelica compatibility.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/834\">#834</a>.
</li>
<li>
April 27, 2018 by Filip Jorissen:<br/>
Modified interfaces for supporting new interzonal air flow models.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/796\">#796</a>.
</li>
<li>
April 12, 2018 by Filip Jorissen:<br/>
Propagated <code>energyDynamicsAir</code>.
See issue <a href=https://github.com/open-ideas/IDEAS/issues/800>#800</a>.
</li>
<li>
March 29, 2018 by Filip Jorissen:<br/>
Propagated <code>mSenFac</code> to <code>airModel</code>.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/792\">#792</a>.
</li>
<li>
March 28, 2018 by Filip Jorissen:<br/>
Added option for introducing state for
radiative temperature.
</li>
<li>
July 26, 2018 by Filip Jorissen:<br/>
Added replaceable block that allows to define
the number of occupants.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/760\">#760</a>.
</li>
<li>
March 21, 2017, by Filip Jorissen:<br/>
Changed linearisation and conservation of energy implementations for JModelica compatibility.
See issue <a href=https://github.com/open-ideas/IDEAS/issues/559>#559</a>.
</li>
<li>
February 1, 2017 by Filip Jorissen:<br/>
Added option for disabling new view factor computation.
See issue
<a href=https://github.com/open-ideas/IDEAS/issues/663>#663</a>.
</li>
<li>
January 24, 2017 by Filip Jorissen:<br/>
Made <code>radDistr</code> replaceable
such that it can be redeclared in experimental models.
</li>
<li>
January 19, 2017 by Filip Jorissen:<br/>
Propagated linearisation parameters for interior radiative heat exchange.
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
</html>", info="<html>
<p>
Partial model that defines the main variables and connectors of a zone model.
</p>
</html>"));
end PartialZone;
