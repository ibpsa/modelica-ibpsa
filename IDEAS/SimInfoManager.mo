within IDEAS;
model SimInfoManager
  "Simulation information manager for handling time and climate data required in each for simulation."
  extends PartialSimInfoManager(final useTmy3Reader = true);


equation
  solDirPer=weaDat.cheDirNorRad.HOut;
  solDirHor = weaDat.cheGloHorRad.HOut - solDifHor;
  solDifHor = weaDat.cheDifHorRad.HOut;
  solGloHor = solDirHor + solDifHor;
  Te = weaDat.cheTemDryBul.TOut;
  TeAv = Te;
  Tground=TdesGround;
  irr = weaDat.cheGloHorRad.HOut;
  summer = timMan.summer;
  relHum = weaDat.cheRelHum.relHumOut;
  TDewPoi = weaDat.cheTemDewPoi.TOut;
  timLoc = timMan.timLoc;
  timSol = timMan.timSol;
  timCal = timMan.timCal;

  if BesTest then
    Tsky = Te - (23.8 - 0.2025*(Te - 273.15)*(1 - 0.87*Fc));
    Fc = 0.2;
    Va = 2.5;
  else
    Tsky = weaDat.TBlaSky.TBlaSky;
    Fc = weaDat.cheOpaSkyCov.nOut*0.87;
    Va = weaDat.cheWinSpe.winSpeOut;
  end if;

  annotation (
    defaultComponentName="sim",
    defaultComponentPrefixes="inner",
    missingInnerMessage=
        "Your model is using an outer \"sim\" component. An inner \"sim\" component is not defined. For simulation drag IDEAS.SimInfoManager into your model.",
    Icon(graphics={
        Ellipse(
          extent={{-60,78},{74,-58}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{18,52},{30,44},{36,44},{36,46},{34,48},{34,56},{22,60},{16,
              60},{10,58},{6,54},{8,52},{2,52},{-8,48},{-14,52},{-24,48},{-26,
              40},{-18,40},{-14,32},{-14,28},{-12,24},{-16,10},{-8,2},{-8,-2},{
              -6,-6},{-4,-4},{0,-6},{2,-12},{10,-18},{18,-24},{22,-30},{26,-36},
              {32,-44},{34,-50},{36,-58},{60,-44},{72,-28},{72,-18},{64,-14},{
              58,-12},{48,-12},{44,-14},{40,-16},{34,-16},{26,-24},{20,-22},{20,
              -18},{24,-12},{16,-16},{8,-12},{8,-8},{10,-2},{16,0},{24,0},{28,-2},
              {30,-8},{32,-6},{28,2},{30,12},{34,18},{36,20},{38,24},{34,26},{
              36,32},{26,38},{18,38},{20,32},{18,28},{12,32},{14,38},{16,42},{
              24,40},{22,46},{16,50},{18,52}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-34,64},{-30,62},{-26,64},{-24,60},{-36,58},{-24,52},{-16,54},
              {-14,62},{-8,68},{6,74},{12,74},{22,70},{28,64},{30,64},{44,62},{
              46,58},{42,56},{50,50},{66,34},{68,20},{74,12},{80,46},{70,78},{
              44,90},{2,90},{-32,80},{-34,64}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Bitmap(extent={{22,-8},{20,-8}}, fileName=""),
        Ellipse(extent={{-60,78},{74,-58}}, lineColor={95,95,95}),
        Polygon(
          points={{-66,-20},{-70,-16},{-72,-20},{-68,-30},{-60,-42},{-60,-40},{
              -62,-32},{-66,-20}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,-4},{-58,0},{-54,-2},{-54,-12},{-52,-20},{-48,-24},{-50,
              -28},{-50,-30},{-54,-28},{-56,-26},{-58,-12},{-62,-4}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,0},{-46,4},{-42,4},{-40,0},{-40,-4},{-38,-16},{-38,-22},
              {-40,-24},{-44,-22},{-44,-16},{-48,0}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,2},{-28,4},{-24,4},{-24,0},{-24,-12},{-24,-20},{-26,-24},
              {-30,-24},{-32,-6},{-32,2}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-6,-36},{-12,-42},{-8,-42},{-4,-36},{0,-26},{-2,-22},{-6,-22},
              {-8,-26},{-10,-32},{-8,-36},{-6,-36}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,-44},{-58,-40},{-54,-40},{-50,-36},{-42,-32},{-36,-32},{
              -32,-28},{-26,-28},{-24,-34},{-24,-36},{-26,-38},{-20,-42},{-16,-46},
              {-12,-46},{-8,-48},{-10,-52},{-12,-60},{-16,-66},{-20,-68},{-26,-70},
              {-30,-70},{-34,-70},{-36,-74},{-40,-76},{-42,-76},{-48,-72},{-54,
              -62},{-60,-44}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics),
    Documentation(info="<html>
</html>"));
end SimInfoManager;
