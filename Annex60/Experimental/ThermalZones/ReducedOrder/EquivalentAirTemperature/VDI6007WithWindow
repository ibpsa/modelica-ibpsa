within Annex60.Experimental.ThermalZones.ReducedOrder.EquivalentAirTemperature;
model VDI6007WithWindow
  "Equivalent air temperature as defined in VDI 6007 Part 1 with modifications"

  extends BaseClasses.PartialEqAirTemp;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaWinOut
    "Windows' convective coefficient of heat transfer (outdoor)";
  parameter Modelica.SIunits.Emissivity aWin
    "Coefficient of absorption of the windows";
  Modelica.SIunits.TemperatureDifference TEqLWWin
    "Equivalent long wave temperature for windows";
  Modelica.SIunits.TemperatureDifference TEqSWWin[n]
    "Eqiuvalent short wave temperature for windows";
  Modelica.Blocks.Interfaces.RealOutput TEqAirWindow
    "Equivalent air temperature for windows (no short-wave radiation)"
    annotation (Placement(transformation(extent={{80,58},{100,78}}),
        iconTransformation(extent={{78,6},{118,46}})));
initial equation
  assert(noEvent(abs(sum(wfWall) + wfGround - 1) < 0.1),
  "The sum of the weightfactors (walls and ground) in eqairtemp is <0.9 or >1.1.
   Normally, the sum should be 1.", level=AssertionLevel.warning);
  assert(noEvent(abs(sum(wfWin) - 1) < 0.1),
  "The sum of the weightfactors (windows) in eqairtemp is <0.9 or >1.1. 
  Normally, the sum should be 1.", level=AssertionLevel.warning);
equation
  TEqLW=(TBlaSky-TDryBul)*(eExt*alphaRad/(alphaRad+alphaExtOut));
  TEqLWWin=(TBlaSky-TDryBul)*(eExt*alphaRad/(alphaRad+alphaWinOut));
  TEqSW=HSol*aExt/(alphaRad+alphaExtOut);
  TEqSWWin=HSol*aWin/(alphaRad+alphaWinOut);

  if withLongwave then
    TEqWin=TDryBul.+(TEqLWWin.+TEqSWWin).*abs(sunblind.-1);
    TEqWall=TDryBul.+TEqLW.+TEqSW;
  else
    TEqWin=TDryBul.+TEqSWWin.*abs(sunblind.-1);
    TEqWall=TDryBul.+TEqSW;
  end if;

  TEqAir = TEqWall*wfWall + TGround*wfGround;
  TEqAirWindow = TEqWin*wfWin;
  annotation (defaultComponentName="eqAirTemp",Documentation(revisions="<html>
<p><ul>
<li><i>October 2014,&nbsp;</i> by Peter Remmen:<br/>Implemented.</li>
<li><i>September 2015,&nbsp;</i> by Moritz Lauster:<br>Got rid of cardinality 
and used assert for warnings.<br>Adapted to Annex 60 requirements.</li>
</ul></p>
</html>", info="<html>
<p><code>EqAirTemp</code> is variant of the calculations defined in VDI 6007 
Part 1. It adds a second equivalent air temperature for windows in case heat 
transfer through windows and exterior walls is handled seperately in the Reduced
Order Model. The sum of all weightfactors for windows should be one as well as 
the sum for all wall elements.</p>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end VDI6007WithWindow;
