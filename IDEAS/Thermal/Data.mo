within IDEAS.Thermal;
package Data

    extends Modelica.Icons.MaterialPropertiesPackage;

package Media
    extends Modelica.Icons.MaterialPropertiesPackage;

  record Air_30degC "Medium properties of air at 30 degC"
  extends IDEAS.Thermal.Data.Interfaces.Medium(
    rho=1.149,
    cp=1007,
    cv= 720,
    lamda=0.0264,
    nue=16.3E-6);
    annotation (Documentation(info="<html>
Medium: properties of air at 30 degC
</html>"));
  end Air_30degC;

  record Air_70degC "Medium properties of air at 70 degC"
  extends IDEAS.Thermal.Data.Interfaces.Medium(
    rho=1.015,
    cp=1010,
    cv= 723,
    lamda=0.0293,
    nue=20.3E-6);
    annotation (Documentation(info="<html>
Medium: properties of air at 70 degC
</html>"));
  end Air_70degC;

  record Water "Medium properties of water"
  extends IDEAS.Thermal.Data.Interfaces.Medium(
    rho=995.6,
    cp=4177,
    cv=4177,
    lamda=0.615,
    nue=0.8E-6);
    annotation (Documentation(info="<html>
Medium: properties of water
</html>"));
  end Water;

end Media;

package Interfaces

  extends Modelica.Icons.InterfacesPackage;

partial record Medium "Record containing media properties"

  extends Modelica.Icons.MaterialProperty;

  parameter Modelica.SIunits.Density rho = 1 "Density";
  parameter Modelica.SIunits.SpecificHeatCapacity cp = 1
        "Specific heat capacity at constant pressure";
  parameter Modelica.SIunits.SpecificHeatCapacity cv = 1
        "Specific heat capacity at constant volume";
  parameter Modelica.SIunits.ThermalConductivity lamda = 1
        "Thermal conductivity";
  parameter Modelica.SIunits.KinematicViscosity nue = 1 "Kinematic viscosity";
  annotation (Documentation(info="<html>
Record containing (constant) medium properties.
</html>"));
end Medium;

end Interfaces;

end Data;
