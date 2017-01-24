within IDEAS.Examples.TwinHouses.Experimental;
model BuildingN2_Exp2_DirGains
  extends BuildingN2_Exp2(redeclare N2SplitFloor struct);
  annotation (experiment(
      StartTime=8.46e+06,
      StopTime=1.2e+07,
      __Dymola_NumberOfIntervals=5000), Documentation(revisions="<html>
<ul>
<li>
January 24, 2017 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This experimental model has a more detailed solar irradiation model 
where all direct solar irradiation is injected onto 1 part of the floor. 
This result in small result changes when comparing with 
<a href=modelica://IDEAS.Examples.TwinHouses.BuildingN2_Exp2>IDEAS.Examples.TwinHouses.BuildingN2_Exp2</a>.
</p>
</html>"));
end BuildingN2_Exp2_DirGains;
