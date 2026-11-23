within IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical;
block AirMassModifier
  "Air mass modifier based on selected PV technology"
  extends Modelica.Blocks.Icons.Block;

  parameter PVType PVTecTyp=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI
    "Type of PV technology";

  Modelica.Blocks.Interfaces.RealInput airMas(final unit="1") "Air mass of atmosphere"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput airMasMod(final unit="1")
    "Air mass modifier depending on PV technology"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

// Air mass parameters based on PV technology. Mono-Si technology as default value
protected
  parameter Real b0=if PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI
       then 0.935823 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.PolySI
       then 0.918093 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI
       then 0.938110 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThreeJuncAmorphous
       then 1.10044085 else 0.935823 "Regression parameter 0 to calculate air mass modifier";
  parameter Real b1=if PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI
       then 0.054289 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.PolySI
       then 0.086257 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI
       then 0.062191 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThreeJuncAmorphous
       then -0.06142323 else 0.054289 "Regression parameter 1 to calculate air mass modifier";
  parameter Real b2=if PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI
       then -0.008677 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.PolySI
       then -0.024459 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI
       then -0.015021 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThreeJuncAmorphous
       then -0.00442732 else -0.008677 "Regression parameter 2 to calculate air mass modifier";
  parameter Real b3=if PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI
       then 0.000527 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.PolySI
       then 0.002816 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI
       then 0.001217 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThreeJuncAmorphous
       then 0.000631504 else 0.000527 "Regression parameter 3 to calculate air mass modifier";
  parameter Real b4=if PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI
       then -0.000011 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.PolySI
       then -0.000126 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI
       then -0.000034 elseif PVTecTyp == IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThreeJuncAmorphous
       then -0.000019184 else -0.000011 "Regression parameter 4 to calculate air mass modifier";

equation
  airMasMod =if (b0 + b1*(airMas) + b2*(airMas^2) + b3*(airMas^3) + b4*(airMas^4)) <=
    0 then 0 else b0 + b1*(airMas^1) + b2*(airMas^2) + b3*(airMas^3) + b4*(
    airMas^4);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
The model computes the air mass modifier.
</p>
<p>
The air mass modifier depends on the PV technology type and is automatically parameterized.
</p>
<p>
The computation results from five parameters which have been determined empirically.
The parameters are found in Fanney et al. 2003 and De Soto et al. 2006.
</p>
<p>
Even though the studies find a neglible influence on the overall PV performance,
this model accounts for a change in parameters based on the selected PV technology type.
</p>
<p>
The air mass modifier is used to account for a change in the absorption ratio of a PV module
compared to standard conditions.
</p>
<h4>References</h4>
<p>
Fanney, A. H., Dougherty, B. P., &amp; Davis, M. W. (2003).
Short-term characterization of building integrated photovoltaic panels.
J. Sol. Energy Eng., 125(1), 13-20.
<a href=\"https://doi.org/10.1115/1.1531642\">
https://doi.org/10.1115/1.1531642</a>
</p>
<p>
De Soto, W., Klein, S. A., &amp; Beckman, W. A. (2006).
Improvement and validation of a model for photovoltaic array performance.
Solar energy, 80(1), 78-88.
<a href=\"https://doi.org/10.1016/j.solener.2005.06.010\">
https://doi.org/10.1016/j.solener.2005.06.010</a>
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 11, 2023, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirMassModifier;
