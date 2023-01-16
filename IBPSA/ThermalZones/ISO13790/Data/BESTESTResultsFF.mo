within IBPSA.ThermalZones.ISO13790.Data;
record BESTESTResultsFF "BESTEST comparison results free-floating"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Temperature TavgMax=299.05 "Maximum average annual air temperature";
  parameter Modelica.Units.SI.Temperature TavgMin=297.35 "Minimum average annual air temperature";
  annotation (defaultComponentName="annComBESTESTFF",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BESTESTResultsFF;
