within IBPSA.Fluid.Chillers.BlackBoxData;
package EuropeanNorm2DData "Package with data according to EN 14511"
  record ChillerBaseDataDefinition "Basic chiller data"
      extends
      IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
                                                                  tableQCon_flow = tableQdot_eva);

    parameter Real tableQdot_eva[:,:] "Cooling power table; T in degC; Q_flow in W";

    annotation (Documentation(info="<html><p>
  Base data definition extending from the <a href=
  \"modelica://IBPSA.DataBase.HeatPump.HeatPumpBaseDataDefinition\">HeatPumpBaseDataDefinition</a>,
  the parameters documentation is matched for a chiller. As a result,
  <span style=\"font-family: Courier New;\">tableQdot_eva</span>
  corresponds to the cooling capacity on the evaporator side of the
  chiller. Furthermore, the values of the tables depend on the
  condenser inlet temperature (defined in first row) and the evaporator
  outlet temperature (defined in first column) in W.
</p>
<p>
  The nominal mass flow rate in the condenser and evaporator are also
  defined as parameters.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"),
     Icon);
  end ChillerBaseDataDefinition;

  package EN14511

    record Vitocal200AWO201 "Vitocal200AWO201Chilling"
      extends
        IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2DData.ChillerBaseDataDefinition(
        device_id="Vitocal200AWO2201",
        tablePel=[0,20,25,27,30,35; 7,1380.0,1590.0,1680.0,1800.0,1970.0; 18,
            950.0,1060.0,1130.0,1200.0,1350.0],
        tableQdot_eva=[0,20,25,27,30,35; 7,2540.0,2440.0,2370.0,2230.0,2170.0;
            18,5270.0,5060.0,4920.0,4610.0,4500.0],
        mCon_flow_nominal=3960/4180/5,
        mEva_flow_nominal=(2250*1.2)/3600,
        tableUppBou=[20,20; 35,20]);

      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false)),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html><p>
  Data&#160;record&#160;for&#160;type&#160;AWO-M/AWO-M-E-AC&#160;201.A04,
  obtained from the technical guide in the UK. <a href=
  \"https://professionals.viessmann.co.uk/content/dam/vi-brands/UK/PDFs/Datasheets/Vitocal%20Technical%20Guide.PDF/_jcr_content/renditions/original.media_file.download_attachment.file/Vitocal%20Technical%20Guide.PDF\">
  Link</a> to the datasheet
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
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>",   info="<html>
<p>This package contains data records for chiller data according to European Norm 14511.</p>
</html>"));
  end EN14511;
end EuropeanNorm2DData;
