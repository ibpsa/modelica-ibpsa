within IDEAS.Buildings.Validation.BaseClasses;
package HeatingSystem

    extends Modelica.Icons.Package;

  model None "None"
    extends IDEAS.Interfaces.HeatingSystem(final nLoads = 1, QNom = zeros(nZones));

  equation
  wattsLawPlug.P = {0};
  wattsLawPlug.Q = {0};
  for i in 1:nZones loop
    heatPortCon[i].Q_flow = 0;
    heatPortRad[i].Q_flow = 0;
    heatPortEmb[i].Q_flow = 0;
  end for;

  end None;

  model Deadband "BESTEST deadband heating system"
    extends IDEAS.Interfaces.HeatingSystem(final nLoads=1, QNom = zeros(nZones));

    parameter Modelica.SIunits.Temperature Theat = 293.15
      "Heating on below 20°C";
    parameter Modelica.SIunits.Temperature Tcool = 300.15
      "Cooling on above 27°C";

    Electric.BaseClasses.WattsLaw wattsLaw
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  equation
    connect(wattsLaw.vi, pinLoad) annotation (Line(
        points={{80,0},{100,0}},
        color={85,170,255},
        smooth=Smooth.None));
  for i in 1:nZones loop
    if Theat > TSensor[i] then
      heatPortCon[i].Q_flow =  -10*C[i]*(Theat -  TSensor[i]);
    elseif Tcool < TSensor[i] then
      heatPortCon[i].Q_flow =  -10*C[i]*(Tcool - TSensor[i]);
    else
      heatPortCon[i].Q_flow =  0;
    end if;
    heatPortRad[i].Q_flow =  0;
    heatPortEmb[i].Q_flow =  0;
  end for;
  wattsLaw.P = -1*sum(heatPortCon.Q_flow);
  wattsLaw.Q = 0;
  end Deadband;

  model ThermostatSetback "BESTEST thermostat setback heating system"

    extends IDEAS.Interfaces.HeatingSystem(final nLoads = 1, QNom = zeros(nZones));

    IDEAS.Occupants.Components.Schedule occ(occupancy=3600*{7, 23},firstEntryOccupied=true)
      "Occupancy shedule";
    parameter Modelica.SIunits.Temperature Tbase = 293.15
      "Heating on below 10°C if non-occupied";
    parameter Modelica.SIunits.Temperature Theat = 293.15
      "Heating on below 20°C if occupied";
    parameter Modelica.SIunits.Temperature Tcool = 300.15
      "Cooling on above 27°C always";

    Electric.BaseClasses.WattsLaw wattsLaw
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  equation
    connect(wattsLaw.vi, pinLoad) annotation (Line(
        points={{80,0},{100,0}},
        color={85,170,255},
        smooth=Smooth.None));

  for i in 1:nZones loop
    if (Tbase > TSensor[i]) and not occ.occupied then
      heatPortCon[i].Q_flow =  max(-10*C[i]*(Tbase -  TSensor[i]),-1e7);
    elseif (Theat > TSensor[i]) and occ.occupied then
      heatPortCon[i].Q_flow =  max(-10*C[i]*(Theat -  TSensor[i]),-1e7);
    elseif (Tcool < TSensor[i]) then
      heatPortCon[i].Q_flow =  min(-10*C[i]*(Tcool - TSensor[i]),1e7);
    else
      heatPortCon[i].Q_flow =  0;
    end if;
    heatPortRad[i].Q_flow =  0;
    heatPortEmb[i].Q_flow =  0;
  end for;

  wattsLaw.P = -1*sum(heatPortCon.Q_flow);
  wattsLaw.Q = 0
    annotation (Diagram(graphics));
  end ThermostatSetback;

end HeatingSystem;
