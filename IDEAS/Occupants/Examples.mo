within IDEAS.Occupants;
package Examples

  extends Modelica.Icons.ExamplesPackage;

  model Occupant_FromFiles "Occupant model based on external files"
    extends Interfaces.Occupant(nZones=1, nLoads=1);
    parameter Integer profileID = 1
      "Profile ID: the column number in the external files";
    parameter SI.Temperature TSetOcc = 294.15
      "(operative) Room set temperature during occupancy";
    parameter SI.Temperature TSetNoOcc = 288.15
      "(operative) Room set temperature during abscence";

    outer Components.UserProfiles userProfiles
      annotation (Placement(transformation(extent={{-58,-38},{22,42}})));
  equation

    heatPortCon[1].Q_flow = -userProfiles.tabQCon.y[profileID];
    heatPortRad[1].Q_flow = -userProfiles.tabQRad.y[profileID];
    TSet[1] = TSetNoOcc + (TSetOcc-TSetNoOcc) * userProfiles.tabPre.y[profileID];
    wattsLawPlug[1].P = userProfiles.tabP.y[profileID];
    wattsLawPlug[1].Q = userProfiles.tabQ.y[profileID];

  end Occupant_FromFiles;
end Examples;
