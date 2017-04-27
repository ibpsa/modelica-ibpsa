within IDEAS.Buildings.Components;
model RectangularZoneTemplate
  "Rectangular zone including walls, floor and ceiling"
  extends IDEAS.Buildings.Components.Interfaces.PartialZone(
    redeclare replaceable IDEAS.Buildings.Components.ZoneAirModels.WellMixedAir airModel
    constrainedby
      IDEAS.Buildings.Components.ZoneAirModels.BaseClasses.PartialAirModel(
      mSenFac=mSenFac),
    calculateViewFactor=false,
    final nSurf=indWinCei+nSurfExt,
    final V=l*w*h,
    final hZone=h,
    final A=l*w,
    final fRH=11);

  parameter IDEAS.Buildings.Components.Interfaces.BoundaryType bouTypA
    "Modelled boundary for face A of the zone"
    annotation(Dialog(tab="Face A", group="Construction details"));
  parameter IDEAS.Buildings.Components.Interfaces.BoundaryType bouTypB
    "Modelled boundary for face B of the zone"
    annotation(Dialog(tab="Face B", group="Construction details"));
  parameter IDEAS.Buildings.Components.Interfaces.BoundaryType bouTypC
    "Modelled boundary for face C of the zone"
    annotation(Dialog(tab="Face C", group="Construction details"));
  parameter IDEAS.Buildings.Components.Interfaces.BoundaryType bouTypD
    "Modelled boundary for face D of the zone"
    annotation(Dialog(tab="Face D", group="Construction details"));
  parameter IDEAS.Buildings.Components.Interfaces.BoundaryType bouTypFlo
    "Modelled boundary for the zone floor"
    annotation(Dialog(tab="Floor", group="Construction details"));
  parameter IDEAS.Buildings.Components.Interfaces.BoundaryType bouTypCei
    "Modelled boundary for the zone ceiling"
    annotation(Dialog(tab="Ceiling", group="Construction details"));
  parameter Boolean hasWinA = false
    "Modelling window for face A if true"
    annotation(Dialog(tab="Face A", group="Window details"));
  parameter Boolean hasWinB = false
    "Modelling window for face B if true"
    annotation(Dialog(tab="Face B", group="Window details"));
  parameter Boolean hasWinC = false
    "Modelling window for face C if true"
    annotation(Dialog(tab="Face C", group="Window details"));
  parameter Boolean hasWinD = false
    "Modelling window for face D if true"
    annotation(Dialog(tab="Face D", group="Window details"));
  parameter Boolean hasWinCei = false
    "Modelling window for ceiling if true"
    annotation(Dialog(tab="Ceiling", group="Window details"));
  parameter Integer nSurfExt = 0
    "Number of additional connected external surfaces";
  parameter Modelica.SIunits.Angle aziA
    "Azimuth angle of face A";
  parameter Modelica.SIunits.Length l
    "Horizontal length of faces A and C";
  parameter Modelica.SIunits.Length w
    "Horizontal length of face B and D";
  parameter Modelica.SIunits.Length h
    "Height between top of floor and bottom of ceiling";
  parameter Modelica.SIunits.Area A_winA=0
    "Surface area of window of face A"
    annotation(Dialog(tab="Face A", group="Window details",
    enable=hasWinA));
  parameter Modelica.SIunits.Area A_winB=0
    "Surface area of window of face B"
    annotation(Dialog(tab="Face B", group="Window details",
    enable=hasWinB));
  parameter Modelica.SIunits.Area A_winC=0
    "Surface area of window of face C"
    annotation(Dialog(tab="Face C", group="Window details",
    enable=hasWinC));
  parameter Modelica.SIunits.Area A_winD=0
    "Surface area of window of face D"
    annotation(Dialog(tab="Face D", group="Window details",
    enable=hasWinD));
  parameter Modelica.SIunits.Area A_winCei=0
    "Surface area of window of ceiling"
    annotation(Dialog(tab="Ceiling", group="Window details",
    enable=hasWinCei));

  parameter Real fracA=0.15
    "Area fraction of the window frame of face A"
    annotation(Dialog(tab="Face A", group="Window details",
    enable=hasWinA));
  parameter Real fracB=0.15
    "Area fraction of the window frame of face B"
    annotation(Dialog(tab="Face B", group="Window details",
    enable=hasWinB));
  parameter Real fracC=0.15
    "Area fraction of the window frame of face C"
    annotation(Dialog(tab="Face C", group="Window details",
    enable=hasWinC));
  parameter Real fracD=0.15
    "Area fraction of the window frame of face D"
    annotation(Dialog(tab="Face D", group="Window details",
    enable=hasWinD));
  parameter Real fracCei=0.15
    "Area fraction of the window frame of the ceiling"
    annotation(Dialog(tab="Ceiling", group="Window details",
    enable=hasWinCei));
  parameter Boolean linIntCon=sim.linIntCon
    "= true, if convective heat transfer should be linearised"
    annotation(Dialog(tab="Advanced", group="Convective heat exchange"));
  parameter Interfaces.WindowDynamicsType windowDynamicsType=IDEAS.Buildings.Components.Interfaces.WindowDynamicsType.Two
    "Type of dynamics for glazings and frames: using zero, one combined or two states"
    annotation(Dialog(group="Windows", tab="Advanced"));
  parameter SI.TemperatureDifference dT_nominal_win=-3
    "Nominal temperature difference used for linearisation, negative temperatures indicate the solid is colder"
    annotation(Dialog(group="Convective heat transfer", tab="Advanced"));
  parameter Boolean linExtCon=sim.linExtCon
    "= true, if exterior convective heat transfer should be linearised (uses average wind speed)"
    annotation(Dialog(tab="Advanced", group="Convective heat exchange"));
  parameter Boolean linExtRad=sim.linExtRad
    "= true, if exterior radiative heat transfer for walls should be linearised"
    annotation(Dialog(tab="Advanced", group="Radiative heat exchange"));
  parameter Boolean linExtRadWin=sim.linExtRadWin
    "= true, if exterior radiative heat transfer for windows should be linearised"
    annotation(Dialog(tab="Advanced", group="Radiative heat exchange"));

  parameter Real mSenFac(min=0.1)=5
    "Factor for scaling the sensible thermal mass of the zone air"
    annotation(Dialog(tab="Advanced",group="Air model"));
  parameter SI.TemperatureDifference dT_nominal_bou=-1
    "Nominal temperature difference for boundary walls, used for linearisation, negative temperatures indicate the solid is colder"
    annotation(Dialog(tab="Advanced", group="Convective heat transfer"));
  parameter SI.TemperatureDifference dT_nominal_out=-3
    "Nominal temperature difference for outer walls, used for linearisation, negative temperatures indicate the solid is colder"
    annotation(Dialog(tab="Advanced", group="Convective heat transfer"));
  parameter SI.TemperatureDifference dT_nominal_sla=-3
    "Nominal temperature difference of slab on ground, used for linearisation, negative temperatures indicate the solid is colder"
    annotation(Dialog(tab="Advanced", group="Convective heat transfer"));
  parameter SI.Temperature TeAvg=273.15 + 10.8
    "Annual average outdoor temperature"
    annotation(Dialog(tab="Floor", group="Slab on ground", enable=bouTypFlo == IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround));
  parameter SI.Temperature TiAvg=273.15 + 22
    "Annual average indoor temperature"
    annotation(Dialog(tab="Floor", group="Slab on ground", enable=bouTypFlo == IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround));
  parameter SI.TemperatureDifference dTeAvg=4
    "Amplitude of variation of monthly average outdoor temperature"
    annotation(Dialog(tab="Floor", group="Slab on ground", enable=bouTypFlo == IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround));
  parameter SI.TemperatureDifference dTiAvg=2
    "Amplitude of variation of monthly average indoor temperature"
    annotation(Dialog(tab="Floor", group="Slab on ground", enable=bouTypFlo == IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround));
  parameter SI.TemperatureDifference dT_nominal_intA=1
    "Nominal temperature difference between zone air and interior walls, used for linearisation"
    annotation(Dialog(tab="Advanced", group="Convective heat transfer"));
  parameter SI.TemperatureDifference dT_nominal_intB=1
    "Nominal temperature difference between interior walls exterior connection, used for linearisation"
    annotation(Dialog(tab="Advanced", group="Convective heat transfer"));
  replaceable parameter IDEAS.Buildings.Data.Constructions.CavityWall conTypA
    constrainedby IDEAS.Buildings.Data.Interfaces.Construction
    "Material structure of face A" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-228,8},{-224,12}})),
    Dialog(tab="Face A",group="Construction details",
           enable=not
                 (bouTypA==IDEAS.Buildings.Components.Interfaces.BoundaryType.External)));
  replaceable parameter IDEAS.Buildings.Data.Constructions.CavityWall conTypB
    constrainedby IDEAS.Buildings.Data.Interfaces.Construction
    "Material structure of face B" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-228,-12},{-224,-8}})),
    Dialog(tab="Face B",group="Construction details",
           enable=not
                 (bouTypB==IDEAS.Buildings.Components.Interfaces.BoundaryType.External)));
  replaceable parameter IDEAS.Buildings.Data.Constructions.CavityWall conTypC
    constrainedby IDEAS.Buildings.Data.Interfaces.Construction
    "Material structure of face C" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-228,-32},{-224,-28}})),
    Dialog(tab="Face C",group="Construction details",
           enable=not
                 (bouTypC==IDEAS.Buildings.Components.Interfaces.BoundaryType.External)));
  replaceable parameter IDEAS.Buildings.Data.Constructions.CavityWall conTypD
    constrainedby IDEAS.Buildings.Data.Interfaces.Construction
    "Material structure of face D" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-228,-52},{-224,-48}})),
    Dialog(tab="Face D",group="Construction details",
           enable=not
                 (bouTypD==IDEAS.Buildings.Components.Interfaces.BoundaryType.External)));
  replaceable parameter IDEAS.Buildings.Data.Constructions.CavityWall conTypCei
    constrainedby IDEAS.Buildings.Data.Interfaces.Construction
    "Material structure of ceiling" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-228,-92},{-224,-88}})),
    Dialog(tab="Ceiling",group="Construction details",
           enable=not
                 (bouTypCei==IDEAS.Buildings.Components.Interfaces.BoundaryType.External)));
  replaceable parameter IDEAS.Buildings.Data.Constructions.CavityWall conTypFlo
    constrainedby IDEAS.Buildings.Data.Interfaces.Construction
    "Material structure of floor" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-228,-72},{-224,-68}})),
    Dialog(tab="Floor",group="Construction details",
           enable=not
                 (bouTypFlo==IDEAS.Buildings.Components.Interfaces.BoundaryType.External)));
  replaceable IDEAS.Buildings.Data.Glazing.Ins2 glazingA
    constrainedby IDEAS.Buildings.Data.Interfaces.Glazing "Glazing type of window of face A"
    annotation (choicesAllMatching=true,
    Dialog(tab="Face A", group="Window details",
           enable = hasWinA));
  replaceable IDEAS.Buildings.Data.Glazing.Ins2 glazingB
    constrainedby IDEAS.Buildings.Data.Interfaces.Glazing "Glazing type of window of face B"
    annotation (choicesAllMatching=true,
    Dialog(tab="Face B", group="Window details",
           enable = hasWinB));
  replaceable IDEAS.Buildings.Data.Glazing.Ins2 glazingC
    constrainedby IDEAS.Buildings.Data.Interfaces.Glazing "Glazing type of window of face C"
    annotation (choicesAllMatching=true,
    Dialog(tab="Face C", group="Window details",
           enable = hasWinC));
  replaceable IDEAS.Buildings.Data.Glazing.Ins2 glazingD
    constrainedby IDEAS.Buildings.Data.Interfaces.Glazing "Glazing type of window of face D"
    annotation (choicesAllMatching=true,
    Dialog(tab="Face D", group="Window details",
           enable = hasWinD));
  replaceable IDEAS.Buildings.Data.Glazing.Ins2 glazingCei
    constrainedby IDEAS.Buildings.Data.Interfaces.Glazing "Glazing type of window of ceiling"
    annotation (
           choicesAllMatching=true,
           Dialog(tab="Ceiling", group="Window details",
           enable = hasWinCei));

  replaceable parameter IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties shaTypA
    constrainedby
    IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties
    "Shading type and properties of window of face A"
    annotation (
           choicesAllMatching=true,
           Dialog(tab="Face A", group="Window details",
           enable = hasWinA));
  replaceable parameter IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties shaTypB
    constrainedby
    IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties
    "Shading type and properties of window of face B"
    annotation (
           choicesAllMatching=true,
           Dialog(tab="Face B", group="Window details",
           enable = hasWinB));
  replaceable parameter IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties shaTypC
    constrainedby
    IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties
    "Shading type and properties of window of face C"
    annotation (
           choicesAllMatching=true,
           Dialog(tab="Face C", group="Window details",
           enable = hasWinC));
  replaceable parameter IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties shaTypD
    constrainedby
    IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties
    "Shading type and properties of window of face D"
    annotation (
           choicesAllMatching=true,
           Dialog(tab="Face D", group="Window details",
           enable = hasWinD));
  replaceable parameter IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties shaTypCei
    constrainedby
    IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties
    "Shading type and properties of window of ceiling"
    annotation (
           choicesAllMatching=true,
           Dialog(tab="Ceiling", group="Window details",
           enable = hasWinCei));
  replaceable parameter IDEAS.Buildings.Data.Frames.None fraTypA
    constrainedby IDEAS.Buildings.Data.Interfaces.Frame
    "Window frame type for surface A"
    annotation (choicesAllMatching=true,
                Dialog(tab="Face A", group="Window details", enable=hasWinA));
  replaceable parameter IDEAS.Buildings.Data.Frames.None fraTypB
    constrainedby IDEAS.Buildings.Data.Interfaces.Frame
    "Window frame type for surface B"
    annotation (choicesAllMatching=true,
                Dialog(tab="Face B", group="Window details", enable=hasWinB));
  replaceable parameter IDEAS.Buildings.Data.Frames.None fraTypC
    constrainedby IDEAS.Buildings.Data.Interfaces.Frame
    "Window frame type for surface C"
    annotation (choicesAllMatching=true,
                Dialog(tab="Face C", group="Window details", enable=hasWinC));
  replaceable parameter IDEAS.Buildings.Data.Frames.None fraTypD
    constrainedby IDEAS.Buildings.Data.Interfaces.Frame
    "Window frame type for surface D"
    annotation (choicesAllMatching=true,
                Dialog(tab="Face D", group="Window details", enable=hasWinD));
  replaceable parameter IDEAS.Buildings.Data.Frames.None fraTypCei
    constrainedby IDEAS.Buildings.Data.Interfaces.Frame
    "Window frame type for surface Cei"
    annotation (choicesAllMatching=true,
                Dialog(tab="Ceiling", group="Window details", enable=hasWinCei));
  IDEAS.Buildings.Components.Interfaces.ZoneBus[nSurfExt] proBusExt(
    each final numIncAndAziInBus=sim.numIncAndAziInBus,
    each final outputAngles=sim.outputAngles) if nSurfExt>0
    "Propsbus for connecting additional external surfaces" annotation (
      Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-210,50}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={-120,100})));
protected
  IDEAS.Buildings.Components.Window winA(azi=aziA, inc=IDEAS.Types.Tilt.Wall,
    glazing(
      nLay=glazingA.nLay,
      mats=glazingA.mats,
      SwAbs=glazingA.SwAbs,
      SwTrans=glazingA.SwTrans,
      SwAbsDif=glazingA.SwAbsDif,
      SwTransDif=glazingA.SwTransDif,
      U_value=glazingA.U_value,
      g_value=glazingA.g_value),
    A=A_winA,
    frac=fracA,
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_win,
    linExtCon=linExtCon,
    windowDynamicsType=windowDynamicsType,
    redeclare IDEAS.Buildings.Components.Shading.Shading shaType(shaPro(
  controlled=shaTypA.controlled,
  shaType=shaTypA.shaType,
  hWin=shaTypA.hWin,
  wWin=shaTypA.wWin,
  wLeft=shaTypA.wLeft,
  wRight=shaTypA.wRight,
  ovDep=shaTypA.ovDep,
  ovGap=shaTypA.ovGap,
  hFin=shaTypA.hFin,
  finDep=shaTypA.finDep,
  finGap=shaTypA.finGap,
  L=shaTypA.L,
  dh=shaTypA.dh,
  shaCorr=shaTypA.shaCorr)),
    fraType(present=fraTypA.present,
            U_value=fraTypA.U_value),
    linExtRad=linExtRadWin) if
       hasWinA
    "Window for face A of this zone" annotation (Placement(transformation(extent={{-100,0},{-90,20}})));
  IDEAS.Buildings.Components.Window winB(
      inc=IDEAS.Types.Tilt.Wall,
    glazing(
      nLay=glazingB.nLay,
      mats=glazingB.mats,
      SwAbs=glazingB.SwAbs,
      SwTrans=glazingB.SwTrans,
      SwAbsDif=glazingB.SwAbsDif,
      SwTransDif=glazingB.SwTransDif,
      U_value=glazingB.U_value,
      g_value=glazingB.g_value),
    A=A_winB,
    frac=fraB,
    azi=aziA + Modelica.Constants.pi/2,
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_win,
    linExtCon=linExtCon,
    windowDynamicsType=windowDynamicsType,
    redeclare IDEAS.Buildings.Components.Shading.Shading shaType(shaPro(
  controlled=shaTypB.controlled,
  shaType=shaTypB.shaType,
  hWin=shaTypB.hWin,
  wWin=shaTypB.wWin,
  wLeft=shaTypB.wLeft,
  wRight=shaTypB.wRight,
  ovDep=shaTypB.ovDep,
  ovGap=shaTypB.ovGap,
  hFin=shaTypB.hFin,
  finDep=shaTypB.finDep,
  finGap=shaTypB.finGap,
  L=shaTypB.L,
  dh=shaTypB.dh,
  shaCorr=shaTypB.shaCorr)),
    fraType(present=fraTypB.present, U_value=fraTypB.U_value),
    linExtRad=linExtRadWin) if
       hasWinB
    "Window for face B of this zone" annotation (Placement(
        transformation(
        extent={{-5,-10},{5,10}},
        rotation=0,
        origin={-95,-10})));
  IDEAS.Buildings.Components.Window winC(inc=IDEAS.Types.Tilt.Wall,
    glazing(
      nLay=glazingC.nLay,
      mats=glazingC.mats,
      SwAbs=glazingC.SwAbs,
      SwTrans=glazingC.SwTrans,
      SwAbsDif=glazingC.SwAbsDif,
      SwTransDif=glazingC.SwTransDif,
      U_value=glazingC.U_value,
      g_value=glazingC.g_value),
    A=A_winC,
    frac=fracC,
    azi=aziA + Modelica.Constants.pi,
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_win,
    linExtCon=linExtCon,
    windowDynamicsType=windowDynamicsType,
    redeclare IDEAS.Buildings.Components.Shading.Shading shaType(shaPro(
  controlled=shaTypC.controlled,
  shaType=shaTypC.shaType,
  hWin=shaTypC.hWin,
  wWin=shaTypC.wWin,
  wLeft=shaTypC.wLeft,
  wRight=shaTypC.wRight,
  ovDep=shaTypC.ovDep,
  ovGap=shaTypC.ovGap,
  hFin=shaTypC.hFin,
  finDep=shaTypC.finDep,
  finGap=shaTypC.finGap,
  L=shaTypC.L,
  dh=shaTypC.dh,
  shaCorr=shaTypC.shaCorr)),
    fraType(present=fraTypC.present, U_value=fraTypC.U_value),
    linExtRad=linExtRadWin) if
       hasWinC
    "Window for face C of this zone" annotation (Placement(
        transformation(
        extent={{-5,-10},{5,10}},
        rotation=0,
        origin={-95,-30})));
  IDEAS.Buildings.Components.Window winD(inc=IDEAS.Types.Tilt.Wall, azi=aziA +
        Modelica.Constants.pi/2*3,
    glazing(
      nLay=glazingD.nLay,
      mats=glazingD.mats,
      SwAbs=glazingD.SwAbs,
      SwTrans=glazingD.SwTrans,
      SwAbsDif=glazingD.SwAbsDif,
      SwTransDif=glazingD.SwTransDif,
      U_value=glazingD.U_value,
      g_value=glazingD.g_value),
    A=A_winD,
    frac=fracD,
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_win,
    linExtCon=linExtCon,
    windowDynamicsType=windowDynamicsType,
    redeclare IDEAS.Buildings.Components.Shading.Shading shaType(shaPro(
      controlled=shaTypD.controlled,
  shaType=shaTypD.shaType,
  hWin=shaTypD.hWin,
  wWin=shaTypD.wWin,
  wLeft=shaTypD.wLeft,
  wRight=shaTypD.wRight,
  ovDep=shaTypD.ovDep,
  ovGap=shaTypD.ovGap,
  hFin=shaTypD.hFin,
  finDep=shaTypD.finDep,
  finGap=shaTypD.finGap,
  L=shaTypD.L,
  dh=shaTypD.dh,
  shaCorr=shaTypD.shaCorr)),
    fraType(present=fraTypD.present, U_value=fraTypD.U_value),
    linExtRad=linExtRadWin) if
       hasWinD
    "Window for face D of this zone" annotation (Placement(
        transformation(
        extent={{-5,-10},{5,10}},
        rotation=0,
        origin={-95,-50})));
  IDEAS.Buildings.Components.Window winCei(inc=IDEAS.Types.Tilt.Ceiling, azi=aziA,
    glazing(
      nLay=glazingCei.nLay,
      mats=glazingCei.mats,
      SwAbs=glazingCei.SwAbs,
      SwTrans=glazingCei.SwTrans,
      SwAbsDif=glazingCei.SwAbsDif,
      SwTransDif=glazingCei.SwTransDif,
      U_value=glazingCei.U_value,
      g_value=glazingCei.g_value),
    A=A_winCei,
    frac=fracCei,
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_win,
    linExtCon=linExtCon,
    windowDynamicsType=windowDynamicsType,
    redeclare IDEAS.Buildings.Components.Shading.Shading shaType(shaPro(
      controlled=shaTypCei.controlled,
  shaType=shaTypCei.shaType,
  hWin=shaTypCei.hWin,
  wWin=shaTypCei.wWin,
  wLeft=shaTypCei.wLeft,
  wRight=shaTypCei.wRight,
  ovDep=shaTypCei.ovDep,
  ovGap=shaTypCei.ovGap,
  hFin=shaTypCei.hFin,
  finDep=shaTypCei.finDep,
  finGap=shaTypCei.finGap,
  L=shaTypCei.L,
  dh=shaTypCei.dh,
  shaCorr=shaTypCei.shaCorr)),
    fraType(present=fraTypCei.present, U_value=fraTypCei.U_value),
    linExtRad=linExtRadWin) if
       hasWinCei
    "Window for ceiling of this zone" annotation (Placement(
        transformation(
        extent={{-5,-10},{5,10}},
        rotation=0,
        origin={-95,-90})));

  IDEAS.Buildings.Components.BoundaryWall bouA(azi=aziA, inc=IDEAS.Types.Tilt.Wall,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypA.locGain,
      incLastLay=conTypA.incLastLay,
      mats=conTypA.mats),
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_bou,
    A=l*h - (if hasWinA then A_winA else 0)) if
       hasBouA
    "Boundary wall for face A of this zone"
    annotation (Placement(transformation(extent={{-120,0},{-110,20}})));
  IDEAS.Buildings.Components.BoundaryWall bouB(
           inc=IDEAS.Types.Tilt.Wall,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypB.locGain,
      incLastLay=conTypB.incLastLay,
      mats=conTypB.mats),
    azi=aziA + Modelica.Constants.pi/2,
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_bou,
    A=w*h - (if hasWinB then A_winB else 0)) if
       hasBouB
    "Boundary wall for face A of this zone"
    annotation (Placement(transformation(extent={{-120,-20},{-110,0}})));
  IDEAS.Buildings.Components.BoundaryWall bouC(inc=IDEAS.Types.Tilt.Wall,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypC.locGain,
      incLastLay=conTypC.incLastLay,
      mats=conTypC.mats),
    azi=aziA + Modelica.Constants.pi,
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_bou,
    A=l*h - (if hasWinC then A_winC else 0)) if
       hasBouC
    "Boundary wall for face C of this zone"
    annotation (Placement(transformation(extent={{-120,-40},{-110,-20}})));
  IDEAS.Buildings.Components.BoundaryWall bouD(inc=IDEAS.Types.Tilt.Wall, azi=aziA
         + Modelica.Constants.pi/2*3,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypD.locGain,
      incLastLay=conTypD.incLastLay,
      mats=conTypD.mats),
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_bou,
    A=w*h - (if hasWinD then A_winD else 0)) if
       hasBouD
    "Boundary wall for face D of this zone"
    annotation (Placement(transformation(extent={{-120,-60},{-110,-40}})));
  IDEAS.Buildings.Components.BoundaryWall bouFlo(inc=IDEAS.Types.Tilt.Floor, azi=aziA,
    A=A,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypFlo.locGain,
      incLastLay=conTypFlo.incLastLay,
      mats=conTypFlo.mats),
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_bou) if
       hasBouFlo
    "Boundary wall for zone floor"
    annotation (Placement(transformation(extent={{-120,-80},{-110,-60}})));
  IDEAS.Buildings.Components.BoundaryWall bouCei(inc=IDEAS.Types.Tilt.Ceiling, azi=aziA,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypCei.locGain,
      incLastLay=conTypCei.incLastLay,
      mats=conTypCei.mats),
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_bou,
    A=A - (if hasWinCei then A_winCei else 0)) if
       hasBouCei
    "Boundary wall for zone ceiling"
    annotation (Placement(transformation(extent={{-120,-100},{-110,-80}})));
  IDEAS.Buildings.Components.OuterWall outA(azi=aziA, inc=IDEAS.Types.Tilt.Wall,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypA.locGain,
      incLastLay=conTypA.incLastLay,
      mats=conTypA.mats),
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_out,
    linExtCon=linExtCon,
    linExtRad=linExtRad,
    A=l*h - (if hasWinA then A_winA else 0)) if
       hasOutA
    "Outer wall for face A of this zone"
    annotation (Placement(transformation(extent={{-140,0},{-130,20}})));
  IDEAS.Buildings.Components.OuterWall outB(
      inc=IDEAS.Types.Tilt.Wall,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypB.locGain,
      incLastLay=conTypB.incLastLay,
      mats=conTypB.mats),
    azi=aziA + Modelica.Constants.pi/2,
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_out,
    linExtCon=linExtCon,
    linExtRad=linExtRad,
    A=w*h - (if hasWinB then A_winB else 0)) if
       hasOutB
    "Outer wall for face B of this zone"
    annotation (Placement(transformation(extent={{-140,-20},{-130,0}})));
  IDEAS.Buildings.Components.OuterWall outC(inc=IDEAS.Types.Tilt.Wall,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypC.locGain,
      incLastLay=conTypC.incLastLay,
      mats=conTypC.mats),
    azi=aziA + Modelica.Constants.pi,
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_out,
    linExtCon=linExtCon,
    linExtRad=linExtRad,
    A=l*h - (if hasWinC then A_winC else 0)) if
       hasOutC
    "Outer wall for face C of this zone"
    annotation (Placement(transformation(extent={{-140,-40},{-130,-20}})));
  IDEAS.Buildings.Components.OuterWall outD(inc=IDEAS.Types.Tilt.Wall, azi=aziA +
        Modelica.Constants.pi/2*3,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypD.locGain,
      incLastLay=conTypD.incLastLay,
      mats=conTypD.mats),
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_out,
    linExtCon=linExtCon,
    linExtRad=linExtRad,
    A=w*h - (if hasWinD then A_winD else 0)) if
       hasOutD
    "Outer wall for face D of this zone"
    annotation (Placement(transformation(extent={{-140,-60},{-130,-40}})));
  IDEAS.Buildings.Components.OuterWall outCei(
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=aziA,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypCei.locGain,
      incLastLay=conTypCei.incLastLay,
      mats=conTypCei.mats),
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_out,
    linExtCon=linExtCon,
    linExtRad=linExtRad,
    A=A - (if hasWinCei then A_winCei else 0)) if
       hasOutCei
    "Outer wall for zone ceiling"
    annotation (Placement(transformation(extent={{-140,-100},{-130,-80}})));
  IDEAS.Buildings.Components.SlabOnGround slaOnGro(
    inc=IDEAS.Types.Tilt.Floor,
    azi=aziA,
    A=A,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypFlo.locGain,
      incLastLay=conTypFlo.incLastLay,
      mats=conTypFlo.mats),
    T_start=T_start,
    linIntCon_a=linIntCon,
    PWall=2*(l + w),
    TeAvg=TeAvg,
    TiAvg=TiAvg,
    dTeAvg=dTeAvg,
    dTiAvg=dTiAvg,
    dT_nominal_a=dT_nominal_sla) if
     bouTypFlo == IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround
    "Slab on ground model for zone floor"
    annotation (Placement(transformation(extent={{-160,-80},{-150,-60}})));
  IDEAS.Buildings.Components.InternalWall intA(azi=aziA, inc=IDEAS.Types.Tilt.Wall,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypA.locGain,
      mats=conTypA.mats,
      incLastLay=conTypA.incLastLay),
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_intA,
    linIntCon_b=linIntCon,
    dT_nominal_b=dT_nominal_intB,
    A=l*h - (if hasWinA then A_winA else 0)) if
    hasIntA
    "Internal wall for face A of this zone"
    annotation (Placement(transformation(extent={{-176,0},{-164,20}})));
  IDEAS.Buildings.Components.InternalWall intB(
           inc=IDEAS.Types.Tilt.Wall,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypB.locGain,
      incLastLay=conTypB.incLastLay,
      mats=conTypB.mats),
    azi=aziA + Modelica.Constants.pi/2,
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_intA,
    linIntCon_b=linIntCon,
    dT_nominal_b=dT_nominal_intB,
    A=w*h - (if hasWinB then A_winB else 0)) if
    hasIntB
    "Internal wall for face B of this zone"
    annotation (Placement(transformation(extent={{-176,-20},{-164,0}})));
  IDEAS.Buildings.Components.InternalWall intC(inc=IDEAS.Types.Tilt.Wall,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypC.locGain,
      incLastLay=conTypC.incLastLay,
      mats=conTypC.mats),
    azi=aziA + Modelica.Constants.pi,
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_intA,
    linIntCon_b=linIntCon,
    dT_nominal_b=dT_nominal_intB,
    A=l*h - (if hasWinC then A_winC else 0)) if
    hasIntC
    "Internal wall for face C of this zone"
    annotation (Placement(transformation(extent={{-176,-40},{-164,-20}})));
  IDEAS.Buildings.Components.InternalWall intD(inc=IDEAS.Types.Tilt.Wall, azi=aziA
         + Modelica.Constants.pi/2*3,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypD.locGain,
      incLastLay=conTypD.incLastLay,
      mats=conTypD.mats),
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_intA,
    linIntCon_b=linIntCon,
    dT_nominal_b=dT_nominal_intB,
    A=w*h - (if hasWinD then A_winD else 0)) if
    hasIntD
    "Internal wall for face D of this zone"
    annotation (Placement(transformation(extent={{-176,-60},{-164,-40}})));
  IDEAS.Buildings.Components.InternalWall intFlo(
    inc=IDEAS.Types.Tilt.Floor,
    azi=aziA,
    A=A,
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType(
      locGain=conTypFlo.locGain,
      incLastLay=conTypFlo.incLastLay,
      mats=conTypFlo.mats),
    T_start=T_start,
    linIntCon_a=linIntCon,
    dT_nominal_a=dT_nominal_intA,
    linIntCon_b=linIntCon,
    dT_nominal_b=dT_nominal_intB) if
    hasIntFlo
    "Internal wall for zone floor"
    annotation (Placement(transformation(extent={{-176,-80},{-164,-60}})));
public
  IDEAS.Buildings.Components.Interfaces.ZoneBus proBusA(
    final numIncAndAziInBus=sim.numIncAndAziInBus,
    final outputAngles=sim.outputAngles) if
    bouTypA == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall or
    bouTypA == IDEAS.Buildings.Components.Interfaces.BoundaryType.External
    "Propsbus connector for connecting to external surface or internalWall of face A"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-188,10}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={-60,90})));
  IDEAS.Buildings.Components.Interfaces.ZoneBus proBusB(
    final numIncAndAziInBus=sim.numIncAndAziInBus,
    final outputAngles=sim.outputAngles) if
    bouTypB == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall or
    bouTypB == IDEAS.Buildings.Components.Interfaces.BoundaryType.External
    "Propsbus connector for connecting to external surface or internalWall of face B"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-188,-10}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={90,60})));
  IDEAS.Buildings.Components.Interfaces.ZoneBus proBusC(
    final numIncAndAziInBus=sim.numIncAndAziInBus,
    final outputAngles=sim.outputAngles) if
    bouTypC == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall or
    bouTypC == IDEAS.Buildings.Components.Interfaces.BoundaryType.External
    "Propsbus connector for connecting to external surface or internalWall of face C"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-188,-30}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=0,
        origin={0,-90})));
  IDEAS.Buildings.Components.Interfaces.ZoneBus proBusD(
    final numIncAndAziInBus=sim.numIncAndAziInBus,
    final outputAngles=sim.outputAngles) if
    bouTypD == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall or
    bouTypD == IDEAS.Buildings.Components.Interfaces.BoundaryType.External
    "Propsbus connector for connecting to external surface or internalWall of face D"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-188,-50}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-90,0})));
  IDEAS.Buildings.Components.Interfaces.ZoneBus proBusFlo(
    final numIncAndAziInBus=sim.numIncAndAziInBus,
    final outputAngles=sim.outputAngles) if
    bouTypFlo == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall or
    bouTypFlo == IDEAS.Buildings.Components.Interfaces.BoundaryType.External
    "Propsbus connector for connecting to external surface or internalWall of floor"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-188,-70}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={0,-60})));
  IDEAS.Buildings.Components.Interfaces.ZoneBus proBusCei(
    final numIncAndAziInBus=sim.numIncAndAziInBus,
    final outputAngles=sim.outputAngles) if
    bouTypCei == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall or
    bouTypCei == IDEAS.Buildings.Components.Interfaces.BoundaryType.External
    "Propsbus connector for connecting to external surface of ceiling: internal walls should be modelled as the floor of the zone above"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-188,-90}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={-2,60})));
protected
  final parameter Boolean hasBouA=
    bouTypA == IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall;
  final parameter Boolean hasBouB=
    bouTypB == IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall;
  final parameter Boolean hasBouC=
    bouTypC == IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall;
  final parameter Boolean hasBouD=
    bouTypD == IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall;
  final parameter Boolean hasBouFlo=
    bouTypFlo == IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall;
  final parameter Boolean hasBouCei=
    bouTypCei == IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall;
  final parameter Boolean hasOutA=
    bouTypA == IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall;
  final parameter Boolean hasOutB=
    bouTypB == IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall;
  final parameter Boolean hasOutC=
    bouTypC == IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall;
  final parameter Boolean hasOutD=
    bouTypD == IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall;
  final parameter Boolean hasOutCei=
    bouTypCei == IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall;
  final parameter Boolean hasIntA=
    bouTypA == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall;
  final parameter Boolean hasIntB=
    bouTypB == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall;
  final parameter Boolean hasIntC=
    bouTypC == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall;
  final parameter Boolean hasIntD=
    bouTypD == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall;
  final parameter Boolean hasIntFlo=
    bouTypFlo == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall;
  final parameter Boolean hasExtA=
    bouTypA == IDEAS.Buildings.Components.Interfaces.BoundaryType.External;
  final parameter Boolean hasExtB=
    bouTypB == IDEAS.Buildings.Components.Interfaces.BoundaryType.External;
  final parameter Boolean hasExtC=
    bouTypC == IDEAS.Buildings.Components.Interfaces.BoundaryType.External;
  final parameter Boolean hasExtD=
    bouTypD == IDEAS.Buildings.Components.Interfaces.BoundaryType.External;
  final parameter Boolean hasExtFlo=
    bouTypFlo == IDEAS.Buildings.Components.Interfaces.BoundaryType.External;
  final parameter Boolean hasExtCei=
    bouTypCei == IDEAS.Buildings.Components.Interfaces.BoundaryType.External;

  final parameter Integer indWinA = 6 + (if hasWinA then 1 else 0);
  final parameter Integer indWinB = indWinA + (if hasWinB then 1 else 0);
  final parameter Integer indWinC = indWinB + (if hasWinC then 1 else 0);
  final parameter Integer indWinD = indWinC + (if hasWinD then 1 else 0);
  final parameter Integer indWinCei = indWinD + (if hasWinCei then 1 else 0);

initial equation
  assert(not bouTypA==IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    "The value for bouTypA is not supported");
  assert(not bouTypB==IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    "The value for bouTypB is not supported");
  assert(not bouTypC==IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    "The value for bouTypC is not supported");
  assert(not bouTypD==IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    "The value for bouTypD is not supported");
  assert(not bouTypCei==IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    "The value for bouTypCei is not supported");
  assert(not (bouTypCei==IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall),
              "Using internal walls for the ceiling is not allowed because it is considered bad practice. 
              Use instead the 'External'  connection to connect the the floor of the surface above, 
              or use this option to connect and internal wall externally.");
  assert(not (hasWinA and bouTypA == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall),
    "Combining an internal wall with an (exterior) window is not allowed since this is non-physical.");
  assert(not (hasWinB and bouTypB == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall),
    "Combining an internal wall with an (exterior) window is not allowed since this is non-physical.");
  assert(not (hasWinC and bouTypC == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall),
    "Combining an internal wall with an (exterior) window is not allowed since this is non-physical.");
  assert(not (hasWinD and bouTypD == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall),
    "Combining an internal wall with an (exterior) window is not allowed since this is non-physical.");
  assert(not (hasWinCei and bouTypCei == IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall),
    "Combining an internal wall with an (exterior) window is not allowed since this is non-physical.");




equation
  connect(intA.propsBus_a, propsBusInt[1]) annotation (Line(
      points={{-165,12},{-152,12},{-152,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(intB.propsBus_a, propsBusInt[2]) annotation (Line(
      points={{-165,-8},{-152,-8},{-152,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(intC.propsBus_a, propsBusInt[3]) annotation (Line(
      points={{-165,-28},{-152,-28},{-152,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(intD.propsBus_a, propsBusInt[4]) annotation (Line(
      points={{-165,-48},{-152,-48},{-152,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(intFlo.propsBus_a, propsBusInt[5]) annotation (Line(
      points={{-165,-68},{-152,-68},{-152,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(slaOnGro.propsBus_a, propsBusInt[5]) annotation (Line(
      points={{-150.833,-68},{-150.833,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(outA.propsBus_a, propsBusInt[1]) annotation (Line(
      points={{-130.833,12},{-130.833,12},{-124,12},{-124,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(outB.propsBus_a, propsBusInt[2]) annotation (Line(
      points={{-130.833,-8},{-124,-8},{-124,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(outC.propsBus_a, propsBusInt[3]) annotation (Line(
      points={{-130.833,-28},{-124,-28},{-124,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(outD.propsBus_a, propsBusInt[4]) annotation (Line(
      points={{-130.833,-48},{-124,-48},{-124,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(outCei.propsBus_a, propsBusInt[6]) annotation (Line(
      points={{-130.833,-88},{-124,-88},{-124,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(bouA.propsBus_a, propsBusInt[1]) annotation (Line(
      points={{-110.833,12},{-110.833,12},{-106,12},{-106,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(bouB.propsBus_a, propsBusInt[2]) annotation (Line(
      points={{-110.833,-8},{-106,-8},{-106,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(bouC.propsBus_a, propsBusInt[3]) annotation (Line(
      points={{-110.833,-28},{-106,-28},{-106,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(bouD.propsBus_a, propsBusInt[4]) annotation (Line(
      points={{-110.833,-48},{-106,-48},{-106,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(bouFlo.propsBus_a, propsBusInt[5]) annotation (Line(
      points={{-110.833,-68},{-106,-68},{-106,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(bouCei.propsBus_a, propsBusInt[6]) annotation (Line(
      points={{-110.833,-88},{-106,-88},{-106,-76},{-106,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(winA.propsBus_a, propsBusInt[indWinA]) annotation (Line(
      points={{-90.8333,12},{-88,12},{-88,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(winB.propsBus_a, propsBusInt[indWinB]) annotation (Line(
      points={{-90.8333,-8},{-88,-8},{-88,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(winC.propsBus_a, propsBusInt[indWinC]) annotation (Line(
      points={{-90.8333,-28},{-88,-28},{-88,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(winD.propsBus_a, propsBusInt[indWinD]) annotation (Line(
      points={{-90.8333,-48},{-88,-48},{-88,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(winCei.propsBus_a, propsBusInt[indWinCei]) annotation (Line(
      points={{-90.8333,-88},{-88,-88},{-88,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(intA.propsBus_b, proBusA) annotation (Line(
      points={{-175,12},{-188,12},{-188,10}},
      color={255,204,51},
      thickness=0.5));
  connect(intB.propsBus_b, proBusB) annotation (Line(
      points={{-175,-8},{-188,-8},{-188,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(intC.propsBus_b, proBusC) annotation (Line(
      points={{-175,-28},{-188,-28},{-188,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(intD.propsBus_b, proBusD) annotation (Line(
      points={{-175,-48},{-188,-48},{-188,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(intFlo.propsBus_b, proBusFlo) annotation (Line(
      points={{-175,-68},{-188,-68},{-188,-70}},
      color={255,204,51},
      thickness=0.5));
  if hasExtA then
    connect(proBusA, propsBusInt[1]) annotation (Line(
      points={{-188,10},{-188,10},{-188,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  end if;
  if hasExtB then
    connect(proBusB, propsBusInt[2]) annotation (Line(
      points={{-188,-10},{-188,-10},{-188,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  end if;
  if hasExtC then
    connect(proBusC, propsBusInt[3]) annotation (Line(
      points={{-188,-30},{-188,-30},{-188,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  end if;
  if hasExtD then
    connect(proBusD, propsBusInt[4]) annotation (Line(
      points={{-188,-50},{-188,-50},{-188,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  end if;
  if hasExtFlo then
    connect(proBusFlo, propsBusInt[5]) annotation (Line(
      points={{-188,-70},{-188,-70},{-188,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  end if;
  if hasExtCei then
    connect(proBusCei, propsBusInt[6]) annotation (Line(
      points={{-188,-90},{-188,-90},{-188,40},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  end if;

  connect(propsBusInt[(indWinCei+1):(indWinCei+nSurfExt)], proBusExt[1:nSurfExt]) annotation (Line(
      points={{-80,40},{-82,40},{-82,54},{-82,50},{-210,50}},
      color={255,204,51},
      thickness=0.5));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, initialScale=0.1),
        graphics={
        Text(
          extent={{-60,-72},{-30,-38}},
          lineColor={28,108,200},
          textString="Flo"),
        Text(
          extent={{120,-14},{140,20}},
          lineColor={28,108,200},
          textString="B"),
        Text(
          extent={{-10,-122},{10,-94}},
          lineColor={28,108,200},
          textString="C"),
        Text(
          extent={{-122,-14},{-102,20}},
          lineColor={28,108,200},
          textString="D"),
        Text(
          extent={{18,44},{46,80}},
          lineColor={28,108,200},
          textString="Cei"),
        Text(
          extent={{-10,114},{10,148}},
          lineColor={28,108,200},
          textString="A")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-220,-60},{-200,-80}},
          lineColor={28,108,200},
          textString="Floor"),
        Text(
          extent={{-220,-80},{-200,-100}},
          lineColor={28,108,200},
          textString="Ceiling"),
        Text(
          extent={{-220,-40},{-200,-60}},
          lineColor={28,108,200},
          textString="D"),
        Text(
          extent={{-220,-20},{-200,-40}},
          lineColor={28,108,200},
          textString="C"),
        Text(
          extent={{-220,0},{-200,-20}},
          lineColor={28,108,200},
          textString="B"),
        Text(
          extent={{-220,20},{-200,0}},
          lineColor={28,108,200},
          textString="A")}),
    Documentation(info="<html>
<p>
This model can be used to set up
zones with a rectangular geometry more quickly.
This template consists of a zone, four walls, a horizontal roof and a floor
and five optional windows.
Additional surfaces may also be connected through external bus connector.
</p>
<h4>Main equations</h4>
<p>
This model incorporates IDEAS components such as
<a href=modelica://IDEAS.Buildings.Components.OuterWall>
IDEAS.Buildings.Components.OuterWall</a> and reproduces
the same results as a model that would be constructed without 
the use of this template.
</p>
<h4>Assumption and limitations</h4>
<p>
This model assumes that the zone has a rectangular
geometry with width <code>w</code>, length <code>l</code>
and height <code>h</code>.
All walls are vertical and both the roof and
the floor are horizontal.
</p>
<h4>Typical use and important parameters</h4>
<p>
Parameters width <code>w</code>, length <code>l</code>
and height <code>h</code> need to be defined
and are used to compute the dimensions of each of the surfaces.
Parameter <code>aziA</code> represents the azimuth angle
of surface A (see icon). Other surfaces are rotated (clockwise) by multiples
of ninety degrees with respect to <code>aziA</code>.
Parameter <code>nSurfExt</code> may be used
to connect additional surfaces to the template. 
When doing this, you may need to change the surface areas of
the surfaces in the template as these are not updated automatically.
</p>
<p>
Six parameter tabs allow to specify further parameters
that are specific for each of the six surfaces.
For each surface the surface type may be specified
using parameters <code>bouTyp*</code>.
The construction type should be defined
using <code>conTyp*</code>.
Parameter <code>hasWin*</code> may be used
for all orientations except for the floor to add
a window.
In this case the window surface area, shading and glazing 
types need to be provided.
For non-default shading a record needs to be created that specifies
the shading properties.
The surface area of the window is deducted from the surface area
of the wall such that the total surface areas add up.
</p>
<h4>Options</h4>
<p>
Advanced options are found under the <code>Advanced</code> 
parameter tab. 
The model may also be adapted further by
overriding the default parameter assignments in the template.
</p>
<h4>Dynamics</h4>
<p>
This model contains wall dynamics
and a state for the zone air temperature.
The zone temperature may be set to steady state using
parameter <code>energyDynamicsAir</code>, which should
in general not be done.
The mass dynamics of the air volume
may be set to steady state by overriding the default parameter
assignment in the <code>airModel</code> submodel.
This removes small time constants
when the zone model is connected to an air flow circuit. 
</p>
<h4>Validation</h4>
<p>
This implementation is compared with a manual implementation
in <a href=modelica://IDEAS.Buildings.Validation.Tests.ZoneTemplateVerification2>
IDEAS.Buildings.Validation.Tests.ZoneTemplateVerification2</a>.
This gives identical results.
</p>
<h4>Example</h4>
<p>
An example of how this template may be used
can be found in 
<a href=modelica://IDEAS.Examples.PPD12>IDEAS.Examples.PPD12</a>.
</p>
<h4>Implementation</h4>
<p>
Shading types need to be declared using a record instead of
by redeclaring the shading components.
This is a workaround because redeclared 
components cannot be propagated.
</p>
</html>", revisions="<html>
<ul>
<li>
April 26, 2017, by Filip Jorissen:<br/>
Added asserts that check for illegal combinations of internal wall with exterior window.
See issue <a href=https://github.com/open-ideas/IDEAS/issues/714>#714</a>.
</li>
<li>
March 21, 2017, by Filip Jorissen:<br/>
Changed bus parameters for JModelica compatibility.
See issue <a href=https://github.com/open-ideas/IDEAS/issues/559>#559</a>.
Also removed obsolete each.
</li>
<li>
January 20, 2017 by Filip Jorissen:<br/>
Removed propagation of <code>nLay</code> and <code>nGain</code>
since this lead to warnings.
</li>
<li>
January 11, 2017 by Filip Jorissen:<br/>
Added documentation
</li>
<li>
January 10, 2017, by Filip Jorissen:<br/>
Added <code>linExtRadWin</code> for windows.
</li>
<li>
November 14, 2016 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>"));
end RectangularZoneTemplate;
