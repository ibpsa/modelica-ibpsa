within IDEAS.Occupants.Stochastic.Data.Residential;
package ApplianceList

  extends Modelica.Icons.MaterialPropertiesPackage;

model Example "IDEAS Example for appliance list"

extends IDEAS.Occupants.Stochastic.Data.BaseClasses.ApplianceList(nLoads=19,appData = {fridgefreezer, uprightfreezer, answermachine, clock, cordlessphone, hifi, iron, vacuum, fax, pc, tv1, tv2,
tv3, tvreceiver, microwave, kettle, smallcookinggroup, tumbledryer, washingmachine});

parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.FridgeFreezer fridgefreezer;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.UprightFreezer
                                                                               uprightfreezer;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.AnswerMachine answermachine;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.Clock clock;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.CordlessPhone cordlessphone;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.HiFi hifi;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.Iron iron;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.Vacuum vacuum;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.Fax fax;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.PC pc;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.TV1 tv1;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.TV2 tv2;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.TV3 tv3;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.DVD dvd;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.TVReceiver tvreceiver;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.Microwave microwave;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.Kettle kettle;
parameter
      IDEAS.Occupants.Stochastic.Data.Residential.Appliances.SmallCookingGroup    smallcookinggroup;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.TumbleDryer tumbledryer;
parameter IDEAS.Occupants.Stochastic.Data.Residential.Appliances.WashingMachine
                                                                               washingmachine;

end Example;

end ApplianceList;
