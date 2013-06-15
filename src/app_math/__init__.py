 
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