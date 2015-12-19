 
from numpy import zeros
from numpy import log10
from numpy import array

def to_dB(value):
    h_dB = 20*log10(abs(value))
    return h_dB
 
def mean_list_lists(list_lists):
    count_lists = len(list_lists)
    result = zeros(len(list_lists[0]))
    for list_values in list_lists:
        result += list_values
    summary = [] 
    for value in result:
        summary.append(value/count_lists)
    return array(summary)

def find_first_zero_idx(in_array):
    cut_position = 0
    for i in range(len(in_array)-1):
        cut_position += 1
        if in_array[i]*in_array[i+1] < 0:
            break
    return cut_position