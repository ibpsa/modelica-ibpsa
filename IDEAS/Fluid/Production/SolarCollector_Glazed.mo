within IDEAS.Fluid.Production;
model SolarCollector_Glazed
  "Glazed collector, originally from master thesis Mark Gutschoven, 2010-2011"

  // not cleaned up nor validated

  extends Modelica.Thermal.FluidHeatFlow.Interfaces.Partials.TwoPort(m=medium.rho
        *Vol);
  IDEAS.Climate.Meteo.Solar.BaseClasses.AngleHour angleHour;
  /*
Model_Mark.Meteo.Solar.RadiationSolar radSol(
    TeAv=265,
    solDirPer=sim.solDirPer,
    solDirHor=sim.solDirHor,
    solDifHor=sim.solDifHor,
    inc=30,
    azi=0,
    A=1);
*/
  parameter Real pi=Modelica.Constants.pi;
  //parameter Real inc(start=30);

  parameter Modelica.SIunits.Volume Vol=AColTot*1.3*1e-3;
  parameter Modelica.SIunits.Area ACol "Surface of a single collector";
  parameter Integer nCol "Number of collectors in series";
  final parameter Modelica.SIunits.Area AColTot=ACol*nCol
    "Total effective surface";

  parameter Modelica.SIunits.Length h_g(start=-2)
    "Geodetic height (heigth difference from flowPort_a to flowPort_b)";

  //pressure drop coefficietns
  parameter Real a=2*0.0008436127;
  parameter Real b=2*0.1510363177;
  //2 vanwege in serie
  parameter Real correctie=11.1/16.5;
  //drukval collector is ongeveer gelijk per l/h.m2

  Modelica.SIunits.Irradiance Ibeam=radSol.solDir;
  Modelica.SIunits.Irradiance Idiff=radSol.solDif;
  Real cosXi=cos(radSol.angInc);
  Real angle_zenit=radSol.angZen;

  // gemeten in dezelfde hoek als collector
  Modelica.SIunits.Temperature T_amb=sim.Te;
  Modelica.SIunits.Temperature T_coll=(T_a + T_b)/2;
  Modelica.SIunits.Temp_K T_sky=(T_amb^1.5)*0.0552;

  Modelica.SIunits.Efficiency eta;
  // parameters from Viesmann vitosol 200F (http://www.viessmann.be/etc/medialib/internet-be/Nederlandstalige_media/Tech_Doc/Zon/Vitosol_300-F.Par.8340.File.File.tmp/PLA_Vitosol_5818440_B-fl_5-2010.pdf p 13)
  parameter Modelica.SIunits.Efficiency eta_0=0.793;
  parameter Real k1=4.04;
  parameter Real k2=0.0182;

  parameter Modelica.SIunits.TransmissionCoefficient ta=0.95*0.9
    "transmission-absorption coefficient";

  parameter Real b_IAM=-0.09;
  // based on Kta 50deg = 0.95
  Modelica.SIunits.TransmissionCoefficient Kta=(1 + b_IAM*(1/cosXi - 1));
  // Duffie Beckman p263
  Modelica.SIunits.TransmissionCoefficient IAM=Kta
    "incidence angle modifier Kta=0.95 at 50deg";

  Real Ul;
  Real Q_loss;
  Real QInNet;
  Modelica.SIunits.Power QInBru=AColTot*(Ibeam + Idiff);
  Modelica.SIunits.Power QNet=-(flowPort_b.H_flow + flowPort_a.H_flow)
    "Net power delivered by the collector";
  parameter Modelica.SIunits.TransmissionCoefficient GSC=0;
  Real Q_lossRad;

  parameter Real eps=0.03;

  Modelica.SIunits.Irradiance S;

  Real feq=if noEvent((V_flow/nCol*correctie) > 0.00001) then (1e8)*V_door^(-0.376)
       else 1e8*0.00001^(-0.376);
  Real V_door=V_flow/nCol*correctie;
  Real dpEq=2*(feq*medium.rho*(V_flow/nCol*correctie)^2/2*(nue/nue_ref)^0.25);

  parameter Real nue_ref=1.004e-6;
  Real nue=(5.8127*exp(-0.03*(T - 273)))*1e-6;
  Modelica.SIunits.Pressure dp_ref;

  Real I=Idiff + Ibeam;
  Modelica.Blocks.Interfaces.RealOutput TCol
    annotation (Placement(transformation(extent={{94,-70},{114,-50}})));
  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-86,60},{-66,80}})));
  IDEAS.Climate.Meteo.Solar.RadSol radSol(
    inc=30*pi/180,
    azi=0,
    A=1) annotation (Placement(transformation(extent={{-40,58},{-20,78}})));
equation
  eta = if noEvent(S < 1) then eta_0 - k1*(T_coll - T_amb) - k2*((T_coll -
    T_amb)^2) else eta_0 - k1*(T_coll - T_amb)/S - k2*((T_coll - T_amb)^2)/S;
  // vergelijking die efficientiecurve collector beschrijft

  /*  eta = if (S<1) then 0 else if noEvent(eta_0 - k1*(T_coll - T_amb)/S - k2*((T_coll
     - T_amb)^2)/S) > 0 then eta_0 - k1*(T_coll - T_amb)/S - k2*((T_coll -
    T_amb)^2)/S else 0;
    */

  Ul = (k1 + k2*(T_coll - T_amb));
  //stralingsverliezen verwaarloosd

  dp = dpEq + medium.rho*Modelica.Constants.g_n*h_g;
  // energy exchange with medium
  dp_ref = (a*((V_flow/nCol*correctie)*(10^3*3600))^2 + b*(V_flow/nCol*
    correctie)*(10^3*3600))*1e2;
  Q_loss = Ul*AColTot*(T_coll - T_amb) + (1 - eta_0)*S*AColTot;

  S = Ibeam*IAM*(1 - GSC) + Idiff + 1e-8;
  // IAM= Incident angle modifier and GSC shading coefficient;

  Q_flow = eta_0*(S*AColTot) - Ul*AColTot*(T_coll - T_amb);
  QInNet = S*AColTot;

  Q_lossRad = eps*Modelica.Constants.sigma*AColTot*(T_coll^4 - T_sky^4);
  // not considered
  TCol = T;

  annotation (
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Glazed solar thermal collector. The model needs cleaning and editing according to the IDEAS conventions and quality standards.</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Dynamic model with water content</li>
<li>Incident Angle Modifier (IAM) to correct for reflection on the glazed plane</li>
<li>No radiation heat exchange with environment</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Check all parameters, the interface has not been cleaned up. </li>
</ol></p>
<p><h4>Validation </h4></p>
<p>No validation performed. </p>
<p><h4>Example</h4></p>
<p>A basic solar thermal system is predesigned in <a href=\"modelica://IDEAS.Thermal.Components.Production.SolarThermalSystem_Simple\">this</a> model, and an example of the collector is used in <a href=\"modelica://IDEAS.Thermal.Components.Examples.SolarThermalCollector\">this example</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: basic documentation</li>
<li>2011 December, Roel De Coninck: inclusion in IDEAS</li>
<li>2011 Mark Gutschoven: first version</li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end SolarCollector_Glazed;
