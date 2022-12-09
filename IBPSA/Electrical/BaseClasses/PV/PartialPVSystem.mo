within IBPSA.Electrical.BaseClasses.PV;
partial model PartialPVSystem "Base PV model with internal or external MPP tracking"

  extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.Icons.partialPVIcon;

  replaceable parameter IBPSA.Electrical.Data.PV.Generic data constrainedby
    IBPSA.Electrical.Data.PV.Generic "PV Panel data definition"
    annotation (choicesAllMatching=true);

  parameter Boolean use_MPP_in = false
   "If true then MPP via real interface else internal automatic MPP tracking"
   annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Boolean use_Til_in = false
  "If true then tilt via real interface else parameter"
  annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Modelica.Units.SI.Angle til if not use_Til_in
  "Prescribed tilt angle (used if til=Parameter)" annotation(Dialog(enable=not use_Til_in, tab="Module mounting and specifications"));

  parameter Boolean use_Azi_in = false
  "If true then azimuth angle is controlled via real interface else parameter"
  annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Modelica.Units.SI.Angle azi if not use_Azi_in
  "Prescribed azimuth angle (used if azi=Parameter)"
  annotation(Dialog(enable=not use_Azi_in, tab="Module mounting and specifications"));

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

  Modelica.Blocks.Interfaces.RealInput HGloTil
    "Global irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-118,82},{-100,100}}),
        iconTransformation(extent={{-118,82},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TDryBul "Ambient dry bulb temperature"
    annotation (Placement(transformation(extent={{-118,38},{-100,56}}),
        iconTransformation(extent={{-118,38},{-100,56}})));
  Modelica.Blocks.Interfaces.RealInput vWinSpe "Wind speed" annotation (
      Placement(transformation(extent={{-118,16},{-100,34}}),iconTransformation(
          extent={{-118,16},{-100,34}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if use_heat_port
    "Heat port for connection with e.g. building facade or mass"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  //Conditional connectors
  Modelica.Blocks.Interfaces.RealInput MPPTraSet if use_MPP_in
    "Conditional input for MPP tracking" annotation (Placement(transformation(
          extent={{-118,-10},{-100,8}}),iconTransformation(extent={{-118,-10},{
            -100,8}})));
  Modelica.Blocks.Interfaces.RealInput tilSet if use_Til_in
    "Conditional input for tilt angle control" annotation (Placement(
        transformation(extent={{-118,-36},{-100,-18}}),iconTransformation(
          extent={{-118,-36},{-100,-18}})));
  Modelica.Blocks.Interfaces.RealInput aziSet if use_Azi_in
    "Conditional input for azimuth angle control" annotation (Placement(
        transformation(extent={{-118,-58},{-100,-40}}),iconTransformation(
          extent={{-118,-58},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput shaSet if use_Sha_in
    "Conditional input for shading [0,1]" annotation (Placement(transformation(
          extent={{-122,-84},{-100,-62}}),iconTransformation(extent={{-118,-80},
            {-100,-62}})));

  Modelica.Blocks.Interfaces.RealInput ageSet if use_age_in
    "Conditional input for ageing [0,1]" annotation (Placement(transformation(
          extent={{-122,-106},{-100,-84}}),iconTransformation(extent={{-118,-102},
            {-100,-84}})));

  Modelica.Blocks.Interfaces.RealOutput P "DC Power output"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  replaceable IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVOptical partialPVOptical
    "Model with optical characteristics"
    annotation (Placement(transformation(extent={{-36,64},{-24,76}})));
  replaceable IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermal partialPVThermal "Test"
    annotation (
    choicesAllMatching=true,
    Dialog(tab="Module mounting and specifications"),
    Placement(transformation(extent={{-38,4},{-24,16}})));

  replaceable IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVElectrical partialPVElectrical
    annotation (Placement(transformation(extent={{-36,-56},{-24,-44}})));
  Modelica.Blocks.Interfaces.RealInput HGloHor
    "Global irradiation on horizontal surface" annotation (Placement(
        transformation(extent={{-118,60},{-100,78}}), iconTransformation(extent=
           {{-118,60},{-100,78}})));
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
  connect(MPPTraSet, MPP_in_internal);
  connect(tilSet, Til_in_internal);
  connect(aziSet, Azi_in_internal);
  connect(shaSet, Sha_in_internal);
  connect(ageSet, Age_in_internal);

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

annotation(Documentation(info="<html>
<p>
This is a partial model for a PV system with an electrical, thermal, and optical replaceable model.
</p>
<p>
For a definition of the parameters, see the
<a href=\"modelica://IBPSA.BoundaryConditions.UsersGuide\">
IBPSA.BoundaryConditions.UsersGuide</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPVSystem;
