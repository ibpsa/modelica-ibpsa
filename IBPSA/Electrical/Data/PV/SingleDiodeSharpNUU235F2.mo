within IBPSA.Electrical.Data.PV;
record SingleDiodeSharpNUU235F2
  "Single-diode record for Sharp NU-U235F2 modules"
   extends IBPSA.Electrical.Data.PV.SingleDiodeData(
    n_ser=60,
    n_par=1,
    A_cel=((V_mp0*I_mp0)/(1000*eta_0))/n_ser,
    A_mod=0.994*1.640,
    eta_0=0.144,
    V_oc0=37,
    I_sc0=8.6,
    V_mp0=30,
    I_mp0=7.84,
    P_mp0=235,
    TCoeff_Isc=0.00053*I_sc0,
    TCoeff_Voc=-0.00351*V_oc0,
    gamma_Pmp=-0.00485,
    T_NOCT=47.5 + 273.15,
    Eg0 = 1.107,
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
