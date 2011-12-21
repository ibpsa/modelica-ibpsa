within IDEAS.Thermal.Data.Media;
record Air_70degC "Medium properties of air at 70 degC"
extends Thermal.Data.Interfaces.Medium(
    rho=1.015,
    cp=1010,
    cv=723,
    lamda=0.0293,
    nue=20.3E-6);
  annotation (Documentation(info="<html>
Medium: properties of air at 70 degC
</html>"));
end Air_70degC;
