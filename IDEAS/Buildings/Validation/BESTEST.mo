within IDEAS.Buildings.Validation;
model BESTEST
  extends Modelica.Icons.Example;

  inner IDEAS.BoundaryConditions.SimInfoManager sim(
    lat=0.69464104229374,
    lon=-1.8308503853421,
    timZonSta=-7*3600,
    filNam="BESTEST.TMY")
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));


  IDEAS.Buildings.Validation.Cases.Case600 Case600
    annotation (Placement(transformation(extent={{-76,44},{-64,56}})));
  IDEAS.Buildings.Validation.Cases.Case600FF Case600FF
    annotation (Placement(transformation(extent={{-56,44},{-44,56}})));
  IDEAS.Buildings.Validation.Cases.Case610 Case610
    annotation (Placement(transformation(extent={{-36,44},{-24,56}})));
  IDEAS.Buildings.Validation.Cases.Case620 Case620
    annotation (Placement(transformation(extent={{-16,44},{-4,56}})));
  IDEAS.Buildings.Validation.Cases.Case630 Case630
    annotation (Placement(transformation(extent={{4,44},{16,56}})));
  IDEAS.Buildings.Validation.Cases.Case640 Case640
    annotation (Placement(transformation(extent={{24,44},{36,56}})));
  IDEAS.Buildings.Validation.Cases.Case650 Case650
    annotation (Placement(transformation(extent={{44,44},{56,56}})));
  IDEAS.Buildings.Validation.Cases.Case650FF Case650FF
    annotation (Placement(transformation(extent={{64,44},{76,56}})));
  IDEAS.Buildings.Validation.Cases.Case900 Case900
    annotation (Placement(transformation(extent={{-76,4},{-64,16}})));
  IDEAS.Buildings.Validation.Cases.Case900FF Case900FF
    annotation (Placement(transformation(extent={{-56,4},{-44,16}})));
  IDEAS.Buildings.Validation.Cases.Case910 Case910
    annotation (Placement(transformation(extent={{-36,4},{-24,16}})));
  IDEAS.Buildings.Validation.Cases.Case920 Case920
    annotation (Placement(transformation(extent={{-16,4},{-4,16}})));
  IDEAS.Buildings.Validation.Cases.Case930 Case930
    annotation (Placement(transformation(extent={{4,4},{16,16}})));
  IDEAS.Buildings.Validation.Cases.Case940 Case940
    annotation (Placement(transformation(extent={{24,4},{36,16}})));
  IDEAS.Buildings.Validation.Cases.Case950 Case950
    annotation (Placement(transformation(extent={{44,4},{56,16}})));
  IDEAS.Buildings.Validation.Cases.Case950FF Case950FF
    annotation (Placement(transformation(extent={{64,4},{76,16}})));

  constant Real MWh = 1/3600000000;
  constant Real kW = 1/1000;

  // variables for storing results
  Modelica.SIunits.Energy EAnnHea600[6];
  Modelica.SIunits.Energy EAnnCoo600[6];
  discrete Modelica.SIunits.Power QPeaHea600[6];
  discrete Modelica.SIunits.Power QPeaCoo600[6];
  Modelica.SIunits.Energy EAnnHea900[6];
  Modelica.SIunits.Energy EAnnCoo900[6];
  discrete Modelica.SIunits.Power QPeaHea900[6];
  discrete Modelica.SIunits.Power QPeaCoo900[6];


  discrete Modelica.SIunits.Temperature Tmax[4];
  discrete Modelica.SIunits.Temperature Tmin[4];

initial equation
  EAnnHea600 =  zeros(6);
  EAnnCoo600 =  zeros(6);
  EAnnHea900 =  zeros(6);
  EAnnCoo900 =  zeros(6);
  QPeaHea600 =  zeros(6);
  QPeaCoo600 =  zeros(6);
  QPeaHea900 =  zeros(6);
  QPeaCoo900 =  zeros(6);

  Tmax=fill(294.15,4);
  Tmax=fill(294.15,4);

equation
  der(EAnnHea600[1]) = max(0,Case600.PHea)*MWh;
  der(EAnnHea600[2]) = max(0,Case610.PHea)*MWh;
  der(EAnnHea600[3]) = max(0,Case620.PHea)*MWh;
  der(EAnnHea600[4]) = max(0,Case630.PHea)*MWh;
  der(EAnnHea600[5]) = max(0,Case640.PHea)*MWh;
  der(EAnnHea600[6]) = max(0,Case650.PHea)*MWh;
  der(EAnnCoo600[1]) = max(0,-Case600.PCoo)*MWh;
  der(EAnnCoo600[2]) = max(0,-Case610.PCoo)*MWh;
  der(EAnnCoo600[3]) = max(0,-Case620.PCoo)*MWh;
  der(EAnnCoo600[4]) = max(0,-Case630.PCoo)*MWh;
  der(EAnnCoo600[5]) = max(0,-Case640.PCoo)*MWh;
  der(EAnnCoo600[6]) = max(0,-Case650.PCoo)*MWh;
  der(EAnnHea900[1]) = max(0,Case900.PHea)*MWh;
  der(EAnnHea900[2]) = max(0,Case910.PHea)*MWh;
  der(EAnnHea900[3]) = max(0,Case920.PHea)*MWh;
  der(EAnnHea900[4]) = max(0,Case930.PHea)*MWh;
  der(EAnnHea900[5]) = max(0,Case940.PHea)*MWh;
  der(EAnnHea900[6]) = max(0,Case950.PHea)*MWh;
  der(EAnnCoo900[1]) = max(0,-Case900.PCoo)*MWh;
  der(EAnnCoo900[2]) = max(0,-Case910.PCoo)*MWh;
  der(EAnnCoo900[3]) = max(0,-Case920.PCoo)*MWh;
  der(EAnnCoo900[4]) = max(0,-Case930.PCoo)*MWh;
  der(EAnnCoo900[5]) = max(0,-Case940.PCoo)*MWh;
  der(EAnnCoo900[6]) = max(0,-Case950.PCoo)*MWh;

  when sample(600,600) then
    QPeaHea600[1] = max(QPeaHea600[1],Case600.PHea)*kW;
    QPeaHea600[2] = max(QPeaHea600[2],Case610.PHea)*kW;
    QPeaHea600[3] = max(QPeaHea600[3],Case620.PHea)*kW;
    QPeaHea600[4] = max(QPeaHea600[4],Case630.PHea)*kW;
    QPeaHea600[5] = max(QPeaHea600[5],Case640.PHea)*kW;
    QPeaHea600[6] = max(QPeaHea600[6],Case650.PHea)*kW;
    QPeaCoo600[1] =  max(QPeaCoo600[1],-Case600.PCoo)*kW;
    QPeaCoo600[2] =  max(QPeaCoo600[2],-Case610.PCoo)*kW;
    QPeaCoo600[3] =  max(QPeaCoo600[3],-Case620.PCoo)*kW;
    QPeaCoo600[4] =  max(QPeaCoo600[4],-Case630.PCoo)*kW;
    QPeaCoo600[5] =  max(QPeaCoo600[5],-Case640.PCoo)*kW;
    QPeaCoo600[6] =  max(QPeaCoo600[6],-Case650.PCoo)*kW;
    QPeaHea900[1] = max(QPeaHea900[1],Case900.PHea)*kW;
    QPeaHea900[2] = max(QPeaHea900[2],Case910.PHea)*kW;
    QPeaHea900[3] = max(QPeaHea900[3],Case920.PHea)*kW;
    QPeaHea900[4] = max(QPeaHea900[4],Case930.PHea)*kW;
    QPeaHea900[5] = max(QPeaHea900[5],Case940.PHea)*kW;
    QPeaHea900[6] = max(QPeaHea900[6],Case950.PHea)*kW;
    QPeaCoo900[1] =  max(QPeaCoo900[1],-Case900.PCoo)*kW;
    QPeaCoo900[2] =  max(QPeaCoo900[2],-Case910.PCoo)*kW;
    QPeaCoo900[3] =  max(QPeaCoo900[3],-Case920.PCoo)*kW;
    QPeaCoo900[4] =  max(QPeaCoo900[4],-Case930.PCoo)*kW;
    QPeaCoo900[5] =  max(QPeaCoo900[5],-Case940.PCoo)*kW;
    QPeaCoo900[6] =  max(QPeaCoo900[6],-Case950.PCoo)*kW;

    Tmax[1]=max(Tmax[1], Case600FF.building.gF.TSensor);
    Tmax[2]=max(Tmax[2], Case650FF.building.gF.TSensor);
    Tmax[3]=max(Tmax[3], Case900FF.building.gF.TSensor);
    Tmax[4]=max(Tmax[4], Case950FF.building.gF.TSensor);

    Tmin[1]=min(Tmin[1], Case600FF.building.gF.TSensor);
    Tmin[2]=min(Tmin[2], Case650FF.building.gF.TSensor);
    Tmin[3]=min(Tmin[3], Case900FF.building.gF.TSensor);
    Tmin[4]=min(Tmin[4], Case950FF.building.gF.TSensor);
  end when;

  annotation (
    experiment(
      StopTime=3.1536e+07,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_Algorithm="Lsodar"),
    __Dymola_experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-78,68},{-40,60}},
          lineColor={85,0,0},
          fontName="Calibri",
          textStyle={TextStyle.Bold},
          textString="BESTEST 600 Series"),Text(
          extent={{-78,28},{-40,20}},
          lineColor={85,0,0},
          fontName="Calibri",
          textStyle={TextStyle.Bold},
          textString="BESTEST 900 Series")}));
end BESTEST;
