within IBPSA.Fluid.PVTCollectors.Validation.BaseClasses;
model ISO9806SolarGainHGloTil
  "Model calculating solar gains per the ISO9806 standard"
  extends .Modelica.Blocks.Icons.Block;
  extends .IDEAS.Fluid.SolarCollectors.BaseClasses.PartialParameters;

  replaceable package Medium = .Modelica.Media.Interfaces.PartialMedium
    "Medium in the system";

  parameter Real eta0(final unit="1") "Optical efficiency (maximum efficiency)";
  parameter Boolean use_shaCoe_in = false
    "Enables an input connector for shaCoe"
    annotation(Dialog(group="Shading"));
  parameter Real shaCoe(
    min=0.0,
    max=1.0) = 0 "Shading coefficient 0.0: no shading, 1.0: full shading"
    annotation(Dialog(enable = not use_shaCoe_in,group="Shading"));

  .Modelica.Blocks.Interfaces.RealInput shaCoe_in if use_shaCoe_in
    "Time varying input for the shading coefficient"
    annotation(Placement(transformation(extent={{-140,-70},{-100,-30}})));
  .Modelica.Blocks.Interfaces.RealInput HGlob(unit="W/m2", quantity="RadiantEnergyFluenceRate")
    "global tilted irradiance"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  .Modelica.Blocks.Interfaces.RealOutput QSol_flow[nSeg](each final unit="W")
    "Solar heat gain"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  .Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
     each final unit="K",
     each displayUnit="degC",
     each final quantity="ThermodynamicTemperature")
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

protected
  constant .Modelica.Units.SI.TemperatureDifference dTMax=1
    "Safety temperature difference to prevent TFlu > Medium.T_max";
  final parameter .Modelica.Units.SI.Temperature TMedMax=Medium.T_max - dTMax
    "Fluid temperature above which there will be no heat gain computed to prevent TFlu > Medium.T_max";
  final parameter .Modelica.Units.SI.Temperature TMedMax2=TMedMax - dTMax
    "Fluid temperature above which there will be no heat gain computed to prevent TFlu > Medium.T_max";

  .Modelica.Blocks.Interfaces.RealInput shaCoe_internal "Internally used shaCoe";

equation
  connect(shaCoe_internal, shaCoe_in);

  if not use_shaCoe_in then
    shaCoe_internal = shaCoe;
  end if;

  // Modified from EnergyPlus 23.2.0 Engineering Reference Eq 18.302
  // by applying shade effect for direct solar radiation
  // Only solar heat gain is considered here
  for i in 1 : nSeg loop
  QSol_flow[i] =A_c/nSeg*(eta0*HGlob)*smooth(1, if TFlu[i] < TMedMax2 then 1 else
      .IDEAS.Utilities.Math.Functions.smoothHeaviside(TMedMax - TFlu[i],
      dTMax));
  end for;
annotation (
  defaultComponentName = "solGaiStc",
  Documentation(info = "<html>
<p>
This component calculates the solar heat gain on a solar thermal collector,
based on 
<a href=\"modelica://IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain\">
IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain</a>.
</p>
<p>
Unlike <a href=\"modelica://IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain\">
IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain</a>, 
this component does not compute the global irradiance on the tilted surface 
from direct and diffuse irradiance components and apply an incidence angle modifier.
It is primarily intended for validation purposes, where the
<b>total solar irradiance on the tilted collector surface is measured</b>
and can be directly provided as an input to this block.
</p>
</html>",
revisions = "<html>
<ul>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation PVT model.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">#1436</a>.
</li>
</ul>
</html>"));

end ISO9806SolarGainHGloTil;
