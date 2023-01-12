within IBPSA.Electrical.BaseClasses.PV;
partial model PartialPVSystem "Base PV model with internal or external MPP tracking"

  extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.Icons.partialPVIcon;

  replaceable parameter IBPSA.Electrical.Data.PV.Generic data constrainedby
    IBPSA.Electrical.Data.PV.Generic "PV Panel data definition"
    annotation (choicesAllMatching=true);
  parameter BaseClasses.PVOptical.PVType PVTechType=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI
    "Type of PV technology";

  parameter Boolean use_zenAng = true
  "If true then the zenith angle is needed as input for absorption ratio calculations"
  annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Boolean use_incAng = true
  "If true then the incidence angle is needed as input for absorption ratio calculations"
  annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Boolean use_HDifHor = true
  "If true then the diffuse horizontal irradiation is needed as input for absorption ratio calculations"
  annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

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

  Modelica.Blocks.Interfaces.RealInput HGloTil(final unit="W/m2")
    "Global irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Modelica.Blocks.Interfaces.RealInput TDryBul(final unit="K") "Ambient dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput vWinSpe(final unit="m/s") "Wind speed" annotation (
      Placement(transformation(extent={{-140,20},{-100,60}}),iconTransformation(
          extent={{-140,20},{-100,60}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if use_heat_port
    "Heat port for connection with e.g. building facade or mass"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));

  //Conditional connectors
  Modelica.Blocks.Interfaces.RealInput MPPTraSet(final unit="1") if use_MPP_in
    "Conditional input for MPP tracking" annotation (Placement(transformation(
          extent={{-140,-10},{-100,30}}),
                                        iconTransformation(extent={{-140,-10},{
            -100,30}})));
  Modelica.Blocks.Interfaces.RealInput tilSet(final unit="rad") if use_Til_in
    "Conditional input for tilt angle control" annotation (Placement(
        transformation(extent={{-140,-40},{-100,0}}),  iconTransformation(
          extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput aziSet(final unit="rad") if use_Azi_in
    "Conditional input for azimuth angle control" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}),iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput shaSet(final unit="1") if use_Sha_in
    "Conditional input for shading [0,1]" annotation (Placement(transformation(
          extent={{-144,-124},{-100,-80}}),
                                          iconTransformation(extent={{-140,-120},
            {-100,-80}})));

  Modelica.Blocks.Interfaces.RealInput ageSet(final unit="1") if use_age_in
    "Conditional input for ageing [0,1]" annotation (Placement(transformation(
          extent={{-144,-164},{-100,-120}}),
                                           iconTransformation(extent={{-140,
            -160},{-100,-120}})));
  Modelica.Blocks.Interfaces.RealInput HGloHor(final unit="W/m2")
    "Global irradiation on horizontal surface" annotation (Placement(
        transformation(extent={{-140,80},{-100,120}}),iconTransformation(extent={{-140,80},
            {-100,120}})));
  Modelica.Blocks.Interfaces.RealInput HDifHor(final unit="W/m2") if use_HDifHor
    "Diffuse irradiation on horizontal surface" annotation (Placement(
        transformation(extent={{-140,160},{-100,200}}), iconTransformation(
          extent={{-140,160},{-100,200}})));
  Modelica.Blocks.Interfaces.RealInput incAngle(final unit="rad") if use_incAng
    "Incidence angle of irradiation"
    annotation (Placement(transformation(extent={{-140,200},{-100,240}}),
        iconTransformation(extent={{-140,200},{-100,240}})));
  Modelica.Blocks.Interfaces.RealInput zenAngle(final unit="rad") if use_zenAng "Zenith angle of irradiation"
    annotation (Placement(transformation(extent={{-140,240},{-100,280}}),
        iconTransformation(extent={{-140,240},{-100,280}})));
  Modelica.Blocks.Interfaces.RealOutput P(final unit="W") "DC Power output"
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
</html>"),
    Diagram(coordinateSystem(extent={{-100,-140},{100,260}})),
    Icon(coordinateSystem(extent={{-100,-140},{100,260}})));
end PartialPVSystem;
