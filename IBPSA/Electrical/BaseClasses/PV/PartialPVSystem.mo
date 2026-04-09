within IBPSA.Electrical.BaseClasses.PV;
partial model PartialPVSystem "Base PV model with internal or external MPP tracking"

  replaceable package PhaseSystem = IBPSA.Electrical.PhaseSystems.PartialPhaseSystem
    constrainedby IBPSA.Electrical.PhaseSystems.PartialPhaseSystem "Phase system"
    annotation (choicesAllMatching=true);

  constant Modelica.Units.SI.Irradiance HGloTil0=1000
    "Total solar radiation on the horizontal surface under standard conditions"
     annotation(Dialog(tab="Site specifications"));

  replaceable parameter Data.PV.Generic dat constrainedby
    IBPSA.Electrical.Data.PV.Generic "PV Panel data definition"
    annotation (choicesAllMatching=true);

  parameter BaseClasses.PVOptical.PVType PVTecTyp=
    IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI
    "Type of PV technology";

  parameter Integer nMod(min=1) "Amount of modules per system";

  parameter Real groRef(unit="1")=0.2 "Ground reflectance"
    annotation(Dialog(tab="Module mounting and specifications"));

  parameter Real glaExtCoe=4 "Glazing extinction coefficient for glass"
    annotation(Dialog(tab="Module mounting and specifications"));

  parameter Modelica.Units.SI.Length glaThi=0.002
    "Glazing thickness for most PV cell panels it is 0.002 m"
    annotation(Dialog(tab="Module mounting and specifications"));

  parameter Real refInd=1.526
    "Effective index of refraction of the cell cover (glass)"
    annotation(Dialog(tab="Module mounting and specifications"));

  parameter Modelica.Units.SI.Length alt
    "Site altitude in Meters"
    annotation(Dialog(tab="Site specifications"));

  parameter Boolean use_zenAng = true
    "If true then the zenith angle is needed as input for absorption ratio calculations"
    annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Boolean use_ter = true
    "If true then the electrical terminal connector is used";

  parameter Boolean use_incAng = true
    "If true then the incidence angle is needed as input for absorption ratio calculations"
    annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Boolean use_HDifHor = true
    "If true then the diffuse horizontal irradiation is needed as input for absorption ratio calculations"
    annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

  parameter Boolean use_Til_in = false
    "If true then tilt via real interface else parameter"
    annotation(Evaluate=true, HideResult=true,Dialog(tab="Module mounting and specifications"));

  parameter Modelica.Units.SI.Angle til
    "Prescribed tilt angle (used if til=Parameter)"
    annotation(Dialog(enable=not use_Til_in, tab="Module mounting and specifications"));

  Modelica.Blocks.Interfaces.RealInput tilSet(final unit="rad") if use_Til_in
    "Conditional input for tilt angle control"
    annotation (Placement(transformation(extent={{-140,90},{-100,130}}),
      iconTransformation(extent={{-120,100},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput zenAng(final unit="rad") if use_zenAng
    "Zenith angle of irradiation"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput incAng(final unit="rad") if use_incAng
    "Incidence angle of irradiation"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput vWinSpe(final unit="m/s") "Wind speed"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput TDryBul(final unit="K")
    "Ambient dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput HGloHor(final unit="W/m2")
    "Global irradiation on horizontal surface"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput HGloTil(final unit="W/m2")
    "Global irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealInput HDifHor(final unit="W/m2") if use_HDifHor
    "Diffuse irradiation on horizontal surface"
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}}),
        iconTransformation(extent={{-120,-120},{-100,-100}})));
  Modelica.Blocks.Interfaces.RealOutput PDC(final unit="W") "DC Power output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  replaceable BaseClasses.PartialPVOptical PVOpt(
    final use_Til_in=use_Til_in,
    final PVTecTyp=PVTecTyp)
    "Model with optical characteristics"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  replaceable BaseClasses.PartialPVThermal PVThe
    "Model with thermal characteristics"
    annotation (choicesAllMatching=true, Dialog(tab="Module mounting and specifications"),
      Placement(transformation(extent={{-20,-20},{0,0}})));
  replaceable BaseClasses.PartialPVElectrical PVEle(
    final nMod=nMod)
    "Model with electrical characteristics"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  replaceable IBPSA.Electrical.Interfaces.Terminal terminal(
    redeclare final package PhaseSystem = PhaseSystem) if use_ter "Generalized terminal"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

protected
  Modelica.Blocks.Interfaces.RealInput Til_in_int
    "Needed to connect to conditional tilt connector";

equation
  connect(tilSet, Til_in_int);
  connect(PVOpt.tilSet, Til_in_int);

  if not use_Til_in then
    Til_in_int = til;
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
  Diagram(coordinateSystem(extent={{-100,-120},{100,120}})),
  Icon(coordinateSystem(extent={{-100,-120},{100,120}}), graphics={
    Rectangle(extent={{-100,100},{100,-100}}, lineColor={215,215,215},fillColor={215,215,215},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-62,30},{-34,2}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-30,30},{-2,2}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{2,30},{30,2}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-62,-2},{-34,-30}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-30,-2},{-2,-30}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{2,-2},{30,-30}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-62,-34},{-34,-62}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-30,62},{-2,34}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{2,62},{30,34}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-62,62},{-34,34}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-30,-34},{-2,-62}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{2,-34},{30,-62}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-94,62},{-66,34}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-94,30},{-66,2}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-94,-2},{-66,-30}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-94,-34},{-66,-62}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{34,62},{62,34}},  lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{34,30},{62,2}},   lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{34,-2},{62,-30}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{34,-34},{62,-62}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{66,-34},{94,-62}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{66,-2},{94,-30}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{66,30},{94,2}},   lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{66,62},{94,34}},  lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid)}));
end PartialPVSystem;
