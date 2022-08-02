within IBPSA.Electrical.BaseClasses.PVSystem;
partial model PartialPVSystem "Base PV model with internal or external MPP tracking"

  extends IBPSA.Electrical.BaseClasses.PVSystem.BaseClasses.Icons.partialPVIcon;

  replaceable model ElectricalModel =
    IBPSA.Electrical.BaseClasses.PVSystem.BaseClasses.PartialPVElectrical
   "Model with electrical characteristics";

  replaceable model ThermalModel =
    IBPSA.Electrical.BaseClasses.PVSystem.BaseClasses.PartialPVThermal
    "Model with thermal characteristics";

  replaceable model OpticalModel =
    IBPSA.Electrical.BaseClasses.PVSystem.BaseClasses.PartialPVOptical
    "Model with optical characteristics"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

  replaceable parameter IBPSA.Electrical.DataBase.PVSimpleBaseDataDefinition data
   constrainedby IBPSA.Electrical.DataBase.PVSimpleBaseDataDefinition
   "PV Panel data definition"
                             annotation (choicesAllMatching);

  parameter Boolean use_MPP_in = false
   "If true then MPP via real interface else internal automatic MPP tracking"
   annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Boolean use_Til_in = false
  "If true then tilt via real interface else parameter"
  annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Modelica.Units.SI.Angle til if not use_Til_in
  "Prescribed tilt angle (used if til=Parameter)" annotation(Dialog(enable=not use_Til_in, tab="Advanced"));

  parameter Boolean use_Azi_in = false
  "If true then azimuth angle is controlled via real interface else parameter"
  annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Modelica.Units.SI.Angle azi if not use_Azi_in
  "Prescribed azimuth angle (used if azi=Parameter)"
  annotation(Dialog(enable=not use_Azi_in, tab="Advanced"));

  parameter Boolean use_Sha_in = false
  "If true then shading is real interface else neglected"
  annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Boolean use_age_in = false
  "If true then ageing is real interface else parameter"
  annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Real ageing if not use_age_in
  "Prescribed ageing factor [0,1] (used if ageig=Parameter)" annotation(Dialog(enable=not use_age_in, tab="Advanced"));

  parameter Boolean use_heat_port = false
  "If true then heat port is enables as interface"
  annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  Modelica.Blocks.Interfaces.RealInput HGloHor "Horizontal global irradiation"
    annotation (Placement(transformation(extent={{-110,80},{-88,102}}),
        iconTransformation(extent={{-110,80},{-88,102}})));
  Modelica.Blocks.Interfaces.RealInput TDryBul "Ambient dry bulb temperature"
    annotation (Placement(transformation(extent={{-110,52},{-88,74}}),
        iconTransformation(extent={{-110,52},{-88,74}})));
  Modelica.Blocks.Interfaces.RealInput vWinSpe "Wind speed" annotation (
      Placement(transformation(extent={{-110,26},{-88,48}}), iconTransformation(
          extent={{-110,26},{-88,48}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if use_heat_port
    "Heat port for connection with e.g. building facade or mass"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  //Conditional connectors
  Modelica.Blocks.Interfaces.RealInput MPPTrackingSet if use_MPP_in
    "Conditional input for MPP tracking" annotation (Placement(transformation(
          extent={{-110,-2},{-88,20}}),  iconTransformation(extent={{-110,-2},{-88,
            20}})));
  Modelica.Blocks.Interfaces.RealInput tilSet if use_Til_in
    "Conditional input for tilt angle control" annotation (Placement(
        transformation(extent={{-110,-24},{-88,-2}}),  iconTransformation(
          extent={{-110,-24},{-88,-2}})));
  Modelica.Blocks.Interfaces.RealInput aziSet if use_Azi_in
    "Conditional input for azimuth angle control" annotation (Placement(
        transformation(extent={{-110,-50},{-88,-28}}), iconTransformation(
          extent={{-110,-50},{-88,-28}})));
  Modelica.Blocks.Interfaces.RealInput shadingSet if use_Sha_in
    "Conditional input for shading [0,1]" annotation (Placement(transformation(
          extent={{-110,-76},{-88,-54}}),  iconTransformation(extent={{-106,-72},
            {-88,-54}})));

  Modelica.Blocks.Interfaces.RealInput ageingSet if use_age_in
    "Conditional input for ageing [0,1]" annotation (Placement(transformation(
          extent={{-110,-104},{-88,-82}}), iconTransformation(extent={{-106,-72},
            {-88,-54}})));

  Modelica.Blocks.Interfaces.RealOutput DCPower "DC Power output"
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));
protected
  Modelica.Blocks.Interfaces.RealInput MPP_in_internal
  "Needed to connect to conditional MPP tracking connector";

  parameter Real MPP = 1 "Dummy MPP parameter";

  Modelica.Blocks.Interfaces.RealInput Til_in_internal
  "Needed to connect to conditional tilt connector";

  Modelica.Blocks.Interfaces.RealInput Azi_in_internal
  "Needed to connect to conditional azimuth connector";

  Modelica.Blocks.Interfaces.RealInput Sha_in_internal
  "Needed to connect to conditional shading connector";

  Modelica.Blocks.Interfaces.RealInput Age_in_internal
  "Needed to connect to conditional ageing connector";

  parameter Real Sha = 1 "Dummy Shading parameter";

equation
  connect(MPPTrackingSet, MPP_in_internal);
  connect(tilSet, Til_in_internal);
  connect(aziSet, Azi_in_internal);
  connect(shadingSet, Sha_in_internal);
  connect(ageingSet, Age_in_internal);

  if not use_MPP_in then
    MPP_in_internal = MPP;
  end if;

  if not use_Til_in then
    Til_in_internal = til;
  end if;

  if not use_Azi_in then
    Azi_in_internal = azi;
  end if;

  if not use_Sha_in then
    Sha_in_internal = Sha;
  end if;

  if not use_age_in then
    Age_in_internal = ageing;
  end if;

end PartialPVSystem;
