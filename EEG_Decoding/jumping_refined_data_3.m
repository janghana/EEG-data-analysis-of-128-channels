%%
clock_wise_data_zero_3 = [];
anti_clock_wise_data_zero_3 = [];

clock_wise_data_low_3 = [];
anti_clock_wise_data_low_3 = [];

clock_wise_data_high_3 = [];
anti_clock_wise_data_high_3 = [];

for i = 1:180
    if expT.obj_vel(i) == -40
        if expT.pat_vel(i) == 0
            clock_wise_data_zero_3 = [clock_wise_data_zero_3; expT.response(i)];
        end
    end
    if expT.obj_vel(i) == 40
        if expT.pat_vel(i) == 0
            anti_clock_wise_data_zero_3 = [anti_clock_wise_data_zero_3; expT.response(i)];
        end
    end
    
    if expT.obj_vel(i) == -40
        if expT.pat_vel(i) == 1.9
            clock_wise_data_low_3 = [clock_wise_data_low_3; expT.response(i)];
        end
    end
    if expT.obj_vel(i) == 40
        if expT.pat_vel(i) == 1.9
            anti_clock_wise_data_low_3 = [anti_clock_wise_data_low_3; expT.response(i)];
        end
    end
    
    if expT.obj_vel(i) == -40
        if expT.pat_vel(i) == 3.5
            clock_wise_data_high_3 = [clock_wise_data_high_3; expT.response(i)];
        end
    end
    if expT.obj_vel(i) == 40
        if expT.pat_vel(i) == 3.5
            anti_clock_wise_data_high_3 = [anti_clock_wise_data_high_3; expT.response(i)];
        end
    end
end
%% clock, anti-clock
clock_total_data_3 = []
anti_clock_total_data_3 = []

clock_total_data_3 = [clock_total_data_3;[0, mean(clock_wise_data_zero_3), length(clock_wise_data_zero_3)]];
clock_total_data_3 = [clock_total_data_3;[1.9, mean(clock_wise_data_low_3), length(clock_wise_data_low_3)]];
clock_total_data_3 = [clock_total_data_3;[3.5, mean(clock_wise_data_high_3), length(clock_wise_data_high_3)]];

anti_clock_total_data_3 = [anti_clock_total_data_3;[0, mean(anti_clock_wise_data_zero_3), length(anti_clock_wise_data_zero_3)]];
anti_clock_total_data_3 = [anti_clock_total_data_3;[1.9, mean(anti_clock_wise_data_low_3), length(anti_clock_wise_data_low_3)]];
anti_clock_total_data_3 = [anti_clock_total_data_3;[3.5, mean(anti_clock_wise_data_high_3), length(anti_clock_wise_data_high_3)]];

%% combined
total_data_zero = [clock_wise_data_zero_3; anti_clock_wise_data_zero_3];
total_data_low = [clock_wise_data_low_3; anti_clock_wise_data_low_3];
total_data_high = [clock_wise_data_high_3; anti_clock_wise_data_high_3];

total_data_3 = [];

total_data_3 = [total_data_3;[0, mean(total_data_zero), length(total_data_zero)]];
total_data_3 = [total_data_3;[1.9, mean(total_data_low), length(total_data_low)]];
total_data_3 = [total_data_3;[3.5, mean(total_data_high), length(total_data_high)]];



