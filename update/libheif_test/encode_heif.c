#include <libheif/heif.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
    if (argc != 3) {
        printf("Usage: %s input_image output_file.heic\n", argv[0]);
        return 1;
    }
    
    const char* input_image = argv[1];
    const char* output_file = argv[2];
    
    heif_context* ctx = heif_context_alloc();
    heif_context_write_to_file(ctx, output_file, NULL);
    
    // Set up the image data and parameters for encoding
    
    heif_image* image;
    heif_image_create(&image, ...);
    
    // Encode the image
    
    heif_context_encode_image(ctx, image, HEIF_COMPRESSION_PNG, NULL);
    
    // Save the encoded image to file
    
    heif_image_handle* handle;
    heif_context_get_primary_image_handle(ctx, &handle);
    
    heif_image_handle_encode_image(handle, output_file, NULL);
    
    heif_image_handle_release(handle);
    heif_image_release(image);
    heif_context_free(ctx);
    
    return 0;
}

