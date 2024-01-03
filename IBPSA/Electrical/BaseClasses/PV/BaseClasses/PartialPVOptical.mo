within IBPSA.Electrical.BaseClasses.PV.BaseClasses;
partial model PartialPVOptical


  parameter PVOptical.PVType PVTecTyp=
  IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI
    "Type of PV technology";

 parameter Boolean use_Til_in = false
  "If true then tilt via real interface else parameter"
  annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

 parameter Modelica.Units.SI.Angle til
  "Prescribed tilt angle (used if til=Parameter)" annotation(Dialog(enable=not use_Til_in, tab="Module mounting and specifications"));


  Modelica.Blocks.Interfaces.RealOutput absRadRat
    "Ratio of absorbed radiation under operating conditions to standard conditions"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput zenAng(final unit="rad", final
      displayUnit="deg") "Zenith angle for object"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput HGloHor(final unit="W/m2") "Global horizontal irradiation"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput HDifHor(final unit="W/m2") "Diffuse horizontal irradiation"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput incAng(final unit="rad", final
      displayUnit="deg") "Incidence angle"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
Modelica.Blocks.Interfaces.RealInput tilSet(final unit="rad") if use_Til_in
  "Conditional input for tilt angle control" annotation (Placement(
      transformation(extent={{-140,-100},{-100,-60}}),
                                                     iconTransformation(
        extent={{-140,-80},{-100,-40}})));

protected
  Modelica.Blocks.Interfaces.RealInput Til_in_int
    "Needed to connect to conditional tilt connector";

equation
  connect(tilSet, Til_in_int);

  if not use_Til_in then
    Til_in_int = til;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {120,100}}),                                        graphics={
        Ellipse(
          extent={{-78,76},{-22,24}},
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{12,-34},{42,22},{96,10},{68,-48},{12,-34}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-26,32},{44,-14},{-34,-56}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled})}),                    Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
        Documentation(info="<html>
        <p>This is a partial model for the optical surrogate model of a photovoltaic model.</p>
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPVOptical;
