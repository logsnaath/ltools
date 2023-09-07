#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "iniparser.h"

char* trim_whitespace(const char* str) {
    if (str == NULL)
        return NULL;

    char* start = (char*)str;
    char* end = start + strlen(str) - 1;

    while (isspace((unsigned char)*start))
        start++;

    while (end > start && isspace((unsigned char)*end))
        end--;

    *(end + 1) = '\0';

    return start;
}

void test_libiniparser(const char* ini_filename) {
    dictionary* ini;

    // Load the INI file
    ini = iniparser_load(ini_filename);
    if (ini == NULL) {
        fprintf(stderr, "Error loading INI file: %s\n", ini_filename);
        return;
    }

    // Get the number of sections in the INI file
    int num_sections = iniparser_getnsec(ini);
    printf("Number of sections: %d\n", num_sections);

    // Iterate through sections
    int s;
    for (s = 0; s < num_sections; s++) {
        char* section_name = iniparser_getsecname(ini, s);
        printf("Section: %s\n", section_name);

        // Get the number of keys in the current section
        char** keys = iniparser_getseckeys(ini, section_name);
        if (keys == NULL) {
            fprintf(stderr, "Error getting keys for section [%s]\n", section_name);
            continue;
        }

        int num_keys = 0;
        char** key_ptr = keys;
        while (*key_ptr) {
            num_keys++;
            key_ptr++;
        }
        printf("Number of keys in section [%s]: %d\n", section_name, num_keys);

        // Iterate through keys in the current section
        char** key = keys;
        while (*key) {
            const char* original_key_name = *key;
            const char* trimmed_key_name = trim_whitespace(original_key_name);

            if (trimmed_key_name == NULL || strlen(trimmed_key_name) == 0) {
                fprintf(stderr, "Null or empty key name found in section [%s]\n", section_name);
                key++;
                continue;
            }

            const char* value = iniparser_getstring(ini, trimmed_key_name, NULL);
            if (value == NULL) {
                fprintf(stderr, "Error getting value for key [%s] in section [%s]\n", original_key_name, section_name);
            } else {
                printf("Key: %s, Value: %s\n", original_key_name, value);
            }
            key++;
        }

        printf("\n");

        // Free the memory allocated for the keys
        char** key_free = keys;
        while (*key_free) {
            free(*key_free);
            key_free++;
        }
        free(keys);
    }

    // Free the memory allocated by libiniparser
    iniparser_freedict(ini);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <ini_file>\n", argv[0]);
        return 1;
    }

    const char* ini_filename = argv[1];
    test_libiniparser(ini_filename);

    return 0;
}

