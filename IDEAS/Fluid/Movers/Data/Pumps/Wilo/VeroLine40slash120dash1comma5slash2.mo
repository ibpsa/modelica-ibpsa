within IDEAS.Fluid.Movers.Data.Pumps.Wilo;
record VeroLine40slash120dash1comma5slash2
  "Pump data for a Wilo Veroline IP-E 40/120-1,5/2 pump"
  extends Generic(
    speed_rpm_nominal=2890,
    use_powerCharacteristic=true,
    power(V_flow={0,5,10,15,20,25,30,35}/3600,
          P={0.69495, 0.92202, 1.1766, 1.4312, 1.6651, 1.8028, 1.8853, 1.9404}*1000),
    pressure(V_flow={0,5,10,15,20,25,30,35}/3600,
             dp={17.396, 18.040, 18.309, 17.879, 16.698, 14.765, 11.973, 8.8054}*9806.65),
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
end VeroLine40slash120dash1comma5slash2;
