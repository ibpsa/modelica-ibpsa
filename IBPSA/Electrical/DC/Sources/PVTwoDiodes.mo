within IBPSA.Electrical.DC.Sources;
model PVTwoDiodes
  "Photovoltaic module(s) model based on two diodes approach"
  extends IBPSA.Electrical.BaseClasses.PV.PartialPVSystem(
    replaceable IBPSA.Electrical.Data.PV.TwoDiodesData data,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVOpticalAbsRat
      PVOptical(
        final alt=alt,
        final til=til,
        final groRef=groRef,
        final glaExtCoe=glaExtCoe,
        final glaThi=glaThi,
        final refInd=refInd),
    redeclare IBPSA.Electrical.BaseClasses.PV.PVElectricalTwoDiodesMPP
      PVElectrical(redeclare IBPSA.Electrical.Data.PV.TwoDiodesData
        data=data),
    replaceable IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermalEmp
      PVThermal(
      redeclare IBPSA.Electrical.Data.PV.TwoDiodesData data=data));

equation
  connect(PVElectrical.eta, PVThermal.eta) annotation (Line(
        points={{-3.45455,-53},{40,-53},{40,-20},{-72,-20},{-72,-11.8},{-17.0909,
          -11.8}},
        color={0,0,127}));
  connect(PVThermal.TCel, PVElectrical.TCel) annotation (Line(
        points={{-4.54545,-10},{0,-10},{0,-14},{-58,-14},{-58,-47},{-16,-47}},
                        color={0,0,127}));
  connect(PVElectrical.P, PDC) annotation (Line(points={{-3.45455,-47},{20,
          -47},{20,-40},{60,-40},{60,0},{90,0}},  color={0,0,127}));
  connect(PVOptical.absRadRat, PVElectrical.absRadRat)
    annotation (Line(points={{-4.54545,30},{20,30},{20,-34},{-64,-34},{-64,-51.8},
          {-16,-51.8}},   color={0,0,127}));
  connect(HGloHor, PVOptical.HGloHor) annotation (Line(points={{-100,-30},
          {-60,-30},{-60,80},{-48,80},{-48,29.4},{-17.0909,29.4}},
                                         color={0,0,127}));
  connect(HGloTil, PVElectrical.HGloTil) annotation (Line(points={{-100,-60},
          {-100,-60},{-100,-54},{-68,-54},{-68,-54.2},{-16,-54.2}},color={0,0,127}));
  connect(TDryBul, PVThermal.TDryBul) annotation (Line(points={{-100,0},{
          -60,0},{-60,-4.6},{-17.0909,-4.6}},color={0,0,127}));
  connect(HGloTil, PVThermal.HGloTil) annotation (Line(points={{-100,-60},
          {-80,-60},{-80,6},{-40,6},{-40,-15.4},{-17.0909,-15.4}},
                                                           color={0,0,127}));
  connect(vWinSpe, PVThermal.winVel) annotation (Line(points={{-100,30},{
          -40,30},{-40,28},{-52,28},{-52,-8.2},{-17.0909,-8.2}},
                                                          color={0,0,127}));
  connect(zenAngle, PVOptical.zenAng) annotation (Line(points={{-100,90},
          {-44,90},{-44,34.2},{-17.0909,34.2}},
                                              color={0,0,127}));
  connect(incAngle, PVOptical.incAng) annotation (Line(points={{-100,60},
          {-100,64},{-22,64},{-22,31.8},{-17.0909,31.8}},         color={0,0,127}));
  connect(HDifHor, PVOptical.HDifHor) annotation (Line(points={{-100,-90},
          {-100,70},{-72,70},{-72,27},{-17.0909,27}},               color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
                Documentation(info="<html>
<p>This is a photovoltaic generator model based on a two diodes approach with replaceable thermal models accounting for different mountings. </p>
</html>",revisions="<html>
<ul>
<li>
Dec 12, 2022, by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVTwoDiodes;
