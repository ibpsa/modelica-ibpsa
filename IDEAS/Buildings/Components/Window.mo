within IDEAS.Buildings.Components;
model Window "Multipane window"
  replaceable IDEAS.Buildings.Data.Interfaces.Glazing glazing
    constrainedby IDEAS.Buildings.Data.Interfaces.Glazing "Glazing type"
    annotation (__Dymola_choicesAllMatching=true, Dialog(group=
          "Construction details"));

  extends IDEAS.Buildings.Components.Interfaces.PartialSurface(
    dT_nominal_a=-3,
    intCon_a(final A=
           A*(1 - frac),
           linearise=linIntCon_a or sim.linearise,
           dT_nominal=dT_nominal_a),
    QTra_design(fixed=false),
    Qgai(y=if sim.computeConservationOfEnergy then
                                                  -(propsBus_a.surfCon.Q_flow +
        propsBus_a.surfRad.Q_flow + propsBus_a.iSolDif.Q_flow + propsBus_a.iSolDir.Q_flow) else 0),
    E(y=0),
    layMul(
      A=A*(1 - frac),
      nLay=glazing.nLay,
      mats=glazing.mats,
      energyDynamics=if windowDynamicsType == IDEAS.Buildings.Components.Interfaces.WindowDynamicsType.Normal then energyDynamics else Modelica.Fluid.Types.Dynamics.SteadyState,
      dT_nom_air=5,
      linIntCon=true));
  parameter Boolean linExtCon=sim.linExtCon
    "= true, if exterior convective heat transfer should be linearised (uses average wind speed)"
    annotation(Dialog(tab="Convection"));
  parameter Boolean linExtRad=sim.linExtRadWin
    "= true, if exterior radiative heat transfer should be linearised"
    annotation(Dialog(tab="Radiation"));


  parameter Real frac(
    min=0,
    max=1) = 0.15 "Area fraction of the window frame";
  parameter IDEAS.Buildings.Components.Interfaces.WindowDynamicsType
    windowDynamicsType=IDEAS.Buildings.Components.Interfaces.WindowDynamicsType.Two
    "Type of dynamics for glazing and frame: using zero, one combined or two states"
    annotation (Dialog(tab="Dynamics", group="Equations", enable = not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Real fraC = frac
    "Ratio of frame and glazing thermal masses"
    annotation(Dialog(tab="Dynamics", group="Equations", enable= not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState and windowDynamicsType == IDEAS.Buildings.Components.Interfaces.WindowDynamicsType.Two));

  replaceable parameter IDEAS.Buildings.Data.Frames.None fraType
    constrainedby IDEAS.Buildings.Data.Interfaces.Frame "Window frame type"
    annotation (choicesAllMatching=true, Dialog(group=
          "Construction details"));
  replaceable IDEAS.Buildings.Components.Shading.None shaType constrainedby
    Shading.Interfaces.PartialShading(
                            final azi=azi) "First shading type"  annotation (Placement(transformation(extent={{-60,-60},
            {-50,-40}})),
      __Dymola_choicesAllMatching=true, Dialog(group="Construction details"));

  Modelica.Blocks.Interfaces.RealInput Ctrl if shaType.controlled
    "Control signal between 0 and 1, i.e. 1 is fully closed" annotation (
      Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-50,-110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-40,-100})));


protected
  final parameter Real U_value=glazing.U_value*(1-frac)+fraType.U_value*frac
    "Average window U-value";
  final parameter Boolean addCapGla =  windowDynamicsType == IDEAS.Buildings.Components.Interfaces.WindowDynamicsType.Two and not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
    "Add lumped thermal capacitor for window glazing";
  final parameter Boolean addCapFra =  fraType.present and not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
    "Added lumped thermal capacitor for window frame";
  final parameter Modelica.SIunits.HeatCapacity Cgla = layMul.C
    "Heat capacity of glazing state";
  final parameter Modelica.SIunits.HeatCapacity Cfra = layMul.C*fraC
    "Heat capacity of frame state";

  IDEAS.Buildings.Components.BaseClasses.ConvectiveHeatTransfer.ExteriorConvection
    eCon(final A=A*(1 - frac), linearise=linExtCon or sim.linearise)
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-20,-38},{-40,-18}})));

  IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.ExteriorHeatRadiation
    skyRad(final A=A*(1 - frac), Tenv_nom=sim.Tenv_nom,
    linearise=linExtRad or sim.linearise)
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  replaceable
  IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.SwWindowResponse
    solWin(
    final nLay=glazing.nLay,
    final SwAbs=glazing.SwAbs,
    final SwTrans=glazing.SwTrans,
    final SwTransDif=glazing.SwTransDif,
    final SwAbsDif=glazing.SwAbsDif)
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  IDEAS.Buildings.Components.BaseClasses.ConvectiveHeatTransfer.InteriorConvection
    iConFra(final A=A*frac, final inc=inc,
    linearise=linIntCon_a or sim.linearise) if
                        fraType.present
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.ExteriorHeatRadiation
    skyRadFra(final A=A*frac, Tenv_nom=sim.Tenv_nom,
    linearise=linExtRad or sim.linearise) if
                         fraType.present
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-20,80},{-40,100}})));
  IDEAS.Buildings.Components.BaseClasses.ConvectiveHeatTransfer.ExteriorConvection
    eConFra(final A=A*frac, linearise=linExtCon or sim.linearise) if
                 fraType.present
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-20,60},{-40,80}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor layFra(final G=(if
        fraType.briTyp.present then fraType.briTyp.G else 0) + (fraType.U_value)
        *A*frac) if                fraType.present  annotation (Placement(transformation(extent={{10,60},
            {-10,80}})));

  BoundaryConditions.SolarIrradiation.RadSolData radSolData(
    inc=inc,
    azi=azi,
    lat=sim.lat,
    outputAngles=sim.outputAngles,
    incAndAziInBus=sim.incAndAziInBus,
    numIncAndAziInBus=sim.numIncAndAziInBus)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Math.Gain gainDir(k=A*(1 - frac))
    "Gain for direct solar irradiation"
    annotation (Placement(transformation(extent={{-42,-46},{-38,-42}})));
  Modelica.Blocks.Math.Gain gainDif(k=A*(1 - frac))
    "Gain for diffuse solar irradiation"
    annotation (Placement(transformation(extent={{-36,-50},{-32,-46}})));
  Modelica.Blocks.Routing.RealPassThrough Tdes
    "Design temperature passthrough since propsBus variables cannot be addressed directly";
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapGla(
     C=Cgla, T(fixed= energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial, start=T_start)) if addCapGla
    "Heat capacitor for glazing"
    annotation (Placement(transformation(extent={{6,-12},{26,-32}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapFra(
     C=Cfra, T(fixed= energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial, start=T_start)) if addCapFra
    "Heat capacitor for frame"
    annotation (Placement(transformation(extent={{6,88},{26,108}})));
  Modelica.Blocks.Sources.Constant constEpsSwFra(final k=fraType.mat.epsSw)
    "Shortwave emissivity of frame"
    annotation (Placement(transformation(extent={{4,46},{-6,56}})));
  Modelica.Blocks.Sources.Constant constEpsLwFra(final k=fraType.mat.epsLw)
    "Shortwave emissivity of frame"
    annotation (Placement(transformation(extent={{4,86},{-6,96}})));
  IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.ExteriorSolarAbsorption
    solAbs(A=A*frac) if fraType.present
    "Solar absorption model for shortwave radiation"
    annotation (Placement(transformation(extent={{-20,40},{-40,60}})));
initial equation
  QTra_design = (U_value*A + (if fraType.briTyp.present then fraType.briTyp.G else 0)) *(273.15 + 21 - Tdes.y);


equation
  connect(eCon.port_a, layMul.port_b) annotation (Line(
      points={{-20,-28},{-14,-28},{-14,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(skyRad.port_a, layMul.port_b) annotation (Line(
      points={{-20,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolDir, propsBus_a.iSolDir) annotation (Line(
      points={{-2,-60},{-2,-70},{100.1,-70},{100.1,19.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolDif, propsBus_a.iSolDif) annotation (Line(
      points={{2,-60},{2,-70},{100.1,-70},{100.1,19.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solWin.iSolAbs, layMul.port_gain) annotation (Line(
      points={{0,-40},{0,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, skyRad.epsLw) annotation (Line(
      points={{-10,8},{-14,8},{-14,3.4},{-20,3.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaType.Ctrl, Ctrl) annotation (Line(
      points={{-55,-60},{-50,-60},{-50,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iConFra.port_b, propsBus_a.surfCon) annotation (Line(
      points={{40,70},{46,70},{46,19.9},{100.1,19.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layFra.port_a, iConFra.port_a) annotation (Line(
      points={{10,70},{20,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(skyRadFra.port_a, layFra.port_b) annotation (Line(
      points={{-20,90},{-16,90},{-16,70},{-10,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eConFra.port_a, layFra.port_b) annotation (Line(
      points={{-20,70},{-10,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radSolData.angInc, shaType.angInc) annotation (Line(
      points={{-79.4,-54},{-60,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSolData.angAzi, shaType.angAzi) annotation (Line(
      points={{-79.4,-58},{-60,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSolData.angZen, shaType.angZen) annotation (Line(
      points={{-79.4,-56},{-60,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSolData.weaBus, propsBus_a.weaBus) annotation (Line(
      points={{-80,-42},{-80,20},{0,20},{0,19.9},{100.1,19.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(radSolData.Tenv, skyRad.Tenv) annotation (Line(
      points={{-79.4,-52},{-64,-52},{-64,10},{-20,10},{-20,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyRadFra.Tenv, skyRad.Tenv) annotation (Line(
      points={{-20,96},{-12,96},{-12,6},{-20,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eConFra.Te, eCon.Te) annotation (Line(
      points={{-20,65.2},{-20,66},{-16,66},{-16,-32.8},{-20,-32.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eCon.hConExt, eConFra.hConExt) annotation (Line(
      points={{-20,-37},{-20,-36},{-14,-36},{-14,61},{-20,61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eCon.Te, propsBus_a.weaBus.Te) annotation (Line(
      points={{-20,-32.8},{100.1,-32.8},{100.1,19.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eCon.hConExt, propsBus_a.weaBus.hConExt) annotation (Line(
      points={{-20,-37},{100.1,-37},{100.1,19.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tdes.u, propsBus_a.weaBus.Tdes);
  connect(shaType.iAngInc, solWin.angInc) annotation (Line(points={{-50,-54},{
          -22,-54},{-22,-54},{-10,-54}}, color={0,0,127}));
  connect(heaCapGla.port, layMul.port_a)
    annotation (Line(points={{16,-12},{16,0},{10,0}},     color={191,0,0}));
  connect(heaCapFra.port, layFra.port_a)
    annotation (Line(points={{16,88},{16,70},{10,70}}, color={191,0,0}));
  connect(skyRadFra.epsLw, constEpsLwFra.y) annotation (Line(points={{-20,93.4},
          {-14,93.4},{-14,91},{-6.5,91}}, color={0,0,127}));
  connect(solAbs.port_a, layFra.port_b) annotation (Line(points={{-20,50},{-16,
          50},{-16,70},{-10,70}},
                              color={191,0,0}));
  connect(solAbs.epsSw, constEpsSwFra.y) annotation (Line(points={{-20,56},{-10,
          56},{-10,51},{-6.5,51}}, color={0,0,127}));
  connect(gainDir.y, solWin.solDir)
    annotation (Line(points={{-37.8,-44},{-10,-44}}, color={0,0,127}));
  connect(gainDif.y, solWin.solDif) annotation (Line(points={{-31.8,-48},{-22,
          -48},{-10,-48}}, color={0,0,127}));
  connect(gainDif.u, shaType.iSolDif) annotation (Line(points={{-36.4,-48},{-48,
          -48},{-50,-48}}, color={0,0,127}));
  connect(gainDir.u, shaType.iSolDir)
    annotation (Line(points={{-42.4,-44},{-50,-44}}, color={0,0,127}));
  connect(shaType.solDir, radSolData.solDir) annotation (Line(points={{-60,-44},
          {-76,-44},{-76,-48},{-79.4,-48}}, color={0,0,127}));
  connect(shaType.solDif, radSolData.solDif) annotation (Line(points={{-60,-48},
          {-74,-48},{-74,-50},{-79.4,-50}}, color={0,0,127}));
  connect(shaType.iSolDir, solAbs.solDir)
    annotation (Line(points={{-50,-44},{-50,56},{-40,56}}, color={0,0,127}));
  connect(shaType.iSolDif, solAbs.solDif) annotation (Line(points={{-50,-48},{
          -48,-48},{-48,52},{-40,52}}, color={0,0,127}));
    annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-60,-100},{60,100}}),
        graphics={
        Rectangle(
          extent={{-50,-90},{50,100}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,60},{50,24},{50,-50},{-30,-20},{-46,-20},{-46,60}},
          smooth=Smooth.None,
          pattern=LinePattern.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{-50,60},{-30,60},{-30,80},{50,80}},
          color={175,175,175}),
        Line(
          points={{-50,-20},{-30,-20},{-30,-70},{-30,-70},{52,-70}},
          color={175,175,175}),
        Line(
          points={{-50,60},{-50,66},{-50,100},{50,100}},
          color={175,175,175}),
        Line(
          points={{-50,-20},{-50,-90},{50,-90}},
          color={175,175,175}),
        Line(
          points={{-46,60},{-46,-20}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>
This model should be used to model windows or other transparant surfaces.
See <a href=modelica://IDEAS.Buildings.Components.Interfaces.PartialSurface>IDEAS.Buildings.Components.Interfaces.PartialSurface</a> 
for equations, options, parameters, validation and dynamics that are common for all surfaces and windows.
</p>
<h4>Typical use and important parameters</h4>
<p>
Parameter <code>A</code> is the total window surface area, i.e. the
sum of the frame surface area and the glazing surface area.
</p>
<p>
Parameter <code>frac</code> may be used to define the surface
area of the frame as a fraction of <code>A</code>. 
</p>
<p>
Parameter <code>glazing</code>  must be used to define the glass properties.
It contains information about the number of glass layers,
their thickness, thermal properties and emissivity.
</p>
<p>
Optional parameter <code>briType</code> may be used to compute additional line losses
along the edges of the glazing.
</p>
<p>
Optional parameter <code>fraType</code> may be used to define the frame thermal properties.
If <code>fraType = None</code> then the frame is assumed to be perfectly insulating.
</p>
<p>
Optional parameter <code>shaType</code> may be used to define the window shading properties.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Filip Jorissen:<br/>
Added option for using 'normal' dynamics for the window glazing.
Removed the option for having a combined state for 
window and frame this this is non-physical.
This is for 
<a href=https://github.com/open-ideas/IDEAS/issues/678>#678</a>.
</li>
<li>
January 10, 2017, by Filip Jorissen:<br/>
Removed declaration of 
<code>A</code> since this is now declared in 
<a href=modelica://IDEAS.Buildings.Components.Interfaces.PartialSurface>
IDEAS.Buildings.Components.Interfaces.PartialSurface</a>.
This is for 
<a href=https://github.com/open-ideas/IDEAS/issues/609>#609</a>.
</li>
<li>
January 10, 2017 by Filip Jorissen:<br/>
Set <code>linExtRad = sim.linExtRadWin</code>.
See <a href=https://github.com/open-ideas/IDEAS/issues/615>#615</a>.
</li>
<li>
December 19, 2016, by Filip Jorissen:<br/>
Added solar irradiation on window frame.
</li>
<li>
December 19, 2016, by Filip Jorissen:<br/>
Removed briType, which had default value LineLoss.
briType is now part of the Frame model and has default
value None.
</li>
<li>
February 10, 2016, by Filip Jorissen and Damien Picard:<br/>
Revised implementation: cleaned up connections and partials.
</li>
<li>
December 17, 2015, Filip Jorissen:<br/>
Added thermal connection between frame and glazing state. 
This is required for decoupling steady state thermal dynamics
without adding a second state for the window.
</li>
<li>
July 14, 2015, Filip Jorissen:<br/>
Removed second shading device since a new partial was created
for handling this.
</li>
<li>
June 14, 2015, Filip Jorissen:<br/>
Adjusted implementation for computing conservation of energy.
</li>
<li>
February 10, 2015 by Filip Jorissen:<br/>
Adjusted implementation for grouping of solar calculations.
</li>
</ul>
</html>"));
end Window;
