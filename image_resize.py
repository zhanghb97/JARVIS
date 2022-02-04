import argparse
import pyheif
from PIL import Image
import os

def resize_image(infile, width, height, outfile='./resize.png'):
  """Resize Image
  :param infile: Source file
  :param outfile: Path of the result image
  :param width: Width of the result image
  :param height: Height of the result image
  """
  print("Processing...")
  img = open_image(infile)
  out = img.resize((width, height), Image.ANTIALIAS)
  out.save(outfile)
  print("Successful!")
        
def open_image(infile):
  """Open Image
  :param infile: Source file
  :return: Image
  """
  if args.verbosity:
    print("Opening the image...")
  try:
    if args.verbosity:
      print("Try PIL...")
    return Image.open(infile)
  except OSError:
    if args.verbosity:
      print("Try pyheif...")
    heif_file = pyheif.read(infile)
    return Image.frombytes(heif_file.mode, heif_file.size, heif_file.data,
                           "raw", heif_file.mode, heif_file.stride)

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument("input", help="Specify the input file")
  parser.add_argument("-o", help="Specify the output file")
  parser.add_argument("--width", type=int, help="Specify the width of the result image")
  parser.add_argument("--height", type=int, help="Specify the height of the result image")
  parser.add_argument("-v", "--verbosity", help="increase output verbosity",
                      action="store_true")
  args = parser.parse_args()
  if args.verbosity:
    print("verbosity turned on")
  if not (args.width and args.height):
    if args.width:
      raise ValueError("lack of width parameter")
    else:
      raise ValueError("lack of height parameter")
  if args.o:
    resize_image(args.input, args.width, args.height, args.o)
  else:
    resize_image(args.input, args.width, args.height)
