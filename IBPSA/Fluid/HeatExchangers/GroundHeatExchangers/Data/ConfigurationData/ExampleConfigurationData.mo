within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData;
record ExampleConfigurationData
  extends Template(
    singleUTube=true,
    nbBh=4,
    cooBh={{0,0},{0,6},{6,0},{6,6}});
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ExampleConfigurationData;
