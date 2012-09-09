within IDEAS.Occupants;
package Examples

  extends Modelica.Icons.ExamplesPackage;

  model Occupant_FromFiles
    "Occupant model based on external files for a single zone building"
    extends Interfaces.Occupant(nZones=1, nLoads=1);
    parameter Integer profileID = 1
      "Profile ID: the column number in the external files";
    parameter SI.Temperature TSetOcc = 294.15
      "(operative) Room set temperature during occupancy";
    parameter SI.Temperature TSetNoOcc = 288.15
      "(operative) Room set temperature during abscence";
    //Not used in this model, but for compatibility with other occupancy models the floor surface is added
    parameter Modelica.SIunits.Area[nZones] AFloor
      "Floor area of different zones";

    outer Components.UserProfiles userProfiles
      annotation (Placement(transformation(extent={{-58,-38},{22,42}})));
  equation

    heatPortCon[1].Q_flow = -userProfiles.tabQCon.y[profileID];
    heatPortRad[1].Q_flow = -userProfiles.tabQRad.y[profileID];
    TSet[1] = noEvent(if userProfiles.tabPre.y[profileID] >0.5 then TSetOcc else TSetNoOcc);
    wattsLawPlug[1].P = userProfiles.tabP.y[profileID];
    wattsLawPlug[1].Q = userProfiles.tabQ.y[profileID];
    mDHW60C = userProfiles.tabDHW.y[profileID];

  end Occupant_FromFiles;

  model Example_Occupant "Tester for occupant models"

    Occupant_FromFiles occupant_FromFiles(AFloor={100}, profileID=2)
      annotation (Placement(transformation(extent={{-28,-4},{-8,16}})));
    inner Components.UserProfiles userProfiles
      annotation (Placement(transformation(extent={{-98,76},{-78,96}})));
    Interfaces.DummyInHomeGrid dummyInHomeGrid
      annotation (Placement(transformation(extent={{14,-4},{34,16}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource voltageSource(
      f=50,
      V=230,
      phi=0) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={80,-20})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
      annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=1e20)
      annotation (Placement(transformation(extent={{-80,14},{-60,34}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sensors.PowerSensor
      powerSensor
      annotation (Placement(transformation(extent={{46,-4},{66,16}})));
  equation
    connect(occupant_FromFiles.plugLoad[1], dummyInHomeGrid.nodeSingle)
      annotation (Line(
        points={{-8,6},{14,6}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(voltageSource.pin_p,ground. pin) annotation (Line(
        points={{80,-30},{80,-50}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(occupant_FromFiles.heatPortCon[1], heatCapacitor.port) annotation (
        Line(
        points={{-28,8},{-70,14}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(occupant_FromFiles.heatPortRad[1], heatCapacitor.port) annotation (
        Line(
        points={{-28,4},{-70,14}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(dummyInHomeGrid.pinSingle, powerSensor.currentP) annotation (Line(
        points={{34,6},{46,6}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensor.currentN, voltageSource.pin_n) annotation (Line(
        points={{66,6},{80,6},{80,-10}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensor.voltageP, powerSensor.currentP) annotation (Line(
        points={{56,16},{46,16},{46,6}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensor.voltageN, voltageSource.pin_p) annotation (Line(
        points={{56,-4},{56,-30},{80,-30}},
        color={85,170,255},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end Example_Occupant;

  model Occupant_FromFiles_Timetable "Occupant model based on external files"
    extends Interfaces.Occupant(nZones=1, nLoads=1);
    parameter Integer profileID = 1
      "Profile ID: the column number in the external files";
    parameter SI.Temperature TSetOcc = 294.15
      "(operative) Room set temperature during occupancy";
    parameter SI.Temperature TSetNoOcc = 288.15
      "(operative) Room set temperature during abscence";
    //Not used in this model, but for compatibility with other occupancy models the floor surface is added
    parameter Modelica.SIunits.Area[nZones] AFloor
      "Floor area of different zones";

    outer ThermalDSM.UserProfiles_timetableDHW
                                  userProfiles
      annotation (Placement(transformation(extent={{-58,-38},{22,42}})));
  equation

    heatPortCon[1].Q_flow = -userProfiles.tabQCon.y[profileID];
    heatPortRad[1].Q_flow = -userProfiles.tabQRad.y[profileID];
    TSet[1] = TSetNoOcc + (TSetOcc-TSetNoOcc) * userProfiles.tabPre.y[profileID];
    wattsLawPlug[1].P = userProfiles.tabP.y[profileID];
    wattsLawPlug[1].Q = userProfiles.tabQ.y[profileID];
    mDHW60C = userProfiles.tabDHW.y[profileID];

  end Occupant_FromFiles_Timetable;
end Examples;
