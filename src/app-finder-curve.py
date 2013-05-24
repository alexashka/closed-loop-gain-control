# coding: utf8
from pylab import plot
from pylab import show
from pylab import grid

# App
from dsp_modules.signal_generator import wrapper_for_finding_2l
from dsp_modules.signal_templates import get_metro_and_axis
from dsp_modules.signal_generator import e
from opimizers import run_approximation


def main():  
    # Поучаем ось
    metro_signal, axis, ideal = get_metro_and_axis()
    T1 = 7
    T2 = 20.0
    v0 = [T1, T2]  # Initial parameter value
    v_result = run_approximation(metro_signal, axis, v0, e)
    
    # Plotting
    x = axis.get_axis()
    plot(x, metro_signal,'b')
    plot(x, wrapper_for_finding_2l(v_result, x),'g')
    grid(); show()

if __name__=="__main__":
    main()
    print 'Done'


