within Annex60.Experimental.ThermalZones.ReducedOrder.EquivalentAirTemperature;
model VDI6007
  "Equivalent air temperature as defined in VDI 6007 Part 1"
  extends BaseClasses.PartialVDI6007;

initial equation
  assert(noEvent(abs(sum(wfWall) + sum(wfWin) + wfGround - 1) < 0.1),
  "The sum of the weightfactors (walls,windows and ground) in eqairtemp is
  <0.9 or >1.1. Normally, the sum should be 1.", level=AssertionLevel.warning);
equation
  TEqLW=(TBlaSky-TDryBul)*(eExt*alphaRad/(alphaRad+alphaExtOut*0.93));
  TEqSW=HSol*aExt/(alphaRad+alphaExtOut);
  if withLongwave then
    TEqWin=TDryBul.+TEqLW*abs(sunblind.-1);
    TEqWall=TDryBul.+TEqLW.+TEqSW;
  else
    TEqWin=TDryBul*ones(n);
    TEqWall=TDryBul.+TEqSW;
  end if;
  TEqAir = TEqWall*wfWall + TEqWin*wfWin + TGround*wfGround;
  annotation (defaultComponentName="eqAirTemp",Documentation(revisions="<html>
  <p><ul>
  <li><i>October 2014,&nbsp;</i> by Peter Remmen:<br/>Implemented.</li>
  <li><i>September 2015,&nbsp;</i> by Moritz Lauster:<br>Got rid of cardinality
  and used assert for warnings.<br>Adapted to Annex 60 requirements.</li>
  </ul></p>
  </html>", info="<html>
  <p><code>VDI6007</code> is a strict implementation of the calculations defined
  in VDI 6007 Part 1. The sum of all weightfactors should be one.</p>
  </html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-100,-100},{100,100}})));
end VDI6007;
