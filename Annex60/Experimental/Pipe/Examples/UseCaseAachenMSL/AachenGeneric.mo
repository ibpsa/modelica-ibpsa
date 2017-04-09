within Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL;
model AachenGeneric
  "Model automatically generated with uesmodels at 2016-12-12 12:20:05.947837"
  extends Modelica.Icons.Example;


  parameter Modelica.SIunits.Temperature T_amb = 283.15
    "Ambient temperature around pipes";

  package Medium = Annex60.Media.Water(T_default=273.15+70);

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.SupplySource supplysupply(
      redeclare package Medium = Medium, p_supply=1000000) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={493.7179687603422,553.1762970021425})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA3041(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={800.9859902302968,526.1729700647633})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA3009(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={41.15622872250802,267.8729793290547})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA1429(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={178.7590357035367,295.24737596371716})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA2468(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={1000.0,760.009355353569})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA1447(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0.0,248.00788872540275})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA1462(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={643.9591121370589,685.7340525618907})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA1465(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={611.1243642944979,403.76432359947466})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA1477(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={445.264151005661,1015.3310001029834})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA3529(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={87.97389217101733,0.0})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA3609(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={633.6055705813698,272.3579181095751})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA3610(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={686.7253869769394,537.5230184715364})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA1455(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={302.01574813866176,991.9384509959672})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA1451(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={354.25651753552665,325.5570181995385})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA2881(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={240.00670600572022,1007.9852764781073})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA2888(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={499.37948555528345,1004.5065764017589})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA2974(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={137.63302561482408,24.365004986299837})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA2984(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={407.23793871612946,329.2045267658489})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA2987(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={223.0360437031334,314.4558610128271})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA3065(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={314.1141736122173,61.31892347960303})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA3067(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={865.695920593297,795.1571158311488})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA3068(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={785.2215204359562,803.8553633085927})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA3069(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={716.472973574878,264.54968588511986})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA3070(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={799.3495954560514,256.76536953008235})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA2629(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={252.59360912951053,67.57738344430696})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.DemandSink stationA3611(
      redeclare package Medium = Medium, m_flow_nominal=0.11950286806883365)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={704.7186181500654,812.3692882993668})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64536424(
    redeclare package Medium = Medium,
    length=15.841391502597723,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=82.14619966628325,
        origin={580.565,759.987})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136540(
    redeclare package Medium = Medium,
    length=16.69461089480488,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=262.14262050959576,
        origin={561.792,623.924})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136539(
    redeclare package Medium = Medium,
    length=8.67207429947886,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=352.14619966628396,
        origin={607.693,688.737})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64406433(
    redeclare package Medium = Medium,
    length=13.336702541819008,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=348.47096074174937,
        origin={556.219,172.671})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64346433(
    redeclare package Medium = Medium,
    length=17.361931556578437,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180.0856044522311,
        origin={427.759,183.814})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64296433(
    redeclare package Medium = Medium,
    length=15.292538353453127,
    diameter=0.1,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=82.14527038648444,
        origin={509.876,247.876})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136521(
    redeclare package Medium = Medium,
    length=16.564225427355726,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90.08560445223141,
        origin={354.361,253.631})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136530(
    redeclare package Medium = Medium,
    length=8.046833022932352,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=186.24105697717525,
        origin={320.907,180.034})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136516(
    redeclare package Medium = Medium,
    length=34.926499759191024,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=79.03699005971923,
        origin={262.999,1124.68})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64822888(
    redeclare package Medium = Medium,
    length=12.551494711088933,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=351.450494627037,
        origin={551.777,994.629})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136537(
    redeclare package Medium = Medium,
    length=12.56231505592064,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=116.28587975540567,
        origin={114.1476887256582,71.91347075426796})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136538(
    redeclare package Medium = Medium,
    length=13.326460255229593,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=352.1452703864843,
        origin={462.968,319.516})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136529(
    redeclare package Medium = Medium,
    length=17.411165392313602,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=282.8809360976238,
        origin={239.42149279833862,242.80368758986143})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136535(
    redeclare package Medium = Medium,
    length=12.47474834331793,
    diameter=0.065,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=197.60893772723173,
        origin={159.67446354395628,144.7429084886619})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136531(
    redeclare package Medium = Medium,
    length=16.362420231930344,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=102.8809360976239,
        origin={194.158,225.911})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64746472(
    redeclare package Medium = Medium,
    length=2.5136658321401453,
    diameter=0.065,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=12.88093609762256,
        origin={219.9,160.94})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136532(
    redeclare package Medium = Medium,
    length=14.220766986581868,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=102.8809360976238,
        origin={300.731,117.842})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136528(
    redeclare package Medium = Medium,
    length=16.900704637832263,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=79.44057828087047,
        origin={878.771,863.296})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136526(
    redeclare package Medium = Medium,
    length=17.634609005399696,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=79.4405782808705,
        origin={798.864,875.04})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136523(
    redeclare package Medium = Medium,
    length=14.22406441423505,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=258.4709607417494,
        origin={704.472,203.714})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136524(
    redeclare package Medium = Medium,
    length=23.602789930678952,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=225.7950290601658,
        origin={745.91,199.822})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136543(
    redeclare package Medium = Medium,
    length=11.87381314654729,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=102.88093609762403,
        origin={241.419,114.442})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136517(
    redeclare package Medium = Medium,
    length=19.096458079554452,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=268.71079106997826,
        origin={89.31812200375482,59.73096826111805})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65056499(
    redeclare package Medium = Medium,
    length=2.5271498035235944,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=26.285879755409393,
        origin={100.22763461983827,124.18646096227364})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136525(
    redeclare package Medium = Medium,
    length=13.751437749766591,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=172.1461996662833,
        origin={647.211,818.302})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136542(
    redeclare package Medium = Medium,
    length=28.783990857058694,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=173.171267850555,
        origin={680.335,538.621})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64973009(
    redeclare package Medium = Medium,
    length=17.456894594932496,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=296.28587975540574,
        origin={73.79201669436154,201.7984897650494})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136519(
    redeclare package Medium = Medium,
    length=6.808999925417844,
    diameter=0.125,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=352.1363874766592,
        origin={522.192,547.244})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64186419(
    redeclare package Medium = Medium,
    length=0.9000000000000282,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=352.1363874766566,
        origin={555.921,553.589})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64196414(
    redeclare package Medium = Medium,
    length=1.2910375054579482,
    diameter=0.1,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=262.13638747665823,
        origin={551.412,548.71})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64183610(
    redeclare package Medium = Medium,
    length=15.18956285715749,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=352.13638747665885,
        origin={623.205,544.296})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136541(
    redeclare package Medium = Medium,
    length=12.049656021478087,
    diameter=0.1,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=82.13826471784333,
        origin={525.656,362.218})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136522(
    redeclare package Medium = Medium,
    length=13.16857497799242,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=78.47096074174978,
        origin={622.495,215.888})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64406444(
    redeclare package Medium = Medium,
    length=9.801654205506187,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=348.4709607417499,
        origin={651.927,153.148})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64536457(
    redeclare package Medium = Medium,
    length=19.056737426352935,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=82.14619966628311,
        origin={600.696,905.928})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64576482(
    redeclare package Medium = Medium,
    length=0.8999999999999883,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=171.45049462704537,
        origin={607.932,986.187})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136527(
    redeclare package Medium = Medium,
    length=24.193791191649396,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=349.4505927644658,
        origin={712.098,966.923})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136515(
    redeclare package Medium = Medium,
    length=75.14839693491729,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=141.6425415510864,
        origin={448.84,1114.5})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64596463(
    redeclare package Medium = Medium,
    length=9.558801116985913,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=349.44057828087034,
        origin={852.176,940.829})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136518(
    redeclare package Medium = Medium,
    length=34.56251349606464,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=301.6550510575044,
        origin={945.923,845.722})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64686474(
    redeclare package Medium = Medium,
    length=3.1057214925314414,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=192.88093609762288,
        origin={243.026,166.229})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64686478(
    redeclare package Medium = Medium,
    length=3.832190439452423,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=12.880936097624192,
        origin={271.578,172.758})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136533(
    redeclare package Medium = Medium,
    length=19.082905760763538,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=170.50482497607643,
        origin={524.719573846839,1002.0416006938106})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136534(
    redeclare package Medium = Medium,
    length=30.076947788477685,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=273.6179142531919,
        origin={294.004,1116.66})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136536(
    redeclare package Medium = Medium,
    length=18.323667590582815,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=133.46625145326203,
        origin={53.21390233310751,191.8659444632234})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64976499(
    redeclare package Medium = Medium,
    length=0.8999999999999081,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=296.28587975540813,
        origin={108.11036103469962,132.31749280167764})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe65136520(
    redeclare package Medium = Medium,
    length=9.387039205049568,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=172.13638747665874,
        origin={571.869,407.186})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components.PipeMSL pipe64146415(
    redeclare package Medium = Medium,
    length=15.627494060500709,
    diameter=0.1,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03,
    nNodes=nNodes)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=262.1363874766586,
        origin={541.64,477.959})));

  parameter Integer nNodes=20 "Number of discrete flow volumes";
equation
  // Connections between supplies, pipes, and stations
  connect(stationA3041.port_a, pipe65136542.port_a)
    annotation(Line(points={{790.986,526.173},{690.264,537.432}},                                         color={0,127,255}));
  connect(stationA3009.port_a, pipe64973009.port_a)
    annotation(Line(points={{31.1562,267.873},{69.3635,210.764}},                                         color={0,127,255}));
  connect(supplysupply.port_b, pipe65136519.port_a)
    annotation(Line(points={{503.718,553.176},{512.286,548.612}},                                         color={0,127,255}));
  connect(pipe64536424.port_a, pipe65136539.port_a)
    annotation(Line(points={{579.199,750.081},{597.787,690.103}},                                         color={0,127,255}));
  connect(pipe64536424.port_b, pipe65136525.port_b)
    annotation(Line(points={{581.931,769.893},{637.305,819.668}},                                         color={0,127,255}));
  connect(pipe64536424.port_a, pipe65136540.port_a)
    annotation(Line(points={{579.199,750.081},{563.159,633.83}},                                          color={0,127,255}));
  connect(pipe64536424.port_b, pipe64536457.port_a)
    annotation(Line(points={{581.931,769.893},{599.33,896.022}},                                          color={0,127,255}));
  connect(pipe65136540.port_b, pipe64186419.port_a)
    annotation(Line(points={{560.425,614.018},{546.015,554.957}},                                         color={0,127,255}));
  connect(pipe65136540.port_b, pipe64196414.port_a)
    annotation(Line(points={{560.425,614.018},{552.78,558.616}},                                          color={0,127,255}));
  connect(pipe65136539.port_b, stationA1462.port_a)
    annotation(Line(points={{617.599,687.371},{633.959,685.734}},                                         color={0,127,255}));
  connect(pipe65136522.port_a, pipe64406433.port_b)
    annotation(Line(points={{620.496,206.09},{566.017,170.672}},                                          color={0,127,255}));
  connect(pipe64406433.port_a, pipe64346433.port_a)
    annotation(Line(points={{546.421,174.67},{437.759,183.829}},                                           color={0,127,255}));
  connect(pipe64406433.port_a, pipe64296433.port_a)
    annotation(Line(points={{546.421,174.67},{508.509,237.97}},                                            color={0,127,255}));
  connect(pipe65136521.port_a, pipe64346433.port_b)
    annotation(Line(points={{354.376,243.631},{417.759,183.799}},                                           color={0,127,255}));
  connect(pipe65136541.port_a, pipe64296433.port_b)
    annotation(Line(points={{524.288,352.312},{511.243,257.782}},                                           color={0,127,255}));
  connect(pipe65136521.port_a, pipe65136530.port_a)
    annotation(Line(points={{354.376,243.631},{330.848,181.121}},                                           color={0,127,255}));
  connect(pipe65136521.port_b, stationA1451.port_a)
    annotation(Line(points={{354.346,263.631},{344.257,325.557}},                                           color={0,127,255}));
  connect(pipe65136530.port_b, pipe64686478.port_b)
    annotation(Line(points={{310.966,178.947},{281.326,174.987}},                                            color={0,127,255}));
  connect(pipe65136530.port_b, pipe65136532.port_b)
    annotation(Line(points={{310.966,178.947},{298.502,127.59}},                                            color={0,127,255}));
  connect(pipe65136516.port_a, stationA2881.port_a)
    annotation(Line(points={{261.097,1114.86},{230.007,1007.99}},                                            color={0,127,255}));
  connect(pipe65136516.port_b, pipe65136534.port_a)
    annotation(Line(points={{264.901,1134.5},{293.373,1126.64}},                                             color={0,127,255}));
  connect(pipe65136516.port_b, pipe65136515.port_b)
    annotation(Line(points={{264.901,1134.5},{440.998,1120.71}},                                           color={0,127,255}));
  connect(pipe64822888.port_b, pipe65136533.port_a)
    annotation(Line(points={{561.666,993.142},{534.583,1000.39}},                                         color={0,127,255}));
  connect(pipe64822888.port_a, stationA2888.port_a)
    annotation(Line(points={{541.888,996.116},{489.379,1004.51}},                                           color={0,127,255}));
  connect(pipe64822888.port_b, pipe64576482.port_b)
    annotation(Line(points={{561.666,993.142},{598.043,987.674}},                                         color={0,127,255}));
  connect(pipe65136517.port_a, pipe65136537.port_b)
    annotation(Line(points={{89.5431,69.7284},{109.719,80.8794}},                                         color={0,127,255}));
  connect(pipe65136537.port_a, stationA2974.port_a)
    annotation(Line(points={{118.576,62.9475},{127.633,24.365}},                                            color={0,127,255}));
  connect(pipe65136541.port_a, pipe65136538.port_b)
    annotation(Line(points={{524.288,352.312},{472.874,318.149}},                                           color={0,127,255}));
  connect(pipe65136538.port_a, stationA2984.port_a)
    annotation(Line(points={{453.062,320.883},{397.238,329.205}},                                           color={0,127,255}));
  connect(pipe65136529.port_a, stationA2987.port_a)
    annotation(Line(points={{237.192,252.552},{213.036,314.456}},                                           color={0,127,255}));
  connect(pipe64686474.port_a, pipe65136529.port_b)
    annotation(Line(points={{252.774,168.458},{241.651,233.055}},                                             color={0,127,255}));
  connect(pipe65136531.port_a, pipe65136535.port_a)
    annotation(Line(points={{196.387,216.163},{169.206,147.768}},                                            color={0,127,255}));
  connect(pipe65056499.port_b, pipe65136535.port_b)
    annotation(Line(points={{109.194,128.615},{150.143,141.718}},                                            color={0,127,255}));
  connect(pipe65136531.port_b, stationA1429.port_a)
    annotation(Line(points={{191.929,235.659},{168.759,295.247}},                                            color={0,127,255}));
  connect(pipe65136531.port_a, pipe64746472.port_a)
    annotation(Line(points={{196.387,216.163},{210.152,158.711}},                                            color={0,127,255}));
  connect(pipe64746472.port_b, pipe64686474.port_b)
    annotation(Line(points={{229.648,163.169},{233.278,164}},                                                color={0,127,255}));
  connect(pipe64746472.port_b, pipe65136543.port_b)
    annotation(Line(points={{229.648,163.169},{239.19,124.19}},                                              color={0,127,255}));
  connect(pipe65136532.port_a, stationA3065.port_a)
    annotation(Line(points={{302.96,108.094},{304.114,61.3189}},                                           color={0,127,255}));
  connect(pipe64596463.port_b, pipe65136528.port_b)
    annotation(Line(points={{862.007,938.996},{880.604,873.127}},                                         color={0,127,255}));
  connect(pipe65136528.port_a, stationA3067.port_a)
    annotation(Line(points={{876.938,853.465},{855.696,795.157}},                                        color={0,127,255}));
  connect(pipe64596463.port_a, pipe65136526.port_b)
    annotation(Line(points={{842.345,942.662},{800.697,884.871}},                                        color={0,127,255}));
  connect(pipe65136526.port_a, stationA3068.port_a)
    annotation(Line(points={{797.031,865.209},{775.222,803.855}},                                        color={0,127,255}));
  connect(pipe64406444.port_b, pipe65136523.port_b)
    annotation(Line(points={{661.725,151.149},{702.473,193.916}},                                           color={0,127,255}));
  connect(pipe65136523.port_a, stationA3069.port_a)
    annotation(Line(points={{706.471,213.512},{706.473,264.55}},                                           color={0,127,255}));
  connect(pipe64406444.port_b, pipe65136524.port_b)
    annotation(Line(points={{661.725,151.149},{738.938,192.653}},                                          color={0,127,255}));
  connect(pipe65136524.port_a, stationA3070.port_a)
    annotation(Line(points={{752.882,206.991},{789.35,256.765}},                                           color={0,127,255}));
  connect(pipe65136543.port_a, stationA2629.port_a)
    annotation(Line(points={{243.648,104.694},{242.594,67.5774}},                                            color={0,127,255}));
  connect(pipe65136517.port_a, pipe65056499.port_a)
    annotation(Line(points={{89.5431,69.7284},{91.2617,119.758}},                                           color={0,127,255}));
  connect(pipe65136517.port_b, stationA3529.port_a)
    annotation(Line(points={{89.0931,49.7335},{77.9739,0}},                                 color={0,127,255}));
  connect(pipe65056499.port_b, pipe64976499.port_b)
    annotation(Line(points={{109.194,128.615},{112.539,123.352}},                                             color={0,127,255}));
  connect(pipe65136525.port_a, stationA3611.port_a)
    annotation(Line(points={{657.117,816.936},{694.719,812.369}},                                         color={0,127,255}));
  connect(pipe64183610.port_a, pipe65136542.port_b)
    annotation(Line(points={{613.299,545.664},{670.406,539.81}},                                          color={0,127,255}));
  connect(pipe64973009.port_b, pipe65136536.port_a)
    annotation(Line(points={{78.2205,192.833},{60.0932,184.608}},                                         color={0,127,255}));
  connect(pipe64973009.port_b, pipe64976499.port_a)
    annotation(Line(points={{78.2205,192.833},{103.682,141.283}},                                           color={0,127,255}));
  connect(pipe64146415.port_a, pipe65136519.port_b)
    annotation(Line(points={{543.008,487.865},{532.098,545.876}},                                         color={0,127,255}));
  connect(pipe64183610.port_a, pipe64186419.port_b)
    annotation(Line(points={{613.299,545.664},{565.827,552.221}},                                         color={0,127,255}));
  connect(pipe64146415.port_a, pipe64196414.port_b)
    annotation(Line(points={{543.008,487.865},{550.044,538.804}},                                         color={0,127,255}));
  connect(pipe64183610.port_b, stationA3610.port_a)
    annotation(Line(points={{633.111,542.928},{676.725,537.523}},                                         color={0,127,255}));
  connect(pipe65136520.port_b, pipe65136541.port_b)
    annotation(Line(points={{561.963,408.554},{527.024,372.124}},                                          color={0,127,255}));
  connect(pipe65136522.port_b, stationA3609.port_a)
    annotation(Line(points={{624.494,225.686},{623.606,272.358}},                                         color={0,127,255}));
  connect(pipe65136522.port_a, pipe64406444.port_a)
    annotation(Line(points={{620.496,206.09},{642.129,155.147}},                                           color={0,127,255}));
  connect(pipe64536457.port_b, pipe64576482.port_a)
    annotation(Line(points={{602.062,915.834},{617.821,984.7}},                                           color={0,127,255}));
  connect(pipe64536457.port_b, pipe65136527.port_a)
    annotation(Line(points={{602.062,915.834},{702.267,968.754}},                                        color={0,127,255}));
  connect(pipe64536457.port_b, pipe65136515.port_a)
    annotation(Line(points={{602.062,915.834},{456.682,1108.29}},                                         color={0,127,255}));
  connect(pipe64596463.port_a, pipe65136527.port_b)
    annotation(Line(points={{842.345,942.662},{721.929,965.092}},                                        color={0,127,255}));
  connect(pipe64596463.port_b, pipe65136518.port_a)
    annotation(Line(points={{862.007,938.996},{940.675,854.234}},                                         color={0,127,255}));
  connect(pipe65136518.port_b, stationA2468.port_a)
    annotation(Line(points={{951.171,837.21},{990,760.009}},                                  color={0,127,255}));
  connect(pipe64686474.port_a, pipe64686478.port_a)
    annotation(Line(points={{252.774,168.458},{261.83,170.529}},                                              color={0,127,255}));
  connect(pipe65136533.port_b, stationA1477.port_a)
    annotation(Line(points={{514.857,1003.69},{435.264,1015.33}},                                         color={0,127,255}));
  connect(pipe65136534.port_b, stationA1455.port_a)
    annotation(Line(points={{294.635,1106.68},{292.016,991.938}},                                            color={0,127,255}));
  connect(pipe65136536.port_b, stationA1447.port_a)
    annotation(Line(points={{46.3346,199.124},{-10,248.008}},                                color={0,127,255}));
  connect(pipe65136520.port_a, stationA1465.port_a)
    annotation(Line(points={{581.775,405.818},{601.124,403.764}},                                          color={0,127,255}));
  connect(pipe65136520.port_b, pipe64146415.port_b)
    annotation(Line(points={{561.963,408.554},{540.272,468.053}},                                         color={0,127,255}));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{0.0,0.0},{1000.0,1245.3740344293326}})),
              experiment(
      StartTime=7000,
      StopTime=8000,
      Interval=1,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>This model represents a generic district heating network auto-generated with the Python packages <em>uesgraphs</em> and <em>uesmodels</em>. </p>
<p>The building positions are taken from OpenStreetMap data for a district in the city of Aachen (The data can be queried from <a href=\"http://www.openstreetmap.org/#map=17/50.78237/6.05746\">http://www.openstreetmap.org/#map=17/50.78237/6.05746</a>). The package <em>uesgraphs</em> imports this data into a Python graph representation including the street network. The heating network is added with a simple algorithm following the street layout to connect 25 buildings to a given supply node. The pipe diameters are designed so that they approach a specific pressure drop of 200 Pa/m for the given maximum heat load of each building for a dT of 20 K between a network supply temperature of 60 degC and a return temperature of 40 degC.</p>
<p>The heat demands of the buildings are taken from a building simulation based on an archetype building model of a residential building. The building model was created using TEASER (<a href=\"https://github.com/RWTH-EBC/TEASER\">https://github.com/RWTH-EBC/TEASER</a>) and AixLib (<a href=\"https://github.com/RWTH-EBC/AixLib\">https://github.com/RWTH-EBC/AixLib</a>). The buildings&#39; peak load is 48.379 kW. The same heat demand is used for each of the 25 buildings.</p>
<p>The Modelica model is auto-generated from the <em>uesgraphs</em> representation of the network using the Python package <em>uesmodels</em>.</p>
</html>", revisions="<html>
<ul>
<li>December 12, 2016 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=true),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end AachenGeneric;
