within IBPSA.Utilities.IO.SDF.Examples;
model Playback "Play back recorded signals using the TimeTable block"
  extends Modelica.Icons.Example;

  TimeTable timeTable(
    datasetUnits={"rad","rad/s"},
    scaleUnit="s",
    datasetNames={"/inertia1/phi","/inertia1/w"},
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Utilities/IO/SDF/Resources/Data/Examples/PID_Controller.mat"))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=4));
end Playback;
