within Annex60.Experimental.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase6 "VDI 6007 Test Case 6 model"
  extends Modelica.Icons.Example;

  ReducedOrderZones.ThermalZoneTwoElements thermalZoneTwoElements(
    VAir=52.5,
    alphaExt=2.7,
    alphaWin=2.7,
    gWin=1,
    nExt=1,
    nInt=1,
    AWin=0,
    AExt=10.5,
    ATransparent=0,
    ratioWinConRad=0,
    AInt=75.5,
    alphaInt=2.24,
    RWin=0.00000001,
    volAir(X_start={0,0}),
    alphaRad=5,
    RExt={0.00436791293674},
    RExtRem=0.03895919557,
    CExt={1600848.94},
    RInt={0.000595693407511},
    CInt={14836354.6282},
    T_start=295.15)
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
    prescribedTemperature(T=295.15)
    annotation (Placement(transformation(extent={{8,-6},{20,6}})));
  Modelica.Thermal.HeatTransfer.Components.Convection thermalConductorWall
    annotation (Placement(transformation(extent={{36,6},{26,-4}})));
  Modelica.Blocks.Sources.CombiTimeTable internalGains(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[0,0; 3600,0; 7200,0; 10800,0; 14400,0; 18000,0; 21600,0; 21600,1000;
        25200,1000; 28800,1000; 32400,1000; 36000,1000; 39600,1000; 43200,1000;
        46800,1000; 50400,1000; 54000,1000; 57600,1000; 61200,1000; 64800,1000;
        64800,0; 68400,0; 72000,0; 75600,0; 79200,0; 82800,0; 86400,0],
    columns={2})
    annotation (Placement(transformation(extent={{6,-82},{22,-66}})));
  Modelica.Blocks.Sources.CombiTimeTable reference(
    tableOnFile=false,
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    table=[3600,0; 7200,0; 10800,0; 14400,0; 18000,0; 21600,0; 25200,-764;
        28800,-696; 32400,-632; 36000,-570; 39600,-511; 43200,-455; 46800,-402;
        50400,-351; 54000,-302; 57600,-255; 61200,-210; 64800,-167; 68400,638;
        72000,610; 75600,583; 79200,557; 82800,533; 86400,511; 781200,774;
        784800,742; 788400,711; 792000,682; 795600,654; 799200,627; 802800,-163;
        806400,-120; 810000,-79; 813600,-40; 817200,-2; 820800,33; 824400,67;
        828000,99; 831600,130; 835200,159; 838800,187; 842400,214; 846000,1004;
        849600,960; 853200,919; 856800,880; 860400,843; 864000,808; 5101200,774;
        5104800,742; 5108400,711; 5112000,682; 5115600,654; 5119200,627;
        5122800,-163; 5126400,-120; 5130000,-78; 5133600,-39; 5137200,-2;
        5140800,33; 5144400,67; 5148000,99; 5151600,130; 5155200,159; 5158800,
        187; 5162400,214; 5166000,1004; 5169600,960; 5173200,919; 5176800,880;
        5180400,843; 5184000,808])
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesRad
    annotation (Placement(transformation(extent={{48,-84},{68,-64}})));

  Modelica.Blocks.Sources.Constant alphaWall(k=25*10.5)
    "Outdoor coefficient of heat transfer for walls" annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-18})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{20,26},{30,36}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    annotation (Placement(transformation(extent={{90,-40},{78,-28}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature1
    annotation (Placement(transformation(extent={{56,-40},{68,-28}})));
  Modelica.Blocks.Sources.CombiTimeTable setTemp(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    table=[0,295.1; 3600,295.1; 7200,295.1; 10800,295.1; 14400,295.1; 18000,
        295.1; 21600,295.1; 25200,300.1; 28800,300.1; 32400,300.1; 36000,300.1;
        39600,300.1; 43200,300.1; 46800,300.1; 50400,300.1; 54000,300.1; 57600,
        300.1; 61200,300.1; 64800,300.1; 68400,295.1; 72000,295.1; 75600,295.1;
        79200,295.1; 82800,295.1; 86400,295.1])
    annotation (Placement(transformation(extent={{20,-50},{36,-34}})));
equation
  connect(thermalConductorWall.fluid, prescribedTemperature.port)
    annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
  connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
    annotation (Line(points={{45,12.4},{40,12.4},{40,1},{36,1}}, color={191,0,0}));
  connect(alphaWall.y, thermalConductorWall.Gc)
    annotation (Line(points={{30,-13.6},{31,-13.6},{31,-4}}, color={0,0,127}));
  connect(const.y, thermalZoneTwoElements.solRad) annotation (Line(points={{
          30.5,31},{37.25,31},{37.25,30.8},{45,30.8}}, color={0,0,127}));
  connect(internalGains.y[1], machinesRad.Q_flow)
    annotation (Line(points={{22.8,-74},{36,-74},{48,-74}}, color={0,0,127}));
  connect(machinesRad.port, thermalZoneTwoElements.intGainsRad) annotation (
      Line(points={{68,-74},{84,-74},{98,-74},{98,25},{91,25}}, color={191,0,0}));
  connect(prescribedTemperature1.port, heatFlowSensor.port_b)
    annotation (Line(points={{68,-34},{73,-34},{78,-34}}, color={191,0,0}));
  connect(setTemp.y[1], prescribedTemperature1.T) annotation (Line(points={{
          36.8,-42},{48,-42},{48,-34},{54.8,-34}}, color={0,0,127}));
  connect(heatFlowSensor.port_a, thermalZoneTwoElements.intGainsConv)
    annotation (Line(points={{90,-34},{94,-34},{94,19.8},{91,19.8}}, color={191,
          0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<p>Test Case 6 of the VDI 6007 Part 1: Calculation of heat load excited with a 
given radiative heat source and a setpoint profile for room version S. Is based 
on Test Case 2.</p>
<p>Boundary Condtions:</p>
<ul>
<li>constant outdoor air temperature 22 degC</li>
<li>no solar or short-wave radiation on the exterior wall</li>
<li>no solar or short-wave radiation through the windows</li>
<li>no long-wave radiation exchange between exterior wall, windows and ambient 
environment</li>
</ul>
<p>This test case is thought to test heat load calculation without maximum 
heating power.</p>
</html>", revisions="<html>
<ul>
<li>January 11, 2016,&nbsp; by Moritz Lauster:<br>Implemented. </li>
</ul>
</html>"),
__Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Experimental/ThermalZones/ReducedOrder/Validation/VDI6007/TestCase6.mos"
        "Simulate and plot"));
end TestCase6;
