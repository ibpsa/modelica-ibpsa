within IDEAS.Thermal.Components.Emission;
package BaseClasses

  extends Modelica.Icons.BasesPackage;

  record FH_Standard1 "Basic floor heating design 1"
    extends IDEAS.Thermal.Components.BaseClasses.FH_Characteristics;
  end FH_Standard1;

  record FH_Standard2 "Larger pipes and bigger interdistance"
    extends IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(
      T=0.2,
      d_a=0.025,
      s_r=0.0025);
  end FH_Standard2;

  record FH_ValidationEmpa "According to Koschenz, 2000, par 4.5.1"
    extends IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(
      T=0.25,
      d_a=0.02,
      s_r=0.0025,
      n1=10,
      n2=10,
      lambda_r=0.55);
  end FH_ValidationEmpa;

  record FH_ValidationEmpa4_6 "According to Koschenz, 2000, par 4.6"
    extends IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(
      S_1=0.1,
      S_2=0.2,
      T=0.20,
      d_a=0.025,
      s_r=0.0025,
      n1=10,
      n2=10,
      lambda_r=0.45);
                // A_Floor should be 120m * 0.2m = 24 m²
  end FH_ValidationEmpa4_6;






end BaseClasses;
