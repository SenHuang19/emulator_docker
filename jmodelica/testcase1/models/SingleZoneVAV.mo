within ;
package SingleZoneVAV
  "This package contains models for the SingleZoneVAV testcase in BOPTEST."
  model TestCaseSupervisory
    "Based on Buildings.Air.Systems.SingleZone.VAV.Examples.ChillerDXHeatingEconomizer."

    package MediumA = Buildings.Media.Air "Buildings library air media package";
    package MediumW = Buildings.Media.Water "Buildings library air media package";

    parameter Modelica.SIunits.Temperature TSupChi_nominal=279.15
      "Design value for chiller leaving water temperature";

    ChillerDXHeatingEconomizerController_ove                                  con(
      minOAFra=0.2,
      kFan=4,
      kEco=4,
      kHea=4,
      TSupChi_nominal=TSupChi_nominal,
      TSetSupAir=286.15) "Controller"
      annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
    Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
      redeclare package MediumA = MediumA,
      redeclare package MediumW = MediumW,
      mAir_flow_nominal=0.75,
      etaHea_nominal=0.99,
      QHea_flow_nominal=7000,
      QCoo_flow_nominal=-7000,
      TSupChi_nominal=TSupChi_nominal)   "Single zone VAV system"
      annotation (Placement(transformation(extent={{-40,-20},{0,20}})));
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.Room zon(
        mAir_flow_nominal=0.75,
        lat=weaDat.lat) "Thermal envelope of single zone"
      annotation (Placement(transformation(extent={{40,-20},{80,20}})));
    Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
        computeWetBulbTemperature=false, filNam=
          Modelica.Utilities.Files.loadResource(
          "Resources/weatherdata/DRYCOLD.mos"))
      annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
    Modelica.Blocks.Continuous.Integrator EFan "Total fan energy"
      annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
    Modelica.Blocks.Continuous.Integrator EHea "Total heating energy"
      annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
    Modelica.Blocks.Continuous.Integrator ECoo "Total cooling energy"
      annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
    Modelica.Blocks.Math.MultiSum EHVAC(nu=4)  "Total HVAC energy"
      annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
    Modelica.Blocks.Continuous.Integrator EPum "Total pump energy"
      annotation (Placement(transformation(extent={{40,-140},{60,-120}})));

    Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
      annotation (Placement(transformation(extent={{-118,120},{-98,140}})));

    Modelica.Blocks.Sources.CombiTimeTable TSetRooHea(
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      table=[0,20 + 273.15; 8*3600,20 + 273.15; 18*3600,20 + 273.15; 24*3600,20
           + 273.15]) "Heating setpoint for room temperature"
      annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
    Modelica.Blocks.Sources.CombiTimeTable TSetRooCoo(
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      table=[0,25 + 273.15; 8*3600,25 + 273.15; 18*3600,25 + 273.15; 24*3600,25
           + 273.15]) "Cooling setpoint for room temperature"
      annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
    IBPSA.Utilities.IO.SignalExchange.Overwrite
                             oveTSetRooHea
      annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
    IBPSA.Utilities.IO.SignalExchange.Overwrite
                             oveTSetRooCoo
      annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
    IBPSA.Utilities.IO.SignalExchange.Read
                        PPum
      annotation (Placement(transformation(extent={{120,70},{140,90}})));
    IBPSA.Utilities.IO.SignalExchange.Read
                        PCoo
      annotation (Placement(transformation(extent={{140,90},{160,110}})));
    IBPSA.Utilities.IO.SignalExchange.Read
                        PHea
      annotation (Placement(transformation(extent={{120,110},{140,130}})));
    IBPSA.Utilities.IO.SignalExchange.Read
                        PFan
      annotation (Placement(transformation(extent={{140,130},{160,150}})));
    IBPSA.Utilities.IO.SignalExchange.Read
                        TRooAir
      annotation (Placement(transformation(extent={{120,-10},{140,10}})));
    IBPSA.Utilities.IO.SignalExchange.Read
                        ETotFan
      annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
    IBPSA.Utilities.IO.SignalExchange.Read
                        ETotHVAC
      annotation (Placement(transformation(extent={{140,-70},{160,-50}})));
    IBPSA.Utilities.IO.SignalExchange.Read
                        ETotHea
      annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
    IBPSA.Utilities.IO.SignalExchange.Read
                        ETotCoo
      annotation (Placement(transformation(extent={{140,-110},{160,-90}})));
    IBPSA.Utilities.IO.SignalExchange.Read
                        ETotPum
      annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
    IBPSA.Utilities.IO.SignalExchange.Read TSupAir
      annotation (Placement(transformation(extent={{120,42},{140,62}})));
    IBPSA.Utilities.IO.SignalExchange.Read TMixAir
      annotation (Placement(transformation(extent={{120,16},{140,36}})));
    IBPSA.Utilities.IO.SignalExchange.Overwrite oveFanSpeRat
      annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
    IBPSA.Utilities.IO.SignalExchange.Overwrite oveHeaOut
      annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
    IBPSA.Utilities.IO.SignalExchange.Overwrite oveOutAirFra
      annotation (Placement(transformation(extent={{-80,44},{-60,64}})));
    IBPSA.Utilities.IO.SignalExchange.Overwrite oveCooOut
      annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  equation
    connect(weaDat.weaBus, weaBus) annotation (Line(
        points={{-140,130},{-108,130}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));

    connect(hvac.chiOn, con.chiOn) annotation (Line(points={{-42,-10},{-60,-10},{
            -60,-4},{-79,-4}},                                color={255,0,255}));
    connect(con.TSetSupChi, hvac.TSetChi) annotation (Line(points={{-79,-8},{-70,
            -8},{-70,-15},{-42,-15}},           color={0,0,127}));
    connect(con.TMix, hvac.TMixAir) annotation (Line(points={{-102,2},{-112,2},{
            -112,-40},{10,-40},{10,-4},{1,-4}},             color={0,0,127}));

    connect(hvac.supplyAir, zon.supplyAir) annotation (Line(points={{0,8},{10,8},
            {10,2},{40,2}},          color={0,127,255}));
    connect(hvac.returnAir, zon.returnAir) annotation (Line(points={{0,0},{6,0},
            {6,-2},{40,-2}},         color={0,127,255}));

    connect(con.TOut, weaBus.TDryBul) annotation (Line(points={{-102,-2},{-108,
            -2},{-108,130}},              color={0,0,127}));
    connect(hvac.weaBus, weaBus) annotation (Line(
        points={{-36,17.8},{-36,130},{-108,130}},
        color={255,204,51},
        thickness=0.5));
    connect(zon.weaBus, weaBus) annotation (Line(
        points={{46,18},{42,18},{42,130},{-108,130}},
        color={255,204,51},
        thickness=0.5));
    connect(con.TSup, hvac.TSup) annotation (Line(points={{-102,-9},{-108,-9},{
            -108,-32},{4,-32},{4,-7},{1,-7}},
          color={0,0,127}));
    connect(con.TRoo, zon.TRooAir) annotation (Line(points={{-102,-6},{-110,-6},
            {-110,-36},{6,-36},{6,-22},{90,-22},{90,0},{81,0}},     color={0,0,
            127}));

    connect(hvac.PFan, EFan.u) annotation (Line(points={{1,18},{24,18},{24,-40},{
            38,-40}},  color={0,0,127}));
    connect(hvac.QHea_flow, EHea.u) annotation (Line(points={{1,16},{22,16},{22,
            -70},{38,-70}},
                       color={0,0,127}));
    connect(hvac.PCoo, ECoo.u) annotation (Line(points={{1,14},{20,14},{20,-100},
            {38,-100}},color={0,0,127}));
    connect(hvac.PPum, EPum.u) annotation (Line(points={{1,12},{18,12},{18,-130},{
            38,-130}},   color={0,0,127}));

    connect(EFan.y, EHVAC.u[1]) annotation (Line(points={{61,-40},{70,-40},{70,-54.75},
            {80,-54.75}},         color={0,0,127}));
    connect(EHea.y, EHVAC.u[2])
      annotation (Line(points={{61,-70},{64,-70},{64,-60},{66,-60},{66,-60},{80,-60},
            {80,-58.25}},                                      color={0,0,127}));
    connect(ECoo.y, EHVAC.u[3]) annotation (Line(points={{61,-100},{70,-100},{70,-61.75},
            {80,-61.75}},         color={0,0,127}));
    connect(EPum.y, EHVAC.u[4]) annotation (Line(points={{61,-130},{74,-130},{74,-65.25},
            {80,-65.25}},         color={0,0,127}));
    connect(TSetRooHea.y[1], oveTSetRooHea.u)
      annotation (Line(points={{-159,30},{-142,30}}, color={0,0,127}));
    connect(oveTSetRooHea.y, con.TSetRooHea) annotation (Line(points={{-119,30},
            {-116,30},{-116,10},{-102,10}}, color={0,0,127}));
    connect(TSetRooCoo.y[1], oveTSetRooCoo.u)
      annotation (Line(points={{-159,-10},{-142,-10}}, color={0,0,127}));
    connect(oveTSetRooCoo.y, con.TSetRooCoo) annotation (Line(points={{-119,-10},
            {-116,-10},{-116,6},{-102,6}}, color={0,0,127}));
    connect(hvac.PPum, PPum.u) annotation (Line(points={{1,12},{18,12},{18,80},
            {118,80}}, color={0,0,127}));
    connect(hvac.PCoo, PCoo.u) annotation (Line(points={{1,14},{14,14},{14,100},
            {138,100}}, color={0,0,127}));
    connect(hvac.QHea_flow, PHea.u) annotation (Line(points={{1,16},{10,16},{10,
            120},{118,120}}, color={0,0,127}));
    connect(hvac.PFan, PFan.u) annotation (Line(points={{1,18},{6,18},{6,140},{
            138,140}}, color={0,0,127}));
    connect(zon.TRooAir, TRooAir.u)
      annotation (Line(points={{81,0},{118,0}}, color={0,0,127}));
    connect(EFan.y, ETotFan.u)
      annotation (Line(points={{61,-40},{118,-40}}, color={0,0,127}));
    connect(ETotHVAC.u, EHVAC.y)
      annotation (Line(points={{138,-60},{101.7,-60}}, color={0,0,127}));
    connect(EHea.y, ETotHea.u) annotation (Line(points={{61,-70},{64,-70},{64,
            -80},{118,-80}}, color={0,0,127}));
    connect(ECoo.y, ETotCoo.u)
      annotation (Line(points={{61,-100},{138,-100}}, color={0,0,127}));
    connect(EPum.y, ETotPum.u) annotation (Line(points={{61,-130},{90,-130},{90,
            -120},{118,-120}}, color={0,0,127}));
    connect(TSupAir.u, hvac.TSup) annotation (Line(points={{118,52},{34,52},{34,
            -7},{1,-7}}, color={0,0,127}));
    connect(TMixAir.u, hvac.TMixAir) annotation (Line(points={{118,26},{40,26},
            {40,-4},{1,-4}}, color={0,0,127}));
    connect(con.yFan, oveFanSpeRat.u) annotation (Line(points={{-79,9},{-74,9},
            {-74,38},{-100,38},{-100,110},{-82,110}}, color={0,0,127}));
    connect(oveFanSpeRat.y, hvac.uFan) annotation (Line(points={{-59,110},{-30,
            110},{-30,124},{-2,124},{-2,94},{-48,94},{-48,18},{-42,18}}, color=
            {0,0,127}));
    connect(oveHeaOut.u, con.yHea) annotation (Line(points={{-82,82},{-96,82},{
            -96,40},{-70,40},{-70,6},{-79,6}}, color={0,0,127}));
    connect(oveHeaOut.y, hvac.uHea) annotation (Line(points={{-59,82},{-52,82},
            {-52,12},{-42,12}}, color={0,0,127}));
    connect(oveOutAirFra.u, con.yOutAirFra) annotation (Line(points={{-82,54},{
            -92,54},{-92,42},{-68,42},{-68,3},{-79,3}}, color={0,0,127}));
    connect(oveOutAirFra.y, hvac.uEco) annotation (Line(points={{-59,54},{-58,
            54},{-58,-2},{-42,-2}}, color={0,0,127}));
    connect(con.yCooCoiVal, oveCooOut.u) annotation (Line(points={{-79,0},{-76,
            0},{-76,-48},{-90,-48},{-90,-70},{-82,-70}}, color={0,0,127}));
    connect(oveCooOut.y, hvac.uCooVal) annotation (Line(points={{-59,-70},{-52,
            -70},{-52,5},{-42,5}}, color={0,0,127}));
    annotation (
      experiment(
        StopTime=504800,
        Interval=3600,
        Tolerance=1e-06),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/ChillerDXHeatingEconomizer.mos"
          "Simulate and plot"),
       Documentation(info="<html>
<p>
The thermal zone is based on the BESTEST Case 600 envelope, while the HVAC
system is based on a conventional VAV system with air cooled chiller and
economizer.  See documentation for the specific models for more information.
</p>
</html>",   revisions="<html>
<ul>
<li>
September 14, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
      Diagram(coordinateSystem(extent={{-160,-160},{120,140}})),
      Icon(coordinateSystem(extent={{-160,-160},{120,140}}), graphics={
          Rectangle(
            extent={{-160,140},{120,-160}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
          Ellipse(lineColor = {75,138,73},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent={{-116,-110},{84,90}}),
          Polygon(lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points={{-52,50},{48,-10},{-52,-70},{-52,50}})}));
  end TestCaseSupervisory;

  model ChillerDXHeatingEconomizerController_ove
    "Controller for single zone VAV system"
    extends Modelica.Blocks.Icons.Block;

    parameter Modelica.SIunits.Temperature TSupChi_nominal
      "Design value for chiller leaving water temperature";
    parameter Real minAirFlo(
      min=0,
      max=1,
      unit="1") = 0.2
      "Minimum airflow rate of system"
      annotation(Dialog(group="Air design"));

    parameter Modelica.SIunits.DimensionlessRatio minOAFra "Minimum outdoor air fraction of system"
      annotation(Dialog(group="Air design"));

    parameter Modelica.SIunits.Temperature TSetSupAir "Cooling supply air temperature setpoint"
      annotation(Dialog(group="Air design"));

    parameter Real kHea(min=Modelica.Constants.small) = 2
      "Gain of heating controller"
      annotation(Dialog(group="Control gain"));

    parameter Real kCoo(min=Modelica.Constants.small)=1
      "Gain of controller for cooling valve"
      annotation(Dialog(group="Control gain"));

    parameter Real kFan(min=Modelica.Constants.small) = 0.5
      "Gain of controller for fan"
      annotation(Dialog(group="Control gain"));

    parameter Real kEco(min=Modelica.Constants.small) = 4
      "Gain of controller for economizer"
      annotation(Dialog(group="Control gain"));

    Modelica.Blocks.Interfaces.RealInput TRoo(
      final unit="K",
      displayUnit="degC") "Zone temperature measurement"
    annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          origin={-120,-60})));

    Modelica.Blocks.Interfaces.RealInput TSetRooCoo(
      final unit="K",
      displayUnit="degC")
      "Zone cooling setpoint temperature" annotation (Placement(transformation(
          extent={{20,-20},{-20,20}},
          rotation=180,
          origin={-120,60})));
    Modelica.Blocks.Interfaces.RealInput TSetRooHea(
      final unit="K",
      displayUnit="degC")
      "Zone heating setpoint temperature" annotation (Placement(transformation(
          extent={{20,-20},{-20,20}},
          rotation=180,
          origin={-120,100})));

    Modelica.Blocks.Interfaces.RealInput TMix(
      final unit="K",
      displayUnit="degC")
      "Measured mixed air temperature"
      annotation (Placement(transformation(extent={{-140,0},{-100,40}})));

    Modelica.Blocks.Interfaces.RealInput TSup(
      final unit="K",
      displayUnit="degC")
      "Measured supply air temperature after the cooling coil"
      annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));

    Modelica.Blocks.Interfaces.RealInput TOut(
      final unit="K",
      displayUnit="degC") "Measured outside air temperature"
      annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));

    Modelica.Blocks.Interfaces.RealOutput yHea(final unit="1") "Control signal for heating coil"
      annotation (Placement(transformation(extent={{100,50},{120,70}})));

    Modelica.Blocks.Interfaces.RealOutput yFan(final unit="1") "Control signal for fan"
      annotation (Placement(transformation(extent={{100,80},{120,100}})));

    Modelica.Blocks.Interfaces.RealOutput yOutAirFra(final unit="1")
      "Control signal for outside air fraction"
      annotation (Placement(transformation(extent={{100,20},{120,40}})));

    Modelica.Blocks.Interfaces.RealOutput yCooCoiVal(final unit="1")
      "Control signal for cooling coil valve"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));

    Modelica.Blocks.Interfaces.RealOutput TSetSupChi(
      final unit="K",
      displayUnit="degC")
      "Set point for chiller leaving water temperature"
      annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

    Modelica.Blocks.Interfaces.BooleanOutput chiOn "On signal for chiller"
      annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

    Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerHeatingFan conSup(
      minAirFlo=minAirFlo,
      kHea=kHea,
      kFan=kFan) "Heating coil, cooling coil and fan controller"
      annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
    Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerEconomizer conEco(final
        kEco=kEco) "Economizer control"
      annotation (Placement(transformation(extent={{40,30},{60,50}})));

    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysChiPla(uLow=-1, uHigh=0)
      "Hysteresis with delay to switch on cooling"
      annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

    Modelica.Blocks.Math.Feedback errTRooCoo
      "Control error on room temperature for cooling"
      annotation (Placement(transformation(extent={{-42,-70},{-22,-50}})));
    Buildings.Controls.Continuous.LimPID conCooVal(
      controllerType=Modelica.Blocks.Types.SimpleController.P,
      final yMax=1,
      final yMin=0,
      final k=kCoo,
      final reverseAction=true) "Cooling coil valve controller"
      annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

    IBPSA.Utilities.IO.SignalExchange.Overwrite oveTSetSupAir
      annotation (Placement(transformation(extent={{-32,-48},{-12,-28}})));
    IBPSA.Utilities.IO.SignalExchange.Overwrite oveMinOAFra
      annotation (Placement(transformation(extent={{4,50},{24,70}})));
  protected
    Modelica.Blocks.Sources.Constant TSetSupChiConst(
      final k=TSupChi_nominal)
      "Set point for chiller temperature"
      annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

    Modelica.Blocks.Sources.Constant conMinOAFra(
      final k=minOAFra)
      "Minimum outside air fraction"
      annotation (Placement(transformation(extent={{-70,38},{-50,58}})));

    Modelica.Blocks.Sources.Constant TSetSupAirConst(
      final k=TSetSupAir)
      "Set point for supply air temperature"
      annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));

  equation
    connect(TSetSupAirConst.y, conEco.TMixSet) annotation (Line(points={{-49,-20},
            {-20,-20},{-20,48},{39,48}}, color={0,0,127}));
    connect(errTRooCoo.y, hysChiPla.u) annotation (Line(points={{-23,-60},{0,-60},
            {0,-40},{38,-40}},                           color={0,0,127}));
    connect(TSetRooCoo, errTRooCoo.u2) annotation (Line(points={{-120,60},{-80,60},
            {-80,-80},{-32,-80},{-32,-68}}, color={0,0,127}));
    connect(errTRooCoo.u1, TRoo) annotation (Line(points={{-40,-60},{-74,-60},{
            -120,-60}}, color={0,0,127}));
    connect(conSup.TSetRooHea, TSetRooHea) annotation (Line(points={{-41,86},{-88,
            86},{-88,100},{-120,100}},
                                     color={0,0,127}));
    connect(conSup.TSetRooCoo, TSetRooCoo) annotation (Line(points={{-41,80},{-80,
            80},{-80,60},{-120,60}}, color={0,0,127}));
    connect(conSup.TRoo, TRoo) annotation (Line(points={{-41,74},{-74,74},{-74,
            -60},{-120,-60}},
                         color={0,0,127}));
    connect(conSup.yHea, conEco.yHea) annotation (Line(points={{-19,76},{-10,76},
            {-10,32},{39,32}},color={0,0,127}));
    connect(conEco.TMix, TMix) annotation (Line(points={{39,45},{-40,45},{-40,
            20},{-120,20}},
                        color={0,0,127}));
    connect(conEco.TRet, TRoo) annotation (Line(points={{39,42},{-34,42},{-34,
            12},{-88,12},{-88,-60},{-120,-60}}, color={0,0,127}));
    connect(conEco.TOut, TOut) annotation (Line(points={{39,35},{-30,35},{-30,8},
            {-94,8},{-94,-20},{-120,-20}},   color={0,0,127}));
    connect(conSup.yHea, yHea) annotation (Line(points={{-19,76},{40,76},{40,60},
            {80,60},{110,60}},
                      color={0,0,127}));
    connect(conSup.yFan, yFan) annotation (Line(points={{-19,84},{40,84},{40,90},
            {40,90},{40,90},{110,90},{110,90}},
                      color={0,0,127}));
    connect(conEco.yOutAirFra, yOutAirFra) annotation (Line(points={{61,40},{80,
            40},{80,30},{110,30}},
                               color={0,0,127}));
    connect(conCooVal.y, yCooCoiVal)
      annotation (Line(points={{21,-20},{76,-20},{76,0},{110,0}},
                                                color={0,0,127}));
    connect(TSetSupChiConst.y, TSetSupChi)
      annotation (Line(points={{61,-80},{110,-80}}, color={0,0,127}));
    connect(conCooVal.u_m, TSup)
      annotation (Line(points={{10,-32},{10,-90},{-120,-90}}, color={0,0,127}));
    connect(hysChiPla.y, chiOn) annotation (Line(points={{61,-40},{80,-40},{110,
            -40}},           color={255,0,255}));
    connect(oveTSetSupAir.u, conEco.TMixSet) annotation (Line(points={{-34,-38},
            {-42,-38},{-42,-20},{-20,-20},{-20,48},{39,48}}, color={0,0,127}));
    connect(oveTSetSupAir.y, conCooVal.u_s) annotation (Line(points={{-11,-38},
            {-6,-38},{-6,-20},{-2,-20}}, color={0,0,127}));
    connect(conMinOAFra.y, oveMinOAFra.u) annotation (Line(points={{-49,48},{
            -30,48},{-30,60},{2,60}}, color={0,0,127}));
    connect(oveMinOAFra.y, conEco.minOAFra) annotation (Line(points={{25,60},{
            34,60},{34,38},{39,38}}, color={0,0,127}));
    annotation (Icon(graphics={Line(points={{-100,-100},{0,2},{-100,100}}, color=
                {0,0,0})}), Documentation(info="<html>
<p>
This is the controller for the VAV system with economizer, heating coil and cooling coil.
</p>
</html>",   revisions="<html>
<ul>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
  end ChillerDXHeatingEconomizerController_ove;
  annotation (uses(Modelica(version="3.2.2"),
      IBPSA(version="3.0.0"),
      Buildings(version="5.1.0")));
end SingleZoneVAV;
