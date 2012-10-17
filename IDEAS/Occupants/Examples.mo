within IDEAS.Occupants;
package Examples

  extends Modelica.Icons.ExamplesPackage;


  model Example_Occupant "Tester for occupant models"

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
    inner SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Files.min60 detail,
        redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
      annotation (Placement(transformation(extent={{-94,78},{-74,98}})));
    Standards.ISO13790 iSO13790_1
      annotation (Placement(transformation(extent={{-38,-2},{-18,18}})));
  equation
    connect(voltageSource.pin_p,ground. pin) annotation (Line(
        points={{80,-30},{80,-50}},
        color={85,170,255},
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
    connect(heatCapacitor.port, iSO13790_1.heatPortCon[1]) annotation (Line(
        points={{-70,14},{-54,14},{-54,10},{-38,10}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(heatCapacitor.port, iSO13790_1.heatPortRad[1]) annotation (Line(
        points={{-70,14},{-54,14},{-54,6},{-38,6}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(iSO13790_1.plugLoad[1], dummyInHomeGrid.nodeSingle) annotation (
        Line(
        points={{-18,8},{-2,8},{-2,6},{14,6}},
        color={85,170,255},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end Example_Occupant;

end Examples;
