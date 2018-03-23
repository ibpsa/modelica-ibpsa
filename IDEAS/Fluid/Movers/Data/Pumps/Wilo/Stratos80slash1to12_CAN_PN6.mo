within IDEAS.Fluid.Movers.Data.Pumps.Wilo;
record Stratos80slash1to12_CAN_PN6
  "Pump data for a Wilo Stratos 80/1-12 CAN PN 6 pump"
  extends Generic(
    speed_rpm_nominal=3300,
    use_powerCharacteristic=true,
    power(V_flow={0.0,0.00277777, 0.00555555, 0.00833333, 0.01111111, 0.01388888, 0.01666666}, P={870.97, 1096.8, 1419.4, 1548.4, 1548.4, 1548.4, 1548.4}),
    pressure(V_flow={0.0,0.00277777, 0.00555555, 0.00833333, 0.01111111, 0.01388888, 0.01666666}, dp={125760, 124360, 123940, 112800, 92160, 67680, 36480}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/0000001700017d670001003a/fc_product_datasheet\">
  http://productfinder.wilo.com/en/COM/product/0000000e000379df0002003a/fc_product_datasheet
  </a>
  </p>
  <p>See
  <a href=\"modelica://IDEAS.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6\">
  IDEAS.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6
  </a>
  for more information about how the data is derived.
  </p>
  </html>", revisions="<html>
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
end Stratos80slash1to12_CAN_PN6;
