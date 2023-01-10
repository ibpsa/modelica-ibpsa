within IBPSA.Electrical.DC.Sources;
model PVSingleDiode
  "Photovoltaic module(s) model based on single diode approach"
  extends IBPSA.Electrical.BaseClasses.PV.PartialPVSystem(
    final ageing=1.0,
    replaceable IBPSA.Electrical.Data.PV.SingleDiodeData data,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVOpticalHorFixedAziTil
      partialPVOptical(
        final lat=lat,
        final lon=lon,
        final alt=alt,
        til=til,
        azi=azi,
        final timZon=timZon,
        final groRef=groRef,
        HGloTil0=HGloTil0,
        final glaExtCoe=glaExtCoe,
        final glaThi=glaThi,
        final refInd=refInd,
        final tau_0=tau_0),
    redeclare IBPSA.Electrical.BaseClasses.PV.PVElectricalSingleDiodeMPP
      partialPVElectrical(redeclare IBPSA.Electrical.Data.PV.SingleDiodeData
        data=data,
        n_mod=n_mod),
    replaceable IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermalEmp
      partialPVThermal(
      redeclare IBPSA.Electrical.Data.PV.SingleDiodeData data=data),
    final use_MPP_in=false,
    final use_Til_in=false,
    final use_Azi_in=false,
    final use_Sha_in=false,
    final use_age_in=false,
    final use_heat_port=false);

  parameter Integer n_mod(min=1) "Amount of modules per system";

  parameter Modelica.Units.SI.Angle til "Surface's tilt angle (0:flat)" annotation(Dialog(tab="Module mounting and specifications"));
  parameter Modelica.Units.SI.Angle azi "Surface's azimut angle (0:South)" annotation(Dialog(tab="Module mounting and specifications"));

  parameter Real groRef(unit="1")=0.2 "Ground refelctance" annotation(Dialog(tab="Module mounting and specifications"));
  parameter Real glaExtCoe=4 "Glazing extinction coefficient for glass" annotation(Dialog(tab="Module mounting and specifications"));
  parameter Modelica.Units.SI.Length glaThi=0.002
    "Glazing thickness for most PV cell panels it is 0.002 m" annotation(Dialog(tab="Module mounting and specifications"));
  parameter Real refInd=1.526
    "Effective index of refraction of the cell cover (glass)" annotation(Dialog(tab="Module mounting and specifications"));
  parameter Modelica.Units.SI.Angle lat "Latitude" annotation(Dialog(tab="Site specifications"));
  parameter Modelica.Units.SI.Angle lon "Longitude" annotation(Dialog(tab="Site specifications"));
  parameter Modelica.Units.SI.Length alt "Site altitude in Meters, default= 1" annotation(Dialog(tab="Site specifications"));
  parameter Modelica.Units.SI.Time timZon(displayUnit="h")
  "Time zone in seconds relative to GMT" annotation(Dialog(tab="Site specifications"));
  parameter Real HGloTil0=1000 "Total solar radiation on the horizontal surface 
  under standard conditions" annotation(Dialog(tab="Site specifications"));

protected
  parameter Real tau_0=exp(-(partialPVOptical.glaExtCoe*partialPVOptical.glaThi))
      *(1 - ((partialPVOptical.refInd - 1)/(partialPVOptical.refInd + 1))^2)
    "Transmittance at standard conditions (incAng=refAng=0)";

equation
  connect(partialPVElectrical.eta, partialPVThermal.eta) annotation (Line(
        points={{-23.4,-53},{40,-53},{40,-20},{-72,-20},{-72,8.2},{-39.4,8.2}},
        color={0,0,127}));
  connect(partialPVThermal.TCel, partialPVElectrical.TCel) annotation (Line(
        points={{-23.3,10},{0,10},{0,-14},{-58,-14},{-58,-47},{-37.2,-47}},
                        color={0,0,127}));
  connect(partialPVElectrical.P, P) annotation (Line(points={{-23.4,-47},{20,-47},
          {20,-40},{60,-40},{60,0},{110,0}},
                           color={0,0,127}));
  connect(partialPVOptical.absRadRat, partialPVElectrical.absRadRat)
    annotation (Line(points={{-23.4,70},{20,70},{20,-34},{-64,-34},{-64,-51.8},{
          -37.2,-51.8}},  color={0,0,127}));
  connect(HGloHor, partialPVOptical.HGloHor) annotation (Line(points={{-120,100},
          {-60,100},{-60,80},{-48,80},{-48,70},{-37.2,70}},
                                         color={0,0,127}));
  connect(HGloTil, partialPVElectrical.radTil) annotation (Line(points={{-120,130},
          {-100,130},{-100,-54},{-68,-54},{-68,-54.2},{-37.2,-54.2}},
                                               color={0,0,127}));
  connect(TDryBul, partialPVThermal.TDryBul) annotation (Line(points={{-120,70},
          {-60,70},{-60,15.4},{-39.4,15.4}}, color={0,0,127}));
  connect(HGloTil, partialPVThermal.HGloTil) annotation (Line(points={{-120,130},
          {-80,130},{-80,6},{-40,6},{-40,5.8},{-39.4,5.8}},color={0,0,127}));
  connect(vWinSpe, partialPVThermal.winVel) annotation (Line(points={{-120,40},{
          -40,40},{-40,28},{-52,28},{-52,13},{-39.4,13}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
                Documentation(info="<html>
<p>This is a photovoltaic generator model based on a single diode approach with replaceable thermal models accounting for different mountings. </p>
<p>The solar cell is approximated as a simplified diode circuit following the scheme illustrated in the following:</p>
<p align=\"center\"><img src=\"modelica://IBPSA/Resources/Images/Electrical/DC/Sources/single_diode_scheme.png\" width=600px height=auto/> </p>
<p>In the figure, <i>I</i><sub>ph</sub> denotes the photocurrent and <i>I</i><sub>d</sub> is the dark current.</p>
<p>The dark current is opposed to the photocurrent and derives from the Shockley equation:</p>
<p align=\"center\"><img src=\"modelica://IBPSA/Resources/Images/Electrical/DC/Sources/dark_current_single_diode.png\" width=250px height=auto/> </p>
<p>where a is the modified ideality factor that is defined as follows:</p>
<p align=\"center\"><img src=\"modelica://IBPSA/Resources/Images/Electrical/DC/Sources/modified_ideality_single_diode.png\" width=250px height=auto/> </p>
<p>Here,  <i>N</i><sub>s</sub> is the number of serial cells, <i>n</i><sub>I</sub> is the ideality factor, </p>
<p>k is the Boltzman constant, q is the elementary charge, and <i>T</i><sub>cell</sub> the cell temperature.</p>
<p><i>R</i><sub>s</sub> is the serial resistance that results in a voltage loss.</p>
<p><i>R</i><sub>sh</sub> denotes is the serial resistance that accounts for the leakage currents along the cell's side.</p>
<p>And <i>I</i><sub>sh</sub> is the resulting leakage current.</p>
<p>The resulting I-V-curve is defined as follows and bases on 5 unknown parameters:</p>
<p align=\"center\"><img src=\"modelica://IBPSA/Resources/Images/Electrical/DC/Sources/I_U_curve_single_diode.png\" width=600px height=auto/> </p>
<p>Hence, the name 5-p approach is common.</p>
<p><br><br><br>For a definition of the parameters, see the <a href=\"modelica://IBPSA.BoundaryConditions.UsersGuide\">IBPSA.BoundaryConditions.UsersGuide</a>. </p>
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
