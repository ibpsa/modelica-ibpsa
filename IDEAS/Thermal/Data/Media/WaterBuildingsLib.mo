within IDEAS.Thermal.Data.Media;
record WaterBuildingsLib
  "Medium properties of water using the same cp as in the buildings library"
  extends IDEAS.Thermal.Data.Media.Water(
    rho=995.586,
    cp=4184,
    cv=4184);
  annotation (Documentation(info="<html>
<p>This Medium has been create to work in conjunction with the Buildings library using the model <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.FluidStreamConversionWater\">FluidStreamConversionWater</a>. To work correctly this model has the same constant cp and cv as the buildings library: cp=4184 instead of cp=4177.</p>
</html>"));
end WaterBuildingsLib;
