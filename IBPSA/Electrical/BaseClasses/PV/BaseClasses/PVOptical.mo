within IBPSA.Electrical.BaseClasses.PV.BaseClasses;
package PVOptical
  "Models for computing irradiance-related boundary conditions for PV systems"
  block AirMass
    "Air mass calculation depening on zenith angle and height of object"
    extends Modelica.Blocks.Icons.Block;
    parameter Modelica.Units.SI.Height alt "Height of object";
    Modelica.Blocks.Interfaces.RealInput zenAng(final unit="rad", final displayUnit="deg") "Zenith angle for object"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealOutput airMas(final unit="1")
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  protected
    Modelica.Units.SI.Angle zen "Zenith angle internal use";
  equation

   zen = if zenAng <= Modelica.Constants.pi/2 then
   zenAng
   else
   Modelica.Constants.pi/2
   "Restriction for zenith angle";

    airMas =
    exp(-0.0001184*alt)/(cos(zen) + 0.5057*(96.080 -
                    zen*180/Modelica.Constants.pi)^(-1.634));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html><p>The model computes the air mass, which is the number of particles in the atmosphere.</br>
        It bases on an exact empirical approach by Kasten et al. and bases on the zenith angle of the object as well as its height.</p>
        <h4>References</h4>
<p>
Kasten, F., & Young, A. T. (1989). Revised optical air mass tables and 
approximation formula. Applied optics, 28(22), 4735-4738.
<a href=\"https://doi.org/10.1364/AO.28.004735\">
https://doi.org/10.1364/AO.28.004735</a>
</p></html>",
  revisions="<html>
<ul>
<li>
Jan 11, 2023, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
  end AirMass;

  block AirMassModifier
    "This block computes the air mass modifier based on selected PV technology"
    extends Modelica.Blocks.Icons.Block;

    parameter IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType PVTechType=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType
        .MonoSI "Type of PV technology";

    Modelica.Blocks.Interfaces.RealInput airMas(final unit="1") "Air mass of atmosphere"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealOutput airMasMod(final unit="1")
      "Air mass modifier depending on PV technology"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // Air mass parameters based on PV technology. Mono-SI technology as default value
  protected
  parameter Real b_0=
    if PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI  then 0.935823
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.PolySI  then 0.918093
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI  then 0.938110
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThreeJuncAmorphous  then 1.10044085
    else 0.935823;
  parameter Real b_1=
    if PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI  then 0.054289
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.PolySI  then 0.086257
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI  then 0.062191
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThreeJuncAmorphous  then -0.06142323
    else 0.054289;
  parameter Real b_2=
    if PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI  then -0.008677
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.PolySI  then -0.024459
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI  then -0.015021
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThreeJuncAmorphous  then -0.00442732
    else -0.008677;
  parameter Real b_3=
    if PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI  then 0.000527
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.PolySI  then 0.002816
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI  then 0.001217
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThreeJuncAmorphous  then 0.000631504
    else 0.000527;
  parameter Real b_4=
    if PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI  then -0.000011
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.PolySI  then -0.000126
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI  then -0.000034
    elseif PVTechType ==IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThreeJuncAmorphous  then -0.000019184
    else -0.000011;

  equation

  airMasMod = if (b_0 + b_1*(airMas^1) + b_2*(airMas^2) + b_3*(
  airMas^3) + b_4*(airMas^4)) <= 0 then
  0 else
  b_0 + b_1*(airMas^1) + b_2*(airMas^2) + b_3*(airMas^3) + b_4*(airMas^4);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html><p>The model computes the air mass modifier.</br>
        The air mass modifier depends on the PV technology type and is automatically parameterized.</br>
        The computation results from five parameters which have been determined empirically.
        The parameters are found in Fanney et al. and De Soto et al.</br>
        Even though the studies find a neglible influence on the overall PV performance,
        this model accounts for a change in parameters based on the selected PV technology type.</br>
        The air mass modifier is used to account for a change in the absorption ratio of a PV module
        compared to standard conditions.</p>
        <h4>References</h4>
<p>
Fanney, A. H., Dougherty, B. P., & Davis, M. W. (2003). 
Short-term characterization of building integrated photovoltaic panels. 
J. Sol. Energy Eng., 125(1), 13-20.
<a href=\"https://doi.org/10.1115/1.1531642\">
https://doi.org/10.1115/1.1531642</a>
</p>
<p>
De Soto, W., Klein, S. A., & Beckman, W. A. (2006). 
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

  type PVType = enumeration(
      MonoSI
        "Single-crystalline Silicon PV technology",
      PolySI "Poly-crystalline Silicon PV technology",
      ThinFilmSI
        "Thin film Silicon PV technology",
      ThreeJuncAmorphous "Three-junction amorphous PV technology")
   "Enumeration to define definition of the PV technology";
end PVOptical;
