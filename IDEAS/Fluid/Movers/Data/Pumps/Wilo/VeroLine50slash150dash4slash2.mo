within IDEAS.Fluid.Movers.Data.Pumps.Wilo;
record VeroLine50slash150dash4slash2
  "Pump data for a Wilo Veroline IP-E 50/150-4/2 pump"
  extends Generic(
    speed_rpm_nominal=2900,
    use_powerCharacteristic=true,
    power(V_flow={0.0,0.00277777, 0.00555555, 0.00833333, 0.01111111, 0.01388888, 0.01666666}, P={1607.8, 2235.3, 2862.7, 3529.4, 4078.4, 4392.2, 4666.7}),
    pressure(V_flow={0.0,0.00277777, 0.00555555, 0.00833333, 0.01111111, 0.01388888, 0.01666666}, dp={255400, 253200, 251500, 250000, 232010, 199640, 156470}),
    motorCooledByFluid=true);
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>Data from:
<a href=\"http://productfinder.wilo.com/com/en/Wilo/c0000002a0003a36300010023/c0000002a0003a36d00010023/c0000002200012eb000020023/_000000650002b9ab0001003a/product.html\">
http://productfinder.wilo.com/com/en/Wilo/c0000002a0003a36300010023/c0000002a0003a36d00010023/c0000002200012eb000020023/_000000650002b9ab0001003a/product.html
</a>
</p>
<p>See 
<a href=\"modelica://IDEAS.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6\">
IDEAS.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 
</a>
for more information about how the data is derived. 
</p>
</html>",   revisions="<html>
<ul>
<li>March 23, 2018
    by Iago Cupeiro:<br/>
       Initial version
</li>
</ul>
</html>"));
end VeroLine50slash150dash4slash2;
