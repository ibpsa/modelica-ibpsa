within IDEAS.Fluid.Movers.Data.Pumps.Wilo;
record Stratos65slash1to12_CAN_PN6slash10
  "Pump data for a Wilo Stratos 65/1-12 CAN PN 6/10 pump"
  extends Generic(
    speed_rpm_nominal=3300,
    use_powerCharacteristic=true,
    power(V_flow={0.0,0.00111111, 0.00222222, 0.00333333, 0.00444444, 0.00555555, 0.00666666, 0.00777777, 0.00888888, 0.01, 0.01111111}, P={615.76, 698.18, 756.36, 785.45, 806.0, 806.0, 806.0, 806.0, 806.0, 806.0, 806.0}),
    pressure(V_flow={0.0,0.00111111, 0.00222222, 0.00333333, 0.00444444, 0.00555555, 0.00666666, 0.00777777, 0.00888888, 0.01, 0.01111111}, dp={107873, 103950, 102190, 96930, 89912, 82456, 73684, 64035, 54386, 44298, 32456}),
    motorCooledByFluid=true);
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/00000018000029520002003a/fc_product_datasheet\">
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
end Stratos65slash1to12_CAN_PN6slash10;
