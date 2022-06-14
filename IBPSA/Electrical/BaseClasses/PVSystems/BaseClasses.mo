within IBPSA.Electrical.BaseClasses.PVSystems;
package BaseClasses "Base parameters for PV Model"
  extends Modelica.Icons.BasesPackage;

  partial model PartialPVElectrical
    "Partial electrical model for PV module model"
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialPVElectrical;

  partial model PartialPVThermal
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialPVThermal;

  partial model PartialPVOptical
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialPVOptical;
end BaseClasses;
