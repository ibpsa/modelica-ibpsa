within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.GenericStepParam;
record example_accurate
  extends Records.GenericStepParam(
    name="example_accurate",
    tStep=8640,
    t_min_d=1,
    tBre_d=100,
    q_ste=21.99,
    m_flow=0.3,
    T_ini=283.15);
  //q_ste = 2*pi*k_s with k_s = 3.5 W/m-K
end example_accurate;
