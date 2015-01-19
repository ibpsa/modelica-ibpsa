within IDEAS.Buildings.Validation.BaseClasses.HeatingSystem;
model Bangbang "BESTEST bang-bang heating system"
  extends IDEAS.Interfaces.BaseClasses.HeatingSystem(
    final nLoads=1, final nTemSen = nZones, C = VZones * corrCV * 1012 * 1.204);

  parameter Modelica.SIunits.Volume[nZones] VZones;
  parameter Real corrCV = 5 "Correction factor for thermal mass in zone";

protected
  parameter Modelica.SIunits.Temperature Theat=293.15 "Heating on below 20degC";
  parameter Modelica.SIunits.Temperature Tcool=293.15 "Cooling on above 27degC";

equation
  for i in 1:nZones loop
    if Theat > TSensor[i] then
      heatPortCon[i].Q_flow = -100*C[i]*(Theat - TSensor[i]);
    elseif Tcool < TSensor[i] then
      heatPortCon[i].Q_flow = -100*C[i]*(Tcool - TSensor[i]);
    else
      heatPortCon[i].Q_flow = 0;
    end if;

    heatPortRad[i].Q_flow = 0;
//    heatPortEmb[i].Q_flow = 0;
  end for;

  P = {QHeaSys};
  Q = {0};

  QHeaSys = sum(heatPortRad.Q_flow) + sum(heatPortCon.Q_flow) + sum(
    heatPortEmb.Q_flow);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -100},{200,100}}), graphics));
end Bangbang;
