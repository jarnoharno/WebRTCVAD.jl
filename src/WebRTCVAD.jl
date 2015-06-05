module WebRTCVAD

export sinc_resample, VADInstance, set_mode, valid_rate_and_frame_length,
       process

const libvad = joinpath(dirname(@__FILE__), "..", "deps", "libvad")

function sinc_resample(samples_in::Vector{Int16}, in_freq::Integer,
                       out_freq::Integer)
    input_length = length(samples_in)
    input_block_size = div(in_freq,100)
    output_block_size = div(out_freq,100)
    blocks = div(input_length,input_block_size)

    # pad input with two extra blocks to account for delay and last block
    output = Array(Int16,output_block_size*(blocks+2))
    delay = ccall((:sinc_resample,libvad),
                  Int32,(Int32,Int32,Ptr{Int16},Int32,Ptr{Int16}),
                  in_freq,out_freq,samples_in,input_length,output)

    # trim
    output[1+delay:div(input_length*out_freq,in_freq)+delay]
end

type VADInstance
    ptr::Ptr{Void}

    function VADInstance()
        ref = Array(Ptr{Void},1)
        err = ccall((:WebRtcVad_Create,libvad),Int32,
                    (Ptr{Ptr{Void}},),ref)
        err == 0 || error("unable to create VADInstance")
        self = new(ref[1])
        finalizer(self, free)
        err = ccall((:WebRtcVad_Init,libvad),Int32,
                    (Ptr{Void},),self.ptr)
        err == 0 || error("unable to initialize VADInstance")
        self
    end
end

function free(vad::VADInstance)
    vad.ptr != C_NULL || return
    ccall((:WebRtcVad_Free,libvad),Int32,(Ptr{Void},),vad.ptr)
    vad.ptr = C_NULL
    nothing
end

# set aggressiveness mode (higher -> more speech segments) (0, 1, 2, or 3)
function set_mode(vad::VADInstance, mode::Integer)
    err = ccall((:WebRtcVad_set_mode,libvad),Int32,(Ptr{Void},Int32),
                vad.ptr,mode)
    err == 0 || error("unable to set mode")
end

function valid_rate_and_frame_length(rate::Integer, frame_length::Integer)
    ret = ccall((:WebRtcVad_ValidRateAndFrameLength,libvad),Int32,(Int32,Int32),
                rate, frame_length)
    ret == 0
end

function process(vad::VADInstance,fs::Integer,audio_frame::Vector{Int16})
    ret = ccall((:WebRtcVad_Process,libvad),Int32,
                (Ptr{Void},Int32,Ptr{Int16},Int32),
                vad.ptr,fs,audio_frame,length(audio_frame))
    ret != -1 || error("error processing frame")
    ret == 1
end

function process(audio::Vector{Int16},fs::Integer;
                 mode::Integer=3,frame_length_ms=20)
    frame_length = div(frame_length_ms*fs,1000)
    valid_rate_and_frame_length(fs,frame_length) ||
        error("invalid sample rate/frame length")
    vad = VADInstance()
    set_mode(vad,mode)
    Bool[ process(vad,fs,audio[i*frame_length+1:(i+1)*frame_length])
          for i=0:div(length(audio),frame_length)-1 ]
end

end # module
