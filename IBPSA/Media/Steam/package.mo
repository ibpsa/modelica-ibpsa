within IBPSA.Media;
package Steam "Package of classes modeling steam"
  extends Modelica.Media.Water.WaterIF97_pT;

  extends Modelica.Icons.Package;

  redeclare model extends BaseProperties "Base properties"

  end BaseProperties;

annotation (Documentation(info="<html>
<p>
The steam model can be utilized for the 1st generation district heating system. 
Here assume the water is always in the one-phase region, either liquid or vapor. 
Two-phase region (e.g., liquid and vapor) is not modeled.
</p>

<h4> 
Limitation
</h4>
<p>
<ul>
<li>
This model uses standard physical equations to calculate enthalpy from temperature for different regions, 
and use backward equations to calculate temperature from enthalpy to avoid iterations.
The numnerical differences between standard equations and backward equations in terms of temperature is shown in the following figure.
</li>
<li>
The steam model has discontious properties when changing from liquid phase to vapor phase. Details can be observed in 
<a href=\"modelica://IBPSA.Media.Examples.SteamProperties\">IBPSA.Media.Examples.SteamProperties</a>.
</li>
</ul>
</p>

</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Yangyang Fu:<br/>
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
