within Annex60.Experimental.Pipe.BaseClasses;
model SpatialDistributionOneDirection

  parameter Modelica.SIunits.Length length "Pipe length";
  Modelica.SIunits.Time time_out_b "Virtual time after delay at port b";
  Modelica.SIunits.Time tau "Time delay for input time";
  Modelica.SIunits.Length x(start=0)
    "Spatial coordiante for spatialDistribution operator";
  Modelica.Blocks.Interfaces.RealInput v "Normalized fluid velocity"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput y=tau "Time delay"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Boolean vBoolean;
equation
    if v >=0 then
    vBoolean = true;
  else
    vBoolean = false;
  end if;

  der(x) = v;
  (, time_out_b) = spatialDistribution(time,
                                       time,
                                       x/length,
                                       v>=0,
                                       {0.0, 1.0},
                                       {0.0, 0.0});
  tau = max(0,time - time_out_b);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p>
Simple model to test the <code>spatialDistribution</code> operator in one direction
</p>
</html>"));
end SpatialDistributionOneDirection;
