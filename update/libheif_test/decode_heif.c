#include <libheif/heif.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s input_file.heic\n", argv[0]);
        return 1;
    }
    
    const char* input_file = argv[1];
    
    heif_context* ctx = heif_context_alloc();
    heif_context_read_from_file(ctx, input_file, NULL);
    
    heif_image_handle* handle;
    heif_context_get_primary_image_handle(ctx, &handle);
    
    heif_image* image;
    heif_decode_image(handle, &image, heif_colorspace_RGB, heif_chroma_interleaved_RGB, NULL);
    
    // Use the decoded image as needed
    
    heif_image_release(image);
    heif_image_handle_release(handle);
    heif_context_free(ctx);
    
    return 0;
}

