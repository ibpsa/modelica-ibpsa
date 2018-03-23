within IDEAS.Fluid.Movers.Data.Pumps.Wilo;
record Stratos40slash1to12CANPN6slash10
  "Pump data for a Wilo Stratos 40/1-12 CAN PN 6/10 pump"
  extends Generic(
    speed_rpm_nominal=4600,
    use_powerCharacteristic=true,
    power(V_flow={0,4,8,12,16,20}/3600,
        P={322.48, 412.40, 452.71, 493.02, 524.03, 542.64}),
    pressure(V_flow={0,4,8,12,16,20}/3600,
        dp={13, 12.741, 11.153, 9.2835, 7.1028, 4.7040}*9806.65));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/00000018000029380002003a/fc_product_datasheet\">
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
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
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
end Stratos40slash1to12CANPN6slash10;
