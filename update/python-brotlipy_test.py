
import brotli

def run_smoke_test():
  try:
    input_data = b"Hello, world!"
    compressed_data = brotli.compress(input_data)
    decompressed_data = brotli.decompress(compressed_data)

    # Check if the decompressed data matches the original input
    if decompressed_data == input_data:
       print("Smoke test passed!")
       return 0
    else:
       print("Smoke test failed: Decompressed data doesn't match input.")
    return 1

  except Exception as e:
      print("Smoke test failed: ", e)
      return 1

if __name__ == "__main__":
  result_code = run_smoke_test()
  exit(result_code)


