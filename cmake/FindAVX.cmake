# This file is use to check all support level of AVX on your machine
# so that PaddlePaddle can unleash the vectorization power of muticore.

INCLUDE(CheckCXXSourceRuns)

IF(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(MMX_FLAG "-mmmx")
    set(SSE2_FLAG "-msse2")
    set(SSE3_FLAG "-msse3")
    SET(AVX_FLAG "-mavx")
    SET(AVX2_FLAG "-mavx2")
ELSEIF(MSVC)
    set(MMX_FLAG "/arch:MMX")
    set(SSE2_FLAG "/arch:SSE2")
    set(SSE3_FLAG "/arch:SSE3")
    SET(AVX_FLAG "/arch:AVX")
    SET(AVX2_FLAG "/arch:AVX2")
ENDIF()

# Check  MMX
set(CMAKE_REQUIRED_FLAGS ${MMX_FLAG})
CHECK_CXX_SOURCE_RUNS("
#include <mmintrin.h>
int main()
{
    _mm_setzero_si64();
    return 0;
}" MMX_FOUND)

# Check SSE2
set(CMAKE_REQUIRED_FLAGS ${SSE2_FLAG})
CHECK_CXX_SOURCE_RUNS("
#include <emmintrin.h>
int main()
{
    _mm_setzero_si128();
    return 0;
}" SSE2_FOUND)

# Check SSE3
set(CMAKE_REQUIRED_FLAGS ${SSE3_FLAG})
CHECK_CXX_SOURCE_RUNS("
#include <pmmintrin.h>
int main()
{
    __m128d a = _mm_set1_pd(6.28);
    __m128d b = _mm_set1_pd(3.14);
    __m128d result = _mm_addsub_pd(a, b);
    result = _mm_movedup_pd(result);
    return 0;
}" SSE3_FOUND)

# Check AVX
set(CMAKE_REQUIRED_FLAGS ${AVX_FLAG})
CHECK_CXX_SOURCE_RUNS("
#include <immintrin.h>
int main()
{
    __m256 a = _mm256_set_ps (-1.0f, 2.0f, -3.0f, 4.0f, -1.0f, 2.0f, -3.0f, 4.0f);
    __m256 b = _mm256_set_ps (1.0f, 2.0f, 3.0f, 4.0f, 1.0f, 2.0f, 3.0f, 4.0f);
    __m256 result = _mm256_add_ps (a, b);
    return 0;
}" AVX_FOUND)

# Check AVX 2
set(CMAKE_REQUIRED_FLAGS ${AVX2_FLAG})
CHECK_CXX_SOURCE_RUNS("
#include <immintrin.h>
int main()
{
    __m256i a = _mm256_set_epi32 (-1, 2, -3, 4, -1, 2, -3, 4);
    __m256i result = _mm256_abs_epi32 (a);
    return 0;
}" AVX2_FOUND)

mark_as_advanced(MMX_FOUND SSE2_FOUND SSE3_FOUND AVX_FOUND AVX2_FOUND)
