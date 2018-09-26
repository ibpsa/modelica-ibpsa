within IDEAS.Buildings.Components.InternalGains;
model Lighting
  "Fraction of heat to space, radiative heat, lighting type, light power and floor area"
  extends
    IDEAS.Buildings.Components.InternalGains.BaseClasses.PartialLightingGains;

  Modelica.Blocks.Math.Gain gaiHea(k=rooTyp.Ev*A/ligTyp.eps)
    "Gain for computing heat lighting gains based on zone lighting requirements"
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon(final
      alpha=0) "Prescribed heat flow rate for convective sensible heat"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Math.Gain gainRad(final k=ligTyp.radFra) "Radiative fraction"
    annotation (Placement(transformation(extent={{-8,-30},{12,-10}})));
  Modelica.Blocks.Math.Gain gainCon(final k=1 - ligTyp.radFra)
    "Convective fraction"
    annotation (Placement(transformation(extent={{-8,10},{12,30}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloRad(final
      alpha=0) "Prescribed heat flow rate for radiative sensible heat"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
equation
  connect(preHeaFloCon.port, portCon)
    annotation (Line(points={{60,20},{100,20}},            color={191,0,0}));
  connect(preHeaFloRad.port, portRad)
    annotation (Line(points={{60,-20},{100,-20}},           color={191,0,0}));
  connect(gainRad.y, preHeaFloRad.Q_flow)
    annotation (Line(points={{13,-20},{40,-20}}, color={0,0,127}));
  connect(gainCon.y, preHeaFloCon.Q_flow) annotation (Line(points={{13,20},{40,20}},
                                   color={0,0,127}));
  connect(gainCon.u, gaiHea.y)
    annotation (Line(points={{-10,20},{-20,20},{-20,0},{-31,0}},
                                                             color={0,0,127}));
  connect(gainRad.u, gaiHea.y) annotation (Line(points={{-10,-20},{-20,-20},{-20,
          0},{-31,0}}, color={0,0,127}));
  connect(ctrl, gaiHea.u) annotation (Line(points=
         {{-110,0},{-54,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This lighting model assumes an input signal between 0 and 1
(adjustable) that is multiplied by the lighting power calculated 
according to the indications of ASHRAE Fundamentals 2017
(Chapter 18). The total lighting gains are split first by the
fraction that goes into the conditioned space and then between
the radiative and convective gains.
</p>
</html>",
        revisions="<html>
<ul>
<li>
August 28, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</ul>
</html>"));
end Lighting;
