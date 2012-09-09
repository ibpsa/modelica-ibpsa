within IDEAS.Electric.Photovoltaic;
model PvSystemGeneralFromFile "PV system with separate shut-down controller"

parameter Real PNom "Nominal power, in Wp";
parameter Integer prod=1;

parameter Modelica.SIunits.Time timeOff=300;
parameter Modelica.SIunits.Voltage VMax=248
    "Max grid voltage for operation of the PV system";

parameter Integer numPha=1;
output Real PInit;
output Real PFinal;
Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin           pin[numPha] annotation (Placement(transformation(extent={{92,30},{112,50}},rotation=0)));

  IDEAS.Electric.Photovoltaic.Components.ForInputFiles.SimpleDCAC_effP
                  invertor(
                      PNom=PNom)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  IDEAS.Electric.BaseClasses.WattsLaw wattsLaw(numPha=numPha)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  IDEAS.Electric.Photovoltaic.Components.PvVoltageCtrlGeneral
                       pvVoltageCtrl(
                              VMax=VMax,timeOff = timeOff,numPha=numPha)
    annotation (Placement(transformation(extent={{26,20},{46,40}})));
  outer IDEAS.Electric.Photovoltaic.Components.ForInputFiles.PVProfileReader
                    PV1
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation
invertor.P_dc=PV1.P_ratio;
  connect(wattsLaw.vi, pin)
                           annotation (Line(
      points={{80,30},{92,30},{92,40},{102,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pvVoltageCtrl.PFinal, wattsLaw.P)
                                           annotation (Line(
      points={{46,36},{53,36},{53,34},{60,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pvVoltageCtrl.QFinal, wattsLaw.Q)
                                           annotation (Line(
      points={{46,32},{54,32},{54,28},{60,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pin, pvVoltageCtrl.pin) annotation (Line(
      points={{102,40},{92,40},{92,4},{42,4},{42,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(invertor.P, pvVoltageCtrl.PInit) annotation (Line(
      points={{-19.4,34},{4,34},{4,36},{26,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(invertor.Q, pvVoltageCtrl.QInit)
   annotation (Line(
      points={{-19.4,26},{4,26},{4,32},{26,32}},
      color={0,0,127},
      smooth=Smooth.None));
 PInit=pvVoltageCtrl.PInit;
 PFinal=pvVoltageCtrl.PFinal;
  annotation (Icon(Bitmap(extent=[-90,90; 90,-90], name="modelica://IDEAS/Electric/PV.png")), Diagram(
        graphics));
end PvSystemGeneralFromFile;
