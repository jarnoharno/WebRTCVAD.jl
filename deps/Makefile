LIBVAD = libvad.so
OUT = obj

COMMON_AUDIO = webrtc/common_audio
RSMDIR = $(COMMON_AUDIO)/resampler
DSPDIR = $(COMMON_AUDIO)/signal_processing
SWRDIR = webrtc/system_wrappers/source
VADDIR = $(COMMON_AUDIO)/vad

RSMOBJ = \
push_resampler.o \
push_sinc_resampler.o \
resampler.o \
sinc_resampler.o \
sinc_resampler_sse.o

DSPOBJ = \
auto_corr_to_refl_coef.o \
auto_correlation.o \
complex_fft.o \
complex_bit_reverse.o \
copy_set_operations.o \
cross_correlation.o \
division_operations.o \
dot_product_with_scale.o \
downsample_fast.o \
energy.o \
filter_ar.o \
filter_ar_fast_q12.o \
filter_ma_fast_q12.o \
get_hanning_window.o \
get_scaling_square.o \
ilbc_specific_functions.o \
levinson_durbin.o \
lpc_to_refl_coef.o \
min_max_operations.o \
randomization_functions.o \
refl_coef_to_lpc.o \
real_fft.o \
resample.o \
resample_48khz.o \
resample_by_2.o \
resample_by_2_internal.o \
resample_fractional.o \
spl_init.o \
spl_sqrt.o \
spl_sqrt_floor.o \
spl_version.o \
splitting_filter.o \
sqrt_of_one_minus_x_squared.o \
vector_scaling_operations.o

VADOBJ = \
webrtc_vad.o \
vad_core.o \
vad_filterbank.o \
vad_gmm.o \
vad_sp.o

SWROBJ = \
aligned_malloc.o \
cpu_features.o

LIBVADOBJ = libvad.o

RSMOUT = $(addprefix $(OUT)/,$(RSMOBJ))
DSPOUT = $(addprefix $(OUT)/,$(DSPOBJ))
VADOUT = $(addprefix $(OUT)/,$(VADOBJ))
SWROUT = $(addprefix $(OUT)/,$(SWROBJ))
LIBVADOUT = $(addprefix $(OUT)/,$(LIBVADOBJ))

$(LIBVAD): $(RSMOUT) $(DSPOUT) $(VADOUT) $(SWROUT) $(LIBVADOUT)
	gcc -pthread -shared -o $@ $^

OFLAGS = -c -O2 -fpic -DWEBRTC_POSIX -I.

$(RSMOUT): $(OUT)/%.o: $(RSMDIR)/%.cc | $(OUT)
	g++ $(OFLAGS) -o $@ $<
$(SWROUT): $(OUT)/%.o: $(SWRDIR)/%.cc | $(OUT)
	g++ $(OFLAGS) -o $@ $<
$(DSPOUT): $(OUT)/%.o: $(DSPDIR)/%.c | $(OUT)
	gcc $(OFLAGS) -o $@ $<
$(VADOUT): $(OUT)/%.o: $(VADDIR)/%.c | $(OUT)
	gcc $(OFLAGS) -o $@ $<
$(LIBVADOUT): $(OUT)/%.o: %.cc | $(OUT)
	g++ $(OFLAGS) -o $@ $<

$(OUT):
	mkdir $@

.PHONY: clean clean-out
clean: clean-out
	rm -f $(LIBVAD)

clean-out:
	rm -rf $(OUT)
