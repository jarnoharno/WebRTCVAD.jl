module WebRTCVAD

export sinc_resample

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

end # module
