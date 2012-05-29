within IDEAS.Thermal.Components.Emission;
model Radiator "Simple 1-node radiator model according to EN 442"

  import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
  extends Thermal.Components.Emission.Auxiliaries.Partial_Emission(final
      emissionType=EmissionType.Radiators);

  /* The capacity of the radiator is based on a calculation for 1 
  type of radiator from Radson.  The headlines of the calculation:
  - we suppose the normative 75/65/20 design conditions (this is a crucial parameter!!!)
  - we take a type 22 radiator from the Radson Compact or Integra series
  - we take a length of 1.05m, height 0.6m
  - we get a power of 1924W, a water content of 7.24 l and a steel weight of 35.52 kg
  - water content: 0.0038 l/W 
  - steel weight: 0.018 kg/W
  Resulting capacity: 24.6 J/K per Watt of nominal power
  
  Redo this calculation for other design conditions
  Example: for 45/35/20 we would get 3.37 times less power, 
  so we have to increase the volume and weight per W by 3.37
  */

  parameter Modelica.SIunits.Temperature TInNom=75 + 273.15
    "Nominal inlet temperature";
  parameter Modelica.SIunits.Temperature TOutNom=65 + 273.15
    "Nominal outlet temperature";
  parameter Modelica.SIunits.Temperature TZoneNom=20 + 273.15
    "Nominal room temperature";

  parameter Modelica.SIunits.Power QNom=1000
    "Nominal thermal power at the specified conditions";
  parameter Real fraRad = 0.35 "Fraction of radiation at Nominal power";
  parameter Real n = 1.3 "Radiator coefficient according to EN 442-2";

  parameter Real powerFactor = 1 "Size increase compared to design at 75/65/20";
    // For reference: 45/35/20 is 3.37; 50/40/20 is 2.5:
    // Source: http://www.radson.com/be/producten/paneelradiatoren/radson-compact.htm, accessed on 15/06/2011
  parameter Modelica.SIunits.Mass mMedium(start=1)=0.0038*QNom*powerFactor
    "Mass of medium (water) in the radiator";
  parameter Modelica.SIunits.Mass mDry(start=1)=0.018*QNom*powerFactor
    "Mass of dry material (steel/aluminium) in the radiator";
  // cpDry for steel: based on carbon steel, Polytechnisch zakboekje, E1/8
  parameter Modelica.SIunits.SpecificHeatCapacity cpDry=480
    "Specific heat capacity of the dry material, default is for steel";

  final parameter Real UA = QNom / ( (TInNom + TOutNom)/2 - TZoneNom)^n;

  Modelica.SIunits.HeatFlowRate QTotal(start=0)
    "Total heat emission of the radiator";
  Modelica.SIunits.TemperatureDifference dTRadRoo;

protected
  parameter Modelica.SIunits.MassFlowRate mFlowNom=QNom/medium.cp/(TInNom -
      TOutNom) "nominal mass flowrate";

equation
  dTRadRoo = max(0, TMean - heatPortCon.T);
  // mass balance
  flowPort_a.m_flow + flowPort_b.m_flow = 0;

  // no pressure drop
  flowPort_a.p = flowPort_b.p;

  // fixing temperatures
algorithm
  if noEvent(flowPort_a.m_flow > mFlowNom/10) then
    TIn := flowPort_a.h/medium.cp;
    TOut := max(heatPortCon.T, 2*TMean - TIn);
  else
    TIn := TMean;
    TOut := TMean;
  end if;

equation
  // radiator equation
  QTotal = - UA * (dTRadRoo)^n; // negative for heat emission!
  heatPortCon.Q_flow = QTotal * (1-fraRad);
  heatPortRad.Q_flow = QTotal * fraRad;

  // energy balance
  // the mass is lumped to TMean!  TOut can be DIFFERENT from TMean (when there is a flowrate)
  flowPort_a.H_flow + flowPort_b.H_flow + QTotal = (mMedium * medium.cp + mDry * cpDry) * der(TMean);

  // massflow a->b mixing rule at a, energy flow at b defined by medium's temperature
  // massflow b->a mixing rule at b, energy flow at a defined by medium's temperature
  flowPort_a.H_flow = semiLinear(flowPort_a.m_flow,flowPort_a.h,TOut * medium.cp);
  flowPort_b.H_flow = semiLinear(flowPort_b.m_flow,flowPort_b.h,TOut * medium.cp);
annotation (Documentation(info="<HTML>
Partial model with two flowPorts.<br>
Possible heat exchange with the ambient is defined by Q_flow; setting this = 0 means no energy exchange.<br>
Setting parameter m (mass of medium within pipe) to zero
leads to neglection of temperature transient cv*m*der(T).<br>
Mixing rule is applied.<br>
Parameter 0 &lt; tapT &lt; 1 defines temperature of heatPort between medium's inlet and outlet temperature.
</HTML>"), Icon(graphics={
        Rectangle(
          extent={{-92,46},{94,-50}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,38},{-60,-42}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-40,38},{-40,-42}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{0,38},{0,-42}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-20,38},{-20,-42}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{40,38},{40,-42}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{20,38},{20,-42}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{60,38},{60,-42}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None)}));
end Radiator;
