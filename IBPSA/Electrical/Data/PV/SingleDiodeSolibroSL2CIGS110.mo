within IBPSA.Electrical.Data.PV;
record SingleDiodeSolibroSL2CIGS110 "Single-diode record for Solibro SL2 CIGS 110 Wp"
   extends IBPSA.Electrical.Data.PV.SingleDiodeData(
    n_ser=150,
    n_par=1,
    A_cel=((V_mp0*I_mp0)/(1000*eta_0))/n_ser,
    A_mod=0.7895*1.190,
    eta_0=0.116,
    V_oc0=93.3,
    I_sc0=1.69,
    V_mp0=72.4,
    I_mp0=1.52,
    P_mp0=110,
    TCoeff_Isc=0.000676,
    TCoeff_Voc=-0.27,
    gamma_Pmp=-0.0038,
    T_NOCT=51 + 273.15,
    Eg0 = 1.107,
    C=0.0002677);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<p>
This is an exemplary data model of the thin-film module Solibro SL2 CIGS 110 Wp used for the single-diode PV model.
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
end SingleDiodeSolibroSL2CIGS110;
