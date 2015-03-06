within IDEAS.Buildings.Validation.Tests;
model ViewFactorVerification
  "View factor implementation verification based on case 900"

  extends Modelica.Icons.Example;

  /*

Simulation of all so far modeled BESTEST cases in a single simulation.

*/

  inner IDEAS.SimInfoManager sim(
    filNam="BESTEST.TMY",
    lat=0.69464104229374,
    lon=-1.8308503853421,
    timZonSta=-28800)
              annotation (Placement(transformation(extent={{-92,68},{-82,78}})));

  // BESTEST 600 Series

  // BESTEST 900 Series

  replaceable Cases.Case900 CaseVf(building(gF(calculateViewFactor=true)))
    constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-76,4},{-64,16}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  replaceable Cases.Case900 CaseNoVf(building(gF(calculateViewFactor=false)))
    constrainedby Interfaces.BesTestCase
    annotation (Placement(transformation(extent={{-76,-16},{-64,-4}})));
  annotation (
    experiment(
      StopTime=3.1536e+007,
      Interval=3600,
      Tolerance=1e-007),
    __Dymola_experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={         Text(
          extent={{-78,28},{-40,20}},
          lineColor={85,0,0},
          fontName="Calibri",
          textStyle={TextStyle.Bold},
          textString="BESTEST 900 Series")}),
    __Dymola_Commands(executeCall(ensureSimulated=true) = {createPlot(
        id=1,
        position={0,0,1065,643},
        y={"CaseVf.building.TSensor[1]","CaseNoVf.building.TSensor[1]"},
        range={0.0,32000000.0,293.0,301.0},
        grid=true,
        leftTitleType=1,
        bottomTitleType=1,
        colors={{0,0,255},{255,0,0}}),createPlot(
        id=1,
        position={0,0,1065,318},
        y={"CaseVf.PHea","CaseNoVf.PHea"},
        range={0.0,32000000.0,-4000.0,500.0},
        grid=true,
        subPlot=2,
        leftTitleType=1,
        bottomTitleType=1,
        colors={{0,0,255},{255,0,0}})} "Verification"),
    Documentation(revisions="<html>
<ul>
<li>
March, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model simulates Bestest case 900 two times. Once with and once without explicit view factor implementation. Use the added command to plot the difference in results between the two implementations.</p>
</html>"));
end ViewFactorVerification;
