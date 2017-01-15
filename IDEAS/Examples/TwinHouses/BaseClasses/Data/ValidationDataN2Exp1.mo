model ValidationDataN2Exp1 "Model that reads all validation data for Twinhouse"

final parameter Integer exp = 1 "Experiment number: 1 or 2"; 
final parameter Integer bui = 1 "Building number 1 (N2), 2 (O5)";

final parameter String filNam = "validationdataN2Exp1.txt"; 
final parameter String dirPath = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Inputs/")    annotation(Evaluate=true); 
Modelica.Blocks.Sources.CombiTimeTable data( 
tableOnFile=true, 
tableName="data", 
columns=2:51, 
smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2, 
extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint, 
final fileName=dirPath+filNam) 
"input for validation data measured at TTH"
annotation (Placement(transformation(extent={{-100,60},{-80,80}}))); 

Real N2_attic_east_AT= data.y[1];
Real N2_attic_west_AT= data.y[2];
Real N2_cellar_AT= data.y[3];
Real N2_living_AT_h67cm= data.y[4];
Real N2_living_AT_h125cm= data.y[5];
Real N2_living_AT_h187cm= data.y[6];
Real N2_corridor_AT= data.y[7];
Real N2_bath_AT= data.y[8];
Real N2_child_AT= data.y[9];
Real N2_kitchen_AT= data.y[10];
Real N2_doorway_AT= data.y[11];
Real N2_bedroom_AT= data.y[12];
Real N2_living_rH_h125cm= data.y[13];
Real N2_westfacade_S_IS_T= data.y[14];
Real N2_westfacade_S_IS_HF= data.y[15];
Real N2_westfacade_S_BL1_T= data.y[16];
Real N2_westfacade_S_BL1_HF= data.y[17];
Real N2_westfacade_S_ES_T= data.y[18];
Real N2_heat_elP_living_room= data.y[19];
Real N2_heat_elP_bath_room= data.y[20];
Real N2_heat_elP_children_room= data.y[21];
Real N2_heat_elP_kitchen= data.y[22];
Real N2HeatInputKitchen= data.y[23];
Real N2_heat_elP_doorway= data.y[24];
Real N2_heat_elP_bedroom= data.y[25];
Real N2_vent_ODA_AT= data.y[26];
Real N2_vent_SUA_AT= data.y[27];
Real N2_vent_SUA_corr_AT= data.y[28];
Real N2_vent_EHA_AT= data.y[29];
Real N2_vent_SUA_VFR= data.y[30];
Real N2_vent_EHA_VFR= data.y[31];
Real N2_vent_SUA_fan_elP= data.y[32];
Real N2_vent_EHA_fan_elP= data.y[33];
Real N2_vent_thP= data.y[34];
Real Ambient_temperature= data.y[35];
Real Solar_radiation_global_horizontal= data.y[36];
Real Solar_radiation_diffuse_horizontal= data.y[37];
Real Solar_radiation_global_vertical_north= data.y[38];
Real Solar_radiation_global_vertical_east= data.y[39];
Real Solar_radiation_global_vertical_south= data.y[40];
Real Solar_radiation_global_vertical_west= data.y[41];
Real Longwave_radiation_horizontal= data.y[42];
Real Longwave_radiation_vertical_west= data.y[43];
Real Wind_speed= data.y[44];
Real Wind_direction= data.y[45];
Real Relative_humidity= data.y[46];
Real Ground_temperature_0cm= data.y[47];
Real Ground_temperature_50cm= data.y[48];
Real Ground_temperature_100cm= data.y[49];
Real Ground_temperature_200cm= data.y[50];
end ValidationDataN2Exp1;