within IBPSA.Electrical.Data.PV;
record SingleDiodeSolibroSL2CIGS115
  "Single-diode record for Solibro SL2 CIGS 115 Wp"
   extends IBPSA.Electrical.Data.PV.SingleDiodeData(
    n_ser=150,
    n_par=1,
    A_cel=((V_mp0*I_mp0)/(1000*eta_0))/n_ser,
    A_mod=0.7895*1.190,
    eta_0=0.122,
    V_oc0=101.2,
    I_sc0=1.69,
    V_mp0=81.0,
    I_mp0=1.42,
    P_mp0=115,
    TCoeff_Isc=0.000169,
    TCoeff_Voc=-0.27324,
    gamma_Pmp=-0.0032,
    T_NOCT=42 + 273.15,
    Eg0 = 1.107,
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
