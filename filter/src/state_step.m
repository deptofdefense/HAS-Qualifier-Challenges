function [state] = state_step(state, Ts)
  state.q_att  = unit( exp(Ts/2 * state.q_rate ) * state.q_att );
  state.time  += Ts;
endfunction