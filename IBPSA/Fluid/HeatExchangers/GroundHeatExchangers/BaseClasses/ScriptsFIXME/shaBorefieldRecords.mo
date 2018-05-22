within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ScriptsFIXME;
function shaBorefieldRecords
  "Return a pseudo sha code of the combination of the record soi, fil and gen of the borefield"
  extends Modelica.Icons.Function;
    input String soiPath "Computer path of the soil record";
    input String filPath "Computer path of the fil record";
    input String genPath "Computer path of the general record";

    output String sha
    "Pseudo sha code of the combination of the soi, fil and gen records";
algorithm
  sha :=IBPSA.Utilities.Cryptographics.BaseClasses.sha(soiPath)+
    IBPSA.Utilities.Cryptographics.BaseClasses.sha(filPath)+
    IBPSA.Utilities.Cryptographics.BaseClasses.sha(genPath);
end shaBorefieldRecords;
