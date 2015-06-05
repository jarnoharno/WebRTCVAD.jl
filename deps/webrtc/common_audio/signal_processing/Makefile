OBJ = \
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

CFLAGS += -I../../.. -DWEBRTC_POSIX

libdsp.a: $(OBJ)
	ar rcs $@ $(OBJ)

.PHONY: clean
clean:
	rm -f vad libdsp.a $(OBJ)
