within IDEAS.Occupants.Extern;
package Interfaces

  extends Modelica.Icons.InterfacesPackage;

  model occupant

      parameter Integer nOcc = 1 "Number of occupant data sets to be read" annotation (Dialog(group="Building occupants"));

    parameter String filPres = "User_zeros.txt"
      "Filename for occupancy presence"
                                      annotation (Dialog(group="Building occupants"));
    parameter String filQCon = "User_zeros.txt"
      "Filename for occupancy-driven convective gains" annotation (Dialog(group="Building occupants"));
    parameter String filQRad = "User_zeros.txt"
      "Filename for occupancy-driven radiative gains" annotation (Dialog(group="Building occupants"));
    parameter String filP = "User_zeros.txt"
      "Filename for occupancy-driven active power load" annotation (Dialog(group="Building occupants"));
    parameter String filQ = "User_zeros.txt"
      "Filename for occupancy-driven reactive power load" annotation (Dialog(group="Building occupants"));
    parameter String filDHW = "User_zeros.txt"
      "Filename for occupancy-driven domestic hot water redrawal" annotation (Dialog(group="Building occupants"));

  end occupant;

  model none

    extends IDEAS.Occupants.Extern.Interfaces.occupant;

  end none;

  model fromFiles

    extends IDEAS.Occupants.Extern.Interfaces.occupant(nOcc=33, filPres = "User_Presence_15.txt",
    filQCon = "User_QCon_15.txt",filQRad = "User_QRad_15.txt",filP = "User_P_15.txt",
    filQ = "User_Q_15.txt",filDHW = "User_mDHW_15s.txt");

  end fromFiles;

end Interfaces;
