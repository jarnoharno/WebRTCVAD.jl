#include "webrtc/common_audio/resampler/include/resampler.h"
#include "webrtc/common_audio/resampler/push_sinc_resampler.h"
#include "webrtc/system_wrappers/interface/scoped_ptr.h"
#include <algorithm>

using namespace webrtc;

extern "C" int sinc_resample(int inFreq, int outFreq,
                             const int16_t* samplesIn, int lengthIn,
                             int16_t* samplesOut)
{
    // 10 ms blocks
    const int input_block_size = inFreq / 100;
    const int output_block_size = outFreq / 100;
    const int blocks = lengthIn / input_block_size;

    // resample with push resampler block by block
    PushSincResampler resampler(input_block_size,output_block_size);
    const int delay = output_block_size -
        resampler.get_resampler_for_testing()->ChunkSize();
    for (int i = 0; i < blocks; ++i) {
        resampler.Resample(samplesIn + input_block_size*i,
                           input_block_size,
                           samplesOut + output_block_size*i,
                           output_block_size);
    }

    // last block
    scoped_array<int16_t> last_block(new int16_t[input_block_size]());
    std::copy(samplesIn+blocks*input_block_size,
              samplesIn+lengthIn,
              last_block.get());
    resampler.Resample(last_block.get(),
                       input_block_size,
                       samplesOut + output_block_size*blocks,
                       output_block_size);
    return delay;
}
