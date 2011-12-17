within IDEAS.Buildings.Data;
package Insulation "Library of thermal insulation materials"

  extends Modelica.Icons.MaterialPropertiesPackage;

  record Rockwool = IDEAS.Buildings.Data.Interfaces.Insulation (
      k=0.036,
      c=840,
      rho=110,
      epsLw=0.8,
      epsSw=0.8) "Rockwool";
  record Glasswool = IDEAS.Buildings.Data.Interfaces.Insulation (
      k=0.040,
      c=840,
      rho=80) "Glasswool";
  record Cellularglass = IDEAS.Buildings.Data.Interfaces.Insulation (
      k=0.046,
      c=840,
      rho=130) "Cellular glass";
  record Eps = IDEAS.Buildings.Data.Interfaces.Insulation (
      k=0.036,
      c=1470,
      rho=26,
      epsLw=0.8,
      epsSw=0.8) "Expanded polystrenem, EPS";
  record Xps = IDEAS.Buildings.Data.Interfaces.Insulation (
      k=0.024,
      c=1470,
      rho=40,
      epsLw=0.8,
      epsSw=0.8) "Extruded polystrene, XPS";
  record Pur = IDEAS.Buildings.Data.Interfaces.Insulation (
      k=0.020,
      c=1470,
      rho=30,
      epsLw=0.8,
      epsSw=0.8) "Polyurethane foam, PUR";
  record Pir = IDEAS.Buildings.Data.Interfaces.Insulation (
      k=0.020,
      c=1470,
      rho=30) "Polyisocyanuraat foam, PIR";
end Insulation;
