within IBPSA.Media;
package Steam "Package with model for region 2 (steam) water according to IF97 standard"
  extends Modelica.Media.Water.WaterIF97_R2pT(
     mediumName="steam",
     reference_T=273.15,
     reference_p=101325,
     AbsolutePressure(start=p_default),
     T_default=Modelica.SIunits.Conversions.from_degC(200),
     Temperature(start=T_default));

  extends Modelica.Icons.Package;

  replaceable function saturationState_p
    "Return saturation property record from pressure"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output SaturationProperties sat "Saturation property record";
  algorithm
    sat.psat := p;
    sat.Tsat := saturationTemperature(p);
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Returns the saturation state for given pressure. This relation is
    valid in the region of <i>0</i> to <i>800</i> C (<i>0</i> to <i>100</i> MPa).
    This corresponds to Region 2 of the IAPWS-IF97 water medium models.
    </p>
</html>",   revisions="<html>
<ul>
<li>
May 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
  end saturationState_p;

annotation (Documentation(info="<html>
<p>
The steam model based on IF97 formulations can be utilized for steam systems 
and components that use the vapor phase of water (regeion 2, quality = 1).
</p>
<p>
Thermodynamic properties are formulated from the International Association for the 
Properties of Water and Steam (IAPWS) 1997 forumulations for water and steam. The
thermodynamic regions as determiend by IAPWS-IF97 are as follows:
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Media/Steam/SteamIF97Regions.PNG\"
alt=\"IF97 Water Steam Regions\" width=\"600\"/>
</p>
<h4>
Limitations
</h4>
<ul>
<li>
The properties are valid in Region 2 shown above. The valid temperature range is
<i>0 C &le; T &le; 800 C</i>, and the valid pressure range is <i>0 MPa &le; p &le; 100 MPa</i>.
</li>
<li>
When phase change is required, this model is to be used in combination with the
<a href=\"modelica://IBPSA.Media.Water\">IBPSA.Media.Water</a> media model for
incompressible liquid water for the liquid phase (quality = 0).
</li>
<li>
The two-phase region (e.g., mixed liquid and vapor), high temperature region, 
and liquid region are not included in this medium model.
</li>
</ul>
<h4>
Applications
</h4>
For numerical robustness, applications of this medium model assume the pressure, 
and hence the saturation pressure,is constant throughout the simulation. This 
is done to improve simulation performance by decoupling the pressure drop and 
energy balance calculations. 
<h4>
References
</h4>
<p>
W. Wagner et al., “The IAPWS industrial formulation 1997 for the thermodynamic 
properties of water and steam,” <i>J. Eng. Gas Turbines Power</i>, vol. 122, 
no. 1, pp. 150–180, 2000.
</p>
</html>", revisions="<html>
<ul>
<li>
May 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
      Line(
        points={{-30,30},{-50,10},{-30,-10},{-50,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{10,30},{-10,10},{10,-10},{-10,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{50,30},{30,10},{50,-10},{30,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier)}));
end Steam;
