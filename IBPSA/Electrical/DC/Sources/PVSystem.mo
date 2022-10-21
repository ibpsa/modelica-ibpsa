within IBPSA.Electrical.DC.Sources;
package PVSystem

  model PVSystemSingleDiode "Photovoltaic module model based on single diode approach"
    extends IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.PartialPVSystem(
      final ageing=1.0,
      replaceable IBPSA.Electrical.DataBase.PV1DiodeBaseDataDefinition data,
      redeclare
        IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.PVOpticalHorFixedAziTil
        partialPVOptical(
        final lat=lat,
        final lon=lon,
        final alt=alt,
        til=til,
        azi=azi,
        final timZon=timZon,
        final groRef=groRef,
        final radTil0=radTil0,
        final glaExtCoe=glaExtCoe,
        final glaThi=glaThi,
        final refInd=refInd,
        final tau_0=tau_0),
      redeclare
        IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.PVElectrical1DiodeMPP
        partialPVElectrical(
        redeclare IBPSA.Electrical.DataBase.PV1DiodeBaseDataDefinition data=data,
        n_mod=n_mod),
      replaceable IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVThermalEmp partialPVThermal(
      redeclare IBPSA.Electrical.DataBase.PV1DiodeBaseDataDefinition data=data),
      final use_MPP_in=false,
      final use_Til_in=false,
      final use_Azi_in=false,
      final use_Sha_in=false,
      final use_age_in=false,
      final use_heat_port=false);

   parameter Integer n_mod(min=1) "Amount of modules per system";

    parameter Modelica.Units.SI.Angle til "Surface's tilt angle (0:flat)" annotation(Dialog(tab="Module mounting and specifications"));
    parameter Modelica.Units.SI.Angle azi "Surface's azimut angle (0:South)" annotation(Dialog(tab="Module mounting and specifications"));

    parameter Real groRef(unit="1")=0.2         "Ground refelctance" annotation(Dialog(tab="Module mounting and specifications"));
    parameter Real glaExtCoe=4 "Glazing extinction coefficient for glass" annotation(Dialog(tab="Module mounting and specifications"));
    parameter Real glaThi=0.002
      "Glazing thickness for most PV cell panels it is 0.002 m" annotation(Dialog(tab="Module mounting and specifications"));
    parameter Real refInd=1.526
      "Effective index of refraction of the cell cover (glass)" annotation(Dialog(tab="Module mounting and specifications"));
    parameter Modelica.Units.SI.Angle lat "Latitude" annotation(Dialog(tab="Site specifications"));
    parameter Modelica.Units.SI.Angle lon "Longitude" annotation(Dialog(tab="Site specifications"));
    parameter Modelica.Units.SI.Length alt "Site altitude in Meters, default= 1" annotation(Dialog(tab="Site specifications"));
    parameter Modelica.Units.SI.Time timZon(displayUnit="h")
    "Time zone in seconds relative to GMT" annotation(Dialog(tab="Site specifications"));
    parameter Real radTil0=1000 "Total solar radiation on the horizontal surface 
  under standard conditions"   annotation(Dialog(tab="Site specifications"));


  protected
    parameter Real tau_0=exp(-(partialPVOptical.glaExtCoe*partialPVOptical.glaThi))
        *(1 - ((partialPVOptical.refInd - 1)/(partialPVOptical.refInd + 1))^2)
      "Transmittance at standard conditions (incAng=refAng=0)";


  equation
    connect(HGloHor, partialPVOptical.HGloHor) annotation (Line(points={{-99,91},{
            -42,91},{-42,70},{-36.96,70}}, color={0,0,127}));
    connect(TDryBul, partialPVThermal.TDryBul) annotation (Line(points={{-99,63},{
            -46,63},{-46,16},{-42,16},{-42,15.4},{-39.4,15.4}}, color={0,0,127}));
    connect(vWinSpe, partialPVThermal.winVel) annotation (Line(points={{-99,37},{-46,
            37},{-46,13},{-39.4,13}}, color={0,0,127}));
    connect(partialPVElectrical.eta, partialPVThermal.eta) annotation (Line(
          points={{-23.4,-53},{6,-53},{6,-24},{-58,-24},{-58,9.4},{-39.4,9.4}},
          color={0,0,127}));
    connect(partialPVOptical.radTil, partialPVThermal.radTil) annotation (Line(
          points={{-23.4,67},{-10,67},{-10,28},{-58,28},{-58,5.8},{-39.54,5.8}},
          color={0,0,127}));
    connect(partialPVThermal.TCel, partialPVElectrical.TCel) annotation (Line(
          points={{-23.3,10},{-18,10},{-18,8},{-10,8},{-10,-16},{-58,-16},{-58,-47},
            {-37.2,-47}}, color={0,0,127}));
    connect(partialPVElectrical.P, P) annotation (Line(points={{-23.4,-47},{52,-47},
            {52,0},{104,0}}, color={0,0,127}));
    connect(partialPVOptical.absRadRat, partialPVElectrical.absRadRat)
      annotation (Line(points={{-23.4,73.12},{18,73.12},{18,-34},{-64,-34},{-64,-51.8},
            {-37.2,-51.8}}, color={0,0,127}));
    connect(partialPVOptical.radTil, partialPVElectrical.radTil) annotation (Line(
          points={{-23.4,67},{6,67},{6,-20},{-72,-20},{-72,-54.2},{-37.2,-54.2}},
          color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PVSystemSingleDiode;
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),      Polygon(points={{-80,-80},{-40,80},{80,80},{40,-80},
              {-80,-80}}, lineColor={0,0,0}),
        Line(points={{-60,-76},{-20,76}}, color={0,0,0}),
        Line(points={{-34,-76},{6,76}}, color={0,0,0}),
        Line(points={{-8,-76},{32,76}}, color={0,0,0}),
        Line(points={{16,-76},{56,76}}, color={0,0,0}),
        Line(points={{-38,60},{68,60}}, color={0,0,0}),
        Line(points={{-44,40},{62,40}}, color={0,0,0}),
        Line(points={{-48,20},{58,20}}, color={0,0,0}),
        Line(points={{-54,0},{52,0}}, color={0,0,0}),
        Line(points={{-60,-20},{46,-20}}, color={0,0,0}),
        Line(points={{-64,-40},{42,-40}}, color={0,0,0}),
        Line(points={{-70,-60},{36,-60}}, color={0,0,0})}));
end PVSystem;
