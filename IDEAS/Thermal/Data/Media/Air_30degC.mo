within IDEAS.Thermal.Data.Media;
record Air_30degC "Medium properties of air at 30 degC"
extends Thermal.Data.Interfaces.Medium(
    rho=1.149,
    cp=1007,
    cv=720,
    lamda=0.0264,
    nue=16.3E-6);
  annotation (Documentation(info="<html>
Medium: properties of air at 30 degC
</html>"));
end Air_30degC;
