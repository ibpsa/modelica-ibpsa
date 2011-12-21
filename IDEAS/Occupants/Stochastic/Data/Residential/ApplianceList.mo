within IDEAS.Occupants.Stochastic.Data.Residential;
package ApplianceList

  extends Modelica.Icons.MaterialPropertiesPackage;

model U01 "List 1, 2570 kWh"

extends IDEAS.Occupants.Stochastic.Data.BaseClasses.ApplianceList(nLoads=19,appData = {fridgefreezer, uprightfreezer, answermachine, clock, cordlessphone, hifi, iron, vacuum, fax, pc, tv1, tv2,
tv3, tvreceiver, microwave, kettle, smallcookinggroup, tumbledryer, washingmachine});

parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.FridgeFreezer fridgefreezer;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.UprightFreezer uprightfreezer;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.AnswerMachine answermachine;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.Clock clock;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.CordlessPhone cordlessphone;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.HiFi hifi;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.Iron iron;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.Vacuum vacuum;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.Fax fax;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.PC pc;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.TV1 tv1;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.TV2 tv2;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.TV3 tv3;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.DVD dvd;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.TVReceiver tvreceiver;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.Microwave microwave;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.Kettle kettle;
parameter
      IDEAS.Occupants.Stochastic.Data.Residential.Appliance.SmallCookingGroup     smallcookinggroup;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.TumbleDryer tumbledryer;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliance.WashingMachine washingmachine;

end U01;

end ApplianceList;
