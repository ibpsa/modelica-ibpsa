within Annex60.Experimental.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase6 "VDI 6007 Test Case 6 model"
  extends Modelica.Icons.Example;

  ReducedOrderZones.ThermalZoneTwoElements thermalZoneTwoElements(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    alphaExt=2.7,
    alphaWin=2.7,
    gWin=1,
    nExt=1,
    nInt=1,
    ratioWinConRad=0,
    AInt=75.5,
    alphaInt=2.24,
    RWin=0.00000001,
    alphaRad=5,
    RExt={0.00436791293674},
    RExtRem=0.03895919557,
    CExt={1600848.94},
    RInt={0.000595693407511},
    CInt={14836354.6282},
    VAir=0,
    nOrientations=1,
    T_start=295.15,
    AWin={0},
    ATransparent={0},
    AExt={10.5}) "Thermal zone"
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature(T=295.15)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{8,-6},{20,6}})));
  Modelica.Thermal.HeatTransfer.Components.Convection thermalConductorWall
    "Outdoor convective heat transfer"
    annotation (Placement(transformation(extent={{36,6},{26,-4}})));
  Modelica.Blocks.Sources.CombiTimeTable internalGains(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[0,0; 3600,0; 7200,0; 10800,0; 14400,0; 18000,0; 21600,0; 21600,1000;
        25200,1000; 28800,1000; 32400,1000; 36000,1000; 39600,1000; 43200,1000;
        46800,1000; 50400,1000; 54000,1000; 57600,1000; 61200,1000; 64800,1000;
        64800,0; 68400,0; 72000,0; 75600,0; 79200,0; 82800,0; 86400,0],
    columns={2}) "Table with internal gains"
    annotation (Placement(transformation(extent={{6,-82},{22,-66}})));
  Modelica.Blocks.Sources.CombiTimeTable reference(
    tableOnFile=false,
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    table=[0,0; 3600,0; 7200,0; 10800,0; 14400,0; 18000,0; 21600,-764; 25200,-696;
        28800,-632; 32400,-570; 36000,-511; 39600,-455; 43200,-402; 46800,-351;
        50400,-302; 54000,-255; 57600,-210; 61200,-167; 64800,638; 68400,610;
        72000,583; 75600,557; 79200,533; 82800,511; 86400,774; 781200,742;
        784800,711; 788400,682; 792000,654; 795600,627; 799200,-163; 802800,-120;
        806400,-79; 810000,-40; 813600,-2; 817200,33; 820800,67; 824400,99;
        828000,130; 831600,159; 835200,187; 838800,214; 842400,1004; 846000,960;
        849600,919; 853200,880; 856800,843; 860400,808; 864000,774; 5101200,742;
        5104800,711; 5108400,682; 5112000,654; 5115600,627; 5119200,-163;
        5122800,-120; 5126400,-78; 5130000,-39; 5133600,-2; 5137200,33; 5140800,
        67; 5144400,99; 5148000,130; 5151600,159; 5155200,187; 5158800,214;
        5162400,1004; 5166000,960; 5169600,919; 5173200,880; 5176800,843;
        5180400,808]) "Reference results"
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesRad
    "Radiative heat flow machines"
    annotation (Placement(transformation(extent={{48,-84},{68,-64}})));
  Modelica.Blocks.Sources.Constant alphaWall(k=25*10.5)
    "Outdoor coefficient of heat transfer for walls"
    annotation (Placement(
    transformation(
    extent={{-4,-4},{4,4}},
    rotation=90,
    origin={30,-18})));
  Modelica.Blocks.Sources.Constant const(k=0) "Solar radiation"
    annotation (Placement(transformation(extent={{20,26},{30,36}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    "Sensor for ideal heater/cooler"
    annotation (Placement(transformation(extent={{90,-40},{78,-28}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1
    "Prescribed temperature for ideal heater/cooler"
    annotation (Placement(transformation(extent={{56,-40},{68,-28}})));
  Modelica.Blocks.Sources.CombiTimeTable setTemp(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    table=[0,295.1; 3600,295.1; 7200,295.1; 10800,295.1; 14400,295.1; 18000,
        295.1; 21600,295.1; 25200,300.1; 28800,300.1; 32400,300.1; 36000,300.1;
        39600,300.1; 43200,300.1; 46800,300.1; 50400,300.1; 54000,300.1; 57600,
        300.1; 61200,300.1; 64800,300.1; 68400,295.1; 72000,295.1; 75600,295.1;
        79200,295.1; 82800,295.1; 86400,295.1],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Set temperature for ideal heater/cooler"
    annotation (Placement(transformation(extent={{20,-50},{36,-34}})));
equation
  connect(thermalConductorWall.fluid, prescribedTemperature.port)
    annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
  connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
    annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},   color={191,0,0}));
  connect(alphaWall.y, thermalConductorWall.Gc)
    annotation (Line(points={{30,-13.6},{31,-13.6},{31,-4}}, color={0,0,127}));
  connect(internalGains.y[1], machinesRad.Q_flow)
    annotation (Line(points={{22.8,-74},{36,-74},{48,-74}}, color={0,0,127}));
  connect(machinesRad.port, thermalZoneTwoElements.intGainsRad)
    annotation (
    Line(points={{68,-74},{84,-74},{98,-74},{98,24},{92.2,24}},
                                                              color={191,0,0}));
  connect(prescribedTemperature1.port, heatFlowSensor.port_b)
    annotation (Line(points={{68,-34},{73,-34},{78,-34}}, color={191,0,0}));
  connect(setTemp.y[1], prescribedTemperature1.T)
    annotation (Line(points={{
    36.8,-42},{48,-42},{48,-34},{54.8,-34}}, color={0,0,127}));
  connect(heatFlowSensor.port_a, thermalZoneTwoElements.intGainsConv)
    annotation (Line(points={{90,-34},{94,-34},{94,20},{92,20}},     color={191,
    0,0}));
  connect(const.y, thermalZoneTwoElements.solRad[1])
    annotation (Line(points={{30.5,31},{37.25,31},{43,31}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
  -100},{100,100}})), Documentation(info="<html>
  <p>Test Case 6 of the VDI 6007 Part 1: Calculation of heat load excited with a
  given radiative heat source and a setpoint profile for room version S. Is
  based on Test Case 2.</p>
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
