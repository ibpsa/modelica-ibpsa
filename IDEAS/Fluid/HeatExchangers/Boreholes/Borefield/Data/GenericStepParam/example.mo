within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.GenericStepParam;
record example
  extends Records.GenericStepParam(
    name="example",
    tStep=86400,
    t_min_d=1,
    tBre_d=10,
    q_ste=21.99,
    m_flow=0.3,
    T_ini=283.15);
  //q_ste = 2*pi*k_s with k_s = 3.5 W/m-K
end example;
