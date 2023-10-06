within IBPSA.Electrical.Data.PV;
record SingleDiodeSolibroSL2CIGS115
  "Single-diode record for Solibro SL2 CIGS 115 Wp"
  extends IBPSA.Electrical.Data.PV.SingleDiodeData(
    nSer=150,
    nPar=1,
    ACel=((VMP0*IMP0)/(1000*eta0))/nSer,
    AMod=0.7895*1.190,
    eta0=0.122,
    VOC0=101.2,
    ISC0=1.69,
    VMP0=81.0,
    IMP0=1.42,
    PMP0=115,
    TCoeISC=0.000169,
    TCoeVOC=-0.27324,
    gammaPMP=-0.0032,
    TNOCT=42 + 273.15,
    Eg0=1.107,
    C=0.0002677);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<p>
This is an exemplary data model of the thin-film module Solibro SL2 CIGS 115 Wp used for the single-diode PV model.
This data is used for validation in
<a href=\"modelica://IBPSA.Electrical.DC.Sources.Validation.PVSingleDiodeRooftopBuildingValidation\">IBPSA.Electrical.DC.Sources.Validation.PVSingleDiodeRooftopBuildingValidation</a>.
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
end SingleDiodeSolibroSL2CIGS115;
