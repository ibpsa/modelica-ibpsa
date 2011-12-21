within IDEAS.Electric.Photovoltaic.Components.ForInputFiles;
model PvSystemGeneralPQ "PV system with separate shut-down controller"

parameter Real amount=30;
parameter Real inc = 34 "inclination";
parameter Real azi = 0 "azimuth";

parameter Integer prod=1;

parameter Modelica.SIunits.Time timeOff=300;
parameter Modelica.SIunits.Voltage VMax=248
    "Max grid voltage for operation of the PV system";

parameter Integer numPha=1;

IDEAS.Electric.BaseClasses.CNegPin
                               pin[numPha] annotation (Placement(transformation(extent={{92,30},{112,50}},rotation=0)));

  IDEAS.Electric.Photovoltaic.Components.ForInputFiles.SimpleDCAC_effP invertor(NPanelen=
        amount)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  IDEAS.Electric.Photovoltaic.Components.PvVoltageCtrlGeneral pvVoltageCtrl(
    VMax=VMax,
    timeOff=timeOff,
    numPha=numPha)
    annotation (Placement(transformation(extent={{26,20},{46,40}})));
  outer IDEAS.Electric.Photovoltaic.Components.ForInputFiles.Read10minPV PV1
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
  flow Modelica.Blocks.Interfaces.RealOutput PQ[2]
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
equation
invertor.P_dc=PV1.P_paneel;
  connect(pin, pvVoltageCtrl.pin) annotation (Line(
      points={{102,40},{78,40},{78,12},{42,12},{42,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(invertor.P, pvVoltageCtrl.PInit) annotation (Line(
      points={{-19.4,34},{4,34},{4,36},{26,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(invertor.Q, pvVoltageCtrl.QInit) annotation (Line(
      points={{-19.4,26},{4,26},{4,32},{26,32}},
      color={0,0,127},
      smooth=Smooth.None));
  pvVoltageCtrl.PFinal=-PQ[1] annotation (Line(
      points={{46,36},{70,36},{70,-5},{106,-5}},
      color={0,0,127},
      smooth=Smooth.None));
pvVoltageCtrl.QFinal=-PQ[2] annotation (Line(
      points={{46,32},{66,32},{66,5},{106,5}},
      color={0,0,127},
      smooth=Smooth.None));
      annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                         graphics={
        Polygon(
          points={{-80,60},{-60,80},{60,80},{80,60},{80,-60},{60,-80},{-60,-80},
              {-80,-60},{-80,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,80},{-40,-80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{40,80},{40,-80}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-100,98},{100,-102}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="#")}),        Diagram(graphics));
end PvSystemGeneralPQ;
