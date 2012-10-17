within IDEAS.Occupants.Extern;
package Interfaces

  extends Modelica.Icons.InterfacesPackage;

  model Occ_Files "Dummy file reader for occupant model"

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

  end Occ_Files;


  model Stoch33 "33 stochastic user behaviour profiles "

    extends IDEAS.Occupants.Extern.Interfaces.Occ_Files(nOcc=33, filPres = "User_Presence_15.txt",
    filQCon = "User_QCon_15.txt",filQRad = "User_QRad_15.txt",filP = "User_P_15.txt",
    filQ = "User_zeros.txt",filDHW = "User_mDHW_15.txt");

  end Stoch33;

end Interfaces;
