within IDEAS.Templates.Heating;
model Heating_Radiators
  "Basic hydraulic heating (with heating curve) with radiator. No TES, no DHW"
  extends IDEAS.Templates.Heating.Interfaces.Partial_HydraulicHeating(
    final isHea=true,
    final isCoo=false,
    nConvPorts=nZones,
    nRadPorts=nZones,
    nTemSen=nZones,
    nEmbPorts=0,
    nLoads=1,
    nZones=1,
    minSup=true,
    TSupMin=273.15 + 30,
    redeclare IDEAS.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 emission[nZones](
      each T_a_nominal = TSupNom,
      each T_b_nominal = TSupNom - dTSupRetNom,
      TAir_nominal= TRoomNom,
      Q_flow_nominal= QNom,
      redeclare each package Medium = Medium,
      each allowFlowReversal=false,
      each massDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
      each from_dp=true),
    pumpRad(each filteredSpeed=true),
    ctrl_Heating(dTHeaterSet=2));
equation
  QHeaSys = -sum(emission.heatPortCon.Q_flow) - sum(emission.heatPortRad.Q_flow);
  P[1] = heater.PEl + sum(pumpRad.P);
  Q[1] = 0;
  connect(emission.heatPortCon, heatPortCon) annotation (Line(
      points={{132,41.2},{132,70},{142,70},{142,96},{-178,96},{-178,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emission.heatPortRad, heatPortRad) annotation (Line(
      points={{138,41.2},{138,72},{148,72},{148,100},{-180,100},{-180,-20},{-200,
          -20}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{
            200,100}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,
            100}})),
    Documentation(info="<html>
<p>
This example model illustrates how heating systems may be used.
Its implementation may not reflect best modelling practices.
</p>
</html>", revisions="<html>
<ul>
<li>
January 23, 2017 by Filip Jorissen and Glenn Reynders:<br/>
Revised implementation and documentation.
</li>
<li>2013 June, Roel De Coninck: first version</li>
</ul>
</html>"));
end Heating_Radiators;
