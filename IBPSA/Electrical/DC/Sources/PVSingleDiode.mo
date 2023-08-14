within IBPSA.Electrical.DC.Sources;
model PVSingleDiode
  "Photovoltaic module(s) model based on single diode approach"
  extends IBPSA.Electrical.BaseClasses.PV.PartialPVSystem(
    replaceable IBPSA.Electrical.Data.PV.SingleDiodeData data,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVOpticalAbsRat
      PVOptical(
        final alt=alt,
        final til=til,
        final groRef=groRef,
        final glaExtCoe=glaExtCoe,
        final glaThi=glaThi,
        final refInd=refInd),
    redeclare IBPSA.Electrical.BaseClasses.PV.PVElectricalSingleDiodeMPP
      PVElectrical(redeclare IBPSA.Electrical.Data.PV.SingleDiodeData
        data=data),
    replaceable IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermalEmp
      PVThermal(
      redeclare IBPSA.Electrical.Data.PV.SingleDiodeData data=data));

equation
  connect(PVElectrical.eta, PVThermal.eta) annotation (Line(
        points={{-3.4,-53.75},{40,-53.75},{40,-20},{-72,-20},{-72,-11.8},{-17.0909,
          -11.8}},
        color={0,0,127}));
  connect(PVThermal.TCel, PVElectrical.TCel) annotation (Line(
        points={{-4.54545,-10},{0,-10},{0,-14},{-58,-14},{-58,-46.25},{-17.2,-46.25}},
                        color={0,0,127}));
  connect(PVElectrical.P, PDC) annotation (Line(points={{-3.4,-46.25},{20,
          -46.25},{20,-40},{60,-40},{60,0},{90,0}},
                                             color={0,0,127}));
  connect(PVOptical.absRadRat, PVElectrical.absRadRat)
    annotation (Line(points={{-4.54545,30},{20,30},{20,-34},{-64,-34},{-64,-52.25},
          {-17.2,-52.25}},color={0,0,127}));
  connect(HGloTil, PVElectrical.HGloTil) annotation (Line(points={{-100,-60},
          {-100,-60},{-100,-54},{-68,-54},{-68,-55.25},{-17.2,-55.25}},color={0,
          0,127}));
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

  connect(HGloHor, PVOptical.HGloHor) annotation (Line(points={{-100,-30},
          {-20,-30},{-20,29.4},{-17.0909,29.4}},color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
                Documentation(info="<html>
<p>This is a photovoltaic generator model based on a single diode approach with replaceable thermal models accounting for different mountings.<br/>
The solar cell is approximated as a simplified diode circuit following the scheme illustrated in the following:<br/></p>
<p align=\"center\"><img src=\"modelica://IBPSA/Resources/Images/Electrical/DC/Sources/single_diode_scheme.png\" alt='Single Diode Scheme'> </p>
<p>In the figure, <i>I</i><sub>ph</sub> denotes the photocurrent and <i>I</i><sub>d</sub> is the dark current.<br/>
<i>I</i><sub>d</sub> is opposed to <i>I</i><sub>ph</sub><br/>
<i>I</i><sub>d</sub> derives from the Shockley equation </p>
<p align=\"center\" style=\"font-style:italic;\">
<i>I</i><sub>d</sub> =
I<sub>s</sub>(e<sup>((U+IR<sub>s</sub>) &frasl; a)</sup>-1)</p>
<p> that bases on the saturation current <i>I</i><sub>s</sub>.<br/>
The Shockley equation uses the modified ideality factor </p>
<p align=\"center\" style=\"font-style:italic;\">a =(N<sub>s</sub> n<sub>I</sub> k T<sub>cell</sub> &frasl; q).</p>
<p>The modified ideality factor <i>a</i> results from<br/>
the number of serial cells <i>N</i><sub>s</sub>,<br/>
the ideality factor <i>n</i><sub>I</sub>,<br/>
the Boltzman constant k,<br/>
the elementary charge q,
<br/>and the cell temperature <i>T</i><sub>cell</sub>.
<i>R</i><sub>s</sub> is the serial resistance that results in a voltage loss.<br/>
The parallel resistance <i>R</i><sub>sh</sub> accounts for the leakage currents along the cell's side<br/>
and <i>I</i><sub>sh</sub> is the resulting leakage current.<br/>
The result is the I-V-curve</p>
<p align=\"center\" style=\"font-style:italic;\">
<i>I</i> =
I<sub>ph</sub> - I<sub>d</sub> - I<sub>sh</sub> <br/>
= I<sub>ph</sub> - I<sub>s</sub> (e<sup>((U+IR<sub>s</sub>) &frasl; a)</sup>-1) - (U+IR<sub>s</sub>) &frasl; R<sub>sh</sub>
</p>
<p>that bases on five unknown parameters (<i>I</i><sub>ph</sub>, <i>I</i><sub>s</sub>, <i>a</i>, <i>R</i><sub>s</sub>, and <i>R</i><sub>sh</sub>) only.<br/>
Hence, the name 5-p approach is common.</p>
<p><br><br>For a definition of the parameters, see the <a href=\"modelica://IBPSA.BoundaryConditions.UsersGuide\">IBPSA.BoundaryConditions.UsersGuide</a>. </p>
<h4>References</h4>
<p>
Humada, Ali M. ; Hojabri, Mojgan ; Mekhilef, Saad ; Hamada, Hussein M.: Solar
cell parameters extraction based on single and double-diode models: A review. In:
Renewable and Sustainable Energy Reviews 56 (2016), 494–509.
<a href=\"https://doi.org/10.1016/j.rser.2015.11.051\">
https://doi.org/10.1016/j.rser.2015.11.051</a>
</p>
<p>
Cannizzaro, S. ; Di Piazza, M. C. ; Luna, M. ; Vitale, G.: Generalized classification
of PV modules by simplified single-diode models. In: IEEE 23rd International
Symposium on Industrial Electronics (ISIE), 2014. Piscataway, NJ : IEEE, 2014. –
ISBN 978–1–4799–2399–1, S. 2266–2273
</p>
<p>
Jordehi, A. R.: Parameter estimation of solar photovoltaic (PV) cells: A review. In:
Renewable and Sustainable Energy Reviews 61 (2016), 354–371.
<a href=\"http://dx.doi.org/10.1016/j.rser.2016.03.049\">
http://dx.doi.org/10.1016/j.rser.2016.03.049</a>
– ISSN 1364–0321
</p>
</html>",revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVSingleDiode;
