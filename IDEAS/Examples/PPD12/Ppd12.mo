within IDEAS.Examples.PPD12;
model Ppd12 "Ppd 12 example model"
  extends Modelica.Icons.Example;
  package MediumAir = IDEAS.Media.Air;
  package MediumWater = IDEAS.Media.Water;
  parameter Modelica.SIunits.Length hFloor0=2.9 "Height of ground floor";
  parameter Modelica.SIunits.Length hFloor1=2.7 "Height of first floor";
  parameter Modelica.SIunits.Length hFloor2=2.5 "Height of second floor";
  parameter Modelica.SIunits.Length lHallway=8 "Length of hallway";
  parameter Modelica.SIunits.Length wHallwayAvg=(wHallway1+wHallway2)/2 "Hallway width";
  parameter Modelica.SIunits.Length wHallway1=1.1 "Hallway width";
  parameter Modelica.SIunits.Length wHallway2=1.4 "Hallway width";
  parameter Modelica.SIunits.Length wZon=(wZonStr+wBathroom)/2 "Avg living width";
  parameter Modelica.SIunits.Length wZonStr=3.2
    "Living width at street";
  parameter Modelica.SIunits.Length wBuilding = 4.6;
  parameter Modelica.SIunits.Length wBathroom = 2.85;
  parameter Modelica.SIunits.Length lDiner = 3;
  parameter Modelica.SIunits.Length wBedroom = 4.4;
  parameter Modelica.SIunits.Length wDiner = 4.5;
  parameter Modelica.SIunits.Length lPorch = 2;
  parameter Modelica.SIunits.Length wPorch = wBuilding-wKitchen;
  parameter Modelica.SIunits.Length wKitchen = 1.4;
  parameter Modelica.SIunits.Length lHalfBuilding = 3.75;
  parameter Modelica.SIunits.Length lBuilding = 8;

  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg angDelta=26;
  parameter Modelica.SIunits.Angle north = IDEAS.Types.Azimuth.N + Modelica.SIunits.Conversions.from_deg(angDelta)
    "Azimuth of the wall, i.e. 0deg denotes South";
  parameter Modelica.SIunits.Angle south = IDEAS.Types.Azimuth.S + Modelica.SIunits.Conversions.from_deg(angDelta)
    "Azimuth of the wall, i.e. 0deg denotes South";
  parameter Modelica.SIunits.Angle west = IDEAS.Types.Azimuth.W + Modelica.SIunits.Conversions.from_deg(angDelta)
    "Azimuth of the wall, i.e. 0deg denotes South";
  parameter Modelica.SIunits.Angle east = IDEAS.Types.Azimuth.E + Modelica.SIunits.Conversions.from_deg(angDelta)
    "Azimuth of the wall, i.e. 0deg denotes South";

  inner IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  IDEAS.Buildings.Components.BoundaryWall wallSou1(inc=IDEAS.Types.Tilt.Wall,
    insulationThickness=0,
    azi=south,
    redeclare Popu12.Data.CommonWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.none insulationType,
    AWall=2.3*lPorch)
    "Common wall on south side"
    annotation (Placement(transformation(extent={{-104,-72},{-94,-52}})));
  IDEAS.Buildings.Components.OuterWall outerWall1(inc=IDEAS.Types.Tilt.Wall,
      insulationThickness=0,
    AWall=hFloor0*wKitchen,
    azi=east,
    redeclare Popu12.Data.OuterWall constructionType)
    annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-89,-94})));
  IDEAS.Buildings.Components.InternalWall ceilingLiving(
    insulationThickness=0,
    redeclare IDEAS.Buildings.Data.Insulation.none insulationType,
    AWall=wZon*lHallway/2,
    azi=0,
    redeclare Popu12.Data.Floor
                         constructionType,
    inc=IDEAS.Types.Tilt.Floor)
    "Internal zone between hallway and main zone"
    annotation (Placement(transformation(extent={{94,72},{104,52}})));
  IDEAS.Buildings.Components.InternalWall ceilingLiving1(
    insulationThickness=0,
    redeclare IDEAS.Buildings.Data.Insulation.none insulationType,
    azi=0,
    AWall=lHallway*wHallway1,
    redeclare Popu12.Data.Floor
                         constructionType,
    inc=IDEAS.Types.Tilt.Floor)
    "Internal zone between hallway and main zone"
    annotation (Placement(transformation(extent={{70,68},{80,88}})));
  IDEAS.Buildings.Components.Window winBed3(
    frac=0.1,
    azi=east,
    redeclare IDEAS.Buildings.Components.ThermalBridges.None briType,
    redeclare Popu12.Data.PvcInsulated
                                fraType,
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Ar glazing,
    inc=(IDEAS.Types.Tilt.Wall + IDEAS.Types.Tilt.Ceiling)/2,
    A=1.2*1)                                            "Window bedroom 3"
    annotation (Placement(transformation(
        extent={{-5,10},{5,-10}},
        rotation=90,
        origin={305,-2})));
  IDEAS.Buildings.Components.OuterWall Roof2(
    insulationThickness=0,
    redeclare IDEAS.Buildings.Data.Insulation.none insulationType,
    azi=east,
    inc=(IDEAS.Types.Tilt.Wall + IDEAS.Types.Tilt.Ceiling)/2,
    AWall=wBedroom*lHalfBuilding*sqrt(2)/2,
    redeclare Popu12.Data.Roof
                        constructionType) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={263,-2})));
  IDEAS.Buildings.Components.OuterWall outerWall6(
                                                 inc=IDEAS.Types.Tilt.Wall,
    insulationThickness=0,
    redeclare Popu12.Data.OuterWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.none insulationType,
    azi=east,
    AWall=0.5*wBedroom)
    annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={235,-2})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";
  IDEAS.Buildings.Components.RectangularZoneTemplate living(
    h=hFloor0,
    aziA=east,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWallAndWindow,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    l=wZon,
    w=lBuilding,
    redeclare package Medium = MediumAir,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    redeclare Popu12.Data.TripleGlazing
                                 glazingC,
    A_winC=2.55*1.74,
    fracC=0.1,
    redeclare Popu12.Data.OuterWall
                             constructionTypeC,
    redeclare Popu12.Data.InteriorWall10
                                  constructionTypeA,
    redeclare Popu12.Data.InteriorWall10
                                  constructionTypeB,
    redeclare Popu12.Data.CommonWall
                              constructionTypeD,
    redeclare Popu12.Data.FloorOnGround
                                 constructionTypeFlo,
    nSurfExt=1,
    redeclare Data.Ppd12WestShadingGnd shaTypC,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState))
    annotation (Placement(transformation(extent={{-18,66},{-38,46}})));

  IDEAS.Buildings.Components.RectangularZoneTemplate hallway(
    h=hFloor0,
    aziA=east,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    w=lBuilding,
    redeclare package Medium = MediumAir,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    redeclare Popu12.Data.TripleGlazing
                                 glazingC,
    A_winC=2.55*1.74,
    fracC=0.1,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    l=wHallwayAvg,
    redeclare Popu12.Data.OuterWall
                             constructionTypeC,
    redeclare Popu12.Data.InteriorWall30
                                  constructionTypeA,
    redeclare Popu12.Data.CommonWall
                              constructionTypeB,
    nSurfExt=1,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState))
    annotation (Placement(transformation(extent={{-72,60},{-92,40}})));
  IDEAS.Buildings.Components.RectangularZoneTemplate Diner(
    h=hFloor0,
    aziA=east,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    redeclare package Medium = MediumAir,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    redeclare Popu12.Data.TripleGlazing
                                 glazingC,
    A_winC=2.55*1.74,
    fracC=0.1,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare Popu12.Data.CommonWall
                              constructionTypeB,
    l=wDiner,
    w=lDiner,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare Popu12.Data.CommonWall
                              constructionTypeD,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWall,
    redeclare Popu12.Data.Roof
                        constructionTypeCei,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.LightWall
      constructionTypeA,
    nSurfExt=4,
    redeclare Popu12.Data.FloorOnGround
                                 constructionTypeFlo,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState))
    annotation (Placement(transformation(extent={{-46,-18},{-26,-38}})));
  IDEAS.Buildings.Components.RectangularZoneTemplate Porch(
    aziA=east,
    redeclare package Medium = MediumAir,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.SlabOnGround,
    redeclare Popu12.Data.TripleGlazing
                                 glazingC,
    A_winC=2.55*1.74,
    fracC=0.1,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare Popu12.Data.CommonWall
                              constructionTypeB,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    redeclare Popu12.Data.Roof
                        constructionTypeCei,
    l=wPorch,
    w=lPorch,
    h=2.3,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    redeclare Popu12.Data.InteriorWall10
                                  constructionTypeD,
    nSurfExt=0,
    redeclare Popu12.Data.FloorOnGround
                                 constructionTypeFlo,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWallAndWindow,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWallAndWindow,
    redeclare IDEAS.Buildings.Data.Glazing.EpcDouble glazingCei,
    redeclare IDEAS.Buildings.Data.Glazing.EpcDouble glazingA,
    A_winA=wPorch*2.3*0.9,
    A_winCei=wPorch*lPorch*0.9,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.LightWall
      constructionTypeA,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState))
    annotation (Placement(transformation(extent={{-44,-66},{-24,-86}})));

  IDEAS.Buildings.Components.RectangularZoneTemplate bedRoom1(
    aziA=east,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWallAndWindow,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare package Medium = MediumAir,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    redeclare Popu12.Data.TripleGlazing
                                 glazingC,
    redeclare Popu12.Data.OuterWall
                             constructionTypeC,
    redeclare Popu12.Data.CommonWall
                              constructionTypeD,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare Popu12.Data.CommonWall
                              constructionTypeB,
    fracC=0.15,
    A_winC=1.9*(1 + 1.5),
    l=wBedroom,
    w=lHalfBuilding,
    h=hFloor1,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    nSurfExt=2,
    redeclare Data.Ppd12WestShadingFirst shaTypC,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState))
                          "Master bedroom"
    annotation (Placement(transformation(extent={{140,80},{120,60}})));

  IDEAS.Buildings.Components.RectangularZoneTemplate bathRoom(
    aziA=east,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare package Medium = MediumAir,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    redeclare Popu12.Data.CommonWall
                              constructionTypeD,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWallAndWindow,
    A_winA=1.21*1.99,
    redeclare Popu12.Data.OuterWall
                             constructionTypeA,
    redeclare Popu12.Data.TripleGlazing
                                 glazingA,
    w=lHalfBuilding,
    h=hFloor1,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    l=wBathroom,
    redeclare Popu12.Data.InteriorWall10
                                  constructionTypeB,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    redeclare Popu12.Data.Floor
                         constructionTypeFlo,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    redeclare Popu12.Data.InteriorWall18
                                  constructionTypeC,
    nSurfExt=0,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState))
                                                     "Bathroom"
    annotation (Placement(transformation(extent={{140,26},{120,6}})));

  IDEAS.Buildings.Components.RectangularZoneTemplate stairWay(
    aziA=east,
    redeclare package Medium = MediumAir,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWallAndWindow,
    redeclare Popu12.Data.OuterWall
                             constructionTypeA,
    redeclare Popu12.Data.TripleGlazing
                                 glazingA,
    w=lHalfBuilding,
    h=hFloor1,
    nSurfExt=0,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    l=wHallway2,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare Popu12.Data.CommonWall
                              constructionTypeB,
    A_winA=1.09*1.69,
    fracA=0.1,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.LightWall
      constructionTypeFlo,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    redeclare Popu12.Data.InteriorWall10
                                  constructionTypeC,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState))
    "Stairway"
    annotation (Placement(transformation(extent={{86,26},{66,6}})));
  IDEAS.Buildings.Components.RectangularZoneTemplate bedRoom2(
    aziA=east,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.OuterWallAndWindow,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare package Medium = MediumAir,
    redeclare Popu12.Data.TripleGlazing
                                 glazingC,
    redeclare Popu12.Data.CommonWall
                              constructionTypeD,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare Popu12.Data.CommonWall
                              constructionTypeB,
    fracC=0.15,
    l=wBedroom,
    w=lHalfBuilding,
    h=hFloor1,
    A_winC=1.1*0.66 + 1.1*1.54,
    redeclare Popu12.Data.InteriorWall18
                                  constructionTypeC,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    redeclare Popu12.Data.InteriorWall10
                                  constructionTypeA,
    nSurfExt=0,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    redeclare Popu12.Data.Floor
                         constructionTypeFlo,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare Popu12.Data.FloorAttic
                              constructionTypeCei,
    redeclare Data.Ppd12WestShadingSecond shaTypC,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState))
                          "Master bedroom"
    annotation (Placement(transformation(extent={{276,82},{256,62}})));
  IDEAS.Buildings.Components.RectangularZoneTemplate bedRoom3(
    aziA=east,
    bouTypD=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare package Medium = MediumAir,
    redeclare Popu12.Data.CommonWall
                              constructionTypeD,
    bouTypB=IDEAS.Buildings.Components.Interfaces.BoundaryType.BoundaryWall,
    redeclare Popu12.Data.CommonWall
                              constructionTypeB,
    l=wBedroom,
    w=lHalfBuilding,
    h=hFloor1,
    redeclare Popu12.Data.InteriorWall10
                                  constructionTypeA,
    bouTypFlo=IDEAS.Buildings.Components.Interfaces.BoundaryType.InternalWall,
    redeclare Popu12.Data.Roof
                        constructionTypeCei,
    bouTypC=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    redeclare Popu12.Data.Floor
                         constructionTypeFlo,
    bouTypCei=IDEAS.Buildings.Components.Interfaces.BoundaryType.External,
    bouTypA=IDEAS.Buildings.Components.Interfaces.BoundaryType.ExternalAndWindow,
    A_winA=1.1*0.73,
    fracA=0.15,
    redeclare Popu12.Data.TripleGlazing
                                 glazingA,
    nSurfExt=3,
    calculateViewFactor=false,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState))
                          "Master bedroom"
    annotation (Placement(transformation(extent={{280,40},{260,20}})));

  IDEAS.Buildings.Components.OuterWall Roof1(
    insulationThickness=0,
    redeclare IDEAS.Buildings.Data.Insulation.none insulationType,
    inc=(IDEAS.Types.Tilt.Wall + IDEAS.Types.Tilt.Ceiling)/2,
    azi=west,
    AWall=wBedroom*lHalfBuilding*sqrt(2),
    redeclare Popu12.Data.Roof
                        constructionType) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={283,-2})));
  IDEAS.Buildings.Components.InternalWall ceilingLiving2(
    insulationThickness=0,
    redeclare IDEAS.Buildings.Data.Insulation.none insulationType,
    azi=0,
    redeclare IDEAS.Buildings.Validation.Data.Constructions.LightWall
      constructionType,
    AWall=lHallway*wHallway2,
    inc=IDEAS.Types.Tilt.Floor)
    "Dummy for representing stairway connection between floors"
    annotation (Placement(transformation(extent={{182,-22},{192,-2}})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2       radGnd(redeclare package
      Medium = MediumWater,
    Q_flow_nominal=4373,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20,
    allowFlowReversal=false)
    "Radiator ground floor: Superia super design 33/500/2400"
                                                    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-40,-142})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2       radBed1(redeclare
      package Medium = MediumWater,
    allowFlowReversal=false,
    Q_flow_nominal=1844,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20)
    "Radiator for first bedroom: Superia super design 22/500/1400"
                                                                 annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,-142})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2       radBat2(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    Q_flow_nominal=676,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20,
    n=1.2) "Towel dryer for bathroom: Brugman ibiza 1186/600" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={90,-142})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2       radBed2(redeclare
      package Medium = MediumWater,
    allowFlowReversal=false,
    Q_flow_nominal=1844,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20)
    "Radiator for second bedroom: Superia super design 22/500/1400"
                                                                 annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={230,-142})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2       radBed3(redeclare
      package Medium = MediumWater,
    allowFlowReversal=false,
    Q_flow_nominal=1671,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20)
    "Radiator for office: Superia super design 22/800/900"       annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={270,-142})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2       radBat1(
                                                              redeclare package
      Medium = MediumWater,
    allowFlowReversal=false,
    Q_flow_nominal=1822,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20)
    "Main radiator for bathroom: Superia super design 33/500/1000"
                                                    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={120,-142})));
  Fluid.Movers.FlowControlled_dp       pump(
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    filteredSpeed=false,
    redeclare package Medium = MediumWater)
    annotation (Placement(transformation(extent={{330,-122},{310,-102}})));
  Fluid.HeatExchangers.HeaterCooler_T       hea(
    m_flow_nominal=m_flow_nominal,
    Q_flow_maxHeat=30000,
    Q_flow_maxCool=0,
    dp_nominal=5000,
    redeclare package Medium = MediumWater)
                     "Bulex thermo master T30/35"
    annotation (Placement(transformation(extent={{370,-122},{350,-102}})));
  Fluid.Sources.Boundary_pT       bou1(
    nPorts=1,
    redeclare package Medium = MediumWater,
    p=150000)
    annotation (Placement(transformation(extent={{388,-202},{368,-182}})));
  Modelica.Blocks.Sources.Constant Thea(k=273.15 + 70)
    "Supply water temperature set point"
    annotation (Placement(transformation(extent={{402,-114},{382,-94}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=273.15 + 20.5, uHigh=
        273.15 + 21.5)
    annotation (Placement(transformation(extent={{250,-92},{270,-72}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal(realTrue=0, realFalse=2000)
    annotation (Placement(transformation(extent={{290,-92},{310,-72}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM spl(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = MediumWater,
    dp_nominal={0,100,1000},
    m_flow_nominal={0.4,0.4,0.4})
    annotation (Placement(transformation(extent={{240,-122},{220,-102}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM spl1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = MediumWater,
    dp_nominal={100,0,1000},
    m_flow_nominal={0.4,0.4,0.4})
    annotation (Placement(transformation(extent={{280,-122},{260,-102}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM spl2(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = MediumWater,
    dp_nominal={100,0,1000},
    m_flow_nominal={0.4,0.4,0.4})
    annotation (Placement(transformation(extent={{130,-124},{110,-104}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM spl3(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = MediumWater,
    dp_nominal={0,0,1000},
    m_flow_nominal={0.4,0.4,0.4})
    annotation (Placement(transformation(extent={{100,-124},{80,-104}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM spl4(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = MediumWater,
    dp_nominal={0,1000,1000},
    m_flow_nominal={0.4,0.4,0.4})
    annotation (Placement(transformation(extent={{70,-124},{50,-104}})));
  Fluid.Sources.Boundary_pT bou(nPorts=9, redeclare package Medium = MediumAir)
    annotation (Placement(transformation(extent={{-106,-138},{-86,-118}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1/3600000)
    annotation (Placement(transformation(extent={{352,-76},{372,-56}})));
equation

  connect(hallway.proBusD, living.proBusB) annotation (Line(
      points={{-73,50},{-50,50},{-37,50}},
      color={255,204,51},
      thickness=0.5));
  connect(Diner.proBusC, living.proBusA) annotation (Line(
      points={{-36,-19},{-22,-19},{-22,47}},
      color={255,204,51},
      thickness=0.5));
  connect(Diner.proBusExt[1], hallway.proBusA) annotation (Line(
      points={{-48,-36.5},{-76,-36.5},{-76,41}},
      color={255,204,51},
      thickness=0.5));
  connect(Diner.proBusExt[2], wallSou1.propsBus_a) annotation (Line(
      points={{-48,-37.5},{-48,-36},{-94,-36},{-94,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(outerWall1.propsBus_a, Diner.proBusExt[3]) annotation (Line(
      points={{-91,-89},{-91,-38.5},{-48,-38.5}},
      color={255,204,51},
      thickness=0.5));
  connect(Porch.proBusC, Diner.proBusA) annotation (Line(
      points={{-34,-67},{-34,-48},{-42,-48},{-42,-37}},
      color={255,204,51},
      thickness=0.5));
  connect(Porch.proBusD, Diner.proBusExt[4]) annotation (Line(
      points={{-43,-76},{-88,-76},{-88,-38},{-48,-38},{-48,-39.5}},
      color={255,204,51},
      thickness=0.5));
  connect(bedRoom1.proBusFlo, ceilingLiving.propsBus_a) annotation (Line(
      points={{130,76},{120,76},{120,60},{103.167,60}},
      color={255,204,51},
      thickness=0.5));
  connect(ceilingLiving.propsBus_b, living.proBusCei) annotation (Line(
      points={{94.8333,60},{-27.8,60},{-27.8,50}},
      color={255,204,51},
      thickness=0.5,
      visible=false));
  connect(bedRoom1.proBusExt[1], ceilingLiving1.propsBus_a) annotation (Line(
      points={{142,61},{144,61},{144,80},{79.1667,80}},
      color={255,204,51},
      thickness=0.5));
  connect(ceilingLiving1.propsBus_b, hallway.proBusCei) annotation (Line(
      points={{70.8333,80},{-81.8,80},{-81.8,44}},
      color={255,204,51},
      thickness=0.5));
  connect(bedRoom1.proBusA, bathRoom.proBusC) annotation (Line(
      points={{136,61},{136,52},{136,25},{130,25}},
      color={255,204,51},
      thickness=0.5));
  connect(bathRoom.proBusFlo, living.proBusExt[1]) annotation (Line(
      points={{130,22},{96,22},{96,32},{96,38},{-16,38},{-16,46}},
      color={255,204,51},
      thickness=0.5));
  connect(stairWay.proBusC, bedRoom1.proBusExt[2]) annotation (Line(
      points={{76,25},{76,25},{76,50},{76,52},{142,52},{142,59}},
      color={255,204,51},
      thickness=0.5));
  connect(stairWay.proBusFlo, hallway.proBusExt[1]) annotation (Line(
      points={{76,22},{46,22},{-70,22},{-70,40}},
      color={255,204,51},
      thickness=0.5));
  connect(stairWay.proBusD, bathRoom.proBusB) annotation (Line(
      points={{85,16},{121,16},{121,10}},
      color={255,204,51},
      thickness=0.5));
  connect(bedRoom2.proBusFlo, bedRoom1.proBusCei) annotation (Line(
      points={{266,78},{266,90},{192,90},{192,64},{130.2,64}},
      color={255,204,51},
      thickness=0.5));
  connect(bedRoom3.proBusC, bedRoom2.proBusA) annotation (Line(
      points={{270,39},{264,39},{264,63},{272,63}},
      color={255,204,51},
      thickness=0.5));
  connect(bedRoom3.proBusFlo, bathRoom.proBusCei) annotation (Line(
      points={{270,36},{202,36},{202,10},{130.2,10}},
      color={255,204,51},
      thickness=0.5));
  connect(outerWall6.propsBus_a, bedRoom3.proBusA) annotation (Line(
      points={{233,3},{233,14},{276,14},{276,21}},
      color={255,204,51},
      thickness=0.5));
  connect(winBed3.propsBus_a, bedRoom3.proBusExt[1]) annotation (Line(
      points={{307,3},{307,21.3333},{282,21.3333}},
      color={255,204,51},
      thickness=0.5));
  connect(Roof1.propsBus_a, bedRoom3.proBusExt[2]) annotation (Line(
      points={{281,3},{281,11.5},{282,11.5},{282,20}},
      color={255,204,51},
      thickness=0.5));
  connect(Roof2.propsBus_a, bedRoom3.proBusCei) annotation (Line(
      points={{261,3},{261,24},{270.2,24}},
      color={255,204,51},
      thickness=0.5));
  connect(ceilingLiving2.propsBus_a, bedRoom3.proBusExt[3]) annotation (Line(
      points={{191.167,-10},{282,-10},{282,18.6667}},
      color={255,204,51},
      thickness=0.5));
  connect(ceilingLiving2.propsBus_b, stairWay.proBusCei) annotation (Line(
      points={{182.833,-10},{76.2,-10},{76.2,10}},
      color={255,204,51},
      thickness=0.5));
  connect(pump.port_a,hea. port_b)
    annotation (Line(points={{330,-112},{350,-112}}, color={0,127,255}));
  connect(radGnd.port_b,radBed1. port_b) annotation (Line(points={{-40,-152},{-40,
          -152},{-40,-172},{60,-172},{60,-152}},     color={0,127,255}));
  connect(radBed1.port_b,radBat2. port_b) annotation (Line(points={{60,-152},{60,
          -172},{90,-172},{90,-152}},      color={0,127,255}));
  connect(radBat2.port_b,radBat1. port_b) annotation (Line(points={{90,-152},{90,
          -172},{120,-172},{120,-152}},     color={0,127,255}));
  connect(radBat1.port_b,radBed2. port_b) annotation (Line(points={{120,-152},{120,
          -152},{120,-172},{230,-172},{230,-152}},     color={0,127,255}));
  connect(radBed2.port_b,radBed3. port_b) annotation (Line(points={{230,-152},{230,
          -152},{230,-172},{270,-172},{270,-152}},     color={0,127,255}));
  connect(radBed3.port_b,hea. port_a) annotation (Line(points={{270,-152},{270,-152},
          {270,-172},{380,-172},{380,-112},{370,-112}},       color={0,127,255}));
  connect(bou1.ports[1],hea. port_b) annotation (Line(points={{368,-192},{350,-192},
          {350,-112}},       color={0,127,255}));
  connect(radGnd.heatPortRad, living.gainRad) annotation (Line(
      points={{-47.2,-144},{-66,-144},{-66,62},{-38,62}},
      color={191,0,0},
      visible=false));
  connect(radGnd.heatPortCon, living.gainCon) annotation (Line(
      points={{-47.2,-140},{-64,-140},{-64,59},{-38,59}},
      color={191,0,0},
      visible=false));
  connect(radBed1.heatPortCon, bedRoom1.gainCon) annotation (Line(
      points={{52.8,-140},{38,-140},{38,73},{120,73}},
      color={191,0,0},
      visible=false));
  connect(radBed1.heatPortRad, bedRoom1.gainRad) annotation (Line(
      points={{52.8,-144},{34,-144},{34,76},{120,76}},
      color={191,0,0},
      visible=false));
  connect(radBat1.heatPortCon, bathRoom.gainCon) annotation (Line(
      points={{112.8,-140},{104,-140},{104,19},{120,19}},
      color={191,0,0},
      visible=false));
  connect(radBat1.heatPortRad, bathRoom.gainRad) annotation (Line(
      points={{112.8,-144},{100,-144},{100,22},{120,22}},
      color={191,0,0},
      visible=false));
  connect(radBat2.heatPortRad, bathRoom.gainRad) annotation (Line(
      points={{82.8,-144},{72,-144},{72,22},{120,22}},
      color={191,0,0},
      visible=false));
  connect(radBat2.heatPortCon, bathRoom.gainCon) annotation (Line(
      points={{82.8,-140},{76,-140},{76,19},{120,19}},
      color={191,0,0},
      visible=false));
  connect(radBed2.heatPortCon, bedRoom2.gainCon) annotation (Line(points={{222.8,
          -140},{202,-140},{202,75},{256,75}}, color={191,0,0},
      visible=false));
  connect(radBed2.heatPortRad, bedRoom2.gainRad) annotation (Line(points={{222.8,
          -144},{198,-144},{198,78},{256,78}}, color={191,0,0},
      visible=false));
  connect(radBed3.heatPortCon, bedRoom3.gainCon) annotation (Line(points={{262.8,
          -140},{242,-140},{242,33},{260,33}}, color={191,0,0},
      visible=false));
  connect(radBed3.heatPortRad, bedRoom3.gainRad) annotation (Line(points={{262.8,
          -144},{238,-144},{238,36},{260,36}}, color={191,0,0},
      visible=false));
  connect(hysteresis.y,booleanToReal. u) annotation (Line(points={{271,-82},{271,
          -82},{288,-82}},     color={255,0,255}));
  connect(booleanToReal.y,pump. dp_in) annotation (Line(points={{311,-82},{320.2,
          -82},{320.2,-100}},       color={0,0,127}));
  connect(hysteresis.u, living.TSensor) annotation (Line(points={{248,-82},{-38.6,
          -82},{-38.6,56}}, color={0,0,127}));
  connect(hea.TSet, Thea.y) annotation (Line(points={{372,-106},{378,-106},{378,
          -104},{381,-104}}, color={0,0,127}));
  connect(spl1.port_1, pump.port_b)
    annotation (Line(points={{280,-112},{310,-112}}, color={0,127,255}));
  connect(spl1.port_3, radBed3.port_a) annotation (Line(points={{270,-122},{270,
          -127},{270,-132}}, color={0,127,255}));
  connect(spl1.port_2, spl.port_1)
    annotation (Line(points={{260,-112},{240,-112}}, color={0,127,255}));
  connect(radBed2.port_a, spl.port_3)
    annotation (Line(points={{230,-132},{230,-122}}, color={0,127,255}));
  connect(spl2.port_1, spl.port_2) annotation (Line(points={{130,-114},{220,-114},
          {220,-112}}, color={0,127,255}));
  connect(spl2.port_2, spl3.port_1) annotation (Line(points={{110,-114},{106,-114},
          {100,-114}}, color={0,127,255}));
  connect(spl3.port_2, spl4.port_1)
    annotation (Line(points={{80,-114},{70,-114}}, color={0,127,255}));
  connect(spl4.port_2, radGnd.port_a) annotation (Line(points={{50,-114},{-40,-114},
          {-40,-132}}, color={0,127,255}));
  connect(spl4.port_3, radBed1.port_a)
    annotation (Line(points={{60,-124},{60,-132}}, color={0,127,255}));
  connect(spl3.port_3, radBat2.port_a) annotation (Line(points={{90,-124},{90,-128},
          {90,-132}}, color={0,127,255}));
  connect(radBat1.port_a, spl2.port_3) annotation (Line(points={{120,-132},{120,
          -129},{120,-124}}, color={0,127,255}));
  connect(bou.ports[1], hallway.flowPort_In) annotation (Line(points={{-86,
          -124.444},{-62,-124.444},{-62,40},{-84,40}},
                                           color={0,127,255},
      visible=false));
  connect(Diner.flowPort_In, bou.ports[2]) annotation (Line(points={{-34,-38},{
          -60,-38},{-60,-125.333},{-86,-125.333}},
                                           color={0,127,255},
      visible=false));
  connect(Porch.flowPort_In, bou.ports[3]) annotation (Line(points={{-32,-86},{
          -58,-86},{-58,-126.222},{-86,-126.222}},
                                           color={0,127,255},
      visible=false));
  connect(stairWay.flowPort_In, bou.ports[4]) annotation (Line(points={{74,6},{
          -6,6},{-6,-127.111},{-86,-127.111}},
                                        color={0,127,255},
      visible=false));
  connect(bathRoom.flowPort_In, bou.ports[5]) annotation (Line(points={{128,6},
          {22,6},{22,-128},{-86,-128}},    color={0,127,255},
      visible=false));
  connect(bedRoom1.flowPort_In, bou.ports[6]) annotation (Line(points={{128,60},
          {22,60},{22,-128.889},{-86,-128.889}},
                                             color={0,127,255},
      visible=false));
  connect(bedRoom2.flowPort_In, bou.ports[7]) annotation (Line(points={{264,62},
          {90,62},{90,-129.778},{-86,-129.778}},
                                             color={0,127,255},
      visible=false));
  connect(bedRoom3.flowPort_In, bou.ports[8]) annotation (Line(points={{268,20},
          {92,20},{92,-130.667},{-86,-130.667}},
                                             color={0,127,255},
      visible=false));
  connect(living.flowPort_In, bou.ports[9]) annotation (Line(
      points={{-30,46},{-32,46},{-32,30},{-32,-131.556},{-86,-131.556}},
      color={0,127,255},
      visible=false));
  connect(integrator.u, hea.Q_flow) annotation (Line(points={{350,-66},{349,-66},
          {349,-106}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -200},{400,100}},
        initialScale=0.1), graphics={
        Line(points={{-72,-100},{-100,-100},{-100,100},{-68,100},{-68,-10},{0,-10},
              {0,100},{-68,100}}, color={28,108,200}),
        Line(points={{-72,-98}}, color={28,108,200}),
        Line(points={{-72,-100},{-72,-50},{0,-50},{0,-8}}, color={28,108,200}),
        Line(points={{-60,-10},{-100,-10}}, color={28,108,200}),
        Line(points={{-72,-100},{0,-100},{0,-50}}, color={28,108,200}),
        Line(points={{60,100},{160,100},{160,46},{60,46},{60,100}}, color={28,108,
              200}),
        Line(
          points={{92,100},{92,46}},
          color={28,108,200},
          pattern=LinePattern.Dash),
        Line(points={{60,46},{160,46},{160,-8},{60,-8},{60,46}}, color={28,108,200}),
        Line(points={{92,46},{92,-8}}, color={28,108,200}),
        Line(points={{220,100},{320,100},{320,46},{220,46},{220,100}},
                                                                    color={28,108,
              200}),
        Line(points={{220,46},{320,46},{320,-8},{220,-8},{220,46}}, color={28,108,
              200})}),          Icon(coordinateSystem(
        preserveAspectRatio=false,
        initialScale=0.1)),
    experiment(
      StopTime=3.15e+07,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_fixedstepsize=15,
      __Dymola_Algorithm="Euler"));
end Ppd12;
