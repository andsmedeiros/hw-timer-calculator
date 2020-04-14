# hw-timer-calculator

Given a source frequency, a target frequency, the width of the timer's counter, the available divisors and the maximum accptable error, lists which combinations of divisors and counter values can produce the target frequency.
Frequencies must be supplied in Hz, but can be suffixed with K or M to represend KHz or MHz (*e.g.*: 10M or 15K).

```
Usage: timer-calculator <options>
    -s, --source-frequency=FS        Timer source clock frenquency
    -t, --target-frequency=FT        Target timer frequency
    -b, --bits=BITS                  Timer width, in bits (default=16)
    -dDIV1,DIV2,...,DIVN,            Available divisors to source clock (default=1.0,2.0,4.0,8.0,16.0,32.0,64.0,128.0,256.0)
        --divisors
    -m, --max-error=MAX_ERROR        The percentual max error of the output frequency (default=5%)
```
