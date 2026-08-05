within IBPSA.Electrical.Data.PV;
record SingleDiodeSolibroSL2CIGS110
  "Single-diode record for Solibro SL2 CIGS 110 Wp"
  extends IBPSA.Electrical.Data.PV.SingleDiodeData(
    nSer=150,
    nPar=1,
    ACel=((VMP0*IMP0)/(1000*eta0))/nSer,
    AMod=0.7895*1.190,
    eta0=0.116,
    VOC0=93.3,
    ISC0=1.69,
    VMP0=72.4,
    IMP0=1.52,
    PMP0=110,
    TCoeISC=0.000676,
    TCoeVOC=-0.27,
    gammaPMP=-0.0038,
    TNOCT=51 + 273.15,
    Eg0=1.773609e-19,
    C=0.0002677);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This is an exemplary data model of the thin-film module Solibro SL2 CIGS 110 Wp
used for the single-diode PV model. This data is used for validation in
<a href=\"modelica://IBPSA.Electrical.DC.Sources.Validation.PVSingleDiodeRooftopBuilding\">
IBPSA.Electrical.DC.Sources.Validation.PVSingleDiodeRooftopBuildingValidation</a>.
</p>
<p>
The data record can be found here:
<a href=\"https://reenergyhub.com/files/hersteller/Solibro/pdf/Solibro_SL2_CIGS_THIN-FILM_Module_G1.5-100-120_en.pdf\">
https://reenergyhub.com/files/hersteller/Solibro/pdf/Solibro_SL2_CIGS_THIN-FILM_Module_G1.5-100-120_en.pdf</a>
</p>
</html>", revisions="<html>
<ul>
<li>
Oct 6, 2023, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleDiodeSolibroSL2CIGS110;
