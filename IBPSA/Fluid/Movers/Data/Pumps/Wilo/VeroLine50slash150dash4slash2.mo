within IDEAS.Fluid.Movers.Data.Pumps.Wilo;
record VeroLine50slash150dash4slash2
  "Pump data for a Wilo Veroline IP-E 50/150-4/2 pump"
  extends Generic(
    speed_rpm_nominal=2900,
    use_powerCharacteristic=true,
    power(V_flow={0.0,0.00277777, 0.00555555, 0.00833333, 0.01111111, 0.01388888, 0.01666666}, P={1607.8, 2235.3, 2862.7, 3529.4, 4078.4, 4392.2, 4666.7}),
    pressure(V_flow={0.0,0.00277777, 0.00555555, 0.00833333, 0.01111111, 0.01388888, 0.01666666}, dp={255400, 255400, 255400, 250000, 232010, 199640, 156470}),
    motorCooledByFluid=true);
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>Data from:<a href=\"http://productfinder.wilo.com/nl/BE/product/0000001d000149e80001003a/fc_product_datasheet\"> http://productfinder.wilo.com/nl/BE/product/0000001d000149e80001003a/fc_product_datasheet</a></p>
<p>See <a href=\"modelica://IDEAS.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6\">IDEAS.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 </a>for more information about how the data is derived. </p>
</html>",   revisions="<html>
<ul>
<li>
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/396\">#396</a>.
</li>
<li>
December 12, 2014, by Michael Wetter:<br/>
Added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code> annotations.
</li>
<li>April 22, 2014
    by Filip Jorissen:<br/>
       Initial version
</li>
</ul>
</html>"));
end VeroLine50slash150dash4slash2;
