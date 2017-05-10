within IDEAS.Buildings.Components.Interfaces;
connector WeaBus "Data bus that stores weather data"
  extends Modelica.Icons.SignalBus;
  parameter Integer numSolBus;
  parameter Boolean outputAngles = true "Set to false when linearising in Dymola only";

  IDEAS.Buildings.Components.Interfaces.SolBus[numSolBus] solBus(each outputAngles=outputAngles) annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector Te(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 0.0,
    start = 293.15,
    nominal = 300,
    displayUnit="degC") "Ambient sensible temperature" annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector Tdes(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 0.0,
    start = -8 + 273.15,
    nominal = 300,
    displayUnit="degC") "Design temperature?" annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector TGroundDes(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 0.0,
    start = 283.15,
    nominal = 300,
    displayUnit="degC")
    "Design ground temperature" annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector hConExt(unit="W/(m2.K)", start = 18.3) "Exterior convective heat transfer coefficient" annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector X_wEnv(start=0.01) "Environment air water mass fraction"
                                annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector CEnv(start=1e-6) "Environment air trace substance mass fraction"
                                annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector dummy(start=1)
    "Dummy variable of value 1 to include constant term in linearization (see SlabOnGround)"
    annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector TskyPow4,TePow4, solGloHor, solDifHor, F1, F2, angZen, angHou, angDec, solDirPer;
  annotation (
    defaultComponentName="weaBus",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-20,2},{22,-2}},
          lineColor={255,204,51},
          lineThickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>
Connector that contains all environment information for many inclinations and tilt angles.
</p>
</html>",
   revisions="<html>
<ul>
<li>
March 21, 2017, by Filip Jorissen:<br/>
Changed Reals into connectors for JModelica compatibility.
Other compatibility changes. 
See issue <a href=https://github.com/open-ideas/IDEAS/issues/559>#559</a>.
</li>
<li>
October 22, 2016, by Filip Jorissen:<br/>
Revised documentation for IDEAS 1.0.
</li>
<li>
June 25, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end WeaBus;
