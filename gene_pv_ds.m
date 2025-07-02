f0 = 75;  % Fundamental frequency (Hz)
fs = 48000;  % Sampling frequency (Hz)
t = 0:1/fs:1/f0;  % Time vector
step = 0.2;  % Step size for numerical evaluation

% Precompute constants to save computation time
xct1 = 2 * pi * f0 * t;
xct2 = 2 * pi * 2 * f0 * t;
xct3 = 2 * pi * 3 * f0 * t;
xct4 = 2 * pi * 4 * f0 * t;
vc1 = (2 * pi * f0) ^ -1;
vc2 = (2 * pi * 2 * f0) ^ -1;
vc3 = (2 * pi * 3 * f0) ^ -1;

vc4 = (2 * pi * 4 * f0) ^ -1;

% Initialize storage for velocity difference and encoded values
pv_ds = zeros(42467328, 2);

i = 0;  % Index counter
for p1 = 0
    for p2 = -pi:step:pi  % Phase phi2 from -π to π
        for p3 = -pi:step:pi  % Phase phi3 from -π to π
            for p4 = -pi:step:pi  % Phase phi4 from -π to π
                for k1 = 0:step:1  % Amplitude A1 from 0 to 1
                    for k2 = 0:step:1  % Amplitude A2 from 0 to 1
                        for k3 = 0:step:1  % Amplitude A3 from 0 to 1
                            for k4 = 0:step:1  % Amplitude A4 from 0 to 1
                                i = i + 1;
                                
                                % Compute velocity
                                v = vc1 * k1 * sin(xct1) + ...
                                    vc2 * k2 * sin(xct2 + p2) + ...
                                    vc3 * k3 * sin(xct3 + p3) + ...
                                    vc4 * k4 * sin(xct4 + p4);
                                
                                % Compute velocity difference
                                diffv = abs(max(v)) - abs(min(v));
                                
                                % Store velocity difference and encoded values
                                pv_ds(i, 1) = diffv;
                                pv_ds(i, 2) = myencode([k1, k2, k3, k4, p1, p2, p3, p4]);
                            end
                        end
                    end
                end
            end
        end
    end
end

% Save results to file
pv_ds = sortrows(pv_ds,1);
save("pv_ds.mat", "pv_ds");




