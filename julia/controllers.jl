module PID

"""

This module implements a simple P controller.

"""

function compute_control(y::Dict)
    # Compute the control input from the measurement.
   
    # Control parameters
    setpoint = 273.15 + 20
    k_p = 2000

    # compute control
    e = setpoint - y["TRooAir_y"]
    value = max(k_p * e, 0.0)
    u = Dict("oveAct_u" => value,"oveAct_activate" => 1)
    return u
end

function initialize()
    u = Dict("oveAct_u" => 0.0,"oveAct_activate" => 1)
    return u
end

end


module sup

"""

This module implements an external signal to overwrite existing controllers in the emulator.

"""

function compute_control(y::Dict)

    u = Dict("oveTSetRooHea_u" => 20+273.15,"oveTSetRooHea_activate" => 1,"oveTSetRooCoo_u" => 25+273.15,"oveTSetRooCoo_activate" => 1)
    return u
end

function initialize()
    u = Dict("oveTSetRooHea_u" => 20+273.15,"oveTSetRooHea_activate" => 1,"oveTSetRooCoo_u" => 25+273.15,"oveTSetRooCoo_activate" => 1)
    return u
end

end


module vav

"""

This module implements an external signal to overwrite existing controllers in the emulator.

"""

function compute_control(y::Dict)

    u = Dict("oveTSetRooHea_u" => 20+273.15,"oveTSetRooHea_activate" => 1,"oveTSetRooCoo_u" => 25+273.15,"oveTSetRooCoo_activate" => 1,"con_oveTSetSupAir_u"=> 25+273.15,"con_oveTSetSupAir_activate"=> 0,"con_oveMinOAFra_u"=> 0.3,"con_oveMinOAFra_activate"=> 0,"oveCooOut_u"=> 1,"oveCooOut_activate"=> 0,"oveFanSpeRat_u"=> 1,"oveFanSpeRat_activate"=> 0,"oveHeaOut_u"=> 1,"oveHeaOut_activate"=> 0,"oveOutAirFra_u"=> 1,"oveOutAirFra_activate"=> 0)
    return u
end

function initialize()
    u = Dict("oveTSetRooHea_u" => 20+273.15,"oveTSetRooHea_activate" => 1,"oveTSetRooCoo_u" => 25+273.15,"oveTSetRooCoo_activate" => 1,"con_oveTSetSupAir_u"=> 25+273.15,"con_oveTSetSupAir_activate"=> 0,"con_oveMinOAFra_u"=> 0.3,"con_oveMinOAFra_activate"=> 0,"oveCooOut_u"=> 1,"oveCooOut_activate"=> 0,"oveFanSpeRat_u"=> 1,"oveFanSpeRat_activate"=> 0,"oveHeaOut_u"=> 1,"oveHeaOut_activate"=> 0,"oveOutAirFra_u"=> 1,"oveOutAirFra_activate"=> 0)
    return u
end

end
