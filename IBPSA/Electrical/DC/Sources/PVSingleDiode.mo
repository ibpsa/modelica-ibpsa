within IBPSA.Electrical.DC.Sources;
model PVSingleDiode
  "Photovoltaic module model based on single diode approach"

  extends IBPSA.Electrical.BaseClasses.PV.PartialPVSystem(
    redeclare package PhaseSystem = IBPSA.Electrical.PhaseSystems.TwoConductor,
    redeclare IBPSA.Electrical.DC.Interfaces.Terminal_p terminal,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVOpticalAbsRat PVOpt(
      final alt=alt,
      final til=til,
      final groRef=groRef,
      final glaExtCoe=glaExtCoe,
      final glaThi=glaThi,
      final refInd=refInd),
    redeclare IBPSA.Electrical.BaseClasses.PV.PVElectricalSingleDiodeMPP PVEle(
        redeclare IBPSA.Electrical.Data.PV.SingleDiodeData dat=dat),
    PVThe(redeclare IBPSA.Electrical.Data.PV.SingleDiodeData dat=dat),
    replaceable IBPSA.Electrical.Data.PV.SingleDiodeData dat);

protected
   IBPSA.Electrical.DC.Loads.Conductor
                   con(mode=Types.Load.VariableZ_P_input,
                       V_nominal=dat.VOC0) if use_ter
    "Conductor, used to interface power with electrical circuit"
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));

equation
  connect(PVEle.eta, PVThe.eta) annotation (Line(points={{-3.4,-53.75},{40,-53.75},
          {40,-20},{-72,-20},{-72,-12.4},{-17.0909,-12.4}}, color={0,0,127}));
  connect(PVThe.TCel, PVEle.TCel) annotation (Line(points={{-4.54545,-10},{0,-10},
          {0,-14},{-58,-14},{-58,-47},{-17.2,-47}},       color={0,0,127}));
  connect(PVOpt.absRadRat, PVEle.absRadRat) annotation (Line(points={{-4.54545,30},
          {20,30},{20,-34},{-64,-34},{-64,-50},{-17.2,-50}},           color={0,
          0,127}));
  connect(TDryBul, PVThe.TDryBul) annotation (Line(points={{-120,-30},{-60,-30},
          {-60,-5.2},{-17.0909,-5.2}},
                                  color={0,0,127}));
  connect(zenAng, PVOpt.zenAng) annotation (Line(points={{-120,80},{-40,80},{-40,
          34.8},{-17.0909,34.8}}, color={0,0,127}));
  connect(HGloHor, PVOpt.HGloHor) annotation (Line(points={{-120,-60},{-20,-60},
          {-20,30},{-17.0909,30}},     color={0,0,127}));
  connect(incAng, PVOpt.incAng) annotation (Line(points={{-120,50},{-60,50},{-60,
          32.4},{-17.0909,32.4}}, color={0,0,127}));
  connect(vWinSpe, PVThe.winVel) annotation (Line(points={{-120,20},{-80,20},{-80,
          -8},{-18,-8},{-18,-7.6},{-17.0909,-7.6}}, color={0,0,127}));
  connect(HGloTil, PVEle.HGloTil) annotation (Line(points={{-120,-90},{-80,-90},
          {-80,-72},{-40,-72},{-40,-53},{-17.2,-53}}, color={0,0,127}));
  connect(HGloTil, PVThe.HGloTil) annotation (Line(points={{-120,-90},{-80,-90},
          {-80,-18},{-17.0909,-18},{-17.0909,-14.8}}, color={0,0,127}));
  connect(HDifHor, PVOpt.HDifHor) annotation (Line(points={{-120,-120},{-60,-120},
          {-60,27.6},{-17.0909,27.6}}, color={0,0,127}));
  connect(PVEle.P, PDC) annotation (Line(points={{-3.4,-46.25},{96,-46.25},{96,0},
          {110,0}}, color={0,0,127}));
  connect(con.terminal, terminal)
    annotation (Line(points={{38,0},{-100,0}}, color={0,0,255}));
  connect(PVEle.P, con.Pow) annotation (Line(points={{-3.4,-46.25},{70,-46.25},{
          70,0},{58,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
                Documentation(info="<html>
<p>This is a photovoltaic generator model based on a single diode approach with replaceable thermal models accounting for different mountings.<br/>
The solar cell is approximated as a simplified diode circuit following the scheme illustrated in the following:</p>
<p align=\"center\"><img src=\"modelica://IBPSA/Resources/Images/Electrical/DC/Sources/single_diode_scheme.png\" alt='Single Diode Scheme'> </p>
<p>In the figure, <i>I</i><sub>ph</sub> denotes the photocurrent and <i>I</i><sub>d</sub> is the dark current.</p>
<p><i>I</i><sub>d</sub> is opposed to <i>I</i><sub>ph</sub></p>
<p><i>I</i><sub>d</sub> derives from the Shockley equation </p>
<p align=\"center\" style=\"font-style:italic;\">
<i>I</i><sub>d</sub> =
I<sub>s</sub>(e<sup>((U+IR<sub>s</sub>) &frasl; a)</sup>-1)</p>
<p>that bases on the saturation current <i>I</i><sub>s</sub>.</p>
<p>The Shockley equation uses the modified ideality factor </p>
<p align=\"center\" style=\"font-style:italic;\">a =(N<sub>s</sub> n<sub>I</sub> k T<sub>cell</sub> &frasl; q).</p>
<p>The modified ideality factor <i>a</i> results from the number of serial cells <i>N</i><sub>s</sub>,
the ideality factor <i>n</i><sub>I</sub>, the Boltzman constant k,
the elementary charge q,and the cell temperature <i>T</i><sub>cell</sub>.
<i>R</i><sub>s</sub> is the serial resistance that results in a voltage loss.</p>
<p>The parallel resistance <i>R</i><sub>sh</sub> accounts for the leakage currents along the cell's side
and <i>I</i><sub>sh</sub> is the resulting leakage current.
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
