#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#if defined(__APPLE__)
#  define COMMON_DIGEST_FOR_OPENSSL
#  include <CommonCrypto/CommonDigest.h>
#  define SHA1 CC_SHA1
#else
#  include <openssl/md5.h>
#endif

// On Ubuntu, this requires 
//    apt-get install libssl-dev
// and because Dymola compiles in 32 bit mode, it requires
//    apt-get install libssl-dev:i386
// For the distribution, it probably is best to compile this to a
// library

const char *str2md5(const char *str, int length) {
    int n;
    MD5_CTX c;
    unsigned char digest[16];
    char *out = (char*)malloc(33);

    MD5_Init(&c);

    while (length > 0) {
        if (length > 512) {
            MD5_Update(&c, str, 512);
        } else {
            MD5_Update(&c, str, length);
        }
        length -= 512;
        str += 512;
    }

    MD5_Final(digest, &c);

    for (n = 0; n < 16; ++n) {
        snprintf(&(out[n*2]), 16*2, "%02x", (unsigned int)digest[n]);
    }

    return out;
}

//    int main(int argc, char **argv) {
//        const char *output = str2md5("hello", strlen("hello"));
//        printf("%s\n", output);
//        free(output);
//        return 0;
//    }
