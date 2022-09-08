within IBPSA.Fluid.HeatPumps.BlackBoxData;
package EuropeanNorm2DData
  "Package with two-dimensional data based on european standard"
  record HeatPumpBaseDataDefinition "Basic heat pump data"
      extends Modelica.Icons.Record;
    parameter Real tableQCon_flow[:,:]
      "Heating power table; T in degC; Q_flow in W";
    parameter Real tablePel[:,:] "Electrical power table; T in degC; Q_flow in W";
    parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
      "Nominal mass flow rate in condenser";
    parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
      "Nominal mass flow rate in evaporator";
    parameter Real tableUppBou[:,2] "Points to define upper boundary for sink temperature";
    parameter String device_id "Name of the device";
    annotation (Documentation(info="<html><h4>
  <span style=\"color: #008000\">Overview</span>
</h4>Base data definition used in the heat pump model. It defines the
table <span style=\"font-family: Courier New;\">table_Qdot_Co</span>
which gives the condenser heat flow rate and <span style=
\"font-family: Courier New;\">table_Pel</span> which gives the electric
power consumption of the heat pump. Both tables define the power values
depending on the evaporator inlet temperature (defined in first row)
and the condenser outlet temperature (defined in first column) in W.
The nominal mass flow rate in the condenser and evaporator are also
defined as parameters.
<h4>
  <span style=\"color: #008000\">Calculation of nominal mass flow
  rates</span>
</h4>
<ul>
  <li>General calculation ṁ = Q̇<sub>nominal</sub> / c<sub>p</sub> /
  ΔT
  </li>
</ul><b>Condenser</b> <span style=
\"font-family: Courier New;\">mCon_flow_nominal</span>
<ul>
  <li>According to <b>EN 14511</b> on <b>water</b> bound condenser side
  <span style=\"font-family: Courier New;\">ΔT = 5 K</span>
  </li>
  <li>According to EN 255 (deprecated) on <b>water</b> bound condenser
  side <span style=\"font-family: Courier New;\">ΔT = 10 K</span>
  </li>
</ul><b>Evaporator</b> <span style=
\"font-family: Courier New;\">mEva_flow_nominal:</span>
<ul>
  <li>According to <b>EN 14511</b> on <b>water/glycol</b> bound
  evaporator side <span style=\"font-family: Courier New;\">ΔT = 3
  K</span>
  </li>
  <li>Possible calculation for <b>air</b> bound evaporator side <span>
    ṁ<sub>eva,nominal</sub> = (Q̇<sub>con,nominal</sub> -
    Ṗ<sub>el,nominal</sub>) / c<sub>p</sub> / ΔT</span> under the
    assumption (no literature source so far) of <span>ΔT = 5 K</span>
  </li>
</ul>
</html>", revisions="<html><ul>
  <li>
    <i>MAy 7, 2020</i> by Philipp Mehrfeld:<br/>
    Add description of how to calculate m_flows
  </li>
  <li>
    <i>December 10, 2013</i> by Ole Odendahl:<br/>
    Formatted documentation appropriately
  </li>
</ul>
</html>
"),  Icon);
  end HeatPumpBaseDataDefinition;

  package EN14511

    record AlphaInnotec_LW80MA "Alpha Innotec LW 80 M-A"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="AlphaInnotec_LW80MA",
        tablePel=[0,-7,2,7,10,15,20; 35,2625,2424,2410,2395,2347,2322; 45,3136,
            3053,3000,2970,2912,2889; 50,3486,3535,3451,3414,3365,3385],
        tableQCon_flow=[0,-7,2,7,10,15,20; 35,6300,8000,9400,10300,11850,13190;
            45,6167,7733,9000,9750,11017,11730; 50,6100,7600,8800,9475,10600,
            11000],
        mCon_flow_nominal=9400/4180/5,
        mEva_flow_nominal=1,
        tableUppBou=[-25,65; 40,65]);
        //These boundary-tables are not from the datasheet but default values.

      annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for air-to-water heat pump Alpha&nbsp;Innotec&nbsp;LW&nbsp;80&nbsp;M-A.</span></p>
<p><span style=\"font-family: Courier New; color: #006400;\">Operational envelope data is not from the data table, as it is not given. Instead, default values are used.</span></p>
</html>"));
    end AlphaInnotec_LW80MA;

    record Dimplex_LA11AS "Dimplex LA 11 AS"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="Dimplex_LA11AS",
        tablePel=[0,-7,2,7,10; 35,2444,2839,3139,3103; 45,2783,2974,3097,3013],

        tableQCon_flow=[0,-7,2,7,10; 35,6600,8800,11300,12100; 45,6400,7898,
            9600,10145],
        mCon_flow_nominal=11300/4180/5,
        mEva_flow_nominal=1,
        tableUppBou=[-25,58; 35,58]);

      annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for a Dimplex LA11AS air-to-water heat pump.</span></p>
</html>"));
    end Dimplex_LA11AS;

    record Ochsner_GMLW_19 "Ochsner GMLW 19"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="Ochsner_GMLW_19",
        tablePel=[0,-10,2,7; 35,4300,4400,4600; 50,6300,6400,6600],
        tableQCon_flow=[0,-10,2,7; 35,11600,17000,20200; 50,10200,15600,18800],

        mCon_flow_nominal=20200/4180/5,
        mEva_flow_nominal=1,
        tableUppBou=[-15,55; 40,55]);

      annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for the Ochsner GMLW 19 air-to-water device</span></p>
</html>"));
    end Ochsner_GMLW_19;

    record Ochsner_GMLW_19plus "Ochsner GMLW 19 plus"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="Ochsner_GMLW_19plus",
        tablePel=[0,-10,2,7; 35,4100,4300,4400; 50,5500,5700,5800; 60,6300,6500,
            6600],
        tableQCon_flow=[0,-10,2,7; 35,12600,16800,19800; 50,11700,15900,18900;
            60,11400,15600,18600],
        mCon_flow_nominal=19800/4180/5,
        mEva_flow_nominal=1,
        tableUppBou=[-24,52; -15,55; -10,65; 40,65]);

      annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for the Ochsner GMLW 19 plus air-to-water device</span></p>
</html>"));
    end Ochsner_GMLW_19plus;

    record Ochsner_GMSW_15plus "Ochsner GMSW 15 plus"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="Ochsner_GMSW_15plus",
        tablePel=[0,-5,0,5; 35,3225,3300,3300; 45,4000,4000,4000; 55,4825,4900,
            4900],
        tableQCon_flow=[0,-5,0,5; 35,12762,14500,16100; 45,12100,13900,15600;
            55,11513,13200,14900],
        mCon_flow_nominal=14500/4180/5,
        mEva_flow_nominal=(14500 - 3300)/3600/3,
        tableUppBou=[-8,52; 0,65; 20,65]);

      annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for the Ochsner GMLW 15 brine-to-water device</span></p>
</html>"));
    end Ochsner_GMSW_15plus;

    record StiebelEltron_WPL18 "Stiebel Eltron WPL 18"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="StiebelEltron_WPL18",
        tablePel=[0,-7,2,7,10,20; 35,3300,3400,3500,3700,3800; 50,4500,4400,
            4600,5000,5100],
        tableQCon_flow=[0,-7,2,7,10,20; 35,9700,11600,13000,14800,16300; 50,
            10000,11200,12900,16700,17500],
        mCon_flow_nominal=13000/4180/5,
        mEva_flow_nominal=1,
        tableUppBou=[-25,65; 40,65]);
        //These boundary-tables are not from the datasheet but default values.

      annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for a Stiebel Eltron WPL18 air-to-water heat pump</span></p>
</html>"));
    end StiebelEltron_WPL18;

    record Vaillant_VWL_101 "Vaillant VWL10-1"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="Vaillant_VWL_101",
        tablePel=[0,-15,-7,2,7; 35,2138,2177,2444,2444; 45,2558,2673,2864,3055;
            55,2902,3131,3360,3513],
        tableQCon_flow=[0,-15,-7,2,7; 35,5842,7523,9776,10807; 45,5842,7332,
            9050,10387; 55,5728,7179,9050,10043],
        mCon_flow_nominal=9776/4180/5,
        mEva_flow_nominal=1,
        tableUppBou=[-25,65; 40,65]);
        //These boundary-tables are not from the datasheet but default values.

      annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for a Vaillaint VLW_101 air-to-water heat pump</span></p>
</html>"));
    end Vaillant_VWL_101;

    record Vitocal200AWO201
      "Vitocal200AWO201"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="Vitocal200AWO201",
        tablePel=[0,-15,-7,2,7,10,20,30; 35,1290.0,1310.0,730.0,870.0,850.0,
            830.0,780.0; 45,1550.0,1600.0,870.0,1110.0,1090.0,1080.0,1040.0; 55,
            1870.0,1940.0,1170.0,1370.0,1370.0,1370.0,1350.0],
        tableQCon_flow=[0,-15,-7,2,7,10,20,30; 35,3020,3810,2610,3960,4340,5350,
            6610; 45,3020,3780,2220,3870,4120,5110,6310; 55,3120,3790,2430,3610,
            3910,4850,6000],
        mCon_flow_nominal=3960/4180/5,
        mEva_flow_nominal=(2250*1.2)/3600,
        tableUppBou=[-20,50; -10,60; 30,60; 35,55]);

      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false)),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html><p>
  <span style=
  \"font-family: Courier New; color: #006400;\">Data&#160;record&#160;for&#160;type&#160;AWO-M/AWO-M-E-AC&#160;201.A04,
  obtained from the technical guide in the UK.</span>
</p>
<ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"));
    end Vitocal200AWO201;
  annotation (Documentation(info="<html>
<p>Records according to 14511.</p>
</html>"));
  end EN14511;

  package EN255

    record AlphaInnotec_SW170I "Alpha Innotec SW 170 I"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="AlphaInnotec_SW170I",
        tablePel=[0,-5.0,0.0,5.0; 35,3700,3600,3600; 50,5100,5100,5100],
        tableQCon_flow=[0,-5.0,0.0,5.0; 35,14800,17200,19100; 50,14400,16400,
            18300],
        mCon_flow_nominal=17200/4180/10,
        mEva_flow_nominal=13600/3600/3,
        tableUppBou=[-22,65; 45,65]);

      annotation (Documentation(info="<html>
<p>Data for a brine-to-water heat pump of Alpha Innotec. Data according to: <a href=\"https://www.forum-hausbau.de/data/PruefResSW090923.pdf\">https://www.forum-hausbau.de/data/PruefResSW090923.pdf</a></p>
</html>"));
    end AlphaInnotec_SW170I;

    record NibeFighter1140_15 "Nibe Fighter 1140-15"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="NibeFighter1140_15",
        tablePel=[0,-5.0,0.0,2,5.0,10; 35,3360,3380,3380,3390,3400; 55,4830,
            4910,4940,4990,5050],
        tableQCon_flow=[0,-5.0,0.0,2,5.0,10; 35,13260,15420,16350,17730,19930;
            55,12560,14490,15330,16590,18900],
        mCon_flow_nominal=15420/4180/10,
        mEva_flow_nominal=(15420 - 3380)/3600/3,
        tableUppBou=[-35,65; 50,65]);

      annotation (Documentation(info="<html>
<p>Brine-to-water heat pump according to: <a href=\"https://www.nibe.lv/nibedocuments/10153/031094-4.pdf\">https://www.nibe.lv/nibedocuments/10153/031094-4.pdf</a></p>
</html>"));
    end NibeFighter1140_15;

    record Vitocal350AWI114 "Vitocal 350 AWI 114"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="Vitocal350AWI114",
        tablePel=[0,-20,-15,-10,-5,0,5,10,15,20,25,30; 35,3295.500,3522.700,
            3750,3977.300,4034.100,4090.900,4204.500,4375,4488.600,4488.600,
            4545.500; 50,4659.100,4886.400,5113.600,5227.300,5511.400,5568.200,
            5738.600,5909.100,6022.700,6250,6477.300; 65,0,6875,7159.100,7500,
            7727.300,7897.700,7954.500,7954.500,8181.800,8409.100,8579.500],
        tableQCon_flow=[0,-20,-15,-10,-5,0,5,10,15,20,25,30; 35,9204.500,
            11136.40,11477.30,12215.90,13863.60,15056.80,16931.80,19090.90,
            21250,21477.30,21761.40; 50,10795.50,11988.60,12215.90,13068.20,
            14545.50,15681.80,17613.60,20284.10,22500,23181.80,23863.60; 65,0,
            12954.50,13465.90,14431.80,15965.90,17386.40,19204.50,21250,
            22897.70,23863.60,24886.40],
        mCon_flow_nominal=15400/4180/10,
        mEva_flow_nominal=1,
        tableUppBou=[-20,55; -5,65; 35,65]);

      annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for VitoCal350 air-to-water heat pump, around 11 kW</span></p>
</html>"));
    end Vitocal350AWI114;

    record Vitocal350BWH110 "Vitocal 350 BWH 110"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="Vitocal350BWH110",
        tablePel=[0,-5.0,0.0,5.0,10.0,15.0; 35,2478,2522,2609,2696,2783; 45,
            3608,3652,3696,3739,3783; 55,4217,4261,4304,4348,4391; 65,5087,5130,
            5174,5217,5261],
        tableQCon_flow=[0,-5.0,0.0,5.0,10.0,15.0; 35,9522,11000,12520,14000,
            15520; 45,11610,12740,13910,15090,16220; 55,11610,12740,13910,15090,
            16220; 65,11610,12740,13910,15090,16220],
        mCon_flow_nominal=11000/4180/10,
        mEva_flow_nominal=8400/3600/3,
        tableUppBou=[-5,55; 25,55]);

      annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for VitoCal350 brine-to-water heat pump, around 11 kW</span></p>
</html>"));
    end Vitocal350BWH110;

    record Vitocal350BWH113 "Vitocal 350 BWH 113"
      extends
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
        device_id="Vitocal350BWH113",
        tablePel=[0,-5.0,0.0,5.0,10.0,15.0; 35,3750,3750,3750,3750,3833; 45,
            4833,4917,4958,5042,5125; 55,5583,5667,5750,5833,5958; 65,7000,7125,
            7250,7417,7583],
        tableQCon_flow=[0,-5.0,0.0,5.0,10.0,15.0; 35,14500,16292,18042,19750,
            21583; 45,15708,17167,18583,20083,21583; 55,15708,17167,18583,20083,
            21583; 65,15708,17167,18583,20083,21583],
        mCon_flow_nominal=16292/4180/10,
        mEva_flow_nominal=12300/3600/3,
        tableUppBou=[-5,55; 25,55]);

      annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for VitoCal350 brine-to-water heat pump, around 16 kW</span></p>
</html>"));
    end Vitocal350BWH113;
  annotation (Documentation(info="<html>
<p>Records according to older EN255.</p>
</html>"));
  end EN255;
annotation (Documentation(info="<html>
<p>This package contains data records for heat pump data according to European Norm.</p>
</html>"));
end EuropeanNorm2DData;
