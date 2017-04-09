within Annex60.Experimental.Pipe.Examples.UseCaseAachen;
model AachenGenericVol
  "Model automatically generated with uesmodels at 2017-02-05 15:56:43.325662"

  parameter Modelica.SIunits.Temperature T_amb = 283.15
    "Ambient temperature around pipes";

  package Medium = Annex60.Media.Water(T_default=273.15+70);


  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.SupplySource supplysupply(
    redeclare package Medium = Medium,
    p_supply=1000000)
      annotation(Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={477.82371795974933,535.3679056576435})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT3041(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={775.1998673382183,509.2338961807383})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT3009(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={39.83128723219811,259.24935089023495})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT1429(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={173.004250327833,285.74248422650317})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT2468(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={967.8070238348805,735.542392291404})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT1447(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={0.0,240.0237766749043})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT1462(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={623.2281517887191,663.658232552155})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT1465(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={591.4504522008414,390.76594835351125})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT1477(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={430.9297728051536,982.6444734169611})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT3529(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={85.14175075720297,0.0})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT3609(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={613.2079215495568,263.58990614349204})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT3610(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={664.6176529620083,520.2185527496792})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT1455(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={292.2929623573431,960.0050000857885})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT1451(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={342.8519459101672,315.07636887225345})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT2881(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={232.28017583980923,975.5352304976564})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT2888(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={483.3029736794526,972.1685201299514})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT2974(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={133.20220890167278,23.580622961512873})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT2984(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={394.1277374615087,318.60645328222654})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT2987(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={215.85584966423588,304.33259097425906})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT3065(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={304.001903507993,59.34488483755339})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT3067(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={837.8265924553958,769.5586417536715})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT3068(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={759.9429027442226,777.9768667573959})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT3069(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={693.4075762136297,256.0330441529304})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT3070(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={773.6161529819369,248.49932810877232})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT2629(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={244.4618690913427,65.40186634978325})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.DemandSink stationT3611(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={682.0316284728444,786.2167031638702})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64536424(
    redeclare package Medium = Medium,
    length=15.841391502597723,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=82.14619966628335,
      origin={561.8750684703712,737.4561604154314})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10111068(
    redeclare package Medium = Medium,
    length=16.69461089480488,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.14262050959576,
      origin={543.7065114912077,605.7735754111479})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10561068(
    redeclare package Medium = Medium,
    length=8.67207429947886,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=352.14619966628396,
      origin={588.1296108132202,668.4997146425538})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64406433(
    redeclare package Medium = Medium,
    length=13.336702541819008,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=348.47096074174937,
      origin={538.3122916100509,169.04751669134967})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64346433(
    redeclare package Medium = Medium,
    length=17.361931556578437,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=180.08560445223117,
      origin={413.9885133921283,179.8319207939404})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64296433(
    redeclare package Medium = Medium,
    length=15.292538353453127,
    diameter=0.1,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=82.14527038648446,
      origin={493.461442855155,241.83135081700607})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10731071(
    redeclare package Medium = Medium,
    length=16.564225427355726,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90.08560445223137,
      origin={342.9530581396753,247.4011540181643})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10371071(
    redeclare package Medium = Medium,
    length=8.046833022932352,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=186.24105697717522,
      origin={310.57587403179184,176.17411731843916})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10741043(
    redeclare package Medium = Medium,
    length=34.926499759191024,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=79.03699005971923,
      origin={254.53231994938372,1090.4084841599733})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64822888(
    redeclare package Medium = Medium,
    length=12.551494711088933,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=351.450494627037,
      origin={534.0138895497655,964.5449226827118})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10761004(
    redeclare package Medium = Medium,
    length=12.56231505592064,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=116.28587975540567,
      origin={110.47293490320962,69.59836210432482})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10771015(
    redeclare package Medium = Medium,
    length=13.326460255229593,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=352.1452703864843,
      origin={448.06388337837274,311.16562624621645})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10341078(
    redeclare package Medium = Medium,
    length=17.411165392313602,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=282.8809360976238,
      origin={231.7138023872644,234.9871142624779})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10791047(
    redeclare package Medium = Medium,
    length=12.47474834331793,
    diameter=0.065,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=197.60893772723173,
      origin={154.53406734490747,140.08320348561634})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10531079(
    redeclare package Medium = Medium,
    length=16.362420231930344,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=102.88093609762393,
      origin={187.90701419376168,220.57396703795166})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64746472(
    redeclare package Medium = Medium,
    length=2.5136658321401453,
    diameter=0.065,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=12.880936097622678,
      origin={212.82124779742702,157.69487695145756})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10811037(
    redeclare package Medium = Medium,
    length=14.220766986581868,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=102.88093609762383,
      origin={291.0497406011966,115.98359015517832})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10821031(
    redeclare package Medium = Medium,
    length=16.900704637832263,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=79.44057828087047,
      origin={850.4803652687585,837.4393258354451})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10831029(
    redeclare package Medium = Medium,
    length=17.634609005399696,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=79.44057828087051,
      origin={773.1461591047471,848.8052344765464})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10841020(
    redeclare package Medium = Medium,
    length=14.22406441423505,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=258.4709607417494,
      origin={681.7925950990254,199.0913253981074})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10851020(
    redeclare package Medium = Medium,
    length=23.602789930678952,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=225.79502906016575,
      origin={721.8968834831792,195.32446737602834})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10031036(
    redeclare package Medium = Medium,
    length=11.87381314654729,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=102.88093609762406,
      origin={233.64729331325316,112.69308520164914})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10591004(
    redeclare package Medium = Medium,
    length=19.096458079554452,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=268.71079106997826,
      origin={86.44270583097472,57.808050623568384})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe65056499(
    redeclare package Medium = Medium,
    length=2.5271498035235944,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=26.285879755409347,
      origin={97.00100876743551,120.18852918448465})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10251007(
    redeclare package Medium = Medium,
    length=13.751437749766591,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=172.1461996662833,
      origin={626.3753477879327,793.8939136308902})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10081014(
    redeclare package Medium = Medium,
    length=28.783990857058694,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=173.17126785055504,
      origin={658.4333998129936,523.216845550175})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64973009(
    redeclare package Medium = Medium,
    length=17.456894594932496,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=296.28587975540574,
      origin={71.41643205974384,195.30199579388608})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10641010(
    redeclare package Medium = Medium,
    length=6.808999925417844,
    diameter=0.125,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=352.13638747665925,
      origin={505.38117487189743,531.5618291511664})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64186419(
    redeclare package Medium = Medium,
    length=0.9000000000000282,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=352.1363874766566,
      origin={538.0244427162315,537.7028745044774})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64196414(
    redeclare package Medium = Medium,
    length=1.2910375054579482,
    diameter=0.1,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766583,
      origin={533.6602924643698,532.9808533670164})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64183610(
    redeclare package Medium = Medium,
    length=15.18956285715749,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=352.13638747665885,
      origin={603.1422926248886,528.7091738346454})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10651015(
    redeclare package Medium = Medium,
    length=12.049656021478087,
    diameter=0.1,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=82.13826471784331,
      origin={508.73391584581066,352.4925157667411})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10181061(
    redeclare package Medium = Medium,
    length=13.16857497799242,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=78.47096074174982,
      origin={602.4548241772927,210.87351855119283})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64406444(
    redeclare package Medium = Medium,
    length=9.801654205506187,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=348.4709607417499,
      origin={630.939670394725,150.15336880108902})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64536457(
    redeclare package Medium = Medium,
    length=19.056737426352935,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=82.1461996662831,
      origin={581.358142572736,878.6995776050908})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64576482(
    redeclare package Medium = Medium,
    length=0.8999999999999883,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=171.45049462704398,
      origin={588.3610117312647,956.374678173872})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10271029(
    redeclare package Medium = Medium,
    length=24.193791191649396,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=349.4505927644658,
      origin={689.1733167538613,937.7308166539842})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10271043(
    redeclare package Medium = Medium,
    length=75.14839693491729,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=141.6425415510864,
      origin={434.3908410507046,1080.554884467281})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64596463(
    redeclare package Medium = Medium,
    length=9.558801116985913,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=349.4405782808703,
      origin={824.7417767736964,912.4768060564577})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10311054(
    redeclare package Medium = Medium,
    length=34.562513496064646,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=301.6550510575044,
      origin={915.4705809585008,820.4312011043113})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64686474(
    redeclare package Medium = Medium,
    length=3.1057214925314414,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=192.8809360976228,
      origin={235.20223632272828,162.81297080210584})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64686478(
    redeclare package Medium = Medium,
    length=3.832190439452423,
    diameter=0.08,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=12.88093609762426,
      origin={262.8346664023466,169.13196651174997})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10581039(
    redeclare package Medium = Medium,
    length=19.082905760763538,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=170.50482497607652,
      origin={507.82728911261603,969.7828993262167})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10431063(
    redeclare package Medium = Medium,
    length=30.076947788477685,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=273.6179142531919,
      origin={284.5387132081506,1082.6433689540395})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10451055(
    redeclare package Medium = Medium,
    length=18.323667590582815,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=133.46625145326203,
      origin={51.500788443644794,185.68920868622075})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64976499(
    redeclare package Medium = Medium,
    length=0.8999999999999081,
    diameter=0.05,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=296.28587975540813,
      origin={104.62996675870707,128.0577989096849})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe10571065(
    redeclare package Medium = Medium,
    length=9.387039205049568,
    diameter=0.04,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=172.13638747665877,
      origin={553.4591272986129,396.0130903383935})));

  Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components.PipeA60Core pipe64146415(
    redeclare package Medium = Medium,
    length=15.627494060500709,
    diameter=0.1,
    T_amb=T_amb,
    m_flow_nominal=1,
    thicknessIns=0.05,
    lambdaIns=0.03)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={524.203217090215,464.5079924839826})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6453(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={570.7190671030211,801.5711240979103})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6457(
    redeclare package Medium = Medium,
    nPorts=4,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={591.997218042451,955.8280311122714})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6459(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={786.3494154652717,919.6336021956969})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6463(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={863.1341380821211,905.3200099172186})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6468(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={247.5717551102929,165.64163755069671})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6474(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={222.83271753516365,159.984304053515})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6478(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={278.0975776944003,172.62229547280324})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6482(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={584.7248054200785,956.9213252354723})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6490(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={276.7844640589581,1205.2817378222906})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6497(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={103.00157688728959,131.3546406975372})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6499(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={106.25835663012457,124.76095712183255})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6414(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={532.9386317840456,527.7557526446894})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6415(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={515.4678023963845,401.2602323232758})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6424(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={553.0310698377214,673.3411967329527})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6433(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={484.92285641507317,179.93790242380575})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6434(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={343.0541703691834,179.72593916407507})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6472(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={202.80977805969036,155.40544984940013})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6505(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={87.74366090474645,115.61610124713675})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6419(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={534.3819531446941,538.2059540893432})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6418(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={541.666932287769,537.1997949196116})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6429(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={502.0000292952368,303.7247992102064})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6440(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={591.7017268050287,158.15713095889365})));

  Annex60.Fluid.MixingVolumes.MixingVolume junction6444(
    redeclare package Medium = Medium,
    nPorts=3,
    V=0.05,
    m_flow_nominal=2)
      annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=262.1363874766586,
      origin={670.1776139844213,142.14960664328436})));


equation
  // Connections between supplies, pipes, and stations
  connect(stationT3041.port_a, pipe10081014.port_a)
    annotation(Line(points={{765.2,509.234},{668.362,522.028}},                                          color={0,127,255}));
  connect(stationT3009.port_a, pipe64973009.port_a)
    annotation(Line(points={{29.8313,259.249},{66.9879,204.268}},                                           color={0,127,255}));
  connect(supplysupply.port_b, pipe10641010.port_a)
    annotation(Line(points={{487.824,535.368},{495.475,532.93}},                                            color={0,127,255}));
  connect(junction6453.ports[1], pipe64536424.port_b)
    annotation(Line(points={{561.178,805.581},{563.241,747.362}},                                         color={0,127,255}));
  connect(junction6453.ports[2], pipe64536457.port_a)
    annotation(Line(points={{560.813,802.939},{579.992,868.794}},                                        color={0,127,255}));
  connect(junction6453.ports[3], pipe10251007.port_b)
    annotation(Line(points={{560.448,800.298},{616.469,795.26}},                                          color={0,127,255}));
  connect(junction6457.ports[1], pipe64536457.port_b)
    annotation(Line(points={{582.502,960.168},{582.724,888.606}},                                       color={0,127,255}));
  connect(junction6457.ports[2], pipe64576482.port_a)
    annotation(Line(points={{582.228,958.187},{598.25,954.888}},                                        color={0,127,255}));
  connect(junction6457.ports[3], pipe10271029.port_a)
    annotation(Line(points={{581.954,956.206},{679.342,939.562}},                                        color={0,127,255}));
  connect(junction6457.ports[4], pipe10271043.port_a)
    annotation(Line(points={{581.681,954.224},{442.233,1074.34}},                                        color={0,127,255}));
  connect(junction6459.ports[1], pipe64596463.port_a)
    annotation(Line(points={{776.808,923.643},{814.911,914.31}},                                          color={0,127,255}));
  connect(junction6459.ports[2], pipe10831029.port_b)
    annotation(Line(points={{776.443,921.002},{774.979,858.636}},                                         color={0,127,255}));
  connect(junction6459.ports[3], pipe10271029.port_b)
    annotation(Line(points={{776.079,918.36},{699.004,935.9}},                                            color={0,127,255}));
  connect(junction6463.ports[1], pipe64596463.port_b)
    annotation(Line(points={{853.593,909.33},{834.573,910.644}},                                          color={0,127,255}));
  connect(junction6463.ports[2], pipe10311054.port_a)
    annotation(Line(points={{853.228,906.688},{910.223,828.943}},                                         color={0,127,255}));
  connect(junction6463.ports[3], pipe10821031.port_b)
    annotation(Line(points={{852.863,904.047},{852.313,847.27}},                                          color={0,127,255}));
  connect(junction6468.ports[1], pipe64686474.port_a)
    annotation(Line(points={{238.031,169.651},{244.95,165.042}},                                             color={0,127,255}));
  connect(junction6468.ports[2], pipe64686478.port_a)
    annotation(Line(points={{237.666,167.01},{253.087,166.903}},                                            color={0,127,255}));
  connect(junction6468.ports[3], pipe10341078.port_b)
    annotation(Line(points={{237.301,164.368},{233.943,225.239}},                                          color={0,127,255}));
  connect(junction6474.ports[1], pipe64746472.port_b)
    annotation(Line(points={{213.292,163.994},{222.569,159.924}},                                           color={0,127,255}));
  connect(junction6474.ports[2], pipe64686474.port_b)
    annotation(Line(points={{212.927,161.352},{225.454,160.584}},                                           color={0,127,255}));
  connect(junction6474.ports[3], pipe10031036.port_b)
    annotation(Line(points={{212.562,158.711},{231.418,122.441}},                                           color={0,127,255}));
  connect(junction6478.ports[1], pipe10371071.port_b)
    annotation(Line(points={{268.556,176.632},{300.635,175.087}},                                            color={0,127,255}));
  connect(junction6478.ports[2], pipe10811037.port_b)
    annotation(Line(points={{268.192,173.99},{288.821,125.732}},                                            color={0,127,255}));
  connect(junction6478.ports[3], pipe64686478.port_b)
    annotation(Line(points={{267.827,171.349},{272.583,171.361}},                                           color={0,127,255}));
  connect(junction6482.ports[1], pipe64822888.port_b)
    annotation(Line(points={{575.184,960.931},{543.903,963.058}},                                         color={0,127,255}));
  connect(junction6482.ports[2], pipe10581039.port_a)
    annotation(Line(points={{574.819,958.289},{517.69,968.133}},                                           color={0,127,255}));
  connect(junction6482.ports[3], pipe64576482.port_b)
    annotation(Line(points={{574.454,955.648},{578.472,957.862}},                                        color={0,127,255}));
  connect(junction6490.ports[1], pipe10741043.port_b)
    annotation(Line(points={{267.243,1209.29},{256.434,1100.23}},                                            color={0,127,255}));
  connect(junction6490.ports[2], pipe10431063.port_a)
    annotation(Line(points={{266.878,1206.65},{283.908,1092.62}},                                           color={0,127,255}));
  connect(junction6490.ports[3], pipe10271043.port_b)
    annotation(Line(points={{266.514,1204.01},{426.549,1086.76}},                                          color={0,127,255}));
  connect(junction6497.ports[1], pipe64973009.port_b)
    annotation(Line(points={{93.4605,135.364},{75.8449,186.336}},                                           color={0,127,255}));
  connect(junction6497.ports[2], pipe10451055.port_a)
    annotation(Line(points={{93.0956,132.723},{58.3801,178.431}},                                            color={0,127,255}));
  connect(junction6497.ports[3], pipe64976499.port_a)
    annotation(Line(points={{92.7308,130.081},{100.201,137.024}},                                           color={0,127,255}));
  connect(junction6499.ports[1], pipe65056499.port_b)
    annotation(Line(points={{96.7172,128.771},{105.967,124.618}},                                            color={0,127,255}));
  connect(junction6499.ports[2], pipe64976499.port_b)
    annotation(Line(points={{96.3524,126.129},{109.059,119.092}},                                            color={0,127,255}));
  connect(junction6499.ports[3], pipe10791047.port_b)
    annotation(Line(points={{95.9875,123.488},{145.003,137.058}},                                             color={0,127,255}));
  connect(junction6414.ports[1], pipe64146415.port_a)
    annotation(Line(points={{523.398,531.765},{525.571,474.414}},                                        color={0,127,255}));
  connect(junction6414.ports[2], pipe10641010.port_b)
    annotation(Line(points={{523.033,529.124},{515.287,530.194}},                                          color={0,127,255}));
  connect(junction6414.ports[3], pipe64196414.port_b)
    annotation(Line(points={{522.668,526.482},{532.292,523.075}},                                         color={0,127,255}));
  connect(junction6415.ports[1], pipe10571065.port_b)
    annotation(Line(points={{505.927,405.27},{543.553,397.381}},                                          color={0,127,255}));
  connect(junction6415.ports[2], pipe10651015.port_b)
    annotation(Line(points={{505.562,402.628},{510.102,362.399}},                                          color={0,127,255}));
  connect(junction6415.ports[3], pipe64146415.port_b)
    annotation(Line(points={{505.197,399.987},{522.835,454.602}},                                        color={0,127,255}));
  connect(junction6424.ports[1], pipe64536424.port_a)
    annotation(Line(points={{543.49,677.351},{560.509,727.55}},                                           color={0,127,255}));
  connect(junction6424.ports[2], pipe10111068.port_a)
    annotation(Line(points={{543.125,674.709},{545.074,615.68}},                                          color={0,127,255}));
  connect(junction6424.ports[3], pipe10561068.port_a)
    annotation(Line(points={{542.76,672.068},{578.224,669.866}},                                          color={0,127,255}));
  connect(junction6433.ports[1], pipe64406433.port_a)
    annotation(Line(points={{475.382,183.948},{528.514,171.047}},                                            color={0,127,255}));
  connect(junction6433.ports[2], pipe64346433.port_a)
    annotation(Line(points={{475.017,181.306},{423.989,179.847}},                                           color={0,127,255}));
  connect(junction6433.ports[3], pipe64296433.port_a)
    annotation(Line(points={{474.652,178.664},{492.094,231.925}},                                           color={0,127,255}));
  connect(junction6434.ports[1], pipe10731071.port_a)
    annotation(Line(points={{333.513,183.736},{342.968,237.401}},                                          color={0,127,255}));
  connect(junction6434.ports[2], pipe10371071.port_a)
    annotation(Line(points={{333.148,181.094},{320.517,177.261}},                                            color={0,127,255}));
  connect(junction6434.ports[3], pipe64346433.port_b)
    annotation(Line(points={{332.783,178.453},{403.989,179.817}},                                          color={0,127,255}));
  connect(junction6472.ports[1], pipe10531079.port_a)
    annotation(Line(points={{193.269,159.415},{190.136,210.826}},                                             color={0,127,255}));
  connect(junction6472.ports[2], pipe64746472.port_a)
    annotation(Line(points={{192.904,156.774},{203.073,155.466}},                                             color={0,127,255}));
  connect(junction6472.ports[3], pipe10791047.port_a)
    annotation(Line(points={{192.539,154.132},{164.065,143.108}},                                             color={0,127,255}));
  connect(junction6505.ports[1], pipe10591004.port_a)
    annotation(Line(points={{78.2025,119.626},{86.6677,67.8056}},                                           color={0,127,255}));
  connect(junction6505.ports[2], pipe65056499.port_a)
    annotation(Line(points={{77.8377,116.984},{88.035,115.76}},                                             color={0,127,255}));
  connect(junction6505.ports[3], pipe10761004.port_b)
    annotation(Line(points={{77.4729,114.343},{106.044,78.5644}},                                           color={0,127,255}));
  connect(junction6419.ports[1], pipe10111068.port_b)
    annotation(Line(points={{524.841,542.216},{542.34,595.868}},                                          color={0,127,255}));
  connect(junction6419.ports[2], pipe64186419.port_a)
    annotation(Line(points={{524.476,539.574},{528.118,539.071}},                                         color={0,127,255}));
  connect(junction6419.ports[3], pipe64196414.port_a)
    annotation(Line(points={{524.111,536.933},{535.028,542.887}},                                         color={0,127,255}));
  connect(junction6418.ports[1], pipe64183610.port_a)
    annotation(Line(points={{532.126,541.21},{593.236,530.077}},                                         color={0,127,255}));
  connect(junction6418.ports[2], pipe10081014.port_b)
    annotation(Line(points={{531.761,538.568},{648.504,524.406}},                                       color={0,127,255}));
  connect(junction6418.ports[3], pipe64186419.port_b)
    annotation(Line(points={{531.396,535.926},{547.93,536.335}},                                         color={0,127,255}));
  connect(junction6429.ports[1], pipe10651015.port_a)
    annotation(Line(points={{492.459,307.735},{507.366,342.587}},                                          color={0,127,255}));
  connect(junction6429.ports[2], pipe10771015.port_b)
    annotation(Line(points={{492.094,305.093},{457.97,309.799}},                                            color={0,127,255}));
  connect(junction6429.ports[3], pipe64296433.port_b)
    annotation(Line(points={{491.729,302.451},{494.828,251.737}},                                         color={0,127,255}));
  connect(junction6440.ports[1], pipe10181061.port_a)
    annotation(Line(points={{582.161,162.167},{600.456,201.076}},                                           color={0,127,255}));
  connect(junction6440.ports[2], pipe64406444.port_a)
    annotation(Line(points={{581.796,159.525},{621.142,152.152}},                                          color={0,127,255}));
  connect(junction6440.ports[3], pipe64406433.port_b)
    annotation(Line(points={{581.431,156.884},{548.11,167.049}},                                            color={0,127,255}));
  connect(junction6444.ports[1], pipe64406444.port_b)
    annotation(Line(points={{660.636,146.159},{640.738,148.154}},                                          color={0,127,255}));
  connect(junction6444.ports[2], pipe10841020.port_b)
    annotation(Line(points={{660.272,143.518},{679.794,189.293}},                                          color={0,127,255}));
  connect(junction6444.ports[3], pipe10851020.port_b)
    annotation(Line(points={{659.907,140.876},{714.925,188.155}},                                           color={0,127,255}));
  connect(pipe10561068.port_b, stationT1462.port_a)
    annotation(Line(points={{598.036,667.133},{613.228,663.658}},                                        color={0,127,255}));
  connect(pipe10731071.port_b, stationT1451.port_a)
    annotation(Line(points={{342.938,257.401},{332.852,315.076}},                                          color={0,127,255}));
  connect(pipe10741043.port_a, stationT2881.port_a)
    annotation(Line(points={{252.631,1080.59},{222.28,975.535}},                                             color={0,127,255}));
  connect(pipe64822888.port_a, stationT2888.port_a)
    annotation(Line(points={{524.125,966.032},{473.303,972.169}},                                         color={0,127,255}));
  connect(pipe10761004.port_a, stationT2974.port_a)
    annotation(Line(points={{114.901,60.6324},{123.202,23.5806}},                                            color={0,127,255}));
  connect(pipe10771015.port_a, stationT2984.port_a)
    annotation(Line(points={{438.158,312.532},{384.128,318.606}},                                            color={0,127,255}));
  connect(pipe10341078.port_a, stationT2987.port_a)
    annotation(Line(points={{229.485,244.735},{205.856,304.333}},                                           color={0,127,255}));
  connect(pipe10531079.port_b, stationT1429.port_a)
    annotation(Line(points={{185.678,230.322},{163.004,285.742}},                                           color={0,127,255}));
  connect(pipe10811037.port_a, stationT3065.port_a)
    annotation(Line(points={{293.279,106.235},{294.002,59.3449}},                                         color={0,127,255}));
  connect(pipe10821031.port_a, stationT3067.port_a)
    annotation(Line(points={{848.648,827.609},{827.827,769.559}},                                         color={0,127,255}));
  connect(pipe10831029.port_a, stationT3068.port_a)
    annotation(Line(points={{771.314,838.975},{749.943,777.977}},                                         color={0,127,255}));
  connect(pipe10841020.port_a, stationT3069.port_a)
    annotation(Line(points={{683.791,208.89},{683.408,256.033}},                                          color={0,127,255}));
  connect(pipe10851020.port_a, stationT3070.port_a)
    annotation(Line(points={{728.869,202.493},{763.616,248.499}},                                           color={0,127,255}));
  connect(pipe10031036.port_a, stationT2629.port_a)
    annotation(Line(points={{235.877,102.945},{234.462,65.4019}},                                           color={0,127,255}));
  connect(pipe10591004.port_b, stationT3529.port_a)
    annotation(Line(points={{86.2177,47.8106},{75.1418,0}},                                  color={0,127,255}));
  connect(pipe10251007.port_a, stationT3611.port_a)
    annotation(Line(points={{636.282,792.527},{672.032,786.217}},                                         color={0,127,255}));
  connect(pipe64183610.port_b, stationT3610.port_a)
    annotation(Line(points={{613.048,527.341},{654.618,520.219}},                                         color={0,127,255}));
  connect(pipe10181061.port_b, stationT3609.port_a)
    annotation(Line(points={{604.453,220.672},{603.208,263.59}},                                            color={0,127,255}));
  connect(pipe10311054.port_b, stationT2468.port_a)
    annotation(Line(points={{920.719,811.919},{957.807,735.542}},                                        color={0,127,255}));
  connect(pipe10581039.port_b, stationT1477.port_a)
    annotation(Line(points={{497.964,971.433},{420.93,982.644}},                                           color={0,127,255}));
  connect(pipe10431063.port_b, stationT1455.port_a)
    annotation(Line(points={{285.17,1072.66},{282.293,960.005}},                                           color={0,127,255}));
  connect(pipe10451055.port_b, stationT1447.port_a)
    annotation(Line(points={{44.6215,192.947},{-10,240.024}},                                 color={0,127,255}));
  connect(pipe10571065.port_a, stationT1465.port_a)
    annotation(Line(points={{563.365,394.645},{581.45,390.766}},                                           color={0,127,255}));



  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{0.0,0.0},{967.8070238348805,1205.2817378222906}})),
              uses(AixLib, uesdhc(version="0.1.0")),
              experiment(
                StopTime=31536000,
                Interval=3600,
                Tolerance=0.0001,
                __Dymola_Algorithm="Dassl"));
end AachenGenericVol;
