function send_ns_trigger(trigger_val, port_handle)
% Sends a trigger to the Neurospec trigger box. A port_handle is
% established with open_ns_port.
% trigger_val: value to send. Default is 1.

if nargin == 0
    trigger_val = 1;
end

fwrite(port_handle, trigger_val) % int8
fwrite(port_handle, 0)           % close trigger