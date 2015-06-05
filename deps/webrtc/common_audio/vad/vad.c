#include <webrtc_vad.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void die(int err, char *msg) {
    fprintf(stderr, "%s\n", msg);
    exit(-1);
}

int main()
{
    int mode = 1; // 0, 1, 2, 3 (aggressiveness)
    int rate = 16000; // Hz
    int frame_length_ms = 30; // ms

    int frame_length = rate * frame_length_ms / 1000;
    size_t frame_size = frame_length * sizeof(int16_t);
    int16_t *audio_frame = malloc(frame_size);
    VadInst *vadInst = 0;
    int err = 0;
    err = WebRtcVad_ValidRateAndFrameLength(rate, frame_length);
    if (err) die(err, "WebRtcVad_ValidRateAndFrameLength");
    err = WebRtcVad_Create(&vadInst);
    if (err) die(err, "WebRtcVad_Create");
    err = WebRtcVad_Init(vadInst);
    if (err) die(err, "WebRtcVad_Init");
    err = WebRtcVad_set_mode(vadInst, mode);
    if (err) die(err, "WebRtcVad_set_mode");

    // process vad
    int vad = WebRtcVad_Process(vadInst, rate, audio_frame, frame_length);
    if (vad < 0) die(err, "WeRtcVad_Process");
    printf("%d\n", vad);

    err = WebRtcVad_Free(vadInst);
    if (err) die(err, "WebRtcVad_Free");
    free(audio_frame);
    return 0;
}
