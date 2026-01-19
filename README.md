# floyd_rose_tuner
DEFAULT_SAMPLE_RATE = 44100;
DEFAULT_BUFFER_SIZE = 2048;
highest_freq = 2kHz
lowest_frequ = 30Hz

sampling_rate =  2x highest_freq = 4kHz =
buffer_size = sampling_rate/lowest_freq = 4kHz/30Hz = 133.33
bitrate = 8*sampling_rate = 8*4kHz = 32kbps
Recorder:
encoding: pcm16bits
bitrate: 128k
samplerate: 44.1k
buffer_size: 2048
channels: 1

AudioStream:
BufferSize: 2048

PitchDetection:
1024

# TODO

5. how to delete a detuning matrix?
8. when manually typing frequency it should use a keyboard with only numbers and dot


## Done

1. Fix bug when pressing on the next button
9. implement the usage of the detuning matrix
# not planned

2. strings that have been measured mark with green color (navigation)
3. add fft to detect frequency when you can know around what frequency the measurement should be
4. the frequency visualization with the slider is distractfull in just the measurement phase
6. when pressing next, it should skip to the next string that havent been measured yer

7. the sensitivity should be set automatically initially
10. optional -  add a page to visualize every data collected ( like a graph with all strings detuning)


