within Annex60.Experimental.ThermalZones.BaseClasses.CorrectionSolarGain;
model CorG_VDI6007 "Correction of the solar gain factor according to VDI6007"
  extends PartialCorG;
  import Modelica.SIunits.Conversions.to_deg;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Uw
    "Thermal transmission coefficient of whole window";

  // Parameters for calculating the transmission correction factor based on VDI_6007 Part-3
  // A0 to A6 are experimental constants VDI 6007 Part-3 page 20
protected
  parameter Real A0=0.918;
  parameter Real A1=2.21*10^(-4);
  parameter Real A2=-2.75*10^(-5);
  parameter Real A3=-3.82*10^(-7);
  parameter Real A4=5.83*10^(-8);
  parameter Real A5=-1.15*10^(-9);
  parameter Real A6=4.74*10^(-12);
  parameter Real g_dir0=0.7537; // Reference value for 2 Panels window
  parameter Real Ta_diff = 0.84; // Energetic degree of transmission for diffuse solar irradiation
  parameter Real Tai_diff=0.903; //Pure degree of transmission
  parameter Real Ta1_diff= Ta_diff*Tai_diff;
  parameter Real rho_T1_diff=1-(Ta_diff);
  parameter Real rho_11_diff=rho_T1_diff/(2-(rho_T1_diff));
  parameter Real rho_1_diff= rho_11_diff+(((1-rho_11_diff)*Tai_diff)^2*rho_11_diff)/(1-(rho_11_diff*Tai_diff)^2);  //degree of reflection for single panel clear glass
  parameter Real XN2_diff=1-rho_1_diff^2;
  parameter Real Ta2_diff=(Ta1_diff^2)/XN2_diff;
  parameter Real a1_diff=1-Ta1_diff-rho_1_diff; // Degree of absorption for single panel clear glass
  parameter Real Q21_diff=a1_diff*(1+(Ta1_diff*rho_1_diff/XN2_diff))*Uw/25;
  parameter Real Q22_diff=a1_diff*(Ta1_diff/XN2_diff)*(1-(Uw/7.7));
  parameter Real Qsek2_diff=Q21_diff+Q22_diff;
  parameter Real CorG_diff=(Ta2_diff+Qsek2_diff)/g_dir0; // Transmission coefficient correction factor for diffuse irradiations
  parameter Real CorG_gr=(Ta2_diff+Qsek2_diff)/g_dir0;   // Transmission coefficient correction factor for irradiations from ground

  //Calculating the correction factor for direct solar radiation
  Real[n] theta; // Solar incident angle
  Real[n] Ta_dir;  // Energetic degree of transmission for direct solar irradiation
  Real[n] Tai_dir;  //Pure degree of transmission
  Real[n] Ta1_dir;
  Real[n] rho_T1_dir;
  Real[n] rho_11_dir;
  Real[n] rho_1_dir;  //Degree of reflection for single panel clear glass
  Real[n] XN2_dir;
  Real[n] Ta2_dir;
  Real[n] a1_dir;   // Degree of absorption for single panel clear glass
  Real[n] Q21_dir;
  Real[n] Q22_dir;
  Real[n] Qsek2_dir;
  Real[n] CorG_dir;  // Transmission coefficient correction factor for direct irradiations
equation
  for i in 1:n loop
    theta[i] = inc[i];
    Ta_dir[i]= (((((A6*to_deg(theta[i])+A5)*to_deg(theta[i])+A4)*to_deg(theta[i])+A3)*to_deg(theta[i])+A2)*to_deg(theta[i])+A1)*to_deg(theta[i])+A0;
    Tai_dir[i]= 0.907^(1/sqrt(1-(sin(theta[i])/1.515)^2));
    Ta1_dir[i]= Ta_dir[i]*Tai_dir[i];
    rho_T1_dir[i]= 1-Ta_dir[i];
    rho_11_dir[i]= rho_T1_dir[i]/(2-rho_T1_dir[i]);
    rho_1_dir[i]=rho_11_dir[i]+(((1-rho_11_dir[i])*Tai_dir[i])^2*rho_11_dir[i])/(1-(rho_11_dir[i]*Tai_dir[i])^2);
    a1_dir[i]= 1-Ta1_dir[i]-rho_1_dir[i];
    XN2_dir[i]= 1+10^(-20)-rho_1_dir[i]^2;
    Q21_dir[i]=a1_dir[i]*(1+(Ta1_dir[i]*rho_1_dir[i]/XN2_dir[i]))*Uw/25;
    Q22_dir[i]= a1_dir[i]*(Ta1_dir[i]/XN2_dir[i])*(1-(Uw/7.7));
    Qsek2_dir[i]=Q21_dir[i]+Q22_dir[i];
    Ta2_dir[i]= Ta1_dir[i]^2/XN2_dir[i];
    CorG_dir[i]= (Ta2_dir[i]+Qsek2_dir[i])/g_dir0;

    //Calculating the input thermal energy due to solar radiation
    solarRadWinTrans[i] = ((HDirTil[i]*CorG_dir[i])+(HSkyDifTil[i]*CorG_diff)+(HGroDifTil[i]*CorG_gr));
  end for;

annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics),
    Documentation(info="<html>
<h4><span style=\"color: #000000\">Overview</span></h4>
<p>This model computes the transmission correction factors for solar radiation through a double pane window depending on the incidence angle, based on the VDI 6007 Part 3.</p>
<p>The correction factors are calculated for the transmitted total and diffuse (cloudy sky) solar radiation, and the reflected radiation from the ground. </p>
<h4><span style=\"color: #000000\">Known Limitations</span></h4>
<p>The model is directly parameterized for a double pane window.</p>
<h4><span style=\"color: #000000\">References</span></h4>
<p>transmission correction factors (CORg) are calculated based on :</p>
<ul>
<li>VDI 6007 Part 3</li>
</ul>
</html>",
    revisions="<html>
<p><i>February 24, 2014</i> by Reza Tavakoli:</p>
<p>implemented </p>
<p><i><span style=\"font-family: MS Shell Dlg 2;\">September 12, 2015 </span></i>by Moritz Lauster:</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">changed input connector from SolRad to five Reals</span></p>
</html>"));
end CorG_VDI6007;
