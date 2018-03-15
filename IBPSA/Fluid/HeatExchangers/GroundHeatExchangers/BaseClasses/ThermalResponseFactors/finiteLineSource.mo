within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors;
function finiteLineSource

  input Real t "Time";
  input Real alpha "Ground thermal diffusivity";
  input Real dis "Radial distance between borehole axes";
  input Real len1 "Length of emitting borehole";
  input Real burDep1 "Buried depth of emitting borehole";
  input Real len2 "Length of receiving borehole";
  input Real burDep2 "Buried depth of receiving borehole";
  input Boolean includeRealSource = true "True if contribution of real source is included";
  input Boolean includeMirrorSource = true "True if contribution of mirror source is included";

  output Real h_21 "Thermal response factor of borehole 1 on borehole 2";

protected
  Real lowBou = 1.0/sqrt(4*alpha*t) "Lower bound of integration";
  // Upper bound is infinite

algorithm

  h_21 := Modelica.Math.Nonlinear.quadratureLobatto(
    function
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.finiteLineSource_Integrand(
      lowBou=lowBou,
      dis=dis,
      len1=len1,
      burDep1=burDep1,
      len2=len2,
      burDep2=burDep2,
      includeRealSource=includeRealSource,
      includeMirrorSource=includeMirrorSource),
    lowBou,
    100,
    1.0e-6);

end finiteLineSource;
