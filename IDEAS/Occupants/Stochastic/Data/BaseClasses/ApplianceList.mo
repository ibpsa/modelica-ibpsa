within IDEAS.Occupants.Stochastic.Data.BaseClasses;
model ApplianceList

extends Modelica.Icons.MaterialProperty;

parameter Integer nLoads(min=1);
parameter IDEAS.Occupants.Stochastic.Data.BaseClasses.Appliance[nLoads] appData;

end ApplianceList;
