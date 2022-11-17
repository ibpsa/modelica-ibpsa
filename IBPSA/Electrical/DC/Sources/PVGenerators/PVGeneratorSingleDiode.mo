within IBPSA.Electrical.DC.Sources.PVGenerators;
model PVGeneratorSingleDiode
  "Photovoltaic module(s) model based on single diode approach"
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
      HGloTil0=HGloTil0,
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
  parameter Real HGloTil0=1000 "Total solar radiation on the horizontal surface 
  under standard conditions" annotation(Dialog(tab="Site specifications"));

protected
  parameter Real tau_0=exp(-(partialPVOptical.glaExtCoe*partialPVOptical.glaThi))
      *(1 - ((partialPVOptical.refInd - 1)/(partialPVOptical.refInd + 1))^2)
    "Transmittance at standard conditions (incAng=refAng=0)";

equation
  connect(vWinSpe, partialPVThermal.winVel) annotation (Line(points={{-109,25},{
          -46,25},{-46,13},{-39.4,13}},
                                    color={0,0,127}));
  connect(partialPVElectrical.eta, partialPVThermal.eta) annotation (Line(
        points={{-23.4,-53},{6,-53},{6,-24},{-58,-24},{-58,8.2},{-39.4,8.2}},
        color={0,0,127}));
  connect(partialPVThermal.TCel, partialPVElectrical.TCel) annotation (Line(
        points={{-23.3,10},{-10,10},{-10,-16},{-58,-16},{-58,-47},{-37.2,-47}},
                        color={0,0,127}));
  connect(partialPVElectrical.P, P) annotation (Line(points={{-23.4,-47},{52,-47},
          {52,0},{110,0}}, color={0,0,127}));
  connect(partialPVOptical.absRadRat, partialPVElectrical.absRadRat)
    annotation (Line(points={{-23.4,70},{18,70},{18,-34},{-64,-34},{-64,-51.8},{
          -37.2,-51.8}},  color={0,0,127}));
  connect(HGloHor, partialPVOptical.HGloHor) annotation (Line(points={{-109,69},
          {-42,69},{-42,70},{-37.2,70}}, color={0,0,127}));
  connect(HGloTil, partialPVElectrical.radTil) annotation (Line(points={{-109,91},
          {-84,91},{-84,-54.2},{-37.2,-54.2}}, color={0,0,127}));
  connect(TDryBul, partialPVThermal.TDryBul) annotation (Line(points={{-109,47},
          {-64,47},{-64,15.4},{-39.4,15.4}}, color={0,0,127}));
  connect(HGloTil, partialPVThermal.HGloTil) annotation (Line(points={{-109,91},
          {-78,91},{-78,6},{-58,6},{-58,5.8},{-39.4,5.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
                Documentation(info="<html>
<p>
This is a photovoltaic generator model based on a single diode approach with 
replaceable thermal models accounting for different mountings.
</p>
<p>
For a definition of the parameters, see the
<a href=\"modelica://IBPSA.BoundaryConditions.UsersGuide\">
IBPSA.BoundaryConditions.UsersGuide</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVGeneratorSingleDiode;
