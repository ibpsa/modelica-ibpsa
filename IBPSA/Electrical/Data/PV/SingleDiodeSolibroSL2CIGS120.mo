within IBPSA.Electrical.Data.PV;
record SingleDiodeSolibroSL2CIGS120
  "Single-diode record for Solibro SL2 CIGS 120 Wp"
   extends IBPSA.Electrical.Data.PV.SingleDiodeData(
    n_ser=150,
    n_par=1,
    A_cel=((V_mp0*I_mp0)/(1000*eta_0))/n_ser,
    A_mod=0.7895*1.190,
    eta_0=0.128,
    V_oc0=102.3,
    I_sc0=1.71,
    V_mp0=82.2,
    I_mp0=1.46,
    P_mp0=120,
    TCoeff_Isc=0.000171,
    TCoeff_Voc=-0.27621,
    gamma_Pmp=-0.0032,
    T_NOCT=42 + 273.15,
    Eg0 = 1.107,
    C=0.0002677);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<p>
This is an exemplary data model of the thin-film module Solibro SL2 CIGS 120 Wp used for the single-diode PV model.
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
end SingleDiodeSolibroSL2CIGS120;
