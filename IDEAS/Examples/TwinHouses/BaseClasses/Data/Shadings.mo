within IDEAS.Examples.TwinHouses.BaseClasses.Data;
package Shadings "Package containing the records for the shading devices"

  model ShaWin1 "Shading device for window type 1"
    extends Buildings.Components.Shading.Interfaces.ShadingProperties(shaType=IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.BoxAndScreen,hWin=1.30,wWin=0.99,wLeft=0.1,wRight=0.1,ovDep=0.15,ovGap=0.11,hFin=0.10,finDep=0.15,finGap=0.1,shaCorr=0.24,controlled=true);
  end ShaWin1;

  model ShaWin2 "Shading device for window type 2"
    extends Buildings.Components.Shading.Interfaces.ShadingProperties(shaType=IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.BoxAndScreen,hWin=2.40,wWin=0.88,wLeft=0.1,wRight=3,ovDep=0.15,ovGap=0.11,hFin=0.10,finDep=0.15,finGap=0.1,shaCorr=0.24,controlled=true);
  end ShaWin2;

  model ShaWin3 "Shading device for window type 3"
    extends Buildings.Components.Shading.Interfaces.ShadingProperties(shaType=IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.BoxAndScreen,hWin=1.40,wWin=3.3,wLeft=1.2,wRight=0.1,ovDep=0.15,ovGap=0.11,hFin=0.10,finDep=0.15,finGap=0.1,shaCorr=0.24,controlled=true);
  end ShaWin3;

  model controlBlind

    Modelica.Blocks.Interfaces.RealOutput[3] y "outputs 1: south oriented windows , 2: north zones, 3: other"
      annotation (Placement(transformation(extent={{92,-10},{112,10}})));
    parameter Integer Exp = 1 "Parameter to select correct experiment (default =1)";
    parameter Integer BuildCase = 1  "Parameter to select the building case. 1: N2 , 2:O5 (default=1)";
  equation
    if Exp==1 and BuildCase==2 then
      if time <=20044800+2*3600*24 then
        y[1]=1;
      elseif time >20044800+2*3600*24 and time <= 20044800+24*3600*23 then
        y[1]=0;
      elseif time >20044800 + 24*3600*23 and time <=20044800 + 24*3600*30 then
        y[1] = 1;
      elseif time >20044800 + 24*3600*30 then
        y[1] = 0;
      else
        y[1] = 0;
      end if;
      y[2]=0;
      y[3]=0;
    elseif Exp==1 and BuildCase==1 then
      y[1]=1;
      y[2]=0;
      y[3]=0;
    else
      y[1]=0;
      y[3]=0;
      y[2]=1;
    end if;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end controlBlind;
end Shadings;
