within IBPSA.Electrical.BaseClasses.PV;
model PVElectricalSingleDiodeMPP
  "Analytical 5-p model for PV I-V characteristics with temperature dependency based on 5 parameters with automatic MPP control"
  extends
    IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVElectricalSingleDiode;

  // Main parameters under standard conditions

  Modelica.Units.SI.ElectricCurrent IPh0
    "Photo current under standard conditions";
  Modelica.Units.SI.ElectricCurrent IS0
    "Saturation current under standard conditions";
  Modelica.Units.SI.Resistance RS0
    "Series resistance under standard conditions";
  Modelica.Units.SI.Resistance RSh0
    "Shunt resistance under standard conditions";
  Real a0(unit="V") "Modified diode ideality factor under standard conditions";
  Real w0(final unit="1")
    "MPP auxiliary correlation coefficient under standard conditions";

// Additional parameters and constants

  constant Real q(unit = "A.s")= 1.602176620924561e-19
   "Elementary charge";

  Modelica.Units.SI.ElectricCurrent IMP(start=0.5*IMP0)
    "MPP current at operating conditions";

  Modelica.Units.SI.Voltage VMP "MPP voltage at operating conditions";

  Modelica.Units.SI.Energy Eg "Band gap energy at operating conditions";

  Modelica.Units.SI.ElectricCurrent IS
    "Saturation current at operating conditions";

  Modelica.Units.SI.Resistance RS "Series resistance at operating conditions";

  Modelica.Units.SI.Resistance RSh "Shunt resistance at operating conditions";

  Real a(final unit = "V", start = 1.3)
    "Modified diode ideality factor";

  Modelica.Units.SI.Power PMod "Output power of one PV module";

  Real w(final unit = "1", start = 0)
   "MPP auxiliary correlation coefficient";

  Modelica.Units.SI.Voltage VOC
    "Open circuit voltage under operating conditions";

equation

  // Analytical parameter extraction equations under standard conditions (Batzelis et al., 2016)

  a0 = VOC0*(1 - TCel0*betaVOC)/(50.1 - TCel0*alphaISC);

  w0 = IBPSA.Electrical.BaseClasses.PV.BaseClasses.lambertWSimple(exp(1/(a0/
    VOC0) + 1));

  RS0 = (a0*(w0 - 1) - VMP0)/IMP0;

  RSh0 = a0*(w0 - 1)/(ISC0*(1 - 1/w0) - IMP0);

  IPh0 = (1 + RS0/RSh0)*ISC0;

  IS0 = IPh0*exp(-1/(a0/VOC0));

  // Parameter extrapolation equations to operating conditions (DeSoto et al., 2006)

  a/a0 = TCel/TCel0;

  IS/IS0 = (TCel/TCel0)^3*exp(1/k*(Eg0/TCel0 - Eg/TCel));

  Eg/(Eg0) =1 - dat.C*(TCel - TCel0);

  RS = RS0;

  IPh =absRadRat*(IPh0 + TCoeISC*(TCel - TCel0));

  RSh/RSh0 = 1/IBPSA.Utilities.Math.Functions.inverseXRegularized(x=absRadRat, delta=Modelica.Constants.eps);

  // Simplified power correlations at MPP using Lambert W function (Batzelis et al., 2016)

  IMP = if noEvent(absRadRat <= Modelica.Constants.eps or w <= Modelica.Constants.eps)
     then 0 else IPh*(1 - 1/w) - a*(w - 1)/RSh;

  VMP = if absRadRat <= 0 then 0 else a*(w - 1) - RS*IMP;

  VOC = if IPh >= Modelica.Constants.eps*10 then a*log(abs((IPh/IS + 1))) else 0;

  w =
    IBPSA.Electrical.BaseClasses.PV.BaseClasses.lambertWSimple(exp(1/(a/IBPSA.Utilities.Math.Functions.inverseXRegularized(x=VOC, delta=Modelica.Constants.eps)) + 1));


// Efficiency and Performance

  eta=PMod/(IBPSA.Utilities.Math.Functions.inverseXRegularized(x=HGloTil, delta=Modelica.Constants.eps)*APan);

  PMod = VMP*IMP;

  P=max(0, min(PMax*nMod, PMod*nMod));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},
            {100,80}})),                                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})),
    Documentation(info="<html><h4>
  <span style=\"color: #008000\">Overview</span>
</h4>
<p>
  Analytical 5-p model for determining the I-V characteristics of a PV
  array (Batzelis et al.,2016) with temp. dependency of the 5
  parameters following (DeSoto et al.,2006).
  For more information on the 5-p modeling approach (single-diode PV cell approximation),
  see model
<a href=\"modelica://IBPSA.Electrical.DC.Sources.PVSingleDiode\">
IBPSA.Electrical.DC.Sources.PVSingleDiode</a> for more
information.
</p>
<p>
  The final output of this model
  is the DC performance of the PV array or module.
  The parameters are first determined for standard boundary conditions denoted with index 0.
  The analytical approach is based on simplifications that result in explicit equations.
  These can be solved more easily by the solver resulting in higher simulation speed.
  The resulting five unknown parameters at standard conditions basing non explicit functions are
  the modified ideality factor </p>
  <p align=\"center\" style=\"font-style:italic;\">
  a<sub>0</sub> = U<sub>L,0</sub> (1- T<sub>cell,0</sub> &beta;<sub>U,L</sub>) &frasl; (50.1 - T<sub>cell,0</sub> &alpha;<sub>I,K</sub>),
  </p>
  <p> the serial resistance
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  R<sub>s,0</sub> = (a<sub>0</sub> (w<sub>0</sub> -1) - U<sub>mp,0</sub> ) &frasl; (I<sub>mp,0</sub>),</p>
  <p>
  the parallel resistance
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  R<sub>sh,0</sub> = (a<sub>0</sub> (w<sub>0</sub> -1)) &frasl; (I<sub>L,0</sub>(1-1 &frasl; w<sub>0</sub>)-I<sub>mp,0</sub>),
  </p>
  <p>
  the photo current
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  I<sub>ph,0</sub> = (1+R<sub>s,0</sub> &frasl; R<sub>sh,0</sub>) I<sub>K,0</sub>,
  </p>
  <p>
  and the saturation current
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  I<sub>s,0</sub> =  I<sub>ph,0</sub> e<sup>(-U<sub>L,0</sub>/a<sub>0+1</sub>)</sup>.
  </p>
  <p>
  The system of equations is based on an approximation of the Lambert equation W at standard conditions
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  w<sub>0</sub> =  W(e<sup>U<sub>L,0</sub>/a<sub>L,0</sub></sup>).
  </p>
  <p>
  Finally, an explicit formulation of the I-V charactierstic at the maximum power point (mp) is derived
  for the current at the maximum power point
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  I<sub>mp</sub> = I<sub>ph</sub>(1-1/w)-a(w-1)/R<sub>sh</sub>
  </p>
  <p>
  and the voltage at the maximum power point
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  U<sub>mp</sub> = a(w-1) - R<sub>s</sub> I<sub>mp</sub>.
  </p>


<p>
The parameters during operating conditions result from simplified relations
to the parameter values at standard conditions following (DeSoto et al.,2006).
</p>
<p>
The model was validated with experimental data from NIST (Boyd, 2017).
</p>
<p>
The module calibration is based on manufactory data.
</p>
<p>
  <br/>
</p>
<h4>References</h4>
<p>
Batzelis, E. I., &amp; Papathanassiou, S. A. (2015). A method for the analytical
extraction of the single-diode PV model parameters. IEEE Transactions on
Sustainable Energy, 7(2), 504-512.
<a href=\"https://doi.org/10.1109/TSTE.2015.2503435\">
https://doi.org/10.1109/TSTE.2015.2503435</a>
</p>
<p>
De Soto, W., Klein, S. A., &amp; Beckman, W. A. (2006). Improvement and validation
of a model for photovoltaic array performance. Solar energy, 80(1), 78-88,
<a href=\"https://doi.org/10.1016/j.solener.2005.06.010\">
https://doi.org/10.1016/j.solener.2005.06.010</a>
</p>
<p>
Boyd, M. (2017). Performance data from the nist photovoltaic arrays and weather
station. Journal of Research of the National Institute of Standards and
Technology, 122, 1.
<a href=\"https://doi.org/10.6028/jres.122.040\">
https://doi.org/10.6028/jres.122.040</a>
</p>
</html>",revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVElectricalSingleDiodeMPP;
