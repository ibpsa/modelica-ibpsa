within IBPSA.Electrical.DC.Sources;
package PVSystem

  model PVSystemSingleDiode "Photovoltaic module model based on single diode approach"
    extends IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.PartialPVSystem(
      final ageing=ageing,
      redeclare
        IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.PVOpticalHorFixedAziTil
        partialPVOptical(
        final lat=lat,
        final lon=lon,
        final alt=alt,
        final til=til,
        final azi=azi,
        final timZon=timZon,
        final groRef=groRef,
        final radTil0=radTil0,
        final glaExtCoe=glaExtCoe,
        final glaThi=glaThi,
        final refInd=refInd,
        final tau_0=tau_0),
      final use_MPP_in=false,
      final use_Til_in=false,
      final til=til,
      final use_Azi_in=false,
      final azi=azi,
      final use_Sha_in=false,
      final use_age_in=false,
      final use_heat_port=false);

    parameter Modelica.Units.SI.Angle til "Fixed tilt angle of the PV module" annotation(Dialog(tab="Module mounting and specifications"));
    parameter Modelica.Units.SI.Angle azi "Fixed azimuth angle of the PV module" annotation(Dialog(tab="Module mounting and specifications"));

    parameter Real groRef "Ground refelctance" annotation(Dialog(tab="Module mounting and specifications"));
    parameter Real glaExtCoe=4 "Glazing extinction coefficient for glass" annotation(Dialog(tab="Module mounting and specifications"));
    parameter Real glaThi=0.002
      "Glazing thickness for most PV cell panels it is 0.002 m" annotation(Dialog(tab="Module mounting and specifications"));
    parameter Real refInd=1.526
      "Effective index of refraction of the cell cover (glass)" annotation(Dialog(tab="Module mounting and specifications"));
    parameter Real lat "Latitude" annotation(Dialog(tab="Site specifications"));
    parameter Real lon "Longitude" annotation(Dialog(tab="Site specifications"));
    parameter Real alt "Site altitude in Meters, default= 1" annotation(Dialog(tab="Site specifications"));
    parameter Real timZon "Time zone in seconds relative to GMT" annotation(Dialog(tab="Site specifications"));
    parameter Real radTil0=1000 "Total solar radiation on the horizontal surface 
  under standard conditions"   annotation(Dialog(tab="Site specifications"));

  protected
    parameter Real tau_0=exp(-(partialPVOptical.glaExtCoe*partialPVOptical.glaThi))
        *(1 - ((partialPVOptical.refInd - 1)/(partialPVOptical.refInd + 1))^2)
      "Transmittance at standard conditions (incAng=refAng=0)";
  equation
    connect(HGloHor, partialPVOptical.HGloHor) annotation (Line(points={{-99,91},
            {-42,91},{-42,70},{-36.96,70}},color={0,0,127}));
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
