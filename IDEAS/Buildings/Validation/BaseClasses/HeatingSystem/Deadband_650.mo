within IDEAS.Buildings.Validation.BaseClasses.HeatingSystem;
model Deadband_650 "BESTEST deadband heating system"
  extends IDEAS.Interfaces.BaseClasses.HeatingSystem(
    final nLoads=1, final nTemSen = nZones, C = VZones * corrCV * 1012 * 1.204);

  parameter Modelica.SIunits.Volume[nZones] VZones;
  parameter Real corrCV = 5 "Correction factor for thermal mass in zone";

protected
  parameter Modelica.SIunits.Temperature Theat=0 "No Heating";
  parameter Modelica.SIunits.Temperature Tcool=300.15 "Cooling on above 27degC";

equation
  for i in 1:nZones loop
    if Theat > TSensor[i] then
      heatPortCon[i].Q_flow = -1*C[i]*(Theat - TSensor[i]);
    elseif Tcool < TSensor[i] then
      heatPortCon[i].Q_flow = -1*C[i]*(Tcool - TSensor[i]);
    else
      heatPortCon[i].Q_flow = 0;
    end if;
    heatPortRad[i].Q_flow = 0;
//    heatPortEmb[i].Q_flow = 0;
  end for;

  QHeaSys = sum(heatPortRad.Q_flow) + sum(heatPortCon.Q_flow) + sum(
    heatPortEmb.Q_flow);

  P = {QHeaSys};
  Q = {0};

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -100},{200,100}}), graphics));
end Deadband_650;
