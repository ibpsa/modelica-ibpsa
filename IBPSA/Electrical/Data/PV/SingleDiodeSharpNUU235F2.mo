within IBPSA.Electrical.Data.PV;
record SingleDiodeSharpNUU235F2
  "Single-diode record for Sharp NU-U235F2 modules"
  extends IBPSA.Electrical.Data.PV.SingleDiodeData(
    nSer=60,
    nPar=1,
    ACel=((VMP0*IMP0)/(1000*eta0))/nSer,
    AMod=0.994*1.640,
    eta0=0.144,
    VOC0=37,
    ISC0=8.6,
    VMP0=30,
    IMP0=7.84,
    PMP0=235,
    TCoeISC=0.00053*ISC0,
    TCoeVOC=-0.00351*VOC0,
    gammaPMP=-0.00485,
    TNOCT=47.5 + 273.15,
    Eg0=1.107,
    C=0.0002677);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<p>
This is an exemplary data model of the mono-Si module Sharp NU-U235 F2 used for the single-diode PV model.
This data is used for validation in
<a href=\"modelica://IBPSA.Electrical.DC.Sources.Validation.PVSingleDiodeNISTValidation\">IBPSA.Electrical.DC.Sources.Validation.PVSingleDiodeNISTValidation</a>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
Oct 6, 2023, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleDiodeSharpNUU235F2;
